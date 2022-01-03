#!/bin/bash

### requisiti ###
# camelot https://github.com/camelot-dev/camelot
# miller https://miller.readthedocs.io/en/latest/
### requisiti ###

set -x
set -e
set -u
set -o pipefail

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$folder"/processing
mkdir -p "$folder"/output

### conversione da PDF a CSV ###

convertPdfToCSV="no"

if [ "$convertPdfToCSV" == "yes" ]; then
  for i in "$folder"/rawdata/*.pdf; do
    name=$(basename "$i" .pdf)
    echo "$name"
    camelot -p 1-end -f csv -o "$folder"/processing/"$name".csv lattice "$i"
  done
fi

### conversione da PDF a CSV ###

### anagrafica enti ###

# fonte: https://bdap-opendata.mef.gov.it/content/anagrafica-enti-ente

# converti in UTF-8 e imposta separatore come ","
if [ ! -f "$folder"/risorse/Anagrafe-Enti---Ente-utf8.csv ]; then
  iconv -f Windows-1252 -t UTF-8 "$folder"/risorse/Anagrafe-Enti---Ente.csv | mlrgo --csv --ifs ";" cat >"$folder"/risorse/Anagrafe-Enti---Ente-utf8.csv
fi

### anagrafica enti ###

for i in "$folder"/rawdata/*.pdf; do
  name=$(basename "$i" .pdf)
  # rimuovi spazi bianchi ridondanti
  mlrgo -S --csv -N clean-whitespace then put -S '$page=FILENAME;$page=sub($page,".+page-","");$page=sub($page,"-t.+","")' then sort -n page then cut -x -f page "$folder"/processing/"$name"*.csv >"$folder"/output/"$name".csv
done


for i in "$folder"/output/*.csv; do
  # rimuovi il separatore delle migliaia
  mlrgo -S -I --csv -N put -S '
  for (k in $*) {
    $[k] = gsub($[k], "(\.|\n)", "");
  }
' "$i"
  # rimuovi il "-" che rappresenta il valore nullo
  mlrgo -S -I --csv -N put -S '
  for (k in $*) {
    $[k] = sub($[k], "^-$", "");
  }
' "$i"
  # sostituisci la virgola con punto, come separatore decimale
  mlrgo -S -I --csv -N put -S '
  for (k in $*) {
    $[k] = sub($[k], "([0-9]),([0-9])", "\1.\2");
  }
' "$i"
done

# aggiungi il nome campo nella colonna che non ce l'ha
mlrgo -S -I --csv -N put -S 'if (NR == 1) {for (k in $*) {$[k] = sub($[k], "^$","Di cui progettazione")}}' "$folder"/output/decreto-fl-30-12-2021-all-3.csv

# aggiungi URL openCup e data in formato YYYY-MM-DD
for i in "$folder"/output/*.csv; do
  mlrgo -S -I --csv put -S '$openCUP="https://opencup.gov.it/progetto/-/cup/".$CUP;$dataTramissioneDomanda=strftime(strptime(${Data Trasmissione Domanda}, "%d/%m/%Y"),"%Y-%m-%d")' "$i"
done

# aggiungi codice Istat ai dati

# estrai da anagrafica enti codice cup e codice istat
mlrgo --csv cut -f Id_Ente,Codice_ISTAT_Comune then rename Id_Ente,"Codice BDAP" "$folder"/risorse/Anagrafe-Enti---Ente-utf8.csv >"$folder"/processing/tmp.csv

# fai join e aggiungi codice istat, e crea JSON
for i in "$folder"/output/*.csv; do
  name=$(basename "$i" .csv)
  mlrgo --csv join --ul -j "Codice BDAP" -f "$i" then unsparsify "$folder"/processing/tmp.csv >"$folder"/processing/tmp_i.csv
  mv "$folder"/processing/tmp_i.csv "$i"
  mlrgo --c2j --jlistwrap cat "$i" >"$folder"/output/"$name".json
done

# estrarre dati Istat per normalizzare i totali per area e popolazione
# POP_2018,PRO_COM_111,SUP,SUP_URB

