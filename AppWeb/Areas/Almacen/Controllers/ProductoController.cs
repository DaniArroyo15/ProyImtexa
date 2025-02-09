using General.Librerias.AccesoDatos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AppWeb.Areas.Almacen.Controllers
{
    public class ProductoController : Controller
    {
        daSQL odaSQL = new daSQL("con.GEN");

        public ActionResult vPrincipal()
        {
            return View();
        }

        public string List()
        {
            string iRpta = "";
            iRpta = odaSQL.EjecutarComando("paProducto_Listar");
            //
            return iRpta;
        }
        public string ListId(string pId)
        {
            string iRpta = "";
            string[] iUser = Session["Usuario"].ToString().Split('|');
            iRpta = odaSQL.EjecutarComando("paProducto_ListarPorId", "@pvcData", pId);
            return iRpta;
        }

        public string Add()
        {
            string iRpta = "";
            string iData = Request.Form["Data"];
            var iUser = Session["Usuario"].ToString().Split('|');
            iData = string.Format("{0}~{1}", iUser[0], iData);
            iRpta = odaSQL.EjecutarComando("paProducto_Agregar", "@pvcData", iData);
            return iRpta;
        }
        public string Modify()
        {
            string iRpta = "";
            string iData = Request.Form["Data"];
            var iUser = Session["Usuario"].ToString().Split('|');
            iData = string.Format("{0}|{1}", iData, iUser[1]);
            iRpta = odaSQL.EjecutarComando("paProducto_Modificar", "@pvcData", iData);
            return iRpta;
        }
        public string Delete(string pId)
        {
            string iRpta = "";
            var iUser = Session["Usuario"].ToString().Split('|');
            string iData = string.Format("{0}|{1}", pId, iUser[1]);
            iRpta = odaSQL.EjecutarComando("paProducto_Eliminar", "@pvcData", iData);
            return iRpta;
        }
    }
}