// AlphacamAddIn.h : main header file for the AlphacamAddIn DLL
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		// main symbols


// CAlphacamAddInApp
// See AlphacamAddIn.cpp for the implementation of this class
//

class CAlphacamAddInApp : public CWinApp
{
public:
	CAlphacamAddInApp();

// Overrides
public:
	virtual BOOL InitInstance();

	DECLARE_MESSAGE_MAP()
};
