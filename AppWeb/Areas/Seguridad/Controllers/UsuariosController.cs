using General.Librerias.AccesoDatos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AppWeb.Areas.Seguridad.Controllers
{
    public class UsuariosController : Controller
    {
        // GET: Seguridad/Usuarios

        daSQL odaSql = new daSQL("con.GEN");

        public ActionResult Index()
        {
            return View();
        }

        public string Principal()
        {
            string rpta = "";
            rpta = odaSql.EjecutarComando("paUsuario_Listar");
            return rpta;
        }

        public string ObtenerUsuario(string UsuarioId)
        {
            string rpta = "";
            rpta = odaSql.EjecutarComando("paUsuario_ObtenerPorId", "@peIdUsuario", UsuarioId);
            return rpta;
        }

        public string GrabaUsuario()
        {
            string rpta = "";
            string data = Request.Form["Data"];
            string user = Session["Usuario"].ToString().Split('|')[1];
            data = string.Format("{0}~{1}", user, data);
            rpta = odaSql.EjecutarComando("paUsuario_Grabar", "@pvcData", data);
            return rpta;
        }

        public string EliminaUsuario(string UsuarioId)
        {
            string rpta = "";
            string user = Session["Usuario"].ToString().Split('|')[1];
            string data = string.Format("{0}~{1}", user, UsuarioId);
            rpta = odaSql.EjecutarComando("paUsuario_Eliminar", "@pvcData", data);
            return rpta;
        }
    }
}