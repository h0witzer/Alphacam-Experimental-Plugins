using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;

using AlphaCAMMill;

namespace ExampleEventsAddIn
{
    public class AlphacamEvents
    {
        IAlphaCamApp Acam;
        AddInInterfaceClass theAddInInterface;
        AddInNotificationsClass theAddInNotifications;
        // This constructor is called when the add-in is loaded by Alphacam
        public AlphacamEvents(IAlphaCamApp Acam)
        {
            this.Acam = Acam;
            Frame Frm = Acam.Frame;

            theAddInInterface = Frm.CreateAddInInterface() as AddInInterfaceClass;

            theAddInInterface.InitAlphacamAddIn += theAddInInterface_InitAlphacamAddIn;
            theAddInInterface.BeforeOpenFile += theAddInInterface_BeforeOpenFile;
            theAddInInterface.AfterInputCad += theAddInInterface_AfterInputCad;
            theAddInInterface.BeforeInputCad += theAddInInterface_BeforeInputCad;
            theAddInInterface.BeforeRoughFinish += theAddInInterface_BeforeRoughFinish;
            theAddInInterface.AfterMachining += theAddInInterface_AfterMachining;

            theAddInNotifications = Frm.CreateAddInNotifications() as AddInNotificationsClass;
            theAddInNotifications.GeometriesUpdated += theAddInNotifications_GeometriesUpdated;

            if (Frm != null)
                Marshal.ReleaseComObject(Frm);
        }
        // Called when geometries are changed eg move, copy, delete etc
        void theAddInNotifications_GeometriesUpdated()
        {
            
        }

        // Called when the add-in is loaded (Action == acamInitAddInActionInitialise)
        // and when it is reloaded after being disabled (Action == acamInitAddInActionReload)
        void theAddInInterface_InitAlphacamAddIn(AcamInitAddInAction Action, EventData Data)
        {
            Data.ReturnCode = 0;
        }
        // Called before AlphaCAM shows open file dialog box,
        // Add-in may set Data.FileName to the name of the file to be opened, and set Data.ReturnCode to 1,
        // or 0 if AlphaCAM is to show normal dialog box, or 2 to cancel the command.
        void theAddInInterface_BeforeOpenFile(EventDataFileName Data)
        {
            Data.FileName = Acam.LicomdirPath + "licomdir\\Tutorial\\3D Simulation - 2D part.amd";
            Data.ReturnCode = 1;
        }
        // Called before AlphaCAM shows open file dialog box to select file for input CAD.
        // Add-in may set Data.FileName to the name of the file to be opened, and set Data.ReturnCode to 1,
        // or 0 if AlphaCAM is to show normal dialog box, or 2 to cancel the command.
        // cad_type is an enum giving the type of CAD file that the user has selected
        // from the dialog box. It will have one of the following values:
        // acamDXF, acamDWG, acamIGES, acamCADL, acamVDA, acamANVIL, acamXYZ, acamSTL.
        void theAddInInterface_BeforeInputCad(AcamCadType Type, EventDataFileName Data)
        {
            if (Type == AcamCadType.acamDXF)
            {
                Data.FileName = Acam.LicomdirPath + "licomdir\\cadfiles\\dxftut.dxf";
                Data.ReturnCode = 1;
            }
            else
            {
                Data.ReturnCode = 0;
            }
        }
        // Called after AlphaCAM has input a CAD file.
        // cad_type is an enum giving the type of CAD file that the user has selected
        // from the dialog box. It will have one of the following values:
        // acamDXF, acamDWG, acamIGES, acamCADL, acamVDA, acamANVIL, acamXYZ, acamSTL.
        void theAddInInterface_AfterInputCad(AcamCadType Type, string FileName)
        {
        }
        // Called before AlphaCAM does the Rough / Finish command when the user has selected the Machine / Rough or Finish command.
        // If Data.ReturnCode is set to 1, AlphaCAM will do nothing - your routine should do everything required
        // for the command - show dialog box(es), select geometries, make the tool paths (using MillData.RoughFinish) etc.

        // The other "Before..." machining events work in the same way. If you type:
        //    theAddInInterface.
        // a drop-down menu will appear listing all the events, having selected one pressing += and then
        // TAB twice will complete the statement and generate a stub function. 
        void theAddInInterface_BeforeRoughFinish(EventData Data)
        {
        }
        // Called after AlphaCAM has produced tool paths using one of the machining commands
        // or using the API (Redo = false), or after the tool paths have been regenerated
        // (with the Update Tool Paths command or Edit Operations) (Redo = true).
        // The tool paths will be passed as a Paths Collection.
        // EventName is the name of the event, one of:
        // "AfterRoughFinish", "AfterSaw", "AfterCut2AxisShape", "AfterCut4AxisShape", "AfterConicCuts",
        // "AfterClearArea", "AfterPocket", "AfterDrillTap", "AfterMachineHoles", "AfterPocketHoles",
        // "AfterEngrave", "AfterCutSplineOrPolyline", "AfterSurfaceMachining", "AfterSolidMachining",
        // "AfterManualToolpath", "AfterCutBetweenTwoGeometries".
        void theAddInInterface_AfterMachining(string EventName, Paths Paths, bool Redo)
        {
            if (EventName == "AfterRoughFinish")
            {
                System.Windows.Forms.MessageBox.Show("AfterRoughFinish: #paths = " + Paths.Count);
            }
        }
        // See the AlphaCAM API help file for more information on the events.
    }
}
