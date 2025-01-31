using General.Librerias.AccesoDatos;
using General.Librerias.CodigoUsuario;
using System;
using System.Configuration;
using System.DirectoryServices;
using System.DirectoryServices.AccountManagement;
using System.Web.Mvc;

namespace AppWeb.Controllers
{
    
    public class LoginController : Controller
    {
        // GET: Login
        public ActionResult SignIn(string pMensaje)
        {
            ViewData["_Message"] = pMensaje;
            ViewData["_Version"] = ConfigurationManager.AppSettings["App.Version"];
            return View();
        }

        public ActionResult SignOut(string pData)
        {
            Session.Clear();
            Session.Abandon();
            @ViewData["_Message"] = pData;
            return RedirectToAction("SignIn", new { pMensaje = pData });
        }
        //
        public string Validate(string pData)
        {
            string usuario = pData.Split('|')[0];
            string clave = pData.Split('|')[1];
            string rpta = "";
            string archivoLog = ConfigurationManager.AppSettings["App.LogFile"];
            try
            {
                using (var _context = new PrincipalContext(ContextType.Domain, "PROVIASNAC"))
                {
                    if (!_context.ValidateCredentials(usuario, clave))
                    {
                        rpta = "KO|Usuario y/o contraseña incorrecto.";
                    }
                    else
                    {
                        using (var _user = UserPrincipal.FindByIdentity(_context, usuario))
                        {
                            var groups = _user.GetAuthorizationGroups();
                            //
                            daSQL odaSQL = new daSQL("con.SIGANET");
                            string iUserData = odaSQL.EjecutarComando("paPerMUsuario_ListarDatos", "@pvcData", usuario);
                            if (!string.IsNullOrEmpty(iUserData))
                            {
                                var iDataUsuario = iUserData.Split('|');
                                //
                                iDataUsuario[2] = iDataUsuario[2].Split(' ')[0] + '|' + iDataUsuario[2].Split(' ')[2];
                                Session["Usuario"] = String.Join("|", iDataUsuario);
                                //
                                rpta = iDataUsuario[2] + '|' + iDataUsuario[5] + '|' + iDataUsuario[3];
                            }
                            else
                            {
                                rpta = "KO|No cuenta con perfil asignado";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                rpta = "KO|";
                Log.Grabar(ex.Message, ex.StackTrace, archivoLog);
            }
            return rpta;
        }

        public string ValidaUser(string pData)
        {
            string usuario = pData.Split('|')[0];
            string clave = pData.Split('|')[1];
            string data = string.Format("{0}|{1}", usuario, clave);
            string rpta = "";
            string archivoLog = ConfigurationManager.AppSettings["App.LogFile"];
            try
            {
                
                            daSQL odaSQL = new daSQL("con.GEN");
                            string iUserData = odaSQL.EjecutarComando("paUsuario_ListarDatos", "@pvcData", data);
                            if (!string.IsNullOrEmpty(iUserData))
                            {
                                var iDataUsuario = iUserData.Split('|');
                                //
                                iDataUsuario[3] = iDataUsuario[3].Split(' ')[0] + '|' + iDataUsuario[3].Split(' ')[2];
                                Session["Usuario"] = String.Join("|", iDataUsuario);
                                //
                                rpta = iDataUsuario[1] + '|' + iDataUsuario[3];
                            }
                            else
                            {
                                rpta = "KO|No cuenta con perfil asignado";
                            }
                        
            }
            catch (Exception ex)
            {
                rpta = "KO|";
                Log.Grabar(ex.Message, ex.StackTrace, archivoLog);
            }
            return rpta;
        }
    }
}