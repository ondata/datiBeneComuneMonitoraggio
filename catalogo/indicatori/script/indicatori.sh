#!/bin/bash

### requisiti ###
# Miller https://github.com/johnkerl/miller
# scrape-cli https://github.com/aborruso/scrape-cli
# xq https://kislyuk.github.io/yq/
### requisiti ###

set -x

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$folder"/rawdata
mkdir -p "$folder"/processing
mkdir -p "$folder"/../../

rm "$folder"/rawdata/lista.jsonl

nome="indicatori"

URL="http://www.salute.gov.it/portale/nuovocoronavirus/dettaglioContenutiNuovoCoronavirus.jsp?lingua=italiano&id=5351&area=nuovoCoronavirus&menu=vuoto"

# leggi la risposta HTTP del sito
code=$(curl -s -L -o /dev/null -w "%{http_code}" ''"$URL"'')

# se il sito è raggiungibile scarica  i dati
if [ $code -eq 200 ]; then
  curl "http://www.salute.gov.it/portale/nuovocoronavirus/dettaglioContenutiNuovoCoronavirus.jsp?lingua=italiano&id=5351&area=nuovoCoronavirus&menu=vuoto" | scrape -be '//div[@class="container-fluid"]//a[contains(text(),"MON") or strong[contains(text(),"MON")]]' | xq -c '.html.body.a[]' | mlr --json rename -r '^(@|#)', then rename strong,text >>"$folder"/rawdata/listaURL.json

  mlr -I --json uniq -a "$folder"/rawdata/listaURL.json
  mlr --j2n cut -f href "$folder"/rawdata/listaURL.json >"$folder"/rawdata/listaURL

  #http://www.salute.gov.it/portale/nuovocoronavirus/dettaglioContenutiNuovoCoronavirus.jsp?lingua=italiano&id=5351&area=nuovoCoronavirus&menu=vuoto

  while read p; do
    curl -kL "http://www.salute.gov.it$p" >"$folder"/rawdata/tmp_pagina.html
    titoloPagina=$(scrape <"$folder"/rawdata/tmp_pagina.html -e '//title/text()' | tr '(\n|\r|\t)' ' ' | sed -r 's/ +/ /g')
    scrape <"$folder"/rawdata/tmp_pagina.html -be '//a[contains(text(),"indica")]' | xq -c '.html.body.a| .|= .+ {url:"'"$p"'"}| .|= .+ {titoloPagina:"'"$titoloPagina"'"}' >>"$folder"/rawdata/listaFileRport.jsonl
  done <"$folder"/rawdata/listaURL

  sed -i '/null/d' "$folder"/rawdata/listaFileRport.jsonl

  mlr -I --json rename -r '(@|#)','' then filter -x -S '$href==""' then uniq -a "$folder"/rawdata/listaFileRport.jsonl

  cat "$folder"/rawdata/listaFileRport.jsonl >"$folder"/processing/listaFileRport.jsonl
  #then put '$href="http://www.salute.gov.it".$href'
  mlr -I --json uniq -a "$folder"/processing/listaFileRport.jsonl
  # titoloFile,dataReport,hrefFile,url
  mlr --j2c unsparsify \
    then put '$href="http://www.salute.gov.it".$href;$url="http://www.salute.gov.it".$url' \
    then cut -x -f onclick,title \
    then rename href,hrefFile,text,titoloFile "$folder"/processing/listaFileRport.jsonl >"$folder"/../output/indicatori.csv

fi
