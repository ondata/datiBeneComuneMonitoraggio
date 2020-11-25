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
mkdir -p "$folder"/../output

nome="sorveglianzaIntegrata"

URL="https://web.archive.org/web/timemap/?url=https%3A%2F%2Fwww.epicentro.iss.it%2Fcoronavirus%2Fbollettino%2F&matchType=prefix&collapse=urlkey&output=json&fl=original%2Cmimetype%2Ctimestamp%2Cendtimestamp%2Cgroupcount%2Cuniqcount&filter=!statuscode%3A%5B45%5D..&limit=100000"

# leggi la risposta HTTP del sito
code=$(curl -s -L -o /dev/null -w "%{http_code}" ''"$URL"'')

# se il sito è raggiungibile scarica  i dati
if [ "$code" -eq 200 ]; then

  # scarica lista
  curl $'https://web.archive.org/web/timemap/?url=https%3A%2F%2Fwww.epicentro.iss.it%2Fcoronavirus%2Fbollettino%2F&matchType=prefix&collapse=urlkey&output=json&fl=original%2Cmimetype%2Ctimestamp%2Cendtimestamp%2Cgroupcount%2Cuniqcount&filter=\u0021statuscode%3A%5B45%5D..&limit=100000' >"$folder"/rawdata/lista.json
  jq <"$folder"/rawdata/lista.json -c '.[]' | sed -r 's/(\[|\])//g' >"$folder"/processing/lista.csv

  mlr -I --csv cat "$folder"/processing/lista.csv

  mlr --csv filter '$mimetype=~"pdf" && tolower($original)=~"integrat"' \
  then put '$url=sub($original,"^(.+)[?](.+)$","\1")' \
  then put 'if (tolower($url)=~"appendix"){$tipo="appendice"}else{$tipo=""}' \
  then put '$nomefile=sub($url,"^(.+/)(.+)$","\2")' \
  then put '$data=sub($url,"^(.+COVID-19_)(.+2020)(.+)$","\2")' \
  then cut -o -f nomefile,data,tipo,url "$folder"/processing/lista.csv >"$folder"/../output/"$nome".csv

  mlr --c2m put '$nomefile="[".$nomefile."](".$url.")"' then cut -x -f url "$folder"/../output/"$nome".csv >"$folder"/../output/"$nome".md

fi
