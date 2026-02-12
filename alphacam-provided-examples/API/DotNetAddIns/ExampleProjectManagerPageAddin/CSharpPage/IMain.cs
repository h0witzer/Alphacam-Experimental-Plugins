using System;
using System.Runtime.InteropServices;

namespace CSharpPage
{
    [Guid("20CC948D-FE83-4F05-A88A-6DF18FA81169")]
    [ComVisible(true)]
    public interface IMain
    {
        int AddPage(AlphaCAMMill.App App);
        void RemovePage();
    }
}
