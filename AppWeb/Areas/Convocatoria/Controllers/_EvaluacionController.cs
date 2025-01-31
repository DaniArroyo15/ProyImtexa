using AppWeb.Filters;
using System.Web.Mvc;

namespace AppWeb.Areas.Convocatoria.Controllers
{
    [FiltroAutenticacion]
    public class _EvaluacionController : Controller
    {
        // GET: Convocatoria/Evaluacion
        public ActionResult Index()
        {
            return View();
        }
    }
}