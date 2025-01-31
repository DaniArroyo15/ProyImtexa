using AppWeb.Filters;
using General.Librerias.AccesoDatos;
using System.Web.Mvc;

namespace AppWeb.Areas.Convocatoria.Controllers
{
    [FiltroAutenticacion]
    public class _ConvocatoriaController : Controller
    {
        daSQL odaSQL = new daSQL("con.SISMA");
        // GET: Convocatoria/Convocatoria
        public ActionResult Index()
        {
            return View();
        }

        public string ListarPrincipal(string pPeriodo, string pTipo, string pEstado)
        {
            string iRpta = "";
            string iData = string.Format("{0}|{1}|{2}", pPeriodo, pTipo, pEstado);
            //
            iRpta = odaSQL.EjecutarComando("paGenSelConvocatorias_Listar", "@pvcData", iData);
            return iRpta;
        }

        public string ListarPorId(string pData)
        {
            string iRpta = "";
            //
            iRpta = odaSQL.EjecutarComando("paGenSelConvocatorias_ListarPorId", "@pvcData", pData);
            return iRpta;
        }


        public ActionResult Convocatoria(string pPlazaVacante)
        {
            ViewData["_PlazaVacante"] = pPlazaVacante;
            return View();
        }
    }
}