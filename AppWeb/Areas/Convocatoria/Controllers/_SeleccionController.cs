using AppWeb.Filters;
using General.Librerias.AccesoDatos;
using System.Web.Mvc;

namespace AppWeb.Areas.Convocatoria.Controllers
{
    [FiltroAutenticacion]
    public class _SeleccionController : Controller
    {
        daSQL odaSQL = new daSQL("con.SISMA");

        // GET: Convocatoria/Seleccion
        public ActionResult Index()
        {
            return View();
        }

        public string ListarInicial()
        {
            string iRpta = "";
            iRpta = odaSQL.EjecutarComando("paGenSelMProceso_ListarInicial");
            return iRpta;
        }
        public string ListarProcesos(string pPeriodo, string pTipo)
        {
            string iRpta = "";
            string iData = string.Format("{0}|{1}", pPeriodo, pTipo);
            //
            iRpta = odaSQL.EjecutarComando("paGenSelMProceso_ListarPorPeriodoTProceso", "@pvcData", iData);
            return iRpta;
        }
        public string ListarPlazas(string pNroProceso)
        {
            string iRpta = "";
            //
            iRpta = odaSQL.EjecutarComando("paGenSelMPlaza_ListarPorNroProceso", "@pvcData", pNroProceso);
            return iRpta;
        }
        public string ListarEtapas(string pNroPlaza)
        {
            string iRpta = "";
            //
            iRpta = odaSQL.EjecutarComando("paGenSelMEtapa_ListarPorNroPlaza", "@pvcData", pNroPlaza);
            return iRpta;
        }
        public string ListarPostulantes(string pNroProcEtapa)
        {
            string rpta = "";
            //
            rpta = odaSQL.EjecutarComando("paGenSelPostEtapa_ListPostulantes", "@pvcData", pNroProcEtapa);
            return rpta;
        }
    }
}