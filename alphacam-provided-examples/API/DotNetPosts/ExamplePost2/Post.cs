using AlphaCAMMill;

// Base class for a Post Processor
class Post
{
	public virtual void AfterCreateNc() { }
	public virtual void AfterOutputNc(string str) { }
	public virtual void AfterPostSimulation() { }
	public virtual void BeforeCreateNc() { }
	public virtual void BeforePostSimulation() { }
	public virtual void AfterOpenPost(IPostConfigure PC) { }
	public virtual void OutputFileLeadingLines(IPostData PD) { }
	public virtual void OutputProgramLeadingLines(IPostData PD) { }
	public virtual void OutputProgramTrailingLines(IPostData PD) { }
	public virtual void OutputFileTrailingLines(IPostData PD) { }
	public virtual void OutputRapid(IPostData PD) { }
	public virtual void OutputFeed(IPostData PD) { }

	// Tool change (Router, Mill, Stone, Lathe only)
	public virtual void OutputSelectTool(IPostData PD) { }
	public virtual void OutputCancelTool(IPostData PD) { }
	public virtual void OutputSelectToolAndWorkPlane(IPostData PD) { }
	// End Tool change (Router, Mill, Stone, Lathe only)

	public virtual void OutputSelectWorkPlane(IPostData PD) { }
	public virtual void OutputUp(IPostData PD) { }
	public virtual void OutputDown(IPostData PD) { }
	public virtual void OutputOriginShift(IPostData PD) { }
	public virtual void OutputCancelOriginShift(IPostData PD) { }
	public virtual void OutputCallSub(IPostData PD) { }
	public virtual void OutputBeginSub(IPostData PD) { }
	public virtual void OutputEndSub(IPostData PD) { }

	// Clamps and Materials (Router, Mill, Stone, Lathe only)
	public virtual void OutputMoveClamp(IPostData PD) { }
	public virtual void OutputMoveMaterial(PostData PD) { }
	// Stone only
	public virtual void OutputCutAndMoveMaterial(PostData PD) { }
	// End Clamps and Materials (Router, Mill, Stone, Lathe only)

	// Drilling (Router, Mill, Stone, Lathe only)
	public virtual void OutputDrillCycleCancel(IPostData PD) { }
	public virtual void OutputDrillCycleFirstHole(IPostData PD) { }
	public virtual void OutputDrillCycleNextHoles(IPostData PD) { }
	public virtual void OutputDrillCycleSubParameters(IPostData PD) { }
	public virtual void OutputFirstHoleSub(IPostData PD) { }
	public virtual void OutputNextHoleSub(IPostData PD) { }
	// End Drilling (Router, Mill, Stone, Lathe only)

	// Cut Holes (Laser only)
	public virtual void OutputCutHoleCycleCancel(IPostData PD) { }
	public virtual void OutputCutHoleCycleFirstHole(IPostData PD) { }
	public virtual void OutputCutHoleCycleNextHoles(IPostData PD) { }
	// End Cut Holes (Laser only)

	// Lathe only
	public virtual void OutputLatheRapid(IPostData PD) { }
	public virtual void OutputThread(IPostData PD) { }
	public virtual void OutputLatheFeed(IPostData PD) { }
	public virtual void OutputSelectLatheTool(IPostData PD) { }
	public virtual void OutputChangeProgPoint(IPostData PD) { }
	public virtual void OutputSetSyncPoint(IPostData PD) { }
	public virtual void OutputLatheCycle(IPostData PD) { }
	// End Lathe only

	// Wire only
	public virtual void OutputStop(IPostData PD) { }
	// End Wire only

	public virtual void OutputSawCycle(PostData PD) { }
	public virtual void OutputDummyOp(PostData PD) { }

	// Filter function - default is no filtering (return is 1)
	public virtual int FilterFunction(string Buffer, EventDataText Data)
	{
		return 1;
	}

	// Additional C# events for Posts - default implementations do nothing
	public virtual void BeforeOutputNc(EventDataFileName Data)
	{
		// Called before ALPHACAM shows save NC file dialog box

		// Set Data.ReturnCode to one of these values:
		// 0 if ALPHACAM should show normal the dialog box
		// 1 to supply a filename and write the filename to Data.FileName
		// 2 to cancel output
		Data.ReturnCode = 0;
	}

	public virtual void BeforeOutputNcDialogBox(EventData Data)
	{
		// Called before the Output NC dialog appears asking the user where to output NC (File, Machine, or Both)

		// Set Data.ReturnCode to one of these values:
		// 0 if ALPHACAM should show normal the dialog box
		// 1 to force File output
		// 2 to force Machine output
		// 3 to force Both
		// 10 to cancel output
		Data.ReturnCode = 0;
	}
	public virtual void BeforeCreateAnyNc(EventData Data)
	{
		// Called before any NC is created allowing Post to potentially disable output
		// See also BeforeCreateNc which is called once but does not allow disabling output. BeforeCreateNc will be called multiple
		// times if outputing a drawing with multiple nested sheets.

		// Set Data.ReturnCode to one of these values:
		// 0 if ALPHACAM should continue as normal
		// 1 to cancel NC output
		Data.ReturnCode = 0;
	}
}