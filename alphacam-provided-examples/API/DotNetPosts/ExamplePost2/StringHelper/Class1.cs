using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StringHelper
{
    public static class Utils
    {
		public static bool StartsWithUpper(string str)
		{
			if (string.IsNullOrWhiteSpace(str))
				return false;

			char ch = str[0];
			return char.IsUpper(ch);
		}
    }
}
