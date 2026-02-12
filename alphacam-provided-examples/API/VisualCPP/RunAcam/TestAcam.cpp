// Example routines to run Alphacam

#include "stdafx.h"
#include "RunAcam2.h"

///////////////////////////////////////////////////////////
//
// Try to run named module. Return App pointer if OK, NULL if not.

static IAlphaCamAppPtr try_run_acam(const char *name)	// eg "am5axaps.application"
{
	try
	{
		IAlphaCamAppPtr pApp(name);
		return pApp;
	}
	catch(_com_error e)
	{
//		AfxMessageBox("Error running Alphacam");
		return NULL;
	}
}

void run_mill_alphacam(CDialog* db)
{
	IAlphaCamAppPtr pApp;
	
	// Run ALPHACAM in Mill Mode
	// ar5axaps.application = Router Mode
	// am5axaps.application = Mill Mode
	// amar5aps.application = Stone/Marble Mode
	// at5axaps.application = Lathe Mode
	// awireaps.application = Wire Mode
	// al5axaps.application = Laser Mode
	pApp = try_run_acam("am5axaps.application");

	if(pApp == NULL)
	{
		AfxMessageBox("Error running Alphacam");
		return;
	}

	// pApp is a valid App pointer, it can be used to access other
	// Alphacam objects, see the DLL example.

	if(pApp->ApiVersion >= 20070810)
	{
		// This is V7.5 or later, so we can get the version and show it in the dialog box
		IVersionInformationPtr pVer(pApp->AlphacamVersion);
		CString ver(static_cast<const char*>(pVer->String));
		db->SetDlgItemText(IDC_EDIT1, ver);

		CString level;
		level.Format("%d", pApp->ProgramLevel);
		db->SetDlgItemText(IDC_EDIT2, level);
	}

	IDrawingPtr drw = pApp->ActiveDrawing;

	IPathPtr path = drw->CreateRectangle(0., 0., 100., 50.);

	drw->ZoomAll();
}
