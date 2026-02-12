using System;

namespace MathUtils
{
    public class Utils
    {
		public static double RadToDeg(double rad)
		{
			return 180.0 * rad / Math.PI;
		}

		public static double DegToRad(double deg)
		{
			return Math.PI * deg / 180.0;
		}

		public static double ATan2D(double y, double x)
		{
			return RadToDeg(Math.Atan2(y, x));
		}

		public static double ACosD(double d)
		{
			return RadToDeg(Math.Acos(d));
		}

		public static double Rounding(double x, int y)
		{
			double yPow = Math.Pow(10, y);
			return ((int)(x * yPow + 0.5)) / yPow;
		}
    }
}
