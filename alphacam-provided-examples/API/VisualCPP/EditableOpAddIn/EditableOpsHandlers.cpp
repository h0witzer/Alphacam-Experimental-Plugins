// Functions to handle notifications from Alphacam to update or edit the operation.
// Each function extracts the objects from the Variants and calls the corresponding member of the
// class dervied from EditableOp.

#include "stdafx.h"
#include "EditableOp.h"

// Register the functions to handle the op.
void EditableOp::SetFunctions(const IMillDataPtr& MD)
{
	MD->SetUpdateFunction("HandleUpdate");
	MD->SetEditFunction("HandleEdit");
	MD->SetBeforeAddGeometriesFunction(WantBeforeAddGeometries() ? "HandleBeforeAddGeometries" : "");
	MD->SetBeforeRemoveGeometryFunction(WantBeforeRemoveGeometry() ? "HandleBeforeRemoveGeometry" : "");
	MD->SetBeforeChangeToolFunction(WantBeforeChangeTool() ? "HandleBeforeChangeTool" : "");
}
// Function called by Alphacam to update the op. Redirect to class member.
ACAMAPIFUN(void) HandleUpdate(VARIANT var_acam, VARIANT var_geos, VARIANT var_MD)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	ACAMAPP(var_acam);		// acam is Application object
	IDrawingPtr pDrw(acam->ActiveDrawing);

	IAlphacamObjectsPtr Geos(var_geos.pdispVal);
	IMillDataPtr MD(var_MD.pdispVal);

	EditableOp* pEditableOp = EditableOp::GetEditableOp();

	if(pEditableOp)
	{
		pDrw->ScreenUpdating = VARIANT_FALSE;	// Alphacam will redraw after re-ordering the operations so no point drawing here

		pEditableOp->Update(acam, Geos, MD);

		pDrw->ScreenUpdating = VARIANT_TRUE;
	}
}

// Function called by Alphacam to edit the op. Redirect to class member.
ACAMAPIFUN(int) HandleEdit(VARIANT var_acam, VARIANT var_MD)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	ACAMAPP(var_acam);		// acam is Application object
	
	IMillDataPtr MD(var_MD.pdispVal);

	EditableOp* pEditableOp = EditableOp::GetEditableOp();

	if(pEditableOp) return pEditableOp->Edit(acam, MD);
	return 1;
}

// Function called by Alphacam before adding geometries to the op. Redirect to class member.
ACAMAPIFUN(int) HandleBeforeAddGeometries(VARIANT var_acam, VARIANT var_geos, VARIANT var_MD)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	ACAMAPP(var_acam);		// acam is Application object
	IDrawingPtr pDrw(acam->ActiveDrawing);

	IAlphacamObjectsPtr Geos(var_geos.pdispVal);
	IMillDataPtr MD(var_MD.pdispVal);

	EditableOp* pEditableOp = EditableOp::GetEditableOp();

	if(pEditableOp) return pEditableOp->BeforeAddGeometries(acam, Geos, MD);
	return 1;
}

// Function called by Alphacam before removing a geometry from the op. Redirect to class member.
ACAMAPIFUN(int) HandleBeforeRemoveGeometry(VARIANT var_acam, VARIANT var_geo, VARIANT var_MD)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	ACAMAPP(var_acam);		// acam is Application object
	IDrawingPtr pDrw(acam->ActiveDrawing);

	IDispatchPtr Geo(var_geo.pdispVal);
	IMillDataPtr MD(var_MD.pdispVal);

	EditableOp* pEditableOp = EditableOp::GetEditableOp();

	if(pEditableOp) return pEditableOp->BeforeRemoveGeometry(acam, Geo, MD);
	return 1;
}

// Function called by Alphacam before changing the tool for the op. Redirect to class member.
ACAMAPIFUN(int) HandleBeforeChangeTool(VARIANT var_acam, VARIANT var_Tool, VARIANT var_MD)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	ACAMAPP(var_acam);		// acam is Application object
	
	IMillToolPtr Tool(var_Tool.pdispVal);
	IMillDataPtr MD(var_MD.pdispVal);

	EditableOp* pEditableOp = EditableOp::GetEditableOp();
	if(pEditableOp) return pEditableOp->BeforeChangeTool(acam, Tool, MD);
	return 1;
}
