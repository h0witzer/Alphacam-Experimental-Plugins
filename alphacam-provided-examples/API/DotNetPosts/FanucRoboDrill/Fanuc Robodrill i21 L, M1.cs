using AlphaCAMMill;
using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using FileIO = System.IO;

namespace FanucRobodrill
{
    public class AlphacamPostEvents
    {
        IAlphaCamApp Acam;
		IFrame Frm;
        AddInPostInterfaceClass PostInterface;

        // General Vars
        string gstrPostName = string.Empty;

        bool blnExitPost = false;
        bool blnToolChange;
        bool blnNesting;
        bool blnStop = false;
        double tax_Workp; double tay_Workp; double taz_Workp;
        double dblPeck;
        double S_Old;

        // Dialog values
        string Description = string.Empty;
        string Revision = string.Empty;
        string Material = string.Empty;
        string Programmer = string.Empty;

        //******************************** Set default vars for Postprocessor ********************************
        
        bool DrillLinear = false;               //True will drill with G0_G1, False will use canned cycles - please notice, that tapping and boring can't be made linear 
        public const int dec_p = 3;             //Set Rounding value for variables
        const double dblArcError = 0.08;        //Set Arc Error for deciding, when G2_G3 will be converted to G1
        const double ParkX = 10.5;              //Set Park Position in X
        const double ParkY = 33.2;              //Set Park Position in Y
        const int MaxToolNumber = 21;           //Max Tool number available in machine
        const int MaxOffsetNumber = 199;        //Max Offset Number available in controller

        string defNCDir = "FanucFolder";        //Default Folder Name stored in the registry - to store location for NC files from this PP
        string defNCExt = "anc";                //Enter default NC file extension for this machine

        string PostAuthor = "Østjydsk CAD-CAM A/S";
        string PostDealer = "Østjydsk CAD-CAM A/S";
        string UKService = "Services and Training";
        string PlanitLtd = "Planit Software Limited";
        string Customer = "Østjydsk CAD-CAM A/S";
		string Development = "Development";

		string sProgramStop;    
		string sStartSpindleAfterProgramStop;
		string sSpindleSpeed;
		string sWith;
		string sToolChange;

		string txtFileName;

        public AlphacamPostEvents(IAlphaCamApp Acam)                                  //******************************** POST EVENTS  
        {
            this.Acam = Acam;
			this.Frm = Acam.Frame;

			txtFileName = FileUtils.TextFilename();

            if (Acam.ProgramLetter != 'R')
            {
                MessageBox.Show(Frm.ReadTextFile(txtFileName, 20, 3));
                return;
            }

            // Create the Post Interface
            PostInterface = Frm.CreateAddInPostInterface() as AddInPostInterfaceClass;

            if (PostInterface != null)
            {
                // Add the event handlers.
                PostInterface.AfterCreateNc += AfterCreateNc;
                PostInterface.AfterOutputNc += AfterOutputNc;
                PostInterface.AfterPostSimulation += AfterPostSimulation;
                PostInterface.AfterOpenPost += AfterOpenPost;
                PostInterface.BeforeCreateNc += BeforeCreateNc;
                //PostInterface.BeforePostSimulation += BeforePostSimulation;
                PostInterface.FilterFunction += FilterFunction;
                //PostInterface.OutputBeginSub += OutputBeginSub;
                //PostInterface.OutputCallSub += OutputCallSub;
                PostInterface.OutputCancelTool += OutputCancelTool;
                //PostInterface.OutputCancelOriginShift += OutputCancelOriginShift;
                //PostInterface.OutputChangeProgPoint += OutputChangeProgPoint;
                //PostInterface.OutputCutAndMoveMaterial += OutputCutAndMoveMaterial;
                //PostInterface.OutputCutHoleCycleCancel += OutputCutHoleCycleCancel;
                //PostInterface.OutputCutHoleCycleFirstHole += OutputCutHoleCycleFirstHole;
                //PostInterface.OutputCutHoleCycleNextHoles += OutputCutHoleCycleNextHoles;
                PostInterface.OutputDrillCycleCancel += OutputDrillCycleCancel;
                PostInterface.OutputDrillCycleFirstHole += OutputDrillCycleFirstHole;
                PostInterface.OutputDrillCycleNextHoles += OutputDrillCycleNextHoles;
                //PostInterface.OutputDrillCycleSubParameters += OutputDrillCycleSubParameters;
                //PostInterface.OutputDown += OutputDown;
                PostInterface.OutputDummyOp += OutputDummyOp;
                //PostInterface.OutputEndSub += OutputEndSub;
                PostInterface.OutputFeed += OutputFeed;
                PostInterface.OutputFileLeadingLines += OutputFileLeadingLines;
                PostInterface.OutputFileTrailingLines += OutputFileTrailingLines;
                //PostInterface.OutputFirstHoleSub += OutputFirstHoleSub;
                //PostInterface.OutputLatheCycle += OutputLatheCycle;
                //PostInterface.OutputLatheFeed += OutputLatheFeed;
                //PostInterface.OutputLatheRapid += OutputLatheRapid;
                //PostInterface.OutputMoveClamp += OutputMoveClamp;
                //PostInterface.OutputMoveMaterial += OutputMoveMaterial;
                //PostInterface.OutputNextHoleSub += OutputNextHoleSub;
                //PostInterface.OutputOriginShift += OutputOriginShift;
                PostInterface.OutputProgramLeadingLines += OutputProgramLeadingLines;
                PostInterface.OutputProgramTrailingLines += OutputProgramTrailingLines;
                PostInterface.OutputRapid += OutputRapid;
                PostInterface.OutputSawCycle += OutputSawCycle;
                //PostInterface.OutputSelectLatheTool += OutputSelectLatheTool;
                PostInterface.OutputSelectTool += OutputSelectTool;
                //PostInterface.OutputSelectToolAndWorkPlane += OutputSelectToolAndWorkPlane;
                PostInterface.OutputSelectWorkPlane += OutputSelectWorkPlane;
                //PostInterface.OutputSetSyncPoint += OutputSetSyncPoint;
                PostInterface.OutputStop += OutputStop;
                //PostInterface.OutputThread += OutputThread;
                //PostInterface.OutputUp += OutputUp;
                
                // Extra event functions unique to C# Posts
                PostInterface.BeforeOutputNc += BeforeOutputNc;
                PostInterface.BeforeOutputNcDialogBox += BeforeOutputNcDialogBox;
                PostInterface.BeforeCreateAnyNc += BeforeCreateAnyNc;
            }

			// Read in strings used by frequently called functions such as OutputRapid, OutputFeed, etc.
			sProgramStop = Frm.ReadTextFile(txtFileName, 31, 27);			
			sStartSpindleAfterProgramStop = Frm.ReadTextFile(txtFileName, 31, 28);
			sSpindleSpeed = Frm.ReadTextFile(txtFileName, 31, 24);
			sWith = Frm.ReadTextFile(txtFileName, 31, 25);
			sToolChange = Frm.ReadTextFile(txtFileName, 31, 26);
        }

        // Implementations of all the Post methods that will be called by ALPHACAM when outputting NC

        void BeforeOutputNc(EventDataFileName Data)                              //******************************** Before Output NC
        {
            // Called before ALPHACAM shows save NC file dialog box

            // Set Data.ReturnCode to one of these values:
            // 0 if ALPHACAM should show normal the dialog box
            // 1 to supply a filename and write the filename to Data.FileName
            // 2 to cancel output

            //MessageBox.Show("BeforeOutputNc");

            // Show dialog to let user pick a filename
            // Directory will be read from registry (default is "My documents")
            // File extension will be .nc

            // Read registry for output location
            const string keyName = "HKEY_CURRENT_USER\\Software\\MyCompanyName\\PostSettings";
            string path = (string)Registry.GetValue(keyName, defNCDir, Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments));

            using (SaveFileDialog saveFileDialog = new SaveFileDialog())
            {
				string sNCCode = Frm.ReadTextFile(txtFileName, 32, 1);
				string sAllFiles = Frm.ReadTextFile(txtFileName, 32, 2);

                saveFileDialog.InitialDirectory = path;
                saveFileDialog.Filter = sNCCode + " (*." + defNCExt  +")|*." + defNCExt + "|" +sAllFiles + " (*.*)|*.*";
                saveFileDialog.FilterIndex = 1;
                saveFileDialog.RestoreDirectory = true;

                if (saveFileDialog.ShowDialog() == DialogResult.OK)
                {
                    // Get the path of chosen file
                    Data.FileName = saveFileDialog.FileName;
                    Data.ReturnCode = 1;

                    // Update registry with new location
                    string FilePath = System.IO.Path.GetDirectoryName(saveFileDialog.FileName);
                    Registry.SetValue(keyName, defNCDir, FilePath);
                }
                else
                {
                    // Cancel output
                    Data.ReturnCode = 2;
                }
            }
        }

        void BeforeOutputNcDialogBox(EventData Data)                             //******************************** Before Output NC Dialogbox
        {
            // Called before the Output NC dialog appears asking the user where to output NC (File, Machine, or Both)

            // Set Data.ReturnCode to one of these values:
            // 0 if ALPHACAM should show normal the dialog box
            // 1 to force File output
            // 2 to force Machine output
            // 3 to force Both
            // 10 to cancel output

            // MessageBox.Show("BeforeOutputNcDialogBox");			

            // Force file only output
            Data.ReturnCode = 1;
        }
        void BeforeCreateAnyNc(EventData Data)                                   //******************************** Before Create Any NC
        {
            // Called before any NC is created allowing Post to potentially disable output
            // See also BeforeCreateNc which is called once but does not allow disabling output. BeforeCreateNc will be called multiple
            // times if outputing a drawing with multiple nested sheets.

            // Set Data.ReturnCode to one of these values:
            // 0 if ALPHACAM should continue as normal
            // 1 to cancel NC output

            //MessageBox.Show("BeforeCreateAnyNc");

            // This is a good location to check license, customer name, etc... to determine if Post can be used or not
            License lic = Acam.License;
            string customerName = lic.GetCustomerName();

            Data.ReturnCode = 0;
			/*
            if (customerName == PostAuthor) { }
            else if (customerName == PostDealer) { }
            else if (customerName == UKService) { }
            else if (customerName == PlanitLtd) { }
            else if (customerName == Customer) { }
			else if (customerName == Development) { }
            else
            {
                MessageBox.Show("WARNING: The Licensename " + customerName + " is not licensed to use with this Postprocessor. " + 
                                "\n \n Please contact reseller for further details",
                                gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);

                Data.ReturnCode = 1;
            }
			*/
            Marshal.ReleaseComObject(lic);

            // Check drawing for anything that the Post can't support
            // For example, if sub-routines are not supported: -
            Drawing drw = Acam.ActiveDrawing;
            Paths toolpaths = drw.ToolPaths;
            gstrPostName = Acam.PostFileName;

            gstrPostName = FileIO.Path.GetFileNameWithoutExtension(gstrPostName);

            int count = toolpaths.Count;
            for (int i = 1; i <= count; ++i)
            {
                IPath toolpath = toolpaths.Item(i);
                if (toolpath.IsSubroutineOriginal || toolpath.IsSubroutineCopy)
                {
                    MessageBox.Show(Frm.ReadTextFile(txtFileName, 20, 1) + "\n \n" + Frm.ReadTextFile(txtFileName, 20, 4) + toolpath.OpNo, 
                                    gstrPostName , MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    Data.ReturnCode = 1;
                    Marshal.ReleaseComObject(toolpath);
                    break;
                }
                Marshal.ReleaseComObject(toolpath);
            }
            Marshal.ReleaseComObject(toolpaths);
            Marshal.ReleaseComObject(drw);
         }

        void AfterCreateNc()                                                    //******************************** AFTER CREATE NC
        {
            //MessageBox.Show("AfterCreateNc");
        }

        void AfterOutputNc(string str)                                          //******************************** AFTER OUTPUT NC
        {
            //MessageBox.Show("AfterOutputNc: " + str);
        }

        void AfterPostSimulation()                                              //******************************** AFTER POST SIMULATION
        {
            //MessageBox.Show("AfterPostSimulation");
        }

        void BeforeCreateNc( )                                                   //******************************** BEFORE CREATE NC
        {
        }

        //void BeforePostSimulation()                                             //******************************** BEFORE POST SIMULATION 
        //{
        //}

        void OutputFileLeadingLines(PostData PD)                               //******************************** OUTPUT FILE LEADING LINES $10
        {
			blnExitPost = false;

            CheckToolData(PD);

            if (blnExitPost)
            {
                Application.Exit();
                return;
            }

            using (frmPostDialog postDialog = new frmPostDialog(Acam, PD)) 
            {
                // Populate variables on the form with current values
                postDialog.Description = Description;
                postDialog.Revision = Revision;
                postDialog.Material = Material;
                postDialog.Programmer = Programmer;
                
                // Show the form using the ShowDialog() method so that it is displayed modally
                DialogResult dialogResult = postDialog.ShowDialog();

                // Check the result from the form
                // The OK button is set to retrurn DialogResult.OK
                // The Cancel button will return DialogResult.Cancel
                if (dialogResult == DialogResult.OK)
                {
                    // Set the module level variables with the values from the form
                    Description = postDialog.Description;
                    Revision = postDialog.Revision;
                    Material = postDialog.Material;
                    Programmer = postDialog.Programmer;

                    PD.UserVariable["PANEL_X"] = postDialog.PanelX;
                    PD.UserVariable["PANEL_Y"] = postDialog.PanelY;
                    PD.UserVariable["PANEL_Z"] = postDialog.PanelZ;

                    PD.UserVariable["OFS_X"] = postDialog.OffsetX;
                    PD.UserVariable["OFS_Y"] = postDialog.OffsetY;
                    PD.UserVariable["OFS_Z"] = postDialog.OffsetZ;

                    PD.UserVariable["ORIG_NO"] = postDialog.Origin;

                    blnExitPost = false;
                }
                else
                {
                    // Either Cancel was pressed or the form was closed using the X
                    // Set a flag so that the post exits in OutputFileLeadingLines
                    blnExitPost = true;
                }
            }

            // Test to see if the post needs to exit (in this case if the user has pressed Cancel on the dialog)
            if (blnExitPost)
            {
                // Display a message and exit
                PD.Post("Dialog cancelled - post will exit");
                PD.Post("$EXIT");
                return;
            }
            
            gstrPostName = Acam.PostFileName;

            gstrPostName = FileIO.Path.GetFileNameWithoutExtension(gstrPostName);

            Drawing drw = Acam.ActiveDrawing;

            // Find Highest Z in Drawing
            double x1, y1, z1, x2, y2, z2;
            drw.GetExtent(out x1, out y1, out z1, out x2, out y2, out z2);
            PD.UserVariable["MAX_Z"] = z2;
  
            Marshal.ReleaseComObject(drw);
 
            // Because IPostVariables is a COM object, this should be stored in a variable so that
            // it can be released when it is no longer needed
            IPostVariables postVariables = PD.Vars;

            if (postVariables.NSH > 0)
                blnNesting = true;
            else
                blnNesting = false;

            // Release the postVariables COM object
            Marshal.ReleaseComObject(postVariables);

            blnToolChange = false;
        }

        void OutputProgramLeadingLines(PostData PD)                               //******************************** OUTPUT PROGRAM LEADING LINES $12
        {
            Drawing Drw = Acam.ActiveDrawing;

            PD.UserVariable["DESCRIPTION"] = Description.ToUpper(); 
            PD.UserVariable["REVISION"] = Revision;
            PD.UserVariable["MATERIAL"] = Material.ToUpper();
            PD.UserVariable["PROGRAMMER"] = Programmer.ToUpper();

            //PD.Post("([DESCRIPTION])");
            //PD.Post("(REV: [REVISION])");
            //PD.Post("(MATERIAL: [MATERIAL])");
            PD.Post("(" + Frm.ReadTextFile(txtFileName, 31, 1) + Drw.FullName + ")");
            PD.Post("(" + Frm.ReadTextFile(txtFileName, 31, 2) + "[PROGRAMMER])");
            
            PD.Post("(" + Frm.ReadTextFile(txtFileName, 31, 3) +  DateTime.Now.ToShortDateString() + ")");
            PD.Post("(" + Frm.ReadTextFile(txtFileName, 31, 4) + DateTime.Now.ToShortTimeString() + ")");

			// Because IPostVariables is a COM object, this should be stored in a variable so that
            // it can be released when it is no longer needed
            IPostVariables pv = PD.Vars;

            int Mins = Convert.ToInt16(pv.TIM / 60);
            int Secs =  Convert.ToInt16(pv.TIM % 60);

            PD.Post("(" + Frm.ReadTextFile(txtFileName, 31, 6) + Mins + Frm.ReadTextFile(txtFileName, 31, 7) + Secs + Frm.ReadTextFile(txtFileName, 31, 8) +  ")");
            PD.Post("(" + Frm.ReadTextFile(txtFileName, 31, 9) + Frm.ReadTextFile(txtFileName, 31, 11)  + "[PANEL_X] / " + Frm.ReadTextFile(txtFileName, 31, 12) + "[PANEL_Y] / " + Frm.ReadTextFile(txtFileName, 31, 13)  + "[PANEL_Z]" + ")");

            PD.Post("");
            OutputToolList(PD);
            PD.Post("");

            PD.Post("#100 = [ORIG_NO]       (" + Frm.ReadTextFile(txtFileName, 31, 14) + ")");
            PD.Post("#101 = [OFS_X]     (" + Frm.ReadTextFile(txtFileName, 31, 15) + ")");
            PD.Post("#102 = [OFS_Y]     (" + Frm.ReadTextFile(txtFileName, 31, 16) + ")");
            PD.Post("#103 = [OFS_Z]     (" + Frm.ReadTextFile(txtFileName, 31, 17) + ")");
            PD.Post("#104 = [PANEL_Z]    (" + Frm.ReadTextFile(txtFileName, 31, 18) + ")");
            PD.Post("#103 = #103 + #104");
            PD.Post("#111 = " + MathUtils.ReplaceCommaDouble(ParkX) + "     (" + Frm.ReadTextFile(txtFileName, 31, 19) + ")");
            PD.Post("#112 = " + MathUtils.ReplaceCommaDouble(ParkY) + "     (" + Frm.ReadTextFile(txtFileName, 31, 20) + ")");
            PD.Post(" ");

            if (blnNesting)
            {
                if (pv.SHN == 1)
                    PD.Post("G0 G17 G40 G80 G49 G90");
                PD.Post("G0 G53 Z0");
            }
            else
                PD.Post("G0 G17 G40 G80 G49 G90");
            PD.Post("G0 G53 Z0");

            // Release the postVariables COM object
            Marshal.ReleaseComObject(pv);

            PD.Post(" ");
            PD.Post("G#100 (" + Frm.ReadTextFile(txtFileName, 31, 22) + ")");

            PD.Post("G52 X#101 Y#102 Z#103 (" + Frm.ReadTextFile(txtFileName, 31, 23) + ")");
            PD.Post(" ");

			Marshal.ReleaseComObject(Drw);
        }

        void OutputProgramTrailingLines(PostData PD)                               //******************************** OUTPUT PROGRAM TRAILING LINES $15
        {
            PD.Post("G0 G53 X#111 Y#112");
            PD.Post("M5");
            PD.Post("M9");
            PD.Post("M30");
        }
        void OutputFileTrailingLines(PostData PD)                               //******************************** OUTPUT FILE TRAILING LINES $17
        {
        }
        void OutputRapid(PostData PD)                                           //******************************** OUTPUT RAPID $20 / 21 / 25
        {
            // Get Rapid Type
            AcamPostRapidType rapidType = PD.RapidType;

            //PD.Post("********TAX_WP = [TAX_WP] / TAY_WP = [TAY_WP] / TAZ_WP = [TAZ_WP]");

            if(blnStop == true)
            {
                blnStop = false;
                PD.Post("(" + sStartSpindleAfterProgramStop + ")");
                PD.Post("M[ROT] S[S]");
                PD.Post(" ");
            }

			IPostVariables pv = PD.Vars;

            if (S_Old != pv.S)
            {
                S_Old = pv.S;
                PD.Post(" ");
                PD.Post("(" + sSpindleSpeed + " )");
                PD.Post("M[ROT] S[S]");
                PD.Post(" ");
            }

			Marshal.ReleaseComObject(pv);

            if (rapidType == AcamPostRapidType.acamPostRapidTypeXY || rapidType == AcamPostRapidType.acamPostRapidTypeXYZ)
            {
                if (blnToolChange)
                {
                    blnToolChange = false;

                    PD.Post("([OPD] " + sWith + " T[T]; [TNM])");
                    PD.Post("G5.1 Q1");

                    PD.Post("G0 X[GAX] Y[GAY]");
                    PD.Post("G0 G43 H[OFS] Z[GAZ] [CLT]");
                }
                else
                {
                    if (rapidType == AcamPostRapidType.acamPostRapidTypeXY)
                        PD.Post("G0 X[GAX] Y[GAY] [CLT]");
                    else
                        PD.Post("G0 X[GAX] Y[GAY] Z[GAZ] [CLT]"); // XYZ Rapid
                }
            }
            else
            {
                // Z-Rapid
                if (!blnToolChange)
                    PD.Post("G0 Z[GAZ]");
            }
        }
        void OutputFeed(PostData PD)                                             //******************************** OUTPUT FEED $40 / 50 / 60
        {
            // Get feed type and the Post Variables
            AcamPostFeedType feedType = PD.FeedType;
            IPostVariables pv = PD.Vars;

            //if (postVariables.MC == 1)
            //{
            //    string message = "WARNING: Cutter Compensation Not Supported on Machine, Use APS Tool Centre.";

            //    MessageBox.Show(message, gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);

            //    PD.Post("$EXIT");
            //    return;
            //}

            if (pv.F <= 1)   //CHECK FOR BUG WHERE FEED IS OUTPUT WITH 0
            {
                MessageBox.Show(Frm.ReadTextFile(txtFileName, 60, 13) + pv.OPN + " / T" + pv.T + Frm.ReadTextFile(txtFileName, 60, 14) + Frm.ReadTextFile(txtFileName, 60, 8), 
                                gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                PD.Post("$EXIT");
            }

            if (feedType == AcamPostFeedType.acamPostFeedTypeLINE)
            {
                // linear
                if (pv.MC + pv.In == 2)
                    PD.Post("G1 G[TC] D[OFS] X[GAX] Y[GAY] Z[GAZ] F[F]");
                else if (pv.LF + pv.Out == 2)
                    PD.Post("G1 G40 X[GAX] Y[GAY] Z[GAZ] F[F]");
                else
                    PD.Post("G1 X[GAX] Y[GAY] Z[GAZ] F[F]");
            }
            else
            {
                // CW or CCW arc
                if (feedType == AcamPostFeedType.acamPostFeedTypeCWARC)
                    PD.UserVariable["G_ARC"] = "G2";
                else
                    PD.UserVariable["G_ARC"] = "G3";

                if (Math.Sqrt(pv.GIX * pv.GIX + pv.GIY * pv.GIY) < dblArcError)
                    PD.Post("G1 X[GAX] Y[GAY] Z[GAZ] F[F]");
                else
                {
                    PD.ModalOff("X,Y");
                    PD.Post("[G_ARC] X[GAX] Y[GAY] Z[GAZ] R[R] F[F]");
                }
            }

            // Release the Variables COM Object
            Marshal.ReleaseComObject(pv);
        }

        void OutputCancelTool(PostData PD)                                       //******************************** OUTPUT CANCEL TOOL $70
        {
            if(blnStop != true)
            {
                PD.ModalOff(" ");
                //PD.Post("G0 Z[MAX_Z+20]");
                PD.Post("G0 G49 G53 Z0 M9");
                PD.Post("G5.1 Q0");
                PD.ModalOn(" ");
            }
        }

        void OutputSelectTool(PostData PD)                                      //******************************** OUTPUT SELECT TOOL CHANGE $80
        {
            IPostVariables pv = PD.Vars;
           
            PD.Post(" ");
            PD.Post("(" + sToolChange + " T[T],  [TNM])");
            PD.Post("M6 T[T]");

            if (pv.TT != 5)
            {
                PD.Post("M[ROT] S[S]");
            }
            PD.Post(" ");

            S_Old = pv.S;
            blnToolChange = true;
            blnStop = false;

            tax_Workp = Math.Cos(MathUtils.Radians(pv.WAC)) * Math.Sin(MathUtils.Radians(pv.WTC));
            tay_Workp = Math.Sin(MathUtils.Radians(pv.WAC)) * Math.Sin(MathUtils.Radians(pv.WTC));
            taz_Workp = Math.Cos(MathUtils.Radians(pv.WTC));

            PD.UserVariable["TAX_WP"] = tax_Workp;
            PD.UserVariable["TAY_WP"] = tay_Workp;
            PD.UserVariable["TAZ_WP"] = taz_Workp;

            Marshal.ReleaseComObject(pv);
        }
        void OutputSelectWorkPlane(PostData PD)                                 //******************************** OUTPUT SELECT WORK PLANE $88
        {
			IPostVariables pv = PD.Vars;

            tax_Workp = Math.Cos(MathUtils.Radians(pv.WAC)) * Math.Sin(MathUtils.Radians(pv.WTC));
            tay_Workp = Math.Sin(MathUtils.Radians(pv.WAC)) * Math.Sin(MathUtils.Radians(pv.WTC));
            taz_Workp = Math.Cos(MathUtils.Radians(pv.WTC));

            PD.UserVariable["TAX_WP"] = tax_Workp;
            PD.UserVariable["TAY_WP"] = tay_Workp;
            PD.UserVariable["TAZ_WP"] = taz_Workp;

			Marshal.ReleaseComObject(pv);
        }
        //void OutputSelectToolAndWorkPlane(PostData PD)                           //******************************** OUTPUT SELECT TOOL AND WORKPLANE $89
        //{
        //}
        //void OutputCallSub(PostData PD)                                         //******************************** OUTPUT CALL SUB $90
        //{
        //}
        //void OutputBeginSub(PostData PD)                                        //******************************** OUTPUT BEGIN SUB $100
        //{
        //}
        //void OutputEndSub(PostData PD)                                          //******************************** OUTPUT END SUB $110
        //{
        //}
        //void OutputOriginShift(PostData PD)                                     //******************************** OUTPUT ORIGIN SHIFT $120
        //{
        //}
        //void OutputCancelOriginShift(PostData PD)                               //******************************** OUTPUT CANCEL ORIGIN SHIFT $130
        //{
        //}
        void OutputDrillCycleCancel(PostData PD)                                //******************************** CANCEL DRILL CYCLE $200
        {
            if (!DrillLinear)
            {
                PD.Post("G80");
            }
        }
        //void OutputFirstHoleSub(PostData PD)                                    //******************************** OUTPUT FIRST HOLE SUB $205
        //{
        //}
        //void OutputNextHoleSub(PostData PD)                                    //******************************** OUTPUT NEXT HOLE SUB $206
        //{
        //}
        void OutputDrillCycleFirstHole(PostData PD)                            //******************************** OUTPUT DRILL CYCLE FIRST HOLE SUB $210, 214, 220, 224, 230, 234, 240 & 244
        {
            AcamPostDrillType drillType = PD.DrillType;
            IPostVariables pv = PD.Vars;

            bool rapidAtRPlane = PD.DrillRapidAtRPlane;

            if (S_Old != pv.S)
            {
                S_Old = pv.S;
                PD.Post(" ");
                PD.Post("(" + sSpindleSpeed + " )");
                PD.Post("M[ROT] S[S]");
                PD.Post(" ");
            }
            if (pv.F <= 1)
            {
                //MessageBox.Show("WARNING: The Feed on your tool OPN " + pv.OPN + " / T" + pv.T + " sems to be 0. Please check your drawing and repost", gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                MessageBox.Show(Frm.ReadTextFile(txtFileName, 60, 13) + pv.OPN + " / T" + pv.T + Frm.ReadTextFile(txtFileName, 60, 14) + Frm.ReadTextFile(txtFileName, 60, 8), gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                PD.Post("$EXIT");
            }
            switch (drillType)
            {
                case AcamPostDrillType.acamPostDrillTypeDRILL:

                    if (!rapidAtRPlane)
                    {
                        // ZS Level
                        if (DrillLinear)
                        {
                            PD.Post("G0 Z[ZR+GLZ]");
                            PD.Post("G1 Z[ZB+GLZ] F[F]");
                            PD.Post("G0 Z[ZS+GLZ]");
                        }
                        else
                        {
                            PD.Post("G98 G81 X[GAX] Y[GAY] Z[GLZ+ZB] R[GLZ+ZR] F[F]");
                        }
                    }
                    else
                    {
                        // ZR Level
                        if (DrillLinear)
                        {
                            PD.Post("G0 Z[ZR+GLZ]");
                            PD.Post("G1 Z[ZB+GLZ] F[F]");
                            PD.Post("G0 Z[ZR+GLZ]");
                        }
                        else
                        {
                            PD.Post("G99 G81 X[GAX] Y[GAY] Z[GLZ+ZB] R[GLZ+ZR] F[F]");
                        }

                    }
                    break;

                case AcamPostDrillType.acamPostDrillTypePECK:

                    if (!rapidAtRPlane)
                    {
                        // ZS Level
                        if (DrillLinear)    //IF POST VARIABLE IS SET TO DRILL LINEAR, USE THIS
                        {
                            PD.Post("G0 Z[ZR+GLZ]");

                            double dblPeck = pv.ZM - pv.ZP;
                            do
                            {
                                PD.UserVariable["PECK"] = dblPeck;
                                PD.Post("G1 Z[PECK+GLZ] F[F]");
                                PD.Post("G0 Z[ZR+GLZ]");
                                PD.Post("G0 Z[PECK+CLEAR_DEPTH]");

                                dblPeck -= pv.ZP;

                            } while (dblPeck > pv.ZB);

                            PD.Post("G1 Z[ZB+GLZ] F[F]");
                            PD.Post("G0 Z[ZS+GLZ]");
                        }
                        else        //POST IS SET TO USE CYCLES
                        {
                            if (pv.FLR == 1)
                            {
                                PD.Post("G98 G83 X[GAX] Y[GAY] Z[GLZ+ZB] R[GLZ+ZR] Q[ZP] F[F]");
                            }
                            else
                            {
                                PD.Post("G98 G73 X[GAX] Y[GAY] Z[GLZ+ZB] R[GLZ+ZR] Q[ZP] F[F]");
                            }
                        }
                    }
                    else
                    {
                        // ZR Level
                        if (DrillLinear)    //IF POST VARIABLE IS SET TO DRILL LINEAR, USE THIS
                        {
                            PD.Post("G0 Z[ZR+GLZ]");

                            dblPeck = pv.ZM - pv.ZP;

                            do
                            {
                                PD.UserVariable["PECK"] = dblPeck;
                                PD.Post("G1 Z[PECK+GLZ] F[F]");
                                PD.Post("G0 Z[ZR+GLZ]");
                                PD.Post("G0 Z[PECK+CLEAR_DEPTH]");

                                dblPeck -= pv.ZP;

                            } while (dblPeck > pv.ZB);


                            PD.Post("G1 Z[ZB+GLZ] F[F]");
                            PD.Post("G0 Z[ZR+GLZ]");
                        }
                        else
                        {
                            if (pv.FLR == 1)
                            {
                                PD.Post("G99 G83 X[GAX] Y[GAY] Z[GLZ+ZB] R[GLZ+ZR] Q[ZP] F[F]");
                            }
                            else
                            {
                                PD.Post("G99 G73 X[GAX] Y[GAY] Z[GLZ+ZB] R[GLZ+ZR] Q[ZP] F[F]");
                            }
                        }
                    }
                    break;

                case AcamPostDrillType.acamPostDrillTypeTAP:
                    if (DrillLinear)
                    {
                        //MessageBox.Show("WARNING: Your Postprocessor is set to drill Linear, which is not possible wiht Tapping. Please contact your reseller for further details", gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                        MessageBox.Show(Frm.ReadTextFile(txtFileName, 60, 15), gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                        PD.Post("$EXIT");
                    }
                    else
                    {
                        if (!rapidAtRPlane)
                        {
                            //ZS Plane
                            PD.Post("M29 S[S]");
                            PD.Post("G98 G84 X[GAX] Y[GAY] Z[GLZ+ZB] R[GLZ+ZR] F[F]");
                        }
                        else
                        {
                            PD.Post("M29 S[S]");
                            PD.Post("G99 G84 X[GAX] Y[GAY] Z[GLZ+ZB] R[GLZ+ZR] F[F]");
                        }
                    }
                    break;

                case AcamPostDrillType.acamPostDrillTypeBORE:
                    if (DrillLinear)
                    {
                        //MessageBox.Show("WARNING: Your Postprocessor is set to drill Linear, which is not possible wiht Boring. Please contact your reseller for further details", gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                        MessageBox.Show(Frm.ReadTextFile(txtFileName, 60, 16), gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                        PD.Post("$EXIT");
                    }
                    else
                    {
                        if (!rapidAtRPlane)
                        {
                            //ZS Plane
                            PD.Post("G98 G85 X[GAX] Y[GAY] Z[GLZ+ZB] R[GLZ+ZR] P[DW] F[F]");
                        }
                        else
                        {
                            PD.Post("G99 G85 X[GAX] Y[GAY] Z[GLZ+ZB] R[GLZ+ZR] P[DW] F[F]");
                        }
                    }
                    break;
            }
            Marshal.ReleaseComObject(pv);
        }

        void OutputDrillCycleNextHoles(PostData PD)                             //******************************** OUTPUT DRILL CYCLE NEXT HOLES SUB $211, 215, 221, 225, 231, 235, 241 & 245
        {
            if (DrillLinear)
            {
                PD.Post("G0 X[GAX] Y[GAY]");
                OutputDrillCycleFirstHole(PD);
            }
            else
            {
                PD.Post("X[GAX] Y[GAY]");
            }
        }
        //void OutputDrillCycleSubParameters(PostData PD)                         //******************************** OUTPUT DRILL CYCLE SUB PARAMETERS $212, 216, 222, 226, 232, 236, 242 & 246
        //{
        //}
        //void OutputCutHoleCycleCancel(PostData PD)                              //******************************** OUTPUT CUT HOLE CYCLE CANCEL
        //{

        //}
        //void OutputCutHoleCycleFirstHole(PostData PD)                           //******************************** OUTPUT CUT HOLE CYCLE FIRST HOLE
        //{
        //}
        //void OutputCutHoleCycleNextHoles(PostData PD)                           //******************************** OUTPUT CUT HOLE CYCLE NEXT HOLES
        //{
        //}
        //void OutputUp(PostData PD)                                              //******************************** OUTPUT UP
        //{
        //}
        //void OutputDown(PostData PD)                                            //******************************** OUTPUT DOWN
        //{
        //}
        void OutputDummyOp(PostData PD)                                         //******************************** OUTPUT DUMMY OPERATIONS
        {
        }
        //void OutputChangeProgPoint(PostData PD)                                 //******************************** OUTPUT CHANGE PROG POINT
        //{
        //}
        //void OutputSelectLatheTool(PostData PD)                                 //******************************** OUTPUT SELECT LATHE TOOL
        //{
        //}
        //void OutputSetSyncPoint(PostData PD)                                    //******************************** OUTPUT SET SYNC POINT
        //{
        //}
        //void OutputLatheCycle(PostData PD)                                      //******************************** OUTPUT LATHE CYCLE
        //{
        //}
        //void OutputLatheFeed(PostData PD)                                       //******************************** OUTPUT LATHE FEED
        //{
        //}
        //void OutputLatheRapid(PostData PD)                                      //******************************** OUTPUT LATHE RAPID
        //{
        //}
        //void OutputThread(PostData PD)                                          //******************************** OUTPUT THREAD
        //{
        //}
        //void OutputMoveMaterial(PostData PD)                                    //******************************** OUTPUT MOVE MATERIAL
        //{
        //}
        //void OutputMoveClamp(PostData PD)                                       //******************************** OUTPUT MOVE CLAMP
        //{
        //}
        //void OutputCutAndMoveMaterial(PostData PD)                              //******************************** OUTPUT CUT AND MOVE MATERIAL
        //{
        //}
        void OutputSawCycle(PostData PD)                                        //******************************** OUTPUT SAW CYCLE
        {
        }
        void OutputStop(PostData PD)                                            //******************************** OUTPUT STOP
        {
            PD.Post("G0 G49 G53 Z0 M5 M9");
            PD.Post("G5.1 Q0");
            PD.Post("G0 G53 X#111 Y#112");
            PD.Post("M5");
            PD.Post("M9");
            PD.Post("");
            PD.Post("(" + sProgramStop + ")");

            PD.Post("M0");
            PD.Post("");

            blnToolChange = true;
            blnStop = true;
        }

        // Called immediately when the Post is loaded by ALPHACAM
        void AfterOpenPost(PostConfigure PC)                                    //******************************** OUTPUT POST CONFIGURE
        {
            PC.CWSpindleRotation = "3"; // $75
            PC.CCWSpindleRotation = "4"; // $76
            PC.MCToolCompCancel = "40"; // $140
            PC.MCToolCompLeft = "41"; // $141
            PC.MCToolCompRight = "42"; // $142
            PC.MCToolCompBlendPercent = 0; // $145
            PC.MCToolCompOnRapidApproach = false; // $146
            PC.MCToolComp5Axis = false; // $148
            PC.CoolantOff = "M9"; // $150
            PC.CoolantMist = "M8"; // $151
            PC.CoolantFlood = "M8"; // $152
            PC.CoolantThroughTool = "M8"; // $153
            PC.ModalText = "G0 G1 G2 G3 M8 M9"; // $500
            PC.ModalAbsoluteValues = "X Y Z B A F"; // $502
            PC.ModalIncrementalValues = ""; // $504
            PC.NeedPlusSigns = false; // $510
            PC.DecimalSeparator = AcamPostDecimalSeparator.acamPostDecimalSeparatorPOINT; // $515
            PC.SubroutinesAtEnd = true; // $520
            PC.LimitArcs = AcamPostLimitArcs.acamPostLimitArcs180; // $525 & 526
            PC.HelicalArcsAsLines = false; // $527
            PC.PlanarArcsAsLines = AcamPostPlanarArcsAsLines.acamPostPlanarArcsAsLinesNONE; // $530
            PC.MaximumArcRadius = 0; // $531
            PC.ArcChordTolerance = 0.02; // $532
            PC.SuppressComments = true; // $540
            PC.AllowOutputVisibleOnly = true; // $545
            PC.FiveAxisProgramPivot = false; // $560
            PC.FiveAxisOffsetFromPivotPointX = 0; // $562
            PC.FiveAxisOffsetFromPivotPointY = 0; // $563
            PC.FiveAxisToolHolderLength = 0; // $565
            PC.FiveAxisToolMaxAngle = 90; // $570
            PC.FiveAxisToolMaxAngleChange = 2; // $575
            PC.Allow5AxisHelicalArcs = false; // $577
            PC.HorizontalMCCentre = true; // $580
            PC.SelectWpToolOrder = AcamPostSelectWpToolOrder.acamPostSelectWpToolOrderTOOL_FIRST; // $582
            PC.LocalXorYAxis = AcamPostLocalXorYAxis.acamPostLocalXorYAxisNONE; // $584
            PC.AllowPositiveAndNegativeTilt = true; // $585

            // SubroutineNumberFormat $700, 701 & 702
            PostFormat pf = PC.SubroutineNumberFormat;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
            pf.LeadingFigures = 0;
            pf.FiguresAfterPoint = 0;
            Marshal.ReleaseComObject(pf);

            PC.SubroutineStartNumber = 1; // $705

            // LineNumberFormat $710, 711 & 712
            pf = PC.LineNumberFormat;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
            pf.LeadingFigures = 0;
            pf.FiguresAfterPoint = 0;
            Marshal.ReleaseComObject(pf);

            PC.LineStartNumber = 10; // $715
            PC.LineNumberIncrement = 10; // $716

            // XYZNumberFormat $720, 721 & 722
            pf = PC.XYZNumberFormat;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat3DECIMAL_NO_0_OR_POINT;
            pf.LeadingFigures = 0;
            pf.FiguresAfterPoint = 3;
            Marshal.ReleaseComObject(pf);

            // ArcCentreNumberFormat  $730, 731 & 732
            pf = PC.ArcCentreNumberFormat;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat3DECIMAL_NO_0_OR_POINT;
            pf.LeadingFigures = 0;
            pf.FiguresAfterPoint = 3;
            Marshal.ReleaseComObject(pf);

            // SpindleSpeedNumberFormat $740, 741 & 742
            pf = PC.SpindleSpeedNumberFormat;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
            pf.LeadingFigures = 0;
            pf.FiguresAfterPoint = 0;
            Marshal.ReleaseComObject(pf);

            PC.SpindleSpeedMax = 24000; // $743
            PC.SpindleSpeedRound = 0; // $745

            // FeedNumberFormat $750, 751 & 752
            pf = PC.FeedNumberFormat;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat1DECIMAL_WITH_0;
            pf.LeadingFigures = 0;
            pf.FiguresAfterPoint = 1;
            Marshal.ReleaseComObject(pf);

            PC.FeedMax = 22860; // $753
            PC.FeedRound = 0; // $755

            // ToolNumberFormat $760, 761 & 762
            pf = PC.ToolNumberFormat;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
            pf.LeadingFigures = 0;
            pf.FiguresAfterPoint = 0;
            Marshal.ReleaseComObject(pf);

            PC.RapidXYSpeed = 22860; // $900
            PC.RapidZSpeed = 2999; // $901
            PC.ToolChangeTime = 15; // $902
            //
            // Create user variables                                            //******************************** CREATE USER VARIABLES
            PostUserVariable UV = PC.AddUserVariable();
            UV.Name = "G_ARC";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormatTEXT;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "PECK";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat3DECIMAL_NO_0_OR_POINT;
            pf.FiguresAfterPoint = 3;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "CLEAR_DEPTH";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat3DECIMAL_NO_0_OR_POINT;
            pf.FiguresAfterPoint = 3;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "TAX_WP";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat3DECIMAL_NO_0_OR_POINT;
            pf.FiguresAfterPoint = 2;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "TAY_WP";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat3DECIMAL_NO_0_OR_POINT;
            pf.FiguresAfterPoint = 2;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "TAZ_WP";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat3DECIMAL_NO_0_OR_POINT;
            pf.FiguresAfterPoint = 2;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "DATE";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormatTEXT_TRUNCATE;
            pf.LeadingFigures = 9;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "MAX_Z";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat3DECIMAL_NO_0_OR_POINT;
            pf.FiguresAfterPoint = 3;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "DESCRIPTION";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormatTEXT;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "REVISION";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormatTEXT;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "MATERIAL";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormatTEXT;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "PROGRAMMER";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormatTEXT;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "PARK_X";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat3DECIMAL_NO_0_OR_POINT;
            pf.FiguresAfterPoint = 3;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "PARK_Y";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat3DECIMAL_NO_0_OR_POINT;
            pf.FiguresAfterPoint = 3;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "PANEL_X";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat10DECIMAL_LEAD_AND_TRAIL;
            pf.FiguresAfterPoint = 2;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "PANEL_Y";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat10DECIMAL_LEAD_AND_TRAIL;
            pf.FiguresAfterPoint = 2;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "PANEL_Z";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat10DECIMAL_LEAD_AND_TRAIL;
            pf.FiguresAfterPoint = 2;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "OFS_X";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat10DECIMAL_LEAD_AND_TRAIL;
            pf.FiguresAfterPoint = 2;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "OFS_Y";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat10DECIMAL_LEAD_AND_TRAIL;
            pf.FiguresAfterPoint = 2;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "OFS_Z";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat10DECIMAL_LEAD_AND_TRAIL;
            pf.FiguresAfterPoint = 2;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "ORIG_NO";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
            pf.FiguresAfterPoint = 3;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);
        }

        void FilterFunction(string Buffer, EventDataText Data)                   //******************************** FILTER FUNCTIONS
        {
            // Return 1 if we don't want to filter this (or any future output)
            Data.ReturnCode = 1;
            /*
			// Return 0 if we want to filter this (or future text)
			Data.ReturnCode = 0;

			// Then set the text to replace, e.g. replace brackets with curly brackets...
			Buffer = Buffer.Replace('(', '{');
			Buffer = Buffer.Replace(')', '}');
			Data.Text = Buffer;
			*/
        }

        void OutputToolList(PostData PD)                                        //******************************** OUTPUT TOOL LIST - AVOID REPETITIONS
        {
            PD.Post("");
            //PD.Post("( * * TOOLS USED IN THIS PROGRAM * * )");
            //PD.Post("( NUMBER ; OFFSET ; NAME             )");
            PD.Post("(" + Frm.ReadTextFile(txtFileName, 60, 11) +")");
            PD.Post("(" + Frm.ReadTextFile(txtFileName, 60, 12) +")");

            IPostVariables pv = PD.Vars;
            IPostArrayVariables av = PD.ArrayVars;
            // Since we don't want duplicates, store the tools in a mathematical set (in C# we use a 'HashSet') of strings
            HashSet<string> toolNames = new HashSet<string>();
            int numTools = (int)pv.NMT;
            for (int i = 1; i <= numTools; ++i)
            {
                string name = av.TNM[i];
                // Add name to the set and check whether it was added (first tool with that name)
                // or not (we've already found that tool)
                bool bAdded = toolNames.Add(name);
                if (bAdded)
                {
                    // Found the first instance of this tool, so get some more information and output it
                    int number = (int)av.T[i];
                    int offset = (int)av.OFS[i];

                    if (number == -1)
                        PD.Post("(   *   ;   *   ; PROGRAM STOP )");
                    else
                        PD.Post("(   " + number + "   ;   " + offset + "   ; " + name + ")");
                }
            }
            // Release the postVariables COM object
            Marshal.ReleaseComObject(pv);
            Marshal.ReleaseComObject(av);
        }

		bool GotVisibleToolPath()
		{
			Drawing Drw = Acam.ActiveDrawing;
			IPaths TPs = Drw.ToolPaths;
			int count = TPs.Count;
			bool gotVisible = false;
			for (int i = 1; i <= count && !gotVisible; ++i)
			{
				IPath TP = TPs.Item(i);
                if (TP.Visible)
                    gotVisible = true;
				Marshal.ReleaseComObject(TP);
            }
			Marshal.ReleaseComObject(TPs);
			Marshal.ReleaseComObject(Drw);

			return gotVisible;
		}

        void CheckToolData(PostData PD)                                            //******************************** OUTPUT CHECK TOOL DATA FOR LEGAL INPUT
        {
            string AttrT; string AttrT_;
            string AttrOfs; string AttrOfs_;
            string AttrName; string AttrName_;

			IPostVariables pv = PD.Vars;
            int numTools = (int)pv.NMT;
            Marshal.ReleaseComObject(pv);

            if (!GotVisibleToolPath())
            {
                //MessageBox.Show("WARNING: There must be at least one Active Toolpath. Check your Drawing and Repost", gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                MessageBox.Show(Frm.ReadTextFile(txtFileName, 60, 1),
                                gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                PD.Post("$EXIT");
                blnExitPost = true;
				return;
            }

			IPostArrayVariables ArrayVars = PD.ArrayVars;

            for (int i = 1; i <= numTools; ++i)
            {
                if (ArrayVars.T[i] > MaxToolNumber)
                {
                    //MessageBox.Show("WARNING: You have selected a Tool Number above " + MaxToolNumber  + " which is not possible on this machine. Check your Drawing and Repost", gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    MessageBox.Show(Frm.ReadTextFile(txtFileName, 60, 2) + MaxToolNumber + Frm.ReadTextFile(txtFileName, 60, 3),
                                    gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    blnExitPost = true;
                    break;
                }

				if (ArrayVars.OFS[i] > MaxOffsetNumber)
                {
                    //MessageBox.Show("WARNING: You have selected an Offset Number above " + MaxOffsetNumber + " which is not possible on this machine. Check your Drawing and Repost", gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    MessageBox.Show(Frm.ReadTextFile(txtFileName, 60, 4) + MaxOffsetNumber + Frm.ReadTextFile(txtFileName, 60, 3),
                                    gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    blnExitPost = true;
                    break;
                }
            }

            for (int i = 1; i <= numTools && !blnExitPost; ++i) 
            {
                AttrT = "AttrT" + ArrayVars.T[i];
                AttrOfs = "AttrOfs" + ArrayVars.OFS[i];
                AttrName = "AttrName" + ArrayVars.TNM[i];

                for (int j = 1; j <= numTools; ++j)
                {
                    AttrT_ = "AttrT" + ArrayVars.T[j];
                    AttrOfs_ = "AttrOfs" + ArrayVars.OFS[j];
                    AttrName_ = "AttrName" + ArrayVars.TNM[j];

                    if (AttrT == AttrT_ && AttrOfs == AttrOfs_)  //Same Tool, Same Place
                    {

                    }
                    else if (AttrName == AttrName_)             //Tool Number is repeated with another offset
                    {
                        //MessageBox.Show("WARNING: It seems as the Tool Named:" + ArrayVars.TNM[i] + ", has been used with two different numbers. Please check your Drawing and Repost", gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                        MessageBox.Show(Frm.ReadTextFile(txtFileName, 60, 5) + ArrayVars.TNM[i] + Frm.ReadTextFile(txtFileName, 60, 6), 
                                        gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                        blnExitPost = true;
                        break;
                    }
                    else if (AttrT == AttrT_ )                  //Tool Number is repeated with another offset
                    {
                        //MessageBox.Show("WARNING: It seems as you have used the same Tool Number on two different Tools Number=" + ArrayVars.T[i] + " Check your Drawing and Repost", gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                        MessageBox.Show(Frm.ReadTextFile(txtFileName, 60, 7) + ArrayVars.T[i] + Frm.ReadTextFile(txtFileName, 60, 8), 
                                        gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                        blnExitPost = true;
                        break;
                    }
                    else if (AttrOfs == AttrOfs_)               //Offset is repeated with another tool number
                    {
                        //MessageBox.Show("WARNING: It seems as you have used the same Offset Number on two different Tools Ofs=" + ArrayVars.OFS[i] + " Check your Drawing and Repost", gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                        MessageBox.Show(Frm.ReadTextFile(txtFileName, 60, 9) + ArrayVars.OFS[i] + Frm.ReadTextFile(txtFileName, 60, 8), 
                                        gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                        blnExitPost = true;
                        break;
                    }
                }
			}
            
			Marshal.ReleaseComObject(ArrayVars);

			if (blnExitPost)
				PD.Post("$EXIT");
		}
    }
}
