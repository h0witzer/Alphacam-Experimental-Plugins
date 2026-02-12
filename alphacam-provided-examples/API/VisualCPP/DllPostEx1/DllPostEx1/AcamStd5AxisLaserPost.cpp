#include "stdafx.h"
#include "AcamStd5AxisLaserPost.h"

CString AcamStd5AxisLaserPost::GetPostName()
{
	return _T("Example 5-Axis Laser");
}

void AcamStd5AxisLaserPost::OutputFileLeadingLines(IPostDataPtr pPD)	// $10
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
void AcamStd5AxisLaserPost::OutputProgramLeadingLines(AlphaCAMMill::IPostDataPtr pPD)	// $12
{
    POST(":[PROGNUM]")
    POST("N[N] (PROGRAM PRODUCED  - [DATE])")
    POST("N[N] G90 G71")
    POST("N[N] G40 G80")	// [L_BRACKET]x[R_BRACKET]")
}
void AcamStd5AxisLaserPost::OutputProgramTrailingLines(AlphaCAMMill::IPostDataPtr pPD)	// $15
{
    POST("N[N] M30")
}
void AcamStd5AxisLaserPost::OutputFileTrailingLines(AlphaCAMMill::IPostDataPtr pPD)	// $17
{
	POST("%")
}
void AcamStd5AxisLaserPost::OutputRapid(AlphaCAMMill::IPostDataPtr pPD)	// $20, 21, 25
{
	IPostVariablesPtr V(pPD->Vars);
	int type = pPD->RapidType;
	switch(type)
	{
	case acamPostRapidTypeXY:
		POST("N[N] G0 X[AX] Y[AY]")
		break;
	case acamPostRapidTypeXYZ:
		POST("N[N] G0 X[AX] Y[AY] Z[AZ]")
		break;
	case acamPostRapidTypeZ:
		POST("N[N] G0 Z[AZ]")
		break;
	}
}
void AcamStd5AxisLaserPost::OutputUp(AlphaCAMMill::IPostDataPtr pPD)	// $30
{
	POST("M09    'Laser OFF")
}
void AcamStd5AxisLaserPost::OutputDown(AlphaCAMMill::IPostDataPtr pPD)	// $35
{
	POST("M08    'Laser ON")
}
void AcamStd5AxisLaserPost::OutputFeed(AlphaCAMMill::IPostDataPtr pPD)	// $40, 50, 60
{
   if(pPD->Element->Is5Axis)
	{
		POST("N[N] G1 X[AX] Y[AY] A[TWZ] B[TIZ] F[F] ' TAX: [TAX], [TAY], [TAZ]")
	}
	else if(pPD->FeedType == acamPostFeedTypeLINE)
	{
		pPD->Post("N[N] G1 X[AX] Y[AY] F[F]");
	}
	else if(pPD->FeedType == acamPostFeedTypeCWARC)
	{
		pPD->Post("N[N] G2 X[AX] Y[AY] R[R] F[F]");
	}
	else if(pPD->FeedType == acamPostFeedTypeCCWARC)
	{
		pPD->Post("N[N] G3 X[AX] Y[AY] R[R] F[F]");
	}
}
void AcamStd5AxisLaserPost::OutputSelectWorkPlane(AlphaCAMMill::IPostDataPtr pPD)	// $88
{
	POST("N[N] (WORK PLANE NAME = [WPN], OFFSET CODE = [WPO])")
}
void AcamStd5AxisLaserPost::OutputCallSub(AlphaCAMMill::IPostDataPtr pPD)	// $90
{
	POST("N[N] G22 P[SN]                  'CALL SUB [SN]")
}
void AcamStd5AxisLaserPost::OutputBeginSub(AlphaCAMMill::IPostDataPtr pPD)	// $100
{
	POST("N[N] $[SN]")
	POST("N[N] G0 X[AX] Y[AY]")
}
void AcamStd5AxisLaserPost::OutputEndSub(AlphaCAMMill::IPostDataPtr pPD)	// $110
{
	POST("N[N] G0 Z[AZ]")
	POST("N[N] G99")
}
void AcamStd5AxisLaserPost::OutputOriginShift(AlphaCAMMill::IPostDataPtr pPD)	// $120
{
	POST("N[N] G60 X[OX] Y[OY]            'ORIGIN SHIFT")
}
void AcamStd5AxisLaserPost::OutputCancelOriginShift(AlphaCAMMill::IPostDataPtr pPD)	// $130
{
	POST("N[N] G67              'CANCEL ORIGIN SHIFT")
}
void AcamStd5AxisLaserPost::OutputCutHoleCycleCancel(IPostDataPtr pPD)	// $400
{
	POST("N[N] G80")
}
void AcamStd5AxisLaserPost::OutputCutHoleCycleFirstHole(IPostDataPtr pPD)	// $410, 414, 420, 424, 430, 434
{
	AcamCutHolesType type = pPD->CutHoleType;
	CString g9899 = pPD->DrillRapidAtRPlane ? _T("G99") : _T("G98");
	CString str = _T("N[N] ") + g9899;
	switch(type)
	{
	case acamCutHolesPIERCE :
		POST_CSTRING(str + _T(" G81 X[AX] Y[AY] R[ZR] F[F] ' Hole Diam = [HD]"))
		break;
	case acamCutHolesCUT_HOLE :
		POST_CSTRING(str + _T(" G82 X[AX] Y[AY] R[ZR] F[F] ' Hole Diam = [HD], Number of Cuts = [NCT]"))
		break;
	case acamCutHolesSPIRAL :
		POST("SPIRAL CANNED CYCLE NOT AVAILABLE ' Hole Diam = [HD], Width of Cut = [WDC]")
		break;
	}
}
void AcamStd5AxisLaserPost::OutputCutHoleCycleNextHoles(IPostDataPtr pPD)	// $411, 415, 421, 425, 431, 435
{
	// Can use pPD->CutHoleType and pPD->DrillRapidAtRPlane if required
	POST("N[N] X[AX] Y[AY]")
}
// This is called only when the Post is first read by AlphaCAM
// eg on startup or if it is reselected
void AcamStd5AxisLaserPost::AfterOpenPost(AlphaCAMMill::IPostConfigurePtr pPC)
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
	pPC->FiveAxisToolHolderLength = 0; // $565
	pPC->FiveAxisToolMaxAngle = 90; // $570
	pPC->FiveAxisToolMaxAngleChange = 15; // $575
	pPC->AllowPositiveAndNegativeTilt = VARIANT_FALSE; // $577
	pPC->HorizontalMCCentre = VARIANT_FALSE; // $580
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

	// $750, 751, 752
	pPC->FeedNumberFormat->Format = acamPostNumberFormat6INTEGER;
	pPC->FeedNumberFormat->LeadingFigures = 0;
	pPC->FeedNumberFormat->FiguresAfterPoint = 0;

	pPC->FeedMax = 10000;	// $753
	//pPC->FeedRound = 10;	// $755

	// $760, 761, 762
	pPC->ToolNumberFormat->Format = acamPostNumberFormat7INTEGER_LEAD_0;
	pPC->ToolNumberFormat->LeadingFigures = 2;
	pPC->ToolNumberFormat->FiguresAfterPoint = 0;

	pPC->RapidXYSpeed = 25000;	// $900
	pPC->RapidZSpeed = 15000;	// $901
	pPC->ToolChangeTime = 30;	// $902

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

//int AcamStd5AxisLaserPost::FilterFunction(const char *buf, char **buf_new)
//{
//	CStringA str = buf;
//	str = "[" + str + "]";
//	*buf_new = _strdup(str);
//	return 0;
//}
