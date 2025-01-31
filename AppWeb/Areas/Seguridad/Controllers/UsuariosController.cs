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
        public ActionResult Index()
        {
            return View();
        }
    }
}