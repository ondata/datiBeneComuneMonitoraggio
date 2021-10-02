#!/bin/bash

set -x
set -e
set -u
set -o pipefail

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$folder"/rawdata
mkdir -p "$folder"/processing
mkdir -p "$folder"/../output

URLBase="https://italiadomani.gov.it/it/documenti-pnrr.html"

code=$(curl -s -L -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:85.0) Gecko/20100101 Firefox/85.0' -o /dev/null -w "%{http_code}" "$URLBase")

# se il server risponde fai partire lo script
if [ $code -eq 200 ]; then
  curl -kL "https://italiadomani.gov.it/it/documenti-pnrr.html" |
    scrape -be '//div[@data-type]' |
    xq '.html.body.div[]' |
    mlr --j2c unsparsify then cut -o -r -f '(ta-type|ta-date|ta-author|on:span|href)' then rename -r -g "@data-," then rename -r ".*span.*,title" then reshape -r 'href' -o i,v then filter -x -S '$v==""' then cut -x -f i then rename v,path then put -S '$datetime = strftime(strptime($date, "%d/%m/%Y"),"%Y-%m-%d");$URL="https://italiadomani.gov.it".$path' then sort -r datetime then clean-whitespace >"$folder"/../output/latest.csv
# se non è raggiungibile esci
else
  exit 1
fi

if [ ! -f "$folder"/../output/archive.csv ]; then
  cp "$folder"/../output/latest.csv "$folder"/../output/archive.csv
else
  mlr --csv uniq -a then sort -r datetime "$folder"/../output/latest.csv "$folder"/../output/archive.csv >"$folder"/rawdata/tmp.csv
  mv "$folder"/rawdata/tmp.csv "$folder"/../output/archive.csv
fi
