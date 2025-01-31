using System.IO;
using System.Web;

namespace AppWebRRHH.Rutines
{
    public class Utilities
    {

        public static string _ObtenerPopup(string tabla, string type = "txt" )
        {
            string rpta = "";
            string archivoPopup = "";
            if (type == "txt") 
            {
                archivoPopup = HttpContext.Current.Server.MapPath("~/Popup/Areas/Papeletas/text/" + tabla + ".txt");
            }
            else {
                archivoPopup = HttpContext.Current.Server.MapPath("~/Popup/Areas/Papeletas/html/" + tabla + ".html");
            }
            
            if (File.Exists(archivoPopup)) rpta = File.ReadAllText(archivoPopup);

            return rpta;
        }

        public static string ObtenerPopup(string area, string nombre)
        {
            string rpta = "";
            string archivoPopup = HttpContext.Current.Server.MapPath("~/Popup/" + area + "/" + nombre + ".html");
            //
            if (File.Exists(archivoPopup)) rpta = File.ReadAllText(archivoPopup);
            //
            return rpta;
        }

        public static string GetIPAddress()
        {
            HttpContext context = HttpContext.Current;
            string ipAddress = context.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (!string.IsNullOrEmpty(ipAddress))
            {
                string[] addresses = ipAddress.Split(',');
                if (addresses.Length != 0)
                {
                    return addresses[0];
                }
            }
            return context.Request.ServerVariables["REMOTE_ADDR"];
        }
    }

    
}