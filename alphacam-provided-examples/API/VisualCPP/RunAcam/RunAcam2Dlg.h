// RunAcam2Dlg.h : header file
//

#if !defined(AFX_RUNACAM2DLG_H__713885DA_4FA4_11D2_987E_00104B4AF281__INCLUDED_)
#define AFX_RUNACAM2DLG_H__713885DA_4FA4_11D2_987E_00104B4AF281__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

/////////////////////////////////////////////////////////////////////////////
// CRunAcam2Dlg dialog

class CRunAcam2Dlg : public CDialog
{
// Construction
public:
	CRunAcam2Dlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CRunAcam2Dlg)
	enum { IDD = IDD_RUNACAM2_DIALOG };
		// NOTE: the ClassWizard will add data members here
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CRunAcam2Dlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CRunAcam2Dlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnButton1();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_RUNACAM2DLG_H__713885DA_4FA4_11D2_987E_00104B4AF281__INCLUDED_)
