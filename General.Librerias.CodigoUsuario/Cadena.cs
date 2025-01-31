using System;
using System.Data;
using System.Linq;

namespace General.Librerias.CodigoUsuario
{
    public class Cadena
    {
        public static DataTable ConvertirTabla(string data, string pExcluidas = "", char separadorCampo = '|', char separadorRegistro = '¬')
        {
            DataTable tabla = new DataTable();
            string[] registros = data.Split(separadorRegistro);
            string[] cabeceras = registros[0].Split(separadorCampo);
            string[] anchos = registros[1].Split(separadorCampo);
            string[] tipos = registros[2].Split(separadorCampo);
            string[] iColumns = pExcluidas.Split(separadorCampo);
            int nColumns = cabeceras.Length;
            int nIndex = 0;
            for (int j = 0; j < nColumns; j++)
            {
                if (iColumns.Contains(j.ToString())) continue;
                if (tipos[j] == "Numeric") { tipos[j] = "String"; }
                tabla.Columns.Add(cabeceras[j], Type.GetType("System." + tipos[j]));
                tabla.Columns[nIndex].Caption = int.Parse(anchos[j]) > 250 ? "250" : anchos[j];
                //tabla.Columns[nIndex].Caption = anchos[j];
                nIndex++;
            }
            int nRegistros = registros.Length;
            string[] campos;
            DataRow fila;
            Type tipo;
            for (int i = 3; i < nRegistros; i++)
            {
                campos = registros[i].Split(separadorCampo);
                fila = tabla.NewRow();
                nIndex = 0;
                for (int j = 0; j < nColumns; j++)
                {
                    if (iColumns.Contains(j.ToString())) continue;
                    int iNumber;
                    var isNumber = int.TryParse(campos[j], out iNumber);
                    if (tipos[j] == "Numeric") { tipos[j] = "String"; }
                    tipo = Type.GetType("System." + tipos[j]);
                    fila[nIndex] = Convert.ChangeType(campos[j], tipo);
                    nIndex++;
                }
                tabla.Rows.Add(fila);
            }
            return tabla;
        }
    }
}
