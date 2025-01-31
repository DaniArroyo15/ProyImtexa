using AppWeb.Filters;
using General.Librerias.AccesoDatos;
using System.Collections.Generic;
using System.Configuration;
using System.Web.Mvc;

namespace AppWeb.Controllers
{
    [FiltroAutenticacion]
    public class HomeController : Controller
    {
        // GET: Home
        public ActionResult Home()
        {
            var iEscenario = ConfigurationManager.ConnectionStrings["con.GEN"].ConnectionString.ToUpper().Split(';')[0].Split('=')[1];
            //
            ViewData["_Version"] = ConfigurationManager.AppSettings["App.Version"];
            ViewData["_Ambiente"] = iEscenario;
            //
            return View();
        }

        public string GetMenu()
        {
            //
            var Usuario = Session["Usuario"].ToString().Split('|');
            //
            string rpta = "";
            daSQL odaSQL = new daSQL("con.GEN");
            //Usuario[4] = (132533).ToString();
            rpta = odaSQL.EjecutarComando("paMenu_ListarOpcionPorUsuario", "@peIdUsuario", Usuario[0]);
            if (rpta != "")
            {
                string[] lista = rpta.Split('¬');
                List<string> listaMenu = new List<string>();
                int nRegistros = lista.Length;
                string[] campos;
                for (int i = 0; i < nRegistros; i++)
                {
                    campos = lista[i].Split('|');
                    listaMenu.Add(campos[2]);
                }
                Session["menu"] = listaMenu;
            }
            return rpta;
        }
    }
}