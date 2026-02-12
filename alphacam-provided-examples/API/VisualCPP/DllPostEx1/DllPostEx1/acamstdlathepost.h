#pragma once

#include "AcamPost.h"

class AcamStdLathePost : public AcamLathePost
{
	bool FirstRapid;
	bool NoLineNumbers;
	virtual CString GetPostName();
	int OldWP;
	void ShowToolChangePos(IPostDataPtr pPD);
public:
	AcamStdLathePost() : FirstRapid(true), NoLineNumbers(false) {}
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
	void OutputLatheRapid(IPostDataPtr pPD);
	void OutputThread(IPostDataPtr pPD);
	void OutputLatheFeed(IPostDataPtr pPD);
	void OutputSelectLatheTool(IPostDataPtr pPD);
	void OutputChangeProgPoint(IPostDataPtr pPD);
	void OutputSetSyncPoint(IPostDataPtr pPD);
	void OutputLatheCycle(IPostDataPtr pPD);
	int FilterFunction(const char *buf, char **buf_new);
};
