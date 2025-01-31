using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;


namespace General.Librerias.CodigoUsuario
{
    public class Import
    {
        public String ImportExcel(Stream pExcel, int pHasHeader)
        {
            string iRpta = "";

            StringBuilder iSBRegistros = new StringBuilder();
            StringBuilder iSBCabecera = new StringBuilder();
            using (SpreadsheetDocument spreadSheetDocument = SpreadsheetDocument.Open(pExcel, false))
            {
                WorkbookPart workbookPart = spreadSheetDocument.WorkbookPart;
                IEnumerable<Sheet> sheets = spreadSheetDocument.WorkbookPart.Workbook.GetFirstChild<Sheets>().Elements<Sheet>();
                string relationshipId = sheets.First().Id.Value;
                WorksheetPart worksheetPart = (WorksheetPart)spreadSheetDocument.WorkbookPart.GetPartById(relationshipId);
                Worksheet workSheet = worksheetPart.Worksheet;
                SheetData sheetData = workSheet.GetFirstChild<SheetData>();
                IEnumerable<Row> rows = sheetData.Descendants<Row>();

                var iTotalColumns = 0;
                var iContFilas = 0;
                foreach (Row row in rows)
                {
                    if (row.InnerText == "") break;
                    //
                    var iFila = "";
                    var iCont = (pHasHeader == 1 ? 0 : 1);
                    if (iContFilas == 0) iTotalColumns = row.Descendants<Cell>().Count();
                    var iCeldas = row.Descendants<Cell>();
                    if (iCeldas != null)
                    {
                        for (int i = iCont; i < iTotalColumns; i++)
                        {
                            iFila += (i == 0 ? "" : "|") + GetCellValue(spreadSheetDocument, iCeldas.ElementAt(i));
                        }
                        if (iContFilas == 0)
                        {
                            iSBCabecera.AppendLine(iFila);
                        }
                        else
                        {
                            iSBRegistros.AppendLine(iFila);
                        }
                        iContFilas++;
                    }

                }
            }
            string[] iDatos = iSBRegistros.ToString().Split(new string[] { Environment.NewLine }, StringSplitOptions.None);
            string[] iCabecera = iSBCabecera.ToString().Split(new string[] { Environment.NewLine }, StringSplitOptions.None);
            iRpta = iCabecera[0] + '~' + string.Join("¬", iDatos);
            return iRpta;
        }

        public static string GetCellValue(SpreadsheetDocument document, Cell cell)
        {
            if (cell == null || cell.CellValue == null)
            {
                return string.Empty;
            }

            SharedStringTablePart stringTablePart = document.WorkbookPart.SharedStringTablePart;
            string value = cell.CellValue.InnerXml;
            if (cell.DataType != null && cell.DataType.Value == CellValues.SharedString)
            {
                return stringTablePart.SharedStringTable.ChildElements[Int32.Parse(value)].InnerText;
            }
            else
            {
                return value;
            }
        }


    }
}
