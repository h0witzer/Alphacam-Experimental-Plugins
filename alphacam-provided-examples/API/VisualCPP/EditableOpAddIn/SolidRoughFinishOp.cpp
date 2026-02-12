// Example class to implement an editable operation.

// It creates a rough/finish pass around selected solid parts and surfaces.
// Selected geometries will be added to the op.

#include "stdafx.h"
#include "SolidRoughFinishOp.h"

// Copy machining data to attributes on the MillData.
// AttributeOp is used so the attributes are not copied to the tool paths.
void SolidRoughFinishOp::SetAttributes(const IMillDataPtr& MD) const
{
	MD->AttributeOp[GetAttributeName("m_stock")] = m_stock;
}

// Copy machining data from attributes on the MillData
void SolidRoughFinishOp::GetAttributes(const IMillDataPtr& MD)
{
	m_stock = MD->AttributeOp[GetAttributeName("m_stock")];
}

// Create tool paths given geometries and MillData.
void SolidRoughFinishOp::Update(const IAlphaCamAppPtr& App, const IAlphacamObjectsPtr& Geos, const IMillDataPtr& MD)
{
	GetAttributes(MD);
	DoMachining(App, Geos, MD);
}

// Show the dialog boxes to edit the data.
// Return 0 if ok, non-zero to cancel the edit.
int SolidRoughFinishOp::Edit(const IAlphaCamAppPtr& App, const IMillDataPtr& MD)
{
	GetAttributes(MD);
	if(ShowDialogBoxes(App)) return 1;
	SetAttributes(MD);
	return 0;
}

// Show dialog boxes. Return 0 if ok, non-zero if aborted
int SolidRoughFinishOp::ShowDialogBoxes(const IAlphaCamAppPtr& App)
{
	return !App->Frame->InputFloatDialog("Solid Rough/Finish", "Stock", acamFloatNON_NEG, &m_stock);
}

// Select solids and geometry paths and call the routine to do the machining
void SolidRoughFinishOp::DoCmd(const IAlphaCamAppPtr& App)
{
	IDrawingPtr Drw = App->ActiveDrawing;
	if(!Drw->UserSelectMultiGeos2("Solid Rough/Finish: select solids/geometries",
		acamSelectSPLINES + acamSelectSURFACES + acamSelectDRAW_SELECTED,
		acamSelectSOLIDS + acamSelectGEOMETRY_PATHS)) return;

	// Build a collection for everything selected
	IAlphacamObjectsPtr Geos = Drw->CreateAlphacamObjectsCollection();
	
	ISolidPartsPtr Parts = Drw->SolidParts;
	for(int i = 1 ; i <= Parts->Count ; ++i)
	{
		ISolidPartPtr Part = Parts->Item(i);
		if(Part->Selected)
		{
			Geos->Add(Part);
			Part->Selected = FALSE;
		}
	}
	ISurfacesPtr Surfaces = Drw->Surfaces;
	for(int i = 1 ; i <= Surfaces->Count ; ++i)
	{
		ISurfacePtr Surface = Surfaces->Item(i);
		if(Surface->Selected)
		{
			Geos->Add(Surface);
			Surface->Selected = FALSE;
		}
	}
	IPathsPtr Paths = Drw->Geometries;
	for(int i = 1 ; i <= Paths->Count ; ++i)
	{
		IPathPtr Path = Paths->Item(i);
		if(Path->Selected && !Path->Is3D)
		{
			Geos->Add(Path);
			Path->Selected = FALSE;
		}
	}
	DoMachining(App, Geos, NULL);
}

// Do the op given geometry, which must include at least one solid or surface (to set the Z)
// and may include geometries.
void SolidRoughFinishOp::DoMachining(const IAlphaCamAppPtr& App, const IAlphacamObjectsPtr& Geos, const IMillDataPtr& MDForAssociate)
{
	if(Geos->Count == 0) return;

	IMillToolPtr Tool = App->GetCurrentTool();
	if(!Tool) return;

	// Create a new MillData to create the tool paths, and associate them with the passed one if this is an update, else the new one
	IMillDataPtr MDUpdate = MDForAssociate;
	IMillDataPtr MD = App->CreateMillData();
	if(!MDUpdate) MDUpdate = MD;

	// Find the extent
	const double Big = 1.e10;
	double MinX = Big, MaxX = -Big, MinY = Big, MaxY = -Big, MinZ = Big, MaxZ = -Big;

    // Loop through the passed geometries looking for the SolidParts and surfaces
	for(int i = 1 ; i <= Geos->Count ; ++i)
	{
		IDispatchPtr Geo = Geos->Item(i);
		// See if it is a SolidPart
		ISolidPartPtr Part = Geo;
		if(Part)
		{
			MDUpdate->AssociateGeometry(Geo, 100);
            double A = Part->MinX;
            if(A < MinX) MinX = A;
			A = Part->MaxX;
			if(A > MaxX) MaxX = A;
            A = Part->MinY;
            if(A < MinY) MinY = A;
			A = Part->MaxY;
			if(A > MaxY) MaxY = A;
            A = Part->MinZ;
            if(A < MinZ) MinZ = A;
			A = Part->MaxZ;
			if(A > MaxZ) MaxZ = A;
		}
		else
		{
			// See if it is a surface
			ISurfacePtr Surface = Geo;
			if(Surface)
			{
				MDUpdate->AssociateGeometry(Geo, 200);
				double A = Surface->MinX;
				if(A < MinX) MinX = A;
				A = Surface->MaxX;
				if(A > MaxX) MaxX = A;
				A = Surface->MinY;
				if(A < MinY) MinY = A;
				A = Surface->MaxY;
				if(A > MaxY) MaxY = A;
				A = Surface->MinZ;
				if(A < MinZ) MinZ = A;
				A = Surface->MaxZ;
				if(A > MaxZ) MaxZ = A;
			}
		}
	}
	if(MaxZ < MinZ) return;

	IPathsPtr PathsToDelete = App->ActiveDrawing->CreatePathCollection();

    // Create a rectangle around the extent
    IPathPtr Rect = App->ActiveDrawing->CreateRectangle(MinX, MinY, MaxX, MaxY);
    Rect->ToolInOut = acamOUTSIDE;
    Rect->Selected = VARIANT_TRUE;
    PathsToDelete->Add(Rect);

	// Select the geometries
	for(int i = 1 ; i <= Geos->Count ; ++i)
	{
		IPathPtr Path = Geos->Item(i);
		if(Path)
		{
			Path->Selected = VARIANT_TRUE;
			MDUpdate->AssociateGeometry(Path, 300);
		}
	}

	// Machine the rectangle
    MD->SafeRapidLevel = static_cast<float>(MaxZ + Tool->Diameter * 0.5);
    MD->RapidDownTo = static_cast<float>(MaxZ + Tool->Diameter * 0.1);
    MD->MaterialTop = static_cast<float>(MaxZ);
    MD->FinalDepth = static_cast<float>(MinZ);
    MD->NumberOfCuts = static_cast<short>((MaxZ - MinZ) / Tool->Diameter * 2 + 1);
    MD->Stock = m_stock;
      
    IPathsPtr ToolPaths = MD->RoughFinish();

	MDUpdate->AssociateToolPaths(ToolPaths);
    
    PathsToDelete->Delete();

	SetFunctions(MDUpdate);
	SetAttributes(MDUpdate);
}

// This function will be called before adding geometries to the operation.
// Geos contains the selected geometries. To reject a geometry set its Selected property to False.
// Return non-zero to reject all geometries.
int SolidRoughFinishOp::BeforeAddGeometries(const IAlphaCamAppPtr& App, const IAlphacamObjectsPtr& Geos, const IMillDataPtr& MD)
{
	// Reject solid part if the name contains "Ball", and 3D paths
	for(int i = 1 ; i <= Geos->Count ; ++i)
	{
		IDispatchPtr Geo = Geos->Item(i);
		// See if it is a SolidPart
		ISolidPartPtr Part = Geo;
		if(Part)	// Will be NULL if Geo is not a SolidPart
		{
			CString name = Part->Name;
			if(name.Find("Ball") > -1) Part->Selected = VARIANT_FALSE;
		}
		else
		{
			IPathPtr Path = Geo;
			if(Path)	// Will be NULL if Geo is not a Path
			{
				if(Path->Is3D) Path->Selected = VARIANT_FALSE;
			}
		}
	}
	return 0;	// Accept any that are still selected
}

// This function will be called before showing the context menu for a geometry.
// Return non-zero to disable the "Remove From Operation" item.
int SolidRoughFinishOp::BeforeRemoveGeometry(const IAlphaCamAppPtr& App, const IDispatchPtr& Geo, const IMillDataPtr& MD)
{
    // For this add-in we must have at least one solid part or surface (for the Z extent)
	ISolidPartPtr Part = Geo;
	ISurfacePtr Surface = Geo;
	if(!Part && !Surface)
	{
        // Not a solid or surface so can remove it
		return 0;	// Enable
	}
    // Is a solid or surface so need to see how many there are
	int n = 0;
	IAlphacamObjectsPtr Geos = MD->GetGeometries();
	for(int i = 1 ; i <= Geos->Count && n < 2 ; ++i)
	{
		IDispatchPtr Geo = Geos->Item(i);
		// See if it is a SolidPart
		ISolidPartPtr Part = Geo;
		if(Part) ++n;
		else
		{
			ISurfacePtr Surface = Geo;
			if(Surface) ++n;
		}
	}
	return n == 1;
}

// This function will be called before the tool is changed by the "Change Tool" option in the operations manager.
// Return non-zero to reject the tool. Otherwise set flags so tool data can be updated.
// Alphacam will call the "Edit" function so the user can update the settings eg width of cut.
int SolidRoughFinishOp::BeforeChangeTool(const IAlphaCamAppPtr& App, const IMillToolPtr& Tool, const IMillDataPtr& MD)
{
	return Tool->Type == acamToolDRILL;	// Disable if a drill
}
