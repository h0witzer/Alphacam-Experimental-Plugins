using AlphaCAMMill;
using System;
using System.Runtime.InteropServices;

class LaserPost : Post
{
	IAlphaCamApp Acam;

	public LaserPost(IAlphaCamApp Acam)
	{
		this.Acam = Acam;
	}
	public override void BeforeCreateNc()
	{

	}
	public override void OutputFileLeadingLines(IPostData PD)
	{
		PD.Post("'C# ExamplePost2 - Laser");

		// Get the Alphacam version
		IVersionInformation Ver = Acam.AlphacamVersion;
		PD.Post("'ALPHACAM Version: " + Ver.String);
		PD.Post("$LET DATE = DAT");
		PD.Post("%");
		Marshal.ReleaseComObject(Ver);
	}
	public override void OutputProgramLeadingLines(IPostData PD)
	{
		PD.Post(":[PROGNUM]");
		PD.Post("N[N] (PROGRAM PRODUCED  - [DATE])");
		PD.Post("N[N] G90 G71");
		PD.Post("N[N] G40 G80");
	}
	public override void OutputProgramTrailingLines(IPostData PD)
	{
		PD.Post("N[N] M30");
	}
	public override void OutputFileTrailingLines(IPostData PD)
	{
		PD.Post("%");
	}
	public override void OutputRapid(IPostData PD)
	{
		IPostVariables V = PD.Vars;
		AcamPostRapidType type = PD.RapidType;
		switch (type)
		{
			case AcamPostRapidType.acamPostRapidTypeXY:
				PD.Post("N[N] G0 X[AX] Y[AY]");
				break;

			case AcamPostRapidType.acamPostRapidTypeXYZ:
				PD.Post("N[N] G0 X[AX] Y[AY] Z[AZ]");
				break;

			case AcamPostRapidType.acamPostRapidTypeZ:
				PD.Post("N[N] G0 Z[AZ]");
				break;
		}
		Marshal.ReleaseComObject(V);
	}
	public override void OutputUp(IPostData PD)
	{
		PD.Post("M09    'Laser OFF");
	}
	public override void OutputDown(IPostData PD)
	{
		PD.Post("M08    'Laser ON");
	}
	public override void OutputFeed(IPostData PD)
	{
		Element E = PD.Element;
		if (E.Is5Axis)
		{
			PD.Post("N[N] G1 X[AX] Y[AY] A[TWZ] B[TIZ] F[F] ' TAX: [TAX], [TAY], [TAZ]");
		}
		else if (PD.FeedType == AcamPostFeedType.acamPostFeedTypeLINE)
		{
			PD.Post("N[N] G1 X[AX] Y[AY] F[F]");
		}
		else if (PD.FeedType == AcamPostFeedType.acamPostFeedTypeCWARC)
		{
			PD.Post("N[N] G2 X[AX] Y[AY] R[R] F[F]");
		}
		else if (PD.FeedType == AcamPostFeedType.acamPostFeedTypeCCWARC)
		{
			PD.Post("N[N] G3 X[AX] Y[AY] R[R] F[F]");
		}
	}
	public override void OutputSelectWorkPlane(IPostData PD)
	{
		PD.Post("N[N] (WORK PLANE NAME = [WPN], OFFSET CODE = [WPO])");
	}
	public override void OutputOriginShift(IPostData PD)
	{
		PD.Post("N[N] G60 X[OX] Y[OY]            'ORIGIN SHIFT");
	}
	public override void OutputCancelOriginShift(IPostData PD)
	{
		PD.Post("N[N] G67              'CANCEL ORIGIN SHIFT");
	}
	public override void OutputCallSub(IPostData PD)
	{
		PD.Post("N[N] G22 P[SN]                  'CALL SUB [SN]");
	}
	public override void OutputBeginSub(IPostData PD)
	{
		PD.Post("N[N] $[SN]");
		PD.Post("N[N] G0 X[AX] Y[AY]");
	}
	public override void OutputEndSub(IPostData PD)
	{
		PD.Post("N[N] G0 Z[AZ]");
		PD.Post("N[N] G99");
	}
	public override void OutputCutHoleCycleCancel(IPostData PD)
	{
		PD.Post("N[N] G80");
	}
	public override void OutputCutHoleCycleFirstHole(IPostData PD)
	{
		AcamCutHolesType type = PD.CutHoleType;
		string g9899 = PD.DrillRapidAtRPlane ? "G99" : "G98";
		string str = "N[N] " + g9899;
		switch (type)
		{
		case AcamCutHolesType.acamCutHolesPIERCE:
			PD.Post(str + " G81 X[AX] Y[AY] R[ZR] F[F] ' Hole Diam = [HD]");
			break;
		case AcamCutHolesType.acamCutHolesCUT_HOLE:
			PD.Post(str + " G82 X[AX] Y[AY] R[ZR] F[F] ' Hole Diam = [HD], Number of Cuts = [NCT]");
			break;
		case AcamCutHolesType.acamCutHolesSPIRAL:
			PD.Post("SPIRAL CANNED CYCLE NOT AVAILABLE ' Hole Diam = [HD], Width of Cut = [WDC]");
			break;
		}
	}
	public override void OutputCutHoleCycleNextHoles(IPostData PD)
	{
		// Can use pPD->CutHoleType and pPD->DrillRapidAtRPlane if required
		PD.Post("N[N] X[AX] Y[AY]");
	}
	public override void AfterOpenPost(IPostConfigure PC)
	{
		PC.CWSpindleRotation = "M03"; // $75
		PC.CCWSpindleRotation = "M04"; // $76
		PC.MCToolCompCancel = "G40"; // $140
		PC.MCToolCompLeft = "G41"; // $141
		PC.MCToolCompRight = "G42"; // $142
		PC.MCToolCompOnRapidApproach = true;   // $147
		PC.CoolantOff = "M09"; // $150
		PC.CoolantMist = "M07"; // $151
		PC.CoolantFlood = "M08"; // $152
		PC.CoolantThroughTool = "M10"; // $153
		PC.ModalText = "G0 G1 G2 G3"; // $500
		PC.ModalAbsoluteValues = "X Y Z F"; // $502
		PC.ModalIncrementalValues = "I J"; // $504
		PC.NeedPlusSigns = false; // $510
		PC.DecimalSeparator = AcamPostDecimalSeparator.acamPostDecimalSeparatorPOINT; // $515
		PC.SubroutinesAtEnd = true; // $520
		PC.LimitArcs = AcamPostLimitArcs.acamPostLimitArcs180; // $525, 526
		PC.HelicalArcsAsLines = false; // $527
		PC.PlanarArcsAsLines = AcamPostPlanarArcsAsLines.acamPostPlanarArcsAsLinesNONE; // $530
		PC.MaximumArcRadius = 0; // $531
		PC.ArcChordTolerance = 0.1; // $532
		PC.SuppressComments = false; // $540
		PC.AllowOutputVisibleOnly = true; // $545
		PC.FiveAxisProgramPivot = false; // $560
		PC.FiveAxisOffsetFromPivotPointX = 0; // $562
		PC.FiveAxisOffsetFromPivotPointY = 0; // $563
		PC.FiveAxisToolHolderLength = 0; // $565
		PC.FiveAxisToolMaxAngle = 90; // $570
		PC.FiveAxisToolMaxAngleChange = 15; // $575
		PC.AllowPositiveAndNegativeTilt = false; // $577
		PC.HorizontalMCCentre = false; // $580
		PC.LocalXorYAxis = AcamPostLocalXorYAxis.acamPostLocalXorYAxisNONE; // $584
		PC.Allow5AxisHelicalArcs = false; // $585

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
		PC.LineNumberIncrement = 10; // $716

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

		// FeedNumberFormat $750, 751 & 752
		pf = PC.FeedNumberFormat;
		pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
		pf.LeadingFigures = 0;
		pf.FiguresAfterPoint = 0;
		Marshal.ReleaseComObject(pf);
		PC.FeedMax = 10000; // $753
		//PC.FeedRound = 10;   // $755

		// ToolNumberFormat $760, 761 & 762
		pf = PC.ToolNumberFormat;
		pf.Format = AcamPostNumberFormat.acamPostNumberFormat7INTEGER_LEAD_0;
		pf.LeadingFigures = 2;
		pf.FiguresAfterPoint = 0;
		Marshal.ReleaseComObject(pf);

		PC.RapidXYSpeed = 25000;    // $900
		PC.RapidZSpeed = 15000;     // $901
		PC.ToolChangeTime = 30;      // $902

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
}