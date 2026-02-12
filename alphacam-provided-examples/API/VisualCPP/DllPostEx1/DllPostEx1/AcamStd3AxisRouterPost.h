#pragma once

#include "AcamPost.h"

class AcamStd3AxisRouterPost : public AcamRouterPost
{
	bool first_rapid;
	virtual CString GetPostName();
public:
	AcamStd3AxisRouterPost() : first_rapid(true) {}
	void AfterOpenPost(IPostConfigurePtr pPC);
	void OutputFileLeadingLines(IPostDataPtr pPD);
	void OutputProgramLeadingLines(IPostDataPtr pPD);
	void OutputProgramTrailingLines(IPostDataPtr pPD);
	void OutputFileTrailingLines(IPostDataPtr pPD);
	void OutputRapid(IPostDataPtr pPD);
	void OutputFeed(IPostDataPtr pPD);
	void OutputSelectWorkPlane(IPostDataPtr pPD);
	void OutputSelectToolAndWorkPlane(IPostDataPtr pPD);
	void OutputUp(IPostDataPtr pPD);
	void OutputDown(IPostDataPtr pPD);
	void OutputOriginShift(IPostDataPtr pPD);
	void OutputCancelOriginShift(IPostDataPtr pPD);
	void OutputCallSub(IPostDataPtr pPD);
	void OutputBeginSub(IPostDataPtr pPD);
	void OutputEndSub(IPostDataPtr pPD);
	void OutputSelectTool(IPostDataPtr pPD);
	void OutputCancelTool(IPostDataPtr pPD);
	void OutputMoveClamp(IPostDataPtr pPD);
	void OutputDrillCycleCancel(IPostDataPtr pPD);
	void OutputDrillCycleFirstHole(IPostDataPtr pPD);
	void OutputDrillCycleNextHoles(IPostDataPtr pPD);
	void OutputDrillCycleSubParameters(IPostDataPtr pPD);
	void OutputFirstHoleSub(IPostDataPtr pPD);
	void OutputNextHoleSub(IPostDataPtr pPD);
	//int FilterFunction(const char *buf, char **buf_new);
};
