using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;

using AlphaCAMMill;

namespace ExampleAddIn
{
    // The add-in must contain a class called AlphacamEvents.
    // An instance will be created when the add-in is loaded.
    public class AlphacamEvents
    {
        IAlphaCamApp Acam;
        AddInInterfaceClass theAddInInterface;
        Rectangle CmdFillet;
        // This constructor is called when the add-in is loaded by Alphacam
        public AlphacamEvents(IAlphaCamApp Acam)
        {
            this.Acam = Acam;
            Frame Frm = Acam.Frame;

            theAddInInterface = Frm.CreateAddInInterface() as AddInInterfaceClass;

            theAddInInterface.InitAlphacamAddIn += theAddInInterface_InitAlphacamAddIn;

            Marshal.ReleaseComObject(Frm);  // Free Frame COM variable
        }
        // Called when the add-in is loaded (Action == acamInitAddInActionInitialise)
        // and when it is reloaded after being disabled (Action == acamInitAddInActionReload)
        private void theAddInInterface_InitAlphacamAddIn(AcamInitAddInAction Action, EventData Data)
        {
            CmdFillet = new Rectangle(Acam);
            Data.ReturnCode = 0;
        }
    }
    public class Rectangle : IDisposable
    {
        IAlphaCamApp Acam;
        CommandItemClass Item;
        CSharpPage.Main MyDialog;

        private bool _disposed = false;

        public Rectangle(IAlphaCamApp Acam)
        {
            this.Acam = Acam;
            Frame Frm = Acam.Frame;

            MyDialog = new CSharpPage.Main();
            MyDialog.AddPage(Acam.Application);

            Marshal.ReleaseComObject(Frm);  // Free COM variable
        }

        public void Dispose()
        {
            DisposeClass();
            GC.SuppressFinalize(this);
        }

        ~Rectangle()
        {
            DisposeClass();
        }

        protected virtual void DisposeClass()
        {
            if (_disposed)
                return;

            // Dispose COM variables
            if (Item != null)
                Marshal.ReleaseComObject(Item);

            _disposed = true;
        }      
    }
}
