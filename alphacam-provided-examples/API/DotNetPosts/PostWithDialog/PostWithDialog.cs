using System;
using System.Runtime.InteropServices;
using AlphaCAMMill;
using System.Windows.Forms;
using FileIO = System.IO;

namespace PostWithDialog
{
    public class AlphacamPostEvents
    {
        IAlphaCamApp Acam;
        AddInPostInterfaceClass PostInterface;

		string gstrPostName = string.Empty;
		bool blnExitPost = false;
		bool blnToolChange;
		bool blnNesting;

		// Dialog values
		string Description = string.Empty;
		string Revision = string.Empty;
		string Material = string.Empty;
		string Programmer = string.Empty;

		const double dblArcError = 0.08;
		double dblPeck;

        public AlphacamPostEvents(IAlphaCamApp Acam)
        {
            this.Acam = Acam;

			if (Acam.ProgramLetter != 'R')
			{
				MessageBox.Show("This post is intended for Router only");
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

        // Implementations of all the Post methods that will be called by ALPHACAM when outputting NC
        void BeforeOutputNc(EventDataFileName Data)
        {
            // Called before ALPHACAM shows save NC file dialog box

            // Set Data.ReturnCode to one of these values:
            // 0 if ALPHACAM should show normal the dialog box
            // 1 to supply a filename and write the filename to Data.FileName
            // 2 to cancel output

            //MessageBox.Show("BeforeOutputNc");

			Data.ReturnCode = 0;
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
            Data.ReturnCode = 0;
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

            Data.ReturnCode = 0;
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
			using(frmSettings settingsDialog = new frmSettings())
			{
				// Populate variables on the form with current values
				settingsDialog.Description = Description;
				settingsDialog.Revision = Revision;
                settingsDialog.Material = Material;
                settingsDialog.Programmer = Programmer;

				// Show the form using the ShowDialog() method so that it is displayed modally
                DialogResult dialogResult = settingsDialog.ShowDialog();

                // Check the result from the form
                // The OK button is set to retrurn DialogResult.OK
                // The Cancel button will return DialogResult.Cancel
                if (dialogResult == DialogResult.OK)
				{
					// Set the module level variables with the values from the form
					Description = settingsDialog.Description;
					Revision = settingsDialog.Revision;
					Material = settingsDialog.Material;
					Programmer = settingsDialog.Programmer;

					blnExitPost = false;
				}
				else
				{
                    // Either Cancel was pressed or the form was closed using the X
                    // Set a flag so that the post exits in OutputFileLeadingLines
                    blnExitPost = true;
                }
            }
		}

		void BeforePostSimulation()
		{
			//MessageBox.Show("BeforePostSimulation");
		}
		void OutputFileLeadingLines(PostData PD)
		{
			// Test to see if the post needs to exit (in this case if the user has pressed Cancel on the dialog)
			if(blnExitPost)
			{
				// Display a message and exit
                PD.Post("Dialog cancelled - post will exit");
                PD.Post("$EXIT");
				return;
            }

            gstrPostName = Acam.PostFileName;

			gstrPostName = FileIO.Path.GetFileNameWithoutExtension(gstrPostName);

			Drawing drw = Acam.ActiveDrawing;

			//'*~* Start; Find Highest Z in Drawing
			double x1, y1, z1, x2, y2, z2;

			drw.GetExtent(out x1, out y1, out z1, out x2, out y2, out z2);
			PD.UserVariable["MAX_Z"] = z2;
			//'*~* End; Find Highest Z in Drawing

			bool exit = false;

			//'*~* Start; Post Processor Does Not Support Subroutines, Warn & Exit
			Paths toolpaths = drw.ToolPaths;
			Path tp = null;

			int tpCount = drw.GetToolPathCount(); 
			for (int i = 1; i <= tpCount; i++)
			{
				tp = toolpaths.Item(i);
				if(tp.IsSubroutineCopy)
				{
					MessageBox.Show("WARNING: Use linear code, not subroutines", gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
					exit = true;
                    Marshal.ReleaseComObject(tp);
                    break;
				}

                Marshal.ReleaseComObject(tp);
            }
            //'*~* End; Post Processor Does Not Support Subroutines, Warn & Exit

            // It is important to release any COM variable used, otherwise memory leaks will occur
            Marshal.ReleaseComObject(toolpaths);
            Marshal.ReleaseComObject(drw);

            if (exit)
			{
				PD.Post("$EXIT");
			}
			else
			{
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

        }
        void OutputProgramLeadingLines(PostData PD)
		{
			PD.UserVariable["DESCRIPTION"] = Description.ToUpper();
            PD.UserVariable["REVISION"] = Revision;
            PD.UserVariable["MATERIAL"] = Material.ToUpper();
            PD.UserVariable["PROGRAMMER"] = Programmer.ToUpper();

			PD.Post("([DESCRIPTION])");
			PD.Post("(REV: [REVISION])");
			PD.Post("(MATERIAL: [MATERIAL])");
			PD.Post("(PROGRAMMER: [PROGRAMMER])");
			PD.Post("(DATE: " + DateTime.Now.ToShortDateString() + ")");
			PD.Post("(TIME: " + DateTime.Now.ToShortTimeString() + ")");


            // Because IPostVariables is a COM object, this should be stored in a variable so that
            // it can be released when it is no longer needed
            IPostVariables postVariables = PD.Vars;

			if (blnNesting)
			{
				if(postVariables.SHN == 1)
					PD.Post("G17 G21 G40 G90");
			}
			else
				PD.Post("G17 G21 G40 G90");

            // Release the postVariables COM object
            Marshal.ReleaseComObject(postVariables);
        }
        void OutputProgramTrailingLines(PostData PD)
		{
			PD.Post("G0 X3050.000 Y500.000");
			PD.Post("M5");
			PD.Post("M9");

			if (blnNesting)
			{
                // Because IPostVariables is a COM object, this should be stored in a variable so that
                // it can be released when it is no longer needed
                IPostVariables postVariables = PD.Vars;

                if (postVariables.SHN == postVariables.NSH)
					PD.Post("M30");
				else
					PD.Post("M00");

                // Release the postVariables COM object
                Marshal.ReleaseComObject(postVariables);
            }
            else
				PD.Post("M30");
        }
        void OutputFileTrailingLines(PostData PD)
		{
		}
		void OutputRapid(PostData PD)
		{
			// Get Rapid Type
			AcamPostRapidType rapidType = PD.RapidType;

			if (rapidType == AcamPostRapidType.acamPostRapidTypeXY  || rapidType == AcamPostRapidType.acamPostRapidTypeXYZ )
			{
				if (blnToolChange)
				{
					blnToolChange = false;

					PD.Post("M[ROT] S[S]");
					PD.Post("G0 X[GAX] Y[GAY]");
					PD.Post("G0 Z[GAZ]");
				}
				else
				{
					if (rapidType == AcamPostRapidType.acamPostRapidTypeXY)
						PD.Post("G0 X[GAX] Y[GAY]");
					else						
						PD.Post("G0 X[GAX] Y[GAY] Z[GAZ]"); // XYZ Rapid
                }
            }
            else
			{
				// Z-Rapid
				if (!blnToolChange)
					PD.Post("G0 Z[GAZ]");
			}
		}
		void OutputFeed(PostData PD)
		{
			// Get feed type and the Post Variables
			AcamPostFeedType feedType = PD.FeedType;
			IPostVariables postVariables = PD.Vars;

			if (postVariables.MC == 1)
			{
				string message = "WARNING: Cutter Compensation Not Supported on Machine, Use APS Tool Centre.";

				MessageBox.Show(message, gstrPostName, MessageBoxButtons.OK, MessageBoxIcon.Exclamation);

				PD.Post("$EXIT");
				return;
			}


			if (feedType == AcamPostFeedType.acamPostFeedTypeLINE)
			{
				// linear
				if (postVariables.MC + postVariables.In + postVariables.Out == 2)
					PD.Post("G1 G[TC] X[GAX] Y[GAY] Z[GAZ] F[F]");
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

				if (Math.Sqrt(postVariables.GIX * postVariables.GIX + postVariables.GIY * postVariables.GIY) < dblArcError)
					PD.Post("G1 X[GAX] Y[GAY] Z[GAZ] F[F]");
				else
				{
					PD.ModalOff("X,Y");
					PD.Post("[G_ARC] X[GAX] Y[GAY] Z[GAZ] R[R] F[F]");
				}
			}

            // Release the Variables COM Object
            Marshal.ReleaseComObject(postVariables);
		}

		void OutputCancelTool(PostData PD)
		{
			PD.Post("G0 Z[MAX_Z+20]");
        }

        void OutputSelectTool(PostData PD)
		{
			PD.Post("([TNM])");
			PD.Post("M6T[T]");
			PD.Post("M[CLT]");

			blnToolChange = true;
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
            IPostVariables postVariables = PD.Vars;
            bool rapidAtRPlane = PD.DrillRapidAtRPlane;

			switch(drillType)
			{
				case AcamPostDrillType.acamPostDrillTypeDRILL:

                    if(!rapidAtRPlane)
					{
						// ZS Level
						PD.Post("G0 Z[ZR+GLZ]");
						PD.Post("G1 Z[ZB+GLZ] F[F]");
						PD.Post("G0 Z[ZS+GLZ]");
                    }
                    else
					{
						// ZR Level
						PD.Post("G0 Z[ZR+GLZ]");
						PD.Post("G1 Z[ZB+GLZ] F[F]");
						PD.Post("G0 Z[ZR+GLZ]");
                    }

                    break;
				
				case AcamPostDrillType.acamPostDrillTypePECK:

					if (!rapidAtRPlane)
					{
						// ZS Level
						PD.Post("G0 Z[ZR+GLZ]");

						double dblPeck = postVariables.ZM - postVariables.ZP;

						do
						{
							PD.UserVariable["PECK"] = dblPeck;
							PD.Post("G1 Z[PECK+GLZ] F[F]");
							PD.Post("G0 Z[ZR+GLZ]");
							PD.Post("G0 Z[PECK+CLEAR_DEPTH]");

							dblPeck -= postVariables.ZP;

						} while (dblPeck > postVariables.ZB);

						PD.Post("G1 Z[ZB+GLZ] F[F]");
						PD.Post("G0 Z[ZS+GLZ]");
					}
					else
					{
						// ZR Level
						PD.Post("G0 Z[ZR+GLZ]");

						dblPeck = postVariables.ZM - postVariables.ZP;

						do
						{
							PD.UserVariable["PECK"] = dblPeck;
							PD.Post("G1 Z[PECK+GLZ] F[F]");
							PD.Post("G0 Z[ZR+GLZ]");
							PD.Post("G0 Z[PECK+CLEAR_DEPTH]");

							dblPeck -= postVariables.ZP;

						} while (dblPeck > postVariables.ZB);


						PD.Post("G1 Z[ZB+GLZ] F[F]");
						PD.Post("G0 Z[ZR+GLZ]");
					}

                    break;
			}
		}
		void OutputDrillCycleNextHoles(PostData PD)
		{
            PD.Post("G0 X[GAX] Y[GAY]");

			OutputDrillCycleFirstHole(PD);
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
			PC.CWSpindleRotation = "3"; // $75
			PC.CCWSpindleRotation = "4"; // $76
			PC.MCToolCompCancel = "40"; // $140
			PC.MCToolCompLeft = "41"; // $141
			PC.MCToolCompRight = "42"; // $142
			PC.MCToolCompBlendPercent = 0; // $145
			PC.MCToolCompOnRapidApproach = false; // $146
			PC.MCToolComp5Axis = false; // $148
			PC.CoolantOff = "9"; // $150
			PC.CoolantMist = "7"; // $151
			PC.CoolantFlood = "7"; // $152
			PC.CoolantThroughTool = "7"; // $153
			PC.ModalText = "G0 G1 G2 G3"; // $500
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
			pf.Format = AcamPostNumberFormat.acamPostNumberFormat10DECIMAL_LEAD_AND_TRAIL;
			pf.LeadingFigures = 0;
			pf.FiguresAfterPoint = 3;
            Marshal.ReleaseComObject(pf);

			// ArcCentreNumberFormat  $730, 731 & 732
			pf = PC.ArcCentreNumberFormat;
			pf.Format = AcamPostNumberFormat.acamPostNumberFormat10DECIMAL_LEAD_AND_TRAIL;
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

			// Create user variables
			PostUserVariable UV = PC.AddUserVariable();
			UV.Name = "G_ARC";
			pf = UV.Format;
			pf.Format = AcamPostNumberFormat.acamPostNumberFormatTEXT;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
			UV.Name = "PECK";
            pf = UV.Format;
			pf.Format = AcamPostNumberFormat.acamPostNumberFormat10DECIMAL_LEAD_AND_TRAIL;
			pf.FiguresAfterPoint = 3;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
			UV.Name = "CLEAR_DEPTH";
            pf = UV.Format;
			pf.Format = AcamPostNumberFormat.acamPostNumberFormat10DECIMAL_LEAD_AND_TRAIL;
			pf.FiguresAfterPoint = 3;
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
			pf.Format = AcamPostNumberFormat.acamPostNumberFormat10DECIMAL_LEAD_AND_TRAIL;
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
			pf.Format = AcamPostNumberFormat.acamPostNumberFormat10DECIMAL_LEAD_AND_TRAIL;
			pf.FiguresAfterPoint = 3;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);

            UV = PC.AddUserVariable();
            UV.Name = "PARK_Y";
            pf = UV.Format;
            pf.Format = AcamPostNumberFormat.acamPostNumberFormat10DECIMAL_LEAD_AND_TRAIL;
            pf.FiguresAfterPoint = 3;
            Marshal.ReleaseComObject(pf);
            Marshal.ReleaseComObject(UV);            
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
