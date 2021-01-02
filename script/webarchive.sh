#!/bin/bash

set -x

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# se lo script è lanciato sul PC di andy, leggi l'API KEY di webarchive dal file locale
if [[ $(hostname) == "DESKTOP-7NVNDNF" ]]; then
  source "$folder"/../.config
fi

yq <"$folder"/../risorse/webarchive.yml -r '.[].URL' >"$folder"/../risorse/webarchive.txt
yq <"$folder"/../risorse/webarchive.yml . | mlr --j2t cut -f URL,if_not_archived_within | tail -n +2 >"$folder"/../risorse/webarchive.tsv

rm "$folder"/webarchiveLatest.log

while IFS=$'\t' read -r url time; do
  curl -X POST -H "Accept: application/json" -H "Authorization: LOW $SUPER_SECRET" \
    -d "url=$url" \
    -d "capture_outlinks=1" \
    -d "capture_screenshot=1" \
    -d "outlinks_availability=1" \
    -d "if_not_archived_within=$time" https://web.archive.org/save >>"$folder"/webarchiveLatest.log
  sleep 12
done <"$folder"/../risorse/webarchive.tsv

jq <"$folder"/webarchiveLatest.log -c . >"$folder"/tmp.log

mv "$folder"/tmp.log "$folder"/webarchiveLatest.log
