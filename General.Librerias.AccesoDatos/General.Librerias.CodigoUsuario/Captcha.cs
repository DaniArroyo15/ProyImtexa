using System;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace General.Librerias.CodigoUsuario
{
    public class Captcha
    {
        static string obtenerNumeroAzar()
        {
            Random oAzar = new Random();
            int n = oAzar.Next(10);
            System.Threading.Thread.Sleep(20);
            return n.ToString();
        }

        static string obtenerCaracterAzar()
        {
            Random oAzar = new Random();
            int n = 65 + oAzar.Next(26);
            System.Threading.Thread.Sleep(20);
            return ((char)n).ToString();
        }

        public static Dictionary<string, byte[]> Crear()
        {
            Dictionary<string, byte[]> rpta = new Dictionary<string, byte[]>();
            Random oAzar = new Random();
            StringBuilder sb = new StringBuilder();
            Bitmap bmp = new Bitmap(200, 80);
            Graphics grafico = Graphics.FromImage(bmp);
            Rectangle rect = new Rectangle(0, 0, 200, 80);
            LinearGradientBrush degradado = new LinearGradientBrush(rect, Color.WhiteSmoke, Color.LightGray, LinearGradientMode.BackwardDiagonal);
            grafico.FillRectangle(degradado, rect);
            string c;
            int x = 0;//10;
            int y;
            int r, g, b;
            //Color color;

            List<Color> colores = new List<Color>();
            colores.Add(Color.FromArgb(255, 153, 51));
            colores.Add(Color.FromArgb(79, 129, 166));
            colores.Add(Color.FromArgb(255, 204, 0));
            colores.Add(Color.FromArgb(0, 153, 0));
            colores.Add(Color.FromArgb(255, 0, 102));

            for (int i = 0; i < 5; i++)
            {
                if (oAzar.Next(2).Equals(0)) c = obtenerNumeroAzar();
                else c = obtenerCaracterAzar();
                sb.Append(c);
                y = oAzar.Next(20);//(35);
                //r = oAzar.Next(255);
                //g = oAzar.Next(255);
                //b = oAzar.Next(255);
                //color = Color.FromArgb(r, g, b);
                

                grafico.DrawString(c, new Font("Courier New", 40, FontStyle.Italic), new SolidBrush(colores[i]), x, y);
                x += 33;//35
            }
            //grafico.DrawString(sb.ToString(), new Font("Arial", 40), Brushes.White, 10, 5);
            byte[] buffer;
            using (MemoryStream ms = new MemoryStream())
            {
                bmp.Save(ms, ImageFormat.Png);
                buffer = ms.ToArray();
            }
            rpta.Add(sb.ToString(), buffer);
            return rpta;
        }
    }
}
