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
  - [2020-11-22](#2020-11-22)

# Introduzione

L'obiettivo di base è quello di creare una lista dei report regionali del "**Monitoraggio Fase 2 Report settimanale**". Sono pubblicati in vari siti, uno è quello del Ministero della Salute.

Ad oggi - 22 novembre 2020 - sono in formato PDF.

Alcuni punti:

- non c'è una pagina dove "guardarli" tutti insieme in lista;
- non c'è una file di testo strutturato con questo elenco.

Un "indice" di questi documenti consente di fare diverse cose: una di queste è crearne una copia di archivio. La prima è stata fatta oggi (22/11/2020) su *web archive* (vedi [qui](https://i.imgur.com/K9Mkroe.png)).

# Fonte dati

La sezione Notizie dal Ministero del sito del Ministero della salute e in particolare l'output della *query* [`monitoraggio settimanale covid-19`](http://cerca.ministerosalute.it/search?ulang=it&proxystylesheet=notiziePORT_front-end&access=p&sort=date%3AD%3AS%3Ad1&wc=200&ud=1&entqr=3&output=xml_no_dtd&filter=p&q=monitoraggio%20settimanale%20covid-19&site=notiziePORT_collection&wc_mc=1&oe=UTF-8&tlen=2048&getfields=*&client=notiziePORT_front-end&ie=UTF-8&entqrm=0&start=0)

# Output

## Lista dei report in formato CSV

È stata creata una lista struttura in formato CSV, disponibile in [`output/monitoraggioSettimanale.csv`](output/monitoraggioSettimanale.csv).

I campi sono:

- `titoloFile`, con il nome del file, così come indicato sulla pagina del sito del Ministero;
- `dataReport`, la data presente nel nome del file;
- `hrefFile`, l'URL del file PDF;
- `url`, l'URL della pagina web in cui è presente il file.

| titoloFile | dataReport | hrefFile | url |
| --- | --- | --- | --- |
| Abruzzo | 20201118 | http://www.salute.gov.it/portale/news/documenti/Epi_aggiornamenti/Epi_aggiornamento_Abruzzo_20201118.pdf | http://www.salute.gov.it/portale/news/p3_2_1_1_1.jsp?lingua=italiano&menu=notizie&p=dalministero&id=5182 |
| Basilicata | 20201118 | http://www.salute.gov.it/portale/news/documenti/Epi_aggiornamenti/Epi_aggiornamento_Basilicata_20201118.pdf | http://www.salute.gov.it/portale/news/p3_2_1_1_1.jsp?lingua=italiano&menu=notizie&p=dalministero&id=5182 |
| Calabria | 20201118 | http://www.salute.gov.it/portale/news/documenti/Epi_aggiornamenti/Epi_aggiornamento_Calabria_20201118.pdf | http://www.salute.gov.it/portale/news/p3_2_1_1_1.jsp?lingua=italiano&menu=notizie&p=dalministero&id=5182 |
| Campania | 20201118 | http://www.salute.gov.it/portale/news/documenti/Epi_aggiornamenti/Epi_aggiornamento_Campania_20201118.pdf | http://www.salute.gov.it/portale/news/p3_2_1_1_1.jsp?lingua=italiano&menu=notizie&p=dalministero&id=5182 |
| ... | ... | ... | ... |

## Lista dei report in formato markdown

È stata creata una lista struttura in formato markdown, per essere letta a schermo e disponibile in [`output/monitoraggioSettimanale.md`](output/monitoraggioSettimanale.md).

Sotto un'anteprima

| titoloFile | dataReport |
| --- | --- |
| [Abruzzo](http://www.salute.gov.it/portale/news/documenti/Epi_aggiornamenti/Abruzzo_20200721.pdf) | 20200721 |
| [Basilicata](http://www.salute.gov.it/portale/news/documenti/Epi_aggiornamenti/Basilicata_20200721.pdf) | 20200721 |
| [Calabria](http://www.salute.gov.it/portale/news/documenti/Epi_aggiornamenti/Calabria_20200721.pdf) | 20200721 |
| ... | ... |

## Lista URL pagine che web del sito del ministero di possibile interesse

È stata creata (e verrà aggiornata giornalmente) la lista degli URL delle pagine che rispondono alla *query* [`monitoraggio settimanale covid-19`](http://cerca.ministerosalute.it/search?ulang=it&proxystylesheet=notiziePORT_front-end&access=p&sort=date%3AD%3AS%3Ad1&wc=200&ud=1&entqr=3&output=xml_no_dtd&filter=p&q=monitoraggio%20settimanale%20covid-19&site=notiziePORT_collection&wc_mc=1&oe=UTF-8&tlen=2048&getfields=*&client=notiziePORT_front-end&ie=UTF-8&entqrm=0&start=0) nella sezione news sul sito del ministero.

Il file è [`script/processing/listaURLReport`](script/processing/listaURLReport).

## File jsonlines con dati grezzi per produrre i vari output

I dati grezzi per produrre la gran parte dei file di output è questo file in formato jsonlines: [`script/processing/listaURLReport`](script/processing/listaFileReport.jsonl).

# Script

Due i file chiave:

- lo *script bash* [script/monitoraggioSettimanale.sh](script/monitoraggioSettimanale.sh) che legge e estrae questi dati;
- il [*workflow* di GitHub](../../.github/workflows/monitoraggioSettimanale.yml) che ogni giorno alle 2 di mattina aggiornerà la lista.

# Problematicità

- la licenza del sito del Ministero della Salute è [NC-ND](http://www.salute.gov.it/portale/p5_0.jsp?lingua=italiano&id=50), quindi non è possibile derivare nulla, nemmeno questa lista;
- il [file del Friuli Venezia Giulia](http://www.salute.gov.it/portale/news/documenti/Epi_aggiornamenti/Epi_aggiornamento_Friuli-Venezia_Giulia_20200915.pdf) del "[report 7-13 settembre](http://www.salute.gov.it/portale/news/p3_2_1_1_1.jsp?lingua=italiano&menu=notizie&p=dalministero&id=5061)" non è disponibile all'URL indicato nella pagina;

# Da fare

- [ ] creare un elenco/archivio ricercabile di queste risorse su zenodo (o web archive, ecc.)

# Log

## 2020-11-22

Creata lista dei report e script giornaliero per estrarli e aggiornarli. Fatta copia su archive di tutti i PDF
