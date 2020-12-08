## Un repository a supporto del monitoraggio COVID-19

Questo spazio esiste a supporto delle azioni di **monitoraggio**, che sono state e saranno sviluppate per la campagna [**datiBeneComune**](https://datibenecomune.it/), in cui più **150 organizzazioni** e circa **40.000 firmatari** chiedono al Governo **dati aperti** e ***machine readable*** sull’emergenza COVID-19.

### Indici di documenti e loro archiviazione

Molte delle informazioni pubbliche più interssanti e di valore sulla **COVID-19** in Italia risiedono in ricchi **PDF** a pubblicazione periodica, per lo più presenti sul sito del Ministero della Salute e/o su quello dell'Istituto Superiore di Sanità.

Questo spazio esiste per superare delle criticità correlate.

Spesso infatti non esistono delle **pagine "indice"**, con raccolti tutti i documenti di un certo tipo. Per volerli esaminare in modo organico si è costretti a fare ricerche *web* (tramite motori di ricerca o servizi di ricerca presenti nei siti). Qui abbiamo iniziato a farlo.

Abbiamo attivano anche un **meccanisno automatico** per la **creazione di una copia di archivo** di questi documenti, perché sono di valore. Se le pagine in cui sono pubblicati venissero spente/cancellate, non sarebbe più possibile accedervi.

Al momento (8 dicembre 2020) abbiamo creato questi elenchi di documenti:

- gli [**Indicatori Monitoraggio della Fase 2**](https://ondata.github.io/datiBeneComuneMonitoraggio/catalogo/indicatori/output/indicatori) ([qui](https://ondata.github.io/datiBeneComuneMonitoraggio/catalogo/indicatori/output/indicatori.csv) l'elenco in `CSV`);
- i [**Bolletini sorveglianza integrata**](https://ondata.github.io/datiBeneComuneMonitoraggio/catalogo/sorveglianzaIntegrata/output/sorveglianzaIntegrata) ([qui](https://ondata.github.io/datiBeneComuneMonitoraggio/catalogo/sorveglianzaIntegrata/output/sorveglianzaIntegrata.csv) l'elenco in `CSV`);
- i [**Report settimanali regionali**](https://ondata.github.io/datiBeneComuneMonitoraggio/catalogo/monitoraggioSettimanale/output/monitoraggioSettimanale) ([qui](https://ondata.github.io/datiBeneComuneMonitoraggio/catalogo/monitoraggioSettimanale/output/monitoraggioSettimanale.csv) l'elenco in `CSV`).

Di ognuno dei file in questi elenchi viene fatta automaticamente **copia** su [**Internet Archive**](https://archive.org/) (il più famoso archivio digitale dei contenuti web), tramite questo [*script*](https://github.com/ondata/datiBeneComuneMonitoraggio/blob/main/script/webarchive.sh).<br>
Quindi ad esempio se il file <http://www.salute.gov.it/imgs/C_17_notizie_5196_1_file.pdf> dovesse non essere più presente sul sito del Ministero della Salute, sarà accessibile nella sua versione su IA:<br>
<https://web.archive.org/web/*/http://www.salute.gov.it/imgs/C_17_notizie_5196_1_file.pdf>

Alcune note:

- l'interfaccia è a una sua prima versione, senza la possibilità ad esempio di applicare filtri e/o ordinare questi elenchi. Se vuoi dare una mano, questi elenchi sono a disposizione;
- l'aggiornamento di questi elenchi è automatico. Qualche volte potrebbe non andare a buon fine e/o non essere fatto al meglio. Se hai qualche suggerimento, apri per favore una issue [qui](https://github.com/ondata/datiBeneComuneMonitoraggio/issues/new);
- l'elenco dei documenti nelle varie categorie non è ancora completo;
- se ci sono altri tipi di documenti, di cui pensi sia importante creare un indice e a cascata una copia di archivio, scrivicelo in una issue [qui](https://github.com/ondata/datiBeneComuneMonitoraggio/issues/new).
