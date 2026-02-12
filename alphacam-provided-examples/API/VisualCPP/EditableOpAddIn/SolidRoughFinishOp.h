#pragma once

#include "EditableOp.h"


class SolidRoughFinishOp : public EditableOp
{
	const CString GetAttrPrefix() const {return "LicomUKDMBSRFDLL";}
	const _bstr_t GetAttributeName(const CString& MemberName) const
	{
		return _bstr_t(GetAttrPrefix() + MemberName);
	}
	float m_stock;
public:
	SolidRoughFinishOp() : m_stock(0.f) {}

	// Overrides
	void Update(const IAlphaCamAppPtr& App, const IAlphacamObjectsPtr& Geos, const IMillDataPtr& MD) override;
	int Edit(const IAlphaCamAppPtr& App, const IMillDataPtr& MD) override;
	int BeforeAddGeometries(const IAlphaCamAppPtr& App, const IAlphacamObjectsPtr& Geos, const IMillDataPtr& MD) override;
	int BeforeRemoveGeometry(const IAlphaCamAppPtr& App, const IDispatchPtr& Geo, const IMillDataPtr& MD) override;
	int BeforeChangeTool(const IAlphaCamAppPtr& App, const IMillToolPtr& Tool, const IMillDataPtr& MD) override;
	//bool WantBeforeAddGeometries() const override {return false;}	// Return false to disable "Add Geometries" menu item
	//bool WantBeforeRemoveGeometry() const override {return false;}	// Override and return false to disable "Remove from operation" menu item
	//bool WantBeforeChangeTool() const override {return false;}	// Override and return false to disable "Change Tool" menu item

	// Select solids and geometry paths and call the routine to do the machining
	void DoCmd(const IAlphaCamAppPtr& App);

	// Show dialog boxes. Return 0 if ok, non-zero if aborted
	int ShowDialogBoxes(const IAlphaCamAppPtr& App);
private:
	// Do the op given geometry, which must include at least one solid or surface (to set the Z)
	// and may include splines and geometries
	void DoMachining(const IAlphaCamAppPtr& App, const IAlphacamObjectsPtr& Geos, const IMillDataPtr& MD);

	// Copy machining data to attributes on the MillData
	void SetAttributes(const IMillDataPtr& MD) const;

	// Copy machining data from attributes on the MillData
	void GetAttributes(const IMillDataPtr& MD);
};
