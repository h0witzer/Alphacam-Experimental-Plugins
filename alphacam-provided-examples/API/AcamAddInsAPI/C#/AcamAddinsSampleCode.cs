using System;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using Alphacam.AddIns;
using Alphacam.AddIns.Interface;
using AlphaCAMMill;
using Alphacam.AddIns.Common;
using io = System.IO;


namespace AcamAddinsSampleCodeExamples
{
    // The add-in must contain a class called AlphacamEvents.
    // An instance will be created when the add-in is loaded.
    public class AlphacamEvents
    {
        IAlphaCamApp Acam;
        AddInInterfaceClass theAddInInterface;
        AcamAddinsSampleCode addinsSampleCode;

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
            addinsSampleCode = new AcamAddinsSampleCode(Acam);
            Data.ReturnCode = 0;
        }
    }
    public class AcamAddinsSampleCode : IDisposable
    {
        IAlphaCamApp Acam;
        CommandItemClass ExtendByDistancePoint;
        CommandItemClass ExtendByDistanceStartEnd;
        CommandItemClass ChangeSelectedCircles;
        CommandItemClass ChangeCircleSizeWithGivenDiameter;
        CommandItemClass ChangeCircleSizeWithinGivenDiameterRange;
        CommandItemClass ChangeCircleSizeOnGivenLayer;
        CommandItemClass BlendGeometriesAuto;
        CommandItemClass Blend2Geometries;

        private bool _disposed = false;

        public AcamAddinsSampleCode(IAlphaCamApp Acam)
        {
            this.Acam = Acam;
            Frame Frm = Acam.Frame;

            ExtendByDistancePoint = Frm.CreateCommandItem() as CommandItemClass;
            ExtendByDistancePoint.OnCommand += ExtendByDistancePoint_OnCommand;

            ExtendByDistanceStartEnd = Frm.CreateCommandItem() as CommandItemClass;
            ExtendByDistanceStartEnd.OnCommand += ExtendByDistanceStartEnd_OnCommand;

            ChangeSelectedCircles = Frm.CreateCommandItem() as CommandItemClass;
            ChangeSelectedCircles.OnCommand += ChangeSelectedCircles_OnCommand;

            ChangeCircleSizeWithGivenDiameter = Frm.CreateCommandItem() as CommandItemClass;
            ChangeCircleSizeWithGivenDiameter.OnCommand += ChangeCircleSizeWithGivenDiameter_OnCommand;

            ChangeCircleSizeWithinGivenDiameterRange = Frm.CreateCommandItem() as CommandItemClass;
            ChangeCircleSizeWithinGivenDiameterRange.OnCommand += ChangeCircleSizeWithinGivenDiameterRange_OnCommand;

            ChangeCircleSizeOnGivenLayer = Frm.CreateCommandItem() as CommandItemClass;
            ChangeCircleSizeOnGivenLayer.OnCommand += ChangeCircleSizeOnGivenLayer_OnCommand;

            BlendGeometriesAuto = Frm.CreateCommandItem() as CommandItemClass;
            BlendGeometriesAuto.OnCommand += BlendGeometriesAuto_OnCommand;
            BlendGeometriesAuto.OnUpdate += this.OnUpdate;

            Blend2Geometries = Frm.CreateCommandItem() as CommandItemClass;
            Blend2Geometries.OnCommand += Blend2Geometries_OnCommand;
            Blend2Geometries.OnUpdate += this.OnUpdate;

            string thisProjectFolder = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);

            // Extend by distance - Point
            if (Frm.AddMenuItem33("Using Point (x, y)", "ExtendByDistancePoint_OnCommand", AcamMenuLocation.acamMenuNEW, "Example C# Code", "Extend By Distance", 0, ExtendByDistancePoint))
                AddButton(thisProjectFolder, "Extend By Distance", "ExtendByDistance.bmp", Frm);

            // Extend by distance - Start/End
            if (Frm.AddMenuItem33("Using Start/End", "ExtendByDistanceStartEnd_OnCommand", AcamMenuLocation.acamMenuNEW, "Example C# Code", "Extend By Distance", 1, ExtendByDistanceStartEnd))
                AddButton(thisProjectFolder, "Extend By Distance Start End", "ExtendByDistance.bmp", Frm);

            // Change Circle Size - Given  diameter
            if (Frm.AddMenuItem33("Change selected circles", "ChangeSelectedCircles_OnCommand", AcamMenuLocation.acamMenuNEW, "Example C# Code", "Change Circle Size", 2, ChangeSelectedCircles))
                AddButton(thisProjectFolder, "Change circles", "ChangeCircleSize.bmp", Frm);

            // Change Circle Size - Given  diameter
            if (Frm.AddMenuItem33("Change circles given diameter", "ChangeCircleSizeWithGivenDiameter_OnCommand", AcamMenuLocation.acamMenuNEW, "Example C# Code", "Change Circle Size", 3, ChangeCircleSizeWithGivenDiameter))
                AddButton(thisProjectFolder, "Change circles given diameter", "ChangeCircleSize.bmp", Frm);

            // Change Circle Size - given diameter range
            if (Frm.AddMenuItem33("Change circles given diameter range", "ChangeCircleSizeWithinGivenDiameterRange_OnCommand", AcamMenuLocation.acamMenuNEW, "Example C# Code", "Change Circle Size", 4, ChangeCircleSizeWithinGivenDiameterRange))
                AddButton(thisProjectFolder, "Change circles given diameter range", "ChangeCircleSize.bmp", Frm);

            // Change Circle Size - given diameter range
            if (Frm.AddMenuItem33("Change circles size on given layer", "ChangeCircleSizeOnGivenLayer_OnCommand", AcamMenuLocation.acamMenuNEW, "Example C# Code", "Change Circle Size", 5, ChangeCircleSizeOnGivenLayer))
                AddButton(thisProjectFolder, "Change circles given layer", "ChangeCircleSize.bmp", Frm);

            // Blend Geometries - Auto
            if (Frm.AddMenuItem33("Blend Geometries Auto", "BlendGeometriesAuto_OnCommand", AcamMenuLocation.acamMenuNEW, "Example C# Code", "Blend Geometries", 6, BlendGeometriesAuto))
                AddButton(thisProjectFolder, "Blend Geometries Auto", "BlendGeometries.bmp", Frm);

            // Blend Geometries 
            if (Frm.AddMenuItem33("Blend 2 Geometries", "Blend2Geometries_OnCommand", AcamMenuLocation.acamMenuNEW, "Example C# Code", "Blend Geometries", 7, Blend2Geometries))
                AddButton(thisProjectFolder, "Blend 2 Geometries", "BlendGeometries.bmp", Frm);

            Marshal.ReleaseComObject(Frm);  // Free COM variable
        }

        private void AddButton(string thisProjectFolder, string buttonBarName, string bmpFilename, Frame acamFrame)
        {
            string bmp = System.IO.Path.Combine(thisProjectFolder, bmpFilename);
            if (io.File.Exists(bmp))
            {
                int buttonBarID = acamFrame.CreateButtonBar(buttonBarName);
                acamFrame.AddButton((AcamButtonBar)buttonBarID, bmp, acamFrame.LastMenuCommandID);
            }
        }

        public void Dispose()
        {
            DisposeClass();
            GC.SuppressFinalize(this);
        }

        ~AcamAddinsSampleCode()
        {
            DisposeClass();
        }

        protected virtual void DisposeClass()
        {
            if (_disposed)
                return;

            // Dispose COM variables
            if (ExtendByDistancePoint != null)
                Marshal.ReleaseComObject(ExtendByDistancePoint);
                Marshal.ReleaseComObject(ExtendByDistanceStartEnd);
                Marshal.ReleaseComObject(ChangeSelectedCircles);
                Marshal.ReleaseComObject(ChangeCircleSizeWithGivenDiameter);
                Marshal.ReleaseComObject(ChangeCircleSizeWithinGivenDiameterRange);
                Marshal.ReleaseComObject(ChangeCircleSizeOnGivenLayer);
                Marshal.ReleaseComObject(BlendGeometriesAuto);
                Marshal.ReleaseComObject(Blend2Geometries);

            _disposed = true;
        }
 
        // Called when the menu item is to be enabled or disabled.
        // Return one of the enum AcamOnUpdateReturn values.
        AcamOnUpdateReturn OnUpdate()
        {
            Drawing Drw = Acam.ActiveDrawing;
            AcamOnUpdateReturn ret = Drw.GetGeoCount() >= 2 ? AcamOnUpdateReturn.acamOnUpdate_UncheckedEnabled : AcamOnUpdateReturn.acamOnUpdate_UncheckedDisabled;
            Marshal.ReleaseComObject(Drw);         

            return ret;
        }
       
        // Called when the menu item is clicked on
        void ExtendByDistancePoint_OnCommand()
        {
            AddInsInterface ai = new AddInsInterface();
            AddIns addIns = (AddIns)ai.GetAddInsInterface(Acam.Application);
            ExtendByDistance extendByDistance = addIns.GetExtendByDistanceAddIn();

            Drawing activeDrawing = Acam.ActiveDrawing;

            // Draw a line 50 units long
            Path pthLine = activeDrawing.Create2DLine(0, 0, 50, 0);

            Utils.QuickMessageInformation("Line has been drawn 50 units long");

            // Extend the path by 20 units
            extendByDistance.ExtendPath(pthLine, 50, 0, 20, false);

            activeDrawing.Refresh();

            Utils.QuickMessageInformation("The line has been extended by 20 units");

            Marshal.ReleaseComObject(pthLine);
            Marshal.ReleaseComObject(activeDrawing); 
        }


        //Called when the menu item is clicked on
        private void ExtendByDistanceStartEnd_OnCommand()
        {
            AddInsInterface ai = new AddInsInterface();
            AddIns addIns = (AddIns)ai.GetAddInsInterface(Acam.Application);
            ExtendByDistance extendByDistance = addIns.GetExtendByDistanceAddIn();

            Drawing activeDrawing = Acam.ActiveDrawing;

            // Extend the end of the geometry by 20 units.
            Path pthLine = activeDrawing.Create2DLine(0, 0, 50, 0);

            Utils.QuickMessageInformation("Line has been drawn 50 units long");

            // Extend the path by 20 units from start and end
            extendByDistance.ExtendPath2(pthLine, true, 20, false);

            //The negative value (-) indicates a Trim should be performed in the geometry and not a extend
            extendByDistance.ExtendPath2(pthLine, false, 20, false);

            activeDrawing.Refresh();

            Utils.QuickMessageInformation("The line has been extended by 20 units with Start End method");

            Marshal.ReleaseComObject(pthLine);
            Marshal.ReleaseComObject(activeDrawing);
        }

        // Called when the menu item is clicked on
        void ChangeSelectedCircles_OnCommand()
        {
            AddInsInterface ai = new AddInsInterface();
            AddIns addIns = (AddIns)ai.GetAddInsInterface(Acam.Application);
            ChangeCircleSize changeCircleSize = addIns.GetChangeCircleSizeAddIn();

            Drawing activeDrawing = Acam.ActiveDrawing;

            //Create 4 circles of 3 different sizes - 2 of 30mm diameter and other 2 of 40mm and 50 mm
            Path pthCircle1 = activeDrawing.CreateCircle(50, 0, 0);
            Path pthCircle2 = activeDrawing.CreateCircle(30, 50, 0);
            Path pthCircle3 = activeDrawing.CreateCircle(40, 100, 0);
            Path pthCircle4 = activeDrawing.CreateCircle(30, 150, 0);

            //Create a layer
            Layer CirclesActiveLayer = activeDrawing.CreateLayer("ActiveLayer");

            //Setting the Color of this layer to red to notice the change
            CirclesActiveLayer.Color = AcamColor.acamRED;

            //Make the layer as active to move the modified circles to the active layer
            CirclesActiveLayer.Active = true;
            
            //Add the Circle paths to the collection
            Paths pathsCollection = activeDrawing.CreatePathCollection();
            pathsCollection.Add(pthCircle1);
            pathsCollection.Add(pthCircle4);

            //Change the size of the circles with 30mm to 20mm as new diameter
            //move the modified circles to the active layer
            changeCircleSize.ChangeAllCircles(pathsCollection, 20, true);

            Marshal.ReleaseComObject(pathsCollection);
            Marshal.ReleaseComObject(pthCircle1);
            Marshal.ReleaseComObject(pthCircle2);
            Marshal.ReleaseComObject(pthCircle3);
            Marshal.ReleaseComObject(pthCircle4);
            Marshal.ReleaseComObject(activeDrawing);
        }

        // Called when the menu item is clicked on
        void ChangeCircleSizeWithGivenDiameter_OnCommand()
        {
            AddInsInterface ai = new AddInsInterface();
            AddIns addIns = (AddIns)ai.GetAddInsInterface(Acam.Application);
            ChangeCircleSize changeCircleSize = addIns.GetChangeCircleSizeAddIn();

            Drawing activeDrawing = Acam.ActiveDrawing;

            //Create 4 circles of 3 different sizes - 2 of 30mm diameter and other 2 of 40mm and 50 mm
            Path pthCircle1 = activeDrawing.CreateCircle(50, 0, 0);
            Path pthCircle2 = activeDrawing.CreateCircle(30, 50, 0);
            Path pthCircle3 = activeDrawing.CreateCircle(40, 100, 0);
            Path pthCircle4 = activeDrawing.CreateCircle(30, 150, 0);

            //Create a layer
            Layer CirclesActiveLayer = activeDrawing.CreateLayer("ActiveLayer");

            //Setting the Color of this layer to red to notice the change
            CirclesActiveLayer.Color = AcamColor.acamRED;

            //Make the layer as active to move the modified circles to the active layer
            CirclesActiveLayer.Active = true;

            //Add the Circle paths to the collection
            Paths pathsCollection = activeDrawing.CreatePathCollection();
            pathsCollection.Add(pthCircle1);
            pathsCollection.Add(pthCircle2);
            pathsCollection.Add(pthCircle3);
            pathsCollection.Add(pthCircle4);

            //Change the size of the circles with 30mm to 20mm as new diameter
            //move the modified circles to the active layer
            changeCircleSize.ChangeAllCirclesWithGivenDiameter(pathsCollection, 30, 20, true, true, false);

            Marshal.ReleaseComObject(pathsCollection);
            Marshal.ReleaseComObject(pthCircle1);
            Marshal.ReleaseComObject(pthCircle2);
            Marshal.ReleaseComObject(pthCircle3);
            Marshal.ReleaseComObject(pthCircle4);
            Marshal.ReleaseComObject(activeDrawing);
        }

        // Called when the menu item is clicked on
        void ChangeCircleSizeWithinGivenDiameterRange_OnCommand()
        {
            AddInsInterface ai = new AddInsInterface();
            AddIns addIns = (AddIns)ai.GetAddInsInterface(Acam.Application);
            ChangeCircleSize changeCircleSize = addIns.GetChangeCircleSizeAddIn();

            Drawing activeDrawing = Acam.ActiveDrawing;

            //Create 4 circles of 3 different sizes - 2 of 30mm diameter and other 2 of 40mm and 50 mm
            Path pthCircle1 = activeDrawing.CreateCircle(50, 0, 0);
            Path pthCircle2 = activeDrawing.CreateCircle(30, 50, 0);
            Path pthCircle3 = activeDrawing.CreateCircle(40, 100, 0);
            Path pthCircle4 = activeDrawing.CreateCircle(30, 150, 0);

            //Create a layer
            Layer CirclesActiveLayer = activeDrawing.CreateLayer("ActiveLayer");

            //Setting the Color of this layer to red to notice the change
            CirclesActiveLayer.Color = AcamColor.acamRED;

            //Make the layer as active to move the modified circles to the active layer
            CirclesActiveLayer.Active = true;

            //Add the Circle paths to the collection
            Paths pathsCollection = activeDrawing.CreatePathCollection();
            pathsCollection.Add(pthCircle1);
            pathsCollection.Add(pthCircle2);
            pathsCollection.Add(pthCircle3);
            pathsCollection.Add(pthCircle4);

            //Change the size of the circles whose diameter is between the range of 25mm and 45mm to 20mm as new diameter
            //here we are not moving the modified circles to the active user layer
            changeCircleSize.ChangeAllCirclesWithinGivenDiameterRange(pathsCollection, 25, 45, 20, true, false, false);

            Marshal.ReleaseComObject(pathsCollection);
            Marshal.ReleaseComObject(pthCircle1);
            Marshal.ReleaseComObject(pthCircle2);
            Marshal.ReleaseComObject(pthCircle3);
            Marshal.ReleaseComObject(pthCircle4);
            Marshal.ReleaseComObject(activeDrawing);
        }

        // Called when the menu item is clicked on
        void ChangeCircleSizeOnGivenLayer_OnCommand()
        {
            AddInsInterface ai = new AddInsInterface();
            AddIns addIns = (AddIns)ai.GetAddInsInterface(Acam.Application);
            ChangeCircleSize changeCircleSize = addIns.GetChangeCircleSizeAddIn();

            Drawing activeDrawing = Acam.ActiveDrawing;

            //Create 4 circles of 3 different sizes - 2 of 30mm diameter and other 2 of 40mm and 50 mm
            Path pthCircle1 = activeDrawing.CreateCircle(50, 0, 0);
            Path pthCircle2 = activeDrawing.CreateCircle(30, 50, 0);
            Path pthCircle3 = activeDrawing.CreateCircle(40, 100, 0);
            Path pthCircle4 = activeDrawing.CreateCircle(30, 150, 0);

            //Create a layer
            Layer CirclesLayer = activeDrawing.CreateLayer("Circles30mm");

            pthCircle2.SetLayer(CirclesLayer);
            pthCircle4.SetLayer(CirclesLayer);

            //Create a Layer
            Layer CirclesActiveLayer = activeDrawing.CreateLayer("ActiveLayer");

            //Setting the Color of this layer to red to notice the change
            CirclesActiveLayer.Color = AcamColor.acamRED;

            //Make the layer as active to move the modified circles to the active layer
            CirclesActiveLayer.Active = true;

            //Add the Circle paths to the collection
            Paths pathsCollection = activeDrawing.CreatePathCollection();
            pathsCollection.Add(pthCircle1);
            pathsCollection.Add(pthCircle2);
            pathsCollection.Add(pthCircle3);
            pathsCollection.Add(pthCircle4);

            //Change the size of the circles on the given layer (Circles30mm) to 10mm as new diameter
            //move the modified circles to the active layer
            changeCircleSize.ChangeCirclesOnGivenLayer(pathsCollection, CirclesLayer, 10, true);

            Marshal.ReleaseComObject(pathsCollection);
            Marshal.ReleaseComObject(pthCircle1);
            Marshal.ReleaseComObject(pthCircle2);
            Marshal.ReleaseComObject(pthCircle3);
            Marshal.ReleaseComObject(pthCircle4);
            Marshal.ReleaseComObject(activeDrawing);
        }

        //Called when the menu item is clicked on
        void Blend2Geometries_OnCommand()
        {
            AddInsInterface ai = new AddInsInterface();
            AddIns addIns = (AddIns)ai.GetAddInsInterface(Acam.Application);

            BlendGeometries blendGeo = addIns.GetBlendGeometriesAddIn();

            Drawing activeDrawing = Acam.ActiveDrawing;

            Path p1 = activeDrawing.UserSelectOneGeo("Select First Geometry");
            if (p1 != null)
            {
                p1.Selected = true;
                p1.Redraw();

                Path p2 = activeDrawing.UserSelectOneGeo("Select Second Geometry");
                if (p2 != null)
                {
                    p1.Selected = false;
                    p1.Redraw();
                }

                //blend the selected geos. alter the UseStart... arguments to see the affect.
                Paths pthsRet = blendGeo.BlendGeos(p1, p2, false, true);
                Marshal.ReleaseComObject(p1);
                if (p2 != null)
                    Marshal.ReleaseComObject(p2);
                
                Marshal.ReleaseComObject(pthsRet);
            }
            Marshal.ReleaseComObject(activeDrawing);
        }

        //Called when the menu item is clicked on
        void BlendGeometriesAuto_OnCommand()
        {
            AddInsInterface ai = new AddInsInterface();
            AddIns addIns = (AddIns)ai.GetAddInsInterface(Acam.Application);

            BlendGeometries blendGeo = addIns.GetBlendGeometriesAddIn();

            Drawing activeDrawing = Acam.ActiveDrawing;

            Paths ps = activeDrawing.UserSelectMultiGeosCollection("Select Geometry to blend", 0);
            if (ps != null)
            {
                //BlendGeosAuto will blend the end point of the first geo with the start point of the second geo, the end point of the second geo with the start point of the third geo and so on.
                Paths pthsRet = blendGeo.BlendGeosAuto(ps);
                Marshal.ReleaseComObject(ps);
                Marshal.ReleaseComObject(pthsRet);
            }
            Marshal.ReleaseComObject(activeDrawing);
        }    
    }
}
