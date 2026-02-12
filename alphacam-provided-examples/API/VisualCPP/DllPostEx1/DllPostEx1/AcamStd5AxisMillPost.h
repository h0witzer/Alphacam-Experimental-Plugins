// Class for example 5-axis post derived from 3-axis post

#pragma once

#include "AcamStd3AxisMillPost.h"

class AcamStd5AxisMillPost : public AcamStd3AxisMillPost
{
	CString GetPostName();
	bool m_first_rapid_after_wp_change;
	double m_b_angle;
public:
	void AfterOpenPost(IPostConfigurePtr pPC);
	void OutputFileLeadingLines(IPostDataPtr pPD);
	void OutputSelectWorkPlane(IPostDataPtr pPD);
	void OutputRapid(IPostDataPtr pPD);
	void OutputFeed(IPostDataPtr pPD);
};
