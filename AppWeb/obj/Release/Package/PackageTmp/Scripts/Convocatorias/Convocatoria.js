var gePlazaVacante;
//
window.onload = function () {
    //
    LoadingClose();
    _Url = _Areas.Convocatorias.Url + "Convocatoria" + "/";
    //
    gePlazaVacante = hdPlazaVacante.value;
    //
    Load();
    Events();
}

function Events() {
    btnCerrar.onclick = function () { _Content.src = "/" + _Url + "Index"; }
}

function Load() {
    Notify.Show('d', gePlazaVacante);
    var iUrl = _Url + "ListarPorId?pData=" + gePlazaVacante;
    Http.get(iUrl, Load_Response);
}
function Load_Response(pRpta) {
    if (pRpta) {
        var iData = (gePlazaVacante + "|" + pRpta).split("|");
        //
        Tools.MostrarDatos("O", iData);
        //
        if (iData[3].includes('PROCESO')) {
            spnEstado.classList.add('bg-pendiente');
        }
        else if (iData[3].includes('CANCELADO'))
        {
            spnEstado.classList.add('bg-cancelado');
        }
        else if (iData[3].includes('DESIERTO'))
        {
            spnEstado.classList.add('bg-desierto');
        }
        else {
            spnEstado.classList.add('bg-secondary');
        }
        var iValor = lbl_FuncionesActividades.innerText.replace("&#x0D;", "");
        lbl_FuncionesActividades.innerText = iValor;
        //
    }
}