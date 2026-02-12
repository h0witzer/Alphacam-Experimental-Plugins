// DllPostEx1.cpp : Defines the initialization routines for the DLL.
//

#include "stdafx.h"
#import EXE_TYPELIB_NAME implementation_only
#include "DllPostEx1.h"
#include "Version.h"
#include "AcamStd3AxisMillPost.h"
#include "AcamStd5AxisMillPost.h"
#include "AcamStd3AxisRouterPost.h"
#include "AcamStdLathePost.h"
#include "AcamStdWirePost.h"
#include "AcamStd5AxisLaserPost.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

///////////////////////////////////////////////////////////
//
// Example C++ DLL Combined Add-In and Post Processor for AlphaCAM V7.5 (Build 139 or later)
// Updated for Alphacam 2022, with Visual Studio 2019. 
// 64 bit build configuration only.
// Code made Unicode compatible, as Microsoft is phasing out support for MBCS.
// This DLL can be built with either MBCS or Unicode, both will work with Alphacam.
//
// The AlphaCAM exe should be #imported in the usual way for an AlphaCAM add-in,
// usually in stdafx.h and at the top of this file.

// The compiled DLL can be selected as a Post using the normal "File | Select Post" command
// and can be made the default post using the "File | Configure | Set Default Post" command
// It can be selected in the API using "App.SelectPost".
// In this case CreateDefaultPost will be called.

// Alternatively, you can register the DLL as an add-in and add your own command (or commands)
// which selects this DLL as a post, as in the example functions eg CmdPost1.
// In this case InitAlphacamAddIn will be called.

// Alphacam will call the exported functions in DllPostInterface.cpp and they will call
// the member functions of a class derived from eg AcamMillPost.

// To create a new post derive a class from eg AcamMillPost and call SetAcamPost from
// CreateDefaultPost for a DLL that is to be selected as a post,
// or from a command-handler eg CmdPost1 for an add-in DLL.
// See AcamStd3AxisMillPost.cpp and AcamStd5AxisMillPost.cpp for example post classes.

// This source has been tested with Microsoft Visual Studio 2005 only

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


// CDllPostEx1App

BEGIN_MESSAGE_MAP(CDllPostEx1App, CWinApp)
END_MESSAGE_MAP()


// CDllPostEx1App construction

CDllPostEx1App::CDllPostEx1App()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}


// The one and only CDllPostEx1App object

CDllPostEx1App theApp;


// CDllPostEx1App initialization

BOOL CDllPostEx1App::InitInstance()
{
	CWinApp::InitInstance();

	return TRUE;
}

///////////////////////////////////////////////////////////
//
// This DLL can be used as a single post selected using the normal Alphacam Select Post command,
// or can be used as an add-in and add its own commands, useful if it supports more than one post.
// If it is loaded as an add-in (because it is registered in the usual way for an Alphacam add-in)
// InitAlphacamAddIn will be called.
// If it is selected as a post, this function will be called (from AfterOpenPost in DllPostInterface.cpp)
// which should create the post class to be used.

void CreateDefaultPost(IPostConfigurePtr pPC)
{
	// Find which module loaded this DLL
	IDrawingPtr pDrw(pPC->Drawing);
	IAlphaCamAppPtr pApp(pDrw->App);
	short module = pApp->ProgramLetter;
	switch(module)
	{
	case 'M' : SetAcamPost(new AcamStd5AxisMillPost);	// store class pointer
		break;
	case 'R' : SetAcamPost(new AcamStd3AxisRouterPost);	// store class pointer
		break;
	case 'T' : SetAcamPost(new AcamStdLathePost);	// store class pointer
		break;
	case 'E' : SetAcamPost(new AcamStdWirePost);	// store class pointer
		break;
	}
}

///////////////////////////////////////////////////////////
//
// Called when AlphaCAM loads add-in.
// Return 0 if OK, -1 if add-in is not to be loaded

ACAMAPIFUN(int) InitAlphacamAddIn(VARIANT var_acam, int version)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());

	IAlphaCamAppPtr pApp(var_acam.pdispVal);
	if(pApp == NULL)
	{
		AfxMessageBox(_T("Parameter 1 is not a valid AlphaCAM Application pointer"));
		return -1;
	}
	if(version < 20070810)
	{
		AfxMessageBox(_T("TestMillDllPost Add-in: Alphacam Version is too old"));
		return -1;
	}
	IVersionInformationPtr pVer(pApp->AlphacamVersion);
	if( !((pVer->Major == MAJOR_NUMBER && pVer->Minor == MINOR_NUMBER) || pVer->Major > MAJOR_NUMBER))
	{
		CString str;
		str.Format(_T("TestMillDllPost Add-in: Incorrect Alphacam Version, expected at least %d.%d"), MAJOR_NUMBER, MINOR_NUMBER);
		AfxMessageBox(str);
		return -1;
	}
	IFramePtr pFrame(pApp->Frame);
	if(pApp->ProgramLetter == 'M')
	{
		pFrame->AddMenuItem2("&Select 3-Axis Post in DLL", "CmdPost1", acamMenuNEW, "DLL Posts");
		pFrame->AddMenuItem2("&Select 5-Axis Post in DLL", "CmdPost2", acamMenuNEW, "DLL Posts");
	}
	else if(pApp->ProgramLetter == 'R')
		pFrame->AddMenuItem2("&Select 3-Axis Post in DLL", "CmdPost6", acamMenuNEW, "DLL Posts");
	else if(pApp->ProgramLetter == 'T')
		pFrame->AddMenuItem2("&Select Lathe Post in DLL", "CmdPost3", acamMenuNEW, "DLL Posts");
	else if(pApp->ProgramLetter == 'E')
		pFrame->AddMenuItem2("&Select Wire Post in DLL", "CmdPost4", acamMenuNEW, "DLL Posts");
	else if(pApp->ProgramLetter == 'L')
		pFrame->AddMenuItem2("&Select Laser Post in DLL", "CmdPost5", acamMenuNEW, "DLL Posts");
	return 0;
}

namespace
{
	// Set class to be the post, and make this DLL the current post, checking for error, eg OnePost
	void SetPost(IAlphaCamAppPtr pApp, AcamPost* p)
	{
		SetAcamPost(p);	// store class pointer
		try
		{
			pApp->SelectPost(pApp->Frame->PathOfThisAddin2);	// so Alphacam re-selects the post
												// PathOfThisAddin2 is a new property in 7.5.0.139 to give the complete path of this DLL
		}
		catch(_com_error e)
		{
			AfxMessageBox(_T("Can't select post. (OnePost system?)"));
			SetAcamPost(NULL);	// will delete p
		}
	}
}

// Select this DLL as the Post, using class AcamStd3AxisMillPost
ACAMAPIFUN(void) CmdPost1(VARIANT var_acam)	// must put CmdPost1 in .DEF file
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	IAlphaCamAppPtr pApp(var_acam.pdispVal);		// pApp is pointer to Application object

	SetPost(pApp, new AcamStd3AxisMillPost);
}
// Select this DLL as the Post, using class AcamStd5AxisMillPost
ACAMAPIFUN(void) CmdPost2(VARIANT var_acam)	// must put CmdPost2 in .DEF file
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	IAlphaCamAppPtr pApp(var_acam.pdispVal);		// pApp is pointer to Application object

	SetPost(pApp, new AcamStd5AxisMillPost);
}
// Select this DLL as the Post, using class AcamStdLathePost
ACAMAPIFUN(void) CmdPost3(VARIANT var_acam)	// must put CmdPost3 in .DEF file
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	IAlphaCamAppPtr pApp(var_acam.pdispVal);		// pApp is pointer to Application object

	SetPost(pApp, new AcamStdLathePost);
}
// Select this DLL as the Post, using class AcamStdWirePost
ACAMAPIFUN(void) CmdPost4(VARIANT var_acam)	// must put CmdPost4 in .DEF file
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	IAlphaCamAppPtr pApp(var_acam.pdispVal);		// pApp is pointer to Application object

	SetPost(pApp, new AcamStdWirePost);
}
// Select this DLL as the Post, using class AcamStd5AxisLaserPost
ACAMAPIFUN(void) CmdPost5(VARIANT var_acam)	// must put CmdPost5 in .DEF file
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	IAlphaCamAppPtr pApp(var_acam.pdispVal);		// pApp is pointer to Application object

	SetPost(pApp, new AcamStd5AxisLaserPost);
}
// Select this DLL as the Post, using class AcamStd3AxisRouterPost
ACAMAPIFUN(void) CmdPost6(VARIANT var_acam)	// must put CmdPost6 in .DEF file
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	IAlphaCamAppPtr pApp(var_acam.pdispVal);		// pApp is pointer to Application object

	SetPost(pApp, new AcamStd3AxisRouterPost);
}

//	return 0;  	// Menu item is unchecked and disabled
//	return 1;	// Menu item is unchecked and enabled.  This is the default menu state if no update function is specified.
ACAMAPIFUN(int) OnUpdateCmdPost1(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	IAlphaCamAppPtr pApp(var_acam.pdispVal);		// pApp is pointer to Application object
	return (pApp->SpecialKey & 8) ? 0 : 1;	// Disable if OnePost
}
ACAMAPIFUN(int) OnUpdateCmdPost2(VARIANT var_acam) {return OnUpdateCmdPost1(var_acam);}
ACAMAPIFUN(int) OnUpdateCmdPost3(VARIANT var_acam) {return OnUpdateCmdPost1(var_acam);}
ACAMAPIFUN(int) OnUpdateCmdPost4(VARIANT var_acam) {return OnUpdateCmdPost1(var_acam);}
ACAMAPIFUN(int) OnUpdateCmdPost5(VARIANT var_acam) {return OnUpdateCmdPost1(var_acam);}
ACAMAPIFUN(int) OnUpdateCmdPost6(VARIANT var_acam) {return OnUpdateCmdPost1(var_acam);}

// This function is called only if this DLL is loaded as an add-in.
// It is called for all add-in VBA projects and DLLs, unless a non-zero
// value is returned to abort the NC creation.

// This function is called when AlphaCAM is about to List or Output NC, using any post.
// Return non-zero to abort.
// Also see BeforeCreateNcUsingThisDLLPost

ACAMAPIFUN(int) BeforeCreateNc(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IAlphaCamAppPtr pApp(var_acam.pdispVal);
	return 0;
}
ACAMAPIFUN(void) AfterOutputNc(VARIANT var_acam, const char* file_name)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	CString str;
	str = _T("AfterOutputNc: file name = ") + CString(file_name);
	AfxMessageBox(str);
}				
