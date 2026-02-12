using System;
using System.Runtime.InteropServices;
using AlphaCAMMill;

namespace DoorMachiningAddin
{
    class MachiningRoutines
    {
        IAlphaCamApp Acam;

        public MachiningRoutines(IAlphaCamApp AcamApp)
        {
            Acam = AcamApp;
        }

        //function to select router Tool
        public void SelectRouterTool(String ToolName)
        {
            MillTool Tool = null;
            while (Tool == null)
            {
                Tool = Acam.SelectTool(ToolName);
                if (Tool == null)
                    Tool = Acam.SelectTool("$User");
            }
            Marshal.ReleaseComObject(Tool);
        }

        public Paths CreateRoughFinishPaths(Paths GeosToMachine, Double dblSafeRapid = 0,Double dblRapidDownto = 0,
            Double dblMaterialTop = 0,Double dblFinalDepth = 0,Double dblStock = 0, AcamComp mcComp = AcamComp.acamCompTOOLCEN, AcamCorners xyCorners = AcamCorners.acamCornersROUND, AcamCoolant coolant = AcamCoolant.acamCoolNONE)
        {
            MillData Md = Acam.CreateMillData();
            Md.SafeRapidLevel = (float)dblSafeRapid;
            Md.RapidDownTo = (float)dblRapidDownto;
            Md.MaterialTop = (float)dblMaterialTop;
            Md.FinalDepth = (float)dblFinalDepth;
            Md.Stock = (float)dblStock;
            Md.McComp = mcComp;
            Md.XYCorners = xyCorners;
            Md.Coolant = coolant;
            //select the geometries to be machined 
            GeosToMachine.Selected = true;
            //create the toolpaths
            Paths roughFinishPaths = Md.RoughFinish();
            
            // release the MillData COM object
            Marshal.ReleaseComObject(Md);

            return roughFinishPaths;            
        }

        public Paths Create3dEngravePaths(Paths GeosToMachine, float dblSafeRapid = 0, float dblRapidDownto = 0,
            float dblMaterialTop = 0, float dblFinalDepth = 0, float dblEngraveCornerAngleLimit = 180, Double dblChordError = 0.05, Double dblStepLength = 0.1)
        {
            MillData Md = Acam.CreateMillData();

            Md.SafeRapidLevel = dblSafeRapid;
            Md.RapidDownTo = dblRapidDownto;
            Md.MaterialTop = dblMaterialTop;
            Md.FinalDepth = dblFinalDepth;
            Md.StepLength = (float)dblStepLength;
            Md.ChordError = (float)dblChordError;
            Md.EngraveType = AcamEngraveType.acamEngraveGEOMETRIES;
            Md.EngraveCornerAngleLimit = dblEngraveCornerAngleLimit;

            //select the geometries
            GeosToMachine.Selected = true;
            //create the toolpaths
            Paths engravePaths = Md.Engrave();

            // Release the MillData COM object
            Marshal.ReleaseComObject(Md);

            return engravePaths;
        }
    }
}
