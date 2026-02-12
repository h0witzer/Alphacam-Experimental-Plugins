// Interface between exported DLL functions and AcamPost class
// This file (and AcamPost.h) should not be changed.
// To create a new post derive a class from the correct one for the module:
//	AcamMillPost, AcamRouterPost, AcamLathePost, AcamWirePost, AcamLaserPost, AcamStonePost
// and implement the functions.

#include "stdafx.h"
#include "AcamPost.h"

#define ACAMPOSTFUN(function_name) ACAMAPIFUN(void) function_name (VARIANT var_pd) { AFX_MANAGE_STATE(AfxGetStaticModuleState())	GETPD if(pPost) pPost->function_name(pPD);}
#define GETPD IPostDataPtr pPD(var_pd.pdispVal);

namespace
{
	// The post class pointer to be used
	AcamPost* pPost;
}

// Set the Post to be used
void SetAcamPost(AcamPost* p)
{
	if(pPost) delete pPost;
	pPost = p;
}

// The following functions map the exported functions that Alphacam calls to member functions
// of the AcamPost class and its derived classes

// This function is called when AlphaCAM is about to List or Output NC using this post
// Also see BeforeCreateNc
ACAMAPIFUN(void) BeforeCreateNcUsingThisDLLPost(VARIANT var_acam)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IAlphaCamAppPtr pApp(var_acam.pdispVal);
	if(pPost) pPost->BeforeCreateNcUsingThisDLLPost(pApp);
}
// This is called only when the Post is first read by AlphaCAM
// eg on startup or if it is reselected
ACAMAPIFUN(void) AfterOpenPost(VARIANT var_pc)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostConfigurePtr pPC(var_pc.pdispVal);

	if(!pPost) CreateDefaultPost(pPC);	// if the DLL was loaded as a post, not an add-in

	if(pPost) pPost->AfterOpenPost(pPC);
}
// Functions needed in all posts
ACAMPOSTFUN(OutputFileLeadingLines)
ACAMPOSTFUN(OutputProgramLeadingLines)
ACAMPOSTFUN(OutputProgramTrailingLines)
ACAMPOSTFUN(OutputFileTrailingLines)
ACAMPOSTFUN(OutputRapid)
ACAMPOSTFUN(OutputFeed)
ACAMPOSTFUN(OutputSelectWorkPlane)
ACAMPOSTFUN(OutputUp)
ACAMPOSTFUN(OutputDown)
ACAMPOSTFUN(OutputOriginShift)
ACAMPOSTFUN(OutputCancelOriginShift)
ACAMPOSTFUN(OutputCallSub)
ACAMPOSTFUN(OutputBeginSub)
ACAMPOSTFUN(OutputEndSub)

// Functions used to select or cancel tools
ACAMAPIFUN(void) OutputSelectTool(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostTool* pPost2 = dynamic_cast<AcamPostTool*>(pPost);
		if(pPost2) pPost2->OutputSelectTool(pPD);
	}
}
ACAMAPIFUN(void) OutputSelectToolAndWorkPlane(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostTool* pPost2 = dynamic_cast<AcamPostTool*>(pPost);
		if(pPost2) pPost2->OutputSelectToolAndWorkPlane(pPD);
	}
}
ACAMAPIFUN(void) OutputCancelTool(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostTool* pPost2 = dynamic_cast<AcamPostTool*>(pPost);
		if(pPost2) pPost2->OutputCancelTool(pPD);
	}
}

// Function to move a clamp
ACAMAPIFUN(void) OutputMoveClamp(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostClamp* pPost2 = dynamic_cast<AcamPostClamp*>(pPost);
		if(pPost2) pPost2->OutputMoveClamp(pPD);
	}
}

// Functions for drilling
ACAMAPIFUN(void) OutputDrillCycleCancel(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostDrill* pPost2 = dynamic_cast<AcamPostDrill*>(pPost);
		if(pPost2) pPost2->OutputDrillCycleCancel(pPD);
	}
}
ACAMAPIFUN(void) OutputDrillCycleFirstHole(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostDrill* pPost2 = dynamic_cast<AcamPostDrill*>(pPost);
		if(pPost2) pPost2->OutputDrillCycleFirstHole(pPD);
	}
}
ACAMAPIFUN(void) OutputDrillCycleNextHoles(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostDrill* pPost2 = dynamic_cast<AcamPostDrill*>(pPost);
		if(pPost2) pPost2->OutputDrillCycleNextHoles(pPD);
	}
}
ACAMAPIFUN(void) OutputDrillCycleSubParameters(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostDrill* pPost2 = dynamic_cast<AcamPostDrill*>(pPost);
		if(pPost2) pPost2->OutputDrillCycleSubParameters(pPD);
	}
}
ACAMAPIFUN(void) OutputFirstHoleSub(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostDrill* pPost2 = dynamic_cast<AcamPostDrill*>(pPost);
		if(pPost2) pPost2->OutputFirstHoleSub(pPD);
	}
}
ACAMAPIFUN(void) OutputNextHoleSub(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostDrill* pPost2 = dynamic_cast<AcamPostDrill*>(pPost);
		if(pPost2) pPost2->OutputNextHoleSub(pPD);
	}
}
// Functions for turning
ACAMAPIFUN(void) OutputLatheRapid(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostTurning* pPost2 = dynamic_cast<AcamPostTurning*>(pPost);
		if(pPost2) pPost2->OutputLatheRapid(pPD);
	}
}
ACAMAPIFUN(void) OutputThread(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostTurning* pPost2 = dynamic_cast<AcamPostTurning*>(pPost);
		if(pPost2) pPost2->OutputThread(pPD);
	}
}
ACAMAPIFUN(void) OutputLatheFeed(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostTurning* pPost2 = dynamic_cast<AcamPostTurning*>(pPost);
		if(pPost2) pPost2->OutputLatheFeed(pPD);
	}
}
ACAMAPIFUN(void) OutputSelectLatheTool(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostTurning* pPost2 = dynamic_cast<AcamPostTurning*>(pPost);
		if(pPost2) pPost2->OutputSelectLatheTool(pPD);
	}
}
ACAMAPIFUN(void) OutputChangeProgPoint(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostTurning* pPost2 = dynamic_cast<AcamPostTurning*>(pPost);
		if(pPost2) pPost2->OutputChangeProgPoint(pPD);
	}
}
ACAMAPIFUN(void) OutputSetSyncPoint(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostTurning* pPost2 = dynamic_cast<AcamPostTurning*>(pPost);
		if(pPost2) pPost2->OutputSetSyncPoint(pPD);
	}
}
ACAMAPIFUN(void) OutputLatheCycle(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostTurning* pPost2 = dynamic_cast<AcamPostTurning*>(pPost);
		if(pPost2) pPost2->OutputLatheCycle(pPD);
	}
}

ACAMAPIFUN(void) OutputCutHoleCycleFirstHole(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostCutHoleCycle* pPost2 = dynamic_cast<AcamPostCutHoleCycle*>(pPost);
		if(pPost2) pPost2->OutputCutHoleCycleFirstHole(pPD);
	}
}
ACAMAPIFUN(void) OutputCutHoleCycleNextHoles(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostCutHoleCycle* pPost2 = dynamic_cast<AcamPostCutHoleCycle*>(pPost);
		if(pPost2) pPost2->OutputCutHoleCycleNextHoles(pPD);
	}
}
ACAMAPIFUN(void) OutputCutHoleCycleCancel(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostCutHoleCycle* pPost2 = dynamic_cast<AcamPostCutHoleCycle*>(pPost);
		if(pPost2) pPost2->OutputCutHoleCycleCancel(pPD);
	}
}

ACAMAPIFUN(void) OutputStop(VARIANT var_pd)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	IPostDataPtr pPD(var_pd.pdispVal);
	if(pPost)
	{
		AcamPostWireStop* pPost2 = dynamic_cast<AcamPostWireStop*>(pPost);
		if(pPost2) pPost2->OutputStop(pPD);
	}
}

// If this function exists it will be called before AlphaCAM outputs each line.
// To change the output, allocate a new string containing the required output
// and return a pointer to it. (AlphaCAM will free the string (free, NOT delete, so don't use new))
// To output nothing, set buf_new to "".
// If the return value is non-zero buf_new will be ignored, and this function
// will not be called again until the post is reselected.

ACAMAPIFUN(int) FilterFunction(const char *buf, char **buf_new)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState())
	if(pPost) return pPost->FilterFunction(buf, buf_new);
	return 1;
}
