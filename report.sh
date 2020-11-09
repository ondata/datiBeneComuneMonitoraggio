#!/bin/bash

set -x

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$folder"/rawdata
mkdir -p "$folder"/report

rm "$folder"/rawdata/lista.jsonl

while read p; do
  curl "$p" | scrape -be '//a[contains(@href,"aggiorname")]' | xq -c '.html.body.a[]' >>"$folder"/rawdata/lista.jsonl
done <"$folder"/lista

mlr --j2c unsparsify "$folder"/rawdata/lista.jsonl >"$folder"/rawdata/lista.csv

mlr --csv then rename -r "^@(.+),\1" then filter '$href=~"^/port"' then cut -f href then put -S '$href="http://www.salute.gov.it".$href' "$folder"/rawdata/lista.csv |tail -n +2 >"$folder"/rawdata/download

cd "$folder"/report
while read p; do
  wget "$p"
done <"$folder"/rawdata/download
