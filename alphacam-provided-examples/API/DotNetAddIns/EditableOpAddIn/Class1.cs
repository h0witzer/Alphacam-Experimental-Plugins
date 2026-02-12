using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using AlphaCAMMill;

namespace EditableOpAddIn
{
    public class AlphacamEvents
    {
        IAlphaCamApp Acam;

        AddInInterfaceClass theAddInInterface;
        SolidRoughFinish CmdSolidRoughFinish;

        // This constructor is called when the add-in is loaded by Alphacam
        public AlphacamEvents(IAlphaCamApp Acam)
        {
            this.Acam = Acam;
            using (COMVariablesDisposer dispFrame = new COMVariablesDisposer(Acam.Frame))
            {
                Frame Frm = dispFrame.mObj;

                theAddInInterface = Frm.CreateAddInInterface() as AddInInterfaceClass;

                theAddInInterface.InitAlphacamAddIn += theAddInInterface_InitAlphacamAddIn;
                theAddInInterface.GetUIVersion += theAddInInterface_GetUIVersion;
                theAddInInterface.CallAddInOpFunction += theAddInInterface_CallAddInOpFunction;
            }
        }

        // Called when the add-in is loaded (Action == acamInitAddInActionInitialise)
        // and when it is reloaded after being disabled (Action == acamInitAddInActionReload)
        private void theAddInInterface_InitAlphacamAddIn(AcamInitAddInAction Action, EventData Data)
        {
            CmdSolidRoughFinish = new SolidRoughFinish(Acam);
            Data.ReturnCode = 0;
        }
        private void theAddInInterface_GetUIVersion(int LastVersion, EventDataUIVersion Data)
        {
            Data.UIVersion = 1;
        }
        void theAddInInterface_CallAddInOpFunction(string FunctionName, object Geos, object MachiningData, EventData Data)
        {
            Data.ReturnCode = CmdSolidRoughFinish.CallAddInOpFunction(FunctionName, Geos, MachiningData);
        }


    }

    public class SolidRoughFinish : IDisposable
    {
        IAlphaCamApp Acam;

        CommandItemClass Item;
        COMVariablesDisposer dispItem = null;

        float m_stock;

        private bool _disposed = false;

        public SolidRoughFinish(IAlphaCamApp Acam)
        {
            this.Acam = Acam;
            
            using (COMVariablesDisposer dispFrame = new COMVariablesDisposer(Acam.Frame))
            {
                Frame Frm = dispFrame.mObj;
                dispItem = new COMVariablesDisposer(Frm.CreateCommandItem() as CommandItemClass);
                Item = dispItem.mObj;
                Item.OnCommand += this.OnCommand;
                Item.OnUpdate += this.OnUpdate;

                // CmdName is just used to generate a unique ID, so use the class name.
                bool ok = Frm.AddMenuItem33("Solid Rough / Finish (.Net EditableOpAddIn)", GetType().Name, AcamMenuLocation.acamMenuMACHINE_3D, "", "", 0, Item);

            }
        }

        public void Dispose()
        {
            DisposeClass();
            GC.SuppressFinalize(this); // Class is already disposed. Make sure destructor is never called
        }

        ~SolidRoughFinish()
        {
            DisposeClass();
        }

        protected virtual void DisposeClass()
        {
            if (_disposed)
                return;

            // Dispose COM variables
            if (dispItem.mObj != null)
                dispItem.Dispose();

            Item = null;

            _disposed = true;
        }

        private void OnCommand()
        {
            // Show the dialog box
            if (ShowDialogBoxes() != 0) return;

            // call sub to do the machining
            DoCmd();
        }

        private AcamOnUpdateReturn OnUpdate()
        {
            AcamOnUpdateReturn ret = AcamOnUpdateReturn.acamOnUpdate_UncheckedDisabled;

            using (COMVariablesDisposer dispDrw = new COMVariablesDisposer(Acam.ActiveDrawing))
            using (COMVariablesDisposer dispFrame = new COMVariablesDisposer(Acam.Frame))
            {
                Drawing Drw = dispDrw.mObj;
                Frame Frm = dispFrame.mObj;

                using (COMVariablesDisposer dispCurrentTool = new COMVariablesDisposer(Acam.GetCurrentTool()))
                using (COMVariablesDisposer dispSolidParts = new COMVariablesDisposer(Drw.SolidParts))
                using (COMVariablesDisposer dispSurfaces = new COMVariablesDisposer(Drw.Surfaces))
                {
                    MillTool Tool = dispCurrentTool.mObj;
                    SolidParts SolidParts = dispSolidParts.mObj;
                    Surfaces Surfaces = dispSurfaces.mObj;
                    if (!Frm.InNewMessageLoop && Tool != null && (SolidParts.Count > 0 || Surfaces.Count > 0))
                        ret = AcamOnUpdateReturn.acamOnUpdate_UncheckedEnabled;
                }
            }
            return ret;
        }

        // Register the functions to handle the op.
        private void SetFunctions(MillData MD)
        {
            MD.SetUpdateFunction("HandleUpdate");
            MD.SetEditFunction("HandleEdit");
            MD.SetBeforeAddGeometriesFunction("HandleBeforeAddGeometries");
            MD.SetBeforeRemoveGeometryFunction("HandleBeforeRemoveGeometry");
            MD.SetBeforeChangeToolFunction("HandleBeforeChangeTool");
        }

        // Copy machining data to attributes on the MillData.
        // AttributeOp is used so the attributes are not copied to the tool paths.
        void SetAttributes(MillData MD)
        {
            MD.AttributeOp[GetAttributeName("m_stock")] = m_stock;
        }

        // Copy machining data from attributes on the MillData
        void GetAttributes(MillData MD)
        {
            float.TryParse(MD.AttributeOp[GetAttributeName("m_stock")].ToString(), out m_stock);
        }

        string GetAttrPrefix()
        {
            return "LicomUKDMBSRFDotNet";
        }

        string GetAttributeName(string MemberName)
        {
            return GetAttrPrefix() + MemberName;
        }

        // Create tool paths given geometries and MillData.
        void Update(AlphacamObjects Geos, MillData MachiningData)
        {
            GetAttributes(MachiningData);
            DoMachining(Geos, MachiningData);
        }

        // Show the dialog boxes to edit the data.
        // Return 0 if ok, non-zero to cancel the edit.
        int Edit(MillData MachiningData)
        {
            GetAttributes(MachiningData);
            if (ShowDialogBoxes() != 0) return 1;
            SetAttributes(MachiningData);
            return 0;
        }

        // Show dialog boxes. Return 0 if ok, non-zero if aborted
        int ShowDialogBoxes()
        {
            int ret = 0;
            using (COMVariablesDisposer dispFrame = new COMVariablesDisposer(Acam.Frame))
            {
                Frame Frm = dispFrame.mObj;
                ret = Frm.InputFloatDialog("Solid Rough/Finish", "Stock", AcamFloat.acamFloatNON_NEG, ref m_stock) ? 0 : 1;
            }
            return ret;
        }

        // Select solids and geometry paths and call the routine to do the machining
        void DoCmd()
        {
            using (COMVariablesDisposer dispDrawing = new COMVariablesDisposer(Acam.ActiveDrawing))
            {
                Drawing Drw = dispDrawing.mObj;

                if (!Drw.UserSelectMultiGeos2("Solid Rough/Finish: select solids/geometries",
                (int)(AcamSelectFlags.acamSelectSPLINES | AcamSelectFlags.acamSelectSURFACES | AcamSelectFlags.acamSelectDRAW_SELECTED),
                (int)(AcamSelectExtraFlags.acamSelectSOLIDS | AcamSelectExtraFlags.acamSelectGEOMETRY_PATHS))) return;

                // Build a collection for everything selected
                using (COMVariablesDisposer dispGeos = new COMVariablesDisposer(Drw.CreateAlphacamObjectsCollection()))
                {
                    AlphacamObjects Geos = dispGeos.mObj;
                    // Solid Parts
                    using (COMVariablesDisposer dispSolidParts = new COMVariablesDisposer(Drw.SolidParts))
                    {
                        SolidParts Parts = dispSolidParts.mObj;
                        int PartsCount = Parts.Count;
                        for (int i = 1; i <= PartsCount; ++i)
                        {
                            using (COMVariablesDisposer dispSolidPart = new COMVariablesDisposer(Parts.Item(i)))
                            {
                                SolidPart Part = dispSolidPart.mObj;
                                if (Part.Selected)
                                {
                                    Geos.Add(Part);
                                    Part.Selected = false;
                                }
                            }
                        }
                    }

                    // Surfaces
                    using (COMVariablesDisposer dispSurfaces = new COMVariablesDisposer(Drw.Surfaces))
                    {
                        Surfaces Surfaces = dispSurfaces.mObj;
                        int SurfacesCount = Surfaces.Count;
                        for (int i = 1; i <= SurfacesCount; ++i)
                        {
                            using (COMVariablesDisposer dispSurface = new COMVariablesDisposer(Surfaces.Item(i)))
                            {
                                Surface Surface = dispSurface.mObj;
                                if (Surface.Selected)
                                {
                                    Geos.Add(Surface);
                                    Surface.Selected = false;
                                }
                            }
                        }
                    }

                    // Paths
                    using (COMVariablesDisposer dispPaths = new COMVariablesDisposer(Drw.Geometries))
                    {
                        Paths Paths = dispPaths.mObj;
                        int PathsCount = Paths.Count;
                        for (int i = 1; i <= PathsCount; ++i)
                        {
                            using (COMVariablesDisposer dispPath = new COMVariablesDisposer(Paths.Item(i)))
                            {
                                Path Path = dispPath.mObj;
                                if (Path.Selected && !Path.Is3D)
                                {
                                    Geos.Add(Path);
                                    Path.Selected = false;
                                }
                            }
                        }
                    }

                    DoMachining(Geos, null);
                }
            }
        }

        // Do the op given geometry, which must include at least one solid or surface (to set the Z)
        // and may include geometries.
        void DoMachining(AlphacamObjects Geos, MillData MDForAssociate)
        {
            if (Geos.Count == 0) return;

            using (COMVariablesDisposer dispTool = new COMVariablesDisposer(Acam.GetCurrentTool()))
            {
                MillTool Tool = dispTool.mObj;
                if (Tool == null)
                    return;

                // Create a new MillData to create the tool paths, and associate them with the passed one if this is an update, else the new one
                MillData MDUpdate = MDForAssociate;

                using (COMVariablesDisposer dispMillData = new COMVariablesDisposer(Acam.CreateMillData()))
                {
                    MillData MD = dispMillData.mObj;

                    if (MDUpdate == null)
                        MDUpdate = MD;

                    // Find the extent
                    const double Big = 1.0E+10;
                    double MinX = Big, MaxX = -Big, MinY = Big, MaxY = -Big, MinZ = Big, MaxZ = -Big;

                    // Loop through the passed geometries looking for the SolidParts and surfaces
                    int GeosCount = Geos.Count;
                    for (int i = 1; i <= GeosCount; ++i)
                    {
                        using (COMVariablesDisposer dispGeo = new COMVariablesDisposer(Geos.Item(i)))
                        {
                            // See if it is a SolidPart
                            SolidPart Part = dispGeo.mObj as SolidPart;
                            if (Part != null)
                            {
                                MDUpdate.AssociateGeometry(dispGeo.mObj, 100);
                                double A = Part.MinX;
                                if (A < MinX) MinX = A;
                                A = Part.MaxX;
                                if (A > MaxX) MaxX = A;
                                A = Part.MinY;
                                if (A < MinY) MinY = A;
                                A = Part.MaxY;
                                if (A > MaxY) MaxY = A;
                                A = Part.MinZ;
                                if (A < MinZ) MinZ = A;
                                A = Part.MaxZ;
                                if (A > MaxZ) MaxZ = A;
                            }
                            else
                            {
                                // See if it is a surface
                                Surface Surface = dispGeo.mObj as Surface;
                                if (Surface != null)
                                {
                                    MDUpdate.AssociateGeometry(dispGeo.mObj, 200);
                                    double A = Surface.MinX;
                                    if (A < MinX) MinX = A;
                                    A = Surface.MaxX;
                                    if (A > MaxX) MaxX = A;
                                    A = Surface.MinY;
                                    if (A < MinY) MinY = A;
                                    A = Surface.MaxY;
                                    if (A > MaxY) MaxY = A;
                                    A = Surface.MinZ;
                                    if (A < MinZ) MinZ = A;
                                    A = Surface.MaxZ;
                                    if (A > MaxZ) MaxZ = A;
                                }
                            }
                        }
                    }
                    if (MaxZ < MinZ) return;

                    using (COMVariablesDisposer dispDrawing = new COMVariablesDisposer(Acam.ActiveDrawing))
                    {
                        Drawing Drw = dispDrawing.mObj;

                        using (COMVariablesDisposer dispPathsToDelete = new COMVariablesDisposer(Drw.CreatePathCollection()))
                        {
                            Paths PathsToDelete = dispPathsToDelete.mObj;

                            using (COMVariablesDisposer dispRect = new COMVariablesDisposer(Drw.CreateRectangle(MinX, MinY, MaxX, MaxY)))
                            {
                                // Create a rectangle around the extent
                                Path Rect = dispRect.mObj;
                                Rect.ToolInOut = AcamToolInOut.acamOUTSIDE;
                                Rect.Selected = true;
                                PathsToDelete.Add(Rect);

                                // Select the geometries
                                int Count = Geos.Count;
                                for (int i = 1; i <= Count; ++i)
                                {
                                    using (COMVariablesDisposer dispPath = new COMVariablesDisposer(Geos.Item(i)))
                                    {
                                        Path tmpPath = dispPath.mObj as Path;
                                        if (tmpPath != null)
                                        {
                                            tmpPath.Selected = true;
                                            MDUpdate.AssociateGeometry(tmpPath, 300);
                                        }
                                    }
                                }

                                // Machine the rectangle
                                MD.SafeRapidLevel = (float)(MaxZ + Tool.Diameter * 0.5);
                                MD.RapidDownTo = (float)(MaxZ + Tool.Diameter * 0.1);
                                MD.MaterialTop = (float)MaxZ;
                                MD.FinalDepth = (float)MinZ;
                                MD.NumberOfCuts = (short)((MaxZ - MinZ) / Tool.Diameter * 2 + 1);
                                MD.Stock = (float)m_stock;

                                using (COMVariablesDisposer dispToolPaths = new COMVariablesDisposer(MD.RoughFinish()))
                                {
                                    Paths ToolPaths = dispToolPaths.mObj;
                                    MDUpdate.AssociateToolPaths(ToolPaths);

                                    PathsToDelete.Delete();

                                    SetFunctions(MDUpdate);
                                    SetAttributes(MDUpdate);
                                }
                            }
                        }
                    }
                }
            }
        }

        // This function will be called before adding geometries to the operation.
        // Geos contains the selected geometries. To reject a geometry set its Selected property to False.
        // Return non-zero to reject all geometries.
        int BeforeAddGeometries(AlphacamObjects Geos, MillData MD)
        {
            // Reject solid part if the name contains "Ball", and 3D paths
            int GeosCount = Geos.Count;
            for (int i = 1; i <= GeosCount; ++i)
            {
                using (COMVariablesDisposer dispGeo = new COMVariablesDisposer(Geos.Item(i)))
                {
                    // See if it is a SolidPart
                    SolidPart Part = dispGeo.mObj as SolidPart;
                    if (Part != null)	// Will be NULL if Geo is not a SolidPart
                    {
                        string name = Part.Name;
                        if (name.Contains("Ball")) 
                            Part.Selected = false;
                    }
                    else
                    {
                        Path Path = dispGeo.mObj as Path;
                        if (Path != null)	// Will be NULL if Geo is not a Path
                        {
                            if (Path.Is3D) 
                                Path.Selected = false;
                        }
                    }
                }
            }

            return 0;	// Accept any that are still selected
        }
        // This function will be called before showing the context menu for a geometry.
        // Return non-zero to disable the "Remove From Operation" item.
        int BeforeRemoveGeometry(object Geo, MillData MD)
        {
            // For this add-in we must have at least one solid part or surface (for the Z extent)
            SolidPart Part = Geo as SolidPart;
            Surface Surface = Geo as Surface;
            if (Part == null && Surface == null)
            {
                // Not a solid or surface so can remove it
                return 0;	// Enable
            }

            // Is a solid or surface so need to see how many there are
            int n = 0;
            using (COMVariablesDisposer dispGeos = new COMVariablesDisposer(MD.GetGeometries()))
            {
                AlphacamObjects Geos = dispGeos.mObj;
                int GeosCount = Geos.Count;
                for (int i = 1; (i <= GeosCount && n < 2); ++i)
                {
                    using (COMVariablesDisposer Geo2 = new COMVariablesDisposer(Geos.Item(i)))
                    {
                        // See if it is a SolidPart
                        Part = Geo2.mObj as SolidPart;
                        if (Part != null)
                            ++n;
                        else
                        {
                            Surface = Geo2.mObj as Surface;
                            if (Surface != null) ++n;
                        }
                    }
                }
            }
            
            return n == 1 ? 1 : 0;
        }
        // This function will be called before the tool is changed by the "Change Tool" option in the operations manager.
        // Return non-zero to reject the tool. Otherwise set flags so tool data can be updated.
        // Alphacam will call the "Edit" function so the user can update the settings eg width of cut.
        int BeforeChangeTool(MillTool Tool, MillData MD)
        {
            return Tool.Type == AcamToolType.acamToolDRILL ? 1 : 0;	// Disable if a drill
        }

        // Call function registered for this op
        public int CallAddInOpFunction(string FunctionName, object oGeos, object oMachiningData)
        {
            if (FunctionName == "HandleUpdate")
            {
                using (COMVariablesDisposer dispDrw = new COMVariablesDisposer(Acam.ActiveDrawing))
                {
                    Drawing Drw = dispDrw.mObj;
                    Drw.ScreenUpdating = false;	// Alphacam will redraw after re-ordering the operations so no point drawing here
                    Update(oGeos as AlphacamObjects, oMachiningData as MillData);
                    Drw.ScreenUpdating = true;
                }
            }
            else if (FunctionName == "HandleEdit")
            {
                MillData MachiningData = oMachiningData as MillData;
                return Edit(MachiningData);
            }
            else if (FunctionName == "HandleBeforeAddGeometries")
            {
                return BeforeAddGeometries(oGeos as AlphacamObjects, oMachiningData as MillData);
            }
            else if (FunctionName == "HandleBeforeRemoveGeometry")
            {
                return BeforeRemoveGeometry(oGeos, oMachiningData as MillData);                    
            }
            else if (FunctionName == "HandleBeforeChangeTool")
            {
                return BeforeChangeTool(oGeos as MillTool, oMachiningData as MillData);
            }
            return 0;
        }
    }
}
