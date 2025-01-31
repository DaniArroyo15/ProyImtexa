using AppWeb.Filters;
using General.Librerias.AccesoDatos;
using General.Librerias.CodigoUsuario;
using System;
using System.Configuration;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Mvc;
using io = System.IO;

namespace AppWeb.Controllers
{
    [FiltroAutenticacion]
    public class GeneralController : Controller
    {
        private daSQL odaSQLRH = new daSQL("con.GEN");

        // GET: General
        public ActionResult Index()
        {
            return View();
        }

        public FileResult GetAvatar()
        {
            FileResult rpta = null;
            //int idPersonal = Int32.Parse(Session["Usuario"].ToString().Split('|')[4]) * 1;
            //string iPhotoUrl = ConfigurationManager.AppSettings["App.UrlPhoto"];
            //string iUrlFileImagen = Path.Combine(iPhotoUrl, idPersonal + ".jpg");
            //if (io.File.Exists(iUrlFileImagen))
            //{
            //    rpta = File(iUrlFileImagen, "image/jpg");
            //}
            return rpta;
        }

        public string Importar(string pTabla, int pHasHeader = 1)
        {
            string iRpta = null;
            if (Request.Files.Count > 0)
            {
                HttpPostedFileBase iFile = Request.Files[0];
                int size = iFile.ContentLength;
                Stream iExcel = iFile.InputStream;
                byte[] buffer = new byte[size];
                iExcel.Read(buffer, 0, size);
                //
                var iData = new Import().ImportExcel(iExcel, pHasHeader);
                //
                var iStore = "pa" + pTabla + "_Importar";
                //
                string idEmpleado = Session["Usuario"].ToString().Split('|')[0];
                string iParamValue = idEmpleado + "~" + iData;
                //
                iRpta = odaSQLRH.EjecutarComando(iStore, "@pvcData", iParamValue);
            }
            return iRpta;
        }


        public FileResult Exportar(string archivo, string pExcluidas = "")
        {
            FileResult rpta = null;
            string nombreReporte = Path.GetFileNameWithoutExtension(archivo);
            string extension = Path.GetExtension(archivo).ToLower();
            string data = Request.Form["Data"];
            DataTable tabla = Cadena.ConvertirTabla(data, pExcluidas);
            if (tabla != null && tabla.Rows.Count > 0)
            {
                DataSet dst = new DataSet();
                dst.Tables.Add(tabla);
                byte[] buffer = null;
                if (extension == ".xlsx")
                {
                    ExcelMemory excel = new ExcelMemory();
                    buffer = excel.Exportar(new string[] { nombreReporte }, dst);
                }
                if (extension == ".docx")
                {
                    WordMemory word = new WordMemory();
                    buffer = word.Exportar(dst, "Reporte de " + nombreReporte, "H");
                }
                if (extension == ".pdf") buffer = PDFMemory.Exportar(tabla, "Reporte de " + nombreReporte);
                if (buffer != null && buffer.Length > 0) rpta = File(buffer, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");

            }
            tabla.Dispose();
            return rpta;
        }
    }
}