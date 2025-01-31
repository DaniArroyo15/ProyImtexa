//
var gUpLoad;
//
window.onload = function () {
    _Load.Close();
    //
    _Area = "Almacen";
    _Controller = "Categoria";
    _PageName = "Categorias";
    _Url = _Area + "/" + _Controller + "/";
    //
    PageLoad();
    PageEvents();
    ModalsGet();
}

function PageLoad() {
    PrincipalGet();
}
function PageEvents() {
    btnCerrar.onclick = function () {
        divPopupContainer.style.display = "none";
    }
    btnGrabar.onclick = function () {

        if (!Valida.ValidarDatos("R", "N")) {
            Notify.Show('e', 'Campos con borde rojo son obligatorios');
            return;
        }
        if (_Accion == _Actions.Modify) { 
            let text = "¿Seguro(a) que desea actualizar el registro?";
            new CustomDialog(text,
                {
                    title: _PageName + ' - Confirmar',
                    positive: {
                        text: 'Aceptar',
                        action: function () {
                            Save();
                        }
                    },
                    negative: {
                        text: 'Cancelar',
                    },
                    animate: CustomDialog.ANIMATE.FADE
                }).show();
        }
        if (_Accion == _Actions.Add) Save();
    }
}

function ModalsGet() {
    Modal.Show(_Area
        , _Controller
        , function () { }
        , 70
        , 70);
}
function ModalsShow(accion) {
    spnBarraTitulo.innerText = _PageName + " - " + accion
    divPopupContainer.style.display = "inline";
    Tools.LimpiarDatos("O");
    ModalsEvents();
}
function ModalsEvents() {
    fsChekEstado.onclick = function () {
        if (fsChekEstado.checked == false) lblEstado.innerText = 'Inactivo';
        if (fsChekEstado.checked == true) lblEstado.innerText = 'Activo';
    }
}

function PrincipalGet() {
    var url = _Url + "List";
    Http.get(url, PrincipalShow);
}
function PrincipalShow(rpta) {
    if (rpta) {
        var iList = rpta.split("¬");
        //
        var iOpts = {
            Id: _Controller
            , DataTable: iList
            , ReportTitle: _PageName
            , RowsForPage: 15
            , HiddenId: true
            , Import: { Enabled: true, Function: 'Importar' }
            , HasExport: true
            , HasEdit: true
            , HasDelete: true
            , HasNew: true
            , ColorIndex: [
                {
                    index: 4,
                    condition: `Inactivo|${_Estados.Rechazado}^Activo|${_Estados.Aprobado}`
                },
            ]
        }
        //
        UI.Grid(divPrincipal, iOpts);
        gUpLoad = document.getElementById("upFile" + _Controller);
    }
}


function Save() {
    var data = Tools.ObtenerDatos("G");
    var frm = new FormData();
    frm.append("Data", data);
    Http.post(_Url + _Accion, SaveResponse, frm);
}
function SaveResponse(rpta) {
    //
    if (rpta) {
        var listas = rpta.split('~');
        //
        if (listas[0].includes('KO')) {
            Notify.Show('e', listas[0].split('|')[1]);
            return;
        }
        //
        btnCerrar.click();
        PrincipalShow(listas[2]);
        Notify.Show('s', listas[0].split('|')[1]);
        _Accion = "";
    }
}

function nuevoRegistro(id) {
    _Accion = _Actions.Add;
    ModalsShow("Agregar");
}
function editarRegistro(id, cod, btn) {
    _Accion = _Actions.Modify;
    ModalsShow("Modificar");
    var url = _Url + "ListId?pId=" + cod;
    Http.get(url, function (rpta) {
        if (rpta) {
            var campos = rpta.split('|');
            Tools.MostrarDatos("O", campos);
        }
    });
}

function eliminarRegistro(id, cod, fila) {
    let text = "¿Seguro(a) que desea eliminar el registro?";
    new oDialog(text,
        {
            title: _PageName + ' - Confirmar',
            positive: {
                text: 'Aceptar',
                action: function () {
                    _Accion = _Actions.Delete;
                    Http.get(_Url + _Accion + "?pData=" + cod, SaveResponse);
                }
            },
            negative: {
                text: 'Cancelar',
            },
            animate: oDialog.ANIMATE.FADE
        }).show();
}

function recargarGrilla() { PrincipalGet(); }
function seleccionarFila(id, idRegistro, fila) { }

function Importar() {
    gUpLoad.click();

    gUpLoad.onchange = function () {
        file = this.files[0];
        var frm = new FormData();
        frm.append("file", file);
        Http.post("General/Importar?pTabla=" + _PageName, ImportResponse, frm);
    }
}

function ImportResponse(rpta) {
    if (rpta) {
        var listas = rpta.split('~');
        //
        if (listas[0].includes('KO')) {
            Notify.Show('e', listas[0].split('|')[1]);
            return;
        }
        PrincipalShow(listas[2]);
        Notify.Show('s', listas[0].split('|')[1]);
    }
}