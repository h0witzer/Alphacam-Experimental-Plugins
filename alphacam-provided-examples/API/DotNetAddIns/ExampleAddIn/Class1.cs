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
        Fillet CmdFillet;
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
            CmdFillet = new Fillet(Acam);
            Data.ReturnCode = 0;
        }
    }
    public class Fillet : IDisposable
    {
        IAlphaCamApp Acam;
        CommandItemClass Item;

        private bool _disposed = false;

        public Fillet(IAlphaCamApp Acam)
        {
            this.Acam = Acam;
            Frame Frm = Acam.Frame;
            Item = Frm.CreateCommandItem() as CommandItemClass;

            Item.OnCommand += this.OnCommand;
            Item.OnUpdate += this.OnUpdate;

            // CmdName is just used to generate a unique ID, so use the class name.
            bool ok = Frm.AddMenuItem43("Fillet by specified value", GetType().Name, AcamCommand.acamCmdEDIT_DELETE, true, "", 0, Item);

            Marshal.ReleaseComObject(Frm);  // Free COM variable
        }

        public void Dispose()
        {
            DisposeClass();
            GC.SuppressFinalize(this);
        }

        ~Fillet()
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

        // Called when the menu item is clicked on
        void OnCommand()
        {
            float fillet_amount = 0F;
            Frame Frm = Acam.Frame;
            if (Frm.InputFloatDialog("Example Add-in", "Fillet amount", AcamFloat.acamFloatNON_NEG, ref fillet_amount))
            {
                Drawing Drw = Acam.ActiveDrawing;
                Paths Geos = Drw.Geometries;

                int GeosCount = Geos.Count;
                for (int i = 1; i <= GeosCount; ++i)
                {
                    Path Path = Geos.Item(i);

                    Path.Fillet(fillet_amount);

                    Marshal.ReleaseComObject(Path);
                }
                Drw.RedrawShadedViews();

                // Free COM variables used
                Marshal.ReleaseComObject(Geos);
                Marshal.ReleaseComObject(Drw);
            }

            Marshal.ReleaseComObject(Frm);  // Free COM variable

        }

        // Called when the menu item is to be enabled or disabled.
        // Return one of the enum AcamOnUpdateReturn values.
        AcamOnUpdateReturn OnUpdate()
        {
            Drawing Drw = Acam.ActiveDrawing;

            AcamOnUpdateReturn ret = Drw.GetGeoCount() > 0 ? AcamOnUpdateReturn.acamOnUpdate_UncheckedEnabled : AcamOnUpdateReturn.acamOnUpdate_UncheckedDisabled;

            Marshal.ReleaseComObject(Drw);

            return ret;
        }
    }
}
