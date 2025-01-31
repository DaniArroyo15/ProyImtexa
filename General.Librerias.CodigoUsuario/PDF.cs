using System;
using System.IO;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using iTextSharp;
using iTextSharp.text;
using iTextSharp.text.pdf;

namespace General.Librerias.CodigoUsuario
{
    public class PDF
    {
        private static PdfPTable serializarTablaPDF(DataTable tabla)
        {
            int nCols = tabla.Columns.Count;
            int nFilas = tabla.Rows.Count;
            string campo;
            string ancho;
            List<int> anchos = new List<int>();
            PdfPTable tablaPdf = new PdfPTable(nCols);
            Font fuente = FontFactory.GetFont("Arial Black", float.Parse("15"), BaseColor.BLACK);
            PdfPCell celdaPdf = new PdfPCell(new Phrase(tabla.TableName, fuente));
            celdaPdf.Colspan = nCols;
            celdaPdf.HorizontalAlignment = 1;
            celdaPdf.BackgroundColor = BaseColor.GRAY;
            tablaPdf.AddCell(celdaPdf);
            if (nCols > 0 && nFilas > 0)
            {
                for (int j = 0; j < nCols; j++)
                {
                    campo = tabla.Columns[j].ColumnName;
                    ancho = tabla.Columns[j].Caption;
                    anchos.Add(int.Parse(ancho));
                    celdaPdf = new PdfPCell(new Phrase(campo));
                    celdaPdf.BackgroundColor = BaseColor.LIGHT_GRAY;
                    tablaPdf.AddCell(celdaPdf);
                }
                tablaPdf.SetWidths(anchos.ToArray());
                for (int i = 0; i < nFilas; i++)
                {
                    for (int j = 0; j < nCols; j++)
                    {
                        tablaPdf.AddCell(tabla.Rows[i][j].ToString());
                    }
                }
            }
            return tablaPdf;
        }

        public static void Crear(string archivo, DataTable tabla)
        {
            using (FileStream ms = new FileStream(archivo, FileMode.Create, FileAccess.Write, FileShare.ReadWrite))
            {
                using (iTextSharp.text.Document oDocumento = new iTextSharp.text.Document())
                {
                    iTextSharp.text.pdf.PdfWriter oPDF = iTextSharp.text.pdf.PdfWriter.GetInstance(oDocumento, ms);
                    oDocumento.Open();
                    oDocumento.Add(serializarTablaPDF(tabla));
                    oDocumento.Close();
                }
            }
        }
    }
}
