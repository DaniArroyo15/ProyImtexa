using General.Librerias.AccesoDatos;
using System.Web.Mvc;

namespace AppWeb.Areas.Almacen.Controllers
{
    public class AlmacenController : Controller
    {
        // GET: Almacen/Almacen

        daSQL odaSQL = new daSQL("con.GEN");

        #region ALMACEN : CATEGORIA
        public ActionResult Categoria()
        {
            return View();
        }

        public string ListaCategoria()
        {
            string rpta = "";
            var user = Session["Usuario"].ToString().Split('|');
            rpta = odaSQL.EjecutarComando("paCategoria_Lista");

            return rpta;
        }
        public string GrabaCategoria() {
            string rpta = "";
            string data = Request.Form["Data"];
            var user = Session["Usuario"].ToString().Split('|')[1];
            data = string.Format("{0}|{1}",data,user);
            rpta = odaSQL.EjecutarComando("paCategoria_Grabar", "@pData", data);
            return rpta;
        }

        public string CategoriaPorId(string CategoriaId) {
            string rpta = "";
            rpta = odaSQL.EjecutarComando("paCategoria_ObtenerPorId", "@pData", CategoriaId);
            return rpta;
        }

        #endregion

        #region ALMACEN : PRODUCTO

        public ActionResult Producto() {
            return View();
        }

        public string ListaProducto(string CategoriaId) {
            string rpta = "";
            rpta = odaSQL.EjecutarComando("paProducto_ListaPorCategoria", "@peIdCategoria", CategoriaId);
            return rpta;
        }

        #endregion
    }
}