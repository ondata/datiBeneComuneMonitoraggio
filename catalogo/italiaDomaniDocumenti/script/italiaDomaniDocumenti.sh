#!/bin/bash

#set -x
set -e
set -u
set -o pipefail

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

git pull

mkdir -p "$folder"/rawdata
mkdir -p "$folder"/processing
mkdir -p "$folder"/../output

URLBase="https://italiadomani.gov.it/it/strumenti/documenti/archivio-documenti/jcr:content/root/container/documentssearch.searchResults.html?orderby=%40jcr%3Acontent%2Fdate&sort=desc"

# controlla risposta HTTP della pagina e scarica elenco dei documenti usando Chrome headless
rm -f "$folder"/rawdata/tmp.html 2>/dev/null || true
google-chrome-stable --headless --disable-gpu --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36" --dump-dom "$URLBase" > "$folder"/rawdata/tmp.html

# verifica se il file è stato scaricato correttamente e contiene i dati
if [ -s "$folder"/rawdata/tmp.html ] && grep -q "documentssearch" "$folder"/rawdata/tmp.html; then
  echo "OK"
# se non è stato scaricato correttamente, esci
else
  echo "Errore nel download della pagina"
  exit 1
fi

# estrai tipo e autore documento (fallback su struttura aggiornata del sito)
scrape <"$folder"/rawdata/tmp.html -be "//div[@data-cmp-hook-search='wrapper']" | xq -c '(.html.body.div // [])[] | {type:(.div.div[0].h4.button.span | if type=="array" then .[0] else . end),author:""}' | mlr --json cat -n >"$folder"/rawdata/tmpTypeAuthor.json


# estrai data, titolo e path documento
scrape <"$folder"/rawdata/tmp.html -be "//div[@data-cmp-hook-search='wrapper']" | xq -c '.html.body.div[]|{
      date:.div["@data-date"],
      title:.div.div[0].h4.button.span,
      path:.div.div[1].div.div[0].a["@href"]
      }' >"$folder"/rawdata/tmp_data.json

# aggiungi id ai dati, utile per fare il join tra i file
mlr -I --json cat -n "$folder"/rawdata/tmp_data.json

# join tra dati con dati su tipo e autore
mlr --json join --ul -j n -f "$folder"/rawdata/tmp_data.json then unsparsify then put -S '$datetime = strftime(strptime($date, "%d/%m/%y"),"%Y-%m-%d");$URL="https://italiadomani.gov.it".$path' then sort -r datetime -f title then clean-whitespace then reorder -f date,type,author,title,path,datetime,URL "$folder"/rawdata/tmpTypeAuthor.json >"$folder"/../output/latest.json


# estrai tag dei documenti (se assenti nella nuova struttura, produce tag vuoto per ogni record)
mlr --json put -S '$tag=""' then cut -f n,tag "$folder"/rawdata/tmpTypeAuthor.json >"$folder"/rawdata/tmpTag.json

# estrai URL documenti
scrape <"$folder"/rawdata/tmp.html -be '//div[@class="card-body pt-0"]' | xq '.html.body.div' | mlr --json unsparsify then cut -r -f 'href' then cat -n then reshape -r ":" -o i,v then filter -x -S '$v==""' then cut -x -f "i" then rename v,URLfile then put -S '$URLfile="https://italiadomani.gov.it".$URLfile' >"$folder"/rawdata/tmpURL.json

mlr --json join --ul -j n -f "$folder"/../output/latest.json then unsparsify then cut -f title,datetime,URLfile "$folder"/rawdata/tmpURL.json >"$folder"/rawdata/tmpURL_join.json

# aggiorna latest sui file
mlr --j2c cat then sort -r datetime -f title "$folder"/rawdata/tmpURL_join.json >"$folder"/../output/file_latest.csv

# crea file di archivio dei file e se c'è già aggiornalo
if [ ! -f "$folder"/../output/archive_file.csv ]; then
  cp "$folder"/../output/file_latest.csv "$folder"/../output/archive_file.csv
else
  mlr --csv uniq -a then sort -r datetime -f title then unsparsify "$folder"/../output/file_latest.csv "$folder"/../output/archive_file.csv >"$folder"/rawdata/tmp_file.csv
  mv "$folder"/rawdata/tmp_file.csv "$folder"/../output/archive_file.csv
fi

# fai join tra i dati e dati con i tag
mlr --json join --ul -j n -f "$folder"/../output/latest.json then unsparsify then cut -x -f n "$folder"/rawdata/tmpTag.json >"$folder"/rawdata/tmp_data.json
mv "$folder"/rawdata/tmp_data.json "$folder"/../output/latest.json


# aggiorna latest
mlr --j2c cat then sort -r datetime -f title "$folder"/../output/latest.json >"$folder"/../output/latest.csv

# crea file di archivio e se c'è già aggiornalo
if [ ! -f "$folder"/../output/archive.csv ]; then
  cp "$folder"/../output/latest.csv "$folder"/../output/archive.csv
else
  mlr --csv uniq -a then sort -r datetime -f title then unsparsify "$folder"/../output/latest.csv "$folder"/../output/archive.csv >"$folder"/rawdata/tmp.csv
  mv "$folder"/rawdata/tmp.csv "$folder"/../output/archive.csv
fi

# genera RSS
title="Italia Domani, Documenti | un progetto di onData per #datiBeneComune"
description="Il feed RSS per essere aggiornati su nuove pubblicazioni nella sezione Documenti di Italia Domani"
selflinkraw="https://ondata.github.io/datiBeneComuneMonitoraggio/catalogo/italiaDomaniDocumenti/rss.xml"

# estrai dati per RSS
mlr --csv put -S '$pubDate = strftime(strptime($datetime, "%Y-%m-%d"),"%Y-%m-%dT%H:%M:%SZ");$title="#".$type." | ".$title' then rename URL,link then cut -o -f title,link,pubDate "$folder"/../output/latest.csv >"$folder"/../output/rss.csv

# crea feed RSS
ogr2ogr -f geoRSS -dsco TITLE="$title" -dsco LINK="$selflinkraw" -dsco DESCRIPTION="$description" "$folder"/../rss.xml "$folder"/../output/rss.csv -oo AUTODETECT_TYPE=YES

# scarica le risorse definite come open-data
mkdir -p "$folder"/../output/open-data/rawdata
cd "$folder"/../output/open-data/rawdata
mlr --c2n filter -S 'tolower($tag)=~"open"' then cut -f URL "$folder"/../output/latest.csv | while read line; do
  # scarica dati con wget e se il file esiste già rinominalo con suffisso numerico
  wget --backups=1 $line
done

# cancella file di cui wget ha creato copia e che terminano per numero
find "$folder"/../output/open-data/rawdata -name '*.[1-9]' -delete

#
#cd "$folder"
#
## modifica encoding in UTF-8, cambia separatore da ";" a ",", rimuovi spazi bianchi ridondanti, rimuovi righe e colonne vuote
#for i in "$folder"/../output/open-data/rawdata/*.csv; do
#  nome=$(basename "$i")
#  iconv -f Windows-1252 -t UTF-8 "$i" >"$folder"/../output/open-data/"$nome"
#  mlr -I --csv --ifs ";" -N remove-empty-columns then skip-trivial-records "$folder"/../output/open-data/"$nome"
#  mlr -I --csv -N put -S 'for (k in $*) {$[k] = gsub($[k], "^ +", "")};for (k in $*) {$[k] = gsub($[k], " +$", "")};for (k in $*) {$[k] = gsub($[k], "  +", " ")}' "$folder"/../output/open-data/"$nome"
#done
