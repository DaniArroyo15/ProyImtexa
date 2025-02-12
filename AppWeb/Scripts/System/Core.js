﻿_Separators = {
    field: '|',
    row: '¬',
    list: '~',
    optional: '^',
    values: ','
}

var UI = (function () {
    function UI() { }
    //
    UI.Menu = function (pLista) {
        
        var iPadre = [];
        var iHtml = `<ul class="nav-links">`;
        var iPadres = pLista.filter((x) => x.split("|")[3] == "0");
        var iIcono = "bx bx-folder";

        for (var i = 0; i < iPadres.length; i++) {
            iPadre = iPadres[i].split("|");
            var iHijos = pLista.filter((x) => x.split("|")[3] == iPadre[0]);
            iHtml += `<li class="mnu" id="mnu${(i + 1)}">`;
            if (iHijos.length > 0) iHtml += `<div class="iocn-link">`;
            iHtml += `<a href="#">`;
            iHtml += `<i class='${iPadre[4].trim() == '' ? iIcono : iPadre[4].trim()}'></i>`;
            iHtml += `<span class="link_name" href="#">${iPadre[1].trim()}</span>`;
            iHtml += `</a>`;
            if (iHijos.length > 0) iHtml += `<i class='bx bxs-chevron-down arrow'></i></div>`;
            iHtml += `<ul class="sub-menu${(iHijos.length == 0) ? " blank" : ""}">`;
            iHtml += `<li><a class="link_name nolink" href="#">${iPadre[1].trim()}</a></li>`;
            if (iHijos.length > 0) iHtml += SubmenuCreate(iHijos);
            iHtml += `</ul>`
            iHtml += `</li>`;
        }
        iHtml += "</ul>";
        divMenu.innerHTML = iHtml;
        OpcionEvent();
        //
        function SubmenuCreate(pHijos) {
            var iHtml = '';
            var iRegistro = [];
            for (var i = 0; i < pHijos.length; i++) {
                iRegistro = pHijos[i].split("|");
                iHtml += `<li><a class="smnu" href="#" data-url='${iRegistro[2]}'>${iRegistro[1]}</a></li>`;
            }
            return iHtml;
        }

        function OpcionEvent() {
            let iMenus = document.querySelectorAll(".mnu");
            for (var i = 0; i < iMenus.length; i++) {
                iMenus[i].addEventListener("click", (e) => {
                    if (e.target.classList.contains('smnu')) {
                        var iOpcion = e.target;
                        if (iOpcion.getAttribute('data-url')) {
                            var accion = iOpcion.getAttribute("data-url");
                            var url = hdfRaiz.value + accion;
                            if (accion != "") {
                                let iActives = document.querySelectorAll(".acivemenu");
                                for (var ii = 0; ii < iActives.length; ii++) {
                                    iActives[ii].classList.remove('acivemenu');
                                }
                                iOpcion.classList.add('acivemenu');
                                window.parent.document.getElementById('divPopupContainerLoad').style.display = "inline";
                                ifrPagina.src = url;
                                window.parent.document.getElementById('hdfHelp').value = url;
                            }
                        }
                        return;
                    }
                    if (e.target.classList.contains('sub-menu')) return;
                    let iMenu = e.currentTarget;
                    let iShows = document.querySelectorAll(".showMenu")
                    for (var i = 0; i < iShows.length; i++) {
                        if (iMenu != iShows[i]) iShows[i].classList.toggle("showMenu");
                    }
                    iMenu.classList.toggle("showMenu");
                });
            }

            let sidebar = document.querySelector(".sidebar");
            let sidebarBtn = document.querySelector(".z-menu");
            sidebarBtn.addEventListener("click", () => {
                sidebar.classList.toggle("close");
            });
        }
    }
    //
    UI.Grid = function (div, options, template = '') {

        var _Options =
        {
            // Obligatorio
            Id: (!options.Id) ? null : options.Id // Obligatorio
            , HiddenId: (!options.HiddenId) ? true : options.HiddenId
            , Name: (!options.Name) ? options.Id : options.Name
            , Title: (!options.Title) ? 'Total de Registros : ' : options.Title
            , RowsForPage: (!options.RowsForPage) ? 20 : options.RowsForPage
            , DisplayPages: (!options.DisplayPages) ? 10 : options.DisplayPages
            , HasFilter: (options.HasFilter == null) ? true : options.HasFilter
            , HasReload: (options.HasReload == null) ? true : options.HasReload
            , HasCheck: (options.HasCheck == null) ? false : options.HasCheck
            , HasPrint: (options.HasPrint == null) ? false : options.HasPrint
            , HasNew: (options.HasNew == null) ? false : options.HasNew
            , HasEdit: (!options.HasEdit) ? false : options.HasEdit
            , HasDelete: (!options.HasDelete) ? false : options.HasDelete
            , HasDetails: (!options.HasDetails) ? false : options.HasDetails
            , HasOrden: (!options.HasOrden) ? true : options.HasOrden
            , HasExport: (options.HasExport == null) ? false : options.HasExport
            , HasImport: (options.HasImport == null) ? false : options.HasImport
            , NotExportIndex: (!options.NotExportIndex) ? '' : options.NotExportIndex
            , ReportTitle: (!options.ReportTitle) ? options.Id : options.ReportTitle
            //
            , HasHead: (!options.HasHead) ? true : options.HasHead
            , TypesColumns: (!options.TypesColumns) ? [] : options.TypesColumns || []
            //
            // Obligatorio
            , DataTable: (!options.DataTable) ? [] : options.DataTable // Obligatorio
            , GridButtons: (!options.GridButtons) ? [] : options.GridButtons || []
            , Indexes: (!options.Indexes) ? [] : options.Indexes || []
            , Helpers: (!options.Helpers) ? [] : options.Helpers || []
            , SubTotals: (!options.SubTotals) ? [] : options.SubTotals || []
            , SubTotalsColumn: (!options.SubTotalsColumn) ? [] : options.SubTotalsColumn || []
            , BorderIndex: (!options.BorderIndex) ? [] : options.BorderIndex || []
            , ColorIndex: (!options.ColorIndex) ? [] : options.ColorIndex || []
            , ConditionCheck: (!options.ConditionCheck) ? [] : options.ConditionCheck || []
            , Buttons: (!options.Buttons) ? [] : options.Buttons || []
            , HiddenColumns: (!options.HiddenColumns) ? [] : options.HiddenColumns || []
            , ChecksId: (!options.ChecksId) ? [] : options.ChecksId || []
            , SelectedId: (!options.SelectedId) ? [] : options.SelectedId || []
            //
            , TemplateColumns: (!options.TemplateColumns) ? {} : options.TemplateColumns || {}
            , Import: (!options.Import) ? [] : options.Import || []
        }

        var matriz = [];
        var id = _Options.Id.replace(' ', '');
        var iName = _Options.ReportTitle;
        var nRegistros = _Options.DataTable.length;
        var nCampos;
        var nGridButtons = _Options.GridButtons.length;
        var filaActual = null;
        var tipos = [];

        var nConditionCheck = _Options.ConditionCheck.length;
        var nColorIndex = _Options.ColorIndex.length;
        var nButtons = _Options.Buttons.length;
        var iTagExport = "";

        //_Options.SubTotals
        var totales = [];
        //Checks
        var filasChecks = [];
        //Ordenacion
        var tipoOrden = 0; //0: ascendente, 1: descendente
        var colOrden = 0; //0: Primera Columna, 1: Segunda Columna
        //Paginacion Simple
        var indicePagina = 0;
        //Paginacion Por Bloques
        var indiceBloque = 0;
        iniciarGrilla();

        function filtrarMatriz() {
            indicePagina = 0;
            indiceBloque = 0;
            crearMatriz();
            mostrarMatriz();
        }

        function iniciarGrilla() {
            crearTabla();
            filtrarMatriz();
        }

        function crearTabla() {
            var html = "";
            html += `<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2">`;
            html += `<div class='InformacionTabla'><span>${_Options.Title}</span>&nbsp;<span id='spnTotal${id}'></span></div>`;
            html += `<div class="btn-toolbar mb-2 mb-md-0">`;
            if (
                _Options.HasFilter == true ||
                _Options.HasPrint == true ||
                _Options.HasExport == true ||
                _Options.Import.Enabled == true ||
                _Options.HasNew == true ||
                _Options.HasReload == true ||
                nButtons > 0
            )
            {
                html += `<div class="btn-group mr-2">`;
                if (_Options.HasReload == true) {
                    html += `<i id="btnReload${id}" class="BotonL btn btn-sm btn-outline-secondary fa fa-refresh" title="Actualizar"></i>`;
                }
                //
                if (_Options.HasFilter == true) {
                    html += `<i id="btnBorrarFiltro${id}" class="BotonL btn btn-sm btn-outline-secondary fa fa-filter" title="Limpiar Filtros"></i>`;
                }
                if (_Options.HasPrint == true) {
                    html += `<i id="btnImprimir${id}" class="BotonL btn btn-sm btn-outline-secondary fa fa-print" title="Imprimir"></i>`;
                }
                if (_Options.Import.Enabled == true) {

                    html += `<i id="btnImportar${id}" class="BotonL btn btn-sm btn-outline-secondary fa fa-cloud-upload" title="Upload" onclick="${_Options.Import.Function}()"></i>`;
                    html += `<input type="file" class="form-control gz-hide" id="upFile${id}" accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet">`;
                }
                if (_Options.HasExport == true) {
                    iTagExport = `data-val='${_Options.NotExportIndex}'`;
                    html += `<label class="btn btn-sm btn-outline-secondary dropdown-toggle dd-dropdown">
                            <div class="dd-button">
                            Exportar
                            </div>
                            <input id='mnucheck_${id}' type="checkbox" class="dd-input" id="test">
                            <ul id='mnuExportar_${id}' class="dd-menu">
                            <li id='btnExportarDocx${id}' class="BotonL" ${iTagExport}>Word</li>
                            <li id='btnExportarXlsx${id}' class="BotonL" ${iTagExport}>Excel</li>
                            </ul>
                        </label>`;
                }
      
                /*
                 <li id='btnExportarTxt${id}' class="BotonL" ${iTagExport}>Texto</li>
                 <li class="divider"></li>
                 <li id='btnExportarPdf${id}' class="BotonL" ${iTagExport}>PDF</li>
                 */

                if (nButtons > 0) {
                    if (nButtons > 1) {
                        html += `<label class="btn btn-sm btn-outline-secondary dropdown-toggle dd-dropdown">
                            <div class="dd-button">_Options.Buttons</div>
                            <input type="checkbox" class="dd-input" id="test">
                            <ul class="dd-menu">`
                        for (var j = 0; j < nButtons; j++) {
                            html += `<li id='btnAccion_${id}' data-value='${_Options.Buttons[j].texto}' class="BotonL Accion ${id}">${_Options.Buttons[j].texto}</li>`;
                        }
                        html += '</ul>';
                        html += '</label>'
                    }
                    else {
                        html += `<button id='btnAccion_${id}' data-value='${_Options.Buttons[0].texto}' class='btn btn-sm btn-outline-secondary BotonL Accion ${id}'>${_Options.Buttons[0].texto}</button>`;
                    }

                }
                if (_Options.HasNew == true) {
                    html += `<button id='btnNuevo${id}' class='BotonL btn btn-sm btn-primary'>`;
                    html += `<i class='fa fa-plus' aria-hidden='true' title='Agregar'></i> Agregar`;
                    html += '</button>';
                }
            }

            html += "</div>";
            html += "</div>";
            html += "</div>";

            html += "<div class='table-responsive small'>";
            html += `<input id="hdfSubTables_${id}" type="hidden" value='' />`
            html += "<table class='table table-bordered'>";
            var cabeceras = _Options.DataTable[0].split("|");
            var anchos = _Options.DataTable[1].split("|");
            tipos = _Options.DataTable[2].split("|");
            nCampos = cabeceras.length;
            html += "<thead class='thead-dark'>";
            html += "<tr class='FilaCabecera ";
            html += id;
            html += "'>";
            if (_Options.HasCheck) {
                html += "<th style='width:1%; max-width:30px' scope='col'>";
                html += "<input id='chkCabecera ";
                html += id;
                html += "' type='checkbox'/>";
                html += "</th>";
            }

            for (var j = 0; j < nCampos; j++) {
                if (j in _Options.TemplateColumns) {
                    html += "<th style='width:1%; max-width:30px' class='Centro'></th>";
                }
                else {
                    //
                    html += "<th style='width:";
                    html += (+anchos[j]);
                    html += "px;";
                    if (_Options.HiddenId && j == 0) {
                        html += "display:none";
                    }
                    if (_Options.HiddenColumns) {
                        for (var k = 0; k < _Options.HiddenColumns.length; k++) {
                            if (_Options.HiddenColumns[k].index == j) {
                                html += "display:none";
                                break;
                            }
                        }
                    }
                    html += "' scope='col'>";
                    html += "<span class='Enlace ";
                    html += id;
                    html += "' data-orden='";
                    html += j;
                    html += "'>";
                    html += cabeceras[j];
                    html += "</span>";
                    html += "&nbsp;";
                    html += "<span></span>";
                    if (_Options.HasFilter) {
                        html += "<br/>";
                        if (_Options.Indexes.length > 0 && _Options.Indexes.indexOf(j) > -1) {
                            html += "<select class='TitleFiedTable ";
                            html += id;
                            html += " Cabecera Combo'></select>";
                        }
                        else {
                            html += "<input type='text' class='TitleFiedTable ";
                            html += id;
                            html += " Cabecera Texto' style='width:100%'/>";
                        }
                    }
                    html += "</th>";
                }
            }
            if (nGridButtons > 0) {
                for (var j = 0; j < nGridButtons; j++) {
                    html += "<th style='width:1%; max-width:30px'>";
                    html += _Options.GridButtons[j].cabecera;
                    html += "</th>";
                }
            }
            if (_Options.HasEdit) {
                html += "<th style='width:1%; max-width:30px; text-align: center;' scope='col'></th>";
            }
            if (_Options.HasDetails) {
                html += "<th style='width:1%; max-width:30px' scope='col'></th>";
            }
            if (_Options.HasDelete) {
                html += "<th style='width:1%; max-width:30px' scope='col'></th>";
            }
            html += "</tr>";
            html += "</thead>";
            html += "<tbody id='tbData";
            html += id;
            html += "'>";
            html += "</tbody>";
            html += "<tfoot>";
            if (_Options.SubTotals.length > 0) {
                var nCols = (_Options.HasCheck ? nCampos + 1 : nCampos);
                var n = (_Options.HasCheck ? 1 : 0);
                html += "<tr class='FilaCabecera'>";
                var ccs = 0;
                for (var j = 0; j < nCols; j++) {
                    html += "<th class='Derecha'";
                    if (_Options.SubTotals.indexOf(j - n) > -1) {
                        html += " id='total";
                        html += id;
                        html += _Options.SubTotals[ccs];
                        html += "'";
                        ccs++;
                    }
                    if (_Options.HiddenId && j == 0) {
                        html += " style='display:none'";
                    }
                    html + ">";
                    if (_Options.SubTotals.indexOf(j - n) > -1) {
                        html += "0";
                    }
                    html += "</th>";
                }
                if (_Options.HasEdit) html += "<th></th>";
                if (_Options.HasDetails) html += "<th></th>";
                if (_Options.HasDelete) html += "<th></th>";
                html += "</tr>";
            }
            var nCols = (_Options.HasCheck ? nCampos + 1 : nCampos);
            nCols = (_Options.HasEdit ? nCols + 1 : nCols);
            nCols = (_Options.HasDetails ? nCols + 1 : nCols);
            nCols = (_Options.HasDelete ? nCols + 1 : nCols);
            html += "<tr>";
            html += "<td id='tdPagina";
            html += id;
            html += "' colspan='";
            html += nCols;
            html += "' class='Centro' style='border-bottom-width: 0;'>";
            html += "</td>";
            html += "</tr>";
            html += "</tfoot>";
            html += "</table>"
            html += "</div>";
            div.innerHTML = html;
            if (_Options.Indexes.length > 0) llenarCombos();
            configurarOrden();
        }

        function llenarCombos() {
            var combos = document.getElementsByClassName(id + " Cabecera Combo");
            var nCombos = combos.length;
            for (var j = 0; j < nCombos; j++) {
                GUI.Combo(combos[j], _Options.Helpers[j], "Todos");
            }
        }

        function crearMatriz() {
            matriz = [];
            var campos = [];
            var fila = [];
            var esNumero = false;
            var esNumeric = false;
            var esFecha = false;
            if (_Options.SubTotals.length > 0) {
                totales = [];
                var nSubTotals = _Options.SubTotals.length;
                for (var j = 0; j < nSubTotals; j++) {
                    totales.push(0);
                }
            }
            if (_Options.DataTable.length > 3 && _Options.DataTable[3] != "") {
                var cabeceras = document.getElementsByClassName(id + " Cabecera");
                var nCabeceras = cabeceras.length;
                var valores = [];
                var iTag = 0;
                for (var j = 0; j < nCabeceras; j++) {
                    if (cabeceras[j].className.indexOf("Texto") > -1) {
                        valores.push(cabeceras[j].value.toLowerCase());
                    }
                    else {
                        valores.push(cabeceras[j].options[cabeceras[j].selectedIndex].text);
                    }
                }
                var exito = false;
                var ccs = 0;
                for (var i = 3; i < nRegistros; i++) {
                    campos = _Options.DataTable[i].split("|");
                    exito = true;
                    for (var j = 0; j < nCabeceras; j++) {

                        if (cabeceras[j].className.indexOf("Texto") > -1) {
                            exito = (valores[j] == "" || campos[j].toString().toLowerCase().indexOf(valores[j]) > -1);
                        }
                        else {
                            exito = (valores[j] == "Todos" || campos[j] == valores[j]);
                        }
                        if (!exito) break;
                    }
                    ccs = 0;
                    if (exito) {
                        fila = [];
                        for (var j = 0; j < nCampos; j++) {
                            esNumero = (tipos[j].indexOf("Int") > -1 || tipos[j].indexOf("Decimal") > -1);
                            esNumeric = (tipos[j].indexOf("Numeric") > -1);
                            esFecha = (tipos[j].indexOf("DateTime") > -1);
                            if (esNumeric) {
                                fila.push(campos[j]);
                            }
                            else if (esNumero) {
                                fila.push(campos[j] * 1);
                            }
                            else if (esFecha) {
                                fila.push(crearFecha(campos[j]));
                            }
                            else {
                                fila.push(campos[j]);
                            }
                            if (_Options.SubTotals.length > 0 && _Options.SubTotals.indexOf(j) > -1) {
                                valor = fila[j];
                                if (_Options.SubTotalsColumn.length == 0 || (_Options.SubTotalsColumn.length > 0 && _Options.SubTotalsColumn[i - 3] == "1")) {
                                    var iValor = valor.replace(',', '');
                                    totales[ccs] += parseFloat(iValor);
                                    ccs++;
                                }
                            }
                        }
                        matriz.push(fila);
                    }
                }
            }
        }

        function crearFecha(strFecha) {
            var fechaDMY;
            var fechas = strFecha.split(" ");
            var fecha = fechas[0].split("/");
            var dia = fecha[0] * 1;
            var mes = +fecha[1] - 1;
            var anio = Number(fecha[2]);

            if (fechas.length > 1 && fechas[1] != "") {
                var hms = fechas[1].split(":");
                var ampm = fechas[2];
                var hora = hms[0] * 1;
                if (ampm == "PM") hora = hora + 12;
                var min = hms[1] * 1;
                var seg = hms[2] * 1;
                fechaDMY = new Date(anio, mes, dia, hora, min, seg);
            } else {
                fechaDMY = new Date(anio, mes, dia);
            }
            return fechaDMY;
        }

        function mostrarMatriz() {
            var html = "";
            var nRegMatriz = matriz.length;
            var esNumero = false;
            var esFecha = false;
            var esDecimal = false;
            var existeIdCheck = false;
            var inicio = indicePagina * _Options.RowsForPage;
            var fin = inicio + _Options.RowsForPage;
            var iTag = 0;
            for (var i = inicio; i < fin; i++) {
                if (i < nRegMatriz) {
                    html += "<tr class='FilaDatos ";
                    html += id;
                    
                    if (_Options.SubTotalsColumn.length > 0 && _Options.SubTotalsColumn[i] == "1") {
                        html += " style='font-weight:bold'";
                    }
                    //
                    if (_Options.SelectedId.Values) {
                        if (_Options.SelectedId.Values.length > 0) {
                            for (var j = 0; j < nCampos; j++) {
                                if (iTag == 1) break;
                                for (var k = 0; k < _Options.SelectedId.Values.length; k++) {
                                    var iValorCelda = matriz[i][_Options.SelectedId.Index];
                                    if (_Options.SelectedId.Values[k] == iValorCelda) {
                                        iTag = 1;
                                        html += " FilaSeleccionada "
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    //
                    html += "'";
                    html += ">";
                    //
                    iTag = 0;
                    if (_Options.HasCheck) {
                        //
                        var iCheckedHtml = "";
                        //
                        if (nConditionCheck > 0) {
                            for (var j = 0; j < nCampos; j++) {
                                if (iTag == 1) break;
                                for (var k = 0; k < nConditionCheck; k++) {
                                    if (_Options.ConditionCheck[k].index == j) {
                                        var iValorCelda = matriz[i][_Options.ConditionCheck[k].index];
                                        if (_Options.ConditionCheck[k].condition == iValorCelda) {
                                            iTag = 1;
                                            html += `<td></td>`;
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        if (iTag == 0) {
                            existeIdCheck = (_Options.ChecksId.indexOf(matriz[i][0]) > -1);
                            if (existeIdCheck) iCheckedHtml += "checked='checked'";
                            //
                            html += `<td><input type='checkbox' class='Check ${id}' ${iCheckedHtml} id='chkControl_${id}'"/></td>`;
                        }
                        iTag = 0;
                    }
                    for (var j = 0; j < nCampos; j++) {
                        if (j in _Options.TemplateColumns) {
                            html += `<td data-col='${j}' data-val='${matriz[i][j]}' class='Centro'>`;
                            html += (matriz[i][j] != '' ? _Options.TemplateColumns[j] : '');
                            html += `</td>`;
                        }
                        else {
                            html += "<td class='";
                            esNumeric = (tipos[j].indexOf("Numeric") > -1);
                            esNumero = (tipos[j].indexOf("Int") > -1 || tipos[j].indexOf("Decimal") > -1);
                            esFecha = (tipos[j].indexOf("DateTime") > -1);
                            esDecimal = (tipos[j].indexOf("Decimal") > -1);
                            if (esNumeric) {
                                html += "Derecha";
                            }
                            else if (esNumero) {
                                html += "Derecha";
                            }
                            else if (esFecha) {
                                html += "Centro";
                            }
                            else {
                                html += "Izquierda";
                            }
                            html += "'";
                            if (_Options.HiddenId && j == 0) {
                                html += " style='display:none'";
                            }
                            if (_Options.HiddenColumns) {
                                for (var k = 0; k < _Options.HiddenColumns.length; k++) {
                                    if (_Options.HiddenColumns[k].index == j) {
                                        html += " style='display:none'";
                                        break;
                                    }
                                }
                            }
                            if (_Options.BorderIndex.length > 0 && matriz[i][j] && _Options.BorderIndex[i] == "1") {
                                html += " style='border-top:solid;border-width:1px'";
                            }
                            html += ">";

                            var iSpan = '';
                            if (nColorIndex) {

                                for (var k = 0; k < nColorIndex; k++) {
                                    if (_Options.ColorIndex[k].index) {
                                        if (_Options.ColorIndex[k].index != j) continue;
                                        var iValorCelda = matriz[i][j].toLowerCase();
                                        var iStyle = '';
                                        var iConditions = _Options.ColorIndex[k].condition.split('^');
                                        for (var x = 0; x < iConditions.length; x++) {
                                            var iCondition = iConditions[x].split('|');
                                            iStyle = iCondition[1]
                                            if (iCondition[0].toLowerCase() == iValorCelda) break;
                                        }
                                        iSpan += `<span class='Centro colsStyles' style='${iStyle == '' ? 'background-color:#adb5bd; !important' : iStyle}'>${matriz[i][j]}</span>`;
                                    }
                                }
                            }
                            if (esNumeric) html += matriz[i][j];
                            else if (esDecimal) html += matriz[i][j].toFixed(2);
                            else if (esFecha) html += mostrarFechaDMY(matriz[i][j]);
                            else if (iSpan != "") html += iSpan;
                            else html += matriz[i][j];

                            html += "</td>";
                        }

                    }
                    if (nGridButtons > 0) {
                        for (var j = 0; j < nGridButtons; j++) {
                            html += "<td>";
                            html += `<i class="${id} ${_Options.GridButtons[j].icono} BotonOtro btnGrid Icono Centro NoImprimir hand" aria-hidden="true" title="${_Options.GridButtons[j].titulo}" data-val="${_Options.GridButtons[j].valor}"></i>`
                            html += "</td>";
                        }
                    }
                    if (_Options.HasEdit) {
                        html += "<td class='Centro'>";
                        html += `<i class="fa fa-pencil Icono Centro Editar NoImprimir hand ${id}" aria-hidden="true" title='Editar'></i>`;
                        html += "</td>";
                    }
                    if (_Options.HasDetails) {
                        html += "<td class='Centro'>";
                        html += `<img src='${hdfRaiz.value}Images/Detalles.png' class='Icono Centro Detalle NoImprimir ${id}' title='Ver Detalle'/>`;
                        html += "</td>";
                    }
                    if (_Options.HasDelete) {
                        html += "<td class='Centro'>";
                        html += `<i class='fa fa-trash-o Icono Centro Eliminar NoImprimir hand ${id}' aria-hidden='true' title='Eliminar'></i>`
                        html += "</td>";
                    }
                    html += "</tr>";
                }
                else break;
            }
            var tbData = document.getElementById("tbData" + id);
            if (tbData != null) tbData.innerHTML = html;
            var spTotal = document.getElementById("spnTotal" + id);
            if (spTotal != null) spTotal.innerHTML = matriz.length;
            if (nGridButtons > 0) configurarGridButtons();
            if (_Options.TemplateColumns != {} && _Options.TemplateColumns != null) configurarGridButtonsFlag();
            if (_Options.SubTotals.length > 0) {
                var nSubTotals = _Options.SubTotals.length;
                var tipo;
                var esDecimal;
                for (var j = 0; j < nSubTotals; j++) {
                    var celdaSubtotal = document.getElementById("total" + id + _Options.SubTotals[j]);
                    if (celdaSubtotal != null) {
                        tipo = tipos[_Options.SubTotals[j]];
                        esDecimal = (tipo.indexOf("Decimal") > -1);
                        if (esDecimal) celdaSubtotal.innerText = "Total : " + totales[j].toFixed(2);
                        else {
                            var iValor = totales[j].toString().replace(',', ''); 
                            celdaSubtotal.innerText = "Total : " + Number.parseFloat(iValor).toFixed(2).toString();
                        }
                    }
                }
            }
            configurarEventos();
            configurarPaginacion();
        }

        function mostrarFechaDMY(fecha) {
            var anio = fecha.getFullYear();
            var mes = fecha.getMonth() + 1;
            mes = (mes < 10 ? "0" + mes.toString() : mes.toString());
            var dia = fecha.getDate();
            dia = (dia < 10 ? "0" + dia.toString() : dia.toString());
            var hora = fecha.getHours();
            var ampm = "AM";
            if (hora > 12) {
                hora -= 12;
                ampm = "PM";
            }
            var min = fecha.getMinutes();
            var seg = fecha.getSeconds();
            var strFecha = dia + "/" + mes + "/" + anio + " " + hora + ":" + min + ":" + seg + " " + ampm;
            return strFecha;
        }

        function configurarGridButtons() {
            var btns = document.getElementsByClassName("BotonOtro " + id);
            var nBtns = btns.length;
            for (var j = 0; j < nBtns; j++) {
                btns[j].onclick = function () {
                    var n = (_Options.HasCheck ? 1 : 0);
                    var fila = this.parentNode.parentNode;
                    var idRegistro = fila.childNodes[n].innerText;

                    var iData = [];
                    var iP = (_Options.HasCheck == true) ? 1 : 0;
                    for (var p = iP; p < fila.childNodes.length; p++) {
                        iData.push(fila.childNodes[p].innerText);
                    }

                    var valor = this.getAttribute("data-val");
                    //seleccionarBoton(id, idRegistro, iData, valor);
                    if (ExistFunction("seleccionarBoton")) {
                        seleccionarBoton(id, idRegistro, iData, valor);
                    }
                    else {
                        Notify.Show("d", "No se encontro funcion -seleccionarBoton-");
                    }
                }
            }
        }

        function configurarGridButtonsFlag() {
            var btnsFlag = document.getElementsByClassName("BotonFlag " + id);
            var nBtnsFlag = btnsFlag.length;
            for (var j = 0; j < nBtnsFlag; j++) {
                btnsFlag[j].onclick = function () {
                    var n = (_Options.HasCheck ? 1 : 0);
                    var celda = this.parentNode;
                    var fila = celda.parentNode;
                    var columna = celda.getAttribute('data-col');
                    var valor = celda.getAttribute('data-val');
                    var idRegistro = fila.childNodes[n].innerText;
                    var data = this.parentNode.parentNode.innerText.split("\t");
                    //seleccionarBotonFlag(id, idRegistro, columna, valor, data);
                    if (ExistFunction("seleccionarBotonFlag")) {
                        seleccionarBotonFlag(id, idRegistro, columna, valor, data);
                    }
                    else {
                        Notify.Show("d", "No se encontro funcion -seleccionarBotonFlag-");
                    }
                }
            }
        }

        function configurarEventos() {
            var filas = document.getElementsByClassName("FilaDatos " + id);
            var nFilas = filas.length;
            for (var i = 0; i < nFilas; i++) {
                filas[i].onclick = function () {
                    var n = (_Options.HasCheck ? 1 : 0);
                    var idRegistro = this.childNodes[n].innerText;
                    if (filaActual != null) {
                        filaActual.className = "FilaDatos " + id;
                    }
                    this.className = "FilaSeleccionada " + id;
                    filaActual = this;
                    if (ExistFunction("seleccionarFila")) seleccionarFila(id, idRegistro, this);
                }
            }

            var cabeceras = document.getElementsByClassName(id + " Cabecera");
            var nCabeceras = cabeceras.length;
            for (var j = 0; j < nCabeceras; j++) {
                if (cabeceras[j].className.indexOf("Texto") > -1) {
                    cabeceras[j].onkeyup = function (event) {
                        filtrarMatriz();
                    }
                }
                else {
                    cabeceras[j].onchange = function (event) {
                        filtrarMatriz();
                    }
                }
            }

            var btnBorrarFiltro = document.getElementById("btnBorrarFiltro" + id);
            if (btnBorrarFiltro != null) {
                btnBorrarFiltro.onclick = function () {
                    var cabeceras = document.getElementsByClassName(id + " Cabecera");
                    var nCabeceras = cabeceras.length;
                    for (var j = 0; j < nCabeceras; j++) {
                        cabeceras[j].value = "";
                    }
                    filtrarMatriz();
                }
            }

            var mnuExportar = document.getElementById("mnuExportar_" + id);
            if (mnuExportar != null) {
                mnuExportar.onmouseleave = function () {
                    var mnucheck = document.getElementById("mnucheck_" + id);
                    mnucheck.checked = false;
                }
            }

            var btnExportarTxt = document.getElementById("btnExportarTxt" + id);
            if (btnExportarTxt != null) {
                btnExportarTxt.onclick = function () {
                    var data = obtenerData("\r\n", ",");

                    if (_Options.NotExportIndex != '') {
                        var iData = data.split("\r\n");
                        var oData = [];
                        for (var i = 0; i < iData.length; i++) {
                            var iRegistro = iData[i].split(',');
                            var oRegistro = [];
                            for (var j = 0; j < iRegistro.length; j++) {
                                var iValor = _Options.NotExportIndex.split('|').filter((x) => x === j.toString()) || '';
                                if (iValor != '') continue;
                                oRegistro.push(iRegistro[j]);
                            }
                            oData.push(oRegistro.join(','));
                        }
                        data = oData.join("\r\n");
                    }
                    FileSystem.download(data, id + ".txt");
                }
            }

            var btnExportarXlsx = document.getElementById("btnExportarXlsx" + id);
            if (btnExportarXlsx != null) {
                btnExportarXlsx.onclick = function () {
                    var archivo = (iName == null ? id : iName) + ".xlsx";
                    var data = obtenerData("¬", "|", true).replace("\r", "").replace("\n", "");

                    var iData = data.split('¬')[3];
                    if (iData == "") {
                        Notify.Show("a", "No cuenta con registros para exportar.");
                        return;
                    }

                    var frm = new FormData();
                    frm.append("Data", data);
                    var iColumns = this.getAttribute("data-val") || '';
                    Http.postDownload("General/Exportar?archivo=" + archivo + "&pExcluidas=" + iColumns, function (rpta) {
                        FileSystem.download(rpta, archivo);
                    }, frm);
                }
            }

            var btnExportarDocx = document.getElementById("btnExportarDocx" + id);
            if (btnExportarDocx != null) {
                btnExportarDocx.onclick = function () {
                    var archivo = (iName == null ? id : iName) + ".docx";
                    var data = obtenerData("¬", "|", true).replace("\r", "").replace("\n", "");

                    var iData = data.split('¬')[3];
                    if (iData == "") {
                        Notify.Show("a", "No cuenta con registros para exportar.");
                        return;
                    }

                    var frm = new FormData();
                    frm.append("Data", data);
                    var iColumns = this.getAttribute("data-val") || '';
                    Http.postDownload("General/Exportar?archivo=" + archivo + "&pExcluidas=" + iColumns, function (rpta) {
                        FileSystem.download(rpta, archivo);
                    }, frm);
                }
            }

            var btnExportarPdf = document.getElementById("btnExportarPdf" + id);
            if (btnExportarPdf != null) {
                btnExportarPdf.onclick = function () {
                    //var archivo = id + ".pdf";
                    var archivo = (iName == null ? id : iName) + ".pdf";
                    var data = obtenerData("¬", "|", true).replace("\r", "");;
                    var frm = new FormData();
                    frm.append("Data", data);
                    var iColumns = this.getAttribute("data-val") || '';
                    Http.postDownload("General/Exportar?archivo=" + archivo + "&pExcluidas=" + iColumns, function (rpta) {
                        FileSystem.download(rpta, archivo);
                    }, frm);
                }
            }

            var btnImprimir = document.getElementById("btnImprimir" + id);
            if (btnImprimir != null) {
                btnImprimir.onclick = function () {
                    var html = "";
                    var nRegistros = matriz.length;
                    var cabeceras = _Options.DataTable[0].split("|");
                    var nCabeceras = cabeceras.length;
                    var anchos = _Options.DataTable[1].split("|");
                    var htmlImg = "";
                    htmlImg += "<img src='data:image/png;base64,";
                    htmlImg += hdfLogo.value;
                    htmlImg += "' style='width:80px;height:35px' title='Logo Provias'/>";

                    html += "<table style='width:100%;font-size:10px'>";
                    html += "<thead>";

                    html += "<tr>";
                    html += "<th colspan='";
                    html += nCabeceras;
                    html += "'>";

                    html += "<table style='width:100%;'>";

                    html += "<tr>";

                    html += "<td style='width:80%'>";
                    html += _Options.ReportTitle[1];
                    html += "</td>";

                    html += "<td style='width:20%;text-align:right'>";
                    html += htmlImg;
                    html += "</td>";

                    html += "</tr>";

                    html += "</table>";

                    html += "</th>";
                    html += "</tr>";


                    html += "<tr>";
                    html += "<th colspan='";
                    html += nCabeceras;
                    html += "'>";

                    html += "<table style='width:100%'>";

                    html += "<tr>";

                    html += "<td style='width:30%'>";
                    html += _Options.ReportTitle[2];
                    html += "</td>";

                    html += "<td style='width:50%;text-align:center'>";
                    html += "<div style='font-size:14px;font-weight:bold'>";
                    html += _Options.ReportTitle[3];
                    html += "</div>";
                    html += "</td>";

                    html += "<td style='width:20%;text-align:right'>";
                    html += _Options.ReportTitle[4];
                    html += "</td>";

                    html += "</tr>";

                    html += "</table>";

                    html += "</th>";
                    html += "</tr>";

                    html += "<tr>";
                    html += "<td colspan='";
                    html += nCabeceras;
                    html += "'>&nbsp;</td>";
                    html += "</tr>";

                    html += "<tr>";
                    for (var j = 0; j < nCabeceras; j++) {
                        html += "<th style='width:";
                        html += anchos[j];
                        html += "px;background-color:lightgray;border-top:solid;border-bottom:solid;border-width:1'>";
                        html += cabeceras[j];
                        html += "</th>";
                    }
                    html += "</tr>";
                    html += "</thead>";
                    html += "<tbody>";
                    var esFecha = false;
                    var esDecimal = false;
                    var esNumero = false;
                    for (var i = 0; i < nRegistros; i++) {
                        html += "<tr";
                        if (_Options.SubTotalsColumn.length > 0 && _Options.SubTotalsColumn[i] == "1") {
                            html += " style='font-weight:bold'";
                        }
                        html += ">";
                        for (var j = 0; j < nCabeceras; j++) {
                            esFecha = (tipos[j].indexOf("DateTime") > -1);
                            esDecimal = (tipos[j].indexOf("Decimal") > -1);
                            esNumero = (tipos[j].indexOf("Int") > -1 || esDecimal);
                            esNumeric = (tipos[j].indexOf("sNumeric") > -1);
                            html += "<td style='";
                            if (esNumero || esNumeric) {
                                html += "text-align:right;";
                            }
                            if (_Options.BorderIndex.length > 0 && matriz[i][j] && _Options.BorderIndex[i] == "1") {
                                html += "border-top:solid;border-width:1px";
                            }
                            html += "'>";
                            if (esFecha) html += mostrarFechaDMY(matriz[i][j]);
                            else {
                                if (esDecimal) html += numberWithCommas(matriz[i][j].toFixed(2));
                                else html += matriz[i][j];
                            }
                            html += "</td>";
                        }
                        html += "</tr>";
                    }
                    if (_Options.SubTotals.length > 0) {
                        html += "<tr>";
                        var nSubTotals = _Options.SubTotals.length;
                        var tipo;
                        var esDecimal;
                        var c = 0;
                        for (var j = 0; j < nCabeceras; j++) {
                            html += "<td style='text-align:right;font-weight:bold;";
                            if (_Options.SubTotals.indexOf(j) > -1) {
                                html += "border-top:double'>";
                                tipo = tipos[j];
                                esDecimal = (tipo.indexOf("Decimal") > -1);
                                if (esDecimal) html += numberWithCommas(totales[c].toFixed(2));
                                else html += totales[c];
                                c++;
                            }
                            else html += "'>";
                            html += "</td>";
                        }
                        html += "</tr>";
                    }
                    html += "</tbody>";
                    html += "</table>";
                    Impresion.imprimirTabla(html, _Options.ReportTitle[0]);
                }
            }

            var btnReload = document.getElementById("btnReload" + id);
            if (btnReload != null) {
                btnReload.onclick = function () {
                    if (ExistFunction("recargarGrilla")) {
                        recargarGrilla(id);
                    }
                    else {
                        Notify.Show("d", "No se encontro funcion -recargarGrilla-");
                    }
                }
            }

            var btnNuevo = document.getElementById("btnNuevo" + id);
            if (btnNuevo != null) {
                btnNuevo.onclick = function () {
                    if (ExistFunction("nuevoRegistro")) {
                        nuevoRegistro(id);
                    }
                    else {
                        Notify.Show("d", "No se encontro funcion -nuevoRegistro-");
                    }
                }
            }

            var btnsEditar = document.getElementsByClassName("Icono Centro Editar " + id);
            if (btnsEditar != null) {
                var nBtnsEditar = btnsEditar.length;
                for (var j = 0; j < nBtnsEditar; j++) {
                    btnsEditar[j].onclick = function () {
                        var fila = this.parentNode.parentNode;
                        var n = 0;
                        if (_Options.HasCheck) n = 1;
                        var cod = fila.childNodes[n].innerText;
                        //editarRegistro(id, cod, this);
                        if (ExistFunction("editarRegistro")) {
                            editarRegistro(id, cod, this);
                        }
                        else {
                            Notify.Show("d", "No se encontro funcion -editarRegistro-");
                        }
                    }
                }
            }

            var btnsDetalles = document.getElementsByClassName("Icono Centro Detalle " + id);
            if (btnsDetalles != null) {
                var nBtnsDetalles = btnsDetalles.length;
                for (var j = 0; j < nBtnsDetalles; j++) {
                    btnsDetalles[j].onclick = function () {
                        var fila = this.parentNode.parentNode;
                        var n = 0;
                        if (_Options.HasCheck) n = 1;
                        var cod = fila.childNodes[n].innerText;
                        //VerDetalles(id, cod, fila);
                        if (ExistFunction("VerDetalles")) {
                            VerDetalles(id, cod, fila);
                        }
                        else {
                            Notify.Show("d", "No se encontro funcion -VerDetalles-");
                        }
                    }
                }
            }

            var btnsEliminar = document.getElementsByClassName("Icono Centro Eliminar " + id);
            if (btnsEliminar != null) {
                var nBtnsEliminar = btnsEliminar.length;
                for (var j = 0; j < nBtnsEliminar; j++) {
                    btnsEliminar[j].onclick = function () {
                        var fila = this.parentNode.parentNode;
                        var n = 0;
                        if (_Options.HasCheck) n = 1;
                        var cod = fila.childNodes[n].innerText;
                        //eliminarRegistro(id, cod, fila);
                        if (ExistFunction("eliminarRegistro")) {
                            eliminarRegistro(id, cod, fila);
                        }
                        else {
                            Notify.Show("d", "No se encontro funcion -eliminarRegistro-");
                        }
                    }
                }
            }

            if (_Options.HasCheck) {
                var checks = document.getElementsByClassName("Check " + id);
                var nChecks = checks.length;
                var fila;
                var seleccionado;
                var esNumero = (tipos[0].indexOf("Int") > -1 || tipos[0].indexOf("Decimal") > -1 || tipos[0].indexOf("Numeric") > -1);
                var pos;
                for (var i = 0; i < nChecks; i++) {
                    checks[i].onchange = function () {
                        seleccionado = this.checked;
                        fila = this.parentNode.parentNode;
                        cod = fila.childNodes[1].innerText;
                        if (esNumero) cod = +cod;
                        if (seleccionado) {
                            _Options.ChecksId += (_Options.ChecksId == '' ? '' : '|') + cod;
                            filasChecks.push(buscarCodigo(cod));
                        }
                        else {
                            var iListaChecks = _Options.ChecksId.split('|');
                            pos = iListaChecks.indexOf(cod);
                            if (pos > -1) {
                                iListaChecks.splice(pos, 1);
                                _Options.ChecksId = iListaChecks.join('|');
                                filasChecks.splice(pos, 1);
                            }
                        }
                        div.setAttribute('data-check', _Options.ChecksId);
                    }
                }

                var chkCabecera = document.getElementById("chkCabecera " + id);
                if (chkCabecera != null) {
                    chkCabecera.onchange = function () {
                        var seleccionado = this.checked;
                        if (!seleccionado) {
                            _Options.ChecksId = [];
                            filasChecks = [];
                        }
                        var fila;
                        var cod;
                        var esNumero = (tipos[0].indexOf("Int") > -1 || tipos[0].indexOf("Decimal") > -1 || tipos[0].indexOf("Numeric") > -1);
                        for (var i = 0; i < nChecks; i++) {
                            checks[i].checked = seleccionado;
                            if (seleccionado) {
                                fila = checks[i].parentNode.parentNode;
                                cod = fila.childNodes[1].innerText;
                                if (esNumero) cod = +cod;
                                _Options.ChecksId.push(cod);
                                filasChecks.push(buscarCodigo(cod));
                            }
                        }
                        if (_Options.ChecksId.length > 0) {
                            div.setAttribute('data-check', _Options.ChecksId);
                        }
                        else {
                            div.setAttribute('data-check', '');
                        }
                        
                    }
                }
            }

            if (nButtons > 0) {
                var btnButtons = document.getElementsByClassName("Accion " + id);
                if (btnButtons.length > 0) {
                    for (var i = 0; i < nButtons; i++) {
                        btnButtons[i].onclick = function () {
                            var dataValue = this.getAttribute('data-value');
                            //accionGrilla(dataValue);
                            if (ExistFunction("accionGrilla")) {
                                accionGrilla(dataValue);
                            }
                            else {
                                Notify.Show("d", "No se encontro funcion -accionGrilla-");
                            }
                        }
                    }
                }
            }
        }

        function obtenerData(sepRegistros, sepCampos, tieneCabeceras) {
            var data = "";
            tieneCabeceras = (tieneCabeceras == null ? false : tieneCabeceras);
            var cabeceras = _Options.DataTable[0].split("|");
            var nCabeceras = cabeceras.length;
            var anchos = _Options.DataTable[1].split("|");
            data += cabeceras.join(sepCampos);
            data += sepRegistros;
            if (tieneCabeceras) {
                data += anchos.join(sepCampos);
                data += sepRegistros;
                data += tipos.join(sepCampos);
                data += sepRegistros;
            }
            var nRegistros = matriz.length;
            for (var i = 0; i < nRegistros; i++) {
                //data += matriz[i].join(sepCampos);
                for (var j = 0; j < nCabeceras; j++) {
                    esFecha = (tipos[j].indexOf("DateTime") > -1);
                    if (esFecha) data += mostrarFechaDMY(matriz[i][j]);
                    else data += matriz[i][j];
                    if (j < nCabeceras - 1) data += sepCampos;
                }
                if (i < nRegistros - 1) data += sepRegistros;
            }
            return data;
        }

        function configurarOrden() {
            if (_Options.HasOrden) {
                var enlaces = document.getElementsByClassName("Enlace " + id);
                var nEnlaces = enlaces.length;
                for (var j = 0; j < nEnlaces; j++) {
                    enlaces[j].onclick = function () {
                        ordenarColumna(this);
                    }
                }
            }
        }

        function ordenarColumna(span) {
            var orden = span.getAttribute("data-orden");
            colOrden = orden * 1;
            var spnSimbolo = span.nextSibling.nextSibling;
            var simbolo = spnSimbolo.innerHTML;
            borrarSimbolosOrdenacion();
            if (simbolo == "") {
                tipoOrden = 0;
                spnSimbolo.innerHTML = "▲";
                //matriz.sort(ordenarMatriz);
                //matriz.sort(OrdenMatriz);
                matriz.sortBy(el => el[colOrden])
            }
            else {
                if (simbolo == "▲") {
                    tipoOrden = 1;
                    spnSimbolo.innerHTML = "▼";
                    matriz.sortBy(el => el[colOrden], true)
                }
                else {
                    tipoOrden = 0;
                    spnSimbolo.innerHTML = "▲";
                    matriz.sortBy(el => el[colOrden])
                }
                //matriz.sort(OrdenMatriz);
                //matriz.sort((a, b) => b[colOrden] - a[colOrden]);

                //matriz.reverse();
            }
            mostrarMatriz();
        }

        function borrarSimbolosOrdenacion() {
            var enlaces = document.getElementsByClassName("Enlace " + id);
            var nEnlaces = enlaces.length;
            for (var j = 0; j < nEnlaces; j++) {
                enlaces[j].nextSibling.nextSibling.innerHTML = "";
            }
        }

        function configurarPaginacion() {
            var nRegistros = matriz.length;
            var totalPaginas = Math.floor(nRegistros / _Options.RowsForPage);
            if (nRegistros % _Options.RowsForPage > 0) totalPaginas++;
            var html = "";
            if (totalPaginas > 1) {
                var totalRegistros = matriz.length;
                var registrosBloque = _Options.RowsForPage * _Options.DisplayPages;
                var totalBloques = Math.floor(totalRegistros / registrosBloque);
                if (totalRegistros % registrosBloque > 0) totalBloques++;
                if (indiceBloque > 0) {
                    html += "<button class='Pag ";
                    html += id;
                    html += " Pagina' data-pag='-1'>";
                    html += "<<";
                    html += "</button>";
                    html += "<button class='Pag ";
                    html += id;
                    html += " Pagina' data-pag='-2'>";
                    html += "<";
                    html += "</button>";
                }
                var inicio = indiceBloque * _Options.DisplayPages;
                var fin = inicio + _Options.DisplayPages;
                for (var j = inicio; j < fin; j++) {
                    if (j < totalPaginas) {
                        html += "<button class='Pag ";
                        html += id;
                        html += " ";
                        if (indicePagina == j) html += "PaginaSeleccionada";
                        else html += "Pagina";
                        html += "' data-pag='";
                        html += j;
                        html += "'>";
                        html += (j + 1);
                        html += "</button>";
                    }
                    else break;
                }
                if (indiceBloque < (totalBloques - 1)) {
                    html += "<button class='Pag ";
                    html += id;
                    html += " Pagina' data-pag='-3'>";
                    html += ">";
                    html += "</button>";
                    html += "<button class='Pag ";
                    html += id;
                    html += " Pagina' data-pag='-4'>";
                    html += ">>";
                    html += "</button>";
                }
                html += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                html += "<select id='cboPagina";
                html += id;
                html += "' style='padding: 3px;'>";
                for (var j = 0; j < totalPaginas; j++) {
                    html += "<option value='";
                    html += j;
                    html += "'";
                    if (indicePagina == j) html += " selected";
                    html += ">";
                    html += (j + 1);
                    html += "</option>";
                }
                html += "</select>";
            }
            var tdPagina = document.getElementById("tdPagina" + id);
            if (tdPagina != null) {
                tdPagina.innerHTML = html;
                configurarEventosPagina();
            }
        }

        function configurarEventosPagina() {
            var paginas = document.getElementsByClassName("Pag " + id);
            var nPaginas = paginas.length;
            for (var j = 0; j < nPaginas; j++) {
                paginas[j].onclick = function () {
                    paginar(+this.getAttribute("data-pag"));
                }
            }

            var cboPagina = document.getElementById("cboPagina" + id);
            if (cboPagina != null) {
                cboPagina.onchange = function () {
                    paginar(this.value);
                }
            }
        }

        function paginar(indice) {
            if (indice > -1) {
                indicePagina = indice;
                indiceBloque = Math.floor(indicePagina / _Options.DisplayPages);
            }
            else {
                var totalRegistros = matriz.length;
                var registrosBloque = _Options.RowsForPage * _Options.DisplayPages;
                var totalBloques = Math.floor(totalRegistros / registrosBloque);
                if (totalRegistros % registrosBloque > 0) totalBloques++;
                switch (indice) {
                    case -1: //Primer Bloque
                        indiceBloque = 0;
                        indicePagina = 0;
                        break;
                    case -2: //Bloque Anterior
                        indiceBloque--;
                        indicePagina = indiceBloque * _Options.DisplayPages;
                        break;
                    case -3: //Bloque Siguiente
                        indiceBloque++;
                        indicePagina = indiceBloque * _Options.DisplayPages;
                        break;
                    case -4: //Ultimo Bloque
                        indiceBloque = (totalBloques - 1);
                        indicePagina = indiceBloque * _Options.DisplayPages;
                        break;
                }
            }
            var iSubTables = document.getElementById('hdfSubTables_' + id).value;
            if (iSubTables != '') { paginarAccion(id); }
            mostrarMatriz();
        }

        this.ObtenerMatriz = function () {
            return matriz;
        }

        this.ObtenerCheckIds = function () {
            var esNumero = (tipos[0].indexOf("Int") > -1 || tipos[0].indexOf("Decimal") > -1 || tipos[0].indexOf("Numeric") > -1);
            if (esNumero) _Options.ChecksId.sort(ordenarVector);
            else _Options.ChecksId.sort();
            return _Options.ChecksId;
        }

        this.ObtenerCheckFilas = function () {
            var esNumero = (tipos[0].indexOf("Int") > -1 || tipos[0].indexOf("Decimal") > -1 || tipos[0].indexOf("Numeric") > -1);
            if (esNumero) filasChecks.sort(ordenarMatrizAscCod);
            else filasChecks.sort();
            var data = [];
            var nFilasChecks = filasChecks.length;
            for (var i = 0; i < nFilasChecks; i++) {
                data.push(filasChecks[i].join("|"));
            }
            return data.join("¬");
        }

        function ordenarVector(x, y) {
            return (x > y ? 1 : -1);
        }

        function ordenarMatrizAscCod(x, y) {
            var idX = x[0];
            var idY = y[0];
            return (idX > idY ? 1 : -1);
        }

        function ordenarMatriz(x, y) {
            var rpta = 0;
            var idX = x[colOrden];
            var idY = y[colOrden];
            if (tipoOrden == 0) rpta = (idX > idY ? 1 : -1);
            else rpta = (idX < idY ? 1 : -1);
            return rpta;
        }

        function OrdenMatriz(x, y) {
            var rpta = 0;
            var keyA = x[colOrden].trim();
            var keyB = y[colOrden].trim();
            //
            if (keyA == "") keyA = 'AA';
            if (keyB == "") keyB = 'AB';
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
            }
            //
            //
            if (tipoOrden == 0) rpta = (iKeyA > iKeyB ? 1 : -1);
            else rpta = (iKeyA < iKeyB ? 1 : -1);
            //
            if (iKeyA == iKeyB) rpta = tipoOrden == 0 ? 1 : -1;
            return rpta;
        }

        function buscarCodigo(id) {
            var fila = [];
            var nRegistros = matriz.length;
            if (nRegistros > 0) {
                var nCampos = matriz[0].length;
                for (var i = 0; i < nRegistros; i++) {
                    if (matriz[i][0] == id) {
                        for (var j = 0; j < nCampos; j++) {
                            fila.push(matriz[i][j])
                        }
                        break;
                    }
                }
            }
            return fila;
        }
    }
    //
    UI.Combo = function (cbo, lista, indexValue = 0, primerItem) {
        var html = "";
        if (indexValue == null) indexValue = 0;
        if (primerItem != null) {
            html += "<option value='' data-value=''>";
            html += primerItem;
            html += "</option>";
        }
        var nRegistros = lista.length;
        for (var i = 0; i < nRegistros; i++) {
            campos = lista[i].split("|");
            html += "<option value='";
            html += campos.length > 1 ? (indexValue != 0 ? campos[indexValue] : campos[0]) : campos[0];
            html += `' data-value='${lista[i]}'>`
            html += campos.length > 1 ? campos[1] : campos[0];
            html += "</option>";
        }
        cbo.innerHTML = html;
    }
    //
    UI.Select = function (cbo, lista, indexValue = 0, primerItem) {
        var html = "";
        if (indexValue == null) indexValue = 0;
        if (primerItem != null) {
            html += "<option value='' data-value=''>";
            html += primerItem;
            html += "</option>";
        }
        var nRegistros = lista.length;
        for (var i = 0; i < nRegistros; i++) {
            campos = lista[i].split("|");
            html += "<option value='";
            html += campos.length > 1 ? (indexValue != 0 ? campos[indexValue] : campos[0]) : campos[0];
            html += `' data-value='${lista[i]}'>`
            html += campos.length > 1 ? campos[1] : campos[0];
            html += "</option>";
        }
        cbo.innerHTML = html;
    }
    //
    UI.MostrarDatos = function (claseMostrar, valoresMostrar) {
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
    //
    return UI;
})();

var Tools = (function () {
    function Tools() { }
    //
    Tools.MostrarDatos = function (claseMostrar, valoresMostrar) {
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
    //
    Tools.ObtenerDatos = function (claseGrabar) {
        var data = "";
        if (claseGrabar == null) claseGrabar = "G";
        var controles = document.getElementsByClassName(claseGrabar);
        var nControles = controles.length;

        for (var i = 0; i < nControles; i++) {
            if (controles[i].type == 'checkbox') {
                if (controles[i].checked == true) data += "1";
                else data += "0";
            }
            else if (controles[i].tagName == 'LABEL') data += controles[i].innerText;
            else if (controles[i].tagName == 'SPAN') data += controles[i].innerText;
            else data += controles[i].value.trim();
            if (i < nControles - 1) data += "|";
        }
        return (data);
    }
    //
    Tools.LimpiarDatos = function (claseBorrar) {
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
    //
    return Tools;
})();

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
    String.prototype.removeCharAt = function (i) {
        var tmp = this.split('');
        tmp.splice(i - 1, 1);
        return tmp.join('');
    }
    Valida.ValidarDatos = function (claseReq, claseNum) {
        var valido = Valida.ValidarRequeridos(claseReq);
        if (valido) {
            valido = Valida.ValidarNumeros(claseNum);
        }
        return valido;
    }
    return Valida;
})();

var Modal = (function () {
    function Modal() { }
    //
    Modal.Show = function (area, nameModal, fun, ancho = 60, alto = 60) {
        fetch('/Popups/' + area + '/' + nameModal + '.html')
            .then(res => res.text())
            .then(content => {
                divPopup.innerHTML = content;
                Modal.Size(ancho, alto);
                fun();
            });
    }
    Modal.Size = function (ancho, alto) {
        divPopupWindow.style.minWidth = ancho + "%";
        /*divPopupWindow.style.minHeight = alto + "%";*/
/*        this.parentElement.style.display = 'none'*/
    }
    //
    return Modal;
})();

var Notify = (function () {
    function Notify() { }
    //
    Notify.Show = function (type, message, time = 3000, title ='', icono = 'fa fa-info-circle') {
        //Notify.Clear();
        var iNotify = window.parent.document.getElementById('Notify');
        var iClass = "notify show";
        //
        iNotify.innerHTML = '';
        //
        var iTitle = 'Información:';
        var iStyle = ' n-info';
        var iIcono = icono;
        //
        if (type.toLowerCase() == 'e') {
            iStyle = ' n-error';
            iTitle = 'Error:';
            iIcono = 'fa fa-times-circle';
        }
        else if (type.toLowerCase() == 'a') {
            iStyle = ' n-alert';
            iTitle = 'Alerta:';
            iIcono = 'fa fa-exclamation-triangle';
        }
        else if (type.toLowerCase() == 's') {
            iStyle = ' n-success';
            iTitle = 'Éxito:';
            iIcono = 'fa fa-check-circle';
        }
        else if (type.toLowerCase() == 'i') {
            iStyle = ' n-info';
            iTitle = 'Información:';
        }
        else {
            iStyle = ' n-default';
            iTitle = 'Defecto:';
        }
        //
        iNotify.className = iClass + iStyle;
        //
        if (title != '') iTitle = title;
        var iNotifyBody = '';
        iNotifyBody += `<strong id="nClose" style="font-size: 0.9rem;position: inherit;top: 5px;right: 10px; cursor:pointer;" onclick='NotifyClose();'> x </strong>`;
        iNotifyBody += `<strong id="nTitle" style="font-size: 0.9rem;"><i class='${iIcono}' aria-hidden='true'></i> ${iTitle}</strong>`;
        iNotifyBody += `<p id="nMessage" style="font-size: 0.75rem;">${message}</p>`;
        iNotify.innerHTML = iNotifyBody;
        //
        setTimeout(function () {
            iNotify.className = iNotify.className.replace("show", "");
        }, time);
    }
    //
    Notify.Clear = function () {
        var iNotify = window.parent.document.getElementById('Notify');
        iNotify.innerHTML = '';
        iNotify.className = 'notify';
    };
    return Notify;
})();

var FileSystem = (function () {
    function FileSystem() {
    }
    FileSystem.getMime = function (archivo) {
        var mime = "";
        var campos = archivo.split(".");
        var extension = campos[campos.length - 1].toLowerCase();
        switch (extension) {
            case "txt":
                mime = "text/plain";
                break;
            case "csv":
                mime = "text/csv";
                break;
            case "json":
                mime = "application/json";
                break;
            case "xlsx":
                mime = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                break;
            case "docx":
                mime = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                break;
            case "pdf":
                mime = "application/pdf";
                break;
            case "png":
                mime = "image/png";
                break;
            case "jpg":
                mime = "image/jpg";
                break;
            default:
                mime = "application/octet-stream";
                break;
        }
        return mime;
    }
    FileSystem.download = function (data, archivo) {
        var mime = FileSystem.getMime(archivo);
        var blob = new Blob([data], { "type": mime });
        var link = document.createElement("a");
        link.href = URL.createObjectURL(blob);
        link.download = archivo;
        link.click();
    }
    return FileSystem;
})();