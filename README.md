## Un repository a supporto del monitoraggio COVID-19

Questo spazio esiste a supporto delle azioni di monitoraggio, sviluppate nell’ambito del la campagna [datiBeneComune](https://datibenecomune.it/), in cui più di 150 realtà diverse e circa 40.000 firmatari chiedono al Governo dati aperti e *machine readable* sull’emergenza COVID-19.

### Indici di documenti e loro archiviazione

Molte delle informazioni pubbliche più interessanti e di valore sulla **COVID-19** in **Italia** risiedono in ricchi **PDF** a pubblicazione periodica, per lo più presenti sul sito del Ministero della Salute e/o su quello dell'Istituto Superiore di Sanità.

Questo spazio esiste per superare la dispersione delle documentazioni e le criticità correlate.

Nei siti istituzionali infatti non esistono delle pagine "**indice**", con raccolta ed archiviazione di tutti i documenti. Per volerli esaminare in modo organico si è costretti a fare ricerche *web* (tramite motori di ricerca o servizi di ricerca presenti nei siti). Per superare questo problema, qui abbiamo iniziato ad organizzare una *repository*.

Abbiamo attivato un meccanismo automatico per la creazione di una **copia** di **archivio** di questi *file* per tenerne traccia, perché tutta la documentazione ha un valore. Se le pagine istituzionali in cui sono pubblicati i documenti venissero spente o cancellate, non sarebbe più possibile accedere a questo patrimonio informativo.

Al momento (8 dicembre 2020) abbiamo creato questi elenchi di documenti:

- gli [Indicatori Monitoraggio della Fase 2](https://ondata.github.io/datiBeneComuneMonitoraggio/catalogo/indicatori/output/indicatori) ([qui](https://ondata.github.io/datiBeneComuneMonitoraggio/catalogo/indicatori/output/indicatori.csv) l'elenco in CSV);
- i [Bollettini sorveglianza integrata](https://ondata.github.io/datiBeneComuneMonitoraggio/catalogo/sorveglianzaIntegrata/output/sorveglianzaIntegrata) ([qui](https://ondata.github.io/datiBeneComuneMonitoraggio/catalogo/sorveglianzaIntegrata/output/sorveglianzaIntegrata.csv) l'elenco in CSV);
- i [Report settimanali regionali](https://ondata.github.io/datiBeneComuneMonitoraggio/catalogo/monitoraggioSettimanale/output/monitoraggioSettimanale) ([qui](https://ondata.github.io/datiBeneComuneMonitoraggio/catalogo/monitoraggioSettimanale/output/monitoraggioSettimanale.csv) l'elenco in CSV);
- i report sull'andamento della mortalità giornaliera (SiSMG) nelle città italiane in relazione all'epidemia di Covid-19

Di ognuno dei file in questi elenchi viene fatta automaticamente copia su [Internet Archive](https://archive.org/) (il più importante archivio digitale dei contenuti web), tramite questo [*script*](https://github.com/ondata/datiBeneComuneMonitoraggio/blob/main/script/webarchive.sh).

Quindi ad esempio se il file <http://www.salute.gov.it/imgs/C_17_notizie_5196_1_file.pdf> dovesse non essere più presente sul sito del Ministero della Salute, sarà accessibile nella sua versione su IA:<br>
<https://web.archive.org/web/*/http://www.salute.gov.it/imgs/C_17_notizie_5196_1_file.pdf>

Alcune note:

- l'interfaccia è a una sua prima versione, senza la possibilità ad esempio di applicare filtri e/o ordinare questi elenchi. Se vuoi dare una mano, questi elenchi sono a disposizione per essere riorganizzati;
- l'aggiornamento di questi elenchi è automatico. Qualche volte potrebbe non andare a buon fine e/o non essere fatto al meglio. Se hai qualche suggerimento, apri per favore una issue [qui](https://github.com/ondata/datiBeneComuneMonitoraggio/issues/new);
- l'elenco dei documenti nelle varie categorie non è ancora completo;
- se ci sono altri tipi di documenti, di cui pensi sia importante creare un indice e a cascata una copia di archivio, scrivilo in una issue [qui](https://github.com/ondata/datiBeneComuneMonitoraggio/issues/new).
