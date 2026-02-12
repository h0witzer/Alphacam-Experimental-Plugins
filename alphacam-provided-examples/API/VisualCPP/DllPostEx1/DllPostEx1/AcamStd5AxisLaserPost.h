#pragma once

#include "AcamPost.h"

class AcamStd5AxisLaserPost: public AcamLaserPost
{
	virtual CString GetPostName();
public:
	void AfterOpenPost(IPostConfigurePtr pPC);
	void OutputFileLeadingLines(IPostDataPtr pPD);
	void OutputProgramLeadingLines(IPostDataPtr pPD);
	void OutputProgramTrailingLines(IPostDataPtr pPD);
	void OutputFileTrailingLines(IPostDataPtr pPD);
	void OutputRapid(IPostDataPtr pPD);
	void OutputFeed(IPostDataPtr pPD);
	void OutputSelectWorkPlane(IPostDataPtr pPD);
	void OutputUp(IPostDataPtr pPD);
	void OutputDown(IPostDataPtr pPD);
	void OutputOriginShift(IPostDataPtr pPD);
	void OutputCancelOriginShift(IPostDataPtr pPD);
	void OutputCallSub(IPostDataPtr pPD);
	void OutputBeginSub(IPostDataPtr pPD);
	void OutputEndSub(IPostDataPtr pPD);
	void OutputCutHoleCycleCancel(IPostDataPtr pPD);
	void OutputCutHoleCycleFirstHole(IPostDataPtr pPD);
	void OutputCutHoleCycleNextHoles(IPostDataPtr pPD);
	//int FilterFunction(const char *buf, char **buf_new);
};
