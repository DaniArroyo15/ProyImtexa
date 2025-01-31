using System;
using System.Collections.Generic;
using System.Web.Mvc;
using System.Web.Mvc.Async;

namespace AppWeb.Filters
{
    public class FiltroAutenticacion : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            var iMessage = "Sesión Expirada";
            object sesionUsuario = filterContext.HttpContext.Session["Usuario"];
            if (sesionUsuario == null)
            {
                filterContext.Result = new ContentResult {
                    Content = string.Format("<script type='text/javascript'>window.parent.location.href = '{0}';</script>", "/Login/SignOut?pData=" + iMessage), ContentType = "text/html"};
            }
            else
            {
                string controlador = filterContext.ActionDescriptor.ControllerDescriptor.ControllerName;
                string accion = filterContext.ActionDescriptor.ActionName;
                string url = controlador + "/" + accion;
                string tipo = "";
                if (filterContext.ActionDescriptor is ReflectedActionDescriptor)
                    tipo = ((ReflectedActionDescriptor)filterContext.ActionDescriptor).MethodInfo.ReturnType.ToString().Contains("ActionResult") ? "Accion" : "Metodo";
                if (filterContext.ActionDescriptor is TaskAsyncActionDescriptor)
                    tipo = ((TaskAsyncActionDescriptor)filterContext.ActionDescriptor).MethodInfo.ReturnType.ToString().Contains("ActionResult") ? "Accion" : "Metodo";

                bool valido = (controlador == "Home");
                if (tipo == "Accion")
                {
                    if (controlador != "Home" && filterContext.HttpContext.Session["menu"] != null)
                    {
                        List<string> listaMenu = (List<string>)filterContext.HttpContext.Session["menu"];
                        var iExistMenu = listaMenu.Exists(p => p.Contains(url)) == true ? 1 : 0;
                        valido = (listaMenu.Count > 0 && iExistMenu > -1);
                    }
                }
                if (tipo == "Metodo")
                {
                    Object obj = filterContext.HttpContext.Request.Headers["xhr"];
                    if (obj != null)
                    {
                        valido = (filterContext.HttpContext.Request.Headers["xhr"] == "1");
                    }
                }
                if (!valido)
                {
                    filterContext.Result = new ContentResult
                    {
                        Content = string.Format("<script type='text/javascript'>window.parent.location.href = '{0}';</script>", "/Login/SignOut?pData=" + iMessage),
                        ContentType = "text/html"
                    };
                }
            }
        }
    }
}