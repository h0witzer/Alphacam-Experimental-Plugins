using AlphaCAMMill;
using System;
using System.Runtime.InteropServices;
using static System.Windows.Forms.LinkLabel;
using System.Runtime.Remoting.Metadata.W3cXsd2001;
using System.Runtime.ConstrainedExecution;

class WirePost : Post
{
	IAlphaCamApp Acam;

	public WirePost(IAlphaCamApp Acam)
	{
		this.Acam = Acam;
	}
	public override void BeforeCreateNc()
	{

	}
	public override void OutputFileLeadingLines(IPostData PD)
	{
		PD.Post("'C# ExamplePost2 - Wire");

		// Get the Alphacam version
		IVersionInformation Ver = Acam.AlphacamVersion;
		PD.Post("'ALPHACAM Version: " + Ver.String);
		PD.Post("%");
		Marshal.ReleaseComObject(Ver);
	}
	public override void OutputProgramLeadingLines(IPostData PD)
	{
		PostVariables V = PD.Vars;
		string date = V.DAT;
		date = date.Substring(0, 9);
		date = date.ToUpper();
		PD.Post("(PROGRAM PRODUCED  - " + date + ")");
		PD.Post(": [PROGNUM]");
		PD.Post("N[N] G90 G71");
		PD.Post("N[N] G40 G50");
		PD.Post("N[N] G92 X[AX] Y[AY] I[EZA-EZP]");
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
		PD.Post("N[N] G0 X[AX] Y[AY]");
	}
	public override void OutputUp(IPostData PD)
	{
		// Lines BEFORE a rapid move
	}
	public override void OutputDown(IPostData PD)
	{
		// Lines AFTER a rapid move

		// Treat small values of ETA as zero.
		// Get the number of decimal places. (Easier to just store the value set in AfterOpenPost but this shows another way)
		IPostConfigure PC = Acam.PostConfigure;
		IPostFormat PF = PC.XYZNumberFormat;
		IPostVariables V = PD.Vars;
		int ndp = PF.FiguresAfterPoint;
		double eta = V.ETA;

		if (Math.Abs(eta) < 0.5 * Math.Pow(10.0, -ndp))
		{
			PD.Post("N[N] G50");    // Wire vertical
		}
		else if (eta > 0)   // WIRE INCLINATION LEFT
		{
			PD.Post("N[N] G51");
			PD.Post("N[N] T[ETA]");
		}
		else if (eta < 0)   // WIRE INCLINATION RIGHT
		{
			PD.Post("N[N] G52");
			PD.Post("N[N] T[-ETA]");
		}
		PD.Post("N[N] G92 X[AX] Y[AY] I[EZA-EZP]    'Start of cutting between Z[EZP] and Z[EZA]");
		PD.Post("N[N] GEN[GEN], CTN[CTN], SIM[SIM], TNC[TNC], BDC[BDC]");

		Marshal.ReleaseComObject(PC);
		Marshal.ReleaseComObject(PF);
		Marshal.ReleaseComObject(V);
	}
	public override void OutputFeed(IPostData PD)
	{
		if (PD.FeedType == AcamPostFeedType.acamPostFeedTypeLINE)
		{
			IPostVariables V = PD.Vars;
			if (V.MC != 0.0 && V.In != 0.0)
				PD.Post("N[N] G01 G90 [TC] X[AX] Y[AY] U[EU] V[EV] F[F]");    // M/C comp applies, and this is LEAD-IN Line
			else if (V.MC != 0.0 && V.Out != 0.0)
				PD.Post("N[N] G01 [TC] X[AX] Y[AY] U[EU] V[EV] F[F]");  // M/C comp applies, and this is LEAD-OUT Line
			else
				PD.Post("N[N] G1 X[AX] Y[AY] U[EU] V[EV] F[F]"); // Applies to all other lines (with APS or M/C comp).
			Marshal.ReleaseComObject(V);
		}
		else if (PD.FeedType == AcamPostFeedType.acamPostFeedTypeCWARC)
		{
			PD.Post("N[N] G2 X[AX] Y[AY] I[II] J[IJ] U[EU] V[EV] K[EK] L[EL] F[F]");
		}
		else if (PD.FeedType == AcamPostFeedType.acamPostFeedTypeCCWARC)
		{
			PD.Post("N[N] G3 X[AX] Y[AY] I[II] J[IJ] U[EU] V[EV] K[EK] L[EL] F[F]");
		}
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
	public override void OutputStop(IPostData PD)
	{
		PD.Post("N[N] M00");
	}
	public override void AfterOpenPost(IPostConfigure PC)
	{
		PC.MCToolCompCancel = "G40"; // $140
		PC.MCToolCompLeft = "G41"; // $141
		PC.MCToolCompRight = "G42"; // $142
		PC.MCToolCompOnRapidApproach = false;   // $147

		PC.ModalText = "G0 G1 G2 G3"; // $500
		PC.ModalAbsoluteValues = "X Y F T"; // $502
		PC.ModalIncrementalValues = "I J U V K L"; // $504
		PC.NeedPlusSigns = false; // $510
		PC.DecimalSeparator = AcamPostDecimalSeparator.acamPostDecimalSeparatorPOINT; // $515
		PC.SubroutinesAtEnd = true; // $520
		PC.LimitArcs = AcamPostLimitArcs.acamPostLimitArcs180; // $525, 526
		PC.PlanarArcsAsLines = AcamPostPlanarArcsAsLines.acamPostPlanarArcsAsLinesNONE; // $530
		PC.MaximumArcRadius = 0; // $531
		PC.ArcChordTolerance = 0.1; // $532
		PC.CAxisArcsAndLinesAsLines = AcamPostCAxisLines.acamPostCAxisLinesNONE;   // $533
		PC.SuppressComments = false; // $540
		PC.AllowOutputVisibleOnly = true; // $545

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

		PC.FeedMax = 2000; // $753
		//PC.FeedRound = 10;   // $755

		PC.RapidXYSpeed = 1500;    // $900

		IPostUserVariable UV = PC.AddUserVariable();
		UV.Name = "DATE";
		IPostFormat PF = UV.Format;
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
	}
}