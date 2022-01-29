#!/bin/bash

### requisiti ###
# Miller https://miller.readthedocs.io/en/latest/installing-miller/
# xmlstarlet http://xmlstar.sourceforge.net/
# jq https://stedolan.github.io/jq/
# scrape-cli https://github.com/aborruso/scrape-cli
### requisiti ###

set -x
set -e
set -u
set -o pipefail

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$folder"/../rawdata
mkdir -p "$folder"/../output


### anagrafica ###

nome="italiaDomaniAvvisi"

# RSS
titolo="Bandi e avvisi pubblicati su italiaDomani PNRR | un progetto di onData per datiBeneComune"
descrizione="Un feed creato per seguire la pagina dei bandi e degli avvisi pubblicati su italiaDomani, il sito del PNRR"
selflink="https://ondata.github.io/datiBeneComuneMonitoraggio/catalogo/italiaDomaniAvvisiBandi/output/feed.xml"

# URL pagina avvisi
URL="https://italiadomani.gov.it/it/bandi-e-avvisi/jcr:content/root/container/noticessearch.searchResults.html?orderby=%2540jcr%253Acontent%252FstartDate&sort=desc"

### anagrafica ###

# estrai codici di risposta HTTP e scarica pagina
code=$(curl -s -L -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:85.0) Gecko/20100101 Firefox/85.0' -o "$folder"/../rawdata/"$nome".html -w "%{http_code}" "$URL")

# se il server risponde fai partire lo script
if [ $code -eq 200 ]; then
  echo "ok, procedi"
else
  # se la pagina non è raggiungibile esci
  exit 1
fi

# estrai dati dall'HTML
scrape <"$folder"/../rawdata/"$nome".html -be "//div[contains(@class, 'notices-card')]" | xq -c '.html.body.div[]|{pa:.div[0].p["#text"],titolo:.div[1].h4["#text"],dataApertura:.div[3].div[1].div[0].div.div?[0].div.span["#text"],dataChiusura:.div[3].div[1].div[0].div.div[1].div.span["#text"],URL:.a["@href"]}' >"$folder"/../output/"$nome"_raw.json

# aggiungi campi data in formato YYYY-MM-DD
mlr --json put -S '$dataAperturaDate = strftime(strptime($dataApertura, "%d/%m/%y"),"%Y-%m-%d");$dataChiusuraDate = strftime(strptime($dataChiusura, "%d/%m/%y"),"%Y-%m-%d")' then clean-whitespace then sort -r dataAperturaDate -f titolo "$folder"/../output/"$nome"_raw.json >"$folder"/../output/"$nome"_latest.json

if [ ! -f "$folder"/../output/"$nome"_archivio.json ]; then
  cp "$folder"/../output/"$nome"_latest.json "$folder"/../output/"$nome"_archivio.json
else
  cp "$folder"/../output/"$nome"_archivio.json "$folder"/../output/tmp.json
  cat "$folder"/../output/tmp.json "$folder"/../output/"$nome"_latest.json >"$folder"/../output/"$nome"_archivio.json
  mlr -I --json uniq -a then sort -r dataAperturaDate -f titolo "$folder"/../output/"$nome"_archivio.json
  mlr --j2c cat "$folder"/../output/"$nome"_archivio.json >"$folder"/../output/"$nome"_archivio.csv
fi


# crea JSON per generare feed RSS
mlr --json put -S '$pubDate = strftime(strptime($dataApertura, "%d/%m/%y"),"%a, %d %b %Y %H:%M:%S %z")' then rename titolo,title,URL,link then put '$title=gsub($title,">","&gt;");$title=gsub($title,"&","&amp;");$title=gsub($title,"'\''","&apos;");$title=gsub($title,"\"","&quot;");$link=gsub($link,"&","&amp;")' then sort -r dataAperturaDate -f title "$folder"/../output/"$nome"_latest.json >"$folder"/../output/tmp_"$nome"_rss.json

# crea copia del template del feed
cp "$folder"/../risorse/feedTemplate.xml "$folder"/../output/feed.xml

# inserisci gli attributi anagrafici nel feed
xmlstarlet ed -L --subnode "//channel" --type elem -n title -v "$titolo" "$folder"/../output/feed.xml
xmlstarlet ed -L --subnode "//channel" --type elem -n description -v "$descrizione" "$folder"/../output/feed.xml
xmlstarlet ed -L --subnode "//channel" --type elem -n link -v "$selflink" "$folder"/../output/feed.xml
xmlstarlet ed -L --subnode "//channel" --type elem -n "atom:link" -v "" -i "//*[name()='atom:link']" -t "attr" -n "rel" -v "self" -i "//*[name()='atom:link']" -t "attr" -n "href" -v "$selflink" -i "//*[name()='atom:link']" -t "attr" -n "type" -v "application/rss+xml" "$folder"/../output/feed.xml

# leggi in loop i dati del file JSON e usali per creare nuovi item nel file XML
newcounter=0
cat "$folder"/../output/tmp_"$nome"_rss.json | while read line; do
  link=$(echo $line | jq -r .link)
  title=$(echo $line | jq -r .title)
  pubDate=$(echo $line | jq -r .pubDate)
  newcounter=$(expr $newcounter + 1)
  xmlstarlet ed -L --subnode "//channel" --type elem -n item -v "" \
    --subnode "//item[$newcounter]" --type elem -n title -v "$title" \
    --subnode "//item[$newcounter]" --type elem -n link -v "$link" \
    --subnode "//item[$newcounter]" --type elem -n pubDate -v "$pubDate" \
    --subnode "//item[$newcounter]" --type elem -n guid -v "$link" \
    "$folder"/../output/feed.xml
done
