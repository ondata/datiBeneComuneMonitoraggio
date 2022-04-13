#!/bin/bash

### requisiti ###
# Miller https://github.com/johnkerl/miller
# scrape-cli https://github.com/aborruso/scrape-cli
# xq https://kislyuk.github.io/yq/
### requisiti ###

set -x

git pull

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$folder"/rawdata
mkdir -p "$folder"/report
mkdir -p "$folder"/processing
mkdir -p "$folder"/../output

rm "$folder"/rawdata/lista.jsonl

nome="SiSMG"

stringaQuery="andamento%20sismg"

URL="http://cerca.ministerosalute.it/search?ulang=it&proxystylesheet=documentiPORT_front-end&access=p&wc=200&ud=1&entqr=3&output=xml_no_dtd&filter=p&q=$stringaQuery&site=pubblicazioniPORT_collection&wc_mc=1&oe=UTF-8&tlen=2048&getfields=*&client=documentiPORT_front-end&ie=UTF-8&entqrm=0&sort=date%3AD%3AS%3Ad1"

# leggi la risposta HTTP del sito
code=$(curl -s -L -o /dev/null -w "%{http_code}" ''"$URL"'')

# se il sito è raggiungibile scarica  i dati
if [ $code -eq 200 ]; then

  # scarica pagina 0
  curl -kL "$URL" >"$folder"/rawdata/start.html
  # leggi quanti risultati sono disponibili
  numeroRisultati=$(scrape <"$folder"/rawdata/start.html -e '//div[@class="portlet-content search-results"]/div[1]/div[2]' | tail -n 1 | grep -oP '(\d+)(?!.*\d)')

  # elimina lista URL da scaricare
  rm "$folder"/rawdata/listaURL

  # scarica in loop elenco URL pagine risultato della query
  START=0
  while [[ "$START" -lt "$numeroRisultati" ]]; do
    curl -kL "http://cerca.ministerosalute.it/search?ulang=it&proxystylesheet=documentiPORT_front-end&access=p&wc=200&ud=1&entqr=3&output=xml_no_dtd&filter=p&q=$stringaQuery&site=pubblicazioniPORT_collection&wc_mc=1&oe=UTF-8&tlen=2048&getfields=*&client=documentiPORT_front-end&ie=UTF-8&entqrm=0&sort=date%3AD%3AS%3Ad1&start=$START" | scrape -be '.results a' | xq -r '.html.body.a[]."@href"' >>"$folder"/rawdata/listaURL
    let START=START+10
  done

  # per ogni pagina estrai elenco URL che contengono PDF
  rm "$folder"/rawdata/lista.jsonl
  rm "$folder"/rawdata/anagraficaPagine.dpkv
  while read p; do
    curl -kL "$p" >"$folder"/rawdata/pagina.html
    # estrai titolo pagina
    titoloPagina=$(scrape <"$folder"/rawdata/pagina.html -e '//title/text()' | tr '(\n|\r|\t)' ' ' | sed -r 's/ +/ /g')
    # se il titolo contiene report
    if [[ "$titoloPagina" =~ "mortalità" ]]; then
      # crea file anagrafica pagine, con url e titolo pagina
      echo -e "titolo=$titoloPagina\turl=$p" | mlr --fs "\t" clean-whitespace >>"$folder"/rawdata/anagraficaPagine.dpkv
      # estrai lista dei tag <a> che hanno come href un file PDF
      scrape <"$folder"/rawdata/pagina.html -be '//div[@class="portlet tab-content"]//a[@href[contains(.,"pdf")]]' | xq -c '.html.body.a | .|= .+ {url:"'"$p"'"}' >>"$folder"/rawdata/lista.jsonl
    fi
  done <"$folder"/rawdata/listaURL

  # crea CSV dell'anagrafica delle pagine
  mlr --ocsv --ifs "\t" cat "$folder"/rawdata/anagraficaPagine.dpkv >"$folder"/processing/anagraficaPagine.csv

  # estrai CSV dei report regionali Epicentro PDF
  mlr --j2c unsparsify \
    then rename -r '(@|#)','' \
    then put -S 'if($href=~"^/"){$hrefFile="http://www.salute.gov.it".$href}else{$hrefFile=$href}' \
    then cut -x -f title,href,tabindex \
    then rename text,titoloFile \
    then filter -S 'tolower($titoloFile)=~"sismg"' \
    then reorder -e -f url "$folder"/rawdata/lista.jsonl >"$folder"/../output/"$nome".csv

  # crea file markdown con lista report regionali Epicento
  mlr --c2m put '$titoloFile="[".$titoloFile."](".gsub($hrefFile," ","%20").")"' then cut -f titoloFile,dataReport then sort -f dataReport "$folder"/../output/"$nome".csv >"$folder"/../output/"$nome".md

  <"$folder"/rawdata/lista.jsonl mlr --json sort -r url -f "#text" >"$folder"/processing/listaFileReport.jsonl
  <"$folder"/rawdata/listaURL sort -r >"$folder"/processing/listaURLReport

  # aggiungi a elenco file PDF, il titolo della pagina da cui sono estratti
  mlr --csv join --ul -j url -f "$folder"/../output/"$nome".csv \
    then unsparsify \
    then sort -f dataReport \
    then reorder -e -f url \
    then rename titolo,titoloPagina then sort -r url "$folder"/processing/anagraficaPagine.csv >"$folder"/rawdata/tmp.csv
  mv "$folder"/rawdata/tmp.csv "$folder"/../output/"$nome".csv
fi
