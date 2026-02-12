using System;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using AlphaCAMMill;

namespace DoorMachiningAddin
{
    class Main
    {
        IAlphaCamApp Acam;
        MachiningRoutines machineRoutines;
        public Main(IAlphaCamApp AcamApp)
        {
            Acam = AcamApp;
            machineRoutines = new MachiningRoutines(Acam);
        }
        public void CreateCathedralDoor(Double dblHeight, Double dblWidth, Double dblDepth,
                     Double dblBorder, Double dblRiseHeight, Double dblBlendRadius, Double dblTopRadius)
        {
            // define the active drawing
            Drawing drw = Acam.ActiveDrawing;

            //create the work volume
            Path WorkVol = drw.CreateRectangle(0, 0, dblHeight, dblWidth);
            WorkVol.SetWorkVolume(0, -dblDepth);
            ReleaseComObject(WorkVol);

            //create the material
            Path Material = drw.CreateRectangle(-1, -1, dblHeight + 1, dblWidth + 1);
            Material.SetMaterial(0, -dblDepth);
            ReleaseComObject(Material);

            //create the outside of the door
            FastGeometry tempFastGeo = drw.CreateFastGeometry();
            tempFastGeo.Point(0, dblWidth / 2);
            tempFastGeo.Point(0, dblWidth);
            tempFastGeo.Point(dblHeight, dblWidth);
            tempFastGeo.Point(dblHeight, 0);
            tempFastGeo.Point(0, 0);
            tempFastGeo.Point(0, dblWidth / 2);
            Path DoorGeo = tempFastGeo.Finish();
            DoorGeo.ToolSide = AcamToolSide.acamLEFT;
            ReleaseComObject(tempFastGeo);

            //machine outside of door

            //select the tool
            String strToolName = Acam.LicomdatPath + @"Licomdat\rtools.alp\Flat - 20mm.art";
            machineRoutines.SelectRouterTool(strToolName);

            //Create machining data for outside of door 
            Paths GeosToMachine = drw.CreatePathCollection();
            GeosToMachine.Add(DoorGeo);
            Paths Tps = machineRoutines.CreateRoughFinishPaths(GeosToMachine, 50, 5, 0, -dblDepth - 1, 0, AcamComp.acamCompMC, 0, 0);
            ReleaseComObject(DoorGeo);
            ReleaseComObject(GeosToMachine);

            //apply lead in and lead out
            //note: Do not use foreach with Alphacam collections, so that the COM objects can be released properly
            for (int i = 1; i <= Tps.Count; i++)
            {
                Path Tp = Tps.Item(i);
                Tp.SetLeadInOutAuto(AcamLeadType.acamLeadBOTH, AcamLeadType.acamLeadBOTH, 1.2, 1.2, 45, false, false, 0);
                ReleaseComObject(Tp);
            }
            ReleaseComObject(Tps);

            // create the panel using fast geometry
            Double dblPanelxStart = dblBorder;
            Double dblPanelyStart = dblBorder;
            Double dblPanelxFin = dblHeight - (dblBorder + dblRiseHeight);
            Double dblPanelyFin = dblWidth - dblBorder;
            tempFastGeo = drw.CreateFastGeometry();
            tempFastGeo.Point(dblPanelxStart, (dblWidth / 2) + 10);
            tempFastGeo.Point(dblPanelxStart, dblPanelyStart);
            tempFastGeo.Point(dblPanelxFin, dblPanelyStart);
            tempFastGeo.LineToArc(dblBlendRadius, true, false, 90);
            tempFastGeo.KnownArc(dblTopRadius, false, dblHeight - dblBorder - dblTopRadius, dblWidth / 2);
            tempFastGeo.ArcToLine(dblBlendRadius, true, false, 90);
            tempFastGeo.Point(dblPanelxFin, dblPanelyFin);
            tempFastGeo.Point(dblPanelxStart, dblPanelyFin);
            tempFastGeo.Point(dblPanelxStart, (dblWidth / 2) - 10);
            Path PanelGeo2 = tempFastGeo.Finish();
            Paths tempPaths = PanelGeo2.Offset(12, AcamToolSide.acamLEFT);
            Path PanelGeo1 = tempPaths.Item(1);
            PanelGeo2.ToolSide = AcamToolSide.acamLEFT;
            ReleaseComObject(tempFastGeo);
            ReleaseComObject(tempPaths);

            //Machining the panel

            //select the tool
            strToolName = Acam.LicomdatPath + @"Licomdat\rtools.alp\Router - Emc4.art";
            machineRoutines.SelectRouterTool(strToolName);

            //create the toolpaths

            GeosToMachine = drw.CreatePathCollection();
            GeosToMachine.Add(PanelGeo1);
            Tps = machineRoutines.CreateRoughFinishPaths(GeosToMachine, 50, 5, 0, -5);
            ReleaseComObject(GeosToMachine);
            ReleaseComObject(PanelGeo1);

            //apply leadin / out to the profile paths
            Double dblXs, dblYs, dblXf, dblYf;
            Element Efirst = null, Elast = null, Efeed = null;
            
            for(int i = 1; i <= Tps.Count; i++)
            {
                Path Tp = Tps.Item(i);            
                Efirst = Tp.GetFirstElem();
                if (Efirst.IsRapid)
                {
                    Efeed = Efirst.GetNext();
                    ReleaseComObject(Efirst);
                    Efirst = Efeed;
                }
                Elast = Tp.GetLastElem();
                dblXs = Efirst.StartXG;
                dblYs = Efirst.StartYG;
                dblXf = Elast.EndXG;
                dblYf = Elast.EndYG;
                Tp.SetLeadInOutManual(AcamLeadType.acamLeadLINE, AcamLeadType.acamLeadLINE, true, true, 
                                        dblXs, dblYs + 20, dblXf, dblYf - 20);

                ReleaseComObject(Tp);
                ReleaseComObject(Efeed);
                ReleaseComObject(Efirst);
                ReleaseComObject(Elast);
            }
            ReleaseComObject(Tps);

            //select the tool
            strToolName = Acam.LicomdatPath + @"Licomdat\rtools.alp\User - Cone - 10mm  x  45 deg.art";
            machineRoutines.SelectRouterTool(strToolName);

            //create the toolpaths
            GeosToMachine = drw.CreatePathCollection();
            GeosToMachine.Add(PanelGeo2);
            Tps = machineRoutines.Create3dEngravePaths(GeosToMachine, 50, 5, 0, -5);
            ReleaseComObject(drw);
            ReleaseComObject(GeosToMachine);
            ReleaseComObject(PanelGeo2);

            //apply leadin/out to the profile paths
            for (int i = 1; i <= Tps.Count; i++)
            {
                Path Tp = Tps.Item(i);

                Efirst = Tp.GetFirstElem();
                if (Efirst.IsRapid)
                {
                    Efeed = Efirst.GetNext();
                    ReleaseComObject(Efirst);
                    Efirst = Efeed;
                }
                Elast = Tp.GetLastElem();
                dblXs = Efirst.StartXG;
                dblYs = Efirst.StartYG;
                dblXf = Elast.EndXG;
                dblYf = Elast.EndYG;
                Tp.SetLeadInOutManual(AcamLeadType.acamLeadLINE, AcamLeadType.acamLeadLINE, true, true,
                                        dblXs, dblYs + 20, dblXf, dblYf - 20);

                ReleaseComObject(Tp);
                ReleaseComObject(Efeed);
                ReleaseComObject(Efirst);
                ReleaseComObject(Elast);
            }
            ReleaseComObject(Tps);
        }

        private void ReleaseComObject(object comObject)
        {
            if (comObject != null)
                Marshal.ReleaseComObject(comObject);
        }

        public bool FileNew()
        {
            bool returnValue = true;

            // function to test if active drawing has any geometries
            // and show a warning that any unsaved data will be lost
            String MsgText = "This will open a new drawing, press OK to continue";
            MessageBoxButtons buttons = MessageBoxButtons.OKCancel;
            if (Acam.ActiveDrawing.GetGeoCount() > 0)
            {
                DialogResult result = MessageBox.Show(MsgText, "Warning", buttons);
                if (result  == DialogResult.OK)
                {
                    Acam.New();
                }
                else if (result ==DialogResult.Cancel)
                {
                    returnValue = false;
                }
            }

            return returnValue;
        }

        public void RefreshDrawing()
        {
            Drawing drw = Acam.ActiveDrawing;

            drw.ThreeDViews = true;
            drw.Options.ShowRapids = false;
            drw.Options.ShowTools = false;
            drw.Redraw();

            ReleaseComObject(drw);
        }
    }
}
