using System.Web.Mvc;
using General.Librerias.AccesoDatos;

namespace AppWeb.Areas.Ventas.Controllers
{
    public class TarifaController : Controller
    {
        daSQL odaSQL = new daSQL("con.GEN");

        // GET: Almacen/Categoria
        public ActionResult vPrincipal()
        {
            return View();
        }

        public string List()
        {
            string iRpta = "";
            iRpta = odaSQL.EjecutarComando("paTarifa_Listar");
            //
            return iRpta;
        }
        public string ListId(string pId)
        {
            string iRpta = "";
            string[] iUser = Session["Usuario"].ToString().Split('|');
            iRpta = odaSQL.EjecutarComando("paTarifa_ListarPorId", "@pvcData", pId);
            return iRpta;
        }

        public string Add()
        {
            string iRpta = "";
            string iData = Request.Form["Data"];
            var iUser = Session["Usuario"].ToString().Split('|');
            iData = string.Format("{0}~{1}", iUser[0], iData);
            iRpta = odaSQL.EjecutarComando("paTarifa_Agregar", "@pvcData", iData);
            return iRpta;
        }
        public string Modify()
        {
            string iRpta = "";
            string iData = Request.Form["Data"];
            var iUser = Session["Usuario"].ToString().Split('|');
            iData = string.Format("{0}|{1}", iData, iUser[1]);
            iRpta = odaSQL.EjecutarComando("paTarifa_Modificar", "@pvcData", iData);
            return iRpta;
        }
        public string Delete(string pId)
        {
            string iRpta = "";
            var iUser = Session["Usuario"].ToString().Split('|');
            string iData = string.Format("{0}|{1}", pId, iUser[1]);
            iRpta = odaSQL.EjecutarComando("paTarifa_Eliminar", "@pvcData", iData);
            return iRpta;
        }
    }
}