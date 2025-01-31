var gIdProceso;
//
window.onload = function () {
    //
    LoadingClose();
    _Url = _Areas.Convocatorias.Url + "Convocatoria" + "/";
    //
    Load();
    Events();
}

function Events() {
    cboPeriodo.onchange = cboTipoProceso.onchange = cboEstado.onchange = function () {
        GetConvotarias();
    }
}

function Load() {
    var iUrl = _Areas.Convocatorias.Id + "ListarInicial";
    Http.get(iUrl, Load_Response);
}
function Load_Response(pRpta) {
    if (pRpta) {
        var iData = pRpta.split("~");
        var iListPeriodos = iData[0].split("¬");
        var iListTipos = iData[1].split("¬");
        var iListEstados = iData[2].split("¬");
        //
        UI.Combo(cboPeriodo, iListPeriodos, 0);
        UI.Combo(cboTipoProceso, iListTipos, 0, '- Todos -');
        UI.Combo(cboEstado, iListEstados, 0, '- Todos -');
        //
        cboPeriodo.selectedIndex = 0;
        cboTipoProceso.selectedIndex = 0;
        cboEstado.selectedIndex = 0;
        //
        GetConvotarias();
    }
}

function GetConvotarias() {
    Loading();
    var iPeriodo = cboPeriodo.value;
    var iTipo = cboTipoProceso.value;
    var iEstado = cboEstado.value;
    var iUrl = _Url + "ListarPrincipal?pPeriodo=" + iPeriodo + "&pTipo=" + iTipo + "&pEstado=" + iEstado;
    Http.get(iUrl, GetConvotarias_Response);
}
function GetConvotarias_Response(pRpta) {
    if (pRpta) {
        var listas = pRpta.split("~");
        var iListData = listas[0].split("¬");
        //
        var iOpts = {
            Id: "Convocatorias"
            , DataTable: iListData
            , RowsForPage: 15
            , ReportTitle: "Lista de Convocatorias"
            , HiddenColumns: [{ index: 10 }]
            , ColorIndex: [{
                index: 9,
                condition: `CONCLUIDO|${_Estados.Aprobado}^EN PROCESO|${_Estados.Pendiente}^DESIERTO|${_Estados.Rechazado}`
            }]
            , HasExport: true
            , NotExportIndex: '10'
            , GridButtons: [{ cabecera: '', icono: 'fa fa-eye', titulo: 'Ver' }]
        }
        //
        UI.Grid(divPrincipal, iOpts);
    }
    LoadingClose();
}

function recargarGrilla(id) {
    GetConvotarias();
}
function seleccionarBoton(idGrilla, idRegistro, innerText) {
    gIdProceso = idRegistro;
    Loading();
    var iDatos = innerText;
    window.parent.document.getElementById('ifrPagina').src = "/" + _Url + "Convocatoria?pPlazaVacante=" + iDatos[10];
}