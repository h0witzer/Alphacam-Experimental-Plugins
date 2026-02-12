// AlphacamAddIn.cpp : Defines the initialization routines for the DLL.
//

#include "stdafx.h"
#include "AlphacamAddIn.h"

#import EXE_TYPELIB_NAME implementation_only

//
//TODO: If this DLL is dynamically linked against the MFC DLLs,
//		any functions exported from this DLL which call into
//		MFC must have the AFX_MANAGE_STATE macro added at the
//		very beginning of the function.
//
//		For example:
//
//		extern "C" BOOL PASCAL EXPORT ExportedFunction()
//		{
//			AFX_MANAGE_STATE(AfxGetStaticModuleState());
//			// normal function body here
//		}
//
//		It is very important that this macro appear in each
//		function, prior to any calls into MFC.  This means that
//		it must appear as the first statement within the 
//		function, even before any object variable declarations
//		as their constructors may generate calls into the MFC
//		DLL.
//
//		Please see MFC Technical Notes 33 and 58 for additional
//		details.
//

// CAlphacamAddInApp

BEGIN_MESSAGE_MAP(CAlphacamAddInApp, CWinApp)
END_MESSAGE_MAP()


// CAlphacamAddInApp construction

CAlphacamAddInApp::CAlphacamAddInApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}


// The one and only CAlphacamAddInApp object

CAlphacamAddInApp theApp;


// CAlphacamAddInApp initialization

BOOL CAlphacamAddInApp::InitInstance()
{
	CWinApp::InitInstance();

	return TRUE;
}

// Called when AlphaCAM loads add-in.
ACAMAPIFUN(int) InitAlphacamAddIn(VARIANT var_acam, int version)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	ACAMAPP(var_acam);

	IFramePtr pFrame = acam->GetFrame();
	if (pFrame)
	{
		// Add a button to the Ribbon Bar that will call "MyCommandFunction" in this add-in

		AcamButtonBar ButtonBar = static_cast<AcamButtonBar>(pFrame->CreateButtonBar(L"AlphacamAddIn"));

		pFrame->AddMenuItem32(L"My Command Name", "MyCommandFunction", acamMenuADDINS, L"", L"Group Name", 1);
		pFrame->AddButton(ButtonBar, L"Bitmaps\\Configure.bmp", pFrame->LastMenuCommandID);

		pFrame->FinishButtonBar(ButtonBar);
	}

	return 0;
}

ACAMAPIFUN(int) GetUIVersion(int iLastVersion)
{
	// Return version number of application for the purposes of updating the User Interface
	AfxMessageBox(_T("GetUIVersion"));
	return 0;
}

ACAMAPIFUN(void) MyCommandFunction(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	AfxMessageBox(_T("MyCommandFunction"));
}

ACAMAPIFUN(int) OnUpdateMyCommandFunction(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	return TRUE;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Event callbacks

ACAMAPIFUN(void) AfterCreateNc(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	AfxMessageBox(_T("AfterCreateNc"));
}

ACAMAPIFUN(void) AfterEditTool(VARIANT var_acam, VARIANT var_tool)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	AfxMessageBox(_T("AfterEditTool"));
}

ACAMAPIFUN(void) AfterInputCad(VARIANT var_acam, int type, LPCSTR szFilename)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strFilename(szFilename);
	CString strMessage;
	strMessage.Format(_T("AfterInputCAD Type: %d Filename: %s"), type, strFilename);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterOpenFile(VARIANT var_acam, LPCSTR szFilename)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strFilename(szFilename);
	CString strMessage;
	strMessage.Format(_T("AfterOpenFile Filename: %s"), strFilename);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterSaveFile(VARIANT var_acam, LPCSTR szFilename)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strFilename(szFilename);
	CString strMessage;
	strMessage.Format(_T("AfterSaveFile Filename: %s"), strFilename);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterOutputNc(VARIANT var_acam, LPCSTR szFilename)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strFilename(szFilename);
	CString strMessage;
	strMessage.Format(_T("AfterOutputNc Filename: %s"), strFilename);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterInputNc(VARIANT var_acam, LPCSTR szFilename)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strFilename(szFilename);
	CString strMessage;
	strMessage.Format(_T("AfterInputNc Filename: %s"), strFilename);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterRoughFinish(VARIANT var_acam, VARIANT varToolPaths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IPathsPtr pToolPaths(varToolPaths);
	strMessage.Format(_T("AfterRoughFinish ToolPath Count: %d Redo: %d"), pToolPaths ? pToolPaths->GetCount() : 0, redo);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterSaw(VARIANT var_acam, VARIANT varToolPaths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IPathsPtr pToolPaths(varToolPaths);
	strMessage.Format(_T("AfterSaw ToolPath Count: %d Redo: %d"), pToolPaths ? pToolPaths->GetCount() : 0, redo);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterCut2AxisShape(VARIANT var_acam, VARIANT varToolPaths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IPathsPtr pToolPaths(varToolPaths);
	strMessage.Format(_T("AfterCut2AxisShape ToolPath Count: %d Redo: %d"), pToolPaths ? pToolPaths->GetCount() : 0, redo);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterCut4AxisShape(VARIANT var_acam, VARIANT varToolPaths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IPathsPtr pToolPaths(varToolPaths);
	strMessage.Format(_T("AfterCut4AxisShape ToolPath Count: %d Redo: %d"), pToolPaths ? pToolPaths->GetCount() : 0, redo);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterConicCuts(VARIANT var_acam, VARIANT varToolPaths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IPathsPtr pToolPaths(varToolPaths);
	strMessage.Format(_T("AfterConicCuts ToolPath Count: %d Redo: %d"), pToolPaths ? pToolPaths->GetCount() : 0, redo);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterClearArea(VARIANT var_acam, VARIANT varToolPaths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IPathsPtr pToolPaths(varToolPaths);
	strMessage.Format(_T("AfterClearArea ToolPath Count: %d Redo: %d"), pToolPaths ? pToolPaths->GetCount() : 0, redo);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterPocket(VARIANT var_acam, VARIANT varToolPaths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IPathsPtr pToolPaths(varToolPaths);
	strMessage.Format(_T("AfterPocket ToolPath Count: %d Redo: %d"), pToolPaths ? pToolPaths->GetCount() : 0, redo);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterDrillTap(VARIANT var_acam, VARIANT varToolPaths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IPathsPtr pToolPaths(varToolPaths);
	strMessage.Format(_T("AfterDrillTap ToolPath Count: %d Redo: %d"), pToolPaths ? pToolPaths->GetCount() : 0, redo);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterMachineHoles(VARIANT var_acam, VARIANT varToolPaths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IPathsPtr pToolPaths(varToolPaths);
	strMessage.Format(_T("AfterMachineHoles ToolPath Count: %d Redo: %d"), pToolPaths ? pToolPaths->GetCount() : 0, redo);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterPocketHoles(VARIANT var_acam, VARIANT varToolPaths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IPathsPtr pToolPaths(varToolPaths);
	strMessage.Format(_T("AfterPocketHoles ToolPath Count: %d Redo: %d"), pToolPaths ? pToolPaths->GetCount() : 0, redo);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterEngrave(VARIANT var_acam, VARIANT varToolPaths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IPathsPtr pToolPaths(varToolPaths);
	strMessage.Format(_T("AfterEngrave ToolPath Count: %d Redo: %d"), pToolPaths ? pToolPaths->GetCount() : 0, redo);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterCutSplineOrPolyline(VARIANT var_acam, VARIANT varToolPaths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IPathsPtr pToolPaths(varToolPaths);
	strMessage.Format(_T("AfterCutSplineOrPolyline ToolPath Count: %d Redo: %d"), pToolPaths ? pToolPaths->GetCount() : 0, redo);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterSurfaceMachining(VARIANT var_acam, VARIANT varToolPaths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IPathsPtr pToolPaths(varToolPaths);
	strMessage.Format(_T("AfterSurfaceMachining ToolPath Count: %d Redo: %d"), pToolPaths ? pToolPaths->GetCount() : 0, redo);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterSolidMachining(VARIANT var_acam, VARIANT varToolPaths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IPathsPtr pToolPaths(varToolPaths);
	strMessage.Format(_T("AfterSolidMachining ToolPath Count: %d Redo: %d"), pToolPaths ? pToolPaths->GetCount() : 0, redo);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) After3DMachining(VARIANT var_acam, VARIANT varToolPaths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IPathsPtr pToolPaths(varToolPaths);
	strMessage.Format(_T("After3DMachining ToolPath Count: %d Redo: %d"), pToolPaths ? pToolPaths->GetCount() : 0, redo);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterManualToolpath(VARIANT var_acam, VARIANT varToolPaths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IPathsPtr pToolPaths(varToolPaths);
	strMessage.Format(_T("AfterManualToolpath ToolPath Count: %d Redo: %d"), pToolPaths ? pToolPaths->GetCount() : 0, redo);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterCutBetweenTwoGeometries(VARIANT var_acam, VARIANT varToolPaths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IPathsPtr pToolPaths(varToolPaths);
	strMessage.Format(_T("AfterCutBetweenTwoGeometries ToolPath Count: %d Redo: %d"), pToolPaths ? pToolPaths->GetCount() : 0, redo);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterSelectTool(VARIANT var_acam, VARIANT var_tool)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	CString strMessage;
	IMillToolPtr pTool(var_tool);
	strMessage.Format(_T("AfterSelectTool ToolName is %s"), pTool ? (LPCTSTR)(pTool->GetName()) : _T(""));
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) AfterTurningMachining(VARIANT var_acam, int method, VARIANT var_tool_paths, int redo)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	// method is one of typeAcamTurningMethod
	AfxMessageBox(_T("AfterTurningMachining"));
}

ACAMAPIFUN(int) BeforeEditClampMove(VARIANT var_acam, VARIANT varToolPath)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	// Return 1 if we handle the command, or return 0 for AlphaCAM to handle the command as normal

	CString strMessage;
	IPathPtr pToolPath(varToolPath);
	if (pToolPath)
	{
		strMessage.Format(_T("BeforeEditClampMove ToolPath Element Count: %d"), pToolPath->GetElemCount());
		AfxMessageBox(strMessage);
	}

	return 0;
}

ACAMAPIFUN(int) BeforeOpenFile(VARIANT var_acam, LPSTR filename)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	// Add-in may copy name of file to be opened to string and return 1, or return 0 if AlphaCAM is to show normal dialog box,
	// or return 2 to cancel command.

	CString strMessage;
	strMessage.Format(_T("BeforeOpenFile: %s"), CString(filename));
	AfxMessageBox(strMessage);

	return 0;
}

ACAMAPIFUN(int) BeforeSaveFile(VARIANT var_acam, LPSTR filename)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	// Add-in may copy name of file to be opened to string and return 1, or return 0 if AlphaCAM is to show normal dialog box,
	// or return 2 to cancel command.

	CString strMessage;
	strMessage.Format(_T("BeforeSaveFile: %s"), CString(filename));
	AfxMessageBox(strMessage);

	return 0;
}

ACAMAPIFUN(int) BeforeSaveAsFile(VARIANT var_acam, LPSTR filename)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	// Add-in may copy name of file to be opened to string and return 1, or return 0 if AlphaCAM is to show normal dialog box,
	// or return 2 to cancel command.

	CString strMessage;
	strMessage.Format(_T("BeforeSaveAsFile: %s"), CString(filename));
	AfxMessageBox(strMessage);

	return 0;
}

ACAMAPIFUN(int) BeforeOutputNc(VARIANT var_acam, LPSTR filename)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	// Add-in may copy name of file to be opened to string and return 1, or return 0 if AlphaCAM is to show normal dialog box,
	// or return 2 to cancel command.

	CString strMessage;
	strMessage.Format(_T("BeforeOutputNc: %s"), CString(filename));
	AfxMessageBox(strMessage);

	return 0;
}

ACAMAPIFUN(int) BeforeOpenPost(VARIANT var_acam, LPSTR filename)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	// Add-in may copy name of file to be opened to string and return 1, or return 0 if AlphaCAM is to show normal dialog box,
	// or return 2 to cancel command.

	CString strMessage;
	strMessage.Format(_T("BeforeOpenPost: %s"), CString(filename));
	AfxMessageBox(strMessage);

	return 0;
}

ACAMAPIFUN(int) BeforeInsertFile(VARIANT var_acam, LPSTR filename)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	// Add-in may copy name of file to be opened to string and return 1, or return 0 if AlphaCAM is to show normal dialog box,
	// or return 2 to cancel command.

	CString strMessage;
	strMessage.Format(_T("BeforeInsertFile: %s"), CString(filename));
	AfxMessageBox(strMessage);

	return 0;
}

ACAMAPIFUN(int) BeforeInputNc(VARIANT var_acam, LPSTR filename)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	// Add-in may copy name of file to be opened to string and return 1, or return 0 if AlphaCAM is to show normal dialog box,
	// or return 2 to cancel command.

	CString strMessage;
	strMessage.Format(_T("BeforeInputNc: %s"), CString(filename));
	AfxMessageBox(strMessage);

	return 0;
}

ACAMAPIFUN(int) BeforeSelectTool(VARIANT var_acam, LPSTR filename)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	// Add-in may copy name of file to be opened to string and return 1, or return 0 if AlphaCAM is to show normal dialog box,
	// or return 2 to cancel command.

	CString strMessage;
	strMessage.Format(_T("BeforeSelectTool: %s"), CString(filename));
	AfxMessageBox(strMessage);

	return 0;
}

ACAMAPIFUN(int) BeforeChangeTool(VARIANT var_acam, LPSTR filename)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	// Add-in may copy name of file to be opened to string and return 1, or return 0 if AlphaCAM is to show normal dialog box,
	// or return 2 to cancel command.

	CString strMessage;
	strMessage.Format(_T("BeforeChangeTool: %s"), CString(filename));
	AfxMessageBox(strMessage);

	return 0;
}

ACAMAPIFUN(int) BeforeCheckToolChangePosition(VARIANT var_acam, VARIANT var_tool)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	IMillToolPtr pTool(var_tool);
	
	// Called before doing checking that the tool change position has been set.
	// Return 1 if addin sets the tool change pos using SetToolChangePoint, else return 2 to cancel the command, else 0 to carry on as normal.

	CString strMessage;
	strMessage.Format(_T("BeforeCheckToolChangePosition: Tool Name: %s"), pTool ? (LPCTSTR)(pTool->GetName()) : _T(""));
	AfxMessageBox(strMessage);

	return 0;
}

ACAMAPIFUN(int) BeforeCreateNc(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 to cancel output, 0 to continue.

	AfxMessageBox(_T("BeforeCreateNc"));

	return 0;
}

ACAMAPIFUN(int) BeforeOutputNcDialogBox(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Called before dialog box for Output NC (asking File, Machine or Both) is shown.
	// Return 0 if AlphaCAM is to show normal dialog box,
	// 10 to cancel the command,
	// else 1 = File, 2 = Machine, 3 = Both.

	AfxMessageBox(_T("BeforeOutputNcDialogBox"));

	return 0;
}

ACAMAPIFUN(int) BeforeDefineTool(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 to suppress normal dialog box, or return 0 if AlphaCAM is to show normal dialog box.
	// (Or 2 = cancel, actually same as 1 in this case)

	AfxMessageBox(_T("BeforeDefineTool"));

	return 0;
}

ACAMAPIFUN(int) BeforeCut2AxisShape(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("BeforeCut2AxisShape"));

	return 0;
}

ACAMAPIFUN(int) BeforeCut4AxisShape(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("BeforeCut4AxisShape"));

	return 0;
}

ACAMAPIFUN(int) BeforeConicCuts(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("BeforeConicCuts"));

	return 0;
}

ACAMAPIFUN(int) BeforeCutPath(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("BeforeCutPath"));

	return 0;
}

ACAMAPIFUN(int) BeforeRoughFinish(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("BeforeRoughFinish"));

	return 0;
}

ACAMAPIFUN(int) BeforeSaw(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("BeforeSaw"));

	return 0;
}

ACAMAPIFUN(int) BeforeClearArea(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("BeforeClearArea"));

	return 0;
}

ACAMAPIFUN(int) BeforePocket(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("BeforePocket"));

	return 0;
}

ACAMAPIFUN(int) BeforeDrillTap(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("BeforeDrillTap"));

	return 0;
}

ACAMAPIFUN(int) BeforeMachineHoles(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("BeforeMachineHoles"));

	return 0;
}

ACAMAPIFUN(int) BeforePocketHoles(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("BeforePocketHoles"));

	return 0;
}

ACAMAPIFUN(int) BeforeEngrave(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("BeforeEngrave"));

	return 0;
}

ACAMAPIFUN(int) BeforeCutSplineOrPolyline(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("BeforeCutSplineOrPolyline"));

	return 0;
}

ACAMAPIFUN(int) BeforeSurfaceMachining(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("BeforeSurfaceMachining"));

	return 0;
}

ACAMAPIFUN(int) BeforeSolidMachining(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("BeforeSolidMachining"));

	return 0;
}

ACAMAPIFUN(int) Before3DMachining(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("Before3DMachining"));

	return 0;
}

ACAMAPIFUN(int) BeforeManualToolpath(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("BeforeManualToolpath"));

	return 0;
}

ACAMAPIFUN(int) BeforeCutBetweenTwoGeometries(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	AfxMessageBox(_T("BeforeCutBetweenTwoGeometries"));

	return 0;
}

ACAMAPIFUN(int) BeforeClose(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 0 if OK to close, 1 (or 2) to cancel command.

	AfxMessageBox(_T("BeforeClose"));

	return 0;
}

ACAMAPIFUN(int) BeforeEditTool(VARIANT var_acam, VARIANT var_tool)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	IMillToolPtr pTool(var_tool);
	
	// Called before editing a tool.
	// Return 1 if tool edited in add-in and should be saved, or return 0 if AlphaCAM is to show normal dialog box,
	// or 2 to cancel
	CString strMessage;
	strMessage.Format(_T("BeforeEditTool: Tool Name: %s"), pTool ? pTool->GetName() : L"");
	AfxMessageBox(strMessage);

	return 0;
}

ACAMAPIFUN(int) BeforeInputCad(VARIANT var_acam, int type, LPSTR szFilename)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Called before AlphaCAM shows open file dialog box to select file for input CAD
	// Add-in may copy name of file to be opened to string,
	// and return 1, or return 0 if AlphaCAM is to show normal dialog box.
	// Or return 2 to cancel.

	CString strMessage;
	strMessage.Format(_T("BeforeInputCad: Type: %d"), type);
	AfxMessageBox(strMessage);

	return 0;
}

ACAMAPIFUN(int) BeforeTurningMachining (VARIANT var_acam, int method)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Return 1 (or 2) to suppress AlphaCAM command eg to do your own, else return 0.

	// Method is one of typeAcamTurningMethod

	CString strMessage;
	strMessage.Format(_T("BeforeTurningMachining Method: %d"), method);
	AfxMessageBox(strMessage);

	return 0;
}

ACAMAPIFUN(void) BeforeUnload(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Called before unloading addin, from the addins dialog box
	AfxMessageBox(_T("BeforeUnload"));
}

ACAMAPIFUN(void) BeforeExit(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Called before exiting. No return value.
	AfxMessageBox(_T("BeforeExit"));
}

ACAMAPIFUN(void) BeforeReadingCad(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Called just before a CAD file is read, after clear memory (or not), after it has been dropped onto Alphacam,
	// or the Input CAD dialog box has been used, or input using the API.

	AfxMessageBox(_T("BeforeReadingCad"));
}

ACAMAPIFUN(int) BeforeSaveSolidPart(VARIANT var_acam, VARIANT solid_part, LPSTR szFilename)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Called before AlphaCAM saves a Solid Part to a separate Drawing file (part of Input CAD Assemblies support)
	// Add-in receives the ISolidPart about to be saved and the filename that will be used.
	// Add-in can optionally replace the filename with an alternative
	// If add-in returns 0, continue as normal
	// If add-in returns 1, continue but use the new filename
	// If add-in returns 2, skip this file
	// If add-in returns 3, cancel the operation (no more files will be saved)
	ISolidPartPtr pSolid(solid_part);

	CString strMessage;
	strMessage.Format(_T("BeforeSaveSolidPart Saving to %s"), CString(szFilename));
	AfxMessageBox(strMessage);

	return 0;
}

ACAMAPIFUN(int) GetFeedsAndSpeedsButtonText(VARIANT var_acam, LPSTR szText)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Get text for Manager button, and enable it
	// Return 1 to use new text and enable it, 0 to disable button.
	// NOTE: Unlike other events, this will only work if VBA project (or DLL) is loaded at startup.

	AfxMessageBox(_T("GetFeedsAndSpeedsButtonText"));

	return 0;
}

ACAMAPIFUN(int) NewFeedsAndSpeed(VARIANT var_acam, VARIANT var_milldata, VARIANT var_tool)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	// Called when Manager button pressed in feeds dialog box.
	// Button will only be shown if GetFeedsAndSpeedsButtonText returns a non-empty string
	// Current machining data will be passed,
	// Return 1 to use new values, 0 to use existing values.
	IMillDataPtr pMillData(var_milldata);
	IMillToolPtr pTool(var_tool);

	AfxMessageBox(_T("NewFeedsAndSpeed"));

	return 0;
}

ACAMAPIFUN(void) GeometryAdded(VARIANT var_acam, VARIANT var_path)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	IPathPtr pPath(var_path);

	AfxMessageBox(_T("GeometryAdded"));
}

ACAMAPIFUN(void) GeometriesUpdated(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	AfxMessageBox(_T("GeometriesUpdated"));
}

ACAMAPIFUN(void) GeometriesModified(VARIANT var_acam, long cmdId, VARIANT modifiedPaths, VARIANT newPaths, VARIANT deletedPaths)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	
	IPathsPtr pModifiedPaths(modifiedPaths);
	IPathsPtr pNewPaths(newPaths);
	IPathsPtr pDeletedPaths(deletedPaths);

	CString strMessage;
	strMessage.Format(_T("GeometriesModified %d Modified, %d New, %d Deleted Paths"), pModifiedPaths ? pModifiedPaths->GetCount() : 0,
		pNewPaths ? pNewPaths->GetCount() : 0, pDeletedPaths ? pDeletedPaths->GetCount() : 0);
	AfxMessageBox(strMessage);
}

ACAMAPIFUN(void) ToolPathsUpdated(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	AfxMessageBox(_T("ToolPathsUpdated"));
}

ACAMAPIFUN(void) TextAdded(VARIANT var_acam, VARIANT var_text)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	ITextPtr pText(var_text);

	AfxMessageBox(_T("TextAdded"));
}

ACAMAPIFUN(void) SplineAdded(VARIANT var_acam, VARIANT var_spline)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	ISplinePtr pSpline(var_spline);

	AfxMessageBox(_T("SplineAdded"));
}

ACAMAPIFUN(void) SurfaceAdded(VARIANT var_acam, VARIANT var_surface)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	ISurfacePtr pSurface(var_surface);

	AfxMessageBox(_T("SurfaceAdded"));
}
