window.onload = function () {
    //
    LoadingClose();
    _Controller = "Evaluacion";
    //
    Load();
    Events();
}

function Load() {
    var url = _Areas.Convocatorias.Url + _Controller + "ListarInicial";
    Http.get(url, Load_Response);
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

function Events() {

}