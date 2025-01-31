//import { Valida.ValidarDato } from 'oValidate';

window.onload = function () {
    sessionStorage.clear();
    spnMessage.innerText = '';

    var iMessage = hdMessage.value;
    if (iMessage != '') {
        spnMessage.classList.remove("gz-hide");
        spnMessage.innerText = iMessage;
    }

    btnIniciarSesion.onclick = function () {
        var iText = captchaValue.value.toUpperCase();
        if (userInput.value.toUpperCase() === iText) {
            captchaValue.value = "";
        } else {
            spnMessage.classList.remove("gz-hide");
            spnMessage.innerText = "Token incorrecto, vuelva a ingresar";
            Captcha.Trigger();
            return;
        }
        if (Valida.ValidarDatos("R", "N", spnMessage)) {
            divPopupContainerLoad.style.display = "inline";
            var data = GUI.ObtenerDatos("L");
            var frm = new FormData();
            frm.append("pData", data);
            Http.post("Login/ValidaUser", mostrarRptaValidarLogin, frm);
        }
    }

    txtClave.onkeypress = function (e) {
        var keycode = (e.keyCode ? e.keyCode : e.which);
        if (keycode == '13') {
            btnIniciarSesion.click();
            return false;
        }
    };
    Captcha.Trigger();
    reloadButton.onclick = function () {
        Captcha.Trigger();
    }
};

function mostrarRptaValidarLogin(rpta) {    
    if (rpta) {
        if (rpta.includes('KO|')) {
            spnMessage.classList.remove("gz-hide");
            spnMessage.innerText = rpta.split('|')[1];
            divPopupContainerLoad.style.display = "none";
            Captcha.Trigger();
            return;
        }
        spnMessage.innerText = '';
        spnMessage.classList.add("gz-hide");
        sessionStorage.setItem("JUsuario",rpta);
        window.location.href = hdfRaiz.value + "Home/Home";
    } else {

        spnMessage.classList.remove("gz-hide");
        spnMessage.innerText = 'Credenciales incorrectas';
        Captcha.Trigger();
    }
    divPopupContainerLoad.style.display = "none";
}