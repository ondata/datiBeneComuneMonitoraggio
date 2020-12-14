- [Introduzione](#introduzione)
- [Fonte dati](#fonte-dati)
- [Output](#output)
  - [Lista dei report in formato CSV](#lista-dei-report-in-formato-csv)
  - [Lista dei report in formato markdown](#lista-dei-report-in-formato-markdown)
  - [Lista URL pagine che web del sito del ministero di possibile interesse](#lista-url-pagine-che-web-del-sito-del-ministero-di-possibile-interesse)
  - [File jsonlines con dati grezzi per produrre i vari output](#file-jsonlines-con-dati-grezzi-per-produrre-i-vari-output)
- [Script](#script)
- [Problematicità](#problematicità)
- [Da fare](#da-fare)
- [Log](#log)
  - [2020-12-14](#2020-12-14)

# Introduzione

L'obiettivo di base è quello di creare una lista dei report sull'**Andamento della mortalità giornaliera (SiSMG)**. Sono pubblicati in vari siti, uno è [quello del Ministero della Salute](http://cerca.ministerosalute.it/search?ulang=it&proxystylesheet=documentiPORT_front-end&access=p&wc=200&ud=1&entqr=3&output=xml_no_dtd&filter=p&q=sismg&site=pubblicazioniPORT_collection&wc_mc=1&oe=UTF-8&tlen=2048&getfields=*&client=documentiPORT_front-end&ie=UTF-8&entqrm=0&sort=date%3AD%3AS%3Ad1).

Ad oggi - 14 dicembre 2020 - sono in formato PDF.

Alcuni punti:

- non c'è una pagina dove "guardarli" tutti insieme in lista;
- non c'è una file di testo strutturato con questo elenco.

Un "indice" di questi documenti consente di fare diverse cose: una di queste è crearne una copia di archivio. La prima è stata fatta oggi (14/12/2020) su *web archive* (vedi [qui](https://web.archive.org/web/*/https://github.com/ondata/datiBeneComuneMonitoraggio/blob/main/catalogo/indicatori/output/indicatori.md)).

# Fonte dati

La sezione Notizie dal Ministero del sito del Ministero della salute e in particolare l'output della *query* [`andamento sismg`](http://cerca.ministerosalute.it/search?ulang=it&proxystylesheet=documentiPORT_front-end&access=p&wc=200&ud=1&entqr=3&output=xml_no_dtd&filter=p&q=sismg&site=pubblicazioniPORT_collection&wc_mc=1&oe=UTF-8&tlen=2048&getfields=*&client=documentiPORT_front-end&ie=UTF-8&entqrm=0&sort=date%3AD%3AS%3Ad1)

# Output

## Lista dei report in formato CSV

È stata creata una lista struttura in formato CSV, disponibile in [`output/SiSMG.csv`](output/SiSMG.csv).

I campi sono:

- `hrefFile`, l'URL del file PDF;
- `titoloFile`, con il nome del file, così come indicato sulla pagina del sito del Ministero;
- `url`, l'URL della pagina web in cui è presente il file;
- `titoloPagina`, il titolo della pagina web in cui il PDF era disponibile.

## Lista dei report in formato markdown

È stata creata una lista struttura in formato markdown, per essere letta a schermo e disponibile in [`output/SiSMG.md`](output/SiSMG.md).

## Lista URL pagine che web del sito del ministero di possibile interesse

Il file è [`script/processing/listaURLReport`](script/processing/listaURLReport) e verrà aggiornato giornalmente.

## File jsonlines con dati grezzi per produrre i vari output

I dati grezzi per produrre la gran parte dei file di output è questo file in formato jsonlines: [`script/processing/listaURLReport`](script/processing/listaFileReport.jsonl).

# Script

Due i file chiave:

- lo *script bash* [script/SiSMG.sh](script/SiSMG.sh) che legge e estrae questi dati;
- il [*workflow* di GitHub](../../.github/workflows/SiSMG.yml) che ogni giorno alle 2 di mattina aggiornerà la lista.

# Problematicità

- la licenza del sito del Ministero della Salute è [NC-ND](http://www.salute.gov.it/portale/p5_0.jsp?lingua=italiano&id=50), quindi non è possibile derivare nulla, nemmeno questa lista;

# Da fare

- [ ] creare un elenco/archivio ricercabile di queste risorse su zenodo (o web archive, ecc.);

# Log

## 2020-12-14

Creata prima versione di script e output
