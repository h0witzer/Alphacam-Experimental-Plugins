using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FanucRobodrill
{
	internal class MathUtils
	{
		public static string ReplaceCommaDouble(double d)                       //******************************** UTILS FUNCTION, REPLACE COMMA FROM A DOUBLE
        {
            string s = Convert.ToString(d);

            s = s.Replace(",", ".");

            return s;
        }

        public static string ReplaceCommaString(string s)                       //******************************** UTILS FUNCTION, REPLACE COMMA FROM A STRING
        {
            s = s.Replace(",", ".");

            return s;
        }
        public static double Radians(double X)                                  //******************************** UTILS FUNCTION, RETURN RADIANS
        {
            return  X * (Math.PI / 180.0);
        }

        public static double Degree(double X)                                  //******************************** UTILS FUNCTION, RETURN DEGREE
        {
            return X * (180.0 / Math.PI);
        }

        public static double RadToDeg(double rad)                              //******************************** UTILS FUNCTION, RETURN RADIANS TO DEGREE
        {
            return 180.0 * rad / Math.PI;
        }

        public static double DegToRad(double deg)                              //******************************** UTILS FUNCTION, RETURN DEGREE TO RADIANS
        {
            return Math.PI * deg / 180.0;
        }

        public static double ATan2D(double y, double x)                        //******************************** UTILS FUNCTION, RETURN ATAN2
        {
            return RadToDeg(Math.Atan2(y, x));
        }

        public static double ACosD(double d)                                  //******************************** UTILS FUNCTION, RETURN ACOS
        {
            return RadToDeg(Math.Acos(d));
        }

        public static double Rounding(double x, int y)                        //******************************** UTILS FUNCTION, RETURN ROUNDED VALUE
        {
            double yPow = Math.Pow(10, y);
            return ((int)(x * yPow + 0.5)) / yPow;
        }
	}
}
