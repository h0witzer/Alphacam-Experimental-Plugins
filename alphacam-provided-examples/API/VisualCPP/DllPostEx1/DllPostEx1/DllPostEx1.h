// DllPostEx1.h : main header file for the DllPostEx1 DLL
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		// main symbols

// CDllPostEx1App
// See DllPostEx1.cpp for the implementation of this class
//

class CDllPostEx1App : public CWinApp
{
public:
	CDllPostEx1App();

// Overrides
public:
	virtual BOOL InitInstance();

	DECLARE_MESSAGE_MAP()
};
