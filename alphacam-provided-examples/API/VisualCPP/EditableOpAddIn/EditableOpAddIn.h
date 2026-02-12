// EditableOpAddIn.h : main header file for the EditableOpAddIn DLL
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		// main symbols


// CEditableOpAddInApp
// See EditableOpAddIn.cpp for the implementation of this class
//

class CEditableOpAddInApp : public CWinApp
{
public:
	CEditableOpAddInApp();

// Overrides
public:
	virtual BOOL InitInstance();

	DECLARE_MESSAGE_MAP()
};
