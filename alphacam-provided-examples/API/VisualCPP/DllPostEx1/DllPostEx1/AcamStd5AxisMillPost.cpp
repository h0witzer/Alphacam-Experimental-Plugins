#include "stdafx.h"
#include "AcamStd5AxisMillPost.h"

CString AcamStd5AxisMillPost::GetPostName()
{
	return _T("Example 5-Axis Mill");
}

void AcamStd5AxisMillPost::AfterOpenPost(AlphaCAMMill::IPostConfigurePtr pPC)
{
	// Do the 3-axis one first
	AcamStd3AxisMillPost::AfterOpenPost(pPC);
	// Now set the ones that might be different
	pPC->FiveAxisToolMaxAngle = 90; // $570
	pPC->HorizontalMCCentre = VARIANT_TRUE; // $580
	pPC->SelectWpToolOrder = acamPostSelectWpToolOrderWP_FIRST; // $582
	pPC->LocalXorYAxis = acamPostLocalXorYAxisNONE; // $584

	IPostUserVariablePtr UV = pPC->AddUserVariable();
	UV->Name = "B_ANGLE";
	UV->Format->Format = acamPostNumberFormat2DECIMAL_NO_0;
	UV->Format->FiguresAfterPoint = 4;
}

void AcamStd5AxisMillPost::OutputFileLeadingLines(AlphaCAMMill::IPostDataPtr pPD)
{
	m_first_rapid_after_wp_change = false;
	AcamStd3AxisMillPost::OutputFileLeadingLines(pPD);
}

void AcamStd5AxisMillPost::OutputSelectWorkPlane(AlphaCAMMill::IPostDataPtr pPD)
{
	m_first_rapid_after_wp_change = true;
	m_b_angle = pPD->Vars->WTA;	
}

void AcamStd5AxisMillPost::OutputRapid(IPostDataPtr pPD)
{
	// Do the angle
	if(m_first_rapid_after_wp_change)
	{
		pPD->UserVariable["B_ANGLE"] = m_b_angle;
		POST("N[N] G0 B[B_ANGLE] L999")
		m_first_rapid_after_wp_change = false;
	}
	// Do the coords
	AcamStd3AxisMillPost::OutputRapid(pPD);
}

void AcamStd5AxisMillPost::OutputFeed(IPostDataPtr pPD)
{
   if(pPD->Element->Is5Axis)
	{
		POST("N[N] G1 X[AX] Y[AY] Z[AZ] A[TWZ] B[TIZ] F[F] ' TAX: [TAX], [TAY], [TAZ]")
	}
	else
		AcamStd3AxisMillPost::OutputFeed(pPD);
}
