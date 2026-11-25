#!/bin/bash

### requisiti ###
# Miller https://github.com/johnkerl/miller
# scrape-cli https://github.com/aborruso/scrape-cli
# xq https://kislyuk.github.io/yq/
### requisiti ###

set -exo pipefail

git pull

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$folder"/rawdata
mkdir -p "$folder"/report
mkdir -p "$folder"/processing
mkdir -p "$folder"/../output

nome="monitoraggioSettimanale"

stringaQuery="monitoraggio%20settimanale%20covid-19"

URL="http://cerca.ministerosalute.it/search?ulang=it&proxystylesheet=notiziePORT_front-end&access=p&btnG=Cerca&sort=date%3AD%3AS%3Ad1&wc=200&ud=1&entqr=3&output=xml_no_dtd&filter=p&q=$stringaQuery&wc_mc=1&site=notiziePORT_collection&oe=UTF-8&tlen=2048&getfields=*&client=notiziePORT_front-end&ie=UTF-8&entqrm=0&start=0"

# leggi la risposta HTTP del sito
code=$(curl -s -L -o /dev/null -w "%{http_code}" ''"$URL"'')

# se il sito è raggiungibile scarica  i dati
if [[ "$code" == 200 ]]; then

  # scarica pagina 0
  curl -kL "$URL" >"$folder"/rawdata/start.html
  # leggi quanti risultati sono disponibili
  numeroRisultati=$(scrape <"$folder"/rawdata/start.html -e '//div[@class="portlet-content search-results"]/div[1]/div[2]' | tail -n 1 | grep -oP '(\d+)(?!.*\d)' || true)
  [[ "$numeroRisultati" =~ ^[0-9]+$ ]] && (( numeroRisultati > 0 )) || exit 0

  # inizializza la lista URL da scaricare
  : >"$folder"/rawdata/listaURL

  # scarica in loop elenco URL pagine risultato della query
  START=0
  while [[ "$START" -lt "$numeroRisultati" ]]; do
    curl -kL "http://cerca.ministerosalute.it/search?ulang=it&proxystylesheet=notiziePORT_front-end&access=p&btnG=Cerca&sort=date%3AD%3AS%3Ad1&wc=200&ud=1&entqr=3&output=xml_no_dtd&filter=p&q=$stringaQuery&wc_mc=1&site=notiziePORT_collection&oe=UTF-8&tlen=2048&getfields=*&client=notiziePORT_front-end&ie=UTF-8&entqrm=0&start=$START" | scrape -be '.results a' | xq -r '.html.body.a | if type == "array" then .[] else . end | objects | ."@href" | strings' >>"$folder"/rawdata/listaURL
    let START=START+10
  done

  # per ogni pagina estrai elenco URL che contengono PDF
  : >"$folder"/rawdata/lista.jsonl
  : >"$folder"/rawdata/anagraficaPagine.dpkv
  while read p; do
    curl -kL "$p" >"$folder"/rawdata/pagina.html
    # estrai titolo pagina
    titoloPagina=$(scrape <"$folder"/rawdata/pagina.html -e '//title/text()' | tr '(\n|\r|\t)' ' ' | sed -r 's/ +/ /g')
    # se il titolo contiene report
    if [[ "$titoloPagina" =~ "report" ]]; then
      # crea file anagrafica pagine, con url e titolo pagina
      echo -e "titolo=$titoloPagina\turl=$p" | mlr --fs "\t" clean-whitespace >>"$folder"/rawdata/anagraficaPagine.dpkv
      # estrai lista dei tag <a> che hanno come href un file PDF
      scrape <"$folder"/rawdata/pagina.html -be '//div[@class="portlet tab-content"]//a[@href[contains(.,"pdf")]]' | xq -c --arg url "$p" '.html.body.a | if type == "array" then .[] else . end | objects | . + {url: $url}' >>"$folder"/rawdata/lista.jsonl
    fi
  done <"$folder"/rawdata/listaURL
  [[ -s "$folder"/rawdata/lista.jsonl ]] || exit 0

  # crea CSV dell'anagrafica delle pagine
  mlr --ocsv --ifs "\t" cat "$folder"/rawdata/anagraficaPagine.dpkv >"$folder"/processing/anagraficaPagine.csv

  # estrai CSV dei report regionali Epicentro PDF
  mlr --j2c unsparsify \
    then rename -r '(@|#)','' \
    then filter -S 'tolower($href)=~"epi.+[0-9]{6}"' \
    then put -S '$dataReport=regextract_or_else($href,"[0-9]{8}","")' \
    then cut -x -f onclick \
    then put -S 'if($href=~"^/"){$hrefFile="http://www.salute.gov.it".$href}else{$hrefFile=$href}' \
    then filter -x -S '(tolower($href)=~"grafico") || (tolower($title)=~"grafico")' \
    then cut -x -f title,href \
    then rename text,titoloFile \
    then reorder -e -f url "$folder"/rawdata/lista.jsonl >"$folder"/rawdata/report_estratti.csv
  [[ -s "$folder"/rawdata/report_estratti.csv ]] || exit 0

  <"$folder"/rawdata/lista.jsonl mlr --json sort -r url -f "#text" >"$folder"/processing/listaFileReport.jsonl
  <"$folder"/rawdata/listaURL sort -r >"$folder"/processing/listaURLReport

  # aggiungi a elenco file PDF, il titolo della pagina da cui sono estratti
  mlr --csv join --ul -j url -f "$folder"/rawdata/report_estratti.csv \
    then unsparsify \
    then sort -f dataReport \
    then rename titolo,titoloPagina \
    then cut -o -f titoloFile,dataReport,hrefFile,titoloPagina,url "$folder"/processing/anagraficaPagine.csv >"$folder"/rawdata/report_nuovi.csv

  archivio="$folder/../output/$nome.csv"
  python3 "$folder/append_reports.py" "$archivio" "$folder/rawdata/report_nuovi.csv"

  # genera il Markdown dall'intero archivio, non soltanto dall'ultima estrazione
  if [[ -s "$archivio" ]]; then
    mlr --c2m put '$titoloFile="[".$titoloFile."](".gsub($hrefFile," ","%20").")"' then cut -f titoloFile,dataReport then sort -f dataReport "$archivio" >"$folder/rawdata/$nome.md"
    mv "$folder/rawdata/$nome.md" "$folder/../output/$nome.md"
  fi
fi
