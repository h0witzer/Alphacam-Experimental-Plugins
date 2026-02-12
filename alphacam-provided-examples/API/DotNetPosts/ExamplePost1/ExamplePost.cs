using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;

using AlphaCAMMill;
using System.Windows.Forms;
using System.Xml.Linq;
using Microsoft.Win32;

namespace ExamplePost1
{
    public class AlphacamPostEvents
    {
        IAlphaCamApp Acam;
        AddInPostInterfaceClass PostInterface;
		bool bToolChange = false;

		public AlphacamPostEvents(IAlphaCamApp Acam)
        {
            this.Acam = Acam;

			if (Acam.ProgramLetter != 'R')
			{
				MessageBox.Show("ExamplePost1 is intended for Router only");
				return;
			}

			// Create the Post Interface
			Frame Frm = Acam.Frame;
			PostInterface = Frm.CreateAddInPostInterface() as AddInPostInterfaceClass;
			if (PostInterface != null)
			{
				// Add the event handlers.  This example shows them all for completeness, but a real
				// Post should just add handlers for the events required.
				PostInterface.AfterCreateNc += AfterCreateNc;
				PostInterface.AfterOutputNc += AfterOutputNc;
				PostInterface.AfterPostSimulation += AfterPostSimulation;
				PostInterface.AfterOpenPost += AfterOpenPost;
				PostInterface.BeforeCreateNc += BeforeCreateNc;
				PostInterface.BeforePostSimulation += BeforePostSimulation;
				PostInterface.FilterFunction += FilterFunction;
				PostInterface.OutputBeginSub += OutputBeginSub;
				PostInterface.OutputCallSub += OutputCallSub;
				PostInterface.OutputCancelTool += OutputCancelTool;
				PostInterface.OutputCancelOriginShift += OutputCancelOriginShift;
				PostInterface.OutputChangeProgPoint += OutputChangeProgPoint;
				PostInterface.OutputCutAndMoveMaterial += OutputCutAndMoveMaterial;
				PostInterface.OutputCutHoleCycleCancel += OutputCutHoleCycleCancel;
				PostInterface.OutputCutHoleCycleFirstHole += OutputCutHoleCycleFirstHole;
				PostInterface.OutputCutHoleCycleNextHoles += OutputCutHoleCycleNextHoles;
				PostInterface.OutputDrillCycleCancel += OutputDrillCycleCancel;
				PostInterface.OutputDrillCycleFirstHole += OutputDrillCycleFirstHole;
				PostInterface.OutputDrillCycleNextHoles += OutputDrillCycleNextHoles;
				PostInterface.OutputDrillCycleSubParameters += OutputDrillCycleSubParameters;
				PostInterface.OutputDown += OutputDown;
				PostInterface.OutputDummyOp += OutputDummyOp;
				PostInterface.OutputEndSub += OutputEndSub;
				PostInterface.OutputFeed += OutputFeed;
				PostInterface.OutputFileLeadingLines += OutputFileLeadingLines;
				PostInterface.OutputFileTrailingLines += OutputFileTrailingLines;
				PostInterface.OutputFirstHoleSub += OutputFirstHoleSub;
				PostInterface.OutputLatheCycle += OutputLatheCycle;
				PostInterface.OutputLatheFeed += OutputLatheFeed;
				PostInterface.OutputLatheRapid += OutputLatheRapid;
				PostInterface.OutputMoveClamp += OutputMoveClamp;
				PostInterface.OutputMoveMaterial += OutputMoveMaterial;
				PostInterface.OutputNextHoleSub += OutputNextHoleSub;
				PostInterface.OutputOriginShift += OutputOriginShift;
				PostInterface.OutputProgramLeadingLines += OutputProgramLeadingLines;
				PostInterface.OutputProgramTrailingLines += OutputProgramTrailingLines;
				PostInterface.OutputRapid += OutputRapid;
				PostInterface.OutputSawCycle += OutputSawCycle;
				PostInterface.OutputSelectLatheTool += OutputSelectLatheTool;
				PostInterface.OutputSelectTool += OutputSelectTool;
				PostInterface.OutputSelectToolAndWorkPlane += OutputSelectToolAndWorkPlane;
				PostInterface.OutputSelectWorkPlane += OutputSelectWorkPlane;
				PostInterface.OutputSetSyncPoint += OutputSetSyncPoint;
				PostInterface.OutputStop += OutputStop;
				PostInterface.OutputThread += OutputThread;
				PostInterface.OutputUp += OutputUp;
				// Extra event functions unique to C# Posts
				PostInterface.BeforeOutputNc += BeforeOutputNc;
				PostInterface.BeforeOutputNcDialogBox += BeforeOutputNcDialogBox;
				PostInterface.BeforeCreateAnyNc += BeforeCreateAnyNc;
			}
			// Release the Frm COM object
            Marshal.ReleaseComObject(Frm);
        }

		// Helper functions
		void OutputToolList(PostData PD)    //Output Tool Data 
        {
            PD.Post("");
            PD.Post("( * * TOOLS USED IN THIS PROGRAM * * )");
            PD.Post("( NUMBER ; OFFSET ; NAME             )");
            IPostVariables Vars = PD.Vars;
            IPostArrayVariables ArrayVars = PD.ArrayVars;
            // Since we don't want duplicates, store the tools in a mathematical set (in C# we use a 'HashSet') of strings
            HashSet<string> toolNames = new HashSet<string>();
            int numTools = (int)Vars.NMT;
            for (int i = 1; i <= numTools; ++i)
            {
                string name = ArrayVars.TNM[i];
                // Add name to the set and check whether it was added (first tool with that name)
                // or not (we've already found that tool)
                bool bAdded = toolNames.Add(name);
                if (bAdded)
                {
                    // Found the first instance of this tool, so get some more information and output it
                    int number = (int)ArrayVars.T[i];
                    int offset = (int)ArrayVars.OFS[i];
                    if (number == -1)
                        PD.Post("( * ; * ; PROGRAM STOP )");
                    else
                        PD.Post("(   " + number + "   ;   " + offset + "   ; " + name + ")");
                }
            }
            // Release the postVariables COM object
            Marshal.ReleaseComObject(Vars);
            Marshal.ReleaseComObject(ArrayVars);
        }


		// Implementations of all the Post methods that will be called by ALPHACAM when outputting NC

		void BeforeOutputNc(EventDataFileName Data)
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
			string path = (string)Registry.GetValue(keyName, "DefaultNCDir", Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments));

			using (SaveFileDialog saveFileDialog = new SaveFileDialog())
			{
				saveFileDialog.InitialDirectory = path;
				saveFileDialog.Filter = "NC Code (*.nc)|*.nc|All files (*.*)|*.*";
				saveFileDialog.FilterIndex = 1;
				saveFileDialog.RestoreDirectory = true;

				if (saveFileDialog.ShowDialog() == DialogResult.OK)
			    {
			        // Get the path of chosen file
					Data.FileName = saveFileDialog.FileName;
					Data.ReturnCode = 1;

					// Update registry with new location
					string FilePath = System.IO.Path.GetDirectoryName(saveFileDialog.FileName);
					Registry.SetValue(keyName, "DefaultNCDir", FilePath);
				}
				else
				{
					// Cancel output
					Data.ReturnCode = 2;
				}
			}
		}

		void BeforeOutputNcDialogBox(EventData Data)
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

		void BeforeCreateAnyNc(EventData Data)
		{
			// Called before any NC is created allowing Post to potentially disable output
			// See also BeforeCreateNc which is called once but does not allow disabling output. BeforeCreateNc will be called multiple
			// times if outputing a drawing with multiple nested sheets.

			// Set Data.ReturnCode to one of these values:
			// 0 if ALPHACAM should continue as normal
			// 1 to cancel NC output

			// MessageBox.Show("BeforeCreateAnyNc");

			// This is a good location to check license, customer name, etc... to determine if Post can be used or not
			License lic = Acam.License;
			string customerName = lic.GetCustomerName();			
			Marshal.ReleaseComObject(lic);

			// MessageBox.Show("Customer Name is " + customerName);

			Data.ReturnCode = 0;

			// Check drawing for anything that the Post can't support
			// For example, if sub-routines are not supported: -
			Drawing drw = Acam.ActiveDrawing;
			Paths toolpaths = drw.ToolPaths;
			int count = toolpaths.Count;
			for (int i = 1; i <= count; ++i)
			{
				IPath toolpath = toolpaths.Item(i);
				if (toolpath.IsSubroutineOriginal || toolpath.IsSubroutineCopy)
				{
					MessageBox.Show("WARNING: Use Linear Code Not Subroutines.\nPlease Check Op." + toolpath.OpNo);
		            Data.ReturnCode = 1;
					Marshal.ReleaseComObject(toolpath);
					break;
				}
				Marshal.ReleaseComObject(toolpath);
			}
			Marshal.ReleaseComObject(toolpaths);
			Marshal.ReleaseComObject(drw);
		}

		void AfterCreateNc()
		{
			//MessageBox.Show("AfterCreateNc");
		}
		void AfterOutputNc(string str)
		{
			//MessageBox.Show("AfterOutputNc: " + str);
		}
		void AfterPostSimulation()
		{
			//MessageBox.Show("AfterPostSimulation");
		}
		void BeforeCreateNc()
		{
			//MessageBox.Show("BeforeCreateNc");
		}
		void BeforePostSimulation()
		{
			//MessageBox.Show("BeforePostSimulation");
		}
		void OutputFileLeadingLines(PostData PD)
		{
			PD.Post("********* DOT NET POST *********");
			bToolChange = false;

			// Assign values to custom user variables and output them
			PD.UserVariable["MY_INTEGER"] = 100;
			PD.UserVariable["MY_DOUBLE"] = 3.1414593;
			PD.UserVariable["MY_STRING"] = "Hello World!";
			PD.Post("(MY_INTEGER = [MY_INTEGER])");
			PD.Post("(MY_DOUBLE = [MY_DOUBLE])");
			PD.Post("(MY_STRING = [MY_STRING])");

			// Retrieve the values, update them and output again		
			int myInteger = Convert.ToInt32(PD.UserVariable["MY_INTEGER"]);
			myInteger += 100;
			PD.UserVariable["MY_INTEGER"] = myInteger;

			double myDouble = Convert.ToDouble(PD.UserVariable["MY_DOUBLE"]);
			myDouble *= 2.0;
			PD.UserVariable["MY_DOUBLE"] = myDouble;

			PD.Post("(Updated: MY_INTEGER = [MY_INTEGER])");
			PD.Post("(Updated: MY_DOUBLE = [MY_DOUBLE])");

			// Output a list of unique tools used in the Drawing
			OutputToolList(PD);
		}
		void OutputProgramLeadingLines(PostData PD)
		{
			int pn = 0;
			do
			{
				PD.AskUserVariable("PROGNUM");
				pn = Convert.ToInt32(PD.get_UserVariable("PROGNUM"));
			} while (pn <= 0);

			PD.Post("%");
			PD.Post(":[PROGNUM] ([FNM])");
			PD.Post("N[N] G17 G40 G80 G90");
		}
		void OutputProgramTrailingLines(PostData PD)
		{
			PD.Post("N[N] G0 G53 X0. Y0.");
			PD.Post("N[N] M30");
			PD.Post("%");
		}
		void OutputFileTrailingLines(PostData PD)
		{
		}
		void OutputRapid(PostData PD)
		{
			// Get Rapid Type
			AcamPostRapidType type = PD.RapidType;

			if (type == AcamPostRapidType.acamPostRapidTypeZ)
			{
				if (!bToolChange)
					PD.Post("N[N] G0 Z[GAZ]");
			}
			else
			{
				if (bToolChange)
				{
					bToolChange = false;
					PD.Post("N[N] G0 X[GAX] Y[GAY]");
					PD.Post("N[N] G43 H[OFS] Z[GAZ]");
				}
				else if (type == AcamPostRapidType.acamPostRapidTypeXYZ)
				{
					PD.Post("N[N] G0 X[GAX] Y[GAY] Z[GAZ]");
				}
				else
				{
					PD.Post("N[N] G0 X[GAX] Y[GAY]");
				}
			}
		}
		void OutputFeed(PostData PD)
		{
			// Get feed type and the Post Variables
			AcamPostFeedType type = PD.FeedType;
			IPostVariables V = PD.Vars;

			if (type == AcamPostFeedType.acamPostFeedTypeLINE)
			{
				if (V.MC == 1.0 && (V.In == 1.0 || V.Out == 1.0))
				{
					PD.Post("N[N] G1 G[TC] D[OFS] X[GAX] Y[GAY] Z[GAZ] F[F]");
				}
				else
				{
					PD.Post("N[N] G1 X[GAX] Y[GAY] Z[GAZ] F[F]");
				}
			}
			else if (type == AcamPostFeedType.acamPostFeedTypeCWARC)
			{
				PD.Post("N[N] G2 X[GAX] Y[GAY] Z[GAZ] R[R] F[F]");
			}
			else
			{
				PD.Post("N[N] G3 X[GAX] Y[GAY] Z[GAZ] R[R] F[F]");
			}

			// Release the Variables COM Object
			Marshal.ReleaseComObject(V);
		}
		void OutputCancelTool(PostData PD)
		{
			PD.Post("N[N] G0 G53 Z0. M9");
		}
		void OutputSelectTool(PostData PD)
		{
			PD.Post("N[N] ([TNM])");
			PD.Post("N[N] T[T] M6");
			PD.Post("N[N] M[ROT] S[S]");
			bToolChange = true;
		}
		void OutputSelectWorkPlane(PostData PD)
		{
		}
		void OutputSelectToolAndWorkPlane(PostData PD)
		{
		}
		void OutputCallSub(PostData PD)
		{
		}
		void OutputBeginSub(PostData PD)
		{
		}
		void OutputEndSub(PostData PD)
		{
		}
		void OutputOriginShift(PostData PD)
		{
		}
		void OutputCancelOriginShift(PostData PD)
		{
		}
		void OutputDrillCycleCancel(PostData PD)
		{
			PD.Post("N[N] G80");
		}
		void OutputFirstHoleSub(PostData PD)
		{
		}
		void OutputNextHoleSub(PostData PD)
		{
		}
		void OutputDrillCycleFirstHole(PostData PD)
		{
			AcamPostDrillType drillType = PD.DrillType;
			bool rapidAtRPlane = PD.DrillRapidAtRPlane;

			if (drillType == AcamPostDrillType.acamPostDrillTypeDRILL)
			{
				if (rapidAtRPlane)
				{
					// R PLANE
					PD.Post("N[N] G98 G81 X[GAX] Y[GAY] Z[ZB] R[ZR] F[F]");
				}
				else
				{
					// Z SAFE
					PD.Post("N[N] G99 G81 X[GAX] Y[GAY] Z[ZB] R[ZS] F[F]");
				}
			}
			else if (drillType == AcamPostDrillType.acamPostDrillTypePECK)
			{
				if (rapidAtRPlane)
				{
					// R PLANE
					PD.Post("N[N] G98 G83 X[GAX] Y[GAY] Z[ZB] R[ZR] Q[ZP] F[F]");
				}
				else
				{
					// Z SAFE
					PD.Post("N[N] G99 G83 X[GAX] Y[GAY] Z[ZB] R[ZS] Q[ZP] F[F]");
				}
			}
			else if (drillType == AcamPostDrillType.acamPostDrillTypeTAP)
			{
				if (rapidAtRPlane)
				{
					// R PLANE
					PD.Post("N[N] G98 G84 X[GAX] Y[GAY] Z[ZB] R[ZR] F[F]");
				}
				else
				{
					// Z SAFE
					PD.Post("N[N] G99 G84 X[GAX] Y[GAY] Z[ZB] R[ZS] F[F]");
				}
			}
			else if (drillType == AcamPostDrillType.acamPostDrillTypeBORE)
			{
				if (rapidAtRPlane)
				{
					// R PLANE
					PD.Post("N[N] G98 G85 X[GAX] Y[GAY] Z[ZB] R[ZR] P[DW] F[F]");
				}
				else
				{
					// Z SAFE
					PD.Post("N[N] G99 G85 X[GAX] Y[GAY] Z[ZB] R[ZS] P[DW] F[F]");
				}
			}
		}
		void OutputDrillCycleNextHoles(PostData PD)
		{
			PD.Post("N[N] X[GAX] Y[GAY]");
		}
		void OutputDrillCycleSubParameters(PostData PD)
		{
		}
		void OutputCutHoleCycleCancel(PostData PD)
		{
		}
		void OutputCutHoleCycleFirstHole(PostData PD)
		{
		}
		void OutputCutHoleCycleNextHoles(PostData PD)
		{
		}
		void OutputUp(PostData PD)
		{
		}
		void OutputDown(PostData PD)
		{
		}
		void OutputDummyOp(PostData PD)
		{
		}
		void OutputChangeProgPoint(PostData PD)
		{
		}
		void OutputSelectLatheTool(PostData PD)
		{
		}
		void OutputSetSyncPoint(PostData PD)
		{
		}
		void OutputLatheCycle(PostData PD)
		{
		}
		void OutputLatheFeed(PostData PD)
		{
		}
		void OutputLatheRapid(PostData PD)
		{
		}
		void OutputThread(PostData PD)
		{
		}
		void OutputMoveMaterial(PostData PD)
		{
		}
		void OutputMoveClamp(PostData PD)
		{
		}
		void OutputCutAndMoveMaterial(PostData PD)
		{
		}
		void OutputSawCycle(PostData PD)
		{
		}
		void OutputStop(PostData PD)
		{
		}

		// Called immediately when the Post is loaded by ALPHACAM
		void AfterOpenPost(PostConfigure PC)
		{
			PC.CWSpindleRotation = "3";			// $75
			PC.CCWSpindleRotation = "4";		// $76
			PC.MCToolCompCancel = "40";         // $140
			PC.MCToolCompLeft = "41";           // $141
			PC.MCToolCompRight = "42";          // $142
			PC.MCToolCompBlendPercent = 10;     // $145
			PC.MCToolCompAdjustInternalCorners = false;     // $146
			PC.MCToolCompOnRapidApproach = false;           // $147

			PC.CoolantOff = "";					// $150
			PC.CoolantMist = "";				// $151
			PC.CoolantFlood = "";				// $152
			PC.CoolantThroughTool = "";			// $153

			PC.ModalText = "G0 G1 G2 G3";       // $500
			PC.ModalAbsoluteValues = "X Y Z F"; // $502
			PC.ModalIncrementalValues = "";     // $504

			PC.NeedPlusSigns = false;           // $510
			PC.DecimalSeparator = AcamPostDecimalSeparator.acamPostDecimalSeparatorPOINT;    // $515
			PC.SubroutinesAtEnd = true;         // $520
			PC.LimitArcs = AcamPostLimitArcs.acamPostLimitArcs180;    // $525 & 526
			PC.HelicalArcsAsLines = false;      // $527
			PC.PlanarArcsAsLines = AcamPostPlanarArcsAsLines.acamPostPlanarArcsAsLinesALL_EXCEPT_XY_OR_YZ_OR_XZ;   // $530
			PC.MaximumArcRadius = 0;		    // $531
			PC.ArcChordTolerance = 0.1;         // $532
			PC.SuppressComments = true;         // $540
			PC.FiveAxisProgramPivot = false;    // $560
			PC.FiveAxisOffsetFromPivotPointX = 0;   // $562
			PC.FiveAxisOffsetFromPivotPointY = 0;   // $563
			PC.FiveAxisToolHolderLength = 0;    // $565
			PC.FiveAxisToolMaxAngle = 110;      // $570
			PC.FiveAxisToolMaxAngleChange = 2;  // $575
			PC.HorizontalMCCentre = true;       // $580
			PC.SelectWpToolOrder = AcamPostSelectWpToolOrder.acamPostSelectWpToolOrderTOOL_FIRST; // $582
			PC.LocalXorYAxis = AcamPostLocalXorYAxis.acamPostLocalXorYAxisNONE; // $584
			PC.AllowManagedRapids = true;         // $587

			// SubroutineNumberFormat $700, 701 & 702
			PostFormat pf = PC.SubroutineNumberFormat;
			pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
			pf.LeadingFigures = 0;
			pf.FiguresAfterPoint = 0;
			Marshal.ReleaseComObject(pf);

			PC.SubroutineStartNumber = 1;		// $705

			// LineNumberFormat $710, 711 & 712
			pf = PC.LineNumberFormat;
			pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
			pf.LeadingFigures = 0;
			pf.FiguresAfterPoint = 0;
			Marshal.ReleaseComObject(pf);

			PC.LineStartNumber = 10;			// $715
			PC.LineNumberIncrement = 10;		// $716

			// XYZNumberFormat $720, 721 & 722
			pf = PC.XYZNumberFormat;
			pf.Format = AcamPostNumberFormat.acamPostNumberFormat2DECIMAL_NO_0;
			pf.LeadingFigures = 0;
			pf.FiguresAfterPoint = 3;
			Marshal.ReleaseComObject(pf);

			// ArcCentreNumberFormat $730, 731 & 732
			pf = PC.ArcCentreNumberFormat;
			pf.Format = AcamPostNumberFormat.acamPostNumberFormat2DECIMAL_NO_0;
			pf.LeadingFigures = 0;
			pf.FiguresAfterPoint = 3;
			Marshal.ReleaseComObject(pf);

			// SpindleSpeedNumberFormat $740, 741 & 742
			pf = PC.SpindleSpeedNumberFormat;
			pf.Format = AcamPostNumberFormat.acamPostNumberFormat10DECIMAL_LEAD_AND_TRAIL;
			pf.LeadingFigures = 0;
			pf.FiguresAfterPoint = 0;
			Marshal.ReleaseComObject(pf);

			PC.SpindleSpeedMax = 24000;			// $743
			PC.SpindleSpeedRound = 10;			// $745

			// FeedNumberFormat $750, 751 & 752
			pf = PC.FeedNumberFormat;
			pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
			pf.LeadingFigures = 0;
			pf.FiguresAfterPoint = 0;
			Marshal.ReleaseComObject(pf);

			PC.FeedMax = 40000;					// $753
			PC.FeedRound = 10;					// $755

			// ToolNumberFormat $760, 761 & 762
			pf = PC.ToolNumberFormat;
			pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
			pf.LeadingFigures = 0;
			pf.FiguresAfterPoint = 0;
			Marshal.ReleaseComObject(pf);

			PC.RapidXYSpeed = 20000;			// $900
			PC.RapidZSpeed = 20000;				// $901
			PC.ToolChangeTime = 10;				// $902

			// Create user variables here

			// Create an integer, double and string variables for illustration purposes
			PostUserVariable UserVar = PC.AddUserVariable();
			UserVar.Name = "MY_INTEGER";
			PostFormat postFormat = UserVar.Format;
			postFormat.Format = AcamPostNumberFormat.acamPostNumberFormat7INTEGER_LEAD_0;
			// Clean up objects
			Marshal.ReleaseComObject(postFormat);
			Marshal.ReleaseComObject(UserVar);
			
			UserVar = PC.AddUserVariable();
			UserVar.Name = "MY_DOUBLE";
			postFormat = UserVar.Format;
			postFormat.Format = AcamPostNumberFormat.acamPostNumberFormat1DECIMAL_WITH_0;
			postFormat.LeadingFigures = 0;
			postFormat.FiguresAfterPoint = 6;
			// Clean up objects
			Marshal.ReleaseComObject(postFormat);
			Marshal.ReleaseComObject(UserVar);

			UserVar = PC.AddUserVariable();
			UserVar.Name = "MY_STRING";
			postFormat = UserVar.Format;
			postFormat.Format = AcamPostNumberFormat.acamPostNumberFormatTEXT;
			// Clean up objects
			Marshal.ReleaseComObject(postFormat);
			Marshal.ReleaseComObject(UserVar);

			// More example user variables
			PostUserVariable UV = PC.AddUserVariable();
			UV.Name = "PROGNUM";
			pf = UV.Format;
			pf.Format = AcamPostNumberFormat.acamPostNumberFormat7INTEGER_LEAD_0;
			pf.LeadingFigures = 4;
			Marshal.ReleaseComObject(pf);
			UV.Prompt = "Enter Program Number";
			UV.Text = "1234";
			Marshal.ReleaseComObject(UV);

			UV = PC.AddUserVariable();
			UV.Name = "PANEL_X";
			pf = UV.Format;
			pf.Format = AcamPostNumberFormat.acamPostNumberFormat2DECIMAL_NO_0;
			pf.LeadingFigures = 0;
			Marshal.ReleaseComObject(pf);
			UV.Format.FiguresAfterPoint = 3;
			Marshal.ReleaseComObject(UV);

			UV = PC.AddUserVariable();
			UV.Name = "PANEL_Y";
			pf = UV.Format;
			pf.Format = AcamPostNumberFormat.acamPostNumberFormat2DECIMAL_NO_0;
			pf.LeadingFigures = 0;
			Marshal.ReleaseComObject(pf);
			UV.Format.FiguresAfterPoint = 3;
			Marshal.ReleaseComObject(UV);

			UV = PC.AddUserVariable();
			UV.Name = "PANEL_Z";
			pf = UV.Format;
			pf.Format = AcamPostNumberFormat.acamPostNumberFormat2DECIMAL_NO_0;
			pf.LeadingFigures = 0;
			Marshal.ReleaseComObject(pf);
			UV.Format.FiguresAfterPoint = 3;
			Marshal.ReleaseComObject(UV);

			// $3000
			PC.SetAttributeIndex(101, "LicomUKDMB3DAxisType");
			PC.SetAttributeIndex(102, "LicomUKDMB3DAction");
			PC.SetAttributeIndex(103, "LicomUKDMB3DMethod");
			PC.SetAttributeIndex(104, "LicomUKDMB3DProject");
		}
		
		void FilterFunction(string Buffer, EventDataText Data)
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
	}
}
