
// Split
var _sepTables = "~";
var _sepRows = "¬";
var _sepFields = "|";

// Repository
var _Raiz = "";
var _Url = "";
var _Modulo = "";
var _Area = "";
var _Controller = "";
var _PageName = "";

// File Upload
var viajesTotal = 0;
var viajesContador = 0;
var viajesPaquete = 1024 * 100; //100k
var file = null;

// Others
let _Accion = "";
let _Modal = "";
let _Usuario = {};
const _GAcion = "";
const _MaxSize = 6000000; // Tamaño maximo del archivo
const _MaxFile = 15000000; // Tamaño maximo del archivo 15MB

var _JContent;
const _Loading = window.parent.document.getElementById('divPopupContainerLoad');
const _Content = window.parent.document.getElementById('ifrPagina');

const _AutorizarUnoMismo = 1;
// 
var _Estados = {

    // Generales
    Registrado: 'background-color: #c7ebff; !important;color: #005585; border: 1px solid #60c6ff; font-weight: 700;'
    , Pendiente: 'background-color: #ffefca; !important;color: #bc3803; border: 1px solid #ffcc85; font-weight: 700;'
    , Autorizado: 'background-color: #e5edff; !important;color: #003cc7; border: 1px solid #85a9ff; font-weight: 700;'
    , Rechazado: 'background-color: #ffe0db; !important;color: #b81800; border: 1px solid #f48270; font-weight: 700;'
    , Aprobado: 'background-color: #d9fbd0; !important;color: #1c6c09; border: 1px solid #90d67f; font-weight: 700;'
    , Anulado: 'background-color: #d9fbd0; !important;color: #1c6c09; border: 1px solid #90d67f; font-weight: 700;'

    // Rendiciones
    , PendienteRendi: 'background-color: #007bff; !important; border: 1px solid #60c6ff; font-weight: 700;'
    , EnviadoRendi: 'background-color: #827cff; !important; border: 1px solid #60c6ff; font-weight: 700;'
    , AprobadoRendi: 'background-color: #00f5fa; !important; border: 1px solid #60c6ff; font-weight: 700;'
    , Rendido: 'background-color: #3adc8b; !important; border: 1px solid #60c6ff; font-weight: 700;'
    , RechazadoRendi: 'background-color: #f74138; !important; border: 1px solid #60c6ff; font-weight: 700;'
    , Observado: 'background-color: #f29287; !important; border: 1px solid #60c6ff; font-weight: 700;'
    , Invalidado: 'background-color: #ffc848; !important; border: 1px solid #60c6ff; font-weight: 700;'
}

const _Areas =
{
    Convocatorias: {
        Id: 'Convocatorias/',
        Url: 'Convocatoria/_',
    },
}

function _ValLetrasNumeros(e) {
    key = e.keyCode || e.which;
    tecla = String.fromCharCode(key).toLowerCase();
    letras = " áéíóúabcdefghijklmnñopqrstuvwxyz01234567890,";
    especiales = [8, 37, 39, 46];

    tecla_especial = false
    for (var i in especiales) {
        if (key == especiales[i]) {
            tecla_especial = true;
            break;
        }
    }

    if (letras.indexOf(tecla) == -1 && !tecla_especial)
        return false;
}

function limpia(input) {
    var val = input.value;
    var tam = val.length;
    for (i = 0; i < tam; i++) {
        if (!isNaN(val[i]))
            input.value = '';
    }
}

function Loading() {
    window.parent.document.getElementById('divPopupContainerLoad').style.display = "inline";
}
function LoadingClose() {
    window.parent.document.getElementById('divPopupContainerLoad').style.display = "none";
}
function RedirectTo(pUrl) {
    _Content.src = "/" + _Url + "Convocatoria";
}


var _App = (function () {
    function _App() { }
    _App.Page = function (pUrl) {
        _Load.Show();
        window.parent.document.getElementById('ifrPagina').src = pUrl;
    }
    return _App;
})();

var _Load = (function () {
    function _Load() { }
    _Load.Show = function () { _Loading.style.display = 'inline'; }
    _Load.Close = function () { _Loading.style.display = 'none'; }
    return _Load;
})();

var _Actions = {
    Add: 'Add',
    Modify: 'Modify',
    Delete: 'Delete',
    Cancel: 'Cancel',
}

Array.prototype.sortBy = function (key_func, reverse = false) {
    return this.sort((a, b) => {
        //
        var keyA = key_func(a).trim(),
            keyB = key_func(b).trim();
        //
        if (keyA == "") keyA = '--';
        if (keyB == "") keyB = '--';
        //
        var IsTypeDate = false;
        var IsTypeNumeric = false;
        //
        var iDateA, iDateB;
        var iParseA, iParseB;
        var iDate = 0;
        if (keyA.split('/').length == 3) {
            var iDate = keyA.split('/')[2].split(':');
            var iFormat = (iDate.length > 1 ? "dd/MM/yyyy hh:mm" : "dd/MM/yyyy");
            iDateA = keyA.toDate(iFormat);
            iParseA = Date.parse(iDateA);
            IsTypeDate = true;
        }
        if (keyB.split('/').length == 3) {
            var iDate = keyB.split('/')[2].split(':');
            var iFormat = (iDate.length > 1 ? "dd/MM/yyyy hh:mm" : "dd/MM/yyyy");
            iDateB = keyB.toDate(iFormat);
            iParseB = Date.parse(iDateB);
        }
        iDate = 0;
        //
        var iKeyA, iKeyB;
        IsTypeNumeric = isNumeric(keyA);



        if (IsTypeDate == true) {
            iKeyA = iParseA;
            iKeyB = iParseB;
        }
        else if (IsTypeNumeric == true) {
            if (keyA.indexOf('.')) {
                iKeyA = parseFloat(keyA);
                iKeyB = parseFloat(keyB);
            }
            else {
                iKeyA = parseInt(keyA);
                iKeyB = parseInt(keyB);
            }
        }
        else {
            iKeyA = keyA.toUpperCase();
            iKeyB = keyB.toUpperCase();
            //.toUpperCase();
        }
        //

        if (iKeyA == iKeyB) return reverse ? 1 : -1;
        if (iKeyA < iKeyB) return reverse ? 1 : -1;
        if (iKeyA > iKeyB) return reverse ? -1 : 1;
        //
        return 0;
    });
}
String.prototype.toDate = function (format) {
    var normalized = this.replace(/[^a-zA-Z0-9]/g, '-');
    var normalizedFormat = format.replace(/[^a-zA-Z0-9]/g, '-');
    var formatItems = normalizedFormat.split('-');
    var dateItems = normalized.split('-');

    var monthIndex = formatItems.indexOf("MM");
    var dayIndex = formatItems.indexOf("dd");
    var yearIndex = formatItems.indexOf("yyyy");
    var hourIndex = formatItems.indexOf("hh");
    var minutesIndex = formatItems.indexOf("mm");
    var secondsIndex = formatItems.indexOf("ss");

    var today = new Date();

    var year = yearIndex > -1 ? dateItems[yearIndex] : today.getFullYear();
    var month = monthIndex > -1 ? dateItems[monthIndex] : today.getMonth();
    var day = dayIndex > -1 ? dateItems[dayIndex] : today.getDate();

    var hour = hourIndex > -1 ? dateItems[hourIndex]-1 : today.getHours();
    var minute = minutesIndex > -1 ? dateItems[minutesIndex]-1 : today.getMinutes();
    var second = secondsIndex > -1 ? dateItems[secondsIndex] - 1 : today.getSeconds();

    return new Date(year, month, day, hour, minute, second);
};

var isNumeric = function (obj) {
    return !Array.isArray(obj) && (obj - parseFloat(obj) + 1) >= 0;
}

function ExistFunction(pNameFunction) {
    var iReturn = false;
    if (typeof window[pNameFunction] === 'function') iReturn = true;
    return iReturn;
}