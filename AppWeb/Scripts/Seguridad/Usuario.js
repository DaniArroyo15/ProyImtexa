
window.onload = function () {
    _Load.Close();
    _Usuario = sessionStorage.getItem("JUsuario").split(_sepFields);
    _Area = "Seguridad"
    _Controller = "Usuarios"
    _Url = _Area + "/" + _Controller + "/";
    setEvents();
    ListaUsuarios();
    ModalGet();
}

function setEvents() {

    btnCerrar.onclick = function () {
        divPopupContainer.style.display = "none";
    }

    btnGrabar.onclick = function () {
        if (!Valida.ValidarDatos("R", "N")) {
            Notify.Show('e', 'Campos con borde rojo son obligatorios');
            return;
        }
        if (_Accion == _Actions.Modify) {
            let text = "¿Está seguro(a) de actualizar el registro?";
            new oDialog(text, {
                title: _Controller + ' - confirmar',
                positive: {
                    text: 'Aceptar',
                    action: function () {
                        SaveUsuario();
                    }
                },
                negative: {
                    text: 'Cancelar'
                },
                animate: oDialog.ANIMATE.FADE
            }).show();
        }
        if (_Accion == _Actions.Add) { SaveUsuario();}
    }
}

function ModalGet() {
    Modal.Show(_Area, _Controller, function () { }, 70, 70);
}

function ModalShow(accion) {
    spnBarraTitulo.innerText = _Controller + " - " + accion;
    divPopupContainer.style.display = "inline";
    Tools.LimpiarDatos("G");
    ModalEvents();
    chkEstado.onchange = function () {
        ModalEvents();
    }
}

function ModalEvents() {
    lblEstado.innerText = chkEstado.checked ? "ACTIVO" : "INACTIVO";
}

function ListaUsuarios() {
    Http.get(_Url + "Principal", rptaUsuarios);
}

function rptaUsuarios(rpta) {
    if (rpta) {
        var lista = rpta.split(_sepTables);
        var ListUsu = lista[0].split(_sepRows);
        var ListPer = lista[1].split(_sepRows);


        UI.Combo(cboPersona, ListPer, 0);

        var opts = {
            Id: "Usuario",
            DataTable: ListUsu,
            RowsForPage: 10,
            ReportTitle: "Lista Usuario",
            HasEdit: true,
            HasDelete: true,
            HasExport: true,
            HasNew: true,
            ColorIndex: [{
                index: 3,
                condition: `Activo|${_Estados.Aprobado}^Inactivo|${_Estados.Rechazado}`
            }]
        }
        UI.Grid(divUsuario, opts);
    }
}

function SaveUsuario() {
    var data = Tools.ObtenerDatos("G");
    var frm = new FormData();
    frm.append("Data", data);
    Http.post(_Url + "GrabaUsuario", SaveResponse,frm);
}

function SaveResponse(rpta) {
    if (rpta) {
        var msg = rpta.split(_sepTables);
        if (msg[0].includes('Duplicate')) {
            Notify.Show('e', 'Nombre de usuario ya existe');
            return;
        }
        if (msg[0].includes('KO')) {
            Notify.Show('e', msg[0].split(_sepFields)[1]);
            return;
        }
        var ListUser = msg[2] + _sepTables + msg[3];
        btnCerrar.click();
        rptaUsuarios(ListUser);
        if (_Accion == _Actions.Add || _Accion == _Actions.Modify) {
            Notify.Show('s', 'Registro guardado');
        }
        else { Notify.Show('s', 'Registro eliminado'); }

        _Accion = "";
    }
}

function nuevoRegistro() {
    _Accion = _Actions.Add;
    ModalShow("Nuevo");
}

function editarRegistro(id, cod, btn) {
    _Accion = _Actions.Modify;
    ModalShow("Modificar");
    Http.get(_Url + "ObtenerUsuario?UsuarioId=" + cod, muestraUsuario);
}

function eliminarRegistro(id, cod, fila) {
    let text = "¿Está seguro(a) que desea eliminar el registro?"

    new oDialog(text, {
        title: _Controller + ' - ' + 'Eliminar',
        positive: {
            text: 'Aceptar',
            action: function () {
                _Accion = _Actions.Delete;
                Http.get(_Url + "EliminaUsuario?UsuarioId=" + cod, SaveResponse);
            }
        },
        negative: {
            text: 'Cancelar',
        },
        animate: oDialog.ANIMATE.FADE
    }).show();
}

function muestraUsuario(rpta) {
    if (rpta) {
        var campos = rpta.split(_sepFields);
        Tools.MostrarDatos("O", campos);

        var event = new Event('change');
        chkEstado.dispatchEvent(event);
    }
}

