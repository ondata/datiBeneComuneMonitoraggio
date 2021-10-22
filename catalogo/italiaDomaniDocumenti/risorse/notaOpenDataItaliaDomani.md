- [Note sugli open-data pubblicati su Italia Domani](#note-sugli-open-data-pubblicati-su-italia-domani)
  - [Non sono dati aperti, perché la licenza non consente di farne uso](#non-sono-dati-aperti-perché-la-licenza-non-consente-di-farne-uso)
  - [Non c'è una sezione di "contatto"](#non-cè-una-sezione-di-contatto)
  - [Pochissima cura nella pubblicazione dei dati](#pochissima-cura-nella-pubblicazione-dei-dati)
    - [Righe vuote](#righe-vuote)
    - [Decine di colonne senza valori](#decine-di-colonne-senza-valori)
    - [Intestazioni ridondanti](#intestazioni-ridondanti)
    - [Separatore di campo e codifica caratteri non documentati](#separatore-di-campo-e-codifica-caratteri-non-documentati)
    - [Presenza di celle contenenti valori aggregati](#presenza-di-celle-contenenti-valori-aggregati)
    - [~~Note di lavoro non rimosse~~](#note-di-lavoro-non-rimosse)
    - [Presenza di note/metadati tra i valori delle celle](#presenza-di-notemetadati-tra-i-valori-delle-celle)
    - [Assenza di verifica congruità di campi contenenti liste di valori controllati](#assenza-di-verifica-congruità-di-campi-contenenti-liste-di-valori-controllati)
    - [Assenza controllo presenza di spazi bianchi ridondanti](#assenza-controllo-presenza-di-spazi-bianchi-ridondanti)
    - [Uniformare rappresentazione del valore Not Available](#uniformare-rappresentazione-del-valore-not-available)
    - [Formato dati non descritto](#formato-dati-non-descritto)
    - [Assenza di un file/servizio di "catalogo"](#assenza-di-un-fileservizio-di-catalogo)
- [Grazie](#grazie)
- [Log](#log)
  - [2021-10-20](#2021-10-20)
  - [2021-10-03](#2021-10-03)

# Note sugli open-data pubblicati su Italia Domani

Nel sito **Italia Domani**, il sito ufficiale dedicato al **Piano Nazionale Ripresa e Resilienza** (PNRR), nella sezione [Documenti](https://italiadomani.gov.it/it/documenti-pnrr.html), sono disponibili dei file classificati come **open-data** (è uno dei filtri disponibili).<br>
Sono presenti alcune **criticità** che li **rendono** **poco** **utilizzabili**.

Riteniamo inoltre che la stessa attenzione che si è messa nella predisposizione e redazione del piano - per l’approvazione da parte dell'UE - debba essere messa anche nella pubblicazione dei dati in questo sito.<br>
La loro **conoscenza** è un **diritto**, e la **cura** nella pubblicazione è una forma di **rispetto** e **condivisione**.

Apprezziamo che siano *online*, ma va fatto rispettando le “regole” per un buon uso: non è solo un adempimento formale, ma è la conseguenza della consapevolezza che ci si mette nel **fare un lavoro “per bene”**!

Nell'intento di dare un aiuto, a seguire alcune note su quanto pubblicato.


## Non sono dati aperti, perché la licenza non consente di farne uso

Ai file della sezione **documenti** **non è associata una licenza**, quindi vale la [nota generale di *copyright* del sito](https://italiadomani.gov.it/it/copyright.html), che **non consente qualsiasi uso dei dati pubblicati**, quindi **non sono per nulla dati aperti**, **non sono un bene comune**.

- **Come risolvere**: **associare** ai documenti classificati come "open-data", **una delle licenze** previste **per i dati aperti** elencate nelle "[Linee guida nazionali per la valorizzazione del patrimonio informativo pubblico](https://docs.italia.it/italia/daf/lg-patrimonio-pubblico/it/stabile/licenzecosti.html#licenze)";
- **Complessità azione risolutiva**: nulla. Si realizza in brevissimo tempo senza che siano necessari approfondimenti. Per eventuali dubbi, contattare l'[Agenzia per l'Italia digitale](https://www.agid.gov.it/).

## Non c'è una sezione di "contatto"

Sul sito non è presente una sezione di "contatto", *email*/*form*/altra modalità, per raggiungere un *helpdesk* del sito e/o chi si occupa di gestirlo.
Sarebbe utile approntarlo, per **consentire** l'**interazione** con **cittadini**, riutilizzatori di dati, mass-media, ricercatori etc., anche e proprio per **segnalazioni** **collaborative** di possibili errori/problemi, come quelli elencati a seguire.


## Pochissima cura nella pubblicazione dei dati

I **file open-data** al momento sono tutti **in formato CSV**. Analizzandoli, emergono tanti elementi che fanno pensare che per produrli ci sia limitati ad aprirli nel loro formato nativo - probabilmente dei fogli elettronici - e **ci sia limitati a fare un salva con nome**, **senza porre alcuna cura** nel produrre degli *output* con le **caratteristiche di base dei dati aperti**.

A seguire delle note di dettaglio, che faranno riferimento alla risorsa denominata **`Traguardi, obiettivi e scadenze per il monitoraggio e l'attuazione degli interventi del PNRR`**.<br>
È associato a un file che è stato aggiornato già due volte. Queste le versioni, tutte ancora disponibili sul sito (visibile soltanto l'ultima):

- [`20211007_T1_UENaz_codificato_ITA.csv`](https://italiadomani.gov.it/content/dam/sogei-ng/documenti/20211007_T1_UENaz_codificato_ITA.csv), che è la **corrente**, del 14 ottobre 2021. Di questo sono uscite due versioni ([qui le differenze](https://github.com/ondata/datiBeneComuneMonitoraggio/commit/9145941370d1d7d90b0270e4a9c36b284398f78c#diff-33e5c15f6534df6982d878d3d11d36f1be9ab672b1c9c9e3517184d021805c57));
- [`20210927_T1_UENaz_codificato_ITA.csv`](https://italiadomani.gov.it/content/dam/sogei-ng/documenti/20210927_T1_UENaz_codificato_ITA.csv).

Questi aggiornamenti risolvono alcune delle note sottostanti, scritte il 3 ottobre 2021. Anche quelle risolte sono lasciate visibili, ma marcate con un taglio centrale - ~~come questo~~ - per dare conto del fatto di essere superate.

### Righe vuote

Sono presenti delle righe totalmente vuote. Ad esempio:

```
534         blank-row    Row at position "534" is completely blank
535         blank-row    Row at position "535" is completely blank
536         blank-row    Row at position "536" is completely blank
537         blank-row    Row at position "537" is completely blank
......
```

### Decine di colonne senza valori

Dopo l'ultima colonna - `Meccanismo di verifica` - sono presenti una ventina di colonne senza intestazione e senza alcuna valorizzazione delle celle.

```
Meccanismo di verifica;;;;;;;;;;;;;;;;;;
```

### Intestazioni ridondanti

Il file contiene diverse brutture correlate alle intestazioni di campo. Ad esempio, facendo riferimento alla immagine sottostante:

1. la prima riga totalmente vuota;
2. un valore di cella, che in realtà è il titolo della tabella;
3. un valore di cella, che è la descrizione generale della tabella;
4. due righe spesso vuote, che contengono alle volte dei dettagli che andrebbero inseriti o in un file di descrizione che accompagna il file, o unite ai valori di intestazione delle colonne;
5. ~~due colonne, di cui la prima non ha nome, spesso non valorizzata con delle note e la seconda è del tutto vuota.~~

Sarebbe opportuno lasciare **una sola prima riga con le sole intestazioni di campo** (i nomi delle colonne).

![](https://i.imgur.com/nsUIoPL.png)

### Separatore di campo e codifica caratteri non documentati

Due sono gli elementi chiave per fare in modo che un *computer*, possa leggere correttamente un file `CSV`:

- il separatore di campi;
- la codifica dei caratteri.

Il primo è deducibile in modo quasi diretto, ma il secondo no. È essenziale **aggiungere** nel sito una **nota informativa** in cui - ad esempio per questi primi file - documentare che il separatore dei campi è il `;` e la codifica dei caratteri è (ad esempio) `Windows-1252`.

![](https://i.imgur.com/MAcKpOp.png)

### Presenza di celle contenenti valori aggregati

I file da pubblicare per essere letti come dati, sono da rendere disponibili senza righe o colonne che contengano valori aggregati a partire da altre righe e colonne.

Nel file [`Quadro PNRR e Piano Complementare_(aggiornato al 30.09.2021).csv`](https://italiadomani.gov.it/content/dam/sogei-ng/documenti/Quadro%20PNRR%20e%20Piano%20Complementare_(aggiornato%20al%2030.09.2021).csv), è presente ad esempio in fondo a tutto la riga `Totale complessivo`.

Queste **righe e/o colonne d'aggregazione**, se presenti, **vanno rimosse**.

### ~~Note di lavoro non rimosse~~

~~Nel file `Traguardi, obiettivi e scadenze per il monitoraggio e l'attuazione degli interventi del PNRR` sono presenti dei valori di cella, che sembrano delle note interne e non dei metadati. Se così è, **andrebbero rimosse**.~~

```
Line 949: verificare coerenza colonne V e W";;;;;;;;;;;;;;;;;;;;;
Line 952: verificare coerenza colonne V e W";;;;;;;;;;;;;;;;;;;;;
Line 965: verificare coerenza colonne V e W";;;;;;;;;;;;;;;;;;;;;
Line 971: verificare coerenza colonne V e W";;;;;;;;;;;;;;;;;;;;;
Line 986: verificare coerenza colonne V e W";;;;;;;;;;;;;;;;;;;;;
Line 992: verificare coerenza colonne V e W";;;;;;;;;;;;;;;;;;;;;
Line 997: verificare coerenza colonne V e W";;;;;;;;;;;;;;;;;;;;;
Line 5406: [...];sul file inviato da Raffaele è indicato come INV.4 anziché INV. 5, quindi è stato corretto il refuso;;;;;;;;;;;;;;;;;;;
```

**Nota bene**: non più presenti nel file corrente, ma soltanto in [questa versione](https://italiadomani.gov.it/content/dam/sogei-ng/documenti/20210927_T1_UENaz_codificato_ITA.csv).

### Presenza di note/metadati tra i valori delle celle

Il file contiene oltre ai valori dei campi, delle celle con delle note utili; queste però - in un file `CSV` - **non andrebbero inserite tra i dati**, ma in **qualche risorsa esterna che le raccoglie**.

Un esempio è quello del file [`Quadro PNRR_aggiornato al 30.09.2021.csv`](https://italiadomani.gov.it/content/dam/sogei-ng/documenti/Quadro%20PNRR-Piano%20Complementare_aggiornato%20al%2030.09.2021.csv), in cui è possibile leggere:

```
NOTA*Nella seduta del CdM del 26/08/2021 la compentenza sull'intervento M2C1 investimento 4. Tecnologie satellitari ed economia spaziale è passata al MITD
```

### Assenza di verifica congruità di campi contenenti liste di valori controllati

~~Alcuni campi contengono una lista controllata di valori. Come ad esempio il campo `Milestone / Target` che dovrebbe essere valorizzato con soli 2 valori: `Milestone` o `Target`.
<br>In un caso però c'è il valore `target` (la iniziale è minuscola) e non `Target`.~~

Un altro esempio è quello della colonna con le unità di misura degli indicatori quantitativi: troviamo sia `EUR` che `Euro`, oppure `Punti percentuali` e `Percentuale`.

Per queste colonne a valori controllati, **andrebbero inseriti** dei **controlli automatici di congruità**.

### Assenza controllo presenza di spazi bianchi ridondanti

Per un *computer* il valore ` ␣ Massa Carrara` (` ␣ ` è per rappresentare lo spazio, qui a inizio cella) è diverso da `Massa Carrara`: se dovrà conteggiare tutte le occorrenze di `Massa Carrara` o usare la stringa `Massa Carrara` per correlarla a valori presenti in un'altra tabella, non terrà conto delle celle in cui erroneamente è stato inserito uno spazio iniziale. E lo stesso vale per uno (o più) spazio alla fine (`Massa Carrara ␣ `) o più spazi tra parole (`Massa ␣ ␣ Carrara`).

Ci sono tantissime occorrenze di spazi bianchi ridondanti e andrebbero rimossi.

### Uniformare rappresentazione del valore Not Available

Ad esempio nella colonna `Indicatori quantitativi` le di questo tipo sono così rappresentate:

- con `N.A`;
- con `N/A`;
- con `NA`.

Qui e in altre colonne sarebbe necessario uniformare la modalità per rappresentare il `Not Available`. Inoltre il valore `N/A` potrebbe avere un significato diverso dalla cella vuota; se è così, sarebbe da documentare e rendere noto, viceversa (se coincidono) ci sarebbe da scegliere se usare `N/A` o cella vuota e documentarne il significato.

### Formato dati non descritto

Andrebbe associato a ogni file `CSV` un ulteriore file che descriva lo schema dati. Per ogni campo, la descrizione, il formato (utile per i campi con date e numerici). Un esempio è [quanto fatto dalla Protezione Civile per i dati COVID-19](https://github.com/pcm-dpc/COVID-19/blob/master/dati-andamento-covid19-italia.md#dati-per-regione).

### Assenza di un file/servizio di "catalogo"

I dati aperti in generale, a maggior forza quelli legati a un progetto epocale, devono essere **pubblicati in modo da renderne la diffusione ampia e automatica**. Per farlo basta descrivere in modo standard, come ad esempio si può leggere nelle ["Linee guida per i cataloghi dati"](https://docs.italia.it/italia/daf/linee-guida-cataloghi-dati-dcat-ap-it/it/stabile/index.html), l'elenco delle risorse pubblicate.

In questo modo i dati aperti di Italia Domani sarebbero **automaticamente** resi **disponibili** sul **portale nazionale ed europeo sui dati aperti** e sui **maggiori motori di ricerca**.

---
# Grazie
L'ispirazione si deve a Marco Cortella e a [questo ricco scambio su Twitter](https://twitter.com/Mcx83/status/1443953484672417813), e alla spinta di Ciro Spataro.

# Log

## 2021-10-20

- inserita nel documento sezione [Log](#log);
- aggiornato il documento alla pubblicazione di una nuova versione del file `Traguardi, obiettivi e scadenze per il monitoraggio e l'attuazione degli interventi del PNRR`;
- aggiunto paragrafo introduttivo iniziale;

## 2021-10-03

Prima versione di questo documento
