using System.Web.Mvc;

namespace AppWeb.Areas.Convocatoria
{
    public class ConvocatoriaAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "Convocatoria";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            context.MapRoute(
                "Convocatoria_default",
                "Convocatoria/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}