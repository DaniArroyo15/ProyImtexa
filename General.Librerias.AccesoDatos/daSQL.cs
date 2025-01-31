using General.Librerias.CodigoUsuario;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace General.Librerias.AccesoDatos
{
    public class daSQL
    {
        private string CadenaConexion;
        private string ArchivoLog;

        public daSQL(string cadenaConexion)
        {
            CadenaConexion = ConfigurationManager.ConnectionStrings[cadenaConexion].ConnectionString;
            ArchivoLog = ConfigurationManager.AppSettings["App.LogFile"];
        }

        public string EjecutarComando(string NombreSP, string ParametroNombre="", string ParametroValor="")
        {
            string rpta = "";
            using (SqlConnection con = new SqlConnection(CadenaConexion))
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(NombreSP, con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 60;
                    if (!String.IsNullOrEmpty(ParametroNombre) && !String.IsNullOrEmpty(ParametroValor))
                    {
                        cmd.Parameters.AddWithValue(ParametroNombre, ParametroValor);
                    }
                    object data = cmd.ExecuteScalar();
                    if (data != null) rpta = data.ToString();
                }
                catch (Exception ex)
                {
                    beLog obeLog = new beLog();
                    obeLog.MensajeError = ex.Message;
                    obeLog.DetalleError = ex.StackTrace;
                    Objeto.Grabar(obeLog, ArchivoLog);
                }
            }
            return rpta;
        }
    }
}
