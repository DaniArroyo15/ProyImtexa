using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace General.Librerias.CodigoUsuario
{
    public class Log
    {
        public static void Grabar(string mensajeError, string detalleError, string archivo)
        {
            beLog obeLog = new beLog();
            obeLog.MensajeError = mensajeError;
            obeLog.DetalleError = detalleError;
            Objeto.Grabar(obeLog, archivo);
        }
    }
}
