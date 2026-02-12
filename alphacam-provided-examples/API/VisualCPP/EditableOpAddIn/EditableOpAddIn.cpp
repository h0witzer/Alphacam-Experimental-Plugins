// EditableOpAddIn.cpp : Defines the initialization routines for the DLL.
//

#include "stdafx.h"
#include "EditableOpAddIn.h"

#include "SolidRoughFinishOp.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

BEGIN_MESSAGE_MAP(CEditableOpAddInApp, CWinApp)
END_MESSAGE_MAP()


// CEditableOpAddInApp construction

CEditableOpAddInApp::CEditableOpAddInApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}


// The one and only CEditableOpAddInApp object

CEditableOpAddInApp theApp;


// CEditableOpAddInApp initialization

BOOL CEditableOpAddInApp::InitInstance()
{
	CWinApp::InitInstance();

	return TRUE;
}

namespace CmdNumber
{
	// Define these so button IDs are constant
	enum CommandNumber {SolidRoughFinishCmd = 1};
}

// Return instance of class supported by this add-in.
EditableOp* EditableOp::GetEditableOp()
{
	static SolidRoughFinishOp* pSolidRoughFinishOp;
	if(!pSolidRoughFinishOp) pSolidRoughFinishOp = new SolidRoughFinishOp;
	return pSolidRoughFinishOp;
}

///////////////////////////////////////////////////////////
//
// Called when AlphaCAM loads add-in.
// Return 0 if OK, -1 if add-in is not to be loaded

ACAMAPIFUN(int) InitAlphacamAddIn(VARIANT var_acam, int version)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	ACAMAPP(var_acam);	// acam = Application object

	IFramePtr frame(acam->Frame);
	frame->AddMenuItem32("Solid Rough/Finish (DLL)", "CmdSolidRoughFinish", acamMenuMACHINE_OPS, "", "", CmdNumber::SolidRoughFinishCmd);

	return 0;
}

ACAMAPIFUN(void) CmdSolidRoughFinish(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	ACAMAPP(var_acam);		// acam is Application object

	SolidRoughFinishOp* pSolidRoughFinishOp = dynamic_cast<SolidRoughFinishOp*>(EditableOp::GetEditableOp());
	if(!pSolidRoughFinishOp) return;

    // Show the dialog box
	if(pSolidRoughFinishOp->ShowDialogBoxes(acam)) return;

    // call sub to do the machining
	pSolidRoughFinishOp->DoCmd(acam);    
}

ACAMAPIFUN(int) OnUpdateCmdSolidRoughFinish(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	ACAMAPP(var_acam);		// acam is Application object
	IDrawingPtr pDrw(acam->ActiveDrawing);

    if(acam->GetCurrentTool() && (pDrw->SolidParts->Count > 0 || pDrw->Surfaces->Count > 0))
        return 1;	// enable

	return 0;	// disable
}
