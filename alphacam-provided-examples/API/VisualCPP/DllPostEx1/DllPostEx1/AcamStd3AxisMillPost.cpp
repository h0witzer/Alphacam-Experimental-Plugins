#include "stdafx.h"
#include "AcamStd3AxisMillPost.h"

CString AcamStd3AxisMillPost::GetPostName()
{
	return _T("Example 3-Axis Mill");
}

void AcamStd3AxisMillPost::OutputFileLeadingLines(IPostDataPtr pPD)	// $10
{
	POST_CSTRING(_T("'DllPostEx1 using VC++2013, ") + GetPostName())

	// Get the Alphacam version
	IDrawingPtr pDrw(pPD->Drawing);
	IAlphaCamAppPtr pApp(pDrw->App);
	IVersionInformationPtr pVer(pApp->AlphacamVersion);

	POST("'Alphacam Version: " + pVer->String)
	POST("$LET DATE = DAT")
	POST("%")	
}
void AcamStd3AxisMillPost::OutputProgramLeadingLines(AlphaCAMMill::IPostDataPtr pPD)	// $12
{
    POST(":[PROGNUM]")
    POST("N[N] (PROGRAM PRODUCED  - [DATE])")
    POST("N[N] G90 G71")
    POST("N[N] G40 G80")	// [L_BRACKET]x[R_BRACKET]")
}
void AcamStd3AxisMillPost::OutputProgramTrailingLines(AlphaCAMMill::IPostDataPtr pPD)	// $15
{
    POST("N[N] M30")
}
void AcamStd3AxisMillPost::OutputFileTrailingLines(AlphaCAMMill::IPostDataPtr pPD)	// $17
{
	POST("%")
}
void AcamStd3AxisMillPost::OutputRapid(AlphaCAMMill::IPostDataPtr pPD)	// $20, 21, 25
{
	IPostVariablesPtr V(pPD->Vars);
	CString comp;
	int type = pPD->RapidType;
	switch(type)
	{
	case acamPostRapidTypeXY:
		if(V->MC)	// True here only if comp on rapid selected
			comp = CString(static_cast<const TCHAR*>(V->TC)) + _T(" ");
		if(first_rapid)
		{
			first_rapid = false;
			POST_CSTRING(_T("N[N] G0 ") + comp + _T("X[AX] Y[AY]"))
			POST("N[N] G0 G43 Z[AZ] H[T] [CLT]")	// G43 = Tool Length Comp, CLT = Coolant code.
		}
		else
		{
			POST_CSTRING(_T("N[N] G0 ") + comp + _T("X[AX] Y[AY]"))
		}
		break;
	case acamPostRapidTypeXYZ:
		POST("N[N] G0 X[AX] Y[AY] Z[AZ]")
		break;
	case acamPostRapidTypeZ:
		if(!first_rapid)	// No NC code if this is the first move in Z after tool change.
		{
			if(V->FRA && V->MC) comp = CString(static_cast<const TCHAR*>(V->TC)) + _T(" ");
			POST_CSTRING(_T("N[N] G0 ") + comp + _T("Z[AZ]"))
		}
		break;
	}
}
void AcamStd3AxisMillPost::OutputUp(AlphaCAMMill::IPostDataPtr pPD)	// $30
{
}
void AcamStd3AxisMillPost::OutputDown(AlphaCAMMill::IPostDataPtr pPD)	// $35
{
}
void AcamStd3AxisMillPost::OutputFeed(AlphaCAMMill::IPostDataPtr pPD)	// $40, 50, 60
{
	if(pPD->FeedType == acamPostFeedTypeLINE)
	{
		IPostVariablesPtr V(pPD->Vars);
		if(V->MC && V->In) pPD->Post("N[N] G1 [TC] D[T+10] X[AX] Y[AY] Z[AZ] F[F]");
		else if(V->MC && V->Out) pPD->Post("N[N] G1 [TC] X[AX] Y[AY] Z[AZ] F[F]");
		else pPD->Post("N[N] G1 X[AX] Y[AY] Z[AZ] F[F]");
	}
	else if(pPD->FeedType == acamPostFeedTypeCWARC)
	{
		pPD->Post("N[N] G2 X[AX] Y[AY] Z[AZ] R[R] F[F]");
	}
	else if(pPD->FeedType == acamPostFeedTypeCCWARC)
	{
		pPD->Post("N[N] G3 X[AX] Y[AY] Z[AZ] R[R] F[F]");
	}
}
void AcamStd3AxisMillPost::OutputCancelTool(AlphaCAMMill::IPostDataPtr pPD)	// $70
{
	POST("N[N] M09")
}
void AcamStd3AxisMillPost::OutputSelectTool(AlphaCAMMill::IPostDataPtr pPD)	// $80
{
	POST("N[N] T[T][OFS] [ROT]       'Select tool and offset")
   POST("N[N] S[S] H[OFS] M06       'Next tool is [NT], Next XY is [NX], [NY]")
	first_rapid = true;
}
void AcamStd3AxisMillPost::OutputSelectWorkPlane(AlphaCAMMill::IPostDataPtr pPD)	// $88
{
	POST("N[N] (WORK PLANE NAME = [WPN], OFFSET CODE = [WPO])")
}
void AcamStd3AxisMillPost::OutputSelectToolAndWorkPlane(AlphaCAMMill::IPostDataPtr pPD)	// $89
{
	POST("' Change Tool and Work Plane at same time")
}
void AcamStd3AxisMillPost::OutputCallSub(AlphaCAMMill::IPostDataPtr pPD)	// $90
{
	POST("N[N] M98 P[SN]                  'CALL SUB [SN]")
}
void AcamStd3AxisMillPost::OutputBeginSub(AlphaCAMMill::IPostDataPtr pPD)	// $100
{
	POST(":[SN]                           'BEGIN SUB [SN]")
}
void AcamStd3AxisMillPost::OutputEndSub(AlphaCAMMill::IPostDataPtr pPD)	// $110
{
	POST("N[N] M99                        'END SUB [SN]")
}
void AcamStd3AxisMillPost::OutputOriginShift(AlphaCAMMill::IPostDataPtr pPD)	// $120
{
	POST("N[N] G52 X[OX] Y[OY]            'ORIGIN SHIFT")
}
void AcamStd3AxisMillPost::OutputCancelOriginShift(AlphaCAMMill::IPostDataPtr pPD)	// $130
{
	POST("N[N] G52 X0.0 Y0.0              'CANCEL ORIGIN SHIFT")
}
void AcamStd3AxisMillPost::OutputMoveClamp(AlphaCAMMill::IPostDataPtr pPD)	// $133
{
    pPD->ModalOff("");
    POST("'Move clamp# [MCN], X[CAX] Y[CAY], Z[CAZ], C[CLA] ([CLN])")
}
void AcamStd3AxisMillPost::OutputDrillCycleCancel(AlphaCAMMill::IPostDataPtr pPD)	// $200
{
	POST("N[N] M09    ''Turn coolant OFF")
	POST("N[N] G80")
}
void AcamStd3AxisMillPost::OutputFirstHoleSub(AlphaCAMMill::IPostDataPtr pPD)	// $205
{
   POST("N[N] X[AX] Y[AY]")
}
void AcamStd3AxisMillPost::OutputNextHoleSub(AlphaCAMMill::IPostDataPtr pPD)	// $206
{
	POST("N[N] X[AX] Y[AY]")
}
void AcamStd3AxisMillPost::OutputDrillCycleFirstHole(AlphaCAMMill::IPostDataPtr pPD)	// $210, 214, 220, 224, 230, 234, 240, 244
{
	CString g9899 = pPD->DrillRapidAtRPlane ? _T("G99") : _T("G98");
	switch(pPD->DrillType)
	{
	case acamPostDrillTypeDRILL :
        POST_CSTRING(_T("N[N] ") + g9899 + _T(" G81 X[AX] Y[AY] Z[ZB] R[ZR] F[F] [CLT]")) break;
	case acamPostDrillTypePECK :
        POST_CSTRING(_T("N[N] ") + g9899 + _T(" G83 X[AX] Y[AY] Z[ZB] R[ZR] Q[ZP] F[F] [CLT]")) break;
	case acamPostDrillTypeTAP :
        POST_CSTRING(_T("N[N] ") + g9899 + _T(" G84 X[AX] Y[AY] Z[ZB] R[ZR] F[F] [CLT]")) break;
	case acamPostDrillTypeBORE :
        POST_CSTRING(_T("N[N] ") + g9899 + _T(" G82 X[AX] Y[AY] Z[ZB] R[ZR] P[DW] F[F] [CLT]")) break;
	}
}
void AcamStd3AxisMillPost::OutputDrillCycleNextHoles(AlphaCAMMill::IPostDataPtr pPD)	// $211, 215, 221, 225, 231, 235, 241, 245
{
    POST("N[N] X[AX] Y[AY]")
}
void AcamStd3AxisMillPost::OutputDrillCycleSubParameters(AlphaCAMMill::IPostDataPtr pPD)	// $212, 216, 222, 226, 232, 236, 242, 246
{
	CString g9899 = pPD->DrillRapidAtRPlane ? _T("G99") : _T("G98");
	switch(pPD->DrillType)
	{
	case acamPostDrillTypeDRILL :
        POST_CSTRING(_T("N[N] ") + g9899 + _T(" G81 Z[ZB] R[ZR] F[F] [CLT]")) break;
	case acamPostDrillTypePECK :
        POST_CSTRING(_T("N[N] ") + g9899 + _T(" G83 Z[ZB] R[ZR] Q[ZP] F[F] [CLT]")) break;
	case acamPostDrillTypeTAP :
        POST_CSTRING(_T("N[N] ") + g9899 + _T(" G84 Z[ZB] R[ZR] F[F] [CLT]")) break;
	case acamPostDrillTypeBORE :
        POST_CSTRING(_T("N[N] ") + g9899 + _T(" G82 Z[ZB] R[ZR] P[DW] F[F] [CLT]")) break;
	}
}
// This is called only when the Post is first read by AlphaCAM
// eg on startup or if it is reselected
void AcamStd3AxisMillPost::AfterOpenPost(AlphaCAMMill::IPostConfigurePtr pPC)
{
	// Example of accessing the Drawing and VersionInformation objects
	IDrawingPtr pDrw(pPC->Drawing);
	IAlphaCamAppPtr pApp(pDrw->App);
	IVersionInformationPtr pVer(pApp->AlphacamVersion);
	_bstr_t v(pVer->String);

	pPC->CWSpindleRotation = "M03"; // $75
	pPC->CCWSpindleRotation = "M04"; // $76
	pPC->MCToolCompCancel = "G40"; // $140
	pPC->MCToolCompLeft = "G41"; // $141
	pPC->MCToolCompRight = "G42"; // $142
	pPC->MCToolCompOnRapidApproach = VARIANT_TRUE;	// $147
	pPC->CoolantOff = "M09"; // $150
	pPC->CoolantMist = "M07"; // $151
	pPC->CoolantFlood = "M08"; // $152
	pPC->CoolantThroughTool = "M10"; // $153
	pPC->ModalText = "G0 G1 G2 G3"; // $500
	pPC->ModalAbsoluteValues = "X Y Z F"; // $502
	pPC->ModalIncrementalValues = "I J"; // $504
	pPC->NeedPlusSigns = VARIANT_FALSE; // $510
	pPC->DecimalSeparator = acamPostDecimalSeparatorPOINT; // $515
	pPC->SubroutinesAtEnd = VARIANT_TRUE; // $520
	pPC->LimitArcs = acamPostLimitArcs180; // $525, 526
	pPC->HelicalArcsAsLines = VARIANT_FALSE; // $527
	pPC->PlanarArcsAsLines = acamPostPlanarArcsAsLinesNONE; // $530
	pPC->MaximumArcRadius = 0; // $531
	pPC->ArcChordTolerance = 0.1; // $532
	pPC->SuppressComments = VARIANT_FALSE; // $540
	pPC->AllowOutputVisibleOnly = VARIANT_TRUE; // $545
	pPC->FiveAxisProgramPivot = VARIANT_FALSE; // $560
	pPC->FiveAxisOffsetFromPivotPointX = 0; // $562
	pPC->FiveAxisOffsetFromPivotPointY = 0; // $563
	pPC->FiveAxisToolHolderLength = 100; // $565
	pPC->FiveAxisToolMaxAngle = 0; // $570
	pPC->FiveAxisToolMaxAngleChange = 15; // $575
	pPC->AllowPositiveAndNegativeTilt = VARIANT_FALSE; // $577
	pPC->HorizontalMCCentre = VARIANT_FALSE; // $580
	pPC->SelectWpToolOrder = acamPostSelectWpToolOrderTOOL_FIRST; // $582
	pPC->LocalXorYAxis = acamPostLocalXorYAxisNONE; // $584
	pPC->Allow5AxisHelicalArcs = VARIANT_FALSE; // $585

	// $700, 701, 702
	pPC->SubroutineNumberFormat->Format = acamPostNumberFormat6INTEGER;
	pPC->SubroutineNumberFormat->LeadingFigures = 0;
	pPC->SubroutineNumberFormat->FiguresAfterPoint = 0;

   pPC->SubroutineStartNumber = 1;	// $705

	// $710, 711, 712
	pPC->LineNumberFormat->Format = acamPostNumberFormat6INTEGER;
	pPC->LineNumberFormat->LeadingFigures = 0;
	pPC->LineNumberFormat->FiguresAfterPoint = 0;

	pPC->LineStartNumber = 10;	// $715
	pPC->LineNumberIncrement = 10;	// $716

	// $720, 721, 722
	pPC->XYZNumberFormat->Format = acamPostNumberFormat2DECIMAL_NO_0;
	pPC->XYZNumberFormat->LeadingFigures = 0;
	pPC->XYZNumberFormat->FiguresAfterPoint = 3;

	// $730, 731, 732
	pPC->ArcCentreNumberFormat->Format = acamPostNumberFormat2DECIMAL_NO_0;
	pPC->ArcCentreNumberFormat->LeadingFigures = 0;
	pPC->ArcCentreNumberFormat->FiguresAfterPoint = 3;

	// $740, 741, 742
	pPC->SpindleSpeedNumberFormat->Format = acamPostNumberFormat6INTEGER;
	pPC->SpindleSpeedNumberFormat->LeadingFigures = 0;
	pPC->SpindleSpeedNumberFormat->FiguresAfterPoint = 0;
	
	pPC->SpindleSpeedMax = 4000;	// $743
   //pPC->SetFixedSpindleSpeeds("1000, 2000");	// $744
	pPC->SpindleSpeedRound = 100;	// $745

	// $750, 751, 752
	pPC->FeedNumberFormat->Format = acamPostNumberFormat6INTEGER;
	pPC->FeedNumberFormat->LeadingFigures = 0;
	pPC->FeedNumberFormat->FiguresAfterPoint = 0;

	pPC->FeedMax = 800;	// $753
	pPC->FeedRound = 10;	// $755

	// $760, 761, 762
	pPC->ToolNumberFormat->Format = acamPostNumberFormat7INTEGER_LEAD_0;
	pPC->ToolNumberFormat->LeadingFigures = 2;
	pPC->ToolNumberFormat->FiguresAfterPoint = 0;

	pPC->RapidXYSpeed = 1500;	// $900
	pPC->RapidZSpeed = 1500;	// $901
	pPC->ToolChangeTime = 10;	// $902

	{
		IPostUserVariablePtr UV = pPC->AddUserVariable();
		UV->Name = "L_BRACKET";
		UV->Format->Format = acamPostNumberFormatTEXT;
		UV->Text= "[";
	}
	{
		IPostUserVariablePtr UV = pPC->AddUserVariable();
		UV->Name = "R_BRACKET";
		UV->Format->Format = acamPostNumberFormatTEXT;
		UV->Text= "]";
	}
	{
		IPostUserVariablePtr UV = pPC->AddUserVariable();
		UV->Name = "DATE";
		UV->Format->Format = acamPostNumberFormatTEXT_TRUNCATE;
		UV->Format->LeadingFigures = 9;
	}
	{
		IPostUserVariablePtr UV = pPC->AddUserVariable();
		UV->Name = "PROGNUM";
		UV->Format->Format = acamPostNumberFormat7INTEGER_LEAD_0;
		UV->Format->LeadingFigures = 4;
		UV->Prompt = "Program Number";
	}
	{
		IPostUserVariablePtr UV = pPC->AddUserVariable();
		UV->Name = "XVAL";
		UV->Format->Format = acamPostNumberFormat2DECIMAL_NO_0;
		UV->Format->FiguresAfterPoint = 4;
	}
	//pPC->SetAttributeIndex(101, ATTR_TEST1);
}

//int AcamStd3AxisMillPost::FilterFunction(const char *buf, char **buf_new)
//{
//	CStringA str = buf;
//	str = "[" + str + "]";
//	*buf_new = _strdup(str);
//	return 0;
//}
