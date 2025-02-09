var gIdPersona = "";
var gGender = "";
window.onload = function () {
    _Load.Close();
    _Usuario = sessionStorage.getItem("JUsuario").split(_sepFields);
    _Area = "Personal"
    _Controller = "Persona"
    _Url = _Area + "/" + _Controller + "/";
    setEvents();
    ListaPersona();
}

function setEvents() {
    btnAgregar.onclick = function () {
        CardUser.classList.remove("gz-hide");
    }

    btnCancelar.onclick = function () {
        CardUser.classList.add("gz-hide");
    }

    btnGuardar.onclick = function () {
        if (!Valida.ValidarDatos("R")) {
            Notify.Show('e', 'Debe llenar campos requeridos (*)');
            return;
        }
        if (gIdPersona) {
            let text = "¿Está seguro(a) que desea actualizar el registro?";
            new oDialog(text,
                {
                    title: 'Persona - Modificar',
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

function ListaPersona() {
    Http.get(_Url + "ListaPersona", mostrarLista);
}

function mostrarLista(rpta) {
    if (rpta) {
        var Lista = rpta.split(_sepTables);
        var ListaTab = Lista[0].split(_sepRows);
        var ListaCombo = Lista[1].split(_sepRows);
        var ListGenero = Lista[2].split(_sepRows);

        UI.Combo(cboTipoPersona, ListaCombo, 0);
        UI.Combo(cboGenero, ListGenero, 0);


        var opts = {
            Id: "Persona",
            DataTable: ListaTab,
            RowsForPage: 10,
            ReportTitle: "Lista Persona",
            HasEdit: true,
            HasDelete: true,
            HasExport: true
        }
        UI.Grid(divPersona, opts);
    }
}

function Grabar() {
    var data = gIdPersona + "|" +  Tools.ObtenerDatos("G");
    var frm = new FormData();
    frm.append("Data", data);
    Http.post(_Url + "GrabaPersona", rptaGrabar, frm);
}

function rptaGrabar(rpta) {
    if (rpta.includes("Duplicado")){
        Notify.Show('e', 'DNI ya existe');
        return;
    }
    else {
        var list = rpta.split(_sepTables);
        if (list.includes("KO")) {
            Notify.Show('e', list[0].split('|')[1]);
            return;
        }
        var listPer = list[2] + _sepTables + list[3] + _sepTables + list[4];
        mostrarLista(listPer);
        LimpiaControl();
        _Accion == _Actions.Delete ? Notify.Show('s', 'Registro eliminado') : Notify.Show('s', 'Registro guardado');
        CardUser.classList.add("gz-hide");
        _Accion = "";
    }
}

function editarRegistro(id, cod, btn) {
    gIdPersona = cod;
    Http.get(_Url + "ObtenerPersona?PersonaId=" + cod, mostrarPersona);
}

function eliminarRegistro(id, cod, fila) {
    let text = "¿Está seguro(a) que desea eliminar el registro?"
    new oDialog(text, {
        title: _Controller + ' - ' + 'Eliminar',
        positive: {
            text: 'Aceptar',
            action: function () {
                _Accion = _Actions.Delete;
                Http.get(_Url + "EliminarPersona?PersonaId=" + cod, rptaGrabar);
            }
        },
        negative: {
            text: 'Cancelar'
        },
        animate: oDialog.ANIMATE.FADE
    }).show();
}

function mostrarPersona(rpta) {
    if (rpta) {
        var data = rpta.split(_sepFields);
        LimpiaControl();
        Tools.MostrarDatos("O", data);
        CardUser.classList.remove("gz-hide");
    }
}

function LimpiaControl() {
    txtNudocumento.value = "";
    txtNombre.value = "";
    txtApePaterno.value = "";
    txtApeMaterno.value = "";
    txtTelefono.value = "";
    txtCorreo.value = "";
    txtDireccion.value = "";
}
