var _HomeSection = "";
var gTipoArchivo = "";

window.onload = function () {
    //
    var iSesionUser = sessionStorage.getItem("JUsuario");
    if (!iSesionUser) {
        window.location.href = hdfRaiz.value + "Login/SignIn";
        return;
    }
    //
    _Raiz = hdfRaiz.value;
    _Usuario = iSesionUser.split('|');
    sessionStorage.setItem('JContent', ifrPagina);
    //
    var iNombre = primeraLetra(_Usuario[0].toLowerCase());
    var iApellido = primeraLetra(_Usuario[1].toLowerCase());
    oNombre.innerHTML = iNombre;
    oApellido.innerHTML = iApellido;
    //
    Http.get("Home/GetMenu", function (rpta) {
        if (rpta) {
            if (rpta.includes('KO|')) {
                Notify.Show("i", rpta.split('|')[1]);
                sessionStorage.clear();
                window.location.href = hdfRaiz.value + "Login/SignOut";
                return;
            }
            lista = rpta.split("¬");
            UI.Menu(lista);
            delete lista;
        }
    });

    //Http.getBytes("General/GetAvatar", function (rpta) {
    //    if (rpta) {
    //        var blob = new Blob([rpta], { 'type': "image/jpg" });
    //        imgAvatar.src = URL.createObjectURL(blob);
    //    }
    //});

    setEvents();
}


function setEvents() {

    btnCerrarVisor.onclick = function () {
        divVisorContainer.style.display = "none";
    }

    btnHelp.onclick = function () {
        var iValue = hdfHelp.value || '';
        const iPDF = _PDFHelp.filter(x => x.Pantalla == iValue);
        if (iPDF.length == 0) {
            Notify.Show('i', 'Esta pantalla no tiene sección de ayuda');
            return;
        }
        MostrarManual(iPDF[0].Manual, iPDF[0].Controller);
    }


    btnFullScreen.onclick = function () {
        if (!document.fullscreenElement) {
            document.documentElement.requestFullscreen();
        } else {
            if (document.exitFullscreen) {
                document.exitFullscreen();
            }
        }
    }

    btnSignOut.onclick = function () {
        let text = `¿Seguro(a) que desea salir del sistema?`;
        new oDialog(text,
            {
                title: 'IMTEXA - Cerrar Sesión',
                positive: {
                    text: 'Aceptar',
                    action: function () {
                        sessionStorage.clear();
                        window.location.href = hdfRaiz.value + "Login/SignOut?pData=Salió del Sistema" ;
                    }
                },
                negative: {
                    text: 'Cancelar',
                },
                animate: oDialog.ANIMATE.FADE
            }).show();
    }
}


function primeraLetra(str) {
    return str[0].toUpperCase() + str.slice(1);
}


function MostrarManual(pValor, pController) {
    var url = "General/ObtenerManual?pNombre=" + pValor + "&pController=" + pController;
    gTipoArchivo = FileSystem.getMime(pValor);
    Http.getBytesBlob(url, ShowModalVisor)
}
function ShowModalVisor(rpta) {
    if (rpta.size > 0) {
        var blob = new Blob([rpta], { 'type': gTipoArchivo });
        divVisorContainer.style.display = "inline";
        spnBarraTituloVisor.innerText = "SISMA - Manual de Ayuda"
        ifrVisor.src = URL.createObjectURL(blob);
    }
    else {
        Notify.Show('e', 'No se encontró el manual de referencia, comuniquese con ORH');
    }
}


function NotifyClose() {
    Notify.Clear();
}