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

        // GET: Almacen/Producto
        public ActionResult Producto()
        {
            return View();
        }

        public string ListaCategoria()
        {
            string rpta = "";
            rpta = odaSQL.EjecutarComando("paCategoria_ListarCombo");
            return rpta;
        }
        public string ListaProducto(string CategoriaId)
        {
            string rpta = "";
            rpta = odaSQL.EjecutarComando("paProducto_ListaPorCategoria", "@peIdCategoria", CategoriaId);
            return rpta;
        }

        public string GrabaProducto()
        {
            string rpta = "";
            string data = Request.Form["Data"];
            var user = Session["Usuario"].ToString().Split('|');
            data = string.Format("{0}~{1}", user[1],data);
            rpta = odaSQL.EjecutarComando("paProducto_Grabar", "@pvcData", data);
            return rpta;
        }

        public string ListaProductoId(string ProductoId)
        {
            string rpta = "";
            rpta = odaSQL.EjecutarComando("paProducto_ObtenerPorId", "@peIdProducto", ProductoId);
            return rpta;
        }

        public string EliminaProducto(string ProductoId)
        {
            string rpta = "";
            var user = Session["Usuario"].ToString().Split('|');
            string data = string.Format("{0}~{1}", user[1], ProductoId);
            rpta = odaSQL.EjecutarComando("paProducto_Eliminar", "@pvcData", data);
            return rpta;
        }
    }
}