// Example Alphacam Wire Post, based on "Fanuc wire (2 or 4 axis).aep"
#include "stdafx.h"
#include "AcamStdWirePost.h"

CString AcamStdWirePost::GetPostName()
{
	return _T("Example Wire");
}

void AcamStdWirePost::OutputFileLeadingLines(IPostDataPtr pPD)	// $10
{
	POST_CSTRING(_T("'DllPostEx1 using VC++2013, ") + GetPostName())

	// Get the Alphacam version
	IDrawingPtr pDrw(pPD->Drawing);
	IAlphaCamAppPtr pApp(pDrw->App);
	IVersionInformationPtr pVer(pApp->AlphacamVersion);

	POST("'Alphacam Version: " + pVer->String)
	POST("%")
}
void AcamStdWirePost::OutputProgramLeadingLines(IPostDataPtr pPD)	// $12
{
	CString date = pPD->Vars->DAT;
	POST_CSTRING(_T("(PROGRAM PRODUCED  - ") + date.Left(9).MakeUpper() + _T(")"))
	POST(": [PROGNUM]")
	POST("N[N] G90 G71")
	POST("N[N] G40 G50")
	POST("N[N] G92 X[AX] Y[AY] I[EZA-EZP]")
}
void AcamStdWirePost::OutputProgramTrailingLines(IPostDataPtr pPD)	// $15
{
    POST("N[N] M30")
}
void AcamStdWirePost::OutputFileTrailingLines(IPostDataPtr pPD)	// $17
{
	POST("%")
}
void AcamStdWirePost::OutputRapid(IPostDataPtr pPD)	// $20
{
	POST("N[N] G0 X[AX] Y[AY]")
}
// Lines BEFORE a rapid move
void AcamStdWirePost::OutputUp(IPostDataPtr pPD)	// $30
{
}
// Lines AFTER a rapid move
void AcamStdWirePost::OutputDown(IPostDataPtr pPD)	// $35
{
	// Treat small values of ETA as zero.
	// Get the number of decimal places. (Easier to just store the value set in AfterOpenPost but this shows another way)
	// This will NOT work if this post is loaded as a OnePost, the PostConfigure object can not be accessed through the App
	IPostConfigurePtr pPC;
	try {pPC = pPD->Drawing->App->PostConfigure;} catch(_com_error e) {}

	int ndp = pPC ? pPC->XYZNumberFormat->FiguresAfterPoint : 3;
	double eta = pPD->Vars->ETA;
	if(fabs(eta) < 0.5 * pow(10., -ndp))
	{
		POST("N[N] G50")	// Wire vertical
	}
	else if(eta > 0)	// WIRE INCLINATION LEFT
	{
		POST("N[N] G51")
		POST("N[N] T[ETA]")
	}
	else if(eta < 0)	// WIRE INCLINATION RIGHT
	{
		POST("N[N] G52")
		POST("N[N] T[-ETA]")
	}
	POST("N[N] G92 X[AX] Y[AY] I[EZA-EZP]    'Start of cutting between Z[EZP] and Z[EZA]")
	POST("N[N] GEN[GEN], CTN[CTN], SIM[SIM], TNC[TNC], BDC[BDC]")
}
// Feed: Line, CW arc or CCW arc
void AcamStdWirePost::OutputFeed(IPostDataPtr pPD)	// $40, 50, 60
{
	if(pPD->FeedType == acamPostFeedTypeLINE)
	{
		IPostVariablesPtr V(pPD->Vars);
		if(V->MC && V->In) pPD->Post("N[N] G01 G90 [TC] X[AX] Y[AY] U[EU] V[EV] F[F]");	// M/C comp applies, and this is LEAD-IN Line
		else if(V->MC && V->Out) pPD->Post("N[N] G01 [TC] X[AX] Y[AY] U[EU] V[EV] F[F]");	// M/C comp applies, and this is LEAD-OUT Line
		else pPD->Post("N[N] G1 X[AX] Y[AY] U[EU] V[EV] F[F]");	// Applies to all other lines (with APS or M/C comp).
	}
	else if(pPD->FeedType == acamPostFeedTypeCWARC)
	{
		pPD->Post("N[N] G2 X[AX] Y[AY] I[II] J[IJ] U[EU] V[EV] K[EK] L[EL] F[F]");
	}
	else if(pPD->FeedType == acamPostFeedTypeCCWARC)
	{
		pPD->Post("N[N] G3 X[AX] Y[AY] I[II] J[IJ] U[EU] V[EV] K[EK] L[EL] F[F]");
	}
}
void AcamStdWirePost::OutputCallSub(IPostDataPtr pPD)	// $90
{
	POST("N[N] M98 P[SN]                  'CALL SUB [SN]")
}
void AcamStdWirePost::OutputBeginSub(IPostDataPtr pPD)	// $100
{
	POST(":[SN]                           'BEGIN SUB [SN]")
}
void AcamStdWirePost::OutputEndSub(IPostDataPtr pPD)	// $110
{
	POST("N[N] M99                        'END SUB [SN]")
}
void AcamStdWirePost::OutputOriginShift(IPostDataPtr pPD)	// $120
{
	POST("N[N] G52 X[OX] Y[OY]            'ORIGIN SHIFT")
}
void AcamStdWirePost::OutputCancelOriginShift(IPostDataPtr pPD)	// $130
{
	POST("N[N] G52 X0.0 Y0.0              'CANCEL ORIGIN SHIFT")
}
void AcamStdWirePost::OutputStop(IPostDataPtr pPD)	// $135
{
	POST("N[N] M00")
}
// This is called only when the Post is first read by AlphaCAM
// eg on startup or if it is reselected
void AcamStdWirePost::AfterOpenPost(IPostConfigurePtr pPC)
{
	// Example of accessing the Drawing and VersionInformation objects
	IDrawingPtr pDrw(pPC->Drawing);
	IAlphaCamAppPtr pApp(pDrw->App);
	IVersionInformationPtr pVer(pApp->AlphacamVersion);
	_bstr_t v(pVer->String);

	pPC->MCToolCompCancel = "G40"; // $140 for variable TC
	pPC->MCToolCompLeft = "G41"; // $141 for variable TC
	pPC->MCToolCompRight = "G42"; // $142 for variable TC
	pPC->MCToolCompOnRapidApproach = VARIANT_FALSE;	// $147
	pPC->ModalText = "G0 G1 G2 G3"; // $500
	pPC->ModalAbsoluteValues = "X Y F T"; // $502
	pPC->ModalIncrementalValues = "I J  U V K L"; // $504
	pPC->NeedPlusSigns = VARIANT_FALSE; // $510
	pPC->DecimalSeparator = acamPostDecimalSeparatorPOINT; // $515
	pPC->SubroutinesAtEnd = VARIANT_TRUE; // $520
	pPC->LimitArcs = acamPostLimitArcs180; // $525, 526
	pPC->PlanarArcsAsLines = acamPostPlanarArcsAsLinesNONE; // $530
	pPC->MaximumArcRadius = 0; // $531
	pPC->ArcChordTolerance = 0.1; // $532
   pPC->CAxisArcsAndLinesAsLines = acamPostCAxisLinesNONE;   // $533
	pPC->SuppressComments = VARIANT_FALSE; // $540
	pPC->AllowOutputVisibleOnly = VARIANT_TRUE; // $545

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

	pPC->FeedMax = 2000;	// $753
	//pPC->FeedRound = 10;	// $755

   pPC->RapidXYSpeed = 1500; // $900

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
}
