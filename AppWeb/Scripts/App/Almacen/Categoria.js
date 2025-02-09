var gIdCategoria;

window.onload = function () {
    _Load.Close();
    _Usuario = sessionStorage.getItem("JUsuario").split(_sepFields);
    _Area = "Almacen"
    _Controller = "Almacen"
    _Url = _Area + "/" + _Controller + "/";
    setEvents();
    ListaCategoria();
}

function setEvents() {
    btnGuardar.onclick = function () {
        if (!Valida.ValidarDatos("R")) {
            Notify.Show('e', 'Debe llenar campos requeridos (*)');
            return;
        }
        if (gIdCategoria) {
            let text = "¿Está seguro de actualizar el registro?";
            new oDialog(text,
                {
                    title: 'Categoria - Modificar',
                    positive: {
                        text: 'Aceptar',
                        action: function () {
                            Grabar();
                        }
                    },
                    negative: {
                        text: 'Cancelar',
                    },
                    animate: oDialog.ANIMATE.FADE
                }).show();
        }
        else {
            Grabar();
        }
    }
}

function ListaCategoria() {
    Http.get(_Url + "ListaCategoria", mostrarPagina);
}

function Grabar() {
    var data = gIdCategoria + '|' + GUI.ObtenerDatos("G");
    var frm = new FormData();
    frm.append("Data", data);
    Http.post(_Url + "GrabaCategoria", RespuestaGrabar,frm);
}

function RespuestaGrabar(rpta) {
    if (rpta.includes('Duplicado')) {
        Notify.Show('e', 'Nombre de Categoria ya existe');
    }
    else {
        LimpiaControl();
        Notify.Show('s', 'Registro guardado');
        ListaCategoria();        
    }
}

function LimpiaControl() {
    txtNombre.value = "";
    txtDescripcion.value = "";
    spnCategoriaId.innerHTML = "";
    //btnActivo.value = 0;
}

function mostrarPagina(rpta) {
    if (rpta) {
        var lista = rpta.split("¬");

        var opts = {
            Id: "Categoria",
            DataTable: lista,
            RowsForPage: 10,
            ReportTitle: "Lista Categoria",
            HasEdit: true,
            HasDelete: true,
            ColorIndex: [{
                index: 4,
                condition: `Activo|${_Estados.Aprobado}^Inactivo|${_Estados.Rechazado}`
            }],
            HasExport: true
        }
        UI.Grid(divCategoria, opts);
    }
    LimpiaControl();
    _Load.Close();
}

function editarRegistro(id, cod, btn) {
    if (id == "Categoria") {
        LimpiaControl();
        gIdCategoria = cod;
        Http.get(_Url + "CategoriaPorId?CategoriaId=" + cod, ObtenerCategoria);
    }
}

function ObtenerCategoria(rpta) {
    if (rpta) {
        var campos = rpta.split("|");
        UI.MostrarDatos("O", campos);
    }
}

