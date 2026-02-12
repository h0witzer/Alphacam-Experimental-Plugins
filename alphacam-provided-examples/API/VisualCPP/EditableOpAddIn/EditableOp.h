// Base class for an Editable Operation
#pragma once

#define ACAMAPIFUN(type) extern "C" __declspec(dllexport) type __stdcall
#define ACAMAPP(var) IAlphaCamAppPtr acam(var.pdispVal);

// Derive a class from this class and override the virtual functions to implement the machining.
class EditableOp
{
protected:
	void SetFunctions(const IMillDataPtr& MD);	// Register the functions to handle the op
	virtual bool WantBeforeAddGeometries() const {return true;}	// Override and return false to disable "Add Geometries" menu item
	virtual bool WantBeforeRemoveGeometry() const {return true;}	// Override and return false to disable "Remove from operation" menu item
	virtual bool WantBeforeChangeTool() const {return true;}	// Override and return false to disable "Change Tool" menu item
public:
	EditableOp()
	{
	}
	// Create tool paths given geometry collection and MillData.
	virtual void Update(const IAlphaCamAppPtr& App, const IAlphacamObjectsPtr& Geos, const IMillDataPtr& MD) = 0;
	
	// Show the forms to edit the MillData.
	// Return 0 if ok, non-zero to cancel the edit
	virtual int Edit(const IAlphaCamAppPtr& App, const IMillDataPtr& MD) = 0;

	// This function will be called before adding geometries to the operation.
	// Geos contains the selected geometries. To reject a geometry set its Selected property to False.
	// Return non-zero to reject all geometries.
	virtual int BeforeAddGeometries(const IAlphaCamAppPtr& App, const IAlphacamObjectsPtr& Geos, const IMillDataPtr& MD) {return 1;}	// Disable

	// This function will be called before showing the context menu for a geometry.
	// Return non-zero to disable the "Remove From Operation" item.
	virtual int BeforeRemoveGeometry(const IAlphaCamAppPtr& App, const IDispatchPtr& Geo, const IMillDataPtr& MD) {return 1;}	// Disable
	
	// This function will be called before the tool is changed by the "Change Tool" option in the operations manager.
	// Return non-zero to reject the tool. Otherwise set flags so tool data can be updated.
	// Alphacam will call the "Edit" function so the user can update the settings eg width of cut.
	virtual int BeforeChangeTool(const IAlphaCamAppPtr& App, const IMillToolPtr& Tool, const IMillDataPtr& MD) {return 1;}	// Disable

	static EditableOp* GetEditableOp();
};

ACAMAPIFUN(void) HandleUpdate(VARIANT var_acam, VARIANT var_geos, VARIANT var_MD);
ACAMAPIFUN(int) HandleEdit(VARIANT var_acam, VARIANT var_MD);
ACAMAPIFUN(int) HandleBeforeAddGeometries(VARIANT var_acam, VARIANT var_geos, VARIANT var_MD);
ACAMAPIFUN(int) HandleBeforeRemoveGeometry(VARIANT var_acam, VARIANT var_geo, VARIANT var_MD);
ACAMAPIFUN(int) HandleBeforeChangeTool(VARIANT var_acam, VARIANT var_Tool, VARIANT var_MD);
