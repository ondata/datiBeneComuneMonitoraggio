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
  - [2020-11-25](#2020-11-25)
  - [2020-11-22](#2020-11-22)

# Introduzione

L'obiettivo di base è quello di creare una lista dei report sugli **Indicatori per la valutazione del rischio**. Sono pubblicati in vari siti, uno è [quello del Ministero della Salute](http://www.salute.gov.it/portale/nuovocoronavirus/dettaglioContenutiNuovoCoronavirus.jsp?lingua=italiano&id=5351&area=nuovoCoronavirus&menu=vuoto).

Ad oggi - 22 novembre 2020 - sono in formato PDF.

Alcuni punti:

- non c'è una pagina dove "guardarli" tutti insieme in lista;
- non c'è una file di testo strutturato con questo elenco.

Un "indice" di questi documenti consente di fare diverse cose: una di queste è crearne una copia di archivio. La prima è stata fatta oggi (22/11/2020) su *web archive* (vedi [qui](https://i.imgur.com/K9Mkroe.png)).

# Fonte dati

La sezione [`Covid-19 - Situazione in Italia`](http://www.salute.gov.it/portale/nuovocoronavirus/dettaglioContenutiNuovoCoronavirus.jsp?lingua=italiano&id=5351&area=nuovoCoronavirus&menu=vuoto) del sito del Ministero della salute e in particolare le pagine linkate che contengono nel titolo la stringa `monit`.

# Output

## Lista dei report in formato CSV

È stata creata una lista struttura in formato CSV, disponibile in [`output/indicatori.csv`](output/indicatori.csv).

I campi sono:

- `hrefFile`, l'URL del file PDF;
- `titoloFile`, con il nome del file, così come indicato sulla pagina del sito del Ministero;
- `url`, l'URL della pagina web in cui è presente il file;
- `titoloPagina`, il titolo della pagina web in cui il PDF era disponibile.

| hrefFile | titoloFile | url | titoloPagina |
| --- | --- | --- | --- |
| http://www.salute.gov.it/imgs/C_17_notizie_5182_0_file.pdf | Dati indicatori | http://www.salute.gov.it/portale/nuovocoronavirus/dettaglioNotizieNuovoCoronavirus.jsp?lingua=italiano&menu=notizie&p=dalministero&id=5182 | Monitoraggio settimanale Covid-19, report 9 - 15 novembre  |
| http://www.salute.gov.it/imgs/C_17_notizie_5169_1_file.pdf | Dati indicatori | http://www.salute.gov.it/portale/nuovocoronavirus/dettaglioNotizieNuovoCoronavirus.jsp?lingua=italiano&menu=notizie&p=dalministero&id=5169 | Monitoraggio settimanale Covid-19, report 2 - 8 novembre  |
| http://www.salute.gov.it/portale/news/documenti/Epi_aggiornamenti/allegati/DATI_MONITORAGGIO_9_11_2020.pdf | Dati indicatori | http://www.salute.gov.it/portale/nuovocoronavirus/dettaglioNotizieNuovoCoronavirus.jsp?lingua=italiano&menu=notizie&p=dalministero&id=5157 | Monitoraggio settimanale Covid-19, report 26 ottobre - 1 novembre  |

## Lista dei report in formato markdown

È stata creata una lista struttura in formato markdown, per essere letta a schermo e disponibile in [`output/indicatori.md`](output/indicatori.md).

Sotto un'anteprima

| titoloFile | titoloPagina |
| --- | --- |
| [Dati indicatori](http://www.salute.gov.it/imgs/C_17_notizie_5182_0_file.pdf) | Monitoraggio settimanale Covid-19, report 9 - 15 novembre  |
| [Dati indicatori](http://www.salute.gov.it/imgs/C_17_notizie_5169_1_file.pdf) | Monitoraggio settimanale Covid-19, report 2 - 8 novembre  |
| [Dati indicatori](http://www.salute.gov.it/portale/news/documenti/Epi_aggiornamenti/allegati/DATI_MONITORAGGIO_9_11_2020.pdf) | Monitoraggio settimanale Covid-19, report 26 ottobre - 1 novembre  |


## Lista URL pagine che web del sito del ministero di possibile interesse

Il file è [`script/processing/listaURLReport`](script/processing/listaURLReport) e verrà aggiornato giornalmente.

## File jsonlines con dati grezzi per produrre i vari output

I dati grezzi per produrre la gran parte dei file di output è questo file in formato jsonlines: [`script/processing/listaURLReport`](script/processing/listaFileReport.jsonl).

# Script

Due i file chiave:

- lo *script bash* [script/indicatori.sh](script/indicatori.sh) che legge e estrae questi dati;
- il [*workflow* di GitHub](../../.github/workflows/indicatori.yml) che ogni giorno alle 2 di mattina aggiornerà la lista.

# Problematicità

- la licenza del sito del Ministero della Salute è [NC-ND](http://www.salute.gov.it/portale/p5_0.jsp?lingua=italiano&id=50), quindi non è possibile derivare nulla, nemmeno questa lista;

# Da fare

- [ ] creare un elenco/archivio ricercabile di queste risorse su zenodo (o web archive, ecc.);
- [ ] verificare se sono presenti, report precedenti al più "vecchio" attualmente in lista.

# Log

## 2020-11-25

Scritto e pubblicato il `README` (questo file).

## 2020-11-22

Creata lista dei report e script giornaliero per estrarli e aggiornarli. Fatta copia su archive di tutti i PDF
