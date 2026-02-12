#include "stdafx.h"
#include "AcamStdLathePost.h"

#ifdef _DEBUG
#define DEBUG_MODE
#endif

CString AcamStdLathePost::GetPostName()
{
	return _T("Example Lathe");
}

void AcamStdLathePost::OutputFileLeadingLines(IPostDataPtr pPD)	// $10
{
	POST_CSTRING(_T("'DllPostEx1 using VC++2013, ") + GetPostName())

	// Get the Alphacam version
	IDrawingPtr pDrw(pPD->Drawing);
	IAlphaCamAppPtr pApp(pDrw->App);
	IVersionInformationPtr pVer(pApp->AlphacamVersion);

	OldWP = 0;
	FirstRapid = true;
	POST("'Alphacam Version: " + pVer->String)
	POST("%")
	ShowToolChangePos(pPD);
}
void AcamStdLathePost::OutputProgramLeadingLines(IPostDataPtr pPD)	// $12
{
	CString date = pPD->Vars->DAT;
	POST_CSTRING(_T("(PROGRAM PRODUCED  - ") + date.Left(9).MakeUpper() + _T(")"))
	POST(": [PROGNUM]")
	POST("N[N] G21 G80 G40")
	POST("N[N] G50 S[MS] M42")
}
void AcamStdLathePost::OutputProgramTrailingLines(IPostDataPtr pPD)	// $15
{
    POST("N[N] M30")
}
void AcamStdLathePost::OutputFileTrailingLines(IPostDataPtr pPD)	// $17
{
	POST("%")
}
// Rapid: 2 Axis Turning
void AcamStdLathePost::OutputLatheRapid(IPostDataPtr pPD)	// $20
{
#ifdef DEBUG_MODE
	POST("$20")
#endif
	IPostVariablesPtr V(pPD->Vars);
	if(FirstRapid)
		FirstRapid = false;
	else if(pPD->Vars->FTC)
		POST("N[N] G0 X[AD] Z[AZ] [CLT]")
	else if(pPD->Vars->TTC)
		POST("N[N] G0 X[AD] Z[AZ] M09")
	else
		POST("N[N] G0 X[AD] Z[AZ]")
}
// Rapid: C or Y Axis
void AcamStdLathePost::OutputRapid(IPostDataPtr pPD)	// $27, 28
{
#ifdef DEBUG_MODE
	POST("$27, $28")
#endif
	POST("N[N] G1 X[AD] Z[AZ] C[AC] F4000")
}
void AcamStdLathePost::OutputUp(IPostDataPtr pPD)	// $30
{
}
void AcamStdLathePost::OutputDown(IPostDataPtr pPD)	// $35
{
}
// Feed: 2 Axis Turning
void AcamStdLathePost::OutputLatheFeed(IPostDataPtr pPD)	// $40, 50, 60
{
#ifdef DEBUG_MODE
	POST("$40, $50, $60")
#endif
	switch(pPD->FeedType)
	{
		case acamPostFeedTypeLINE :
			if(pPD->Vars->MC && pPD->Vars->In)
				POST("N[N] G1 [TC] X[AD] Z[AZ] F[F]")
			else if(pPD->Vars->MC && pPD->Vars->Out)
				POST("N[N] G1 [TC] X[AD] Z[AZ] F[F]")
			else
				POST("N[N] G1 X[AD] Z[AZ] F[F]")
			break;
		case acamPostFeedTypeCWARC :
			POST("N[N] G2 X[AD] Z[AZ] R[R] F[F]")
			break;
		case acamPostFeedTypeCCWARC :
			POST("N[N] G3 X[AD] Z[AZ] R[R] F[F]")
			break;
	}
}
// C or Y Axis
// CWP = Current Work Plane:
// 0 = 2-AXIS Turning, 1 = XY, 2 = XZ, 3 = YZ, 4 = 3D, 5 = C-Ax Developed
// pPD->MoveType = acamPostMoveTypeC for C-Axis, acamPostMoveTypeY for Y-Axis
void AcamStdLathePost::OutputFeed(IPostDataPtr pPD)	// $47, 48, 57, 58, 67, 68
{
#ifdef DEBUG_MODE
	POST("$47, $48, $57, $58, $67, $68")
#endif
	// POST("Tax: [TAX], [TAY], [TAZ]")
    if(pPD->MoveType == acamPostMoveTypeC)
	 {
        // C-Axis
        if(pPD->Vars->CWP != 5)
		  {
            switch(pPD->FeedType)
				{
					case acamPostFeedTypeLINE :
					if(pPD->Vars->MC && (pPD->Vars->In || pPD->Vars->Out))
						 POST("N[N] G1 [TC] X[AX] C[AY] Z[AZ] F[F]")
					else
						 POST("N[N] G1 X[AX] C[AY] Z[AZ] F[F]")
					break;
					case acamPostFeedTypeCWARC :
						 POST("N[N] G2 X[AX] C[AY] Z[AZ] R[R] F[F]")
					break;
					case acamPostFeedTypeCCWARC :
						 POST("N[N] G3 X[AX] C[AY] Z[AZ] R[R] F[F]")
					break;
            }
		  }
        else
		  {
            // CWP == 5, C-Ax developed
            switch(pPD->FeedType)
				{
				case acamPostFeedTypeLINE :
						 if(pPD->Vars->MC && (pPD->Vars->In || pPD->Vars->Out)) // M/C comp applies, and this is LEAD-In or Out LIne
							  POST("N[N] G1 [TC] X[AD] C[AC] Z[AZ] F[F]")
						 else    // Applies to all other lInes (with APS or M/C comp).
							  POST("N[N] G1 X[AD] C[AC] Z[AZ] F[F]")
				break;
				case acamPostFeedTypeCWARC :
						 POST("N[N] G3 X[AD] C[AC] Z[AZ] R[R] F[F]")
				break;
				case acamPostFeedTypeCCWARC :
						 POST("N[N] G2 X[AD] C[AC] Z[AZ] R[R] F[F]")
				break;
				}
			}
	 }
    else
	 {
        // Y-Axis
        switch(pPD->FeedType)
		  {
		  case acamPostFeedTypeLINE :
			  if(pPD->Vars->MC && (pPD->Vars->In || pPD->Vars->Out))
					POST("N[N] G1 [TC] X[AX] Y[AY] Z[AZ] C[AC] F[F]")
			  else
					POST("N[N] G1 X[AX] Y[AY] Z[AZ] C[AC] F[F]")
			  break;
		  case acamPostFeedTypeCWARC :
				POST("N[N] G2 X[AX] Y[AY] Z[AZ] C[AC] R[R] F[F]")
				break;
		  case acamPostFeedTypeCCWARC :
					POST("N[N] G3 X[AX] Y[AY] Z[AZ] C[AC] R[R] F[F]")
				break;
        }
	 }
}
void AcamStdLathePost::OutputThread(IPostDataPtr pPD)	// $42
{
	POST("N[N] G32 X[AD] Z[AZ] F[F]")
}
void AcamStdLathePost::OutputCancelTool(IPostDataPtr pPD)	// $70
{
	POST("N[N] T[T]00")
}
// 2-AXIS Turning Tool (inc. Centre Drilling)
void AcamStdLathePost::OutputSelectLatheTool(IPostDataPtr pPD)  // $80
{
#ifdef DEBUG_MODE
	POST("N[N] OPN = [OPN], OSN = [OSN], OPG = [OPG]")
#endif
	POST("N[N] G0 T[T][OFS]   'Select TOOL [T] and OFFSET Number [OFS]")
	POST("N[N] G50 (X... Z...)    'Enter tool reference values at machine")
	POST("N[N] G50 S[MS]")	// MS = Maximum Spindle Speed
	POST("N[N] [CS] S[S] [RT] [FP]")
#ifdef DEBUG_MODE
	POST("TNT = [TNT], TPD1 = [TPD(1)], TPD2 = [TPD(2)], TPD3 = [TPD(3)]")
	POST("OOT = [OOT] ' $80")
#endif
	ShowToolChangePos(pPD);
}
// Select new DRIVEN tool for C-axis Milling and Drilling
void AcamStdLathePost::OutputSelectTool(IPostDataPtr pPD)	// $84
{
	POST("N[N] OPN = [OPN], OSN = [OSN], OPG = [OPG]")
	POST("N[N] T[T][OFS]  ' Select MILLING TOOL type [TT], fp = [FP]")
	ShowToolChangePos(pPD);
}
void AcamStdLathePost::OutputChangeProgPoint(IPostDataPtr pPD)	// $86
{
	POST("OutputChangeProgPoint")
}
// SYN=Sync Number
// TAB = 1 if Turret Above Centre Line,  = 2 if Turret is Below Centre Line
//  TFB = 1 if Turret is at Front (Conventional), = 2 if Turret is at Back
void AcamStdLathePost::OutputSetSyncPoint(IPostDataPtr pPD)    // $87
{
	int syn = int(pPD->Vars->SYN);
	if(pPD->Vars->TAB == 1)	// Turret is Above C/L
		POST("N[N] P[SYN]")
	else							// Turret is Below C/L
		POST("N[N] Q[SYN]")
}
// CWP = Current Work Plane:
// 0 = 2-AXIS Turning, 1 = XY, 2 = XZ, 3 = YZ, 4 = 3D, 5 = C-Ax Developed
// OPT = 1 for 2-AX TURN OR C-AX MILL, = 2 for C-AX DRILL/TAP ETC
void AcamStdLathePost::OutputSelectWorkPlane(IPostDataPtr pPD)	// $88
{
    int CWP = int(pPD->Vars->CWP);
    if(pPD->Vars->OPT != 2 && CWP != OldWP)
	 {
        if(CWP == 0)
            POST("N[N] M49")                    // 2-AXIS TURNING
        else if(CWP == 1)
            POST("N[N] G112")
        else if(CWP < 4)
            POST("N[N] G[CWP + 16]")
        else if(CWP == 5)
		  {
            POST("N[N] G18 H0 W0")              // DDP = Diameter of Developed Plane
            POST("N[N] G107 C[DDP / 2]        ' Part Diameter = [DDP]")
		  }
        OldWP = CWP;
	 }
}
void AcamStdLathePost::OutputSelectToolAndWorkPlane(IPostDataPtr pPD)	// $89
{
	POST("' Change Tool and Work Plane at same time")
}
void AcamStdLathePost::OutputCallSub(IPostDataPtr pPD)	// $90
{
	POST("N[N] M98 P[SN]                  'CALL SUB [SN]")
}
void AcamStdLathePost::OutputBeginSub(IPostDataPtr pPD)	// $100
{
	POST(":[SN]                           'BEGIN SUB [SN]")
}
void AcamStdLathePost::OutputEndSub(IPostDataPtr pPD)	// $110
{
	POST("N[N] M99                        'END SUB [SN]")
}
void AcamStdLathePost::OutputOriginShift(IPostDataPtr pPD)	// $120
{
	POST("N[N] G52 X[OX] Y[OY]            'ORIGIN SHIFT")
}
void AcamStdLathePost::OutputCancelOriginShift(IPostDataPtr pPD)	// $130
{
	POST("N[N] G52 X0.0 Y0.0              'CANCEL ORIGIN SHIFT")
}
void AcamStdLathePost::OutputMoveClamp(IPostDataPtr pPD)	// $133
{
    pPD->ModalOff("");
    POST("'Move clamp# [MCN], X[CAX] Y[CAY], Z[CAZ], C[CLA] ([CLN])")
}
void AcamStdLathePost::OutputDrillCycleCancel(IPostDataPtr pPD)	// $200
{
	POST("N[N] G80")
}
void AcamStdLathePost::OutputFirstHoleSub(IPostDataPtr pPD)	// $205
{
   POST("N[N] X[AX] Y[AY]")
}
void AcamStdLathePost::OutputNextHoleSub(IPostDataPtr pPD)	// $206
{
	POST("N[N] X[AX] Y[AY]")
}
void AcamStdLathePost::OutputDrillCycleFirstHole(IPostDataPtr pPD)	// $210, 214, 220, 224, 230, 234, 240, 244
{
    int CWP = int(pPD->Vars->CWP);
    switch(pPD->DrillType)
	 {
	 case acamPostDrillTypeDRILL :
            if(!pPD->DrillRapidAtRPlane)
				{
                if(CWP == 1) // X-Y PLANE - HOLES ARE ON A FACE
                    POST("N[N] G98 G83 X[AD] C[AC] Z[AZ + ZB] R[AZ + ZR] F[F]")
                else if(CWP == 5) // HOLES ARE ON A DEVELOPED DIAMETER
					 {
                    POST("N[N] G80 G0 X[DDP + (ZS*2)]")
                    POST("N[N] G98 G87 Z[AZ] C[AC] X[DDP+(ZB*2)] R[ZR-ZS] F[F]")
					 }
                else    // HOLES MUST BE Y-AXIS  (OR B-AXIS)
                    POST("N[N] G98 G87 Z[AZ] C[AC] X[AX+ZB] Y[AY] R[ZR-ZS] F[F]")
				}                
            else    // Traverse at retract level
				{
                if(CWP == 1) // X-Y PLANE - HOLES ARE ON A FACE
                    POST("N[N] G99 G83 X[AD] C[AC] Z[AZ + ZB] R0. F[F]")
                else if(CWP == 5) // HOLES ARE ON A DEVELOPED DIAMETER
                    POST("N[N] G99 G87 Z[AZ] C[AC] X[DDP+(ZB*2)] R0. F[F]")
                else    // HOLES MUST BE Y-AXIS  (OR B-AXIS)
                    POST("N[N] G99 G87 Z[AZ] C[AC] X[AX+ZB] Y[AY] R0. F[F]")
				}
				break;
	 case acamPostDrillTypePECK :
            if(!pPD->DrillRapidAtRPlane)
				{
                if(CWP == 1) // X-Y PLANE - HOLES ARE ON A FACE
                    POST("N[N] G98 G83 X[AD] C[AC] Z[AZ + ZB] R[AZ + ZR] Q[ZP] F[F]")
                else if(CWP == 5) // HOLES ARE ON A DEVELOPED DIAMETER
					 {
                    POST("N[N] G80 G0 X[DDP + (ZS*2)]")
                    POST("N[N] G98 G87 Z[AZ] C[AC] X[DDP+(ZB*2)] R[ZR-ZS] Q[ZP] F[F]")
					 }
                else    // HOLES MUST BE Y-AXIS  (OR B-AXIS)
                    POST("N[N] G98 G87 Z[AZ] C[AC] X[AX+ZB] Y[AY] R[ZR-ZS] Q[ZP] F[F]")
				}                
            else    // Traverse at retract level
				{
                if(CWP == 1) // X-Y PLANE - HOLES ARE ON A FACE
                    POST("N[N] G99 G83 X[AD] C[AC] Z[AZ + ZB] R0. Q[ZP] F[F]")
                else if(CWP == 5) // HOLES ARE ON A DEVELOPED DIAMETER
                    POST("N[N] G99 G87 Z[AZ] C[AC] X[DDP+(ZB*2)] R0. Q[ZP] F[F]")
                else    // HOLES MUST BE Y-AXIS  (OR B-AXIS)
                    POST("N[N] G99 G87 Z[AZ] C[AC] X[AX+ZB] Y[AY] R0. Q[ZP] F[F]")
				}
				break;
	 case acamPostDrillTypeTAP :
            if(!pPD->DrillRapidAtRPlane)
				{
                if(CWP == 1) // X-Y PLANE - HOLES ARE ON A FACE
                    POST("N[N] G98 G84 X[AD] C[AC] Z[AZ + ZB] R[AZ + ZR] F[F]")
                else if(CWP == 5) // HOLES ARE ON A DEVELOPED DIAMETER
					 {
                    POST("N[N] G80 G0 X[DDP + (ZS*2)]")
                    POST("N[N] G98 G87 Z[AZ] C[AC] X[DDP+(ZB*2)] R[ZR-ZS] F[F]")
					 }
                else    // HOLES MUST BE Y-AXIS  (OR B-AXIS)
                    POST("N[N] G98 G87 Z[AZ] C[AC] X[AX+ZB] Y[AY] R[ZR-ZS] F[F]")
				}                
            else    // Traverse at retract level
				{
                if(CWP == 1) // X-Y PLANE - HOLES ARE ON A FACE
                    POST("N[N] G99 G84 X[AD] C[AC] Z[AZ + ZB] R0. F[F]")
                else if(CWP == 5) // HOLES ARE ON A DEVELOPED DIAMETER
                    POST("N[N] G99 G84 Z[AZ] C[AC] X[DDP+(ZB*2)] R0. F[F]")
                else    // HOLES MUST BE Y-AXIS  (OR B-AXIS)
                    POST("N[N] G99 G84 Z[AZ] C[AC] X[AX+ZB] Y[AY] R0. F[F]")
				}
				break;
	 case acamPostDrillTypeBORE :
            if(!pPD->DrillRapidAtRPlane)
				{
                if(CWP == 1) // X-Y PLANE - HOLES ARE ON A FACE
                    POST("N[N] G98 G83 X[AD] C[AC] Z[AZ + ZB] R[AZ + ZR] P[DW] F[F]")
                else if(CWP == 5) // HOLES ARE ON A DEVELOPED DIAMETER
					 {
                    POST("N[N] G80 G0 X[DDP + (ZS*2)]")
                    POST("N[N] G98 G87 Z[AZ] C[AC] X[DDP+(ZB*2)] R[ZR-ZS] P[DW] F[F]")
					 }
                else    // HOLES MUST BE Y-AXIS  (OR B-AXIS)
                    POST("N[N] G98 G87 Z[AZ] C[AC] X[AX+ZB] Y[AY] R[ZR-ZS] P[DW] F[F]")
				}                
            else    // Traverse at retract level
				{
                if(CWP == 1) // X-Y PLANE - HOLES ARE ON A FACE
                    POST("N[N] G99 G83 X[AD] C[AC] Z[AZ + ZB] R0. P[DW] F[F]")
                else if(CWP == 5) // HOLES ARE ON A DEVELOPED DIAMETER
                    POST("N[N] G99 G87 Z[AZ] C[AC] X[DDP+(ZB*2)] R0. P[DW] F[F]")
                else    // HOLES MUST BE Y-AXIS  (OR B-AXIS)
                    POST("N[N] G99 G87 Z[AZ] C[AC] X[AX+ZB] Y[AY] R0. P[DW] F[F]")
				}
				break;
	 }
}
void AcamStdLathePost::OutputDrillCycleNextHoles(IPostDataPtr pPD)	// $211, 215, 221, 225, 231, 235, 241, 245
{
    int CWP = int(pPD->Vars->CWP);
    if(CWP == 1)
        POST("N[N] X[AD] C[AC]")
    else if(CWP == 5)
        POST("N[N] Z[AZ] C[AC]")
    else
        POST("N[N] Z[AZ] Y[AY]")
}
void AcamStdLathePost::OutputDrillCycleSubParameters(IPostDataPtr pPD)	// $212, 216, 222, 226, 232, 236, 242, 246
{
	POST("OutputDrillCycleSubParameters")
}
void AcamStdLathePost::OutputLatheCycle(IPostDataPtr pPD)	// $300, 301, 305, 306, 310, 311, 320, 325, 326, 330, 335, 336, 340
{
#ifdef DEBUG_MODE
	POST("OutputLatheCycle")
#endif
	switch(pPD->LatheCycleType)
	{
	 case acamPostLatheCycleDIAMETER_ROUGH : // $300
		 POST("N[N] (SPD = [SPD], SPZ = [SPZ], EPD = [EPD], EPZ = [EPZ] ' Start/end of profile")
		 POST("N[N] G71 P[LNS] Q[LNE] U[STD] W[STF] D[WDC] F[F] S[S]        ' DIA ROUGH CYCLE")
			 break;
	 case acamPostLatheCycleDIAMETER_ROUGH_END : case acamPostLatheCycleDIAMETER_GROOVE_END : case acamPostLatheCycleFACE_ROUGH_END : case acamPostLatheCycleFACE_GROOVE_END : // $301, 306, 326, 336
		 POST("N[N] G80 ' End of cycle profile")
			 break;
	 case acamPostLatheCycleFACE_ROUGH : // $305
		 POST("N[N] G72 P[LNS] Q[LNE] U[STD] W[STF] D[WDC] F[F] S[S] ' RTR = [RTR]")
			 break;
	 case acamPostLatheCycleDRILL : // $310
		 POST("N[N] G74 Z[ZB] K[ZP] F[F]")
			 break;
	 case acamPostLatheCycleDIAMETER_GROOVE : // $320
		 POST("N[N] G75 X[AD] Z[AZ] I[PKD] K[WDC] F[F]")
			 break;
	 case acamPostLatheCycleDIAMETER_GROOVE_PROFILE : // $325
		 POST("N[N] G175 I[PKD] K[WDC] F[F]")
			 break;
	 case acamPostLatheCycleFACE_GROOVE : // $330
		 POST("N[N] G74 X[AD] Z[AZ] I[WDC] K[PKD] F[F]")
			 break;
	 case acamPostLatheCycleFACE_GROOVE_PROFILE : // $335
		 POST("N[N] G174 I[WDC] K[PKD] F[F]")
			 break;
	 case acamPostLatheCycleTHREAD :	// $340
		 POST("'vars [NTS], [TAD], [NOC], [SPR], [TLI], [TLO], [TLH], [TCT], [TFD], [TFP]")
		 POST("N[N] G76 X[AD] Z[AZ] I[THR] K[THD] D[THF] F[F] A[THA]")
			 break;			
	}
}
// This is called only when the Post is first read by AlphaCAM
// eg on startup or if it is reselected
void AcamStdLathePost::AfterOpenPost(IPostConfigurePtr pPC)
{
	// Example of accessing the Drawing and VersionInformation objects
	IDrawingPtr pDrw(pPC->Drawing);
	IAlphaCamAppPtr pApp(pDrw->App);
	IVersionInformationPtr pVer(pApp->AlphacamVersion);
	_bstr_t v(pVer->String);

   pPC->ConstantSurfaceSpeed = "G96";  // $71 for variable CS
   pPC->ConstantSpindleSpeed = "G97"; // $72 for variable CS
	pPC->FeedPerMin = "G98";	// $73 for variable FP
	pPC->FeedPerRev = "G99";	// $74 for variable FP
	pPC->CWSpindleRotation = "M03"; // $75 for variable RT
	pPC->CCWSpindleRotation = "M04"; // $76 for variable RT
	pPC->MCToolCompCancel = "G40"; // $140 for variable TC
	pPC->MCToolCompLeft = "G41"; // $141 for variable TC
	pPC->MCToolCompRight = "G42"; // $142 for variable TC
	pPC->MCToolCompOnRapidApproach = VARIANT_FALSE;	// $147
	pPC->CoolantOff = "M09"; // $150
	pPC->CoolantMist = "M07"; // $151
	pPC->CoolantFlood = "M08"; // $152
	pPC->CoolantThroughTool = "M10"; // $153
	pPC->ModalText = "G0 G1 G2 G3"; // $500
	pPC->ModalAbsoluteValues = "X Y Z F C"; // $502
	pPC->ModalIncrementalValues = "I J"; // $504
	pPC->NeedPlusSigns = VARIANT_FALSE; // $510
	pPC->DecimalSeparator = acamPostDecimalSeparatorPOINT; // $515
	pPC->SubroutinesAtEnd = VARIANT_TRUE; // $520
	pPC->LimitArcs = acamPostLimitArcsQUAD; // $525, 526
	pPC->HelicalArcsAsLines = VARIANT_FALSE; // $527
	pPC->PlanarArcsAsLines = acamPostPlanarArcsAsLinesNONE; // $530
	pPC->MaximumArcRadius = 0; // $531
	pPC->ArcChordTolerance = 0.1; // $532
   pPC->CAxisArcsAndLinesAsLines = acamPostCAxisLinesNONE;   // $533
	pPC->SuppressComments = VARIANT_FALSE; // $540
	pPC->AllowOutputVisibleOnly = VARIANT_TRUE; // $545
   pPC->OutputLatheBySequenceNumber = VARIANT_TRUE; // $543
   pPC->LatheAX = acamPostLatheAXIsDIAMETER;    // $550
   pPC->LatheCycleIgnoreUndercuts = VARIANT_FALSE;  // $551
   pPC->LatheEdgeTip = VARIANT_TRUE;    // $555
	pPC->FiveAxisProgramPivot = VARIANT_FALSE; // $560
	pPC->FiveAxisOffsetFromPivotPointX = 0; // $562
	pPC->FiveAxisOffsetFromPivotPointY = 0; // $563
	pPC->FiveAxisToolHolderLength = 0; // $565
	pPC->FiveAxisToolMaxAngle = 90; // $570
	pPC->FiveAxisToolMaxAngleChange = 15; // $575
	pPC->AllowPositiveAndNegativeTilt = VARIANT_FALSE; // $577
	pPC->HorizontalMCCentre = VARIANT_TRUE; // $580
	pPC->SelectWpToolOrder = acamPostSelectWpToolOrderTOOL_FIRST; // $582
	pPC->LocalXorYAxis = acamPostLocalXorYAxisNONE; // $584
	pPC->Allow5AxisHelicalArcs = VARIANT_FALSE; // $585
   pPC->LatheBelowCLXPositive = VARIANT_FALSE;  // $590

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
	pPC->LineNumberIncrement = NoLineNumbers ? 0 : 10;	// $716

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
	//pPC->SpindleSpeedRound = 100;	// $745

	// $750, 751, 752
	pPC->FeedNumberFormat->Format = acamPostNumberFormat3DECIMAL_NO_0_OR_POINT;
	pPC->FeedNumberFormat->LeadingFigures = 0;
	pPC->FeedNumberFormat->FiguresAfterPoint = 3;

	//pPC->FeedMax = 800;	// $753
	//pPC->FeedRound = 10;	// $755

	// $760, 761, 762
	pPC->ToolNumberFormat->Format = acamPostNumberFormat6INTEGER;
	pPC->ToolNumberFormat->LeadingFigures = 0;
	pPC->ToolNumberFormat->FiguresAfterPoint = 0;

   pPC->RapidXYSpeed = 5000; // $900
   pPC->RapidZSpeed = 4000; // $901
   pPC->ToolChangeTime = 3; // $902

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

int AcamStdLathePost::FilterFunction(const char *buf, char **buf_new)
{
	//if(NoLineNumbers)
	//{
	//	CStringA str = buf;
	//	//str = "[" + str + "]";
	//	if(str.Left(3) == "N10")
	//		str = str.Mid(3);
	//	*buf_new = _strdup(str);
	//	return 0;
	//}
	return 1;
}

void AcamStdLathePost::ShowToolChangePos(IPostDataPtr pPD)
{
#ifdef DEBUG_MODE
    ITurnDataPtr pTD(pPD->Path->GetTurnData());
    if(!pTD) return;
    double TCX = 0, TCZ = 0;
	 if(pTD->GetToolChangePointForTurret(
		 pPD->Vars->TAB == 2 ? acamTurretBELOW_CL : acamTurretABOVE_CL,
		 pPD->Vars->TFB == 2 ? acamStationBACK : acamStationFRONT, &TCZ, &TCX))
	 {
		 CString str, tcx = pPD->Format(TCX), tcz = pPD->Format(TCZ);
		 str.Format(_T("Tool Change X,Z = %s, %s"), tcx, tcz);
		 POST_CSTRING(str)		
	 }
    else
        POST("Tool Change Position not set!!!")
#endif
}
