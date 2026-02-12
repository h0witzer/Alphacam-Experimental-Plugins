using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;

using AlphaCAMMill;
using System.Windows.Forms;
using System.Xml.Linq;

namespace ExamplePost2
{
	public class AlphacamPostEvents
	{
		IAlphaCamApp Acam;
		AddInPostInterfaceClass PostInterface;
		Post post;

		public AlphacamPostEvents(IAlphaCamApp Acam)
		{
			this.Acam = Acam;
			Frame Frm = Acam.Frame;

			int pl = Acam.ProgramLetter;
			if (pl == 'R')
				post = new RouterPost(Acam);
			else if (pl == 'M')
				post = new MillPost(Acam);
			else if (pl == 'L')
				post = new LaserPost(Acam);
			else if (pl == 'E')
				post = new WirePost(Acam);
			else if (pl == 'T')
				post = new LathePost(Acam);
			else if (pl == 'S')
				post = new StonePost(Acam);

			PostInterface = Frm.CreateAddInPostInterface() as AddInPostInterfaceClass;
			if (PostInterface != null)
			{
				PostInterface.AfterCreateNc += AfterCreateNc;
				PostInterface.AfterOutputNc += AfterOutputNc;
				PostInterface.AfterPostSimulation += AfterPostSimulation;
				PostInterface.AfterOpenPost += AfterOpenPost;
				PostInterface.BeforeCreateNc += BeforeCreateNc;
				PostInterface.BeforePostSimulation += BeforePostSimulation;
				PostInterface.FilterFunction += FilterFunction;
				PostInterface.OutputBeginSub += OutputBeginSub;
				PostInterface.OutputCallSub += OutputCallSub;
				PostInterface.OutputCancelTool += OutputCancelTool;
				PostInterface.OutputCancelOriginShift += OutputCancelOriginShift;
				PostInterface.OutputChangeProgPoint += OutputChangeProgPoint;
				PostInterface.OutputCutAndMoveMaterial += OutputCutAndMoveMaterial;
				PostInterface.OutputCutHoleCycleCancel += OutputCutHoleCycleCancel;
				PostInterface.OutputCutHoleCycleFirstHole += OutputCutHoleCycleFirstHole;
				PostInterface.OutputCutHoleCycleNextHoles += OutputCutHoleCycleNextHoles;
				PostInterface.OutputDrillCycleCancel += OutputDrillCycleCancel;
				PostInterface.OutputDrillCycleFirstHole += OutputDrillCycleFirstHole;
				PostInterface.OutputDrillCycleNextHoles += OutputDrillCycleNextHoles;
				PostInterface.OutputDrillCycleSubParameters += OutputDrillCycleSubParameters;
				PostInterface.OutputDown += OutputDown;
				PostInterface.OutputDummyOp += OutputDummyOp;
				PostInterface.OutputEndSub += OutputEndSub;
				PostInterface.OutputFeed += OutputFeed;
				PostInterface.OutputFileLeadingLines += OutputFileLeadingLines;
				PostInterface.OutputFileTrailingLines += OutputFileTrailingLines;
				PostInterface.OutputFirstHoleSub += OutputFirstHoleSub;
				PostInterface.OutputLatheCycle += OutputLatheCycle;
				PostInterface.OutputLatheFeed += OutputLatheFeed;
				PostInterface.OutputLatheRapid += OutputLatheRapid;
				PostInterface.OutputMoveClamp += OutputMoveClamp;
				PostInterface.OutputMoveMaterial += OutputMoveMaterial;
				PostInterface.OutputNextHoleSub += OutputNextHoleSub;
				PostInterface.OutputOriginShift += OutputOriginShift;
				PostInterface.OutputProgramLeadingLines += OutputProgramLeadingLines;
				PostInterface.OutputProgramTrailingLines += OutputProgramTrailingLines;
				PostInterface.OutputRapid += OutputRapid;
				PostInterface.OutputSawCycle += OutputSawCycle;
				PostInterface.OutputSelectLatheTool += OutputSelectLatheTool;
				PostInterface.OutputSelectTool += OutputSelectTool;
				PostInterface.OutputSelectToolAndWorkPlane += OutputSelectToolAndWorkPlane;
				PostInterface.OutputSelectWorkPlane += OutputSelectWorkPlane;
				PostInterface.OutputSetSyncPoint += OutputSetSyncPoint;
				PostInterface.OutputStop += OutputStop;
				PostInterface.OutputThread += OutputThread;
				PostInterface.OutputUp += OutputUp;
				// Extra event functions unique to C# Posts
				PostInterface.BeforeOutputNc += BeforeOutputNc;
				PostInterface.BeforeOutputNcDialogBox += BeforeOutputNcDialogBox;
				PostInterface.BeforeCreateAnyNc += BeforeCreateAnyNc;
			}
			Marshal.ReleaseComObject(Frm);
		}

		// Implementations all call appropriate methods in the post class

		void BeforeOutputNc(EventDataFileName Data)
		{
			post.BeforeOutputNc(Data);
		}

		void BeforeOutputNcDialogBox(EventData Data)
		{
			post.BeforeOutputNcDialogBox(Data);
		}
		void BeforeCreateAnyNc(EventData Data)
		{
			post.BeforeCreateAnyNc(Data);
		}

		void AfterCreateNc()
		{
			post.AfterCreateNc();
		}
		void AfterOutputNc(string str)
		{
			post.AfterOutputNc(str);
		}
		void AfterPostSimulation()
		{
			post.AfterPostSimulation();
		}
		void BeforeCreateNc()
		{
			post.BeforeCreateNc();
		}
		void BeforePostSimulation()
		{
			post.BeforePostSimulation();
		}
		void OutputFileLeadingLines(PostData P)
		{
			post.OutputFileLeadingLines(P);
		}
		void OutputProgramLeadingLines(PostData P)
		{
			post.OutputProgramLeadingLines(P);
		}
		void OutputProgramTrailingLines(PostData P)
		{
			post.OutputProgramTrailingLines(P);
		}
		void OutputFileTrailingLines(PostData P)
		{
			post.OutputFileTrailingLines(P);
		}
		void OutputRapid(PostData P)
		{
			post.OutputRapid(P);
		}
		void OutputFeed(PostData P)
		{
			post.OutputFeed(P);
		}
		void OutputCancelTool(PostData P)
		{
			post.OutputCancelTool(P);
		}
		void OutputSelectTool(PostData P)
		{
			post.OutputSelectTool(P);
		}
		void OutputSelectWorkPlane(PostData P)
		{
			post.OutputSelectWorkPlane(P);
		}
		void OutputSelectToolAndWorkPlane(PostData P)
		{
			post.OutputSelectToolAndWorkPlane(P);
		}
		void OutputCallSub(PostData P)
		{
			post.OutputCallSub(P);
		}
		void OutputBeginSub(PostData P)
		{
			post.OutputBeginSub(P);
		}
		void OutputEndSub(PostData P)
		{
			post.OutputEndSub(P);
		}
		void OutputOriginShift(PostData P)
		{
			post.OutputOriginShift(P);
		}
		void OutputCancelOriginShift(PostData P)
		{
			post.OutputCancelOriginShift(P);
		}
		void OutputDrillCycleCancel(PostData P)
		{
			post.OutputDrillCycleCancel(P);
		}
		void OutputFirstHoleSub(PostData P)
		{
			post.OutputFirstHoleSub(P);
		}
		void OutputNextHoleSub(PostData P)
		{
			post.OutputNextHoleSub(P);
		}
		void OutputDrillCycleFirstHole(PostData P)
		{
			post.OutputDrillCycleFirstHole(P);
		}
		void OutputDrillCycleNextHoles(PostData P)
		{
			post.OutputDrillCycleNextHoles(P);
		}
		void OutputDrillCycleSubParameters(PostData P)
		{
			post.OutputDrillCycleSubParameters(P);
		}
		void OutputCutHoleCycleCancel(PostData P)
		{
			post.OutputCutHoleCycleCancel(P);
		}
		void OutputCutHoleCycleFirstHole(PostData P)
		{
			post.OutputCutHoleCycleFirstHole(P);
		}
		void OutputCutHoleCycleNextHoles(PostData P)
		{
			post.OutputCutHoleCycleNextHoles(P);
		}
		void OutputUp(PostData P)
		{
			post.OutputUp(P);
		}
		void OutputDown(PostData P)
		{
			post.OutputDown(P);
		}
		void OutputDummyOp(PostData P)
		{
			post.OutputDummyOp(P);
		}
		void OutputChangeProgPoint(PostData P)
		{
			post.OutputChangeProgPoint(P);
		}
		void OutputSelectLatheTool(PostData P)
		{
			post.OutputSelectLatheTool(P);
		}
		void OutputSetSyncPoint(PostData P)
		{
			post.OutputSetSyncPoint(P);
		}
		void OutputLatheCycle(PostData P)
		{
			post.OutputLatheCycle(P);
		}
		void OutputLatheFeed(PostData P)
		{
			post.OutputLatheFeed(P);
		}
		void OutputLatheRapid(PostData P)
		{
			post.OutputLatheRapid(P);
		}
		void OutputThread(PostData P)
		{
			post.OutputThread(P);
		}
		void OutputMoveMaterial(PostData P)
		{
			post.OutputMoveMaterial(P);
		}
		void OutputMoveClamp(PostData P)
		{
			post.OutputMoveClamp(P);
		}
		void OutputCutAndMoveMaterial(PostData P)
		{
			post.OutputCutAndMoveMaterial(P);
		}
		void OutputSawCycle(PostData P)
		{
			post.OutputSawCycle(P);
		}
		void OutputStop(PostData P)
		{
			post.OutputStop(P);
		}
		void AfterOpenPost(PostConfigure PC)
		{
			post.AfterOpenPost(PC);
		}
		void FilterFunction(string Buffer, EventDataText Data)
		{
			post.FilterFunction(Buffer, Data);
		}
	}
}
