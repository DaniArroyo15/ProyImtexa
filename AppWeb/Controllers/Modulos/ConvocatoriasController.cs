using AppWeb.Filters;
using General.Librerias.AccesoDatos;
using System.Web.Mvc;

namespace AppWeb.Controllers
{
    [FiltroAutenticacion]
    public class ConvocatoriasController : Controller
    {
        daSQL odaSQL = new daSQL("con.SISMA");

        public ActionResult Index()
        {
            return View();
        }
        public string ListarInicial()
        {
            string iRpta = "";
            iRpta = odaSQL.EjecutarComando("paGenSelConvocatorias_ListarInicial");
            return iRpta;
        }
    }
}