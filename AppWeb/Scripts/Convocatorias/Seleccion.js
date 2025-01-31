window.onload = function () {
    //
    LoadingClose();
    _Url = _Areas.Convocatorias.Url + "Seleccion" + "/";
    //
    Load();
    setEvents();
}

function Load() {
    var iUrl = _Areas.Convocatorias.Id + "ListarInicial";
    Http.get(iUrl, Load_Response);
}
function Load_Response(rpta) {
    if (rpta) {
        var iData = rpta.split("~");
        var iListPeriodos = iData[0].split("¬");
        var iListTipos = iData[1].split("¬");
        //
        UI.Combo(cboPeriodo, iListPeriodos, 0);
        UI.Combo(cboTipoProceso, iListTipos, 0, '--');
        //
        cboPeriodo.selectedIndex = 0;
        cboTipoProceso.selectedIndex = 0;
    }
}

function setEvents() {
    cboPeriodo.onchange = cboTipoProceso.onchange = function () {
        GetProcesos();
    }
    cboProceso.onchange = function () {
        GetPlazas();
    }
    cboPlazas.onchange = function () {
        GetEtapas();
    }
    cboEtapas.onchange = function () {
        GetPostulantes();
    }
}



function GetProcesos() {
    var iPeriodo = cboPeriodo.value;
    var iTipo = cboTipoProceso.value;
    var iUrl = _Url + "ListarProcesos?pPeriodo=" + iPeriodo + "&pTipo=" + iTipo;
    Http.get(iUrl, RptaGetProcesos);
}
function RptaGetProcesos(rpta) {
    if (rpta) {
        var iData = rpta.split("¬");
        UI.Combo(cboProceso, iData, 0, '--');
        spNroProcesos.innerText = " ( N° de registros : " + iData.length.toString() + " ) ";
        //
        var iListNulo = [];
        UI.Combo(cboPlazas, iListNulo, 0, '--');
        spNroPlazas.innerText = "";
        UI.Combo(cboEtapas, iListNulo, 0, '--');
        spNroEtapas.innerText = "";
        //
    }
}

function GetPlazas() {
    var iProceso = cboProceso.value;
    var iUrl = _Url + "ListarPlazas?pNroProceso=" + iProceso;
    Http.get(iUrl, RptaGetPlazas);
}
function RptaGetPlazas(rpta) {
    if (rpta) {
        var iData = rpta.split("¬");
        UI.Combo(cboPlazas, iData, 0, '--');
        spNroPlazas.innerText = " ( N° de registros : " + iData.length.toString() + " ) ";
        var iListNulo = [];
        UI.Combo(cboEtapas, iListNulo, 0, '--');
        spNroEtapas.innerText = "";
    }
}

function GetEtapas() {
    var iPlaza = cboPlazas.value;
    var iUrl = _Url + "ListarEtapas?pNroPlaza=" + iPlaza;
    Http.get(iUrl, RptaGetEtapas);
}
function RptaGetEtapas(rpta) {
    if (rpta) {
        var iData = rpta.split("¬");
        UI.Combo(cboEtapas, iData, 0, '--');
        spNroEtapas.innerText = " ( N° de registros : " + iData.length.toString() + " ) ";
    }
}



function GetPostulantes() {
    var iEtapa = cboEtapas.value;
    var url = _Url + "ListarPostulantes?pNroProcEtapa=" + iEtapa;
    Http.get(url, ShowPostulantes);
}
function ShowPostulantes(rpta) {
    if (rpta) {
        var listas = rpta.split("~");
        var iListData = listas[0].split("¬");
        //
        var iOpts = {
            Id: "Postulantes"
            , DataTable: iListData
            , RowsForPage: 30
            , ReportTitle: "Lista de Postulantes"
        }
        //
        UI.Grid(divPrincipal, iOpts);
    }
}
