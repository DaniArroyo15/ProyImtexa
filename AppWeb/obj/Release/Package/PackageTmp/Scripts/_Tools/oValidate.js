var Valida = (function () {
    function Valida() {
    }
    Valida.ValidarRequeridos = function (claseReq) {
        if (claseReq == null) claseReq = "R";
        var controles = document.getElementsByClassName(claseReq);
        var nControles = controles.length;
        var c = 0;
        for (var i = 0; i < nControles; i++) {
            if (controles[i].value == "") {
                controles[i].style.borderColor = "red";
                c++;
            }
            else {
                controles[i].style.borderColor = "";
            }
        }
        return (c == 0);
    }
    Valida.ValidarNumeros = function (claseNum) {
        if (claseNum == null) claseNum = "N";
        var controles = document.getElementsByClassName(claseNum);
        var nControles = controles.length;
        var c = 0;
        for (var i = 0; i < nControles; i++) {
            if (isNaN(controles[i].value)) {
                controles[i].style.borderColor = "blue";
                c++;
            }
            else {
                controles[i].style.borderColor = "";
            }
        }
        return (c == 0);
    }
    Valida.ValidarNumerosEnLinea = function (claseNum) {
        if (claseNum == null) claseNum = "N";
        var controles = document.getElementsByClassName(claseNum);
        var nControles = controles.length;
        for (var i = 0; i < nControles; i++) {
            controles[i].onkeyup = function (event) {
                var keycode = ('which' in event ? event.which : event.keycode);
                var esValido = ((keycode > 47 && keycode < 58) || (keycode > 95 && keycode < 106) || keycode == 8 || keycode == 37 || keycode == 39 || keycode == 110 || keycode == 188 || keycode == 190);
                if (!esValido) this.value = this.value.removeCharAt(this.selectionStart);
            }

            controles[i].onpaste = function (event) {
                event.preventDefault();
            }
        }
    }
    Valida.ValidarDatos = function (claseReq, claseNum) {
        var valido = Valida.ValidarRequeridos(claseReq);
        if (valido) {
            valido = Valida.ValidarNumeros(claseNum);
        }
        return valido;
    }
    //
    String.prototype.removeCharAt = function (i) {
        var tmp = this.split('');
        tmp.splice(i - 1, 1);
        return tmp.join('');
    }
    //
    return Valida;
})();