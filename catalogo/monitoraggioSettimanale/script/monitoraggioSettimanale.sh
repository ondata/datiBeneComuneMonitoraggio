#!/bin/bash

### requisiti ###
# Miller https://github.com/johnkerl/miller
# scrape-cli https://github.com/aborruso/scrape-cli
# xq https://kislyuk.github.io/yq/
### requisiti ###

set -x

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$folder"/rawdata
mkdir -p "$folder"/report
mkdir -p "$folder"/processing
mkdir -p "$folder"/../output

rm "$folder"/rawdata/lista.jsonl

nome="monitoraggioSettimanale"

stringaQuery="monitoraggio%20settimanale%20covid-19"

URL="http://cerca.ministerosalute.it/search?ulang=it&proxystylesheet=notiziePORT_front-end&access=p&btnG=Cerca&sort=date%3AD%3AS%3Ad1&wc=200&ud=1&entqr=3&output=xml_no_dtd&filter=p&q=$stringaQuery&wc_mc=1&site=notiziePORT_collection&oe=UTF-8&tlen=2048&getfields=*&client=notiziePORT_front-end&ie=UTF-8&entqrm=0&start=0"

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
    curl -kL "http://cerca.ministerosalute.it/search?ulang=it&proxystylesheet=notiziePORT_front-end&access=p&btnG=Cerca&sort=date%3AD%3AS%3Ad1&wc=200&ud=1&entqr=3&output=xml_no_dtd&filter=p&q=$stringaQuery&wc_mc=1&site=notiziePORT_collection&oe=UTF-8&tlen=2048&getfields=*&client=notiziePORT_front-end&ie=UTF-8&entqrm=0&start=$START" | scrape -be '.results a' | xq -r '.html.body.a[]."@href"' >>"$folder"/rawdata/listaURL
    let START=START+10
  done

  # per ogni pagina estrai elenco URL che contengono PDF
  rm "$folder"/rawdata/lista.jsonl
  rm "$folder"/rawdata/anagraficaPagine.dpkv
  while read p; do
    curl -kL "$p" >"$folder"/rawdata/pagina.html
    titoloPagina=$(scrape <"$folder"/rawdata/pagina.html -e '//title/text()' | tr '(\n|\r|\t)' ' ' | sed -r 's/ +/ /g')
    if [[ "$titoloPagina" =~ "report" ]]; then
      echo -e "titolo=$titoloPagina\turl=$p" | mlr --fs "\t" clean-whitespace >>"$folder"/rawdata/anagraficaPagine.dpkv
      scrape <"$folder"/rawdata/pagina.html -be '//div[@class="portlet tab-content"]//a[@href[contains(.,"pdf")]]' | xq -c '.html.body.a[] | .|= .+ {url:"'"$p"'"}' >>"$folder"/rawdata/lista.jsonl
    fi
  done <"$folder"/rawdata/listaURL

  # estrai CSV dei report regionali Epicentro PDF
  mlr --j2c unsparsify then rename -r '(@|#)','' then filter -S 'tolower($href)=~"epi.+[0-9]{6}"' then put -S '$dataReport=regextract_or_else($href,"[0-9]{8}","")' then cut -x -f onclick then put -S 'if($href=~"^/"){$hrefFile="http://www.salute.gov.it".$href}else{$hrefFile=$href}' then filter -x -S '(tolower($href)=~"grafico") || (tolower($title)=~"grafico")' then cut -x -f title,href then rename text,titoloFile then reorder -e -f url "$folder"/rawdata/lista.jsonl >"$folder"/../output/"$nome".csv
  # crea file markdown con lista report regionali Epicento
  mlr --c2m put '$titoloFile="[".$titoloFile."](".gsub($hrefFile," ","%20").")"' then cut -f titoloFile,dataReport then sort -f dataReport "$folder"/../output/"$nome".csv >"$folder"/../output/"$nome".md

  mv "$folder"/rawdata/lista.jsonl "$folder"/processing/listaFileReport.jsonl
  mv "$folder"/rawdata/listaURL "$folder"/processing/listaURLReport
fi
