var GUI = (function () {

    function GUI() { }

    GUI.ObtenerDatos = function (claseGrabar) {
        var data = "";
        if (claseGrabar == null) claseGrabar = "G";
        var controles = document.getElementsByClassName(claseGrabar);
        var nControles = controles.length;

        for (var i = 0; i < nControles; i++) {
            if (controles[i].type == 'checkbox') {
                if (controles[i].checked == true) data += "1";
                else data += "0";
            }
            else data += controles[i].value.trim();
            if (i < nControles - 1) data += "|";
        }
        return (data);
    }

    GUI.LimpiarDatos = function (claseBorrar) {
        if (claseBorrar == null) claseBorrar = "R";
        var controles = document.getElementsByClassName(claseBorrar);
        var nControles = controles.length;
        for (var i = 0; i < nControles; i++) {
            if (controles[i].type == 'checkbox') controles[i].checked = false;
            else if (controles[i].tagName == "IMG") controles[i].src = "";
            else if (controles[i].tagName == 'SPAN') controles[i].innerText = "";
            else if (controles[i].tagName == 'LABEL') controles[i].innerText = "";
            else if (controles[i].tagName == 'P') controles[i].innerText = "";

            else controles[i].value = "";
            controles[i].style.borderColor = "";
        }
    }

    GUI.MostrarDatos = function (claseMostrar, valoresMostrar) {
        if (claseMostrar == null) claseMostrar = "G";
        var controles = document.getElementsByClassName(claseMostrar);
        var nControles = controles.length;
        for (var i = 0; i < nControles; i++) {
            if (i < valoresMostrar.length) {
                if (controles[i].type == 'checkbox') {
                    if (valoresMostrar[i] == '0') controles[i].checked = false;
                    else controles[i].checked = true;
                }
                else if (controles[i].tagName == 'SPAN') controles[i].innerText = valoresMostrar[i];
                else if (controles[i].tagName == 'LABEL') controles[i].innerText = valoresMostrar[i];
                else if (controles[i].tagName == 'P') controles[i].innerText = valoresMostrar[i];
                else controles[i].value = valoresMostrar[i];
            }
        }
    }

    return GUI;
})();
