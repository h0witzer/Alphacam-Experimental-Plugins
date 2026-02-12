// stdafx.h : include file for standard system include files,
//  or project specific include files that are used frequently, but
//      are changed infrequently
//

#if !defined(AFX_STDAFX_H__713885DC_4FA4_11D2_987E_00104B4AF281__INCLUDED_)
#define AFX_STDAFX_H__713885DC_4FA4_11D2_987E_00104B4AF281__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#define VC_EXTRALEAN		// Exclude rarely-used stuff from Windows headers

#include <afxwin.h>         // MFC core and standard components
#include <afxext.h>         // MFC extensions
#include <afxdisp.h>        // MFC OLE automation classes
#ifndef _AFX_NO_AFXCMN_SUPPORT
#include <afxcmn.h>			// MFC support for Windows Common Controls
#endif // _AFX_NO_AFXCMN_SUPPORT


//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

// Include the declarations of the AlphaCAM wrapper routines
// Edit the path to the location of AlphaCAM on the development computer
// See RunAcam2.cpp for the second #import statement

#define EXE_TYPELIB_NAME "C:\Program Files\Hexagon\ALPHACAM 2022\acam.exe"
#import EXE_TYPELIB_NAME no_implementation named_guids
using namespace AlphaCAMMill;

// To import a different type library eg Turning, use the tlbid attribute
// 1 = Mill, 2 = Turning, 3 = Router, 5 = Stone, 17 = Laser, 19 = Wire
//#define EXE_TYPELIB_NAME "C:\Program Files\Hexagon\ALPHACAM 2022\acam.exe" tlbid(2)
//#import EXE_TYPELIB_NAME no_implementation named_guids
//using namespace AlphaCAMTurning;

#endif // !defined(AFX_STDAFX_H__713885DC_4FA4_11D2_987E_00104B4AF281__INCLUDED_)
