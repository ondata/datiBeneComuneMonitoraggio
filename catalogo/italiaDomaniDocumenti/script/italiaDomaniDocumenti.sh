#!/bin/bash

set -x
set -e
set -u
set -o pipefail

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

git pull

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

# RSS

title="Italia Domani, Documenti | a cura di #datiBeneComune"
description="Il feed RSS per essere aggiornati su nuove pubblicazioni nella sezione Documenti di Italia Domani"
selflinkraw="https://ondata.github.io/datiBeneComuneMonitoraggio/catalogo/italiaDomaniDocumenti/rss.xml"

mlr --csv put -S '$pubDate = strftime(strptime($datetime, "%Y-%m-%d"),"%Y-%m-%dT%H:%M:%SZ");$title="#".$type." | ".$title' then rename URL,link then cut -o -f title,link,pubDate "$folder"/../output/latest.csv >"$folder"/../output/rss.csv

ogr2ogr -f geoRSS -dsco TITLE="$title" -dsco LINK="$selflinkraw" -dsco DESCRIPTION="$description" "$folder"/../rss.xml "$folder"/../output/rss.csv -oo AUTODETECT_TYPE=YES

# open-data
mkdir -p "$folder"/../output/open-data/rawdata
cd "$folder"/../output/open-data/rawdata
mlr --c2n filter -S '$type=="open-data"' then cut -f URL "$folder"/../output/latest.csv | xargs -n 1 -P 8 wget -q

cd "$folder"

# modifica encoding in UTF-8, cambia separatore da ";" a ",", rimuovi spazi bianchi ridondanti, rimuovi righe e colonne vuote
for i in "$folder"/../output/open-data/rawdata/*.csv; do
  nome=$(basename "$i")
  iconv -f Windows-1252 -t UTF-8 "$i" >"$folder"/../output/open-data/"$nome"
  mlr -I --csv --ifs ";" -N remove-empty-columns then skip-trivial-records "$folder"/../output/open-data/"$nome"
  mlr -I --csv -N put -S 'for (k in $*) {$[k] = gsub($[k], "^ +", "")};for (k in $*) {$[k] = gsub($[k], " +$", "")};for (k in $*) {$[k] = gsub($[k], "  +", " ")}' "$folder"/../output/open-data/"$nome"
done

