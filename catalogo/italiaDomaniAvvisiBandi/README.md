# I bandi e gli avvisi pubblicati su Italia Domani

[**Italia Domani**](https://italiadomani.gov.it/) è il sito ufficiale dedicato al Piano Nazionale Ripresa e Resilienza (PNRR).<br>
Contiene una sezione "[**Bandi e avvisi**](https://italiadomani.gov.it/it/bandi-e-avvisi.html)" che al momento ha delle criticità:

- è disponibile **soltanto** come pagina **HTML**, quindi per essere guardata a schermo;
- gli avvisi e i bandi sono **ordinati** di *default* **per nome** del bando e **non per data** (dal più recente al meno recente);
- non c'è un meccanismo per **iscriversi** agli **avvisi** (un feed RSS ad esempio);
- non c'è un **archivio** in formato ***machine readable***.

È stato creato uno script che ogni giorno verifica se ci sono aggiornamenti e produce:

1. un **feed RSS** <https://feeds.feedburner.com/bandi_avvisi_italiadomani_pnrr>;
2. l'**archivio** in [formato CSV](https://github.com/ondata/datiBeneComuneMonitoraggio/blob/main/catalogo/italiaDomaniAvvisiBandi/output/italiaDomaniAvvisi_archivio.csv) e [JSON](https://github.com/ondata/datiBeneComuneMonitoraggio/blob/main/catalogo/italiaDomaniAvvisiBandi/output/italiaDomaniAvvisi_archivio.json) di quanto pubblicato nella sezione.

## Come rimanere aggiornati

La modalità più comoda in termini di opzioni è il feed RSS. Se non sai come usarlo, trovi [decine di guide online](https://www.google.com/search?q=come+leggere+un+feed+rss&rlz=1C1GCEA_enIT905IT905&oq=come+leggere+un+feed+rss&aqs=chrome..69i57j33i22i29i30l3.5547j0j7&sourceid=chrome&ie=UTF-8).<br>
A partire da un feed RSS puoi anche ricevere un avviso in chat, per email, per SMS, ecc..

Se vuoi ricevere un'email per ogni aggiornamento, puoi usare [questo modulo](https://feedburner.google.com/fb/a/mailverify?uri=bandi_avvisi_italiadomani_pnrr&loc=en_US).

## Nota

Questo non è un servizio ufficiale. Se il sito di Italia Domani verrà modificato, questo aggiornamento giornaliero potrebbe non funzionare più.

