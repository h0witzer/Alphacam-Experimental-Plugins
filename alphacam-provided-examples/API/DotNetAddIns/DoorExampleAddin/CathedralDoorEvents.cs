using System;
using System.Runtime.InteropServices;
using AlphaCAMMill;
using DoorMachiningForm;
using DoorMachiningAddin;

namespace DoorMachining.Addin
{
    // The add-in must contain a class called AlphacamEvents.
    // An instance will be created when the add-in is loaded.
    public class AlphacamEvents
    {
        // Bump UI version if ribbon update is needed.
        int UIVersion = 1;

        IAlphaCamApp Acam;
        AddInInterfaceClass theAddInInterface;
        CathedralDoor cathedralDoorInstance;

        // This constructor is called when the add-in is loaded by Alphacam
        public AlphacamEvents(IAlphaCamApp Acam)
        {
            this.Acam = Acam;
            Frame Frm = Acam.Frame;

            theAddInInterface = Frm.CreateAddInInterface() as AddInInterfaceClass;

            theAddInInterface.InitAlphacamAddIn += theAddInInterface_InitAlphacamAddIn;
            theAddInInterface.GetUIVersion += theAddInInterface_GetUIVersion;

            Marshal.ReleaseComObject(Frm);  // Free Frame COM variable
        }
        // Called when the add-in is loaded (Action == acamInitAddInActionInitialise)
        // and when it is reloaded after being disabled (Action == acamInitAddInActionReload)
        private void theAddInInterface_InitAlphacamAddIn(AcamInitAddInAction Action, EventData Data)
        {
            cathedralDoorInstance = new CathedralDoor(Acam);
            Data.ReturnCode = 0;
        }

        private void theAddInInterface_GetUIVersion(int LastVersion, AlphaCAMMill.EventDataUIVersion Data)
        {
            Data.UIVersion = UIVersion;
        }
    }

    public class CathedralDoor : IDisposable
    {
        IAlphaCamApp Acam;
        CommandItemClass Item;
        Frame Frm;

        private bool _disposed = false;

        public CathedralDoor(IAlphaCamApp Acam)
        {
            // initialise variables - These will be release when this class is disposed
            this.Acam = Acam;
            Frm = Acam.Frame;

            Item = Frm.CreateCommandItem() as CommandItemClass;
            Item.OnCommand += this.OnCommand;

            // CmdName is just used to generate a unique ID, so use the class name.
            Frm.AddMenuItem33("Cathedral Door", GetType().Name, AcamMenuLocation.acamMenuNEW, "C# Example Add-in", "Door Example", 1, Item);
        }

        public void Dispose()
        {
            DisposeClass();
            GC.SuppressFinalize(this);
        }

        ~CathedralDoor()
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

            if (Frm != null)
                Marshal.ReleaseComObject(Frm);

            _disposed = true;
        }

        // Called when the menu item is clicked on
        void OnCommand()
        {
            Main CDMain = new Main(Acam);
            if (CDMain.FileNew())
            {
                ShowForm();
                CDMain.RefreshDrawing();
            }
        }

        private void ShowForm()
        {
            CathedralDoorForm cathedralDoorForm = new CathedralDoorForm(Acam);
            cathedralDoorForm.ShowDialog();
        }
    }
}
