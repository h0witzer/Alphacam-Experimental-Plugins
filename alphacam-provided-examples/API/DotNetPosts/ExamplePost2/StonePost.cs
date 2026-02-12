using AlphaCAMMill;
using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.TaskbarClock;
using MathUtils;

class StonePost : Post
{
	IAlphaCamApp Acam;
	bool bOutputStop = false;
    bool bFullRetract = false;
	bool bToolChange = false;
	bool bFromRapid = false;
	string PostName = "ExamplePost2 - Stone";
	const double ArcError = 0.08;
	const int intDecP = 3;

	public StonePost(IAlphaCamApp Acam)
	{
		this.Acam = Acam;
	}
	public override void BeforeCreateNc()
	{

	}
	public override void OutputFileLeadingLines(IPostData PD)
	{
		PD.UserVariable["CLEAR_DEPTH"] = 2;
		PD.UserVariable["RAPID_FEED"] = 2000;
    
		PD.Post(";C# ExamplePost2 - Stone");

		bOutputStop = false;
		bFullRetract = false;
	}
	public override void OutputProgramLeadingLines(IPostData PD)
	{
		PD.Post("%_N_[FNM]_SPF");
		PD.Post(";$PATH=/_N_SPF_DIR");

		IDrawing Drw = Acam.ActiveDrawing;
		PD.Post(";Alphacam Drawing: " + Drw.Name);
		DateTime currentDate = DateTime.Now;
		
		PD.Post(";Date: " + currentDate.ToString("F"));
		PD.Post("SOFT");
		PD.Post("CFTCP");
		PD.Post("G54");
		PD.Post("G17");
		PD.Post("G90");
		PD.Post("G64");
		PD.Post("D0");
		PD.Post("G153 G0 Z0");
		PD.Post("MPEROF");
		
		Marshal.ReleaseComObject(Drw);
	}
	public override void OutputProgramTrailingLines(IPostData PD)
	{
		PD.ModalOff("Z");
		PD.Post("STOPRE");
		PD.Post("M09");
		PD.Post("M05");
		PD.Post("D0");
		PD.Post("G153 G0 Z0");
		PD.Post("G153 G0 X0 Y1500");
		PD.Post("M30");
	}
	public override void OutputFileTrailingLines(IPostData PD)
	{
	}
	public override void OutputRapid(IPostData PD)
	{
		if (bOutputStop)
		{
			bOutputStop = false;
			PD.Post("; *************************");
			PD.Post("M0 ;[OP_NOTE]");
			PD.Post("; *************************");
			PD.Post("[ROT] S[S]");
		}
    
		AcamPostRapidType type = PD.RapidType;

		if (bToolChange)
		{
			if (type != AcamPostRapidType.acamPostRapidTypeZ)
			{
	            bToolChange = false;
            
				PD.Post( "G0 X[GAX] Y[GAY]");
				PD.Post( "[ROT] [CLT]");
				PD.Post( "M13");
				PD.Post( "G0 Z[GAZ]");
			}            
        }
		else
		{
	        if (type == AcamPostRapidType.acamPostRapidTypeXY)
	            PD.Post("G0 X[GAX] Y[GAY]");
            else if (type == AcamPostRapidType.acamPostRapidTypeXYZ)
	            PD.Post("G0 X[GAX] Y[GAY] Z[GAZ]");
            else
                PD.Post("G0 Z[GAZ]");	// Z Rapid
            
        }
        
		bFromRapid = true;
    }
    
	public override void OutputFeed(IPostData PD)
	{
		if (bFromRapid)
		{
	        bFromRapid = false;
			PD.ModalOff("F");
		}
		else
		{
	        PD.ModalOn("F");
		}
        
		IPostVariables V = PD.Vars;

		if (PD.FeedType == AcamPostFeedType.acamPostFeedTypeLINE)
		{
	        if (V.MC == 1.0 && (V.In == 1.0 || V.Out == 1))
	            PD.Post("G1 [TC] X[GAX] Y[GAY] Z[GAZ] F[F]");
            else
				PD.Post("G1 X[GAX] Y[GAY] Z[GAZ] F[F]");
		}            
		else
		{
	        if (V.MC == 1.0 && (V.In == 1.0 || V.Out == 1.0) && (V.FF == 1.0 || V.LF == 1.0))
			{
	            string strMsg = "WARNING: Cannot Apply/Remove G41/42 Compensation on an Arc Only Lead In/Out.\nCheck OPD." + PD.Vars.OPN;
				MessageBox.Show(strMsg, PostName);
				PD.Post("$EXIT");
				return;
			}
        
			double AIA = Utils.Rounding(V.AIA, intDecP);

			if (Math.Sqrt(V.GIX * V.GIX + V.GIY * V.GIY) < ArcError && AIA != 360.0)
			{
	            PD.Post("G1 X[GAX] Y[GAY] Z[GAZ] F[F]");
			}
			else
			{
				PD.ModalOff("X,Y");
				PD.UserVariable["G_ARC"] = PD.FeedType == AcamPostFeedType.acamPostFeedTypeCWARC ? "G2" : "G3";
				PD.Post("[G_ARC] X[GAX] Y[GAY] Z[GAZ] I[GII] J[GIJ] F[F]");
			}
		}

		Marshal.ReleaseComObject(V);
	}
	public override void OutputCancelTool(IPostData PD)
	{
		PD.Post("MPEROF");

		IPostVariables V = PD.Vars;

        if (V.NT == 0)
		{
		}
		else if (bOutputStop)
		{
			bOutputStop = false;
			PD.Post("; *************************");
			PD.Post("M0 ;[OP_NOTE]");
			PD.Post("; *************************");
		}
		else
		{
	        PD.Post("M1");
		}

		Marshal.ReleaseComObject(V);
	}
	public override void OutputSelectTool(IPostData PD)
	{
		PD.Post("T[T] ; [TNM]");
		PD.Post("TOOL");
		PD.Post("D[OFS]");
		PD.Post("CHKTOOL");
		PD.Post("MPERON");
		PD.Post("S[S]");
    
		bToolChange = true;
	}
	public override void OutputSelectWorkPlane(IPostData PD)
	{
	}
	public override void OutputSelectToolAndWorkPlane(IPostData PD)
	{
	}
	public override void OutputCallSub(IPostData PD)
	{
	}
	public override void OutputBeginSub(IPostData PD)
	{
	}
	public override void OutputEndSub(IPostData PD)
	{
	}
	public override void OutputOriginShift(IPostData PD)
	{
	}
	public override void OutputCancelOriginShift(IPostData PD)
	{
	}
	public override void OutputStop(IPostData PD)
	{
		bOutputStop = true;
		PostArrayVariables AV = PD.ArrayVars;
    
		if (Convert.ToInt32(AV.PAT[1]) == 0 || Convert.ToString(AV.PAT[1]) == "")
			PD.UserVariable["OP_NOTE"] = "PROGRAM STOP";
        else
			PD.UserVariable["OP_NOTE"] = AV.PAT[1];

		Marshal.ReleaseComObject(AV);
	}
	public override void OutputDrillCycleCancel(IPostData PD)
	{
	}
	public override void OutputFirstHoleSub(IPostData PD)
	{
	}
	public override void OutputNextHoleSub(IPostData PD)
	{
	}
	public override void OutputDrillCycleFirstHole(IPostData PD)
	{
		if (bOutputStop)
		{
	        bOutputStop = false;
			PD.Post("; *************************");
			PD.Post("M0 ;[OP_NOTE]");
			PD.Post("; *************************");
			PD.Post("[ROT] S[S]");
		}
    
	    PD.ModalOff("F");
    
		AcamPostDrillType type = PD.DrillType;
		bool bRPlane = PD.DrillRapidAtRPlane;

		if (type == AcamPostDrillType.acamPostDrillTypeDRILL)
		{
			if (!bRPlane)
			{
				PD.Post("G0 Z[ZR+GLZ]");
				PD.Post("G1 Z[ZB+GLZ] F[F]");
				PD.Post("G0 Z[ZS+GLZ]");
			}
			else
			{
				PD.Post("G0 Z[ZR+GLZ]");
				PD.Post("G1 Z[ZB+GLZ] F[F]");
				PD.Post("G0 Z[ZR+GLZ]");
			}
		}
        else if (type == AcamPostDrillType.acamPostDrillTypePECK)
		{
			PostVariables V = PD.Vars;
			PostArrayVariables AV = PD.ArrayVars;

			// user sets operation note 1 to determine full retract or not
			bFullRetract = Convert.ToInt32(AV.PAT[2]) == 1 ? true : false;
        
			if (!bRPlane)
			{
	            PD.Post("G0 Z[ZR+GLZ]");
                double dblPeck = V.ZM - V.ZP;
            
				PD.ModalOff("F");
            
				do
				{
	                PD.UserVariable["PECK"] = dblPeck;
	                PD.Post("G1 Z[PECK+GLZ] F[F]");
					PD.ModalOn("F");
                
					if (bFullRetract)
					{
	                    PD.Post("G0 Z[ZR+GLZ]");
		                PD.Post("G1 Z[PECK+GLZ+CLEAR_DEPTH] F[RAPID_FEED]");
					}
					else
					{
						// partial retract
						PD.Post("G1 Z[PECK+GLZ+CLEAR_DEPTH] F[RAPID_FEED]");
					}
                
					dblPeck -= V.ZP;
				} while (dblPeck > V.ZB);
            
				PD.Post("G1 Z[ZB+GLZ] F[F]");
				PD.Post("G0 Z[ZS+GLZ]");
			}
			else
			{
				// ZR Level
	            PD.Post("G0 Z[ZR+GLZ]");
            
				double dblPeck = V.ZM - V.ZP;
                PD.ModalOff("F");
            
				do
				{
	                PD.UserVariable["PECK"] = dblPeck;
	                PD.Post("G1 Z[PECK+GLZ] F[F]");
                    PD.ModalOn("F");
                
					if (bFullRetract)
					{
	                    PD.Post("G0 Z[ZR+GLZ]");
		                PD.Post("G1 Z[PECK+GLZ+CLEAR_DEPTH] F[RAPID_FEED]");
					}
					else
					{
	                    // partial retract
						PD.Post("G1 Z[PECK+GLZ+CLEAR_DEPTH] F[RAPID_FEED]");
					}
                
					dblPeck -= V.ZP;
				} while (dblPeck > V.ZB);
            
	            PD.Post("G1 Z[ZB+GLZ] F[F]");
		        PD.Post("G0 Z[ZR+GLZ]");
            }

			Marshal.ReleaseComObject(AV);
			Marshal.ReleaseComObject(V);
		}
	}
	public override void OutputDrillCycleNextHoles(IPostData PD)
	{
		PD.ModalOn("F");

		AcamPostDrillType type = PD.DrillType;
		bool bRPlane = PD.DrillRapidAtRPlane;

		if (type == AcamPostDrillType.acamPostDrillTypeDRILL)
		{
		    if (!bRPlane)
			{
				PD.Post("G0 X[GAX] Y[GAY]");
				PD.Post("G0 Z[ZR+GLZ]");
				PD.Post("G1 Z[ZB+GLZ] F[F]");
				PD.Post("G0 Z[ZS+GLZ]");
			}
			else
			{
				PD.Post("G0 X[GAX] Y[GAY]");
				PD.Post("G1 Z[ZB+GLZ] F[F]");
				PD.Post("G0 Z[ZR+GLZ]");
			}
		}     
		else if (type == AcamPostDrillType.acamPostDrillTypePECK)
		{
			PostVariables V = PD.Vars;

	        if (!bRPlane)
			{
	            PD.Post("G0 X[GAX] Y[GAY]");
		        PD.Post("G0 Z[ZR+GLZ]");
	            double dblPeck = V.ZM - V.ZP;
	            PD.ModalOff("F");
            
				do
				{
	                PD.UserVariable["PECK"] = dblPeck;
	                PD.Post("G1 Z[PECK+GLZ] F[F]");
					PD.ModalOn("F");
                
					if (bFullRetract)
						PD.Post("G1 Z[ZR+GLZ] F[RAPID_FEED]");
					else
						PD.Post("G1 Z[PECK+GLZ+CLEAR_DEPTH] F[RAPID_FEED]");
                
					dblPeck -= V.ZP;
				} while (dblPeck > V.ZB);
            
				PD.Post("G1 Z[ZB+GLZ] F[F]");
				PD.Post("G0 Z[ZS+GLZ]");
			}
			else
			{
	            // ZR Level
	            PD.Post("G0 X[GAX] Y[GAY]");
                double dblPeck = V.ZM - V.ZP;
	            PD.ModalOff("F");
            
				do
				{
	                PD.UserVariable["PECK"] = dblPeck;
	                PD.Post("G1 Z[PECK+GLZ] F[F]");
	                PD.ModalOn("F");
                
	                if (bFullRetract)
	                    PD.Post("G1 Z[ZR+GLZ] F[RAPID_FEED]");
                    else
	                    PD.Post("G1 Z[PECK+GLZ+CLEAR_DEPTH] F[RAPID_FEED]");
                
	                dblPeck -= V.ZP;
				} while (dblPeck > V.ZB);
            
	            PD.Post("G1 Z[ZB+GLZ] F[F]");
		        PD.Post("G0 Z[ZR+GLZ]");
			}

			Marshal.ReleaseComObject(V);
		}
	}
	
	public override void AfterOpenPost(IPostConfigure PC)
	{
		PC.CWSpindleRotation = "M3"; // $75
		PC.CCWSpindleRotation = "M4"; // $76
		PC.MCToolCompCancel = "G40"; // $140
		PC.MCToolCompLeft = "G41"; // $141
		PC.MCToolCompRight = "G42"; // $142
		PC.MCToolCompBlendPercent = 10;	// $145
		PC.MCToolCompAdjustInternalCorners = false; // $156
		PC.MCToolCompOnRapidApproach = false;   // $147

		PC.CoolantOff = ""; // $150
		PC.CoolantMist = "M7"; // $151
		PC.CoolantFlood = "M7"; // $152
		PC.CoolantThroughTool = "M7"; // $153

		PC.ModalText = "G0 G1"; // $500
		PC.ModalAbsoluteValues = "X Y Z F"; // $502
		PC.ModalIncrementalValues = ""; // $504

		PC.NeedPlusSigns = false; // $510
		PC.DecimalSeparator = AcamPostDecimalSeparator.acamPostDecimalSeparatorPOINT; // $515
		PC.SubroutinesAtEnd = true; // $520
		PC.LimitArcs = AcamPostLimitArcs.acamPostLimitArcsNONE; // $525, 526
		PC.HelicalArcsAsLines = false; // $527
		PC.PlanarArcsAsLines = AcamPostPlanarArcsAsLines.acamPostPlanarArcsAsLinesNONE; // $530
		PC.MaximumArcRadius = 0; // $531
		PC.ArcChordTolerance = 0.08; // $532
		PC.SuppressComments = true; // $540

		PC.FiveAxisProgramPivot = false; // $560
		PC.FiveAxisOffsetFromPivotPointX = 0; // $562
		PC.FiveAxisOffsetFromPivotPointY = 0; // $563
		PC.FiveAxisToolHolderLength = 0; // $565
		PC.FiveAxisToolMaxAngle = 0; // $570
		PC.FiveAxisToolMaxAngleChange = 0; // $575

		PC.HorizontalMCCentre = false; // $580
		PC.SelectWpToolOrder = AcamPostSelectWpToolOrder.acamPostSelectWpToolOrderTOOL_FIRST; // $582
		PC.LocalXorYAxis = AcamPostLocalXorYAxis.acamPostLocalXorYAxisNONE; // $584

		// SubroutineNumberFormat $700, 701 & 702
		PostFormat pf = PC.SubroutineNumberFormat;
		pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
		pf.LeadingFigures = 0;
		pf.FiguresAfterPoint = 0;
		Marshal.ReleaseComObject(pf);
		PC.SubroutineStartNumber = 1;   // $705

		// LineNumberFormat $710, 711 & 712
		pf = PC.LineNumberFormat;
		pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
		pf.LeadingFigures = 0;
		pf.FiguresAfterPoint = 0;
		Marshal.ReleaseComObject(pf);
		PC.LineStartNumber = 5;     // $715
		PC.LineNumberIncrement = 5; // $716

		// XYZNumberFormat $720, 721 & 722
		pf = PC.XYZNumberFormat;
		pf.Format = AcamPostNumberFormat.acamPostNumberFormat3DECIMAL_NO_0_OR_POINT;
		pf.LeadingFigures = 0;
		pf.FiguresAfterPoint = 3;
		Marshal.ReleaseComObject(pf);

		// ArcCentreNumberFormat $730, 731 & 732
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
		PC.SpindleSpeedRound = 0;   // $745

		// FeedNumberFormat $750, 751 & 752
		pf = PC.FeedNumberFormat;
		pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
		pf.LeadingFigures = 0;
		pf.FiguresAfterPoint = 0;
		Marshal.ReleaseComObject(pf);
		PC.FeedMax = 30000; // $753
		PC.FeedRound = 10;   // $755

		// ToolNumberFormat $760, 761 & 762
		pf = PC.ToolNumberFormat;
		pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
		pf.LeadingFigures = 0;
		pf.FiguresAfterPoint = 0;
		Marshal.ReleaseComObject(pf);

		PC.RapidXYSpeed = 20000;    // $900
		PC.RapidZSpeed = 20000;     // $901
		PC.ToolChangeTime = 10;      // $902

		IPostUserVariable UV = PC.AddUserVariable();
		UV.Name = "G_ARC";
		IPostFormat PF = UV.Format;
		PF.Format = AcamPostNumberFormat.acamPostNumberFormatTEXT;
		Marshal.ReleaseComObject(PF);
		Marshal.ReleaseComObject(UV);

		UV = PC.AddUserVariable();
		UV.Name = "PECK";
		PF = UV.Format;
		PF.Format = AcamPostNumberFormat.acamPostNumberFormat3DECIMAL_NO_0_OR_POINT;
		PF.FiguresAfterPoint = 3;
		Marshal.ReleaseComObject(PF);
		Marshal.ReleaseComObject(UV);

		UV = PC.AddUserVariable();
		UV.Name = "CLEAR_DEPTH";
		PF = UV.Format;
		PF.Format = AcamPostNumberFormat.acamPostNumberFormat3DECIMAL_NO_0_OR_POINT;
		PF.FiguresAfterPoint = 3;
		Marshal.ReleaseComObject(PF);
		Marshal.ReleaseComObject(UV);

		UV = PC.AddUserVariable();
		UV.Name = "RAPID_FEED";
		PF = UV.Format;
		PF.Format = AcamPostNumberFormat.acamPostNumberFormat3DECIMAL_NO_0_OR_POINT;
		PF.FiguresAfterPoint = 3;
		Marshal.ReleaseComObject(PF);
		Marshal.ReleaseComObject(UV);

		UV = PC.AddUserVariable();
		UV.Name = "OP_NOTE";
		PF = UV.Format;
		PF.Format = AcamPostNumberFormat.acamPostNumberFormatTEXT;
		Marshal.ReleaseComObject(PF);
		Marshal.ReleaseComObject(UV);

		// $3000
        PC.SetAttributeIndex(1, "LicomUKDMBOperationNote");
        PC.SetAttributeIndex(2, "LicomUKDMBOperationNote01");
        
        PC.SetAttributeIndex(101, "LicomUKDMB3DAxisType");
        PC.SetAttributeIndex(102, "LicomUKDMB3DAction");
        PC.SetAttributeIndex(103, "LicomUKDMB3DMethod");
        PC.SetAttributeIndex(104, "LicomUKDMB3DProject");
	}
}