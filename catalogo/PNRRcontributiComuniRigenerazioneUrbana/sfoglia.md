# Contributi ai Comuni per investimenti di rigenerazione urbana anni 2021-2026 (PNRR)

<a href="https://www.datibenecomune.it/" target="_blank"><img src="https://img.shields.io/badge/%F0%9F%99%8F-%23datiBeneComune-%23cc3232"/></a>

## Introduzione


Il **30 dicembre 2021** è stata pubblicato il decreto relativo ai "**Contributi ai Comuni** da destinare a **investimenti** in progetti di **rigenerazione urbana anni 2021-2026**":<br>
<https://dait.interno.gov.it/finanza-locale/documentazione/decreto-30-dicembre-2021>.


Sono i contributi del Piano Nazionale di Ripresa e Resilienza (**PNRR**) e in particolare quelli della Missione 5 “**Inclusione e Coesione**”, Componente 2 “Infrastrutture sociali, famiglie, comunità e terzo settore”, Investimento 2.1 “Investimenti in progetti di rigenerazione urbana, volti a ridurre situazioni di emarginazione e degrado sociale”.

Le informazioni sui contributi di questo decreto sono **pubblicate come PDF** e **non come dati** *machine readable*. Abbiamo convertito i PDF in dati ([qui](https://github.com/ondata/datiBeneComuneMonitoraggio/blob/main/catalogo/PNRRcontributiComuniRigenerazioneUrbana/README.md) i dettagli) e da questi è stata creata una **visualizzazione interattiva numerica informativa**.

## I numeri

<div id="observablehq-viewof-Reg-cad9fe1c"></div>
<div id="observablehq-viewof-Prov-cad9fe1c"></div>
<div id="observablehq-testo-cad9fe1c"></div>
<div id="observablehq-lista-cad9fe1c"></div>


<script type="module">
import {Runtime, Inspector} from "https://cdn.jsdelivr.net/npm/@observablehq/runtime@4/dist/runtime.js";
import define from "https://api.observablehq.com/@aborruso/contributi-pnrr-rigenerazione-urbana.js?v=3";
new Runtime().module(define, name => {
  if (name === "lista") return new Inspector(document.querySelector("#observablehq-lista-cad9fe1c"));
  if (name === "testo") return new Inspector(document.querySelector("#observablehq-testo-cad9fe1c"));
  if (name === "viewof Prov") return new Inspector(document.querySelector("#observablehq-viewof-Prov-cad9fe1c"));
  if (name === "viewof Reg") return new Inspector(document.querySelector("#observablehq-viewof-Reg-cad9fe1c"));
  return ["listaComuni","listaContributi","totaleProvincia","comuniSelezionati","listaProv","totaleRegione","percentualeReg"].includes(name);
});
</script>
