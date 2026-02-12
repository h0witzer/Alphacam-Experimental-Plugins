using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace FanucRobodrill
{
	internal class FileUtils
	{
		public static string TextFilename()
		{
			string codeBase = Assembly.GetExecutingAssembly().CodeBase;
			UriBuilder uri = new UriBuilder(codeBase);
			string path = Uri.UnescapeDataString(uri.Path);
			// Note need to use System.IO.Path because 'Path' is also an ALPHACAM object type
			return System.IO.Path.ChangeExtension(path, ".txt");
		}

		public static string IniFilename()
		{
			string codeBase = Assembly.GetExecutingAssembly().CodeBase;
			UriBuilder uri = new UriBuilder(codeBase);
			string path = Uri.UnescapeDataString(uri.Path);
			// Note need to use System.IO.Path because 'Path' is also an ALPHACAM object type
			return System.IO.Path.ChangeExtension(path, ".ini");
		}
	}
}
