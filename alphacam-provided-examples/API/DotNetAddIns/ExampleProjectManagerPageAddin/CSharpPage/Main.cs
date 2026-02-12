using System;
using System.Runtime.InteropServices;
using ac = AlphaCAMMill;

namespace CSharpPage
{
    [Guid("AAF4866A-4A5D-430F-9BC7-F70AE1EF6A79")]
    [ClassInterface(ClassInterfaceType.None)]
    [ComVisible(true)]
    public class Main : IMain, IDisposable
    {
        public static ac.App AcamApp;
        
        private MainPage _page;
        private int _pageHandle = 0;

        #region disposal logic        

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if ((disposing) && (_page != null))
            {
                _page.Dispose();
                _page = null;
            }
        }

        ~Main()
        {
            Dispose(false);
        }

        #endregion

        public int AddPage(ac.App App)
        {
            if (App == null) return 0;

            // set the "global" alphacam app object
            AcamApp = App;

            if (_page == null)
            {
                _page = new MainPage();
            }

            _pageHandle = (int)_page.Handle;
            ac.Frame f = AcamApp.Frame;
            f.AddProjectBarPage(_pageHandle, "C# Example", (int)Properties.Resources.tab_icon.GetHbitmap());

            return _pageHandle;
        }

        public void RemovePage()
        {
            if (_page == null) return;

            ac.Frame f = AcamApp.Frame;
            f.RemoveProjectBarPage(_pageHandle);                        
        }
    }
}
