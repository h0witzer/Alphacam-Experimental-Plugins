using AlphaCAMMill;
using System;
using System.Runtime.InteropServices;
class LathePost : Post
{
	IAlphaCamApp Acam;
	bool FirstRapid;
	bool NoLineNumbers;
	double OldWP;
	//void ShowToolChangePos(IPostData PD);

	public LathePost(IAlphaCamApp Acam)
	{
		this.Acam = Acam;
		FirstRapid = true;
		NoLineNumbers = false;
	}
	public override void BeforeCreateNc()
	{

	}
	public override void OutputFileLeadingLines(IPostData PD)
	{
		PD.Post("'C# ExamplePost2 - Lathe");

		OldWP = 0.0;
		FirstRapid = true;

		// Get the Alphacam version
		IVersionInformation Ver = Acam.AlphacamVersion;
		PD.Post("'ALPHACAM Version: " + Ver.String);
		PD.Post("%");
		Marshal.ReleaseComObject(Ver);

		ShowToolChangePos(PD);
	}
	public override void OutputProgramLeadingLines(IPostData PD)
	{
		PostVariables V = PD.Vars;
		string date = V.DAT;
		date = date.Substring(0, 9);
		date = date.ToUpper();
		PD.Post("(PROGRAM PRODUCED  - " + date + ")");
		PD.Post(": [PROGNUM]");
		PD.Post("N[N] G21 G80 G40");
		PD.Post("N[N] G50 S[MS] M42");
	}
	public override void OutputProgramTrailingLines(IPostData PD)
	{
		PD.Post("N[N] M30");
	}
	public override void OutputFileTrailingLines(IPostData PD)
	{
		PD.Post("%");
	}
	// Rapid: 2 Axis Turning
	public override void OutputLatheRapid(IPostData PD)
	{
		IPostVariables V = PD.Vars;
		if (FirstRapid)
			FirstRapid = false;
		else if (V.FTC != 0.0)
			PD.Post("N[N] G0 X[AD] Z[AZ] [CLT]");
		else if (V.TTC != 0.0)
			PD.Post("N[N] G0 X[AD] Z[AZ] M09");
		else
			PD.Post("N[N] G0 X[AD] Z[AZ]");
		Marshal.ReleaseComObject(V);
	}
	// Rapid: C or Y Axis
	public override void OutputRapid(IPostData PD)
	{
		PD.Post("N[N] G1 X[AD] Z[AZ] C[AC] F4000");
	}
	// Feed: 2 Axis Turning
	public override void OutputLatheFeed(IPostData PD)
	{
		IPostVariables V = PD.Vars;
		switch (PD.FeedType)
		{
		case AcamPostFeedType.acamPostFeedTypeLINE:
			if (V.MC != 0.0 && V.In != 0.0)
				PD.Post("N[N] G1 [TC] X[AD] Z[AZ] F[F]");
			else if (V.MC != 0.0 && V.Out != 0.0)
				PD.Post("N[N] G1 [TC] X[AD] Z[AZ] F[F]");
			else
				PD.Post("N[N] G1 X[AD] Z[AZ] F[F]");
			break;

		case AcamPostFeedType.acamPostFeedTypeCWARC:
			PD.Post("N[N] G2 X[AD] Z[AZ] R[R] F[F]");
			break;

		case AcamPostFeedType.acamPostFeedTypeCCWARC:
			PD.Post("N[N] G3 X[AD] Z[AZ] R[R] F[F]");
			break;
		}
		Marshal.ReleaseComObject(V);
	}

	// C or Y Axis
	// CWP = Current Work Plane:
	// 0 = 2-AXIS Turning, 1 = XY, 2 = XZ, 3 = YZ, 4 = 3D, 5 = C-Ax Developed
	// pPD->MoveType = acamPostMoveTypeC for C-Axis, acamPostMoveTypeY for Y-Axis
	public override void OutputFeed(IPostData PD)
	{
		IPostVariables V = PD.Vars;

		// PD.Post("Tax: [TAX], [TAY], [TAZ]");
		if (PD.MoveType == AcamPostMoveType.acamPostMoveTypeC)
		{
			// C-Axis
			if (V.CWP != 5.0)
			{
				switch (PD.FeedType)
				{
				case AcamPostFeedType.acamPostFeedTypeLINE:
					if (V.MC != 0.0 && (V.In != 0.0 || V.Out != 0.0))
						PD.Post("N[N] G1 [TC] X[AX] C[AY] Z[AZ] F[F]");
					else
						PD.Post("N[N] G1 X[AX] C[AY] Z[AZ] F[F]");
					break;
				case AcamPostFeedType.acamPostFeedTypeCWARC:
					PD.Post("N[N] G2 X[AX] C[AY] Z[AZ] R[R] F[F]");
					break;
				case AcamPostFeedType.acamPostFeedTypeCCWARC:
					PD.Post("N[N] G3 X[AX] C[AY] Z[AZ] R[R] F[F]");
					break;
				}
			}
			else
			{
				// CWP == 5, C-Ax developed
				switch (PD.FeedType)
				{
				case AcamPostFeedType.acamPostFeedTypeLINE:
					if (V.MC != 0.0 && (V.In != 0.0 || V.Out != 0.0))	// M/C comp applies, and this is LEAD-In or Out LIne
						PD.Post("N[N] G1 [TC] X[AD] C[AC] Z[AZ] F[F]");
					else    // Applies to all other lInes (with APS or M/C comp).
						PD.Post("N[N] G1 X[AD] C[AC] Z[AZ] F[F]");
					break;
				case AcamPostFeedType.acamPostFeedTypeCWARC:
					PD.Post("N[N] G3 X[AD] C[AC] Z[AZ] R[R] F[F]");
					break;
				case AcamPostFeedType.acamPostFeedTypeCCWARC:
					PD.Post("N[N] G2 X[AD] C[AC] Z[AZ] R[R] F[F]");
					break;
				}
			}
		}
		else
		{
			// Y-Axis
			switch (PD.FeedType)
			{
			case AcamPostFeedType.acamPostFeedTypeLINE:
				if (V.MC != 0.0 && (V.In != 0.0 || V.Out != 0.0))
					PD.Post("N[N] G1 [TC] X[AX] Y[AY] Z[AZ] C[AC] F[F]");
				else
					PD.Post("N[N] G1 X[AX] Y[AY] Z[AZ] C[AC] F[F]");
			  break;
			case AcamPostFeedType.acamPostFeedTypeCWARC:
				PD.Post("N[N] G2 X[AX] Y[AY] Z[AZ] C[AC] R[R] F[F]");
				break;
			case AcamPostFeedType.acamPostFeedTypeCCWARC:
				PD.Post("N[N] G3 X[AX] Y[AY] Z[AZ] C[AC] R[R] F[F]");
				break;
			}
		}
		Marshal.ReleaseComObject(V);
	}
	public override void OutputThread(IPostData PD)
	{
		PD.Post("N[N] G32 X[AD] Z[AZ] F[F]");
	}
	public override void OutputCancelTool(IPostData PD)
	{
		PD.Post("N[N] T[T]00");
	}

	// 2-AXIS Turning Tool (inc. Centre Drilling)
	public override void OutputSelectLatheTool(IPostData PD)
	{
		PD.Post("N[N] G0 T[T][OFS]   'Select TOOL [T] and OFFSET Number [OFS]");
		PD.Post("N[N] G50 (X... Z...)    'Enter tool reference values at machine");
		PD.Post("N[N] G50 S[MS]");  // MS = Maximum Spindle Speed
		PD.Post("N[N] [CS] S[S] [RT] [FP]");

		ShowToolChangePos(PD);
	}

	// Select new DRIVEN tool for C-axis Milling and Drilling
	public override void OutputSelectTool(IPostData PD)
	{
		PD.Post("N[N] OPN = [OPN], OSN = [OSN], OPG = [OPG]");
		PD.Post("N[N] T[T][OFS]  ' Select MILLING TOOL type [TT], fp = [FP]");
		ShowToolChangePos(PD);
	}
	public override void OutputChangeProgPoint(IPostData PD)
	{
		PD.Post("OutputChangeProgPoint");
	}

	// SYN=Sync Number
	// TAB = 1 if Turret Above Centre Line,  = 2 if Turret is Below Centre Line
	//  TFB = 1 if Turret is at Front (Conventional), = 2 if Turret is at Back
	public override void OutputSetSyncPoint(IPostData PD)
	{
		IPostVariables V = PD.Vars;
		if (V.TAB == 1)    // Turret is Above C/L
			PD.Post("N[N] P[SYN]");
		else               // Turret is Below C/L
			PD.Post("N[N] Q[SYN]");
		Marshal.ReleaseComObject(V);
	}
	public override void OutputSelectToolAndWorkPlane(IPostData PD)
	{
		PD.Post("' Change Tool and Work Plane at same time");
	}

	// CWP = Current Work Plane:
	// 0 = 2-AXIS Turning, 1 = XY, 2 = XZ, 3 = YZ, 4 = 3D, 5 = C-Ax Developed
	// OPT = 1 for 2-AX TURN OR C-AX MILL, = 2 for C-AX DRILL/TAP ETC
	public override void OutputSelectWorkPlane(IPostData PD)
	{
		IPostVariables V = PD.Vars;
		double CWP = V.CWP;
		if (V.OPT != 2.0 && CWP != OldWP)
		{
			if (CWP == 0.0)
				PD.Post("N[N] M49");                    // 2-AXIS TURNING
			else if (CWP == 1.0)
				PD.Post("N[N] G112");
			else if (CWP < 4.0)
				PD.Post("N[N] G[CWP + 16]");
			else if (CWP == 5.0)
			{
				PD.Post("N[N] G18 H0 W0");              // DDP = Diameter of Developed Plane
				PD.Post("N[N] G107 C[DDP / 2]        ' Part Diameter = [DDP]");
			}
			OldWP = CWP;
		}
		Marshal.ReleaseComObject(V);
	}
	public override void OutputOriginShift(IPostData PD)
	{
		PD.Post("N[N] G52 X[OX] Y[OY]            'ORIGIN SHIFT");
	}
	public override void OutputCancelOriginShift(IPostData PD)
	{
		PD.Post("N[N] G52 X0.0 Y0.0              'CANCEL ORIGIN SHIFT");
	}
	public override void OutputCallSub(IPostData PD)
	{
		PD.Post("N[N] M98 P[SN]                  'CALL SUB [SN]");
	}
	public override void OutputBeginSub(IPostData PD)
	{
		PD.Post(":[SN]                           'BEGIN SUB [SN]");
	}
	public override void OutputEndSub(IPostData PD)
	{
		PD.Post("N[N] M99                        'END SUB [SN]");
	}
	public override void OutputMoveClamp(IPostData PD)
	{
		PD.ModalOff("");
		PD.Post("'Move clamp# [MCN], X[CAX] Y[CAY], Z[CAZ], C[CLA] ([CLN])");
	}
	public override void OutputDrillCycleCancel(IPostData PD)
	{
		PD.Post("N[N] G80");
	}
	public override void OutputDrillCycleFirstHole(IPostData PD)
	{
		IPostVariables V = PD.Vars;
		double CWP = V.CWP;
		switch (PD.DrillType)
		{
		case AcamPostDrillType.acamPostDrillTypeDRILL:
			if (!PD.DrillRapidAtRPlane)
			{
				if (CWP == 1.0) // X-Y PLANE - HOLES ARE ON A FACE
					PD.Post("N[N] G98 G83 X[AD] C[AC] Z[AZ + ZB] R[AZ + ZR] F[F]");
				else if (CWP == 5) // HOLES ARE ON A DEVELOPED DIAMETER
				{
					PD.Post("N[N] G80 G0 X[DDP + (ZS*2)]");
					PD.Post("N[N] G98 G87 Z[AZ] C[AC] X[DDP+(ZB*2)] R[ZR-ZS] F[F]");
				}
				else    // HOLES MUST BE Y-AXIS  (OR B-AXIS)
					PD.Post("N[N] G98 G87 Z[AZ] C[AC] X[AX+ZB] Y[AY] R[ZR-ZS] F[F]");
			}
			else    // Traverse at retract level
			{
				if (CWP == 1) // X-Y PLANE - HOLES ARE ON A FACE
					PD.Post("N[N] G99 G83 X[AD] C[AC] Z[AZ + ZB] R0. F[F]");
				else if (CWP == 5) // HOLES ARE ON A DEVELOPED DIAMETER
					PD.Post("N[N] G99 G87 Z[AZ] C[AC] X[DDP+(ZB*2)] R0. F[F]");
				else    // HOLES MUST BE Y-AXIS  (OR B-AXIS)
					PD.Post("N[N] G99 G87 Z[AZ] C[AC] X[AX+ZB] Y[AY] R0. F[F]");
			}
			break;

		case AcamPostDrillType.acamPostDrillTypePECK:
			if (!PD.DrillRapidAtRPlane)
			{
				if (CWP == 1) // X-Y PLANE - HOLES ARE ON A FACE
					PD.Post("N[N] G98 G83 X[AD] C[AC] Z[AZ + ZB] R[AZ + ZR] Q[ZP] F[F]");
				else if (CWP == 5) // HOLES ARE ON A DEVELOPED DIAMETER
				{
					PD.Post("N[N] G80 G0 X[DDP + (ZS*2)]");
					PD.Post("N[N] G98 G87 Z[AZ] C[AC] X[DDP+(ZB*2)] R[ZR-ZS] Q[ZP] F[F]");
				}
				else    // HOLES MUST BE Y-AXIS  (OR B-AXIS)
					PD.Post("N[N] G98 G87 Z[AZ] C[AC] X[AX+ZB] Y[AY] R[ZR-ZS] Q[ZP] F[F]");
			}
			else    // Traverse at retract level
			{
				if (CWP == 1) // X-Y PLANE - HOLES ARE ON A FACE
					PD.Post("N[N] G99 G83 X[AD] C[AC] Z[AZ + ZB] R0. Q[ZP] F[F]");
				else if (CWP == 5) // HOLES ARE ON A DEVELOPED DIAMETER
					PD.Post("N[N] G99 G87 Z[AZ] C[AC] X[DDP+(ZB*2)] R0. Q[ZP] F[F]");
				else    // HOLES MUST BE Y-AXIS  (OR B-AXIS)
					PD.Post("N[N] G99 G87 Z[AZ] C[AC] X[AX+ZB] Y[AY] R0. Q[ZP] F[F]");
			}
			break;

		case AcamPostDrillType.acamPostDrillTypeTAP:
			if (!PD.DrillRapidAtRPlane)
			{
				if (CWP == 1) // X-Y PLANE - HOLES ARE ON A FACE
					PD.Post("N[N] G98 G84 X[AD] C[AC] Z[AZ + ZB] R[AZ + ZR] F[F]");
				else if (CWP == 5) // HOLES ARE ON A DEVELOPED DIAMETER
				{
					PD.Post("N[N] G80 G0 X[DDP + (ZS*2)]");
					PD.Post("N[N] G98 G87 Z[AZ] C[AC] X[DDP+(ZB*2)] R[ZR-ZS] F[F]");
				}
				else    // HOLES MUST BE Y-AXIS  (OR B-AXIS)
					PD.Post("N[N] G98 G87 Z[AZ] C[AC] X[AX+ZB] Y[AY] R[ZR-ZS] F[F]");
			}
			else    // Traverse at retract level
			{
				if (CWP == 1) // X-Y PLANE - HOLES ARE ON A FACE
					PD.Post("N[N] G99 G84 X[AD] C[AC] Z[AZ + ZB] R0. F[F]");
				else if (CWP == 5) // HOLES ARE ON A DEVELOPED DIAMETER
					PD.Post("N[N] G99 G84 Z[AZ] C[AC] X[DDP+(ZB*2)] R0. F[F]");
				else    // HOLES MUST BE Y-AXIS  (OR B-AXIS)
					PD.Post("N[N] G99 G84 Z[AZ] C[AC] X[AX+ZB] Y[AY] R0. F[F]");
			}
			break;

		case AcamPostDrillType.acamPostDrillTypeBORE:
			if (!PD.DrillRapidAtRPlane)
			{
				if (CWP == 1) // X-Y PLANE - HOLES ARE ON A FACE
					PD.Post("N[N] G98 G83 X[AD] C[AC] Z[AZ + ZB] R[AZ + ZR] P[DW] F[F]");
				else if (CWP == 5) // HOLES ARE ON A DEVELOPED DIAMETER
				{
					PD.Post("N[N] G80 G0 X[DDP + (ZS*2)]");
					PD.Post("N[N] G98 G87 Z[AZ] C[AC] X[DDP+(ZB*2)] R[ZR-ZS] P[DW] F[F]");
				}
				else    // HOLES MUST BE Y-AXIS  (OR B-AXIS)
					PD.Post("N[N] G98 G87 Z[AZ] C[AC] X[AX+ZB] Y[AY] R[ZR-ZS] P[DW] F[F]");
			}
			else    // Traverse at retract level
			{
				if (CWP == 1) // X-Y PLANE - HOLES ARE ON A FACE
					PD.Post("N[N] G99 G83 X[AD] C[AC] Z[AZ + ZB] R0. P[DW] F[F]");
				else if (CWP == 5) // HOLES ARE ON A DEVELOPED DIAMETER
					PD.Post("N[N] G99 G87 Z[AZ] C[AC] X[DDP+(ZB*2)] R0. P[DW] F[F]");
				else    // HOLES MUST BE Y-AXIS  (OR B-AXIS)
					PD.Post("N[N] G99 G87 Z[AZ] C[AC] X[AX+ZB] Y[AY] R0. P[DW] F[F]");
			}
			break;
		}
		Marshal.ReleaseComObject(V);
	}
	public override void OutputDrillCycleNextHoles(IPostData PD)
	{
		IPostVariables V = PD.Vars;
		double CWP = V.CWP;
		if (CWP == 1)
			PD.Post("N[N] X[AD] C[AC]");
		else if (CWP == 5)
			PD.Post("N[N] Z[AZ] C[AC]");
		else
			PD.Post("N[N] Z[AZ] Y[AY]");
		Marshal.ReleaseComObject(V);
	}
	public override void OutputDrillCycleSubParameters(IPostData PD)
	{
		PD.Post("OutputDrillCycleSubParameters");
	}
	public override void OutputLatheCycle(IPostData PD)
	{
		switch (PD.LatheCycleType)
		{
		case AcamPostLatheCycleType.acamPostLatheCycleDIAMETER_ROUGH: // $300
			PD.Post("N[N] (SPD = [SPD], SPZ = [SPZ], EPD = [EPD], EPZ = [EPZ] ' Start/end of profile");
			PD.Post("N[N] G71 P[LNS] Q[LNE] U[STD] W[STF] D[WDC] F[F] S[S]        ' DIA ROUGH CYCLE");
			break;

		case AcamPostLatheCycleType.acamPostLatheCycleDIAMETER_ROUGH_END:
		case AcamPostLatheCycleType.acamPostLatheCycleDIAMETER_GROOVE_END:
		case AcamPostLatheCycleType.acamPostLatheCycleFACE_ROUGH_END:
		case AcamPostLatheCycleType.acamPostLatheCycleFACE_GROOVE_END: // $301, 306, 326, 336
			PD.Post("N[N] G80 ' End of cycle profile");
			break;

		case AcamPostLatheCycleType.acamPostLatheCycleFACE_ROUGH: // $305
			PD.Post("N[N] G72 P[LNS] Q[LNE] U[STD] W[STF] D[WDC] F[F] S[S] ' RTR = [RTR]");
			break;

		case AcamPostLatheCycleType.acamPostLatheCycleDRILL: // $310
			PD.Post("N[N] G74 Z[ZB] K[ZP] F[F]");
			break;

		case AcamPostLatheCycleType.acamPostLatheCycleDIAMETER_GROOVE: // $320
			PD.Post("N[N] G75 X[AD] Z[AZ] I[PKD] K[WDC] F[F]");
			break;

		case AcamPostLatheCycleType.acamPostLatheCycleDIAMETER_GROOVE_PROFILE: // $325
			PD.Post("N[N] G175 I[PKD] K[WDC] F[F]");
			break;

		case AcamPostLatheCycleType.acamPostLatheCycleFACE_GROOVE: // $330
			PD.Post("N[N] G74 X[AD] Z[AZ] I[WDC] K[PKD] F[F]");
			break;

		case AcamPostLatheCycleType.acamPostLatheCycleFACE_GROOVE_PROFILE: // $335
			PD.Post("N[N] G174 I[WDC] K[PKD] F[F]");
			break;

		case AcamPostLatheCycleType.acamPostLatheCycleTHREAD:  // $340
			PD.Post("'vars [NTS], [TAD], [NOC], [SPR], [TLI], [TLO], [TLH], [TCT], [TFD], [TFP]");
			PD.Post("N[N] G76 X[AD] Z[AZ] I[THR] K[THD] D[THF] F[F] A[THA]");
			break;
		}
	}
	public override void AfterOpenPost(IPostConfigure PC)
	{
		PC.ConstantSurfaceSpeed = "G96";  // $71 for variable CS
		PC.ConstantSpindleSpeed = "G97"; // $72 for variable CS
		PC.FeedPerMin = "G98";    // $73 for variable FP
		PC.FeedPerRev = "G99";    // $74 for variable FP
		PC.CWSpindleRotation = "M03"; // $75
		PC.CCWSpindleRotation = "M04"; // $76
		PC.MCToolCompCancel = "G40"; // $140
		PC.MCToolCompLeft = "G41"; // $141
		PC.MCToolCompRight = "G42"; // $142
		PC.MCToolCompOnRapidApproach = false;   // $147
		PC.CoolantOff = "M09"; // $150
		PC.CoolantMist = "M07"; // $151
		PC.CoolantFlood = "M08"; // $152
		PC.CoolantThroughTool = "M10"; // $153
		PC.ModalText = "G0 G1 G2 G3"; // $500
		PC.ModalAbsoluteValues = "X Y Z F C"; // $502
		PC.ModalIncrementalValues = "I J"; // $504
		PC.NeedPlusSigns = false; // $510
		PC.DecimalSeparator = AcamPostDecimalSeparator.acamPostDecimalSeparatorPOINT; // $515
		PC.SubroutinesAtEnd = true; // $520
		PC.LimitArcs = AcamPostLimitArcs.acamPostLimitArcsQUAD; // $525, 526
		PC.HelicalArcsAsLines = false; // $527
		PC.PlanarArcsAsLines = AcamPostPlanarArcsAsLines.acamPostPlanarArcsAsLinesNONE; // $530
		PC.MaximumArcRadius = 0; // $531
		PC.ArcChordTolerance = 0.1; // $532
		PC.CAxisArcsAndLinesAsLines = AcamPostCAxisLines.acamPostCAxisLinesNONE;   // $533
		PC.SuppressComments = false; // $540
		PC.AllowOutputVisibleOnly = true; // $545
		PC.OutputLatheBySequenceNumber = true; // $543
		PC.LatheAX = AcamPostLatheAX.acamPostLatheAXIsDIAMETER;    // $550
		PC.LatheCycleIgnoreUndercuts = false;  // $551
		PC.LatheEdgeTip = true;    // $555
		PC.FiveAxisProgramPivot = false; // $560
		PC.FiveAxisOffsetFromPivotPointX = 0; // $562
		PC.FiveAxisOffsetFromPivotPointY = 0; // $563
		PC.FiveAxisToolHolderLength = 0; // $565
		PC.FiveAxisToolMaxAngle = 90; // $570
		PC.FiveAxisToolMaxAngleChange = 15; // $575
		PC.AllowPositiveAndNegativeTilt = false; // $577
		PC.HorizontalMCCentre = true; // $580
		PC.SelectWpToolOrder = AcamPostSelectWpToolOrder.acamPostSelectWpToolOrderTOOL_FIRST; // $582
		PC.LocalXorYAxis = AcamPostLocalXorYAxis.acamPostLocalXorYAxisNONE; // $584
		PC.Allow5AxisHelicalArcs = false; // $585
		PC.LatheBelowCLXPositive = false;  // $590

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
		PC.LineStartNumber = 10;     // $715
		PC.LineNumberIncrement = NoLineNumbers ? 0 : 10;    // $716

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
		pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
		pf.LeadingFigures = 0;
		pf.FiguresAfterPoint = 0;
		Marshal.ReleaseComObject(pf);
		PC.SpindleSpeedMax = 4000; // $743
		//PC.SpindleSpeedRound = 100;   // $745

		// FeedNumberFormat $750, 751 & 752
		pf = PC.FeedNumberFormat;
		pf.Format = AcamPostNumberFormat.acamPostNumberFormat3DECIMAL_NO_0_OR_POINT;
		pf.LeadingFigures = 0;
		pf.FiguresAfterPoint = 3;
		Marshal.ReleaseComObject(pf);

		//PC.FeedMax = 800; // $753
		//PC.FeedRound = 10;   // $755

		// ToolNumberFormat $760, 761 & 762
		pf = PC.ToolNumberFormat;
		pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
		pf.LeadingFigures = 0;
		pf.FiguresAfterPoint = 0;
		Marshal.ReleaseComObject(pf);

		PC.RapidXYSpeed = 5000;    // $900
		PC.RapidZSpeed = 4000;     // $901
		PC.ToolChangeTime = 3;      // $902

		IPostUserVariable UV = PC.AddUserVariable();
		UV.Name = "L_BRACKET";
		IPostFormat PF = UV.Format;
		PF.Format = AcamPostNumberFormat.acamPostNumberFormatTEXT;
		UV.Text = "[";
		Marshal.ReleaseComObject(PF);
		Marshal.ReleaseComObject(UV);

		UV = PC.AddUserVariable();
		UV.Name = "R_BRACKET";
		PF = UV.Format;
		PF.Format = AcamPostNumberFormat.acamPostNumberFormatTEXT;
		UV.Text = "]";
		Marshal.ReleaseComObject(PF);
		Marshal.ReleaseComObject(UV);

		UV = PC.AddUserVariable();
		UV.Name = "DATE";
		PF = UV.Format;
		PF.Format = AcamPostNumberFormat.acamPostNumberFormatTEXT_TRUNCATE;
		PF.LeadingFigures = 9;
		Marshal.ReleaseComObject(PF);
		Marshal.ReleaseComObject(UV);

		UV = PC.AddUserVariable();
		UV.Name = "PROGNUM";
		PF = UV.Format;
		PF.Format = AcamPostNumberFormat.acamPostNumberFormat7INTEGER_LEAD_0;
		PF.LeadingFigures = 4;
		UV.Prompt = "Program Number";
		Marshal.ReleaseComObject(PF);
		Marshal.ReleaseComObject(UV);

		UV = PC.AddUserVariable();
		UV.Name = "XVAL";
		PF = UV.Format;
		PF.Format = AcamPostNumberFormat.acamPostNumberFormat2DECIMAL_NO_0;
		PF.FiguresAfterPoint = 4;
		Marshal.ReleaseComObject(PF);
		Marshal.ReleaseComObject(UV);
	}

	void ShowToolChangePos(IPostData PD)
	{
		// For testing only

		IPath P = PD.Path;
		ITurnData TD = P.GetTurnData();
		IPostVariables V = PD.Vars;

		// TODO test if TD is valid or not

		double TCX = 0, TCZ = 0;
		if (TD.GetToolChangePointForTurret(
			V.TAB == 2 ? AcamLatheTurret.acamTurretBELOW_CL : AcamLatheTurret.acamTurretABOVE_CL,
			V.TFB == 2 ? AcamLatheStation.acamStationBACK : AcamLatheStation.acamStationFRONT, out TCZ, out TCX))
		{
			string tcx = PD.Format(TCX);
			string tcz = PD.Format(TCZ);
			string str = "Tool Change X,Z = " + tcx + ", " + tcz;
			PD.Post(str);
		}
		else
			PD.Post("Tool Change Position not set!!!");

		Marshal.ReleaseComObject(P);
		Marshal.ReleaseComObject(TD);
		Marshal.ReleaseComObject(V);
	}

}