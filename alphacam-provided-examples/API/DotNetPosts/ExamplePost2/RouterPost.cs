using AlphaCAMMill;
using Microsoft.Win32;
using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;

class RouterPost : Post
{
	IAlphaCamApp Acam;
	bool first_rapid;
	public RouterPost(IAlphaCamApp Acam)
	{
		this.Acam = Acam;
		first_rapid = true;
	}

	public override void BeforeOutputNc(EventDataFileName Data)
	{
		// Called before ALPHACAM shows save NC file dialog box

		// Set Data.ReturnCode to one of these values:
		// 0 if ALPHACAM should show normal the dialog box
		// 1 to supply a filename and write the filename to Data.FileName
		// 2 to cancel output

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

	public override void BeforeOutputNcDialogBox(EventData Data)
	{
		// Called before the Output NC dialog appears asking the user where to output NC (File, Machine, or Both)

		// Set Data.ReturnCode to one of these values:
		// 0 if ALPHACAM should show normal the dialog box
		// 1 to force File output
		// 2 to force Machine output
		// 3 to force Both
		// 10 to cancel output

		// Force file only output
		Data.ReturnCode = 1;
	}
	public override void BeforeCreateAnyNc(EventData Data)
	{
		// Called before any NC is created allowing Post to potentially disable output
		// See also BeforeCreateNc which is called once but does not allow disabling output. BeforeCreateNc will be called multiple
		// times if outputing a drawing with multiple nested sheets.

		// Set Data.ReturnCode to one of these values:
		// 0 if ALPHACAM should continue as normal
		// 1 to cancel NC output

		// This is a good location to check license, customer name, etc... to determine if Post can be used or not
		License lic = Acam.License;
		string customerName = lic.GetCustomerName();			
		Marshal.ReleaseComObject(lic);

		Data.ReturnCode = 0;
	}

	public override void BeforeCreateNc()
	{

	}
	public override void OutputFileLeadingLines(IPostData PD)
	{
		PD.Post("'C# ExamplePost2 - Router");

		// Get the Alphacam version
		IVersionInformation Ver = Acam.AlphacamVersion;
		PD.Post("'ALPHACAM Version: " + Ver.String);
		PD.Post("$LET DATE = DAT");
		PD.Post("%");

		// Just for testing, use an external assembly (MathUtils.dll)
		double pi = MathUtils.Utils.DegToRad(180.0);
		PD.Post("2 PI = " + pi * 2);

		// And another test using a trival string library function
		string test1 = "ALPHACAM";
		string test2 = "alphacam";
		bool bTest1 = StringHelper.Utils.StartsWithUpper(test1);
		bool bTest2 = StringHelper.Utils.StartsWithUpper(test2);

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
		string comp = "";
		AcamPostRapidType type = PD.RapidType;
		switch (type)
		{
			case AcamPostRapidType.acamPostRapidTypeXY:
				if (V.MC != 0.0)  // True here only if comp on rapid selected
					comp = V.TC + " ";
				if (first_rapid)
				{
					first_rapid = false;
					PD.Post("N[N] G0 " + comp + "X[AX] Y[AY]");
					PD.Post("N[N] G0 G43 Z[AZ] H[T] [CLT]");    // G43 = Tool Length Comp, CLT = Coolant code.
				}
				else
				{
					PD.Post("N[N] G0 " + comp + "X[AX] Y[AY]");
				}
				break;

			case AcamPostRapidType.acamPostRapidTypeXYZ:
				PD.Post("N[N] G0 X[AX] Y[AY] Z[AZ]");
				break;

			case AcamPostRapidType.acamPostRapidTypeZ:
				if (!first_rapid)   // No NC code if this is the first move in Z after tool change.
				{
					if (V.FRA != 0.0 && V.MC != 0.0)
						comp = V.TC + " ";
					PD.Post("N[N] G0 " + comp + "Z[AZ]");
				}
				break;
		}
		Marshal.ReleaseComObject(V);
	}
	public override void OutputFeed(IPostData PD)
	{
		if (PD.FeedType == AcamPostFeedType.acamPostFeedTypeLINE)
		{
			IPostVariables V = PD.Vars;
			if (V.MC != 0.0 && V.In != 0.0)
				PD.Post("N[N] G1 [TC] D[T+10] X[AX] Y[AY] Z[AZ] F[F]");
			else if (V.MC != 0.0 && V.Out != 0.0)
				PD.Post("N[N] G1 [TC] X[AX] Y[AY] Z[AZ] F[F]");
			else
				PD.Post("N[N] G1 X[AX] Y[AY] Z[AZ] F[F]");
			Marshal.ReleaseComObject(V);
		}
		else if (PD.FeedType == AcamPostFeedType.acamPostFeedTypeCWARC)
		{
			PD.Post("N[N] G2 X[AX] Y[AY] Z[AZ] R[R] F[F]");
		}
		else if (PD.FeedType == AcamPostFeedType.acamPostFeedTypeCCWARC)
		{
			PD.Post("N[N] G3 X[AX] Y[AY] Z[AZ] R[R] F[F]");
		}
	}
	public override void OutputSelectTool(IPostData PD)
	{
		PD.Post("N[N] T[T][OFS] [ROT]       'Select tool and offset");
		PD.Post("N[N] S[S] H[OFS] M06       'Next tool is [NT], Next XY is [NX], [NY]");
		first_rapid = true;
	}
	public override void OutputCancelTool(IPostData PD)
	{
		PD.Post("N[N] M09");
	}
	public override void OutputSelectToolAndWorkPlane(IPostData PD)
	{
		PD.Post("' Change Tool and Work Plane at same time");
	}
	public override void OutputSelectWorkPlane(IPostData PD)
	{
		PD.Post("N[N] (WORK PLANE NAME = [WPN], OFFSET CODE = [WPO])");
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
		PD.Post("N[N] M09    ''Turn coolant OFF");
		PD.Post("N[N] G80");
	}
	public override void OutputDrillCycleFirstHole(IPostData PD)
	{
		string g9899 = PD.DrillRapidAtRPlane ? "G99" : "G98";
		switch (PD.DrillType)
		{
			case AcamPostDrillType.acamPostDrillTypeDRILL:
				PD.Post("N[N] " + g9899 + " G81 X[AX] Y[AY] Z[ZB] R[ZR] F[F] [CLT]");
				break;
			case AcamPostDrillType.acamPostDrillTypePECK:
				PD.Post("N[N] " + g9899 + " G83 X[AX] Y[AY] Z[ZB] R[ZR] Q[ZP] F[F] [CLT]");
				break;
			case AcamPostDrillType.acamPostDrillTypeTAP:
				PD.Post("N[N] " + g9899 + " G84 X[AX] Y[AY] Z[ZB] R[ZR] F[F] [CLT]");
				break;
			case AcamPostDrillType.acamPostDrillTypeBORE:
				PD.Post("N[N] " + g9899 + " G82 X[AX] Y[AY] Z[ZB] R[ZR] P[DW] F[F] [CLT]");
				break;
		}
	}
	public override void OutputDrillCycleNextHoles(IPostData PD)
	{
		PD.Post("N[N] X[AX] Y[AY]");
	}
	public override void OutputDrillCycleSubParameters(IPostData PD)
	{
		string g9899 = PD.DrillRapidAtRPlane ? "G99" : "G98";
		switch (PD.DrillType)
		{
			case AcamPostDrillType.acamPostDrillTypeDRILL:
				PD.Post("N[N] " + g9899 + " G81 Z[ZB] R[ZR] F[F] [CLT]");
				break;
			case AcamPostDrillType.acamPostDrillTypePECK:
				PD.Post("N[N] " + g9899 + " G83 Z[ZB] R[ZR] Q[ZP] F[F] [CLT]");
				break;
			case AcamPostDrillType.acamPostDrillTypeTAP:
				PD.Post("N[N] " + g9899 + " G84 Z[ZB] R[ZR] F[F] [CLT]");
				break;
			case AcamPostDrillType.acamPostDrillTypeBORE:
				PD.Post("N[N] " + g9899 + " G82 Z[ZB] R[ZR] P[DW] F[F] [CLT]");
				break;
		}
	}
	public override void OutputFirstHoleSub(IPostData PD)
	{
		PD.Post("N[N] X[AX] Y[AY]");
	}
	public override void OutputNextHoleSub(IPostData PD)
	{
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
		PC.FiveAxisToolHolderLength = 100; // $565
		PC.FiveAxisToolMaxAngle = 0; // $570
		PC.FiveAxisToolMaxAngleChange = 15; // $575
		PC.AllowPositiveAndNegativeTilt = false; // $577
		PC.HorizontalMCCentre = false; // $580
		PC.SelectWpToolOrder = AcamPostSelectWpToolOrder.acamPostSelectWpToolOrderTOOL_FIRST; // $582
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

		// SpindleSpeedNumberFormat $740, 741 & 742
		pf = PC.SpindleSpeedNumberFormat;
		pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
		pf.LeadingFigures = 0;
		pf.FiguresAfterPoint = 0;
		Marshal.ReleaseComObject(pf);
		PC.SpindleSpeedMax = 4000; // $743
		PC.SpindleSpeedRound = 100;   // $745

		// FeedNumberFormat $750, 751 & 752
		pf = PC.FeedNumberFormat;
		pf.Format = AcamPostNumberFormat.acamPostNumberFormat6INTEGER;
		pf.LeadingFigures = 0;
		pf.FiguresAfterPoint = 0;
		Marshal.ReleaseComObject(pf);
		PC.FeedMax = 800; // $753
		PC.FeedRound = 10;   // $755

		// ToolNumberFormat $760, 761 & 762
		pf = PC.ToolNumberFormat;
		pf.Format = AcamPostNumberFormat.acamPostNumberFormat7INTEGER_LEAD_0;
		pf.LeadingFigures = 2;
		pf.FiguresAfterPoint = 0;
		Marshal.ReleaseComObject(pf);
		PC.RapidXYSpeed = 1500;    // $900
		PC.RapidZSpeed = 1500;     // $901
		PC.ToolChangeTime = 10;      // $902

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