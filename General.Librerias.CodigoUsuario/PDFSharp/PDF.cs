using General.Librerias.CodigoUsuario.Entities;
using PdfSharp.Drawing;
using PdfSharp.Drawing.Layout;
using PdfSharp.Pdf;
using System;
using System.IO;

namespace General.Librerias.CodigoUsuario.PDFSharp
{
    public class PDF
    {
        public Response Papeleta(string pUrlLogo, string pData)
        {

            Response iResponse = new Response();
            //
            String iStatus = "KO";
            String iMessage = "Error : PDFSharp + Papeleta";
            String iInfo = "";
            dynamic iData = null;
            try
            {
                //
                var iTablas = pData.Split('~');
                var iListCabecera = iTablas[0].Split('|');
                var iListData = iTablas[1].Split('|');
                //
                XPen pen = new XPen(XColors.Gray, 0.5f);
                XPen penS = new XPen(XColors.GhostWhite, 0.1f);
                //
                PdfDocument document = new PdfDocument();
                document.Info.Title = "SGRH - Papeleta Nro " + iListData[1];
                //
                PdfPage page = document.AddPage();
                page.Size = PdfSharp.PageSize.A5;
                page.Orientation = PdfSharp.PageOrientation.Portrait;
                XGraphics gfx = XGraphics.FromPdfPage(page);
                //
                XFont font = new XFont("Arial", 7, XFontStyle.Regular);
                XFont iFontTitle = new XFont("Arial", 8, XFontStyle.Bold);
                XFont iFontText = new XFont("Arial", 8, XFontStyle.Regular);
                //
                var iMaxLong = (int)((int)page.Width * 0.26f);
                //
                double x = 20, y = 75;

                // Logo // -----------------------------------------------------------------------------------------------------------------------------------------------------------
                y += 0;
                var iUrLogo = pUrlLogo + (pUrlLogo.EndsWith("\\") ? "" : "\\")  + @"\Logo.png";
                XImage image = XImage.FromFile(iUrLogo);
                gfx.DrawImage(image, 100, 20, page.Width - 200, 50);

                // Encabezado // -----------------------------------------------------------------------------------------------------------------------------------------------------------
                y += 0;
                gfx.DrawString('"' + iListCabecera[0] + '"', font, XBrushes.Gray, new XRect(0, y, page.Width, 20), XStringFormats.Center);
                y += 10;
                var iText = FormatParrafo(iListCabecera[1], iMaxLong).Split('|');
                var iCont = 0;
                foreach (string _item in iText)
                {
                    gfx.DrawString(iCont == 0 ? '"' + _item : (iCont + 1 < iText.Length ? _item : _item + '"'), font, XBrushes.Gray, new XRect(0, y, page.Width, 20), XStringFormats.Center);
                    iCont++;
                    y += 10;
                }

                // Titulo  // -----------------------------------------------------------------------------------------------------------------------------------------------------------
                y += 10;
                gfx.DrawLine(pen, x, y, (page.Width - 20), y); // Linea
                font = new XFont("Arial", 10, XFontStyle.Bold);
                gfx.DrawString("PAPELETA DE AUTORIZACIÓN DE PERSONAL", font, XBrushes.Black, new XRect(0, y, page.Width, 20), XStringFormats.Center);
                y += 15;
                gfx.DrawString("Nro : " + iListData[1], font, XBrushes.Black, new XRect(0, y, page.Width, 20), XStringFormats.Center);
                y += 20;
                gfx.DrawLine(pen, x, y, (page.Width - 20), y); // Linea

                // Trabajador // -----------------------------------------------------------------------------------------------------------------------------------------------------------
                y += 0;
                gfx.DrawRectangle(pen, new XSolidBrush(XColors.GhostWhite), new XRect(20f, y + 22f, 60f, 20f)); // Rectangulo
                gfx.DrawRectangle(pen, new XSolidBrush(XColors.GhostWhite), new XRect(80f, y + 22f, ((int)page.Width - 100f), 20f)); // Rectangulo
                gfx.DrawString("Código ", iFontTitle, XBrushes.Black, new XRect(23f, y, 100f, 30f), XStringFormats.CenterLeft);
                gfx.DrawString("Trabajador ", iFontTitle, XBrushes.Black, new XRect(90f, y, 100f, 30f), XStringFormats.CenterLeft);
                y += 17;
                gfx.DrawString(iListData[3].Split('-')[0].Trim(), iFontText, XBrushes.Black, new XRect(25f, y, 100f, 30f), XStringFormats.CenterLeft);
                gfx.DrawString(iListData[3].Split('-')[1].Trim(), iFontText, XBrushes.Black, new XRect(90f, y, 230f, 30f), XStringFormats.CenterLeft);

                // Tipo de Papeleta // -----------------------------------------------------------------------------------------------------------------------------------------------------------
                y += 22;
                gfx.DrawRectangle(pen, new XSolidBrush(XColors.GhostWhite), new XRect(20f, y + 22f, ((int)page.Width - 40f), 20f)); // Rectangulo
                gfx.DrawString("Tipo de Papeleta ", iFontTitle, XBrushes.Black, new XRect(23f, y, 100f, 30f), XStringFormats.CenterLeft);
                y += 17;
                gfx.DrawString(iListData[4].Trim(), iFontText, XBrushes.Black, new XRect(25f, y, 100f, 30f), XStringFormats.CenterLeft);
                font = new XFont("Arial", 7, XFontStyle.Bold);

                // Sustento // -----------------------------------------------------------------------------------------------------------------------------------------------------------
                y += 22;
                gfx.DrawString("Sustento ", iFontTitle, XBrushes.Black, new XRect(23f, y, 100f, 30f), XStringFormats.CenterLeft);
                y += 13;
                var iHeiht = FormatParrafo(iListData[6].Trim(), iMaxLong).Split('|').Length * 10f;
                gfx.DrawRectangle(pen, new XSolidBrush(XColors.GhostWhite), new XRect(20f, y + 10, ((int)page.Width - 40f), iHeiht + 15)); // Rectangulo
                y += 10;
                XTextFormatter tf = new XTextFormatter(gfx);
                XRect rect = new XRect(25f, y + 5, ((int)page.Width - 50f), iHeiht);
                gfx.DrawRectangle(penS, new XSolidBrush(XColors.GhostWhite), rect);
                tf.Alignment = XParagraphAlignment.Justify;
                tf.DrawString(iListData[6].Trim(), iFontText, XBrushes.Black, rect, XStringFormats.TopLeft);
                //

                // Duracion // -----------------------------------------------------------------------------------------------------------------------------------------------------------
                y += iHeiht + 13f;
                gfx.DrawString("Duración ", iFontTitle, XBrushes.Black, new XRect(23f, y, 100f, 30f), XStringFormats.CenterLeft);
                y += 17;
                gfx.DrawRectangle(pen, new XSolidBrush(XColors.GhostWhite), new XRect(20f, y + 5, 140f, 23f)); // Rectangulo
                gfx.DrawRectangle(pen, new XSolidBrush(XColors.GhostWhite), new XRect(160f, y + 5, 140f, 23f)); // Rectangulo
                gfx.DrawRectangle(pen, new XSolidBrush(XColors.White), new XRect(20f, y + 28, 140f, 60f)); // Rectangulo
                gfx.DrawRectangle(pen, new XSolidBrush(XColors.White), new XRect(160f, y + 28, 140f, 60f)); // Rectangulo
                y += 2;
                gfx.DrawString("Por Días ", iFontTitle, XBrushes.Black, new XRect(25f, y, 120f, 30f), XStringFormats.CenterLeft);
                gfx.DrawString("Por Horas ", iFontTitle, XBrushes.Black, new XRect(170f, y, 120f, 30f), XStringFormats.CenterLeft);
                y += 23;
                gfx.DrawString("Desde :", iFontTitle, XBrushes.Black, new XRect(25f, y, 100f, 30f), XStringFormats.CenterLeft);
                gfx.DrawString("Hasta :", iFontTitle, XBrushes.Black, new XRect(25f, y + 16f, 100f, 30f), XStringFormats.CenterLeft);
                gfx.DrawString(iListData[7].Trim(), iFontText, XBrushes.Black, new XRect(60f, y, 100f, 30f), XStringFormats.CenterLeft);
                gfx.DrawString(iListData[9].Trim(), iFontText, XBrushes.Black, new XRect(60f, y + 16f, 100f, 30f), XStringFormats.CenterLeft);
                gfx.DrawString("Salida :", iFontTitle, XBrushes.Black, new XRect(170f, y, 100f, 30f), XStringFormats.CenterLeft);
                gfx.DrawString("Retorno :", iFontTitle, XBrushes.Black, new XRect(170f, y + 16f, 100f, 30f), XStringFormats.CenterLeft);
                gfx.DrawString(iListData[8].Trim(), iFontText, XBrushes.Black, new XRect(210f, y, 100f, 30f), XStringFormats.CenterLeft);
                gfx.DrawString(iListData[10].Trim(), iFontText, XBrushes.Black, new XRect(210f, y + 16f, 100f, 30f), XStringFormats.CenterLeft);
                y += 32;
                gfx.DrawString("Total :", iFontTitle, XBrushes.Black, new XRect(25f, y, 100f, 30f), XStringFormats.CenterLeft);
                gfx.DrawString("Total :", iFontTitle, XBrushes.Black, new XRect(170f, y, 100f, 30f), XStringFormats.CenterLeft);
                gfx.DrawString(iListData[11].Trim(), iFontText, XBrushes.Black, new XRect(60f, y, 100f, 30f), XStringFormats.CenterLeft);
                gfx.DrawString(iListData[12].Trim(), iFontText, XBrushes.Black, new XRect(210f, y, 100f, 30f), XStringFormats.CenterLeft);
                //
                // Firma // -----------------------------------------------------------------------------------------------------------------------------------------------------------
                gfx.DrawString("<firma>", iFontTitle, XBrushes.Black, new XRect(23f, (int)page.Height - 120f, 30f, 30f), XStringFormats.CenterLeft);

                // Autorizado // -----------------------------------------------------------------------------------------------------------------------------------------------------------
                gfx.DrawLine(pen, x, (int)page.Height - 42f, (page.Width - 20), (int)page.Height - 45f); // Linea
                gfx.DrawString("Autorizado Por : " + iListData[13].Trim(), iFontTitle, XBrushes.Black, new XRect(23f, (int)page.Height - 40f, 100f, 30f), XStringFormats.CenterLeft);
                //
                using (MemoryStream stream = new MemoryStream())
                {
                    document.Save(stream, true);
                    iData = stream.ToArray();
                    stream.Dispose();
                    stream.Close();
                }
                //
                iStatus = "OK";
                iMessage = "Generación Satisfactoria";
                iInfo = iListData[1] + "_" + iListData[3] + ".pdf";
            }
            catch (Exception iEx)
            {
                iStatus = "KO";
                iResponse.Message = iEx.Message;
                iResponse.Data = null;
                iInfo = "";
            }
            finally 
            {
                iResponse.Status = iStatus;
                iResponse.Message = iMessage;
                iResponse.Info = iInfo;
                iResponse.Data = iData;
            }
            //
            return iResponse;
        }

        public string FormatParrafo(string pText, int pMaxLong)
        {
            var iParrafo = "";
            var iParrafos = pText.Split('\n');

            foreach (string iLinea in iParrafos)
            {
                var iData = iLinea.Split(' ');
                var iLine = "";
                var iContPartes = 1;

                foreach (string iPart in iData)
                {
                    var iTemp = iLine + ' ' + iPart;
                    if (iTemp.Length > pMaxLong || iContPartes == iData.Length)
                    {
                        if (iContPartes == iData.Length) { iParrafo += "|" + iTemp; }
                        else { iParrafo += "|" + iLine; }
                        //
                        iLine = "";
                    }
                    iLine = iLine + ' ' + iPart;
                    iLine = iLine.TrimStart();
                    iContPartes++;
                }
            }            
            //
            var iRetorno = iParrafo.Substring(1, (iParrafo.Length - 1));
            return iRetorno;
        }

        public int NroLineas(string pText, int pMaxLong)
        {
            var iData = pText.Split(' ');
            var iLine = "";
            var iContPartes = 1;
            foreach (string iPart in iData)
            {
                var iTemp = iLine + ' ' + iPart;
                if (iTemp.Length > pMaxLong || iContPartes == iData.Length) iLine = "";
                iLine = iLine + ' ' + iPart;
                iLine = iLine.TrimStart();
                iContPartes++;
            }
            return iContPartes;
        }
    }

}
