# Contributi ai Comuni da destinare a investimenti in progetti di rigenerazione urbana anni 2021-2026

Il 30 dicembre 2021 è stata pubblicato il decreto relativo ai "Contributi ai Comuni da destinare a investimenti in progetti di rigenerazione urbana anni 2021-2026" (grazie a Monithon per la [segnalazione](https://twitter.com/Monithon/status/1476886369335136260)):<br>
<https://dait.interno.gov.it/finanza-locale/documentazione/decreto-30-dicembre-2021>.

Non sono pubblicati come dati *machine readable*, ma come PDF.

Sono i contributi della Missione 5 “Inclusione e Coesione”, Componente 2 “Infrastrutture sociali, famiglie, comunità e terzo settore”, Investimento 2.1 “Investimenti in progetti di rigenerazione urbana, volti a ridurre situazioni di emarginazione e degrado sociale”, in particolare:

1. MILESTONE:
    - Q3 2021, M-ITA: Attivazione della procedura di selezione degli investimenti in progetti di rigenerazione urbana volti a ridurre situazioni di emarginazione e degrado sociale entro il terzo trimestre 2021;
    - Q1 2022, M-UE: Notifica di tutti gli appalti pubblici assegnati ad almeno 300 comuni con popolazione superiore ai 15.000 abitanti per investimenti nella rigenerazione urbana, al fine di ridurre le situazioni di emarginazione e degrado sociale con progetti in linea con il dispositivo di ripresa e resilienza (RRF) e il principio ""non arrecare un danno significativo"" (DNSH) entro il primo trimestre 2022;
    - Q3 2023, M-ITA Aggiudicazione degli appalti pubblici da parte dei Comuni beneficiari entro il terzo trimestre 2023;
2. TARGET:
    - Q4 2024, T-ITA Erogato almeno il 30% degli importi totali degli interventi riferiti all'obiettivo finale entro il quarto trimestre 2024;
    - Q2 2026, T-UE Progetti completati, presentati dai comuni con più di 15.000 abitanti, riguardanti almeno un milione di metri quadrati di superficie relativa agli interventi di rigenerazione urbana entro il secondo trimestre 2026.

Altri dettagli in [questo file PDF](risorse/decreto-fl-30-12-2021_1.pdf).

## Elaborazioni effettuate

- I dati su questi contributi sono in file PDF, nei documenti classificati come allegati e presenti [qui](rawdata). Sono stati convertiti in CSV;
- Dai campi con valori numerici è stato rimosso il separatore di migliaia, e come separatore decimale è stato scelto il `.`. Ora sono "numeri" e non "testo";
- I campi con valori nulli sono in origine rappresentati dal carattere `-`. È stato rimosso, è adesso le celle sono vuote;
- C'è un campo di tipo "data", denominato `Data Trasmissione Domanda`, con le date espresse in formato `gg/mm/aaaa` (ad esempio `27/11/2021`). È stato aggiunto un campo, da questo derivato, con date in formato `aaaa-mm-gg`;
- È stato aggiunto il Codice Istat di ogni Comune, a partire dal [Codice BDAP](https://bdap-opendata.mef.gov.it/content/anagrafica-enti-ente) presente nei dati. Il campo aggiunto è `Codice_ISTAT_Comune`.

## Output

### Istanze validamente trasmesse e progetti ammissibili

Qui l'[elenco  dei progetti  ammissibili](output/decreto-fl-30-12-2021-all-1.csv) ([file PDF](rawdata/decreto-fl-30-12-2021-all-1.pdf) da cui sono stati estratti), relativi  alle  istanze validamente trasmesse dai Comuni ai sensi del DPCM 21 gennaio 2021 e del successivo Decreto del Ministero dell’Interno del 2 aprile 2021, e con evidenza dei progetti esclusi dall’assegnazione del contributo perché ritenuti non ammissibili per le motivazioni ivi indicate. L’elenco è allegato al presente provvedimento e ne forma parte integrante.

Altri dettagli sempre in [questo file PDF](risorse/decreto-fl-30-12-2021_1.pdf).

### Graduatoria progetti ammissibili

Qui la [graduatoria dei progetti ammissibili](output/decreto-fl-30-12-2021-all-2.csv) ([file PDF](rawdata/decreto-fl-30-12-2021-all-2.pdf), completi del target PNRR di riferimento individuati in quelli che presentano il valore più elevato dell’indice di vulnerabilità sociale e materiale (IVSM) (qui [il file con questi valori](risorse/Indicatori_Intero_territorio_nazionale.xlsx)), tenendo conto della quota riferita alla progettazione esecutiva e alle opere, in attuazione dell’art. 5 del DPCM del 21 gennaio 2021, per un ammontare complessivo di 4.277.384.625,56 euro.

### Progetti beneficiari del contributo e comuni attuatori

Qui l'[elenco dei progetti beneficiari](output/decreto-fl-30-12-2021-all-3.csv) ([file PDF](rawdata/decreto-fl-30-12-2021-all-3.pdf) da cui sono stati estratti), completi del target PNRR di riferimento e del comune soggetto attuatore nonché degli importi assegnati per ciascuna annualità sulla base del cronoprogramma e delle risorse disponibili per ciascun esercizio, per un ammontare di progetti finanziati pari a 3.399.271.176,95 euro.
