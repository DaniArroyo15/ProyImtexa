
var gUpLoad;
var g

window.onload = function () {
    _Load.Close();
    _Usuario = sessionStorage.getItem("JUsuario").split(_sepFields);
    _Area = "Almacen"
    _Controller = "Producto"
    _Url = _Area + "/" + _Controller + "/";
    CargaCombo();
    setEvents();
    ModalGet();
}

function setEvents() {
    cboCategoria.onchange = function () {
        ListaProducto();
    }

    btnCerrar.onclick = function () {
        divPopupContainer.style.display = "none";
    }

    btnGrabar.onclick = function () {
        if (!Valida.ValidarDatos("R", "N")) {
            Notify.Show('e', 'Campos con borde rojo son obligatorios');
            return;
        }
        if (_Accion == _Actions.Modify) {
            let text = "¿Está seguro(a) que desea actualizar el registro?";
            new oDialog(text, {
                title: _Controller + ' - confirmar',
                positive: {
                    text: 'Aceptar',
                    action: function () {
                        SaveProducto();
                    }
                },
                negative: {
                    text: 'Cancelar',
                },
                animate: oDialog.ANIMATE.FADE
            }).show();
        }
        if (_Accion == _Actions.Add) SaveProducto();
    }
}

function ModalGet() {
    Modal.Show(_Area, _Controller, function () { }, 70, 70);
}

function ModalShow(accion) {
    spnBarraTitulo.innerText = _Controller + " - " + accion;
    divPopupContainer.style.display = "inline";
    Tools.LimpiarDatos("O1");
    ModalEvents();
    chkEstado.onchange = function () {
        ModalEvents();
    }
}

function ModalEvents() {
    lblEstado.innerText = chkEstado.checked ? "VENDIDO" : "DISPONIBLE";
}

function SaveProducto() {
    var data = Tools.ObtenerDatos("G");
    var frm = new FormData();
    frm.append("Data", data);
    Http.post(_Url + "GrabaProducto", SaveResponse, frm);
}

function SaveResponse(rpta) {
    if (rpta) {
        var List = rpta.split(_sepTables);
        if (List[0].includes('KO')) {
            Notify.Show('e', List[0].split('|')[1]);
            return;
        }
        var listProd = List[2];
        btnCerrar.click();
        mostrarLista(listProd);
        if (_Accion == _Actions.Add || _Accion == _Actions.Modify) {
            Notify.Show('s', 'Registro guardado');
        }
        else { Notify.Show('s', 'Registro eliminado'); }
        _Accion = "";
    }
}

function CargaCombo() {
    Http.get(_Url + "ListaCategoria", muestraCategoria);
}

function muestraCategoria(rpta) {
    if (rpta) {
        var ListCate = rpta.split(_sepRows);
        UI.Combo(cboCategoria, ListCate, 0);

        cboCategoria.selectedIndex = 0;

        /*Combo popup*/
        UI.Combo(cboTipCategoria, ListCate, 0);

        cboTipCategoria.selectedIndex = 0;

        var event = new Event('change');
        cboCategoria.dispatchEvent(event);
    }
}

function ListaProducto() {
    var iCategoria = cboCategoria.value === "" ? "1" : cboCategoria.value;
    Http.get(_Url + "ListaProducto?CategoriaId=" + iCategoria, mostrarLista);
}

function mostrarLista(rpta) {
    if (rpta) {
        var Lista = rpta.split(_sepTables);
        var ListaTab = Lista[0].split(_sepRows);

        var opts = {
            Id: _Controller,
            DataTable: ListaTab,
            RowsForPage: 10,
            ReportTitle: "Lista Producto",
            HasNew: true,
            HasEdit: true,
            HasDelete: true,
            ColorIndex: [{
                index: 8,
                condition: `DISPONIBLE|${_Estados.Aprobado}^VENDIDO|${_Estados.Rechazado}`
            }],
            HasExport: true,
            Import: { Enabled: true, Function: 'Importar' }
        }
        UI.Grid(divProducto, opts);

        gUpLoad = document.getElementById("upFile" + _Controller);
    }
}

function nuevoRegistro() {
    _Accion = _Actions.Add;
    ModalShow("Nuevo");
}

function editarRegistro(id, cod, btn) {
    _Accion = _Actions.Modify;
    ModalShow("Modificar");
    Http.get(_Url + "ListaProductoId?ProductoId=" + cod, muestraProducto);
}

function eliminarRegistro(id, cod, fila) {
    let text = "¿Está seguro(a) que desea eliminar el registro?"

    new oDialog(text, {
        title: _Controller + ' - ' + 'Eliminar',
        positive: {
            text: 'Aceptar',
            action: function () {
                _Accion = _Actions.Delete;
                Http.get(_Url + "EliminaProducto?ProductoId=" + cod, SaveResponse);
            }
        },
        negative: {
            text: 'Cancelar',
        },
        animate: oDialog.ANIMATE.FADE
    }).show();
}

function muestraProducto(rpta) {
    if (rpta) {
        var data = rpta.split(_sepFields);
        Tools.MostrarDatos("O1", data);

        var event = new Event('change');
        chkEstado.dispatchEvent(event);
    }
}

function Importar() {

    gUpLoad.click();

    gUpLoad.onchange = function () {
        file = this.files[0];
        var frm = new FormData();
        frm.append("file", file);
        Http.post("General/Importar?pTabla=" + _Controller, GetGrabarFile, frm);
    }
}

function GetGrabarFile(rpta) {
    if (rpta) {
        var list = rpta.split(_sepTables);
        var listProduct = list[2];
        mostrarLista(listProduct);
        Notify.Show('s', 'Data importada');
    }
}

