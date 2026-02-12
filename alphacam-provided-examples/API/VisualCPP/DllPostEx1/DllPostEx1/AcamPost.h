// Base Class for Alphacam C++ DLL Post
#pragma once

class AcamPost
{
public:
	virtual void BeforeCreateNcUsingThisDLLPost(IAlphaCamAppPtr pApp) {}
	virtual void AfterOpenPost(IPostConfigurePtr pPC) = 0;
	virtual void OutputFileLeadingLines(IPostDataPtr pPD) = 0;
	virtual void OutputProgramLeadingLines(IPostDataPtr pPD) = 0;
	virtual void OutputProgramTrailingLines(IPostDataPtr pPD) = 0;
	virtual void OutputFileTrailingLines(IPostDataPtr pPD) = 0;
	virtual void OutputRapid(IPostDataPtr pPD) = 0;
	virtual void OutputFeed(IPostDataPtr pPD) = 0;
	virtual void OutputSelectWorkPlane(IPostDataPtr pPD) = 0;
	virtual void OutputUp(IPostDataPtr pPD) = 0;
	virtual void OutputDown(IPostDataPtr pPD) = 0;
	virtual void OutputOriginShift(IPostDataPtr pPD) = 0;
	virtual void OutputCancelOriginShift(IPostDataPtr pPD) = 0;
	virtual void OutputCallSub(IPostDataPtr pPD) = 0;
	virtual void OutputBeginSub(IPostDataPtr pPD) = 0;
	virtual void OutputEndSub(IPostDataPtr pPD) = 0;

	virtual int FilterFunction(const char *buf, char **buf_new) {return 1;}
	virtual ~AcamPost() {}
};

class AcamPostTool
{
public:
	virtual void OutputSelectTool(IPostDataPtr pPD) = 0;
	virtual void OutputCancelTool(IPostDataPtr pPD) = 0;
	virtual void OutputSelectToolAndWorkPlane(IPostDataPtr pPD) = 0;
	// No virtual destructor because this class should only be used with a class derived from AcamPost
};

class AcamPostClamp
{
public:
	virtual void OutputMoveClamp(IPostDataPtr pPD) = 0;
	// No virtual destructor because this class should only be used with a class derived from AcamPost
};

class AcamPostDrill
{
public:
	virtual void OutputDrillCycleCancel(IPostDataPtr pPD) = 0;
	virtual void OutputDrillCycleFirstHole(IPostDataPtr pPD) = 0;
	virtual void OutputDrillCycleNextHoles(IPostDataPtr pPD) = 0;
	virtual void OutputDrillCycleSubParameters(IPostDataPtr pPD) = 0;
	virtual void OutputFirstHoleSub(IPostDataPtr pPD) = 0;
	virtual void OutputNextHoleSub(IPostDataPtr pPD) = 0;
	// No virtual destructor because this class should only be used with a class derived from AcamPost
};

class AcamPostTurning
{
public:
	virtual void OutputLatheRapid(IPostDataPtr pPD) = 0;
	virtual void OutputThread(IPostDataPtr pPD) = 0;
	virtual void OutputLatheFeed(IPostDataPtr pPD) = 0;
	virtual void OutputSelectLatheTool(IPostDataPtr pPD) = 0;
	virtual void OutputChangeProgPoint(IPostDataPtr pPD) = 0;
	virtual void OutputSetSyncPoint(IPostDataPtr pPD) = 0;
	virtual void OutputLatheCycle(IPostDataPtr pPD) = 0;
	// No virtual destructor because this class should only be used with a class derived from AcamPost
};

class AcamPostCutHoleCycle
{
public:
	virtual void OutputCutHoleCycleCancel(IPostDataPtr pPD) = 0;
	virtual void OutputCutHoleCycleFirstHole(IPostDataPtr pPD) = 0;
	virtual void OutputCutHoleCycleNextHoles(IPostDataPtr pPD) = 0;
	// No virtual destructor because this class should only be used with a class derived from AcamPost
};

class AcamPostWireStop
{
public:
	virtual void OutputStop(IPostDataPtr pPD) = 0;
	// No virtual destructor because this class should only be used with a class derived from AcamPost
};

// Mill posts should be derived from AcamMillPost
class AcamMillPost : public AcamPost, public AcamPostTool, public AcamPostClamp, public AcamPostDrill
{
};

// Router posts should be derived from AcamRouterPost
class AcamRouterPost : public AcamPost, public AcamPostTool, public AcamPostClamp, public AcamPostDrill
{
};

// Lathe posts should be derived from AcamLathePost
class AcamLathePost : public AcamPost, public AcamPostTurning, public AcamPostTool, public AcamPostClamp, public AcamPostDrill
{
};

// Wire posts should be derived from AcamWirePost
class AcamWirePost : public AcamPost, public AcamPostWireStop
{
};

// Laser posts should be derived from AcamLaserPost
class AcamLaserPost : public AcamPost, public AcamPostCutHoleCycle
{
};

// Stone posts should be derived from AcamStonePost
class AcamStonePost : public AcamPost, public AcamPostTool, public AcamPostClamp, public AcamPostDrill
{
};

#define POST(string) pPD->Post(string);
#define POST_CSTRING(cstring) pPD->Post(_bstr_t(cstring));

#define ACAMAPIFUN(type) extern "C" __declspec(dllexport) type __stdcall

void SetAcamPost(AcamPost* p);
void CreateDefaultPost(IPostConfigurePtr pPC);
