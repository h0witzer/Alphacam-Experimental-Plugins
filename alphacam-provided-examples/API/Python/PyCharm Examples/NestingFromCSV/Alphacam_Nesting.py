# -*- coding: mbcs -*-
# Created by makepy.py version 0.5.01
# By python version 3.7.8 (tags/v3.7.8:4b47a5b6ba, Jun 28 2020, 08:53:46) [MSC v.1916 64 bit (AMD64)]
# From type library 'AcamRadNest.dll'
# On Fri Jul 29 09:27:30 2022
'Alphacam Nesting v3.0 Type Library'
makepy_version = '0.5.01'
python_version = 0x30708f0

import win32com.client.CLSIDToClass, pythoncom, pywintypes
import win32com.client.util
from pywintypes import IID
from win32com.client import Dispatch

# The following 3 lines may need tweaking for the particular server
# Candidates are pythoncom.Missing, .Empty and .ArgNotFound
defaultNamedOptArg=pythoncom.Empty
defaultNamedNotOptArg=pythoncom.Empty
defaultUnnamedArg=pythoncom.Empty

CLSID = IID('{6702E3DF-142C-4627-8EA2-4C47EBC78441}')
MajorVersion = 1
MinorVersion = 3
LibraryFlags = 8
LCID = 0x0

class constants:
	areaUnitSqFt                  =3          # from enum AreaUnits
	areaUnitSqInch                =2          # from enum AreaUnits
	areaUnitSqM                   =1          # from enum AreaUnits
	areaUnitSqMM                  =0          # from enum AreaUnits
	Centre                        =1          # from enum CutOffcutSide
	Inside                        =0          # from enum CutOffcutSide
	Outside                       =2          # from enum CutOffcutSide
	nestExtensionTypeLIST         =0          # from enum ExtensionType
	nestExtensionTypePART         =1          # from enum ExtensionType
	grainDirNone                  =0          # from enum GrainDirection
	grainDirX                     =1          # from enum GrainDirection
	grainDirY                     =2          # from enum GrainDirection
	lenUnitFt                     =3          # from enum LengthUnits
	lenUnitInch                   =2          # from enum LengthUnits
	lenUnitM                      =1          # from enum LengthUnits
	lenUnitMM                     =0          # from enum LengthUnits
	nestCutAuto                   =2          # from enum NestCutDirection
	nestCutInX                    =0          # from enum NestCutDirection
	nestCutInY                    =1          # from enum NestCutDirection
	nestBOTTOM                    =1          # from enum NestDirection
	nestBOTTOMLEFT                =5          # from enum NestDirection
	nestBOTTOMRIGHT               =6          # from enum NestDirection
	nestCUSTOM                    =8          # from enum NestDirection
	nestLEFT                      =0          # from enum NestDirection
	nestRIGHT                     =2          # from enum NestDirection
	nestTOP                       =3          # from enum NestDirection
	nestTOPLEFT                   =4          # from enum NestDirection
	nestTOPRIGHT                  =7          # from enum NestDirection
	nestLevelADVANCED             =1          # from enum NestLevel
	nestLevelBASIC                =2          # from enum NestLevel
	nestLevelEXPRESS              =3          # from enum NestLevel
	nestLevelNONE                 =0          # from enum NestLevel
	nestMethodCUSTOM              =3          # from enum NestMethod
	nestMethodMANUAL              =1          # from enum NestMethod
	nestMethodMINIMUMENTROPY      =2          # from enum NestMethod
	nestMethodORIGINAL            =0          # from enum NestMethod
	nestMethodRADNEST             =5          # from enum NestMethod
	nestMethodRECTANGLE           =4          # from enum NestMethod
	nestMethodVERONEST            =6          # from enum NestMethod
	nestBOTH                      =2          # from enum NestPathType
	nestGEOMETRIES                =0          # from enum NestPathType
	nestTOOLPATHS                 =1          # from enum NestPathType
	nestSheetBOTTOM               =1          # from enum NestSheetAlignment
	nestSheetTOP                  =0          # from enum NestSheetAlignment
	HORIZONTAL                    =1          # from enum OffcutType
	HORIZONTAL_VERTICAL           =3          # from enum OffcutType
	VERTICAL                      =0          # from enum OffcutType
	VERTICAL_HORIZONTAL           =2          # from enum OffcutType
	costBYAREA                    =0          # from enum SheetCostType
	costBYSHEET                   =2          # from enum SheetCostType
	costBYWEIGHT                  =1          # from enum SheetCostType
	sheetOrderBestUtilisation     =0          # from enum SheetOrderType
	sheetOrderPickedOrder         =1          # from enum SheetOrderType
	wtUnitCwt                     =3          # from enum WeightUnits
	wtUnitGram                    =0          # from enum WeightUnits
	wtUnitKilo                    =1          # from enum WeightUnits
	wtUnitLb                      =2          # from enum WeightUnits
	zoneTypeNoNest                =0          # from enum ZoneType
	zoneTypeSmallPart             =1          # from enum ZoneType

from win32com.client import DispatchBaseClass
class IDatabaseMaterial(DispatchBaseClass):
	CLSID = IID('{26947A4F-EE56-4834-A341-A8166EA72D77}')
	coclass_clsid = IID('{82CA8D6B-39DD-4036-9EA4-68751525CA41}')

	def Clashes(self, Other=defaultNamedNotOptArg):
		'Check whether two materials have any unique fields the same'
		return self._oleobj_.InvokeTypes(6, LCID, 1, (3, 0), ((9, 1),),Other
			)

	def Delete(self):
		'Remove this material (and all thicknesses and sheets using it) from the database'
		return self._oleobj_.InvokeTypes(4, LCID, 1, (24, 0), (),)

	# Result is of type IDatabaseThickness
	def FindThickness(self, Thickness=defaultNamedNotOptArg, Units=defaultNamedNotOptArg):
		'Locate a Thickness object by thickness and units (which are unique)'
		ret = self._oleobj_.InvokeTypes(11, LCID, 1, (9, 0), ((5, 1), (3, 1)),Thickness
			, Units)
		if ret is not None:
			ret = Dispatch(ret, 'FindThickness', '{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}')
		return ret

	# Result is of type IDatabaseThickness
	def NewThickness(self):
		'Create a new Thickness for this material, not yet saved to the database'
		ret = self._oleobj_.InvokeTypes(7, LCID, 1, (9, 0), (),)
		if ret is not None:
			ret = Dispatch(ret, 'NewThickness', '{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}')
		return ret

	def Save(self):
		'Update the values of this material in the database'
		return self._oleobj_.InvokeTypes(3, LCID, 1, (3, 0), (),)

	def Store(self):
		'Store this thickness in the database for the first time'
		return self._oleobj_.InvokeTypes(2, LCID, 1, (3, 0), (),)

	_prop_map_get_ = {
		"GUIPosition": (12, 2, (3, 0), (), "GUIPosition", None),
		"Id": (0, 2, (3, 0), (), "Id", None),
		"Name": (1, 2, (8, 0), (), "Name", None),
		# Method 'Offcuts' returns object of type 'IDatabaseSheets'
		"Offcuts": (10, 2, (9, 0), (), "Offcuts", '{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}'),
		# Method 'Sheets' returns object of type 'IDatabaseSheets'
		"Sheets": (8, 2, (9, 0), (), "Sheets", '{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}'),
		# Method 'Thicknesses' returns object of type 'IDatabaseThicknesses'
		"Thicknesses": (5, 2, (9, 0), (), "Thicknesses", '{A09823E9-8D42-42A1-B8DF-A2D9342DAFB1}'),
		# Method 'WholeSheets' returns object of type 'IDatabaseSheets'
		"WholeSheets": (9, 2, (9, 0), (), "WholeSheets", '{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}'),
	}
	_prop_map_put_ = {
		"GUIPosition": ((12, LCID, 4, 0),()),
		"Name": ((1, LCID, 4, 0),()),
	}
	# Default property for this class is 'Id'
	def __call__(self):
		return self._ApplyTypes_(*(0, 2, (3, 0), (), "Id", None))
	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,3,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, None)

class IDatabaseMaterials(DispatchBaseClass):
	CLSID = IID('{E838A5C4-4986-451E-8BAA-DDDDC5FE51E6}')
	coclass_clsid = IID('{142B2338-8688-4EE7-B34A-305DBB1BCB7E}')

	def Add(self, dbMaterial=defaultNamedNotOptArg):
		'Adds a material object to the list'
		return self._oleobj_.InvokeTypes(2, LCID, 1, (24, 0), ((9, 1),),dbMaterial
			)

	# Result is of type IDatabaseMaterial
	def Item(self, Index=defaultNamedNotOptArg):
		'Returns the material of the given index in the list'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, 'Item', '{26947A4F-EE56-4834-A341-A8166EA72D77}')
		return ret

	def Remove(self, dbMaterial=defaultNamedNotOptArg):
		'Removes a material from the nestlist'
		return self._oleobj_.InvokeTypes(3, LCID, 1, (24, 0), ((9, 1),),dbMaterial
			)

	_prop_map_get_ = {
		"Count": (1, 2, (3, 0), (), "Count", None),
	}
	_prop_map_put_ = {
	}
	# Default method for this class is 'Item'
	def __call__(self, Index=defaultNamedNotOptArg):
		'Returns the material of the given index in the list'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, '__call__', '{26947A4F-EE56-4834-A341-A8166EA72D77}')
		return ret

	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,2,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, '{26947A4F-EE56-4834-A341-A8166EA72D77}')
	#This class has Count() property - allow len(ob) to provide this
	def __len__(self):
		return self._ApplyTypes_(*(1, 2, (3, 0), (), "Count", None))
	#This class has a __len__ - this is needed so 'if object:' always returns TRUE.
	def __nonzero__(self):
		return True

class IDatabaseSheet(DispatchBaseClass):
	CLSID = IID('{B843219A-C9CE-419A-9153-577BF8C9362D}')
	coclass_clsid = IID('{3EF55026-A506-47EE-A86A-C87304F1EE53}')

	def ClearPreviewImage(self):
		'Remove the custom preview image from this sheet'
		return self._oleobj_.InvokeTypes(19, LCID, 1, (24, 0), (),)

	def Delete(self):
		'Remove this sheet (and all its zones) from the database'
		return self._oleobj_.InvokeTypes(16, LCID, 1, (24, 0), (),)

	def GetPreviewImage(self, Width=defaultNamedNotOptArg, Height=defaultNamedNotOptArg):
		'Get the preview image for this sheet, as HBitmap'
		return self._oleobj_.InvokeTypes(13, LCID, 1, (3, 0), ((3, 1), (3, 1)),Width
			, Height)

	def InsertInActiveDrawing(self):
		'Insert this sheet in the active drawing'
		return self._oleobj_.InvokeTypes(24, LCID, 1, (24, 0), (),)

	# Result is of type IPaths
	def InsertInActiveDrawingAtPoint(self, x=defaultNamedNotOptArg, y=defaultNamedNotOptArg):
		'Insert this sheet in the active drawing, aligned bottom-left to X, Y. Returns the sheet (not zone) paths'
		ret = self._oleobj_.InvokeTypes(26, LCID, 1, (9, 0), ((5, 1), (5, 1)),x
			, y)
		if ret is not None:
			ret = Dispatch(ret, 'InsertInActiveDrawingAtPoint', '{AFA20680-8305-11D2-98D1-00104B4AF281}')
		return ret

	# Result is of type IDatabaseZone
	def NewZone(self, ZonePaths=defaultNamedNotOptArg):
		'Create a new Zone on this sheet, from the supplied ZonePaths, not yet saved to the database'
		ret = self._oleobj_.InvokeTypes(18, LCID, 1, (9, 0), ((9, 1),),ZonePaths
			)
		if ret is not None:
			ret = Dispatch(ret, 'NewZone', '{97F97832-6E45-4C52-91EA-9F23CC038F29}')
		return ret

	def Rotate(self, Angle=defaultNamedNotOptArg):
		'Rotate this sheet by the specified angle, anticlockwise about the origin'
		return self._oleobj_.InvokeTypes(25, LCID, 1, (24, 0), ((5, 1),),Angle
			)

	def Save(self):
		'Update the values of this sheet in the database'
		return self._oleobj_.InvokeTypes(15, LCID, 1, (3, 0), (),)

	def Store(self):
		'Store this sheet in the database for the first time'
		return self._oleobj_.InvokeTypes(14, LCID, 1, (3, 0), (),)

	def UpdateUnitsAndCascadeZones(self, newVal=defaultNamedNotOptArg):
		'Update the length units for this sheet, and all its zones, Saving each'
		return self._oleobj_.InvokeTypes(27, LCID, 1, (3, 0), ((3, 1),),newVal
			)

	_prop_map_get_ = {
		"Cost": (10, 2, (5, 0), (), "Cost", None),
		"GUIPosition": (23, 2, (3, 0), (), "GUIPosition", None),
		"GrainDirection": (8, 2, (3, 0), (), "GrainDirection", None),
		"Height": (5, 2, (5, 0), (), "Height", None),
		"Id": (0, 2, (3, 0), (), "Id", None),
		"InheritCost": (21, 2, (11, 0), (), "InheritCost", None),
		"IsOffcut": (3, 2, (11, 0), (), "IsOffcut", None),
		"LengthUnits": (6, 2, (3, 0), (), "LengthUnits", None),
		# Method 'Material' returns object of type 'IDatabaseMaterial'
		"Material": (1, 2, (9, 0), (), "Material", '{26947A4F-EE56-4834-A341-A8166EA72D77}'),
		"Name": (20, 2, (8, 0), (), "Name", None),
		"NumReserved": (22, 2, (3, 0), (), "NumReserved", None),
		"Quantity": (11, 2, (3, 0), (), "Quantity", None),
		# Method 'Shape' returns object of type 'IDrawing'
		"Shape": (7, 2, (9, 0), (), "Shape", '{1A172592-4565-11D2-9866-00104B4AF281}'),
		# Method 'Thickness' returns object of type 'IDatabaseThickness'
		"Thickness": (2, 2, (9, 0), (), "Thickness", '{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}'),
		"UserID": (9, 2, (8, 0), (), "UserID", None),
		"Width": (4, 2, (5, 0), (), "Width", None),
		# Method 'Zones' returns object of type 'IDatabaseZones'
		"Zones": (17, 2, (9, 0), (), "Zones", '{07D9A612-7B31-4B54-94BF-2E947A15A8DC}'),
	}
	_prop_map_put_ = {
		"Cost": ((10, LCID, 4, 0),()),
		"GUIPosition": ((23, LCID, 4, 0),()),
		"GrainDirection": ((8, LCID, 4, 0),()),
		"Height": ((5, LCID, 4, 0),()),
		"InheritCost": ((21, LCID, 4, 0),()),
		"LengthUnits": ((6, LCID, 4, 0),()),
		"Name": ((20, LCID, 4, 0),()),
		"NumReserved": ((22, LCID, 4, 0),()),
		"PreviewFilename": ((12, LCID, 4, 0),()),
		"Quantity": ((11, LCID, 4, 0),()),
		"Shape": ((7, LCID, 4, 0),()),
		"UserID": ((9, LCID, 4, 0),()),
		"Width": ((4, LCID, 4, 0),()),
	}
	# Default property for this class is 'Id'
	def __call__(self):
		return self._ApplyTypes_(*(0, 2, (3, 0), (), "Id", None))
	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,3,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, None)

class IDatabaseSheets(DispatchBaseClass):
	CLSID = IID('{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}')
	coclass_clsid = IID('{5F0A5D97-AEF4-4FCE-81E9-FEF202EBDB65}')

	def Add(self, dbSheet=defaultNamedNotOptArg):
		'Adds a sheet object to the list.'
		return self._oleobj_.InvokeTypes(2, LCID, 1, (24, 0), ((9, 1),),dbSheet
			)

	# Result is of type IDatabaseSheet
	def Item(self, Index=defaultNamedNotOptArg):
		'Returns the sheet at the given index in the list'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, 'Item', '{B843219A-C9CE-419A-9153-577BF8C9362D}')
		return ret

	def Remove(self, dbSheet=defaultNamedNotOptArg):
		'Removes a sheet from the nestlist'
		return self._oleobj_.InvokeTypes(3, LCID, 1, (24, 0), ((9, 1),),dbSheet
			)

	_prop_map_get_ = {
		"Count": (1, 2, (3, 0), (), "Count", None),
	}
	_prop_map_put_ = {
	}
	# Default method for this class is 'Item'
	def __call__(self, Index=defaultNamedNotOptArg):
		'Returns the sheet at the given index in the list'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, '__call__', '{B843219A-C9CE-419A-9153-577BF8C9362D}')
		return ret

	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,2,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, '{B843219A-C9CE-419A-9153-577BF8C9362D}')
	#This class has Count() property - allow len(ob) to provide this
	def __len__(self):
		return self._ApplyTypes_(*(1, 2, (3, 0), (), "Count", None))
	#This class has a __len__ - this is needed so 'if object:' always returns TRUE.
	def __nonzero__(self):
		return True

class IDatabaseThickness(DispatchBaseClass):
	CLSID = IID('{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}')
	coclass_clsid = IID('{9CBA1ED5-B394-4E28-A147-8C52EAB77C28}')

	# Result is of type IDatabaseSheet
	def AddSheetAndZones(self, Paths=defaultNamedNotOptArg):
		'Add a new Sheet to the database for this material, with shape and Zones defined by the supplied SheetPaths collection'
		ret = self._oleobj_.InvokeTypes(23, LCID, 1, (9, 0), ((9, 1),),Paths
			)
		if ret is not None:
			ret = Dispatch(ret, 'AddSheetAndZones', '{B843219A-C9CE-419A-9153-577BF8C9362D}')
		return ret

	def Clashes(self, Other=defaultNamedNotOptArg):
		'Check whether two thickness have any unique fields the same'
		return self._oleobj_.InvokeTypes(14, LCID, 1, (3, 0), ((9, 1),),Other
			)

	def Delete(self):
		'Remove this thickness (and all sheets using it) from the database'
		return self._oleobj_.InvokeTypes(13, LCID, 1, (24, 0), (),)

	# Result is of type IDatabaseSheet
	def NewOffcut(self, SheetPaths=defaultNamedNotOptArg):
		'Create a new offcut Sheet with no Zones for this material, from the supplied SheetPaths collection, not yet saved to the database'
		ret = self._oleobj_.InvokeTypes(19, LCID, 1, (9, 0), ((9, 1),),SheetPaths
			)
		if ret is not None:
			ret = Dispatch(ret, 'NewOffcut', '{B843219A-C9CE-419A-9153-577BF8C9362D}')
		return ret

	# Result is of type IDatabaseSheet
	def NewSheet(self):
		'Create a new non-offcut Sheet for this material, not yet saved to the database'
		ret = self._oleobj_.InvokeTypes(18, LCID, 1, (9, 0), (),)
		if ret is not None:
			ret = Dispatch(ret, 'NewSheet', '{B843219A-C9CE-419A-9153-577BF8C9362D}')
		return ret

	def Save(self):
		'Update the values of this thickness in the database'
		return self._oleobj_.InvokeTypes(12, LCID, 1, (3, 0), (),)

	def SetCostPerArea(self, newCost=defaultNamedNotOptArg, newUnits=defaultNamedNotOptArg):
		'Set the cost-per-area, including area units'
		return self._oleobj_.InvokeTypes(10, LCID, 1, (24, 0), ((5, 1), (3, 1)),newCost
			, newUnits)

	def SetThickness(self, newThick=defaultNamedNotOptArg, newUnits=defaultNamedNotOptArg):
		'Set the thickness including units'
		return self._oleobj_.InvokeTypes(4, LCID, 1, (24, 0), ((5, 1), (3, 1)),newThick
			, newUnits)

	def SetWeightPerArea(self, newWPA=defaultNamedNotOptArg, newWeightUnits=defaultNamedNotOptArg, newAreaUnits=defaultNamedNotOptArg):
		'Set the weight-per-area, including weight and area units'
		return self._oleobj_.InvokeTypes(7, LCID, 1, (24, 0), ((5, 1), (3, 1), (3, 1)),newWPA
			, newWeightUnits, newAreaUnits)

	def Store(self):
		'Store this thickness in the database for the first time'
		return self._oleobj_.InvokeTypes(11, LCID, 1, (3, 0), (),)

	def UpdateUnitsAndCascadeSheets(self, newVal=defaultNamedNotOptArg):
		'Update the length units for this thickness, and all its sheets, Saving each'
		return self._oleobj_.InvokeTypes(24, LCID, 1, (3, 0), ((3, 1),),newVal
			)

	_prop_map_get_ = {
		"AreaUnits": (8, 2, (3, 0), (), "AreaUnits", None),
		"CostIsByWeight": (21, 2, (11, 0), (), "CostIsByWeight", None),
		"CostPerArea": (9, 2, (5, 0), (), "CostPerArea", None),
		"CostPerWeight": (20, 2, (5, 0), (), "CostPerWeight", None),
		"GUIPosition": (22, 2, (3, 0), (), "GUIPosition", None),
		"Id": (0, 2, (3, 0), (), "Id", None),
		# Method 'Material' returns object of type 'IDatabaseMaterial'
		"Material": (1, 2, (9, 0), (), "Material", '{26947A4F-EE56-4834-A341-A8166EA72D77}'),
		# Method 'Offcuts' returns object of type 'IDatabaseSheets'
		"Offcuts": (17, 2, (9, 0), (), "Offcuts", '{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}'),
		# Method 'Sheets' returns object of type 'IDatabaseSheets'
		"Sheets": (15, 2, (9, 0), (), "Sheets", '{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}'),
		"Thickness": (2, 2, (5, 0), (), "Thickness", None),
		"ThicknessUnits": (3, 2, (3, 0), (), "ThicknessUnits", None),
		"WeightPerArea": (5, 2, (5, 0), (), "WeightPerArea", None),
		"WeightUnits": (6, 2, (3, 0), (), "WeightUnits", None),
		# Method 'WholeSheets' returns object of type 'IDatabaseSheets'
		"WholeSheets": (16, 2, (9, 0), (), "WholeSheets", '{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}'),
	}
	_prop_map_put_ = {
		"AreaUnits": ((8, LCID, 4, 0),()),
		"CostIsByWeight": ((21, LCID, 4, 0),()),
		"CostPerArea": ((9, LCID, 4, 0),()),
		"CostPerWeight": ((20, LCID, 4, 0),()),
		"GUIPosition": ((22, LCID, 4, 0),()),
		"Thickness": ((2, LCID, 4, 0),()),
		"ThicknessUnits": ((3, LCID, 4, 0),()),
		"WeightPerArea": ((5, LCID, 4, 0),()),
		"WeightUnits": ((6, LCID, 4, 0),()),
	}
	# Default property for this class is 'Id'
	def __call__(self):
		return self._ApplyTypes_(*(0, 2, (3, 0), (), "Id", None))
	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,3,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, None)

class IDatabaseThicknesses(DispatchBaseClass):
	CLSID = IID('{A09823E9-8D42-42A1-B8DF-A2D9342DAFB1}')
	coclass_clsid = IID('{DACBC1D5-64AA-4648-B06C-4E90289DF069}')

	def Add(self, dbThickness=defaultNamedNotOptArg):
		'Adds a thickness object to the list.'
		return self._oleobj_.InvokeTypes(2, LCID, 1, (24, 0), ((9, 1),),dbThickness
			)

	# Result is of type IDatabaseThickness
	def Item(self, Index=defaultNamedNotOptArg):
		'Returns the thickness of the given index in the list'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, 'Item', '{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}')
		return ret

	def Remove(self, dbThickness=defaultNamedNotOptArg):
		'Removes a thickness from the nestlist'
		return self._oleobj_.InvokeTypes(3, LCID, 1, (24, 0), ((9, 1),),dbThickness
			)

	_prop_map_get_ = {
		"Count": (1, 2, (3, 0), (), "Count", None),
	}
	_prop_map_put_ = {
	}
	# Default method for this class is 'Item'
	def __call__(self, Index=defaultNamedNotOptArg):
		'Returns the thickness of the given index in the list'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, '__call__', '{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}')
		return ret

	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,2,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, '{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}')
	#This class has Count() property - allow len(ob) to provide this
	def __len__(self):
		return self._ApplyTypes_(*(1, 2, (3, 0), (), "Count", None))
	#This class has a __len__ - this is needed so 'if object:' always returns TRUE.
	def __nonzero__(self):
		return True

class IDatabaseZone(DispatchBaseClass):
	CLSID = IID('{97F97832-6E45-4C52-91EA-9F23CC038F29}')
	coclass_clsid = IID('{C1746D4A-91A8-4B8D-BE95-5B35BB968CD8}')

	def Delete(self):
		'Remove this zone from the database'
		return self._oleobj_.InvokeTypes(7, LCID, 1, (24, 0), (),)

	def Save(self):
		'Update the values of this zone in the database'
		return self._oleobj_.InvokeTypes(6, LCID, 1, (3, 0), (),)

	def Store(self):
		'Store this zone in the database for the first time'
		return self._oleobj_.InvokeTypes(5, LCID, 1, (3, 0), (),)

	_prop_map_get_ = {
		"Id": (0, 2, (3, 0), (), "Id", None),
		"LengthUnits": (3, 2, (3, 0), (), "LengthUnits", None),
		# Method 'Shape' returns object of type 'IDrawing'
		"Shape": (4, 2, (9, 0), (), "Shape", '{1A172592-4565-11D2-9866-00104B4AF281}'),
		# Method 'Sheet' returns object of type 'IDatabaseSheet'
		"Sheet": (1, 2, (9, 0), (), "Sheet", '{B843219A-C9CE-419A-9153-577BF8C9362D}'),
		"ZoneType": (2, 2, (3, 0), (), "ZoneType", None),
	}
	_prop_map_put_ = {
		"LengthUnits": ((3, LCID, 4, 0),()),
		"Shape": ((4, LCID, 4, 0),()),
		"ZoneType": ((2, LCID, 4, 0),()),
	}
	# Default property for this class is 'Id'
	def __call__(self):
		return self._ApplyTypes_(*(0, 2, (3, 0), (), "Id", None))
	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,3,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, None)

class IDatabaseZones(DispatchBaseClass):
	CLSID = IID('{07D9A612-7B31-4B54-94BF-2E947A15A8DC}')
	coclass_clsid = IID('{D6908C61-2E6E-4B36-A147-603BF2DCF875}')

	def Add(self, dbSheet=defaultNamedNotOptArg):
		'Adds a zone object to the list.'
		return self._oleobj_.InvokeTypes(2, LCID, 1, (24, 0), ((9, 1),),dbSheet
			)

	# Result is of type IDatabaseZone
	def Item(self, Index=defaultNamedNotOptArg):
		'Returns the zone at the given index in the list'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, 'Item', '{97F97832-6E45-4C52-91EA-9F23CC038F29}')
		return ret

	def Remove(self, dbSheet=defaultNamedNotOptArg):
		'Removes a zone from the nestlist'
		return self._oleobj_.InvokeTypes(3, LCID, 1, (24, 0), ((9, 1),),dbSheet
			)

	_prop_map_get_ = {
		"Count": (1, 2, (3, 0), (), "Count", None),
	}
	_prop_map_put_ = {
	}
	# Default method for this class is 'Item'
	def __call__(self, Index=defaultNamedNotOptArg):
		'Returns the zone at the given index in the list'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, '__call__', '{97F97832-6E45-4C52-91EA-9F23CC038F29}')
		return ret

	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,2,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, '{97F97832-6E45-4C52-91EA-9F23CC038F29}')
	#This class has Count() property - allow len(ob) to provide this
	def __len__(self):
		return self._ApplyTypes_(*(1, 2, (3, 0), (), "Count", None))
	#This class has a __len__ - this is needed so 'if object:' always returns TRUE.
	def __nonzero__(self):
		return True

class INestData(DispatchBaseClass):
	'INestData Interface'
	CLSID = IID('{175E5A9E-72D2-4163-B751-382357CD5D6A}')
	coclass_clsid = IID('{A3E9AAD4-E240-4382-9DDB-5F4EFC9E8FB9}')

	def AddSheet(self, Geometry=defaultNamedNotOptArg, MaterialName=defaultNamedNotOptArg, Thickness=defaultNamedNotOptArg, Number=defaultNamedNotOptArg):
		return self._oleobj_.InvokeTypes(4097, LCID, 1, (24, 0), ((9, 1), (8, 1), (5, 1), (3, 1)),Geometry
			, MaterialName, Thickness, Number)

	def DoNest(self):
		return self._oleobj_.InvokeTypes(4098, LCID, 1, (24, 0), (),)

	_prop_map_get_ = {
		"Direction": (5, 2, (3, 0), (), "Direction", None),
		"EdgeGap": (5001, 2, (5, 0), (), "EdgeGap", None),
		"Gap": (2, 2, (5, 0), (), "Gap", None),
		"LeadGap": (3, 2, (5, 0), (), "LeadGap", None),
		"MergeTools": (5005, 2, (2, 0), (), "MergeTools", None),
		"MinimiseToolChanges": (5002, 2, (2, 0), (), "MinimiseToolChanges", None),
		"OrderByPart": (5006, 2, (2, 0), (), "OrderByPart", None),
		"OrderInnerFirst": (5007, 2, (2, 0), (), "OrderInnerFirst", None),
		"RepeatFirstRowOrColumn": (6, 2, (11, 0), (), "RepeatFirstRowOrColumn", None),
		"Resolution": (1, 2, (5, 0), (), "Resolution", None),
		"SheetHGap": (5003, 2, (5, 0), (), "SheetHGap", None),
		"SheetVGap": (5004, 2, (5, 0), (), "SheetVGap", None),
		"Subroutines": (4, 2, (11, 0), (), "Subroutines", None),
		"ToolPaths": (7, 2, (11, 0), (), "ToolPaths", None),
	}
	_prop_map_put_ = {
		"Direction": ((5, LCID, 4, 0),()),
		"EdgeGap": ((5001, LCID, 4, 0),()),
		"Gap": ((2, LCID, 4, 0),()),
		"LeadGap": ((3, LCID, 4, 0),()),
		"MergeTools": ((5005, LCID, 4, 0),()),
		"MinimiseToolChanges": ((5002, LCID, 4, 0),()),
		"OrderByPart": ((5006, LCID, 4, 0),()),
		"OrderInnerFirst": ((5007, LCID, 4, 0),()),
		"RepeatFirstRowOrColumn": ((6, LCID, 4, 0),()),
		"Resolution": ((1, LCID, 4, 0),()),
		"SheetHGap": ((5003, LCID, 4, 0),()),
		"SheetVGap": ((5004, LCID, 4, 0),()),
		"Subroutines": ((4, LCID, 4, 0),()),
	}
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,3,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, None)

class INestEngine(DispatchBaseClass):
	'INestEngine Interface'
	CLSID = IID('{67426269-0738-4335-AC13-6AE288FE096D}')
	coclass_clsid = IID('{9FC79BC5-07C6-4DCF-A08D-80E076BB2316}')

	def NestPart(self, Part=defaultNamedNotOptArg, target=defaultNamedNotOptArg):
		'method NestPart'
		return self._oleobj_.InvokeTypes(1, LCID, 1, (2, 0), ((13, 1), (13, 1)),Part
			, target)

	def PlaceNewSheet(self, Sheet=defaultNamedNotOptArg):
		'Get the engine to place a newly-created sheet in the drawing'
		return self._oleobj_.InvokeTypes(5, LCID, 1, (24, 0), ((9, 1),),Sheet
			)

	def SetEngineParams(self, SourceList=defaultNamedNotOptArg):
		'The nestlist holds the variables used by the engine to do the nest. This call lets the engine know which nestlist to use to get those variables from.'
		return self._oleobj_.InvokeTypes(3, LCID, 1, (24, 0), ((9, 1),),SourceList
			)

	_prop_map_get_ = {
		"ClassPointerRemoved": (2, 2, (3, 0), (), "ClassPointerRemoved", None),
	}
	_prop_map_put_ = {
	}
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,3,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, None)

class INestEvents3(DispatchBaseClass):
	'INestEvents3 Interface'
	CLSID = IID('{9A867723-2B30-4B44-AB02-BAF612A0FBF4}')
	coclass_clsid = IID('{F4C7709A-132D-4182-9414-B5DA62D7F763}')

	_prop_map_get_ = {
		"ClassPointerRemoved": (1, 2, (3, 0), (), "ClassPointerRemoved", None),
	}
	_prop_map_put_ = {
	}
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,3,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, None)

class INestEventsEvents:
	'INestEventsEvents Interface'
	CLSID = CLSID_Sink = IID('{03762FE5-DFDF-4534-B1AE-7D34AF943D86}')
	coclass_clsid = IID('{F4C7709A-132D-4182-9414-B5DA62D7F763}')
	_public_methods_ = [] # For COM Server support
	_dispid_to_func_ = {
		        1 : "OnDoNothingEver",
		        2 : "OnBeforeNewNestList",
		        3 : "OnAfterNewNestList",
		        4 : "OnBeforeNewSheetList",
		        5 : "OnAfterNewSheetList",
		        6 : "OnBeforeAddPart",
		        7 : "OnAfterAddPart",
		        8 : "OnBeforeAddSheet",
		        9 : "OnAfterAddSheet",
		       10 : "OnBeforeDeleteNestList",
		       11 : "OnAfterDeleteNestList",
		       12 : "OnBeforeDeleteSheetList",
		       13 : "OnAfterDeleteSheetList",
		       14 : "OnBeforeAddFile",
		       15 : "OnAfterAddFile",
		       16 : "OnBeforeDeletePart",
		       17 : "OnAfterDeletePart",
		       18 : "OnBeforeOrderList",
		       19 : "OnAfterOrderList",
		       20 : "OnBeforePlacePart",
		       21 : "OnAfterPlacePart",
		       22 : "OnBeforePlaceSheet",
		       23 : "OnAfterPlaceSheet",
		       24 : "OnBeforeDoNest",
		       25 : "OnNestingComplete",
		       26 : "OnSheetComplete",
		       27 : "OnPartConfigured",
		}

	def __init__(self, oobj = None):
		if oobj is None:
			self._olecp = None
		else:
			import win32com.server.util
			from win32com.server.policy import EventHandlerPolicy
			cpc=oobj._oleobj_.QueryInterface(pythoncom.IID_IConnectionPointContainer)
			cp=cpc.FindConnectionPoint(self.CLSID_Sink)
			cookie=cp.Advise(win32com.server.util.wrap(self, usePolicy=EventHandlerPolicy))
			self._olecp,self._olecp_cookie = cp,cookie
	def __del__(self):
		try:
			self.close()
		except pythoncom.com_error:
			pass
	def close(self):
		if self._olecp is not None:
			cp,cookie,self._olecp,self._olecp_cookie = self._olecp,self._olecp_cookie,None,None
			cp.Unadvise(cookie)
	def _query_interface_(self, iid):
		import win32com.server.util
		if iid==self.CLSID_Sink: return win32com.server.util.wrap(self)

	# Event Handlers
	# If you create handlers, they should have the following prototypes:
#	def OnDoNothingEver(self):
#	def OnBeforeNewNestList(self, ListName=defaultNamedNotOptArg):
#		'method BeforeNewNestList'
#	def OnAfterNewNestList(self, Nestlist=defaultNamedNotOptArg):
#		'method AfterNewNestList'
#	def OnBeforeNewSheetList(self, ListName=defaultNamedNotOptArg):
#		'method BeforeNewSheetList'
#	def OnAfterNewSheetList(self, SheetList=defaultNamedNotOptArg):
#		'method AfterNewSheetList'
#	def OnBeforeAddPart(self, Nestlist=defaultNamedNotOptArg, Paths=defaultNamedNotOptArg):
#		'method BeforeAddPart'
#	def OnAfterAddPart(self, Nestlist=defaultNamedNotOptArg, Part=defaultNamedNotOptArg):
#		'method AfterAddPart'
#	def OnBeforeAddSheet(self, SheetList=defaultNamedNotOptArg, Path=defaultNamedNotOptArg, Cancel=defaultNamedNotOptArg):
#		'method BeforeAddSheet'
#	def OnAfterAddSheet(self, SheetList=defaultNamedNotOptArg, Sheet=defaultNamedNotOptArg):
#		'method AfterAddSheet'
#	def OnBeforeDeleteNestList(self, Nestlist=defaultNamedNotOptArg, Cancel=defaultNamedNotOptArg):
#		'method BeforeDeleteNestList'
#	def OnAfterDeleteNestList(self, Nestlist=defaultNamedNotOptArg):
#		'method AfterDeleteNestList'
#	def OnBeforeDeleteSheetList(self, SheetList=defaultNamedNotOptArg, Cancel=defaultNamedNotOptArg):
#		'method BeforeDeleteSheetList'
#	def OnAfterDeleteSheetList(self, SheetList=defaultNamedNotOptArg):
#		'method AfterDeleteSheetList'
#	def OnBeforeAddFile(self, Nestlist=defaultNamedNotOptArg, FileName=defaultNamedNotOptArg):
#		'method BeforeAddFile'
#	def OnAfterAddFile(self, Nestlist=defaultNamedNotOptArg, FileName=defaultNamedNotOptArg, Part=defaultNamedNotOptArg):
#		'method AfterAddFile'
#	def OnBeforeDeletePart(self, Nestlist=defaultNamedNotOptArg, Part=defaultNamedNotOptArg, Cancel=defaultNamedNotOptArg):
#		'method BeforeDeletePart'
#	def OnAfterDeletePart(self, Nestlist=defaultNamedNotOptArg, Part=defaultNamedNotOptArg):
#		'method AfterDeletePart'
#	def OnBeforeOrderList(self, Nestlist=defaultNamedNotOptArg, Cancel=defaultNamedNotOptArg):
#		'method BeforeOrderList'
#	def OnAfterOrderList(self, Nestlist=defaultNamedNotOptArg):
#		'method AfterOrderList'
#	def OnBeforePlacePart(self, Part=defaultNamedNotOptArg, x=defaultNamedNotOptArg, y=defaultNamedNotOptArg, Angle=defaultNamedNotOptArg
#			, Mirror=defaultNamedNotOptArg, Cancel=defaultNamedNotOptArg):
#		'method BeforePlacePart'
#	def OnAfterPlacePart(self, Part=defaultNamedNotOptArg, Paths=defaultNamedNotOptArg, InternalText=defaultNamedNotOptArg):
#		'method AfterPlacePart'
#	def OnBeforePlaceSheet(self, Sheet=defaultNamedNotOptArg, x=defaultNamedNotOptArg, y=defaultNamedNotOptArg, Cancel=defaultNamedNotOptArg):
#		'method BeforePlaceSheet'
#	def OnAfterPlaceSheet(self, Sheet=defaultNamedNotOptArg, Paths=defaultNamedNotOptArg):
#		'method AfterPlaceSheet'
#	def OnBeforeDoNest(self, Engine=defaultNamedNotOptArg, Nestlist=defaultNamedNotOptArg, SheetList=defaultNamedNotOptArg, Cancel=defaultNamedNotOptArg):
#		'method BeforeDoNest'
#	def OnNestingComplete(self, Nestlist=defaultNamedNotOptArg):
#		'method NestingComplete'
#	def OnSheetComplete(self, Sheet=defaultNamedNotOptArg, Paths=defaultNamedNotOptArg):
#		'method SheetComplete'
#	def OnPartConfigured(self, Part=defaultNamedNotOptArg):
#		'method PartConfigured'


class INestExtension(DispatchBaseClass):
	'INestExtension Interface'
	CLSID = IID('{6EC96D6F-3CA5-4B12-A9A0-3BE960F94DB0}')
	coclass_clsid = IID('{CEBB82E2-828A-4E84-BC64-D05CB076DB04}')

	def FreeListConfig(self):
		'Frees off stuff'
		return self._oleobj_.InvokeTypes(14, LCID, 1, (24, 0), (),)

	def GetEnabled(self, Id=defaultNamedNotOptArg):
		'Returns TRUE if the sub-extension given by Id is enabled'
		return self._oleobj_.InvokeTypes(6, LCID, 1, (11, 0), ((3, 1),),Id
			)

	def GetState(self, Id=defaultNamedNotOptArg):
		'Returns the state of the extension (0 = off, 1 = on)'
		return self._oleobj_.InvokeTypes(7, LCID, 1, (2, 0), ((3, 1),),Id
			)

	def GetText(self, Id=defaultNamedNotOptArg):
		'Returns the name of sub-extension given by Id'
		# Result is a Unicode object
		return self._oleobj_.InvokeTypes(5, LCID, 1, (8, 0), ((3, 1),),Id
			)

	def HasUserConfig(self):
		'Whether the extension supports user configuration'
		return self._oleobj_.InvokeTypes(15, LCID, 1, (11, 0), (),)

	def SetListConfig(self, Nestlist=defaultNamedNotOptArg, ConfigString=defaultNamedNotOptArg):
		'Sets the configuration string and the nestlist relevant to the extension'
		return self._oleobj_.InvokeTypes(12, LCID, 1, (24, 0), ((9, 1), (8, 1)),Nestlist
			, ConfigString)

	def SetPartConfig(self, Part=defaultNamedNotOptArg, ConfigString=defaultNamedNotOptArg):
		'Sets the config string and active part for a part-based extension'
		return self._oleobj_.InvokeTypes(13, LCID, 1, (24, 0), ((9, 1), (8, 1)),Part
			, ConfigString)

	def SetState(self, Id=defaultNamedNotOptArg, State=defaultNamedNotOptArg):
		'Sets the state of the given sub-extension to 0 or 1 as specified by State'
		return self._oleobj_.InvokeTypes(8, LCID, 1, (24, 0), ((3, 1), (2, 1)),Id
			, State)

	def ShowUserConfigDialog(self):
		'Display the dialog allowing the user to set user configuration'
		return self._oleobj_.InvokeTypes(16, LCID, 1, (24, 0), (),)

	_prop_map_get_ = {
		"Count": (2, 2, (3, 0), (), "Count", None),
		"DefaultConfig": (10, 2, (8, 0), (), "DefaultConfig", None),
		"Heading": (4, 2, (8, 0), (), "Heading", None),
		"Name": (1, 2, (8, 0), (), "Name", None),
		"SaveConfig": (11, 2, (8, 0), (), "SaveConfig", None),
		"Type": (3, 2, (3, 0), (), "Type", None),
	}
	_prop_map_put_ = {
	}
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,3,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, None)
	#This class has Count() property - allow len(ob) to provide this
	def __len__(self):
		return self._ApplyTypes_(*(2, 2, (3, 0), (), "Count", None))
	#This class has a __len__ - this is needed so 'if object:' always returns TRUE.
	def __nonzero__(self):
		return True

class INestExtensions(DispatchBaseClass):
	'INestExtensions Interface'
	CLSID = IID('{7B37B17F-B44C-4625-A435-B137E03E6AAF}')
	coclass_clsid = IID('{3061A13F-96CC-45F0-8FD6-F5850D262A55}')

	# Result is of type INestExtension
	def Item(self, Index=defaultNamedNotOptArg):
		'method Item'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, 'Item', '{6EC96D6F-3CA5-4B12-A9A0-3BE960F94DB0}')
		return ret

	_prop_map_get_ = {
		"Count": (1, 2, (3, 0), (), "Count", None),
	}
	_prop_map_put_ = {
	}
	# Default method for this class is 'Item'
	def __call__(self, Index=defaultNamedNotOptArg):
		'method Item'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, '__call__', '{6EC96D6F-3CA5-4B12-A9A0-3BE960F94DB0}')
		return ret

	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,2,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, '{6EC96D6F-3CA5-4B12-A9A0-3BE960F94DB0}')
	#This class has Count() property - allow len(ob) to provide this
	def __len__(self):
		return self._ApplyTypes_(*(1, 2, (3, 0), (), "Count", None))
	#This class has a __len__ - this is needed so 'if object:' always returns TRUE.
	def __nonzero__(self):
		return True

class INestInformation(DispatchBaseClass):
	'INestInformation Interface'
	CLSID = IID('{6B205E8C-FD6E-44ED-ABA2-9FD6870B42BB}')
	coclass_clsid = IID('{FCC7E45F-B0AC-4835-99DF-552F5C18014E}')

	def Refresh(self):
		'Causes nesting information to re-scan the drawing and update its nesting info'
		return self._oleobj_.InvokeTypes(5001, LCID, 1, (24, 0), (),)

	_prop_map_get_ = {
		# Method 'Parts' returns object of type 'INestParts'
		"Parts": (2, 2, (9, 0), (), "Parts", '{5FFBEE0B-0A71-4255-BEBB-99F138EEFC4D}'),
		# Method 'SheetDB' returns object of type 'ISheetDBase'
		"SheetDB": (5002, 2, (9, 0), (), "SheetDB", '{98D8443D-C842-4F05-9D64-BB03AE1A65C6}'),
		# Method 'Sheets' returns object of type 'INestSheets'
		"Sheets": (1, 2, (9, 0), (), "Sheets", '{D55B5242-FAEA-4704-8C71-0EB0746BC751}'),
	}
	_prop_map_put_ = {
	}
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,3,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, None)

class INestList(DispatchBaseClass):
	'INestList Interface'
	CLSID = IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')
	coclass_clsid = IID('{A027C40B-1156-4F95-B126-455E37FEA178}')

	# Result is of type INestPart
	def Add(self, Paths=defaultNamedNotOptArg):
		'Adds, as a single part, the paths specified to the nest list. A NestPart is returned.'
		ret = self._oleobj_.InvokeTypes(8, LCID, 1, (9, 0), ((9, 1),),Paths
			)
		if ret is not None:
			ret = Dispatch(ret, 'Add', '{8ACC255D-1758-4296-AE13-FA3DC51E1641}')
		return ret

	# Result is of type INestPart
	def AddCopy(self, Part=defaultNamedNotOptArg):
		'Take a copy of a part and add it to a nestlist, returning the new part'
		ret = self._oleobj_.InvokeTypes(42, LCID, 1, (9, 0), ((9, 1),),Part
			)
		if ret is not None:
			ret = Dispatch(ret, 'AddCopy', '{8ACC255D-1758-4296-AE13-FA3DC51E1641}')
		return ret

	# Result is of type INestPart
	def AddFile(self, FileName=defaultNamedNotOptArg):
		'Adds a file with the given name to the nestlist, returning the NestPart created. You must set the part parameters in the part after loading.'
		ret = self._oleobj_.InvokeTypes(22, LCID, 1, (9, 0), ((8, 1),),FileName
			)
		if ret is not None:
			ret = Dispatch(ret, 'AddFile', '{8ACC255D-1758-4296-AE13-FA3DC51E1641}')
		return ret

	def ConfigureExtensions(self):
		'Call this to set all extensions up to use this nestlist'
		return self._oleobj_.InvokeTypes(32, LCID, 1, (24, 0), (),)

	def CopyParamsFrom(self, OtherList=defaultNamedNotOptArg):
		'Sets all of this lists parameters to match another list'
		return self._oleobj_.InvokeTypes(43, LCID, 1, (24, 0), ((9, 1),),OtherList
			)

	# Result is of type INestList
	def CopyTemporary(self):
		'Makes a copy of this nestlist but does not add it to the main nesting object'
		ret = self._oleobj_.InvokeTypes(26, LCID, 1, (9, 0), (),)
		if ret is not None:
			ret = Dispatch(ret, 'CopyTemporary', '{32E79675-9214-4CCF-BC22-68AB6B9574A0}')
		return ret

	def DeletePart(self, Part=defaultNamedNotOptArg):
		'Deletes the specified part from the nestlist'
		return self._oleobj_.InvokeTypes(24, LCID, 1, (24, 0), ((9, 1),),Part
			)

	def FreeExtensions(self):
		'Call this to free all extensions that use this nestlist'
		return self._oleobj_.InvokeTypes(45, LCID, 1, (24, 0), (),)

	def GetExtensionConfig(self, ExtensionName=defaultNamedNotOptArg):
		'Returns the config string for the given named extension for this nestlist'
		# Result is a Unicode object
		return self._oleobj_.InvokeTypes(31, LCID, 1, (8, 0), ((8, 1),),ExtensionName
			)

	def GetSheetAlignment(self, SheetAlignment=pythoncom.Missing):
		'Get sheet Z-Level alignment'
		return self._ApplyTypes_(66, 1, (5, 0), ((16387, 2),), 'GetSheetAlignment', None,SheetAlignment
			)

	# Result is of type INestPart
	def Item(self, Index=defaultNamedNotOptArg):
		'Returns the specified item'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, 'Item', '{8ACC255D-1758-4296-AE13-FA3DC51E1641}')
		return ret

	def Load(self, FileName=defaultNamedNotOptArg):
		'Load the nestlist with the given filename. Clears whatever is currently stored in this list'
		return self._oleobj_.InvokeTypes(4, LCID, 1, (24, 0), ((8, 1),),FileName
			)

	def LoadSettings(self, FileName=defaultNamedNotOptArg):
		'Load the settings from the nestlist with the given filename. No parts will be loaded.'
		return self._oleobj_.InvokeTypes(59, LCID, 1, (24, 0), ((8, 1),),FileName
			)

	def OrderParts(self):
		'Sets the part order in the nestlist, sorting largest->smallest, then calls UpdateOrder'
		return self._oleobj_.InvokeTypes(25, LCID, 1, (24, 0), (),)

	def Save(self):
		'Save this nestlist to its current filename (see Filename property)'
		return self._oleobj_.InvokeTypes(6, LCID, 1, (24, 0), (),)

	def SaveAs(self, FileName=defaultNamedNotOptArg):
		'Save this nestlist as the specified filename'
		return self._oleobj_.InvokeTypes(5, LCID, 1, (24, 0), ((8, 1),),FileName
			)

	def SaveConfigAsDefault(self):
		"Save the list's current configuration as default values."
		return self._oleobj_.InvokeTypes(54, LCID, 1, (24, 0), (),)

	def SaveSettings(self, FileName=defaultNamedNotOptArg):
		'Save the settings from this nestlist to the specified filename. No parts will be saved.'
		return self._oleobj_.InvokeTypes(60, LCID, 1, (24, 0), ((8, 1),),FileName
			)

	def SetExtensionConfig(self, ExtensionName=defaultNamedNotOptArg, ConfigString=defaultNamedNotOptArg):
		'Call this to set the configuration string for the specified extension'
		return self._oleobj_.InvokeTypes(30, LCID, 1, (24, 0), ((8, 1), (8, 1)),ExtensionName
			, ConfigString)

	def SetSheetAlignment(self, SheetAlignment=defaultNamedNotOptArg, ZLevel=defaultNamedNotOptArg):
		'Set sheet Z-Level alignment'
		return self._oleobj_.InvokeTypes(65, LCID, 1, (24, 0), ((3, 1), (5, 1)),SheetAlignment
			, ZLevel)

	def StoreTemporary(self):
		'If this NestList is a Temporary list, this will convert it to a permenant one - renaming if necessary'
		return self._oleobj_.InvokeTypes(38, LCID, 1, (24, 0), (),)

	def UpdateOrder(self):
		'Reorders parts according to PlaceOrder in each NestPart (set in OrderParts and then through the BeforeOrderParts event)'
		return self._oleobj_.InvokeTypes(33, LCID, 1, (24, 0), (),)

	_prop_map_get_ = {
		"AllowSolidParts": (63, 2, (11, 0), (), "AllowSolidParts", None),
		"AssistedNest": (44, 2, (3, 0), (), "AssistedNest", None),
		"BalanceAcrossSheets": (41, 2, (3, 0), (), "BalanceAcrossSheets", None),
		"ClassPointerRemoved": (7, 2, (3, 0), (), "ClassPointerRemoved", None),
		"Count": (3, 2, (3, 0), (), "Count", None),
		"CustomAngle": (35, 2, (5, 0), (), "CustomAngle", None),
		"CutDirection": (37, 2, (3, 0), (), "CutDirection", None),
		"CutWidth": (36, 2, (5, 0), (), "CutWidth", None),
		"EdgeGap": (9, 2, (5, 0), (), "EdgeGap", None),
		"EvenlySpacedParts": (61, 2, (11, 0), (), "EvenlySpacedParts", None),
		"FileName": (1, 2, (8, 0), (), "FileName", None),
		"FromGui": (49, 2, (11, 0), (), "FromGui", None),
		"FromScreen": (23, 2, (2, 0), (), "FromScreen", None),
		"InnerFirst": (14, 2, (2, 0), (), "InnerFirst", None),
		"LeadInGap": (10, 2, (5, 0), (), "LeadInGap", None),
		"ListName": (2, 2, (8, 0), (), "ListName", None),
		"MinimiseSheetPatterns": (50, 2, (3, 0), (), "MinimiseSheetPatterns", None),
		"MinimiseToolChanges": (15, 2, (2, 0), (), "MinimiseToolChanges", None),
		"Modified": (21, 2, (2, 0), (), "Modified", None),
		"NestSide": (17, 2, (3, 0), (), "NestSide", None),
		"NestingMethod": (28, 2, (3, 0), (), "NestingMethod", None),
		"OffcutPreference": (58, 2, (3, 0), (), "OffcutPreference", None),
		"OptimiseForCuts": (39, 2, (3, 0), (), "OptimiseForCuts", None),
		"OptimiseLevel": (40, 2, (2, 0), (), "OptimiseLevel", None),
		"OptimizedToolPathOverlap": (62, 2, (11, 0), (), "OptimizedToolPathOverlap", None),
		"OrderByPart": (16, 2, (2, 0), (), "OrderByPart", None),
		"PartGap": (11, 2, (5, 0), (), "PartGap", None),
		"PathType": (20, 2, (3, 0), (), "PathType", None),
		"PreserveSheetEdge": (34, 2, (2, 0), (), "PreserveSheetEdge", None),
		"PreventApertureNest": (51, 2, (11, 0), (), "PreventApertureNest", None),
		"RepeatFirstRow": (13, 2, (2, 0), (), "RepeatFirstRow", None),
		"Resolution": (27, 2, (5, 0), (), "Resolution", None),
		"SelectBestSheet": (47, 2, (3, 0), (), "SelectBestSheet", None),
		# Method 'SheetList' returns object of type 'ISheetList'
		"SheetList": (55, 2, (9, 0), (), "SheetList", '{0687113C-A6A0-4D3C-B56F-432DF61A5774}'),
		"SheetOrder": (56, 2, (3, 0), (), "SheetOrder", None),
		"SingleIdenticalSheetInstance": (67, 2, (11, 0), (), "SingleIdenticalSheetInstance", None),
		"StrictPriorities": (64, 2, (11, 0), (), "StrictPriorities", None),
		"SuppressDialogs": (52, 2, (11, 0), (), "SuppressDialogs", None),
		"Temporary": (29, 2, (2, 0), (), "Temporary", None),
		"TimePerSheet": (48, 2, (5, 0), (), "TimePerSheet", None),
		"TotalTime": (57, 2, (5, 0), (), "TotalTime", None),
		"UseNameIdentifiers": (53, 2, (11, 0), (), "UseNameIdentifiers", None),
		"UseSubroutines": (12, 2, (2, 0), (), "UseSubroutines", None),
		"WholeNestLevel": (46, 2, (2, 0), (), "WholeNestLevel", None),
	}
	_prop_map_put_ = {
		"AllowSolidParts": ((63, LCID, 4, 0),()),
		"AssistedNest": ((44, LCID, 4, 0),()),
		"BalanceAcrossSheets": ((41, LCID, 4, 0),()),
		"CustomAngle": ((35, LCID, 4, 0),()),
		"CutDirection": ((37, LCID, 4, 0),()),
		"CutWidth": ((36, LCID, 4, 0),()),
		"EdgeGap": ((9, LCID, 4, 0),()),
		"EvenlySpacedParts": ((61, LCID, 4, 0),()),
		"FileName": ((1, LCID, 4, 0),()),
		"FromGui": ((49, LCID, 4, 0),()),
		"FromScreen": ((23, LCID, 4, 0),()),
		"InnerFirst": ((14, LCID, 4, 0),()),
		"LeadInGap": ((10, LCID, 4, 0),()),
		"ListName": ((2, LCID, 4, 0),()),
		"MinimiseSheetPatterns": ((50, LCID, 4, 0),()),
		"MinimiseToolChanges": ((15, LCID, 4, 0),()),
		"NestSide": ((17, LCID, 4, 0),()),
		"NestingMethod": ((28, LCID, 4, 0),()),
		"OffcutPreference": ((58, LCID, 4, 0),()),
		"OptimiseForCuts": ((39, LCID, 4, 0),()),
		"OptimiseLevel": ((40, LCID, 4, 0),()),
		"OptimizedToolPathOverlap": ((62, LCID, 4, 0),()),
		"OrderByPart": ((16, LCID, 4, 0),()),
		"PartGap": ((11, LCID, 4, 0),()),
		"PathType": ((20, LCID, 4, 0),()),
		"PreserveSheetEdge": ((34, LCID, 4, 0),()),
		"PreventApertureNest": ((51, LCID, 4, 0),()),
		"RepeatFirstRow": ((13, LCID, 4, 0),()),
		"Resolution": ((27, LCID, 4, 0),()),
		"SelectBestSheet": ((47, LCID, 4, 0),()),
		"SheetList": ((55, LCID, 4, 0),()),
		"SheetOrder": ((56, LCID, 4, 0),()),
		"SingleIdenticalSheetInstance": ((67, LCID, 4, 0),()),
		"StrictPriorities": ((64, LCID, 4, 0),()),
		"SuppressDialogs": ((52, LCID, 4, 0),()),
		"TimePerSheet": ((48, LCID, 4, 0),()),
		"TotalTime": ((57, LCID, 4, 0),()),
		"UseNameIdentifiers": ((53, LCID, 4, 0),()),
		"UseSubroutines": ((12, LCID, 4, 0),()),
		"WholeNestLevel": ((46, LCID, 4, 0),()),
	}
	# Default method for this class is 'Item'
	def __call__(self, Index=defaultNamedNotOptArg):
		'Returns the specified item'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, '__call__', '{8ACC255D-1758-4296-AE13-FA3DC51E1641}')
		return ret

	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,2,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, '{8ACC255D-1758-4296-AE13-FA3DC51E1641}')
	#This class has Count() property - allow len(ob) to provide this
	def __len__(self):
		return self._ApplyTypes_(*(3, 2, (3, 0), (), "Count", None))
	#This class has a __len__ - this is needed so 'if object:' always returns TRUE.
	def __nonzero__(self):
		return True

class INestPart(DispatchBaseClass):
	'INestPart Interface'
	CLSID = IID('{8ACC255D-1758-4296-AE13-FA3DC51E1641}')
	coclass_clsid = IID('{485EF309-87A4-41C5-91CC-C9ECB28BF7B5}')

	def AddSpecificRotation(self, Angle=defaultNamedNotOptArg):
		'Add a specific rotation angle to the list'
		return self._oleobj_.InvokeTypes(29, LCID, 1, (24, 0), ((5, 1),),Angle
			)

	# The method Attribute is actually a property, but must be used as a method to correctly pass the arguments
	def Attribute(self, key=defaultNamedNotOptArg):
		'Note data is a reference, so is maintained by caller'
		return self._ApplyTypes_(3, 2, (12, 0), ((8, 1),), 'Attribute', None,key
			)

	def GetExtentL(self, minx=defaultNamedNotOptArg, miny=defaultNamedNotOptArg, maxx=defaultNamedNotOptArg, maxy=defaultNamedNotOptArg):
		'Gives extents of this part'
		return self._oleobj_.InvokeTypes(20, LCID, 1, (24, 0), ((16389, 1), (16389, 1), (16389, 1), (16389, 1)),minx
			, miny, maxx, maxy)

	def HasRotationByNinety(self):
		'TRUE if this part can be rotated by ninety degrees (for rectangular nesting)'
		return self._oleobj_.InvokeTypes(32, LCID, 1, (3, 0), (),)

	def IsSame(self, Part=defaultNamedNotOptArg):
		'Returns true if the given part is the same as this part'
		return self._oleobj_.InvokeTypes(23, LCID, 1, (2, 0), ((9, 1),),Part
			)

	def PlacePart(self, x=defaultNamedNotOptArg, y=defaultNamedNotOptArg, Angle=defaultNamedNotOptArg, Mirror=defaultNamedNotOptArg
			, Subroutine=defaultNamedNotOptArg):
		"This causes the part to place itself at (x,y) and return the paths. The part is placed as a subrouting if 'Subroutine' is true"
		ret = self._oleobj_.InvokeTypes(12, LCID, 1, (9, 0), ((16389, 1), (16389, 1), (16389, 1), (16386, 1), (2, 1)),x
			, y, Angle, Mirror, Subroutine)
		if ret is not None:
			ret = Dispatch(ret, 'PlacePart', None)
		return ret

	def RemoveSpecificRotation(self, Angle=defaultNamedNotOptArg):
		'Removes a specific angle from the list'
		return self._oleobj_.InvokeTypes(30, LCID, 1, (24, 0), ((5, 1),),Angle
			)

	# The method SetAttribute is actually a property, but must be used as a method to correctly pass the arguments
	def SetAttribute(self, key=defaultNamedNotOptArg, arg1=defaultUnnamedArg):
		'Note data is a reference, so is maintained by caller'
		return self._oleobj_.InvokeTypes(3, LCID, 4, (24, 0), ((8, 1), (12, 1)),key
			, arg1)

	def SetExtensionConfig(self, ExtensionName=defaultNamedNotOptArg, ConfigString=defaultNamedNotOptArg):
		'Sets the extension config string in this part'
		return self._oleobj_.InvokeTypes(24, LCID, 1, (24, 0), ((8, 1), (8, 1)),ExtensionName
			, ConfigString)

	# The method SetSpecificRotation is actually a property, but must be used as a method to correctly pass the arguments
	def SetSpecificRotation(self, Index=defaultNamedNotOptArg, arg1=defaultUnnamedArg):
		'allows indexed access to any specific rotation angles'
		return self._oleobj_.InvokeTypes(28, LCID, 4, (24, 0), ((3, 1), (5, 1)),Index
			, arg1)

	# The method SpecificRotation is actually a property, but must be used as a method to correctly pass the arguments
	def SpecificRotation(self, Index=defaultNamedNotOptArg):
		'allows indexed access to any specific rotation angles'
		return self._oleobj_.InvokeTypes(28, LCID, 2, (5, 0), ((3, 1),),Index
			)

	_prop_map_get_ = {
		"AllowMirror": (10, 2, (2, 0), (), "AllowMirror", None),
		"Annotation": (22, 2, (2, 0), (), "Annotation", None),
		"AssociatedSolidParts": (36, 2, (9, 0), (), "AssociatedSolidParts", None),
		"CheckPaths": (2, 2, (9, 0), (), "CheckPaths", None),
		"ClassPointerRemoved": (5, 2, (3, 0), (), "ClassPointerRemoved", None),
		"ExtraPartGap": (38, 2, (5, 0), (), "ExtraPartGap", None),
		"FileName": (13, 2, (8, 0), (), "FileName", None),
		"Ignore3DPaths": (35, 2, (11, 0), (), "Ignore3DPaths", None),
		"IgnoreApertures": (39, 2, (11, 0), (), "IgnoreApertures", None),
		"IgnorePathsOnWorkPlanes": (40, 2, (11, 0), (), "IgnorePathsOnWorkPlanes", None),
		"IncludeSolidParts": (37, 2, (11, 0), (), "IncludeSolidParts", None),
		# Method 'Instances' returns object of type 'INestPartInstances'
		"Instances": (17, 2, (9, 0), (), "Instances", '{8B25EDA4-0887-4EA2-A9B6-D78ABCDDC8D9}'),
		"InternalText": (21, 2, (9, 0), (), "InternalText", None),
		"ItemNumber": (16, 2, (3, 0), (), "ItemNumber", None),
		"KitNumber": (34, 2, (3, 0), (), "KitNumber", None),
		"MaxPerSheet": (31, 2, (3, 0), (), "MaxPerSheet", None),
		"Modified": (19, 2, (2, 0), (), "Modified", None),
		"Name": (6, 2, (8, 0), (), "Name", None),
		"NumRequired": (14, 2, (3, 0), (), "NumRequired", None),
		"NumSpecificRotations": (27, 2, (3, 0), (), "NumSpecificRotations", None),
		"Paths": (1, 2, (9, 0), (), "Paths", None),
		"PlaceOrder": (25, 2, (3, 0), (), "PlaceOrder", None),
		"Priority": (9, 2, (3, 0), (), "Priority", None),
		"QualityZone": (33, 2, (3, 0), (), "QualityZone", None),
		"Required": (8, 2, (3, 0), (), "Required", None),
		"RotationAngle": (11, 2, (5, 0), (), "RotationAngle", None),
		"Total": (15, 2, (3, 0), (), "Total", None),
		"TryRotatedFirst": (26, 2, (2, 0), (), "TryRotatedFirst", None),
	}
	_prop_map_put_ = {
		"AllowMirror": ((10, LCID, 4, 0),()),
		"Annotation": ((22, LCID, 4, 0),()),
		"AssociatedSolidParts": ((36, LCID, 4, 0),()),
		"CheckPaths": ((2, LCID, 4, 0),()),
		"ExtraPartGap": ((38, LCID, 4, 0),()),
		"FileName": ((13, LCID, 4, 0),()),
		"Ignore3DPaths": ((35, LCID, 4, 0),()),
		"IgnoreApertures": ((39, LCID, 4, 0),()),
		"IgnorePathsOnWorkPlanes": ((40, LCID, 4, 0),()),
		"IncludeSolidParts": ((37, LCID, 4, 0),()),
		"InternalText": ((21, LCID, 4, 0),()),
		"KitNumber": ((34, LCID, 4, 0),()),
		"MaxPerSheet": ((31, LCID, 4, 0),()),
		"Name": ((6, LCID, 4, 0),()),
		"NumSpecificRotations": ((27, LCID, 4, 0),()),
		"Paths": ((1, LCID, 4, 0),()),
		"PlaceOrder": ((25, LCID, 4, 0),()),
		"Priority": ((9, LCID, 4, 0),()),
		"QualityZone": ((33, LCID, 4, 0),()),
		"Required": ((8, LCID, 4, 0),()),
		"RotationAngle": ((11, LCID, 4, 0),()),
		"TryRotatedFirst": ((26, LCID, 4, 0),()),
	}
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,3,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, None)

class INestPartInstance(DispatchBaseClass):
	'INestPartInstance Interface'
	CLSID = IID('{972F8639-17D0-4413-A31B-E0F509880998}')
	coclass_clsid = IID('{1287E979-83A6-4C8E-90B2-DB71CA4C1F37}')

	_prop_map_get_ = {
		"FileName": (3, 2, (8, 0), (), "FileName", None),
		"Mirrored": (7, 2, (11, 0), (), "Mirrored", None),
		"Name": (2, 2, (8, 0), (), "Name", None),
		"Paths": (4, 2, (9, 0), (), "Paths", None),
		"RotationAngle": (6, 2, (5, 0), (), "RotationAngle", None),
		# Method 'Sheet' returns object of type 'INestSheet'
		"Sheet": (1, 2, (9, 0), (), "Sheet", '{393B862B-F535-4010-B5EF-1D1482809F2A}'),
	}
	_prop_map_put_ = {
	}
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,3,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, None)

class INestPartInstances(DispatchBaseClass):
	'INestPartInstances Interface'
	CLSID = IID('{8B25EDA4-0887-4EA2-A9B6-D78ABCDDC8D9}')
	coclass_clsid = IID('{4BCC51A8-6934-4B04-BE49-E105CE847FA8}')

	# Result is of type INestPartInstance
	def Item(self, Index=defaultNamedNotOptArg):
		'method Item'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, 'Item', '{972F8639-17D0-4413-A31B-E0F509880998}')
		return ret

	_prop_map_get_ = {
		"Count": (1, 2, (3, 0), (), "Count", None),
	}
	_prop_map_put_ = {
	}
	# Default method for this class is 'Item'
	def __call__(self, Index=defaultNamedNotOptArg):
		'method Item'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, '__call__', '{972F8639-17D0-4413-A31B-E0F509880998}')
		return ret

	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,2,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, '{972F8639-17D0-4413-A31B-E0F509880998}')
	#This class has Count() property - allow len(ob) to provide this
	def __len__(self):
		return self._ApplyTypes_(*(1, 2, (3, 0), (), "Count", None))
	#This class has a __len__ - this is needed so 'if object:' always returns TRUE.
	def __nonzero__(self):
		return True

class INestParts(DispatchBaseClass):
	'INestParts Interface'
	CLSID = IID('{5FFBEE0B-0A71-4255-BEBB-99F138EEFC4D}')
	coclass_clsid = IID('{12FFBF81-08E5-4038-A2CD-C952A262C7FD}')

	# Result is of type INestPart
	def Item(self, Index=defaultNamedNotOptArg):
		'method Item'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((12, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, 'Item', '{8ACC255D-1758-4296-AE13-FA3DC51E1641}')
		return ret

	def SaveInfo(self, FileName=defaultNamedNotOptArg):
		"Saves nest info to a CSV file. Save type is 'by part'"
		return self._oleobj_.InvokeTypes(2, LCID, 1, (24, 0), ((8, 1),),FileName
			)

	_prop_map_get_ = {
		"Count": (1, 2, (3, 0), (), "Count", None),
	}
	_prop_map_put_ = {
	}
	# Default method for this class is 'Item'
	def __call__(self, Index=defaultNamedNotOptArg):
		'method Item'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((12, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, '__call__', '{8ACC255D-1758-4296-AE13-FA3DC51E1641}')
		return ret

	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,2,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, '{8ACC255D-1758-4296-AE13-FA3DC51E1641}')
	#This class has Count() property - allow len(ob) to provide this
	def __len__(self):
		return self._ApplyTypes_(*(1, 2, (3, 0), (), "Count", None))
	#This class has a __len__ - this is needed so 'if object:' always returns TRUE.
	def __nonzero__(self):
		return True

class INestSheet(DispatchBaseClass):
	'INestSheet Interface'
	CLSID = IID('{393B862B-F535-4010-B5EF-1D1482809F2A}')
	coclass_clsid = IID('{00406E2C-CFE4-4A81-A05E-7445826669B5}')

	# The method Attribute is actually a property, but must be used as a method to correctly pass the arguments
	def Attribute(self, key=defaultNamedNotOptArg):
		'Note data is a reference, so is maintained by caller'
		return self._ApplyTypes_(3, 2, (12, 0), ((8, 1),), 'Attribute', None,key
			)

	def GetRealPaths(self):
		'Returns the sheet path as it has been placed in the drawing in a collection of size 1'
		ret = self._oleobj_.InvokeTypes(17, LCID, 1, (9, 0), (),)
		if ret is not None:
			ret = Dispatch(ret, 'GetRealPaths', None)
		return ret

	def IsSame(self, Sheet=defaultNamedNotOptArg):
		'Returns true if the given sheet is the same as this one'
		return self._oleobj_.InvokeTypes(16, LCID, 1, (2, 0), ((9, 1),),Sheet
			)

	def NotifyComplete(self, pPaths=defaultNamedNotOptArg):
		return self._oleobj_.InvokeTypes(18, LCID, 1, (24, 0), ((9, 1),),pPaths
			)

	def PlaceSheet(self, x=defaultNamedNotOptArg, y=defaultNamedNotOptArg):
		'This places the sheet at (x,y) and returns the paths copied'
		ret = self._oleobj_.InvokeTypes(12, LCID, 1, (9, 0), ((16389, 1), (16389, 1)),x
			, y)
		if ret is not None:
			ret = Dispatch(ret, 'PlaceSheet', None)
		return ret

	# The method SetAttribute is actually a property, but must be used as a method to correctly pass the arguments
	def SetAttribute(self, key=defaultNamedNotOptArg, arg1=defaultUnnamedArg):
		'Note data is a reference, so is maintained by caller'
		return self._oleobj_.InvokeTypes(3, LCID, 4, (24, 0), ((8, 1), (12, 1)),key
			, arg1)

	_prop_map_get_ = {
		"CheckPaths": (2, 2, (9, 0), (), "CheckPaths", None),
		"ClassPointerRemoved": (5, 2, (3, 0), (), "ClassPointerRemoved", None),
		"Geometry": (13, 2, (9, 0), (), "Geometry", None),
		"MaterialName": (11, 2, (8, 0), (), "MaterialName", None),
		"Multiplicity": (19, 2, (3, 0), (), "Multiplicity", None),
		"Name": (6, 2, (8, 0), (), "Name", None),
		# Method 'Parts' returns object of type 'INestPartInstances'
		"Parts": (14, 2, (9, 0), (), "Parts", '{8B25EDA4-0887-4EA2-A9B6-D78ABCDDC8D9}'),
		"Path": (9, 2, (9, 0), (), "Path", None),
		"Paths": (1, 2, (9, 0), (), "Paths", None),
		"Required": (8, 2, (3, 0), (), "Required", None),
		"Thickness": (10, 2, (5, 0), (), "Thickness", None),
	}
	_prop_map_put_ = {
		"CheckPaths": ((2, LCID, 4, 0),()),
		"MaterialName": ((11, LCID, 4, 0),()),
		"Name": ((6, LCID, 4, 0),()),
		"Path": ((9, LCID, 4, 0),()),
		"Paths": ((1, LCID, 4, 0),()),
		"Required": ((8, LCID, 4, 0),()),
		"Thickness": ((10, LCID, 4, 0),()),
	}
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,3,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, None)

class INestSheets(DispatchBaseClass):
	'INestSheets Interface'
	CLSID = IID('{D55B5242-FAEA-4704-8C71-0EB0746BC751}')
	coclass_clsid = IID('{ACDEA351-A51F-4553-821E-B51EC78FC231}')

	# Result is of type INestSheet
	def Item(self, Index=defaultNamedNotOptArg):
		'method Item'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((12, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, 'Item', '{393B862B-F535-4010-B5EF-1D1482809F2A}')
		return ret

	def SaveInfo(self, FileName=defaultNamedNotOptArg):
		"Saves data to a CSV file of given name. Save type is 'by sheet'"
		return self._oleobj_.InvokeTypes(2, LCID, 1, (24, 0), ((8, 1),),FileName
			)

	_prop_map_get_ = {
		"Count": (1, 2, (3, 0), (), "Count", None),
	}
	_prop_map_put_ = {
	}
	# Default method for this class is 'Item'
	def __call__(self, Index=defaultNamedNotOptArg):
		'method Item'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((12, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, '__call__', '{393B862B-F535-4010-B5EF-1D1482809F2A}')
		return ret

	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,2,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, '{393B862B-F535-4010-B5EF-1D1482809F2A}')
	#This class has Count() property - allow len(ob) to provide this
	def __len__(self):
		return self._ApplyTypes_(*(1, 2, (3, 0), (), "Count", None))
	#This class has a __len__ - this is needed so 'if object:' always returns TRUE.
	def __nonzero__(self):
		return True

class INesting(DispatchBaseClass):
	'INesting Interface'
	CLSID = IID('{31DEE408-CC4F-44A8-87AC-C1C8770CA018}')
	coclass_clsid = IID('{57250022-AD47-4205-AA0D-9F8039C315B3}')

	# Result is of type INestList
	def AutoNest(self, SheetPath=defaultNamedNotOptArg, Count=defaultNamedNotOptArg, Nestlist=defaultNamedNotOptArg):
		'Quick nesting call, takes a path to use as the sheet, the number of sheets and a nest list'
		ret = self._oleobj_.InvokeTypes(35, LCID, 1, (9, 0), ((9, 1), (3, 1), (9, 1)),SheetPath
			, Count, Nestlist)
		if ret is not None:
			ret = Dispatch(ret, 'AutoNest', '{32E79675-9214-4CCF-BC22-68AB6B9574A0}')
		return ret

	# Result is of type INestEvents3
	def CreateEventHandler(self):
		ret = self._oleobj_.InvokeTypes(37, LCID, 1, (9, 0), (),)
		if ret is not None:
			ret = Dispatch(ret, 'CreateEventHandler', '{9A867723-2B30-4B44-AB02-BAF612A0FBF4}')
		return ret

	# Result is of type INestingExtension3
	def CreateExtensionHandler(self):
		ret = self._oleobj_.InvokeTypes(38, LCID, 1, (9, 0), (),)
		if ret is not None:
			ret = Dispatch(ret, 'CreateExtensionHandler', '{576061B6-AF45-4CFB-AD31-2E42C2A68F2E}')
		return ret

	def DeleteAllNestLists(self):
		'Deletes all nestlist currently loaded'
		return self._oleobj_.InvokeTypes(34, LCID, 1, (24, 0), (),)

	def DeleteNestList(self, FileName=defaultNamedNotOptArg):
		'Call this to have the nestlist with the given filename removed from the nesting manager. This will free up all resources relating to that nestlist'
		return self._oleobj_.InvokeTypes(3, LCID, 1, (24, 0), ((8, 1),),FileName
			)

	def DeleteNestListByIndex(self, Index=defaultNamedNotOptArg):
		'Deletes a nestlist given its index, instead of its name'
		return self._oleobj_.InvokeTypes(33, LCID, 1, (24, 0), ((3, 1),),Index
			)

	# Result is of type INestData
	def GetNestData(self, FileName=defaultNamedNotOptArg):
		'Old compatibility function for 1.1 (depracated)'
		ret = self._oleobj_.InvokeTypes(9, LCID, 1, (9, 0), ((8, 1),),FileName
			)
		if ret is not None:
			ret = Dispatch(ret, 'GetNestData', '{175E5A9E-72D2-4163-B751-382357CD5D6A}')
		return ret

	# Result is of type INestInformation
	def GetNestInformation(self):
		'Returns nest information structures for the current drawing'
		ret = self._oleobj_.InvokeTypes(10, LCID, 1, (9, 0), (),)
		if ret is not None:
			ret = Dispatch(ret, 'GetNestInformation', '{6B205E8C-FD6E-44ED-ABA2-9FD6870B42BB}')
		return ret

	# Result is of type INestInformation
	def GetNestInformationForDrawing(self, Drawing=defaultNamedNotOptArg):
		'Returns nest information structures for the given drawing'
		ret = self._oleobj_.InvokeTypes(39, LCID, 1, (9, 0), ((9, 1),),Drawing
			)
		if ret is not None:
			ret = Dispatch(ret, 'GetNestInformationForDrawing', '{6B205E8C-FD6E-44ED-ABA2-9FD6870B42BB}')
		return ret

	def IsNestListNameValid(self, pNestList=defaultNamedNotOptArg, NewName=defaultNamedNotOptArg):
		"Returns true if the nest-list's new name is valid, false otherwise"
		return self._oleobj_.InvokeTypes(42, LCID, 1, (11, 0), ((9, 1), (8, 1)),pNestList
			, NewName)

	# Result is of type INestList
	def Item(self, Index=defaultNamedNotOptArg):
		'Returns the nestlist specified by Index'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, 'Item', '{32E79675-9214-4CCF-BC22-68AB6B9574A0}')
		return ret

	# Result is of type INestList
	def LoadNestList(self, FileName=defaultNamedNotOptArg):
		'Call this to have the named nestlist loaded from disk and returned'
		ret = self._oleobj_.InvokeTypes(22, LCID, 1, (9, 0), ((8, 1),),FileName
			)
		if ret is not None:
			ret = Dispatch(ret, 'LoadNestList', '{32E79675-9214-4CCF-BC22-68AB6B9574A0}')
		return ret

	def MakeOffcuts(self, min_x=defaultNamedNotOptArg, min_y=defaultNamedNotOptArg, Type=defaultNamedNotOptArg, apply_style=defaultNamedNotOptArg
			, cut_side=defaultNamedNotOptArg, style_full_path=defaultNamedNotOptArg):
		"Returns a collection of offcuts (as Paths) generated from the current drawing's nested sheets according to input settings. [min_x/min_y] minimum size of acceptable offcut, [type] direction and/or order in which to look for valid offcuts, [apply_style] if TRUE "
		ret = self._oleobj_.InvokeTypes(43, LCID, 1, (9, 0), ((5, 1), (5, 1), (3, 1), (11, 1), (3, 1), (8, 1)),min_x
			, min_y, Type, apply_style, cut_side, style_full_path
			)
		if ret is not None:
			ret = Dispatch(ret, 'MakeOffcuts', None)
		return ret

	# Result is of type INestList
	def Nest(self, Nestlist=defaultNamedNotOptArg, SheetList=defaultNamedNotOptArg):
		'This nests the given nestlist into sheets in the sheetlist, returning a new nestlist of un-nested parts'
		ret = self._oleobj_.InvokeTypes(11, LCID, 1, (9, 0), ((9, 1), (9, 1)),Nestlist
			, SheetList)
		if ret is not None:
			ret = Dispatch(ret, 'Nest', '{32E79675-9214-4CCF-BC22-68AB6B9574A0}')
		return ret

	# Result is of type INestList
	def NestUsingEngine(self, Nestlist=defaultNamedNotOptArg, SheetList=defaultNamedNotOptArg, Engine=defaultNamedNotOptArg):
		'Similar to the Nest function, but allows use of a custom nest engine'
		ret = self._oleobj_.InvokeTypes(12, LCID, 1, (9, 0), ((9, 1), (9, 1), (9, 1)),Nestlist
			, SheetList, Engine)
		if ret is not None:
			ret = Dispatch(ret, 'NestUsingEngine', '{32E79675-9214-4CCF-BC22-68AB6B9574A0}')
		return ret

	# Result is of type INestList
	def NewNestList(self, Name=defaultNamedNotOptArg):
		'Call this to create a new, empty nest list. Use LoadNestList to create and load a nestlist.'
		ret = self._oleobj_.InvokeTypes(1, LCID, 1, (9, 0), ((8, 1),),Name
			)
		if ret is not None:
			ret = Dispatch(ret, 'NewNestList', '{32E79675-9214-4CCF-BC22-68AB6B9574A0}')
		return ret

	# Result is of type ISheetList
	def NewSheetList(self):
		'Creates an empty sheet list for nesting into'
		ret = self._oleobj_.InvokeTypes(4, LCID, 1, (9, 0), (),)
		if ret is not None:
			ret = Dispatch(ret, 'NewSheetList', '{0687113C-A6A0-4D3C-B56F-432DF61A5774}')
		return ret

	# Result is of type INestList
	def NewTemporaryNestList(self):
		"Creates a new nestlist but does not add it to nesting's main collection, or trigger creation events"
		ret = self._oleobj_.InvokeTypes(13, LCID, 1, (9, 0), (),)
		if ret is not None:
			ret = Dispatch(ret, 'NewTemporaryNestList', '{32E79675-9214-4CCF-BC22-68AB6B9574A0}')
		return ret

	def RegisterDebugEventHandler(self, EventHandler=defaultNamedNotOptArg, DebugIndex=defaultNamedNotOptArg):
		'This lets you register an event handler which will take the place of any previously registered with the same DebugIndex (it avoids multiple registrations during development)'
		return self._oleobj_.InvokeTypes(25, LCID, 1, (24, 0), ((9, 1), (3, 1)),EventHandler
			, DebugIndex)

	def RegisterDebugExtensionHandler(self, ExtensionHandler=defaultNamedNotOptArg, DebugIndex=defaultNamedNotOptArg):
		'See RegisterDebugEventHandler for details'
		return self._oleobj_.InvokeTypes(29, LCID, 1, (24, 0), ((9, 1), (3, 1)),ExtensionHandler
			, DebugIndex)

	def RegisterEventHandler(self, EventHandler=defaultNamedNotOptArg):
		'Create a NestEvents object in a class module then pass it to this function to let nesting know where you want to receive nesting events'
		return self._oleobj_.InvokeTypes(6, LCID, 1, (24, 0), ((9, 1),),EventHandler
			)

	def RegisterExtensionHandler(self, ExtensionHandler=defaultNamedNotOptArg):
		'Call this with a NestExtension class object to register an extension handler'
		return self._oleobj_.InvokeTypes(23, LCID, 1, (24, 0), ((9, 1),),ExtensionHandler
			)

	def UnRegisterDebugEventHandler(self, DebugIndex=defaultNamedNotOptArg):
		'If a handler was registered using a debug index, this can be used to unregister by index instead of requiring the original object.'
		return self._oleobj_.InvokeTypes(27, LCID, 1, (24, 0), ((3, 1),),DebugIndex
			)

	def UnRegisterDebugExtensionHandler(self, DebugIndex=defaultNamedNotOptArg):
		'See UnRegisterDebugEventHandler'
		return self._oleobj_.InvokeTypes(31, LCID, 1, (24, 0), ((3, 1),),DebugIndex
			)

	def UnRegisterEventHandler(self, EventHandler=defaultNamedNotOptArg):
		'This unregisters your event handler - good for writing temporary handlers'
		return self._oleobj_.InvokeTypes(15, LCID, 1, (24, 0), ((9, 1),),EventHandler
			)

	def UnRegisterExtensionHandler(self, ExtensionHandler=defaultNamedNotOptArg):
		'Call this to remove/deregister an extension handler'
		return self._oleobj_.InvokeTypes(24, LCID, 1, (24, 0), ((9, 1),),ExtensionHandler
			)

	_prop_map_get_ = {
		"Abort": (36, 2, (2, 0), (), "Abort", None),
		"ClassPointerRemoved": (19, 2, (3, 0), (), "ClassPointerRemoved", None),
		"Count": (2, 2, (3, 0), (), "Count", None),
		# Method 'Extensions' returns object of type 'INestExtensions'
		"Extensions": (20, 2, (9, 0), (), "Extensions", '{7B37B17F-B44C-4625-A435-B137E03E6AAF}'),
		"Level": (18, 2, (3, 0), (), "Level", None),
		# Method 'SheetDB' returns object of type 'ISheetDBase'
		"SheetDB": (21, 2, (9, 0), (), "SheetDB", '{98D8443D-C842-4F05-9D64-BB03AE1A65C6}'),
		# Method 'SheetDatabase' returns object of type 'ISheetDatabase'
		"SheetDatabase": (40, 2, (9, 0), (), "SheetDatabase", '{EE72FD01-BA42-4DFC-8BDE-9D522F43DE75}'),
		"SuppressDialogs": (41, 2, (11, 0), (), "SuppressDialogs", None),
	}
	_prop_map_put_ = {
		"Abort": ((36, LCID, 4, 0),()),
		"SuppressDialogs": ((41, LCID, 4, 0),()),
	}
	# Default method for this class is 'Item'
	def __call__(self, Index=defaultNamedNotOptArg):
		'Returns the nestlist specified by Index'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, '__call__', '{32E79675-9214-4CCF-BC22-68AB6B9574A0}')
		return ret

	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,2,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, '{32E79675-9214-4CCF-BC22-68AB6B9574A0}')
	#This class has Count() property - allow len(ob) to provide this
	def __len__(self):
		return self._ApplyTypes_(*(2, 2, (3, 0), (), "Count", None))
	#This class has a __len__ - this is needed so 'if object:' always returns TRUE.
	def __nonzero__(self):
		return True

class INestingExtension3(DispatchBaseClass):
	'INestingExtension3 Interface'
	CLSID = IID('{576061B6-AF45-4CFB-AD31-2E42C2A68F2E}')
	coclass_clsid = IID('{C575F813-38F0-44D4-8D08-227D2794A94F}')

	_prop_map_get_ = {
		"ClassPointerRemoved": (1, 2, (3, 0), (), "ClassPointerRemoved", None),
	}
	_prop_map_put_ = {
	}
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,3,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, None)

class INestingExtensionEvents:
	'INestingExtensionEvents Interface'
	CLSID = CLSID_Sink = IID('{F2339392-DB43-4B6C-95CF-D67B51B577AF}')
	coclass_clsid = IID('{C575F813-38F0-44D4-8D08-227D2794A94F}')
	_public_methods_ = [] # For COM Server support
	_dispid_to_func_ = {
		        1 : "OnExtensionName",
		        2 : "OnGetExtensionHeading",
		        3 : "OnGetExtensionCount",
		        4 : "OnGetExtensionText",
		        5 : "OnGetExtensionState",
		        6 : "OnSetExtensionState",
		        7 : "OnGetExtensionEnabled",
		        8 : "OnGetExtensionDefaultConfig",
		        9 : "OnGetExtensionSaveConfig",
		       10 : "OnConfigListExtension",
		       11 : "OnConfigPartExtension",
		       12 : "OnGetExtensionType",
		}

	def __init__(self, oobj = None):
		if oobj is None:
			self._olecp = None
		else:
			import win32com.server.util
			from win32com.server.policy import EventHandlerPolicy
			cpc=oobj._oleobj_.QueryInterface(pythoncom.IID_IConnectionPointContainer)
			cp=cpc.FindConnectionPoint(self.CLSID_Sink)
			cookie=cp.Advise(win32com.server.util.wrap(self, usePolicy=EventHandlerPolicy))
			self._olecp,self._olecp_cookie = cp,cookie
	def __del__(self):
		try:
			self.close()
		except pythoncom.com_error:
			pass
	def close(self):
		if self._olecp is not None:
			cp,cookie,self._olecp,self._olecp_cookie = self._olecp,self._olecp_cookie,None,None
			cp.Unadvise(cookie)
	def _query_interface_(self, iid):
		import win32com.server.util
		if iid==self.CLSID_Sink: return win32com.server.util.wrap(self)

	# Event Handlers
	# If you create handlers, they should have the following prototypes:
#	def OnExtensionName(self, Name=defaultNamedNotOptArg):
#		'method ExtensionName'
#	def OnGetExtensionHeading(self, Heading=defaultNamedNotOptArg):
#		'method GetExtensionHeading'
#	def OnGetExtensionCount(self, Count=defaultNamedNotOptArg):
#		'method GetExtensionCount'
#	def OnGetExtensionText(self, Id=defaultNamedNotOptArg, Text=defaultNamedNotOptArg):
#		'method GetExtensionText'
#	def OnGetExtensionState(self, Id=defaultNamedNotOptArg, State=defaultNamedNotOptArg):
#		'method GetExtensionState'
#	def OnSetExtensionState(self, Id=defaultNamedNotOptArg, State=defaultNamedNotOptArg):
#		'method SetExtensionState'
#	def OnGetExtensionEnabled(self, Id=defaultNamedNotOptArg, Enabled=defaultNamedNotOptArg):
#		'method GetExtensionEnabled'
#	def OnGetExtensionDefaultConfig(self, ConfigString=defaultNamedNotOptArg):
#		'method GetExtensionDefaultConfig'
#	def OnGetExtensionSaveConfig(self, ConfigString=defaultNamedNotOptArg):
#		'method GetExtensionSaveConfig'
#	def OnConfigListExtension(self, list=defaultNamedNotOptArg, ConfigString=defaultNamedNotOptArg):
#		'method ConfigListExtension'
#	def OnConfigPartExtension(self, Part=defaultNamedNotOptArg, ConfigString=defaultNamedNotOptArg):
#		'method ConfigPartExtension'
#	def OnGetExtensionType(self, ExtType=defaultNamedNotOptArg):
#		'method GetExtensionType'


class ISheetDBElem(DispatchBaseClass):
	'ISheetDBElem Interface'
	CLSID = IID('{65FD3369-7398-404A-852F-0C092EA7BC25}')
	coclass_clsid = IID('{308D5B14-E22B-4963-8814-F665C10E9A13}')

	_prop_map_get_ = {
		"Comment": (11, 2, (8, 0), (), "Comment", None),
		"Cost": (3, 2, (5, 0), (), "Cost", None),
		"CostType": (5, 2, (3, 0), (), "CostType", None),
		"DBUid": (12, 2, (3, 0), (), "DBUid", None),
		"Length": (9, 2, (5, 0), (), "Length", None),
		"Material": (1, 2, (8, 0), (), "Material", None),
		"NumAvailable": (6, 2, (3, 0), (), "NumAvailable", None),
		"OffCut": (2, 2, (2, 0), (), "OffCut", None),
		"Thickness": (7, 2, (5, 0), (), "Thickness", None),
		"TimeStamp": (13, 2, (3, 0), (), "TimeStamp", None),
		"Value": (10, 2, (5, 0), (), "Value", None),
		"Weight": (4, 2, (5, 0), (), "Weight", None),
		"Width": (8, 2, (5, 0), (), "Width", None),
	}
	_prop_map_put_ = {
		"Comment": ((11, LCID, 4, 0),()),
		"Cost": ((3, LCID, 4, 0),()),
		"CostType": ((5, LCID, 4, 0),()),
		"DBUid": ((12, LCID, 4, 0),()),
		"Length": ((9, LCID, 4, 0),()),
		"Material": ((1, LCID, 4, 0),()),
		"NumAvailable": ((6, LCID, 4, 0),()),
		"OffCut": ((2, LCID, 4, 0),()),
		"Thickness": ((7, LCID, 4, 0),()),
		"TimeStamp": ((13, LCID, 4, 0),()),
		"Value": ((10, LCID, 4, 0),()),
		"Weight": ((4, LCID, 4, 0),()),
		"Width": ((8, LCID, 4, 0),()),
	}
	# Default property for this class is 'Value'
	def __call__(self):
		return self._ApplyTypes_(*(10, 2, (5, 0), (), "Value", None))
	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,3,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, None)

class ISheetDBase(DispatchBaseClass):
	'ISheetDBase Interface'
	CLSID = IID('{98D8443D-C842-4F05-9D64-BB03AE1A65C6}')
	coclass_clsid = IID('{0D12AADE-D65D-47B4-B924-FC1099CF9207}')

	def AddSheet(self, Sheet=defaultNamedNotOptArg):
		'Adds a sheet, and all accompanying properties, to the database'
		return self._oleobj_.InvokeTypes(4, LCID, 1, (24, 0), ((9, 1),),Sheet
			)

	def CreateOffcuts(self):
		'This method scans the drawing for possible offcuts and offers them to the user for adding to the database'
		return self._oleobj_.InvokeTypes(13, LCID, 1, (24, 0), (),)

	def Delete(self, Index=defaultNamedNotOptArg):
		'Deletes the given indexed sheet from the database'
		return self._oleobj_.InvokeTypes(5, LCID, 1, (24, 0), ((12, 1),),Index
			)

	def FromDisk(self):
		'method FromDisk'
		return self._oleobj_.InvokeTypes(1, LCID, 1, (24, 0), (),)

	def InsertSheet(self, Index=defaultNamedNotOptArg):
		'Creates and sets up the sheet geometry at 0,0 and returns the path'
		ret = self._oleobj_.InvokeTypes(10, LCID, 1, (9, 0), ((12, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, 'InsertSheet', None)
		return ret

	# Result is of type ISheetDBElem
	def Item(self, Index=defaultNamedNotOptArg):
		'Returns the specified item'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((12, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, 'Item', '{65FD3369-7398-404A-852F-0C092EA7BC25}')
		return ret

	# Result is of type ISheetDBElem
	def NewSheet(self):
		'This gives a blank, fresh sheet to set up. Note it does NOT add it to the sheet database! Call AddSheet for that.'
		ret = self._oleobj_.InvokeTypes(8, LCID, 1, (9, 0), (),)
		if ret is not None:
			ret = Dispatch(ret, 'NewSheet', '{65FD3369-7398-404A-852F-0C092EA7BC25}')
		return ret

	def Refresh(self, Modified=pythoncom.Missing):
		"Refreshes the database from disk, only if necessary. Sets 'Modified' to true if something changed internally"
		return self._ApplyTypes_(9, 1, (24, 0), ((16395, 2),), 'Refresh', None,Modified
			)

	def ToDisk(self):
		'method ToDisk'
		return self._oleobj_.InvokeTypes(2, LCID, 1, (24, 0), (),)

	def Update(self):
		'Updates the sheet database based on the current drawing'
		return self._oleobj_.InvokeTypes(6, LCID, 1, (24, 0), (),)

	def UpdateFromScreen(self):
		'Updates the database given the offcuts used in the current drawing'
		return self._oleobj_.InvokeTypes(12, LCID, 1, (24, 0), (),)

	def UseOffcuts(self):
		'Call this to pop up the user interface to add offcuts into the drawing'
		return self._oleobj_.InvokeTypes(14, LCID, 1, (24, 0), (),)

	_prop_map_get_ = {
		"ClassPointerRemoved": (11, 2, (3, 0), (), "ClassPointerRemoved", None),
		"Count": (7, 2, (3, 0), (), "Count", None),
		"Modified": (3, 2, (2, 0), (), "Modified", None),
	}
	_prop_map_put_ = {
	}
	# Default method for this class is 'Item'
	def __call__(self, Index=defaultNamedNotOptArg):
		'Returns the specified item'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((12, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, '__call__', '{65FD3369-7398-404A-852F-0C092EA7BC25}')
		return ret

	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,2,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, '{65FD3369-7398-404A-852F-0C092EA7BC25}')
	#This class has Count() property - allow len(ob) to provide this
	def __len__(self):
		return self._ApplyTypes_(*(7, 2, (3, 0), (), "Count", None))
	#This class has a __len__ - this is needed so 'if object:' always returns TRUE.
	def __nonzero__(self):
		return True

class ISheetDatabase(DispatchBaseClass):
	CLSID = IID('{EE72FD01-BA42-4DFC-8BDE-9D522F43DE75}')
	coclass_clsid = IID('{1C2252AB-0AED-4650-A92C-F5354919A8AE}')

	# Result is of type IDatabaseMaterial
	def AddMaterial(self, Name=defaultNamedNotOptArg):
		'Add a material with the given name to the database, and return it'
		ret = self._oleobj_.InvokeTypes(1, LCID, 1, (9, 0), ((8, 1),),Name
			)
		if ret is not None:
			ret = Dispatch(ret, 'AddMaterial', '{26947A4F-EE56-4834-A341-A8166EA72D77}')
		return ret

	def CreateOffcuts(self):
		'Scan the drawing for possible offcuts and offer them to the user for adding to the database'
		return self._oleobj_.InvokeTypes(13, LCID, 1, (24, 0), (),)

	# Result is of type IDatabaseSheets
	def CreateSheetCollection(self):
		'Creates an empty COM collection of Sheets'
		ret = self._oleobj_.InvokeTypes(7, LCID, 1, (9, 0), (),)
		if ret is not None:
			ret = Dispatch(ret, 'CreateSheetCollection', '{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}')
		return ret

	# Result is of type IDatabaseMaterial
	def FindMaterial(self, Name=defaultNamedNotOptArg):
		'Locate a Material object by name (which is unique)'
		ret = self._oleobj_.InvokeTypes(6, LCID, 1, (9, 0), ((8, 1),),Name
			)
		if ret is not None:
			ret = Dispatch(ret, 'FindMaterial', '{26947A4F-EE56-4834-A341-A8166EA72D77}')
		return ret

	# Result is of type IDatabaseMaterial
	def FindMaterialByDatabaseID(self, Id=defaultNamedNotOptArg):
		'Locate a Material object by database ID'
		ret = self._oleobj_.InvokeTypes(9, LCID, 1, (9, 0), ((3, 1),),Id
			)
		if ret is not None:
			ret = Dispatch(ret, 'FindMaterialByDatabaseID', '{26947A4F-EE56-4834-A341-A8166EA72D77}')
		return ret

	# Result is of type IDatabaseSheet
	def FindSheet(self, Name=defaultNamedNotOptArg):
		'Locate a Sheet object by name (which is unique)'
		ret = self._oleobj_.InvokeTypes(8, LCID, 1, (9, 0), ((8, 1),),Name
			)
		if ret is not None:
			ret = Dispatch(ret, 'FindSheet', '{B843219A-C9CE-419A-9153-577BF8C9362D}')
		return ret

	# Result is of type IDatabaseSheet
	def FindSheetByDatabaseID(self, Id=defaultNamedNotOptArg):
		'Locate a Sheet object by database ID'
		ret = self._oleobj_.InvokeTypes(11, LCID, 1, (9, 0), ((3, 1),),Id
			)
		if ret is not None:
			ret = Dispatch(ret, 'FindSheetByDatabaseID', '{B843219A-C9CE-419A-9153-577BF8C9362D}')
		return ret

	# Result is of type IDatabaseThickness
	def FindThicknessByDatabaseID(self, Id=defaultNamedNotOptArg):
		'Locate a Thickness object by database ID'
		ret = self._oleobj_.InvokeTypes(10, LCID, 1, (9, 0), ((3, 1),),Id
			)
		if ret is not None:
			ret = Dispatch(ret, 'FindThicknessByDatabaseID', '{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}')
		return ret

	def Save(self):
		'Update the top-level values of the sheet database'
		return self._oleobj_.InvokeTypes(12, LCID, 1, (3, 0), (),)

	def SaveOffcutToDatabase(self, i_sheet=defaultNamedNotOptArg, i_drw=defaultNamedNotOptArg):
		'Save the provided offcut sheet to the database '
		# Result is a Unicode object
		return self._oleobj_.InvokeTypes(14, LCID, 1, (8, 0), ((9, 1), (9, 1)),i_sheet
			, i_drw)

	_prop_map_get_ = {
		"LengthUnits": (2, 2, (3, 0), (), "LengthUnits", None),
		# Method 'Materials' returns object of type 'IDatabaseMaterials'
		"Materials": (0, 2, (9, 0), (), "Materials", '{E838A5C4-4986-451E-8BAA-DDDDC5FE51E6}'),
		# Method 'Offcuts' returns object of type 'IDatabaseSheets'
		"Offcuts": (5, 2, (9, 0), (), "Offcuts", '{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}'),
		# Method 'Sheets' returns object of type 'IDatabaseSheets'
		"Sheets": (3, 2, (9, 0), (), "Sheets", '{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}'),
		# Method 'WholeSheets' returns object of type 'IDatabaseSheets'
		"WholeSheets": (4, 2, (9, 0), (), "WholeSheets", '{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}'),
	}
	_prop_map_put_ = {
		"LengthUnits": ((2, LCID, 4, 0),()),
	}
	# Default property for this class is 'Materials'
	def __call__(self):
		return self._ApplyTypes_(*(0, 2, (9, 0), (), "Materials", '{E838A5C4-4986-451E-8BAA-DDDDC5FE51E6}'))
	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,3,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, None)

class ISheetList(DispatchBaseClass):
	'ISheetList Interface'
	CLSID = IID('{0687113C-A6A0-4D3C-B56F-432DF61A5774}')
	coclass_clsid = IID('{426370B5-A456-4270-BB81-725FAB9884C7}')

	# Result is of type INestSheet
	def Add(self, Path=defaultNamedNotOptArg):
		'Adds a sheet with the path specified to the list. A NestSheet is returned.'
		ret = self._oleobj_.InvokeTypes(4, LCID, 1, (9, 0), ((9, 1),),Path
			)
		if ret is not None:
			ret = Dispatch(ret, 'Add', '{393B862B-F535-4010-B5EF-1D1482809F2A}')
		return ret

	def DeleteSheet(self, Sheet=defaultNamedNotOptArg):
		'Removes a sheet from the nestlist'
		return self._oleobj_.InvokeTypes(5, LCID, 1, (24, 0), ((9, 1),),Sheet
			)

	def DeleteSheetByIndex(self, SheetIndex=defaultNamedNotOptArg):
		'Removes a sheet from the nestlist, refered to by index'
		return self._oleobj_.InvokeTypes(8, LCID, 1, (24, 0), ((3, 1),),SheetIndex
			)

	# Result is of type INestSheet
	def Item(self, Index=defaultNamedNotOptArg):
		'Returns the sheet of the given index in the list'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, 'Item', '{393B862B-F535-4010-B5EF-1D1482809F2A}')
		return ret

	_prop_map_get_ = {
		"ClassPointerRemoved": (3, 2, (3, 0), (), "ClassPointerRemoved", None),
		"Count": (1, 2, (3, 0), (), "Count", None),
		"ListName": (2, 2, (8, 0), (), "ListName", None),
		"SheetHGap": (6, 2, (5, 0), (), "SheetHGap", None),
		"SheetVGap": (7, 2, (5, 0), (), "SheetVGap", None),
	}
	_prop_map_put_ = {
		"ListName": ((2, LCID, 4, 0),()),
		"SheetHGap": ((6, LCID, 4, 0),()),
		"SheetVGap": ((7, LCID, 4, 0),()),
	}
	# Default method for this class is 'Item'
	def __call__(self, Index=defaultNamedNotOptArg):
		'Returns the sheet of the given index in the list'
		ret = self._oleobj_.InvokeTypes(0, LCID, 1, (9, 0), ((3, 1),),Index
			)
		if ret is not None:
			ret = Dispatch(ret, '__call__', '{393B862B-F535-4010-B5EF-1D1482809F2A}')
		return ret

	def __str__(self, *args):
		return str(self.__call__(*args))
	def __int__(self, *args):
		return int(self.__call__(*args))
	def __iter__(self):
		"Return a Python iterator for this object"
		try:
			ob = self._oleobj_.InvokeTypes(-4,LCID,2,(13, 10),())
		except pythoncom.error:
			raise TypeError("This object does not support enumeration")
		return win32com.client.util.Iterator(ob, '{393B862B-F535-4010-B5EF-1D1482809F2A}')
	#This class has Count() property - allow len(ob) to provide this
	def __len__(self):
		return self._ApplyTypes_(*(1, 2, (3, 0), (), "Count", None))
	#This class has a __len__ - this is needed so 'if object:' always returns TRUE.
	def __nonzero__(self):
		return True

from win32com.client import CoClassBaseClass
class DatabaseMaterial(CoClassBaseClass): # A CoClass
	# DatabaseMaterial class
	CLSID = IID('{82CA8D6B-39DD-4036-9EA4-68751525CA41}')
	coclass_sources = [
	]
	coclass_interfaces = [
		IDatabaseMaterial,
	]
	default_interface = IDatabaseMaterial

class DatabaseMaterials(CoClassBaseClass): # A CoClass
	# DatabaseMaterials class
	CLSID = IID('{142B2338-8688-4EE7-B34A-305DBB1BCB7E}')
	coclass_sources = [
	]
	coclass_interfaces = [
		IDatabaseMaterials,
	]
	default_interface = IDatabaseMaterials

class DatabaseSheet(CoClassBaseClass): # A CoClass
	# DatabaseSheet class
	CLSID = IID('{3EF55026-A506-47EE-A86A-C87304F1EE53}')
	coclass_sources = [
	]
	coclass_interfaces = [
		IDatabaseSheet,
	]
	default_interface = IDatabaseSheet

class DatabaseSheets(CoClassBaseClass): # A CoClass
	# DatabaseSheets class
	CLSID = IID('{5F0A5D97-AEF4-4FCE-81E9-FEF202EBDB65}')
	coclass_sources = [
	]
	coclass_interfaces = [
		IDatabaseSheets,
	]
	default_interface = IDatabaseSheets

class DatabaseThickness(CoClassBaseClass): # A CoClass
	# DatabaseThickness class
	CLSID = IID('{9CBA1ED5-B394-4E28-A147-8C52EAB77C28}')
	coclass_sources = [
	]
	coclass_interfaces = [
		IDatabaseThickness,
	]
	default_interface = IDatabaseThickness

class DatabaseThicknesses(CoClassBaseClass): # A CoClass
	# DatabaseThicknesses class
	CLSID = IID('{DACBC1D5-64AA-4648-B06C-4E90289DF069}')
	coclass_sources = [
	]
	coclass_interfaces = [
		IDatabaseThicknesses,
	]
	default_interface = IDatabaseThicknesses

class DatabaseZone(CoClassBaseClass): # A CoClass
	# DatabaseZone class
	CLSID = IID('{C1746D4A-91A8-4B8D-BE95-5B35BB968CD8}')
	coclass_sources = [
	]
	coclass_interfaces = [
		IDatabaseZone,
	]
	default_interface = IDatabaseZone

class DatabaseZones(CoClassBaseClass): # A CoClass
	# DatabaseZones class
	CLSID = IID('{D6908C61-2E6E-4B36-A147-603BF2DCF875}')
	coclass_sources = [
	]
	coclass_interfaces = [
		IDatabaseZones,
	]
	default_interface = IDatabaseZones

class NestData(CoClassBaseClass): # A CoClass
	# NestData Class
	CLSID = IID('{A3E9AAD4-E240-4382-9DDB-5F4EFC9E8FB9}')
	coclass_sources = [
	]
	coclass_interfaces = [
		INestData,
	]
	default_interface = INestData

class NestEngine(CoClassBaseClass): # A CoClass
	# NestEngine Class
	CLSID = IID('{9FC79BC5-07C6-4DCF-A08D-80E076BB2316}')
	coclass_sources = [
	]
	coclass_interfaces = [
		INestEngine,
	]
	default_interface = INestEngine

class NestEvents(CoClassBaseClass): # A CoClass
	# NestEvents Class
	CLSID = IID('{F4C7709A-132D-4182-9414-B5DA62D7F763}')
	coclass_sources = [
		INestEventsEvents,
	]
	default_source = INestEventsEvents
	coclass_interfaces = [
		INestEvents3,
	]
	default_interface = INestEvents3

class NestExtension(CoClassBaseClass): # A CoClass
	# NestExtension Class
	CLSID = IID('{CEBB82E2-828A-4E84-BC64-D05CB076DB04}')
	coclass_sources = [
	]
	coclass_interfaces = [
		INestExtension,
	]
	default_interface = INestExtension

class NestExtensions(CoClassBaseClass): # A CoClass
	# NestExtensions Class
	CLSID = IID('{3061A13F-96CC-45F0-8FD6-F5850D262A55}')
	coclass_sources = [
	]
	coclass_interfaces = [
		INestExtensions,
	]
	default_interface = INestExtensions

class NestInformation(CoClassBaseClass): # A CoClass
	# NestInformation Class
	CLSID = IID('{FCC7E45F-B0AC-4835-99DF-552F5C18014E}')
	coclass_sources = [
	]
	coclass_interfaces = [
		INestInformation,
	]
	default_interface = INestInformation

class NestPart(CoClassBaseClass): # A CoClass
	# NestPart Class
	CLSID = IID('{485EF309-87A4-41C5-91CC-C9ECB28BF7B5}')
	coclass_sources = [
	]
	coclass_interfaces = [
		INestPart,
	]
	default_interface = INestPart

class NestPartInstance(CoClassBaseClass): # A CoClass
	# NestPartInstance Class
	CLSID = IID('{1287E979-83A6-4C8E-90B2-DB71CA4C1F37}')
	coclass_sources = [
	]
	coclass_interfaces = [
		INestPartInstance,
	]
	default_interface = INestPartInstance

class NestPartInstances(CoClassBaseClass): # A CoClass
	# NestPartInstances Class
	CLSID = IID('{4BCC51A8-6934-4B04-BE49-E105CE847FA8}')
	coclass_sources = [
	]
	coclass_interfaces = [
		INestPartInstances,
	]
	default_interface = INestPartInstances

class NestParts(CoClassBaseClass): # A CoClass
	# NestParts Class
	CLSID = IID('{12FFBF81-08E5-4038-A2CD-C952A262C7FD}')
	coclass_sources = [
	]
	coclass_interfaces = [
		INestParts,
	]
	default_interface = INestParts

class NestSheet(CoClassBaseClass): # A CoClass
	# NestSheet Class
	CLSID = IID('{00406E2C-CFE4-4A81-A05E-7445826669B5}')
	coclass_sources = [
	]
	coclass_interfaces = [
		INestSheet,
	]
	default_interface = INestSheet

class NestSheets(CoClassBaseClass): # A CoClass
	# NestSheets Class
	CLSID = IID('{ACDEA351-A51F-4553-821E-B51EC78FC231}')
	coclass_sources = [
	]
	coclass_interfaces = [
		INestSheets,
	]
	default_interface = INestSheets

# This CoClass is known by the name 'AcamNest.Nesting.1'
class Nesting(CoClassBaseClass): # A CoClass
	# Nesting Class
	CLSID = IID('{57250022-AD47-4205-AA0D-9F8039C315B3}')
	coclass_sources = [
	]
	coclass_interfaces = [
		INesting,
	]
	default_interface = INesting

class NestingExtension(CoClassBaseClass): # A CoClass
	# NestExtension Class
	CLSID = IID('{C575F813-38F0-44D4-8D08-227D2794A94F}')
	coclass_sources = [
		INestingExtensionEvents,
	]
	default_source = INestingExtensionEvents
	coclass_interfaces = [
		INestingExtension3,
	]
	default_interface = INestingExtension3

class Nestlist(CoClassBaseClass): # A CoClass
	# NestList Class
	CLSID = IID('{A027C40B-1156-4F95-B126-455E37FEA178}')
	coclass_sources = [
	]
	coclass_interfaces = [
		INestList,
	]
	default_interface = INestList

class SheetDBElem(CoClassBaseClass): # A CoClass
	# SheetDBElem Class
	CLSID = IID('{308D5B14-E22B-4963-8814-F665C10E9A13}')
	coclass_sources = [
	]
	coclass_interfaces = [
		ISheetDBElem,
	]
	default_interface = ISheetDBElem

class SheetDBase(CoClassBaseClass): # A CoClass
	# SheetDBase Class
	CLSID = IID('{0D12AADE-D65D-47B4-B924-FC1099CF9207}')
	coclass_sources = [
	]
	coclass_interfaces = [
		ISheetDBase,
	]
	default_interface = ISheetDBase

class SheetDatabase(CoClassBaseClass): # A CoClass
	# SheetDatabase class
	CLSID = IID('{1C2252AB-0AED-4650-A92C-F5354919A8AE}')
	coclass_sources = [
	]
	coclass_interfaces = [
		ISheetDatabase,
	]
	default_interface = ISheetDatabase

class SheetList(CoClassBaseClass): # A CoClass
	# SheetList Class
	CLSID = IID('{426370B5-A456-4270-BB81-725FAB9884C7}')
	coclass_sources = [
	]
	coclass_interfaces = [
		ISheetList,
	]
	default_interface = ISheetList

IDatabaseMaterial_vtables_dispatch_ = 1
IDatabaseMaterial_vtables_ = [
	(( 'Id' , 'pVal' , ), 0, (0, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 0 , )),
	(( 'Name' , 'pVal' , ), 1, (1, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'Name' , 'pVal' , ), 1, (1, (), [ (8, 1, None, None) , ], 1 , 4 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'Store' , 'pRetCode' , ), 2, (2, (), [ (16387, 10, None, None) , ], 1 , 1 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'Save' , 'pRetCode' , ), 3, (3, (), [ (16387, 10, None, None) , ], 1 , 1 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
	(( 'Delete' , ), 4, (4, (), [ ], 1 , 1 , 4 , 0 , 96 , (3, 0, None, None) , 0 , )),
	(( 'Thicknesses' , 'pVal' , ), 5, (5, (), [ (16393, 10, None, "IID('{A09823E9-8D42-42A1-B8DF-A2D9342DAFB1}')") , ], 1 , 2 , 4 , 0 , 104 , (3, 0, None, None) , 0 , )),
	(( 'Clashes' , 'Other' , 'pResult' , ), 6, (6, (), [ (9, 1, None, "IID('{26947A4F-EE56-4834-A341-A8166EA72D77}')") , 
			 (16387, 10, None, None) , ], 1 , 1 , 4 , 0 , 112 , (3, 0, None, None) , 0 , )),
	(( 'NewThickness' , 'pVal' , ), 7, (7, (), [ (16393, 10, None, "IID('{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}')") , ], 1 , 1 , 4 , 0 , 120 , (3, 0, None, None) , 0 , )),
	(( 'Sheets' , 'pVal' , ), 8, (8, (), [ (16393, 10, None, "IID('{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}')") , ], 1 , 2 , 4 , 0 , 128 , (3, 0, None, None) , 0 , )),
	(( 'WholeSheets' , 'pVal' , ), 9, (9, (), [ (16393, 10, None, "IID('{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}')") , ], 1 , 2 , 4 , 0 , 136 , (3, 0, None, None) , 0 , )),
	(( 'Offcuts' , 'pVal' , ), 10, (10, (), [ (16393, 10, None, "IID('{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}')") , ], 1 , 2 , 4 , 0 , 144 , (3, 0, None, None) , 0 , )),
	(( 'FindThickness' , 'Thickness' , 'Units' , 'pVal' , ), 11, (11, (), [ 
			 (5, 1, None, None) , (3, 1, None, None) , (16393, 10, None, "IID('{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}')") , ], 1 , 1 , 4 , 0 , 152 , (3, 0, None, None) , 0 , )),
	(( 'GUIPosition' , 'pVal' , ), 12, (12, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 160 , (3, 0, None, None) , 0 , )),
	(( 'GUIPosition' , 'pVal' , ), 12, (12, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 168 , (3, 0, None, None) , 0 , )),
]

IDatabaseMaterials_vtables_dispatch_ = 1
IDatabaseMaterials_vtables_ = [
	(( '_NewEnum' , 'pVal' , ), -4, (-4, (), [ (16397, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 1 , )),
	(( 'Item' , 'Index' , 'pVal' , ), 0, (0, (), [ (3, 1, None, None) , 
			 (16393, 10, None, "IID('{26947A4F-EE56-4834-A341-A8166EA72D77}')") , ], 1 , 1 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'Count' , 'pVal' , ), 1, (1, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'Add' , 'dbMaterial' , ), 2, (2, (), [ (9, 1, None, "IID('{26947A4F-EE56-4834-A341-A8166EA72D77}')") , ], 1 , 1 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'Remove' , 'dbMaterial' , ), 3, (3, (), [ (9, 1, None, "IID('{26947A4F-EE56-4834-A341-A8166EA72D77}')") , ], 1 , 1 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
]

IDatabaseSheet_vtables_dispatch_ = 1
IDatabaseSheet_vtables_ = [
	(( 'Id' , 'pVal' , ), 0, (0, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 0 , )),
	(( 'Material' , 'pVal' , ), 1, (1, (), [ (16393, 10, None, "IID('{26947A4F-EE56-4834-A341-A8166EA72D77}')") , ], 1 , 2 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'Thickness' , 'pVal' , ), 2, (2, (), [ (16393, 10, None, "IID('{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}')") , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'IsOffcut' , 'pVal' , ), 3, (3, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'Width' , 'pVal' , ), 4, (4, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
	(( 'Width' , 'pVal' , ), 4, (4, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 96 , (3, 0, None, None) , 0 , )),
	(( 'Height' , 'pVal' , ), 5, (5, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 104 , (3, 0, None, None) , 0 , )),
	(( 'Height' , 'pVal' , ), 5, (5, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 112 , (3, 0, None, None) , 0 , )),
	(( 'LengthUnits' , 'pVal' , ), 6, (6, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 120 , (3, 0, None, None) , 0 , )),
	(( 'LengthUnits' , 'pVal' , ), 6, (6, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 128 , (3, 0, None, None) , 0 , )),
	(( 'Shape' , 'pVal' , ), 7, (7, (), [ (16393, 10, None, "IID('{1A172592-4565-11D2-9866-00104B4AF281}')") , ], 1 , 2 , 4 , 0 , 136 , (3, 0, None, None) , 0 , )),
	(( 'Shape' , 'pVal' , ), 7, (7, (), [ (9, 1, None, "IID('{1A172592-4565-11D2-9866-00104B4AF281}')") , ], 1 , 4 , 4 , 0 , 144 , (3, 0, None, None) , 0 , )),
	(( 'GrainDirection' , 'pVal' , ), 8, (8, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 152 , (3, 0, None, None) , 0 , )),
	(( 'GrainDirection' , 'pVal' , ), 8, (8, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 160 , (3, 0, None, None) , 0 , )),
	(( 'UserID' , 'pVal' , ), 9, (9, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 168 , (3, 0, None, None) , 0 , )),
	(( 'UserID' , 'pVal' , ), 9, (9, (), [ (8, 1, None, None) , ], 1 , 4 , 4 , 0 , 176 , (3, 0, None, None) , 0 , )),
	(( 'Cost' , 'pVal' , ), 10, (10, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 184 , (3, 0, None, None) , 0 , )),
	(( 'Cost' , 'pVal' , ), 10, (10, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 192 , (3, 0, None, None) , 0 , )),
	(( 'Quantity' , 'pVal' , ), 11, (11, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 200 , (3, 0, None, None) , 0 , )),
	(( 'Quantity' , 'pVal' , ), 11, (11, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 208 , (3, 0, None, None) , 0 , )),
	(( 'PreviewFilename' , ), 12, (12, (), [ (8, 1, None, None) , ], 1 , 4 , 4 , 0 , 216 , (3, 0, None, None) , 0 , )),
	(( 'GetPreviewImage' , 'Width' , 'Height' , 'imageHandle' , ), 13, (13, (), [ 
			 (3, 1, None, None) , (3, 1, None, None) , (16387, 10, None, None) , ], 1 , 1 , 4 , 0 , 224 , (3, 0, None, None) , 0 , )),
	(( 'Store' , 'pRetCode' , ), 14, (14, (), [ (16387, 10, None, None) , ], 1 , 1 , 4 , 0 , 232 , (3, 0, None, None) , 0 , )),
	(( 'Save' , 'pRetCode' , ), 15, (15, (), [ (16387, 10, None, None) , ], 1 , 1 , 4 , 0 , 240 , (3, 0, None, None) , 0 , )),
	(( 'Delete' , ), 16, (16, (), [ ], 1 , 1 , 4 , 0 , 248 , (3, 0, None, None) , 0 , )),
	(( 'Zones' , 'pVal' , ), 17, (17, (), [ (16393, 10, None, "IID('{07D9A612-7B31-4B54-94BF-2E947A15A8DC}')") , ], 1 , 2 , 4 , 0 , 256 , (3, 0, None, None) , 0 , )),
	(( 'NewZone' , 'ZonePaths' , 'pVal' , ), 18, (18, (), [ (9, 1, None, "IID('{AFA20680-8305-11D2-98D1-00104B4AF281}')") , 
			 (16393, 10, None, "IID('{97F97832-6E45-4C52-91EA-9F23CC038F29}')") , ], 1 , 1 , 4 , 0 , 264 , (3, 0, None, None) , 0 , )),
	(( 'ClearPreviewImage' , ), 19, (19, (), [ ], 1 , 1 , 4 , 0 , 272 , (3, 0, None, None) , 0 , )),
	(( 'Name' , 'pVal' , ), 20, (20, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 280 , (3, 0, None, None) , 0 , )),
	(( 'Name' , 'pVal' , ), 20, (20, (), [ (8, 1, None, None) , ], 1 , 4 , 4 , 0 , 288 , (3, 0, None, None) , 0 , )),
	(( 'InheritCost' , 'pVal' , ), 21, (21, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 296 , (3, 0, None, None) , 0 , )),
	(( 'InheritCost' , 'pVal' , ), 21, (21, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 304 , (3, 0, None, None) , 0 , )),
	(( 'NumReserved' , 'pVal' , ), 22, (22, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 312 , (3, 0, None, None) , 0 , )),
	(( 'NumReserved' , 'pVal' , ), 22, (22, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 320 , (3, 0, None, None) , 0 , )),
	(( 'GUIPosition' , 'pVal' , ), 23, (23, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 328 , (3, 0, None, None) , 0 , )),
	(( 'GUIPosition' , 'pVal' , ), 23, (23, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 336 , (3, 0, None, None) , 0 , )),
	(( 'InsertInActiveDrawing' , ), 24, (24, (), [ ], 1 , 1 , 4 , 0 , 344 , (3, 0, None, None) , 0 , )),
	(( 'Rotate' , 'Angle' , ), 25, (25, (), [ (5, 1, None, None) , ], 1 , 1 , 4 , 0 , 352 , (3, 0, None, None) , 0 , )),
	(( 'InsertInActiveDrawingAtPoint' , 'x' , 'y' , 'pVal' , ), 26, (26, (), [ 
			 (5, 1, None, None) , (5, 1, None, None) , (16393, 10, None, "IID('{AFA20680-8305-11D2-98D1-00104B4AF281}')") , ], 1 , 1 , 4 , 0 , 360 , (3, 0, None, None) , 0 , )),
	(( 'UpdateUnitsAndCascadeZones' , 'newVal' , 'pRetCode' , ), 27, (27, (), [ (3, 1, None, None) , 
			 (16387, 10, None, None) , ], 1 , 1 , 4 , 0 , 368 , (3, 0, None, None) , 0 , )),
]

IDatabaseSheets_vtables_dispatch_ = 1
IDatabaseSheets_vtables_ = [
	(( '_NewEnum' , 'pVal' , ), -4, (-4, (), [ (16397, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 1 , )),
	(( 'Item' , 'Index' , 'pVal' , ), 0, (0, (), [ (3, 1, None, None) , 
			 (16393, 10, None, "IID('{B843219A-C9CE-419A-9153-577BF8C9362D}')") , ], 1 , 1 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'Count' , 'pVal' , ), 1, (1, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'Add' , 'dbSheet' , ), 2, (2, (), [ (9, 1, None, "IID('{B843219A-C9CE-419A-9153-577BF8C9362D}')") , ], 1 , 1 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'Remove' , 'dbSheet' , ), 3, (3, (), [ (9, 1, None, "IID('{B843219A-C9CE-419A-9153-577BF8C9362D}')") , ], 1 , 1 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
]

IDatabaseThickness_vtables_dispatch_ = 1
IDatabaseThickness_vtables_ = [
	(( 'Id' , 'pVal' , ), 0, (0, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 0 , )),
	(( 'Material' , 'pVal' , ), 1, (1, (), [ (16393, 10, None, "IID('{26947A4F-EE56-4834-A341-A8166EA72D77}')") , ], 1 , 2 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'Thickness' , 'pVal' , ), 2, (2, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'Thickness' , 'pVal' , ), 2, (2, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'ThicknessUnits' , 'pVal' , ), 3, (3, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
	(( 'ThicknessUnits' , 'pVal' , ), 3, (3, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 96 , (3, 0, None, None) , 0 , )),
	(( 'SetThickness' , 'newThick' , 'newUnits' , ), 4, (4, (), [ (5, 1, None, None) , 
			 (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 104 , (3, 0, None, None) , 0 , )),
	(( 'WeightPerArea' , 'pVal' , ), 5, (5, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 112 , (3, 0, None, None) , 0 , )),
	(( 'WeightPerArea' , 'pVal' , ), 5, (5, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 120 , (3, 0, None, None) , 0 , )),
	(( 'WeightUnits' , 'pVal' , ), 6, (6, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 128 , (3, 0, None, None) , 0 , )),
	(( 'WeightUnits' , 'pVal' , ), 6, (6, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 136 , (3, 0, None, None) , 0 , )),
	(( 'SetWeightPerArea' , 'newWPA' , 'newWeightUnits' , 'newAreaUnits' , ), 7, (7, (), [ 
			 (5, 1, None, None) , (3, 1, None, None) , (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 144 , (3, 0, None, None) , 0 , )),
	(( 'AreaUnits' , 'pVal' , ), 8, (8, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 152 , (3, 0, None, None) , 0 , )),
	(( 'AreaUnits' , 'pVal' , ), 8, (8, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 160 , (3, 0, None, None) , 0 , )),
	(( 'CostPerArea' , 'pVal' , ), 9, (9, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 168 , (3, 0, None, None) , 0 , )),
	(( 'CostPerArea' , 'pVal' , ), 9, (9, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 176 , (3, 0, None, None) , 0 , )),
	(( 'SetCostPerArea' , 'newCost' , 'newUnits' , ), 10, (10, (), [ (5, 1, None, None) , 
			 (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 184 , (3, 0, None, None) , 0 , )),
	(( 'Store' , 'pRetCode' , ), 11, (11, (), [ (16387, 10, None, None) , ], 1 , 1 , 4 , 0 , 192 , (3, 0, None, None) , 0 , )),
	(( 'Save' , 'pRetCode' , ), 12, (12, (), [ (16387, 10, None, None) , ], 1 , 1 , 4 , 0 , 200 , (3, 0, None, None) , 0 , )),
	(( 'Delete' , ), 13, (13, (), [ ], 1 , 1 , 4 , 0 , 208 , (3, 0, None, None) , 0 , )),
	(( 'Clashes' , 'Other' , 'pResult' , ), 14, (14, (), [ (9, 1, None, "IID('{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}')") , 
			 (16387, 10, None, None) , ], 1 , 1 , 4 , 0 , 216 , (3, 0, None, None) , 0 , )),
	(( 'Sheets' , 'pVal' , ), 15, (15, (), [ (16393, 10, None, "IID('{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}')") , ], 1 , 2 , 4 , 0 , 224 , (3, 0, None, None) , 0 , )),
	(( 'WholeSheets' , 'pVal' , ), 16, (16, (), [ (16393, 10, None, "IID('{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}')") , ], 1 , 2 , 4 , 0 , 232 , (3, 0, None, None) , 0 , )),
	(( 'Offcuts' , 'pVal' , ), 17, (17, (), [ (16393, 10, None, "IID('{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}')") , ], 1 , 2 , 4 , 0 , 240 , (3, 0, None, None) , 0 , )),
	(( 'NewSheet' , 'pVal' , ), 18, (18, (), [ (16393, 10, None, "IID('{B843219A-C9CE-419A-9153-577BF8C9362D}')") , ], 1 , 1 , 4 , 0 , 248 , (3, 0, None, None) , 0 , )),
	(( 'NewOffcut' , 'SheetPaths' , 'pVal' , ), 19, (19, (), [ (9, 1, None, "IID('{AFA20680-8305-11D2-98D1-00104B4AF281}')") , 
			 (16393, 10, None, "IID('{B843219A-C9CE-419A-9153-577BF8C9362D}')") , ], 1 , 1 , 4 , 0 , 256 , (3, 0, None, None) , 0 , )),
	(( 'CostPerWeight' , 'pVal' , ), 20, (20, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 264 , (3, 0, None, None) , 0 , )),
	(( 'CostPerWeight' , 'pVal' , ), 20, (20, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 272 , (3, 0, None, None) , 0 , )),
	(( 'CostIsByWeight' , 'pVal' , ), 21, (21, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 280 , (3, 0, None, None) , 0 , )),
	(( 'CostIsByWeight' , 'pVal' , ), 21, (21, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 288 , (3, 0, None, None) , 0 , )),
	(( 'GUIPosition' , 'pVal' , ), 22, (22, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 296 , (3, 0, None, None) , 0 , )),
	(( 'GUIPosition' , 'pVal' , ), 22, (22, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 304 , (3, 0, None, None) , 0 , )),
	(( 'AddSheetAndZones' , 'Paths' , 'pVal' , ), 23, (23, (), [ (9, 1, None, "IID('{AFA20680-8305-11D2-98D1-00104B4AF281}')") , 
			 (16393, 10, None, "IID('{B843219A-C9CE-419A-9153-577BF8C9362D}')") , ], 1 , 1 , 4 , 0 , 312 , (3, 0, None, None) , 0 , )),
	(( 'UpdateUnitsAndCascadeSheets' , 'newVal' , 'pRetCode' , ), 24, (24, (), [ (3, 1, None, None) , 
			 (16387, 10, None, None) , ], 1 , 1 , 4 , 0 , 320 , (3, 0, None, None) , 0 , )),
]

IDatabaseThicknesses_vtables_dispatch_ = 1
IDatabaseThicknesses_vtables_ = [
	(( '_NewEnum' , 'pVal' , ), -4, (-4, (), [ (16397, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 1 , )),
	(( 'Item' , 'Index' , 'pVal' , ), 0, (0, (), [ (3, 1, None, None) , 
			 (16393, 10, None, "IID('{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}')") , ], 1 , 1 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'Count' , 'pVal' , ), 1, (1, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'Add' , 'dbThickness' , ), 2, (2, (), [ (9, 1, None, "IID('{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}')") , ], 1 , 1 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'Remove' , 'dbThickness' , ), 3, (3, (), [ (9, 1, None, "IID('{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}')") , ], 1 , 1 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
]

IDatabaseZone_vtables_dispatch_ = 1
IDatabaseZone_vtables_ = [
	(( 'Id' , 'pVal' , ), 0, (0, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 0 , )),
	(( 'Sheet' , 'pVal' , ), 1, (1, (), [ (16393, 10, None, "IID('{B843219A-C9CE-419A-9153-577BF8C9362D}')") , ], 1 , 2 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'ZoneType' , 'pVal' , ), 2, (2, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'ZoneType' , 'pVal' , ), 2, (2, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'LengthUnits' , 'pVal' , ), 3, (3, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
	(( 'LengthUnits' , 'pVal' , ), 3, (3, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 96 , (3, 0, None, None) , 0 , )),
	(( 'Shape' , 'pVal' , ), 4, (4, (), [ (16393, 10, None, "IID('{1A172592-4565-11D2-9866-00104B4AF281}')") , ], 1 , 2 , 4 , 0 , 104 , (3, 0, None, None) , 0 , )),
	(( 'Shape' , 'pVal' , ), 4, (4, (), [ (9, 1, None, "IID('{1A172592-4565-11D2-9866-00104B4AF281}')") , ], 1 , 4 , 4 , 0 , 112 , (3, 0, None, None) , 0 , )),
	(( 'Store' , 'pRetCode' , ), 5, (5, (), [ (16387, 10, None, None) , ], 1 , 1 , 4 , 0 , 120 , (3, 0, None, None) , 0 , )),
	(( 'Save' , 'pRetCode' , ), 6, (6, (), [ (16387, 10, None, None) , ], 1 , 1 , 4 , 0 , 128 , (3, 0, None, None) , 0 , )),
	(( 'Delete' , ), 7, (7, (), [ ], 1 , 1 , 4 , 0 , 136 , (3, 0, None, None) , 0 , )),
]

IDatabaseZones_vtables_dispatch_ = 1
IDatabaseZones_vtables_ = [
	(( '_NewEnum' , 'pVal' , ), -4, (-4, (), [ (16397, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 1 , )),
	(( 'Item' , 'Index' , 'pVal' , ), 0, (0, (), [ (3, 1, None, None) , 
			 (16393, 10, None, "IID('{97F97832-6E45-4C52-91EA-9F23CC038F29}')") , ], 1 , 1 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'Count' , 'pVal' , ), 1, (1, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'Add' , 'dbSheet' , ), 2, (2, (), [ (9, 1, None, "IID('{97F97832-6E45-4C52-91EA-9F23CC038F29}')") , ], 1 , 1 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'Remove' , 'dbSheet' , ), 3, (3, (), [ (9, 1, None, "IID('{97F97832-6E45-4C52-91EA-9F23CC038F29}')") , ], 1 , 1 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
]

INestData_vtables_dispatch_ = 1
INestData_vtables_ = [
	(( 'Resolution' , 'pVal' , ), 1, (1, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 0 , )),
	(( 'Resolution' , 'pVal' , ), 1, (1, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'Gap' , 'pVal' , ), 2, (2, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'Gap' , 'pVal' , ), 2, (2, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'LeadGap' , 'pVal' , ), 3, (3, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
	(( 'LeadGap' , 'pVal' , ), 3, (3, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 96 , (3, 0, None, None) , 0 , )),
	(( 'Subroutines' , 'pVal' , ), 4, (4, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 104 , (3, 0, None, None) , 0 , )),
	(( 'Subroutines' , 'pVal' , ), 4, (4, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 112 , (3, 0, None, None) , 0 , )),
	(( 'Direction' , 'pVal' , ), 5, (5, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 120 , (3, 0, None, None) , 0 , )),
	(( 'Direction' , 'pVal' , ), 5, (5, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 128 , (3, 0, None, None) , 0 , )),
	(( 'RepeatFirstRowOrColumn' , 'pVal' , ), 6, (6, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 136 , (3, 0, None, None) , 0 , )),
	(( 'RepeatFirstRowOrColumn' , 'pVal' , ), 6, (6, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 144 , (3, 0, None, None) , 0 , )),
	(( 'ToolPaths' , 'pVal' , ), 7, (7, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 152 , (3, 0, None, None) , 0 , )),
	(( 'AddSheet' , 'Geometry' , 'MaterialName' , 'Thickness' , 'Number' , 
			 ), 4097, (4097, (), [ (9, 1, None, None) , (8, 1, None, None) , (5, 1, None, None) , (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 160 , (3, 0, None, None) , 0 , )),
	(( 'DoNest' , ), 4098, (4098, (), [ ], 1 , 1 , 4 , 0 , 168 , (3, 0, None, None) , 0 , )),
	(( 'Init' , 'nestptr' , 'list' , ), 5000, (5000, (), [ (9, 1, None, "IID('{31DEE408-CC4F-44A8-87AC-C1C8770CA018}')") , 
			 (9, 1, None, "IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')") , ], 1 , 1 , 4 , 0 , 176 , (3, 0, None, None) , 1 , )),
	(( 'EdgeGap' , 'pVal' , ), 5001, (5001, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 184 , (3, 0, None, None) , 0 , )),
	(( 'EdgeGap' , 'pVal' , ), 5001, (5001, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 192 , (3, 0, None, None) , 0 , )),
	(( 'MinimiseToolChanges' , 'pVal' , ), 5002, (5002, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 200 , (3, 0, None, None) , 0 , )),
	(( 'MinimiseToolChanges' , 'pVal' , ), 5002, (5002, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 208 , (3, 0, None, None) , 0 , )),
	(( 'SheetHGap' , 'pVal' , ), 5003, (5003, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 216 , (3, 0, None, None) , 0 , )),
	(( 'SheetHGap' , 'pVal' , ), 5003, (5003, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 224 , (3, 0, None, None) , 0 , )),
	(( 'SheetVGap' , 'pVal' , ), 5004, (5004, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 232 , (3, 0, None, None) , 0 , )),
	(( 'SheetVGap' , 'pVal' , ), 5004, (5004, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 240 , (3, 0, None, None) , 0 , )),
	(( 'MergeTools' , 'pVal' , ), 5005, (5005, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 248 , (3, 0, None, None) , 0 , )),
	(( 'MergeTools' , 'pVal' , ), 5005, (5005, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 256 , (3, 0, None, None) , 0 , )),
	(( 'OrderByPart' , 'pVal' , ), 5006, (5006, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 264 , (3, 0, None, None) , 0 , )),
	(( 'OrderByPart' , 'pVal' , ), 5006, (5006, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 272 , (3, 0, None, None) , 0 , )),
	(( 'OrderInnerFirst' , 'pVal' , ), 5007, (5007, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 280 , (3, 0, None, None) , 0 , )),
	(( 'OrderInnerFirst' , 'pVal' , ), 5007, (5007, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 288 , (3, 0, None, None) , 0 , )),
]

INestEngine_vtables_dispatch_ = 1
INestEngine_vtables_ = [
	(( 'NestPart' , 'Part' , 'target' , 'pVal' , ), 1, (1, (), [ 
			 (13, 1, None, None) , (13, 1, None, None) , (16386, 10, None, None) , ], 1 , 1 , 4 , 0 , 56 , (3, 0, None, None) , 0 , )),
	(( 'ClassPointerRemoved' , 'pVal' , ), 2, (2, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 64 , (3, 0, None, None) , 1 , )),
	(( 'SetEngineParams' , 'SourceList' , ), 3, (3, (), [ (9, 1, None, "IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')") , ], 1 , 1 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'DoNest' , 'Nestlist' , 'SheetList' , 'Drawing' , 'pVal' , 
			 ), 4, (4, (), [ (9, 1, None, "IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')") , (9, 1, None, "IID('{0687113C-A6A0-4D3C-B56F-432DF61A5774}')") , (9, 1, None, None) , (16387, 10, None, None) , ], 1 , 1 , 4 , 0 , 80 , (3, 0, None, None) , 1 , )),
	(( 'PlaceNewSheet' , 'Sheet' , ), 5, (5, (), [ (9, 1, None, "IID('{393B862B-F535-4010-B5EF-1D1482809F2A}')") , ], 1 , 1 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
]

INestEvents3_vtables_dispatch_ = 1
INestEvents3_vtables_ = [
	(( 'ClassPointerRemoved' , 'pVal' , ), 1, (1, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 1 , )),
]

INestExtension_vtables_dispatch_ = 1
INestExtension_vtables_ = [
	(( 'Name' , 'pVal' , ), 1, (1, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 0 , )),
	(( 'Count' , 'pVal' , ), 2, (2, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'Type' , 'pVal' , ), 3, (3, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'Heading' , 'pVal' , ), 4, (4, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'GetText' , 'Id' , 'pVal' , ), 5, (5, (), [ (3, 1, None, None) , 
			 (16392, 10, None, None) , ], 1 , 1 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
	(( 'GetEnabled' , 'Id' , 'pVal' , ), 6, (6, (), [ (3, 1, None, None) , 
			 (16395, 10, None, None) , ], 1 , 1 , 4 , 0 , 96 , (3, 0, None, None) , 0 , )),
	(( 'GetState' , 'Id' , 'pVal' , ), 7, (7, (), [ (3, 1, None, None) , 
			 (16386, 10, None, None) , ], 1 , 1 , 4 , 0 , 104 , (3, 0, None, None) , 0 , )),
	(( 'SetState' , 'Id' , 'State' , ), 8, (8, (), [ (3, 1, None, None) , 
			 (2, 1, None, None) , ], 1 , 1 , 4 , 0 , 112 , (3, 0, None, None) , 0 , )),
	(( 'InitRemoved' , 'Handler' , ), 9, (9, (), [ (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 120 , (3, 0, None, None) , 1 , )),
	(( 'DefaultConfig' , 'pVal' , ), 10, (10, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 128 , (3, 0, None, None) , 64 , )),
	(( 'SaveConfig' , 'pVal' , ), 11, (11, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 136 , (3, 0, None, None) , 0 , )),
	(( 'SetListConfig' , 'Nestlist' , 'ConfigString' , ), 12, (12, (), [ (9, 1, None, "IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')") , 
			 (8, 1, None, None) , ], 1 , 1 , 4 , 0 , 144 , (3, 0, None, None) , 0 , )),
	(( 'SetPartConfig' , 'Part' , 'ConfigString' , ), 13, (13, (), [ (9, 1, None, "IID('{8ACC255D-1758-4296-AE13-FA3DC51E1641}')") , 
			 (8, 1, None, None) , ], 1 , 1 , 4 , 0 , 152 , (3, 0, None, None) , 0 , )),
	(( 'FreeListConfig' , ), 14, (14, (), [ ], 1 , 1 , 4 , 0 , 160 , (3, 0, None, None) , 64 , )),
	(( 'HasUserConfig' , 'pVal' , ), 15, (15, (), [ (16395, 10, None, None) , ], 1 , 1 , 4 , 0 , 168 , (3, 0, None, None) , 64 , )),
	(( 'ShowUserConfigDialog' , ), 16, (16, (), [ ], 1 , 1 , 4 , 0 , 176 , (3, 0, None, None) , 64 , )),
]

INestExtensions_vtables_dispatch_ = 1
INestExtensions_vtables_ = [
	(( '_NewEnum' , 'pVal' , ), -4, (-4, (), [ (16397, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 1 , )),
	(( 'Item' , 'Index' , 'pVal' , ), 0, (0, (), [ (3, 1, None, None) , 
			 (16393, 10, None, "IID('{6EC96D6F-3CA5-4B12-A9A0-3BE960F94DB0}')") , ], 1 , 1 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'Count' , 'pVal' , ), 1, (1, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'InitRemoved' , 'Data' , ), 2, (2, (), [ (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 80 , (3, 0, None, None) , 1 , )),
]

INestInformation_vtables_dispatch_ = 1
INestInformation_vtables_ = [
	(( 'Sheets' , 'pVal' , ), 1, (1, (), [ (16393, 10, None, "IID('{D55B5242-FAEA-4704-8C71-0EB0746BC751}')") , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 0 , )),
	(( 'Parts' , 'pVal' , ), 2, (2, (), [ (16393, 10, None, "IID('{5FFBEE0B-0A71-4255-BEBB-99F138EEFC4D}')") , ], 1 , 2 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'Init' , 'Drawing' , 'nptr' , ), 5000, (5000, (), [ (9, 1, None, None) , 
			 (9, 1, None, "IID('{31DEE408-CC4F-44A8-87AC-C1C8770CA018}')") , ], 1 , 1 , 4 , 0 , 72 , (3, 0, None, None) , 1 , )),
	(( 'Refresh' , ), 5001, (5001, (), [ ], 1 , 1 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'SheetDB' , 'pVal' , ), 5002, (5002, (), [ (16393, 10, None, "IID('{98D8443D-C842-4F05-9D64-BB03AE1A65C6}')") , ], 1 , 2 , 4 , 0 , 88 , (3, 0, None, None) , 64 , )),
]

INestList_vtables_dispatch_ = 1
INestList_vtables_ = [
	(( '_NewEnum' , 'pVal' , ), -4, (-4, (), [ (16397, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 1 , )),
	(( 'Item' , 'Index' , 'pVal' , ), 0, (0, (), [ (3, 1, None, None) , 
			 (16393, 10, None, "IID('{8ACC255D-1758-4296-AE13-FA3DC51E1641}')") , ], 1 , 1 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'FileName' , 'pVal' , ), 1, (1, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'FileName' , 'pVal' , ), 1, (1, (), [ (8, 1, None, None) , ], 1 , 4 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'ListName' , 'pVal' , ), 2, (2, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
	(( 'ListName' , 'pVal' , ), 2, (2, (), [ (8, 1, None, None) , ], 1 , 4 , 4 , 0 , 96 , (3, 0, None, None) , 0 , )),
	(( 'Count' , 'pVal' , ), 3, (3, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 104 , (3, 0, None, None) , 0 , )),
	(( 'Load' , 'FileName' , ), 4, (4, (), [ (8, 1, None, None) , ], 1 , 1 , 4 , 0 , 112 , (3, 0, None, None) , 0 , )),
	(( 'SaveAs' , 'FileName' , ), 5, (5, (), [ (8, 1, None, None) , ], 1 , 1 , 4 , 0 , 120 , (3, 0, None, None) , 0 , )),
	(( 'Save' , ), 6, (6, (), [ ], 1 , 1 , 4 , 0 , 128 , (3, 0, None, None) , 0 , )),
	(( 'ClassPointerRemoved' , 'pVal' , ), 7, (7, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 136 , (3, 0, None, None) , 1 , )),
	(( 'Add' , 'Paths' , 'pVal' , ), 8, (8, (), [ (9, 1, None, None) , 
			 (16393, 10, None, "IID('{8ACC255D-1758-4296-AE13-FA3DC51E1641}')") , ], 1 , 1 , 4 , 0 , 144 , (3, 0, None, None) , 0 , )),
	(( 'EdgeGap' , 'pVal' , ), 9, (9, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 152 , (3, 0, None, None) , 0 , )),
	(( 'EdgeGap' , 'pVal' , ), 9, (9, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 160 , (3, 0, None, None) , 0 , )),
	(( 'LeadInGap' , 'pVal' , ), 10, (10, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 168 , (3, 0, None, None) , 0 , )),
	(( 'LeadInGap' , 'pVal' , ), 10, (10, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 176 , (3, 0, None, None) , 0 , )),
	(( 'PartGap' , 'pVal' , ), 11, (11, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 184 , (3, 0, None, None) , 0 , )),
	(( 'PartGap' , 'pVal' , ), 11, (11, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 192 , (3, 0, None, None) , 0 , )),
	(( 'UseSubroutines' , 'pVal' , ), 12, (12, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 200 , (3, 0, None, None) , 0 , )),
	(( 'UseSubroutines' , 'pVal' , ), 12, (12, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 208 , (3, 0, None, None) , 0 , )),
	(( 'RepeatFirstRow' , 'pVal' , ), 13, (13, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 216 , (3, 0, None, None) , 0 , )),
	(( 'RepeatFirstRow' , 'pVal' , ), 13, (13, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 224 , (3, 0, None, None) , 0 , )),
	(( 'InnerFirst' , 'pVal' , ), 14, (14, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 232 , (3, 0, None, None) , 0 , )),
	(( 'InnerFirst' , 'pVal' , ), 14, (14, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 240 , (3, 0, None, None) , 0 , )),
	(( 'MinimiseToolChanges' , 'pVal' , ), 15, (15, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 248 , (3, 0, None, None) , 0 , )),
	(( 'MinimiseToolChanges' , 'pVal' , ), 15, (15, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 256 , (3, 0, None, None) , 0 , )),
	(( 'OrderByPart' , 'pVal' , ), 16, (16, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 264 , (3, 0, None, None) , 0 , )),
	(( 'OrderByPart' , 'pVal' , ), 16, (16, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 272 , (3, 0, None, None) , 0 , )),
	(( 'NestSide' , 'pVal' , ), 17, (17, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 280 , (3, 0, None, None) , 0 , )),
	(( 'NestSide' , 'pVal' , ), 17, (17, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 288 , (3, 0, None, None) , 0 , )),
	(( 'PathType' , 'pVal' , ), 20, (20, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 296 , (3, 0, None, None) , 0 , )),
	(( 'PathType' , 'pVal' , ), 20, (20, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 304 , (3, 0, None, None) , 0 , )),
	(( 'Modified' , 'pVal' , ), 21, (21, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 312 , (3, 0, None, None) , 0 , )),
	(( 'AddFile' , 'FileName' , 'pVal' , ), 22, (22, (), [ (8, 1, None, None) , 
			 (16393, 10, None, "IID('{8ACC255D-1758-4296-AE13-FA3DC51E1641}')") , ], 1 , 1 , 4 , 0 , 320 , (3, 0, None, None) , 0 , )),
	(( 'FromScreen' , 'pVal' , ), 23, (23, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 328 , (3, 0, None, None) , 0 , )),
	(( 'FromScreen' , 'pVal' , ), 23, (23, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 336 , (3, 0, None, None) , 0 , )),
	(( 'DeletePart' , 'Part' , ), 24, (24, (), [ (9, 1, None, "IID('{8ACC255D-1758-4296-AE13-FA3DC51E1641}')") , ], 1 , 1 , 4 , 0 , 344 , (3, 0, None, None) , 0 , )),
	(( 'OrderParts' , ), 25, (25, (), [ ], 1 , 1 , 4 , 0 , 352 , (3, 0, None, None) , 0 , )),
	(( 'CopyTemporary' , 'pVal' , ), 26, (26, (), [ (16393, 10, None, "IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')") , ], 1 , 1 , 4 , 0 , 360 , (3, 0, None, None) , 0 , )),
	(( 'Resolution' , 'pVal' , ), 27, (27, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 368 , (3, 0, None, None) , 0 , )),
	(( 'Resolution' , 'pVal' , ), 27, (27, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 376 , (3, 0, None, None) , 0 , )),
	(( 'NestingMethod' , 'pVal' , ), 28, (28, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 384 , (3, 0, None, None) , 0 , )),
	(( 'NestingMethod' , 'pVal' , ), 28, (28, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 392 , (3, 0, None, None) , 0 , )),
	(( 'Temporary' , 'pVal' , ), 29, (29, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 400 , (3, 0, None, None) , 0 , )),
	(( 'SetExtensionConfig' , 'ExtensionName' , 'ConfigString' , ), 30, (30, (), [ (8, 1, None, None) , 
			 (8, 1, None, None) , ], 1 , 1 , 4 , 0 , 408 , (3, 0, None, None) , 64 , )),
	(( 'GetExtensionConfig' , 'ExtensionName' , 'ConfigString' , ), 31, (31, (), [ (8, 1, None, None) , 
			 (16392, 10, None, None) , ], 1 , 1 , 4 , 0 , 416 , (3, 0, None, None) , 0 , )),
	(( 'ConfigureExtensions' , ), 32, (32, (), [ ], 1 , 1 , 4 , 0 , 424 , (3, 0, None, None) , 0 , )),
	(( 'UpdateOrder' , ), 33, (33, (), [ ], 1 , 1 , 4 , 0 , 432 , (3, 0, None, None) , 0 , )),
	(( 'PreserveSheetEdge' , 'pVal' , ), 34, (34, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 440 , (3, 0, None, None) , 0 , )),
	(( 'PreserveSheetEdge' , 'pVal' , ), 34, (34, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 448 , (3, 0, None, None) , 0 , )),
	(( 'CustomAngle' , 'pVal' , ), 35, (35, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 456 , (3, 0, None, None) , 0 , )),
	(( 'CustomAngle' , 'pVal' , ), 35, (35, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 464 , (3, 0, None, None) , 0 , )),
	(( 'CutWidth' , 'pVal' , ), 36, (36, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 472 , (3, 0, None, None) , 0 , )),
	(( 'CutWidth' , 'pVal' , ), 36, (36, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 480 , (3, 0, None, None) , 0 , )),
	(( 'CutDirection' , 'pVal' , ), 37, (37, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 488 , (3, 0, None, None) , 0 , )),
	(( 'CutDirection' , 'pVal' , ), 37, (37, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 496 , (3, 0, None, None) , 0 , )),
	(( 'StoreTemporary' , ), 38, (38, (), [ ], 1 , 1 , 4 , 0 , 504 , (3, 0, None, None) , 0 , )),
	(( 'OptimiseForCuts' , 'pVal' , ), 39, (39, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 512 , (3, 0, None, None) , 0 , )),
	(( 'OptimiseForCuts' , 'pVal' , ), 39, (39, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 520 , (3, 0, None, None) , 0 , )),
	(( 'OptimiseLevel' , 'pVal' , ), 40, (40, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 528 , (3, 0, None, None) , 0 , )),
	(( 'OptimiseLevel' , 'pVal' , ), 40, (40, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 536 , (3, 0, None, None) , 0 , )),
	(( 'BalanceAcrossSheets' , 'pVal' , ), 41, (41, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 544 , (3, 0, None, None) , 0 , )),
	(( 'BalanceAcrossSheets' , 'pVal' , ), 41, (41, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 552 , (3, 0, None, None) , 0 , )),
	(( 'AddCopy' , 'Part' , 'pVal' , ), 42, (42, (), [ (9, 1, None, "IID('{8ACC255D-1758-4296-AE13-FA3DC51E1641}')") , 
			 (16393, 10, None, "IID('{8ACC255D-1758-4296-AE13-FA3DC51E1641}')") , ], 1 , 1 , 4 , 0 , 560 , (3, 0, None, None) , 0 , )),
	(( 'CopyParamsFrom' , 'OtherList' , ), 43, (43, (), [ (9, 1, None, "IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')") , ], 1 , 1 , 4 , 0 , 568 , (3, 0, None, None) , 0 , )),
	(( 'AssistedNest' , 'pVal' , ), 44, (44, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 576 , (3, 0, None, None) , 0 , )),
	(( 'AssistedNest' , 'pVal' , ), 44, (44, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 584 , (3, 0, None, None) , 0 , )),
	(( 'FreeExtensions' , ), 45, (45, (), [ ], 1 , 1 , 4 , 0 , 592 , (3, 0, None, None) , 64 , )),
	(( 'WholeNestLevel' , 'pVal' , ), 46, (46, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 600 , (3, 0, None, None) , 0 , )),
	(( 'WholeNestLevel' , 'pVal' , ), 46, (46, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 608 , (3, 0, None, None) , 0 , )),
	(( 'SelectBestSheet' , 'pVal' , ), 47, (47, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 616 , (3, 0, None, None) , 0 , )),
	(( 'SelectBestSheet' , 'pVal' , ), 47, (47, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 624 , (3, 0, None, None) , 0 , )),
	(( 'TimePerSheet' , 'pVal' , ), 48, (48, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 632 , (3, 0, None, None) , 0 , )),
	(( 'TimePerSheet' , 'pVal' , ), 48, (48, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 640 , (3, 0, None, None) , 0 , )),
	(( 'FromGui' , 'pVal' , ), 49, (49, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 648 , (3, 0, None, None) , 1 , )),
	(( 'FromGui' , 'pVal' , ), 49, (49, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 656 , (3, 0, None, None) , 1 , )),
	(( 'MinimiseSheetPatterns' , 'pVal' , ), 50, (50, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 664 , (3, 0, None, None) , 0 , )),
	(( 'MinimiseSheetPatterns' , 'pVal' , ), 50, (50, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 672 , (3, 0, None, None) , 0 , )),
	(( 'PreventApertureNest' , 'pVal' , ), 51, (51, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 680 , (3, 0, None, None) , 0 , )),
	(( 'PreventApertureNest' , 'pVal' , ), 51, (51, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 688 , (3, 0, None, None) , 0 , )),
	(( 'SuppressDialogs' , 'pVal' , ), 52, (52, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 696 , (3, 0, None, None) , 64 , )),
	(( 'SuppressDialogs' , 'pVal' , ), 52, (52, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 704 , (3, 0, None, None) , 64 , )),
	(( 'UseNameIdentifiers' , 'pVal' , ), 53, (53, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 712 , (3, 0, None, None) , 0 , )),
	(( 'UseNameIdentifiers' , 'pVal' , ), 53, (53, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 720 , (3, 0, None, None) , 0 , )),
	(( 'SaveConfigAsDefault' , ), 54, (54, (), [ ], 1 , 1 , 4 , 0 , 728 , (3, 0, None, None) , 0 , )),
	(( 'SheetList' , 'SheetList' , ), 55, (55, (), [ (16393, 10, None, "IID('{0687113C-A6A0-4D3C-B56F-432DF61A5774}')") , ], 1 , 2 , 4 , 0 , 736 , (3, 0, None, None) , 1 , )),
	(( 'SheetList' , 'SheetList' , ), 55, (55, (), [ (9, 1, None, "IID('{0687113C-A6A0-4D3C-B56F-432DF61A5774}')") , ], 1 , 4 , 4 , 0 , 744 , (3, 0, None, None) , 1 , )),
	(( 'SheetOrder' , 'SheetOrder' , ), 56, (56, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 752 , (3, 0, None, None) , 0 , )),
	(( 'SheetOrder' , 'SheetOrder' , ), 56, (56, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 760 , (3, 0, None, None) , 0 , )),
	(( 'TotalTime' , 'pVal' , ), 57, (57, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 768 , (3, 0, None, None) , 0 , )),
	(( 'TotalTime' , 'pVal' , ), 57, (57, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 776 , (3, 0, None, None) , 0 , )),
	(( 'OffcutPreference' , 'pVal' , ), 58, (58, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 784 , (3, 0, None, None) , 0 , )),
	(( 'OffcutPreference' , 'pVal' , ), 58, (58, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 792 , (3, 0, None, None) , 0 , )),
	(( 'LoadSettings' , 'FileName' , ), 59, (59, (), [ (8, 1, None, None) , ], 1 , 1 , 4 , 0 , 800 , (3, 0, None, None) , 0 , )),
	(( 'SaveSettings' , 'FileName' , ), 60, (60, (), [ (8, 1, None, None) , ], 1 , 1 , 4 , 0 , 808 , (3, 0, None, None) , 0 , )),
	(( 'EvenlySpacedParts' , 'pVal' , ), 61, (61, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 816 , (3, 0, None, None) , 0 , )),
	(( 'EvenlySpacedParts' , 'pVal' , ), 61, (61, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 824 , (3, 0, None, None) , 0 , )),
	(( 'OptimizedToolPathOverlap' , 'pVal' , ), 62, (62, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 832 , (3, 0, None, None) , 0 , )),
	(( 'OptimizedToolPathOverlap' , 'pVal' , ), 62, (62, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 840 , (3, 0, None, None) , 0 , )),
	(( 'AllowSolidParts' , 'pVal' , ), 63, (63, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 848 , (3, 0, None, None) , 0 , )),
	(( 'AllowSolidParts' , 'pVal' , ), 63, (63, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 856 , (3, 0, None, None) , 0 , )),
	(( 'StrictPriorities' , 'pVal' , ), 64, (64, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 864 , (3, 0, None, None) , 0 , )),
	(( 'StrictPriorities' , 'pVal' , ), 64, (64, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 872 , (3, 0, None, None) , 0 , )),
	(( 'SetSheetAlignment' , 'SheetAlignment' , 'ZLevel' , ), 65, (65, (), [ (3, 1, None, None) , 
			 (5, 1, None, None) , ], 1 , 1 , 4 , 0 , 880 , (3, 0, None, None) , 0 , )),
	(( 'GetSheetAlignment' , 'SheetAlignment' , 'ZLevel' , ), 66, (66, (), [ (16387, 2, None, None) , 
			 (16389, 10, None, None) , ], 1 , 1 , 4 , 0 , 888 , (3, 0, None, None) , 0 , )),
	(( 'SingleIdenticalSheetInstance' , 'pVal' , ), 67, (67, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 896 , (3, 0, None, None) , 0 , )),
	(( 'SingleIdenticalSheetInstance' , 'pVal' , ), 67, (67, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 904 , (3, 0, None, None) , 0 , )),
]

INestPart_vtables_dispatch_ = 1
INestPart_vtables_ = [
	(( 'Paths' , 'pVal' , ), 1, (1, (), [ (16393, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 0 , )),
	(( 'Paths' , 'pVal' , ), 1, (1, (), [ (9, 1, None, None) , ], 1 , 4 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'CheckPaths' , 'pVal' , ), 2, (2, (), [ (16393, 10, None, None) , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 64 , )),
	(( 'CheckPaths' , 'pVal' , ), 2, (2, (), [ (9, 1, None, None) , ], 1 , 4 , 4 , 0 , 80 , (3, 0, None, None) , 64 , )),
	(( 'Attribute' , 'key' , 'pVal' , ), 3, (3, (), [ (8, 1, None, None) , 
			 (16396, 10, None, None) , ], 1 , 2 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
	(( 'Attribute' , 'key' , 'pVal' , ), 3, (3, (), [ (8, 1, None, None) , 
			 (12, 1, None, None) , ], 1 , 4 , 4 , 0 , 96 , (3, 0, None, None) , 0 , )),
	(( 'ClassPointerRemoved' , 'pVal' , ), 5, (5, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 104 , (3, 0, None, None) , 1 , )),
	(( 'Name' , 'pVal' , ), 6, (6, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 112 , (3, 0, None, None) , 0 , )),
	(( 'Name' , 'pVal' , ), 6, (6, (), [ (8, 1, None, None) , ], 1 , 4 , 4 , 0 , 120 , (3, 0, None, None) , 0 , )),
	(( 'Required' , 'pVal' , ), 8, (8, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 128 , (3, 0, None, None) , 0 , )),
	(( 'Required' , 'pVal' , ), 8, (8, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 136 , (3, 0, None, None) , 0 , )),
	(( 'Priority' , 'pVal' , ), 9, (9, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 144 , (3, 0, None, None) , 0 , )),
	(( 'Priority' , 'pVal' , ), 9, (9, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 152 , (3, 0, None, None) , 0 , )),
	(( 'AllowMirror' , 'pVal' , ), 10, (10, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 160 , (3, 0, None, None) , 0 , )),
	(( 'AllowMirror' , 'pVal' , ), 10, (10, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 168 , (3, 0, None, None) , 0 , )),
	(( 'RotationAngle' , 'pVal' , ), 11, (11, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 176 , (3, 0, None, None) , 0 , )),
	(( 'RotationAngle' , 'pVal' , ), 11, (11, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 184 , (3, 0, None, None) , 0 , )),
	(( 'PlacePart' , 'x' , 'y' , 'Angle' , 'Mirror' , 
			 'Subroutine' , 'pVal' , ), 12, (12, (), [ (16389, 1, None, None) , (16389, 1, None, None) , 
			 (16389, 1, None, None) , (16386, 1, None, None) , (2, 1, None, None) , (16393, 10, None, None) , ], 1 , 1 , 4 , 0 , 192 , (3, 0, None, None) , 0 , )),
	(( 'FileName' , 'pVal' , ), 13, (13, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 200 , (3, 0, None, None) , 0 , )),
	(( 'FileName' , 'pVal' , ), 13, (13, (), [ (8, 1, None, None) , ], 1 , 4 , 4 , 0 , 208 , (3, 0, None, None) , 0 , )),
	(( 'NumRequired' , 'pVal' , ), 14, (14, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 216 , (3, 0, None, None) , 64 , )),
	(( 'Total' , 'pVal' , ), 15, (15, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 224 , (3, 0, None, None) , 0 , )),
	(( 'ItemNumber' , 'pVal' , ), 16, (16, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 232 , (3, 0, None, None) , 0 , )),
	(( 'Instances' , 'pVal' , ), 17, (17, (), [ (16393, 10, None, "IID('{8B25EDA4-0887-4EA2-A9B6-D78ABCDDC8D9}')") , ], 1 , 2 , 4 , 0 , 240 , (3, 0, None, None) , 0 , )),
	(( 'InfoInitRemoved' , 'Data' , 'Index' , 'Drawing' , ), 18, (18, (), [ 
			 (3, 1, None, None) , (3, 1, None, None) , (9, 1, None, None) , ], 1 , 1 , 4 , 0 , 248 , (3, 0, None, None) , 1 , )),
	(( 'Modified' , 'pVal' , ), 19, (19, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 256 , (3, 0, None, None) , 0 , )),
	(( 'GetExtentL' , 'minx' , 'miny' , 'maxx' , 'maxy' , 
			 ), 20, (20, (), [ (16389, 1, None, None) , (16389, 1, None, None) , (16389, 1, None, None) , (16389, 1, None, None) , ], 1 , 1 , 4 , 0 , 264 , (3, 0, None, None) , 0 , )),
	(( 'InternalText' , 'pVal' , ), 21, (21, (), [ (16393, 10, None, None) , ], 1 , 2 , 4 , 0 , 272 , (3, 0, None, None) , 0 , )),
	(( 'InternalText' , 'pVal' , ), 21, (21, (), [ (9, 1, None, None) , ], 1 , 4 , 4 , 0 , 280 , (3, 0, None, None) , 0 , )),
	(( 'Annotation' , 'pVal' , ), 22, (22, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 288 , (3, 0, None, None) , 0 , )),
	(( 'Annotation' , 'pVal' , ), 22, (22, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 296 , (3, 0, None, None) , 0 , )),
	(( 'IsSame' , 'Part' , 'pVal' , ), 23, (23, (), [ (9, 1, None, "IID('{8ACC255D-1758-4296-AE13-FA3DC51E1641}')") , 
			 (16386, 10, None, None) , ], 1 , 1 , 4 , 0 , 304 , (3, 0, None, None) , 0 , )),
	(( 'SetExtensionConfig' , 'ExtensionName' , 'ConfigString' , ), 24, (24, (), [ (8, 1, None, None) , 
			 (8, 1, None, None) , ], 1 , 1 , 4 , 0 , 312 , (3, 0, None, None) , 64 , )),
	(( 'PlaceOrder' , 'pVal' , ), 25, (25, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 320 , (3, 0, None, None) , 0 , )),
	(( 'PlaceOrder' , 'pVal' , ), 25, (25, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 328 , (3, 0, None, None) , 0 , )),
	(( 'TryRotatedFirst' , 'pVal' , ), 26, (26, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 336 , (3, 0, None, None) , 0 , )),
	(( 'TryRotatedFirst' , 'pVal' , ), 26, (26, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 344 , (3, 0, None, None) , 0 , )),
	(( 'NumSpecificRotations' , 'pVal' , ), 27, (27, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 352 , (3, 0, None, None) , 0 , )),
	(( 'NumSpecificRotations' , 'pVal' , ), 27, (27, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 360 , (3, 0, None, None) , 0 , )),
	(( 'SpecificRotation' , 'Index' , 'pVal' , ), 28, (28, (), [ (3, 1, None, None) , 
			 (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 368 , (3, 0, None, None) , 0 , )),
	(( 'SpecificRotation' , 'Index' , 'pVal' , ), 28, (28, (), [ (3, 1, None, None) , 
			 (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 376 , (3, 0, None, None) , 0 , )),
	(( 'AddSpecificRotation' , 'Angle' , ), 29, (29, (), [ (5, 1, None, None) , ], 1 , 1 , 4 , 0 , 384 , (3, 0, None, None) , 0 , )),
	(( 'RemoveSpecificRotation' , 'Angle' , ), 30, (30, (), [ (5, 1, None, None) , ], 1 , 1 , 4 , 0 , 392 , (3, 0, None, None) , 0 , )),
	(( 'MaxPerSheet' , 'pVal' , ), 31, (31, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 400 , (3, 0, None, None) , 0 , )),
	(( 'MaxPerSheet' , 'pVal' , ), 31, (31, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 408 , (3, 0, None, None) , 0 , )),
	(( 'HasRotationByNinety' , 'pVal' , ), 32, (32, (), [ (16387, 10, None, None) , ], 1 , 1 , 4 , 0 , 416 , (3, 0, None, None) , 0 , )),
	(( 'QualityZone' , 'pVal' , ), 33, (33, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 424 , (3, 0, None, None) , 0 , )),
	(( 'QualityZone' , 'pVal' , ), 33, (33, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 432 , (3, 0, None, None) , 0 , )),
	(( 'KitNumber' , 'pVal' , ), 34, (34, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 440 , (3, 0, None, None) , 0 , )),
	(( 'KitNumber' , 'pVal' , ), 34, (34, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 448 , (3, 0, None, None) , 0 , )),
	(( 'Ignore3DPaths' , 'pVal' , ), 35, (35, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 456 , (3, 0, None, None) , 0 , )),
	(( 'Ignore3DPaths' , 'pVal' , ), 35, (35, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 464 , (3, 0, None, None) , 0 , )),
	(( 'AssociatedSolidParts' , 'pVal' , ), 36, (36, (), [ (16393, 10, None, None) , ], 1 , 2 , 4 , 0 , 472 , (3, 0, None, None) , 0 , )),
	(( 'AssociatedSolidParts' , 'pVal' , ), 36, (36, (), [ (9, 1, None, None) , ], 1 , 4 , 4 , 0 , 480 , (3, 0, None, None) , 0 , )),
	(( 'IncludeSolidParts' , 'pVal' , ), 37, (37, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 488 , (3, 0, None, None) , 0 , )),
	(( 'IncludeSolidParts' , 'pVal' , ), 37, (37, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 496 , (3, 0, None, None) , 0 , )),
	(( 'ExtraPartGap' , 'pVal' , ), 38, (38, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 504 , (3, 0, None, None) , 0 , )),
	(( 'ExtraPartGap' , 'pVal' , ), 38, (38, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 512 , (3, 0, None, None) , 0 , )),
	(( 'IgnoreApertures' , 'pVal' , ), 39, (39, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 520 , (3, 0, None, None) , 0 , )),
	(( 'IgnoreApertures' , 'pVal' , ), 39, (39, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 528 , (3, 0, None, None) , 0 , )),
	(( 'IgnorePathsOnWorkPlanes' , 'pVal' , ), 40, (40, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 536 , (3, 0, None, None) , 0 , )),
	(( 'IgnorePathsOnWorkPlanes' , 'pVal' , ), 40, (40, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 544 , (3, 0, None, None) , 0 , )),
]

INestPartInstance_vtables_dispatch_ = 1
INestPartInstance_vtables_ = [
	(( 'Sheet' , 'pVal' , ), 1, (1, (), [ (16393, 10, None, "IID('{393B862B-F535-4010-B5EF-1D1482809F2A}')") , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 0 , )),
	(( 'Name' , 'pVal' , ), 2, (2, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'FileName' , 'pVal' , ), 3, (3, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'Paths' , 'pVal' , ), 4, (4, (), [ (16393, 10, None, None) , ], 1 , 2 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'InitRemoved' , 'Data' , 'Index' , 'SheetNum' , 'Name' , 
			 'Drawing' , ), 5, (5, (), [ (3, 1, None, None) , (3, 1, None, None) , (3, 1, None, None) , 
			 (8, 1, None, None) , (9, 1, None, None) , ], 1 , 1 , 4 , 0 , 88 , (3, 0, None, None) , 1 , )),
	(( 'RotationAngle' , 'pVal' , ), 6, (6, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 96 , (3, 0, None, None) , 0 , )),
	(( 'Mirrored' , 'pVal' , ), 7, (7, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 104 , (3, 0, None, None) , 0 , )),
]

INestPartInstances_vtables_dispatch_ = 1
INestPartInstances_vtables_ = [
	(( '_NewEnum' , 'pVal' , ), -4, (-4, (), [ (16397, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 1 , )),
	(( 'Item' , 'Index' , 'pVal' , ), 0, (0, (), [ (3, 1, None, None) , 
			 (16393, 10, None, "IID('{972F8639-17D0-4413-A31B-E0F509880998}')") , ], 1 , 1 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'Count' , 'pVal' , ), 1, (1, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'InitRemoved' , 'Data' , 'SheetNum' , 'PartName' , 'Drawing' , 
			 ), 2, (2, (), [ (3, 1, None, None) , (3, 1, None, None) , (8, 1, None, None) , (9, 1, None, None) , ], 1 , 1 , 4 , 0 , 80 , (3, 0, None, None) , 1 , )),
]

INestParts_vtables_dispatch_ = 1
INestParts_vtables_ = [
	(( '_NewEnum' , 'pVal' , ), -4, (-4, (), [ (16397, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 1 , )),
	(( 'Count' , 'pVal' , ), 1, (1, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'Item' , 'Index' , 'pVal' , ), 0, (0, (), [ (12, 1, None, None) , 
			 (16393, 10, None, "IID('{8ACC255D-1758-4296-AE13-FA3DC51E1641}')") , ], 1 , 1 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'SaveInfo' , 'FileName' , ), 2, (2, (), [ (8, 1, None, None) , ], 1 , 1 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'InitRemoved' , 'Data' , 'Drawing' , ), 3, (3, (), [ (3, 1, None, None) , 
			 (9, 1, None, None) , ], 1 , 1 , 4 , 0 , 88 , (3, 0, None, None) , 1 , )),
]

INestSheet_vtables_dispatch_ = 1
INestSheet_vtables_ = [
	(( 'Paths' , 'pVal' , ), 1, (1, (), [ (16393, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 0 , )),
	(( 'Paths' , 'pVal' , ), 1, (1, (), [ (9, 1, None, None) , ], 1 , 4 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'CheckPaths' , 'pVal' , ), 2, (2, (), [ (16393, 10, None, None) , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 64 , )),
	(( 'CheckPaths' , 'pVal' , ), 2, (2, (), [ (9, 1, None, None) , ], 1 , 4 , 4 , 0 , 80 , (3, 0, None, None) , 64 , )),
	(( 'Attribute' , 'key' , 'pVal' , ), 3, (3, (), [ (8, 1, None, None) , 
			 (16396, 10, None, None) , ], 1 , 2 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
	(( 'Attribute' , 'key' , 'pVal' , ), 3, (3, (), [ (8, 1, None, None) , 
			 (12, 1, None, None) , ], 1 , 4 , 4 , 0 , 96 , (3, 0, None, None) , 0 , )),
	(( 'ClassPointerRemoved' , 'pVal' , ), 5, (5, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 104 , (3, 0, None, None) , 1 , )),
	(( 'Name' , 'pVal' , ), 6, (6, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 112 , (3, 0, None, None) , 0 , )),
	(( 'Name' , 'pVal' , ), 6, (6, (), [ (8, 1, None, None) , ], 1 , 4 , 4 , 0 , 120 , (3, 0, None, None) , 0 , )),
	(( 'Required' , 'pVal' , ), 8, (8, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 128 , (3, 0, None, None) , 0 , )),
	(( 'Required' , 'pVal' , ), 8, (8, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 136 , (3, 0, None, None) , 0 , )),
	(( 'Path' , 'pVal' , ), 9, (9, (), [ (16393, 10, None, None) , ], 1 , 2 , 4 , 0 , 144 , (3, 0, None, None) , 0 , )),
	(( 'Path' , 'pVal' , ), 9, (9, (), [ (9, 1, None, None) , ], 1 , 4 , 4 , 0 , 152 , (3, 0, None, None) , 0 , )),
	(( 'Thickness' , 'pVal' , ), 10, (10, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 160 , (3, 0, None, None) , 0 , )),
	(( 'Thickness' , 'pVal' , ), 10, (10, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 168 , (3, 0, None, None) , 0 , )),
	(( 'MaterialName' , 'pVal' , ), 11, (11, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 176 , (3, 0, None, None) , 0 , )),
	(( 'MaterialName' , 'pVal' , ), 11, (11, (), [ (8, 1, None, None) , ], 1 , 4 , 4 , 0 , 184 , (3, 0, None, None) , 0 , )),
	(( 'PlaceSheet' , 'x' , 'y' , 'pVal' , ), 12, (12, (), [ 
			 (16389, 1, None, None) , (16389, 1, None, None) , (16393, 10, None, None) , ], 1 , 1 , 4 , 0 , 192 , (3, 0, None, None) , 0 , )),
	(( 'Geometry' , 'pVal' , ), 13, (13, (), [ (16393, 10, None, None) , ], 1 , 2 , 4 , 0 , 200 , (3, 0, None, None) , 64 , )),
	(( 'Parts' , 'pVal' , ), 14, (14, (), [ (16393, 10, None, "IID('{8B25EDA4-0887-4EA2-A9B6-D78ABCDDC8D9}')") , ], 1 , 2 , 4 , 0 , 208 , (3, 0, None, None) , 0 , )),
	(( 'InfoInitRemoved' , 'Info' , 'Index' , 'Drawing' , ), 15, (15, (), [ 
			 (3, 1, None, None) , (3, 1, None, None) , (9, 1, None, None) , ], 1 , 1 , 4 , 0 , 216 , (3, 0, None, None) , 1 , )),
	(( 'IsSame' , 'Sheet' , 'pVal' , ), 16, (16, (), [ (9, 1, None, "IID('{393B862B-F535-4010-B5EF-1D1482809F2A}')") , 
			 (16386, 10, None, None) , ], 1 , 1 , 4 , 0 , 224 , (3, 0, None, None) , 0 , )),
	(( 'GetRealPaths' , 'pVal' , ), 17, (17, (), [ (16393, 10, None, None) , ], 1 , 1 , 4 , 0 , 232 , (3, 0, None, None) , 0 , )),
	(( 'NotifyComplete' , 'pPaths' , ), 18, (18, (), [ (9, 1, None, None) , ], 1 , 1 , 4 , 0 , 240 , (3, 0, None, None) , 0 , )),
	(( 'Multiplicity' , 'pVal' , ), 19, (19, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 248 , (3, 0, None, None) , 0 , )),
]

INestSheets_vtables_dispatch_ = 1
INestSheets_vtables_ = [
	(( '_NewEnum' , 'pVal' , ), -4, (-4, (), [ (16397, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 1 , )),
	(( 'Count' , 'pVal' , ), 1, (1, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'Item' , 'Index' , 'pVal' , ), 0, (0, (), [ (12, 1, None, None) , 
			 (16393, 10, None, "IID('{393B862B-F535-4010-B5EF-1D1482809F2A}')") , ], 1 , 1 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'SaveInfo' , 'FileName' , ), 2, (2, (), [ (8, 1, None, None) , ], 1 , 1 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'InitRemoved' , 'Data' , 'Drawing' , ), 3, (3, (), [ (3, 1, None, None) , 
			 (9, 1, None, None) , ], 1 , 1 , 4 , 0 , 88 , (3, 0, None, None) , 1 , )),
]

INesting_vtables_dispatch_ = 1
INesting_vtables_ = [
	(( '_NewEnum' , 'pVal' , ), -4, (-4, (), [ (16397, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 1 , )),
	(( 'Item' , 'Index' , 'pVal' , ), 0, (0, (), [ (3, 1, None, None) , 
			 (16393, 10, None, "IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')") , ], 1 , 1 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'NewNestList' , 'Name' , 'pVal' , ), 1, (1, (), [ (8, 1, None, None) , 
			 (16393, 10, None, "IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')") , ], 1 , 1 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'Count' , 'pVal' , ), 2, (2, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'DeleteNestList' , 'FileName' , ), 3, (3, (), [ (8, 1, None, None) , ], 1 , 1 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
	(( 'NewSheetList' , 'pVal' , ), 4, (4, (), [ (16393, 10, None, "IID('{0687113C-A6A0-4D3C-B56F-432DF61A5774}')") , ], 1 , 1 , 4 , 0 , 96 , (3, 0, None, None) , 0 , )),
	(( 'RegisterEventHandler' , 'EventHandler' , ), 6, (6, (), [ (9, 1, None, "IID('{9A867723-2B30-4B44-AB02-BAF612A0FBF4}')") , ], 1 , 1 , 4 , 0 , 104 , (3, 0, None, None) , 0 , )),
	(( 'RegisterCEventHandlerRemoved' , 'EventHandler' , ), 7, (7, (), [ (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 112 , (3, 0, None, None) , 1 , )),
	(( 'Init' , 'App' , 'hInst' , ), 8, (8, (), [ (9, 1, None, None) , 
			 (16387, 2, None, None) , ], 1 , 1 , 4 , 0 , 120 , (3, 0, None, None) , 1 , )),
	(( 'GetNestData' , 'FileName' , 'pVal' , ), 9, (9, (), [ (8, 1, None, None) , 
			 (16393, 10, None, "IID('{175E5A9E-72D2-4163-B751-382357CD5D6A}')") , ], 1 , 1 , 4 , 0 , 128 , (3, 0, None, None) , 64 , )),
	(( 'GetNestInformation' , 'pVal' , ), 10, (10, (), [ (16393, 10, None, "IID('{6B205E8C-FD6E-44ED-ABA2-9FD6870B42BB}')") , ], 1 , 1 , 4 , 0 , 136 , (3, 0, None, None) , 0 , )),
	(( 'Nest' , 'Nestlist' , 'SheetList' , 'pVal' , ), 11, (11, (), [ 
			 (9, 1, None, "IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')") , (9, 1, None, "IID('{0687113C-A6A0-4D3C-B56F-432DF61A5774}')") , (16393, 10, None, "IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')") , ], 1 , 1 , 4 , 0 , 144 , (3, 0, None, None) , 0 , )),
	(( 'NestUsingEngine' , 'Nestlist' , 'SheetList' , 'Engine' , 'pVal' , 
			 ), 12, (12, (), [ (9, 1, None, "IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')") , (9, 1, None, "IID('{0687113C-A6A0-4D3C-B56F-432DF61A5774}')") , (9, 1, None, "IID('{67426269-0738-4335-AC13-6AE288FE096D}')") , (16393, 10, None, "IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')") , ], 1 , 1 , 4 , 0 , 152 , (3, 0, None, None) , 64 , )),
	(( 'NewTemporaryNestList' , 'pVal' , ), 13, (13, (), [ (16393, 10, None, "IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')") , ], 1 , 1 , 4 , 0 , 160 , (3, 0, None, None) , 0 , )),
	(( 'UnRegisterCEventHandlerRemoved' , 'EventHandler' , ), 14, (14, (), [ (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 168 , (3, 0, None, None) , 1 , )),
	(( 'UnRegisterEventHandler' , 'EventHandler' , ), 15, (15, (), [ (9, 1, None, "IID('{9A867723-2B30-4B44-AB02-BAF612A0FBF4}')") , ], 1 , 1 , 4 , 0 , 176 , (3, 0, None, None) , 0 , )),
	(( 'RegisterCExtensionHandlerRemoved' , 'ExtensionHandler' , ), 16, (16, (), [ (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 184 , (3, 0, None, None) , 1 , )),
	(( 'UnRegisterCExtensionHandlerRemoved' , 'ExtensionHandler' , ), 17, (17, (), [ (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 192 , (3, 0, None, None) , 1 , )),
	(( 'Level' , 'pVal' , ), 18, (18, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 200 , (3, 0, None, None) , 0 , )),
	(( 'ClassPointerRemoved' , 'pVal' , ), 19, (19, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 208 , (3, 0, None, None) , 1 , )),
	(( 'Extensions' , 'pVal' , ), 20, (20, (), [ (16393, 10, None, "IID('{7B37B17F-B44C-4625-A435-B137E03E6AAF}')") , ], 1 , 2 , 4 , 0 , 216 , (3, 0, None, None) , 0 , )),
	(( 'SheetDB' , 'pVal' , ), 21, (21, (), [ (16393, 10, None, "IID('{98D8443D-C842-4F05-9D64-BB03AE1A65C6}')") , ], 1 , 2 , 4 , 0 , 224 , (3, 0, None, None) , 64 , )),
	(( 'LoadNestList' , 'FileName' , 'pVal' , ), 22, (22, (), [ (8, 1, None, None) , 
			 (16393, 10, None, "IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')") , ], 1 , 1 , 4 , 0 , 232 , (3, 0, None, None) , 0 , )),
	(( 'RegisterExtensionHandler' , 'ExtensionHandler' , ), 23, (23, (), [ (9, 1, None, "IID('{576061B6-AF45-4CFB-AD31-2E42C2A68F2E}')") , ], 1 , 1 , 4 , 0 , 240 , (3, 0, None, None) , 0 , )),
	(( 'UnRegisterExtensionHandler' , 'ExtensionHandler' , ), 24, (24, (), [ (9, 1, None, "IID('{576061B6-AF45-4CFB-AD31-2E42C2A68F2E}')") , ], 1 , 1 , 4 , 0 , 248 , (3, 0, None, None) , 0 , )),
	(( 'RegisterDebugEventHandler' , 'EventHandler' , 'DebugIndex' , ), 25, (25, (), [ (9, 1, None, "IID('{9A867723-2B30-4B44-AB02-BAF612A0FBF4}')") , 
			 (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 256 , (3, 0, None, None) , 64 , )),
	(( 'RegisterDebugCEventHandler' , 'EventHandler' , 'DebugIndex' , ), 26, (26, (), [ (3, 1, None, None) , 
			 (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 264 , (3, 0, None, None) , 1 , )),
	(( 'UnRegisterDebugEventHandler' , 'DebugIndex' , ), 27, (27, (), [ (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 272 , (3, 0, None, None) , 64 , )),
	(( 'UnRegisterDebugCEventHandler' , 'DebugIndex' , ), 28, (28, (), [ (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 280 , (3, 0, None, None) , 1 , )),
	(( 'RegisterDebugExtensionHandler' , 'ExtensionHandler' , 'DebugIndex' , ), 29, (29, (), [ (9, 1, None, "IID('{576061B6-AF45-4CFB-AD31-2E42C2A68F2E}')") , 
			 (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 288 , (3, 0, None, None) , 64 , )),
	(( 'RegisterDebugCExtensionHandler' , 'ExtensionHandler' , 'DebugIndex' , ), 30, (30, (), [ (3, 1, None, None) , 
			 (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 296 , (3, 0, None, None) , 1 , )),
	(( 'UnRegisterDebugExtensionHandler' , 'DebugIndex' , ), 31, (31, (), [ (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 304 , (3, 0, None, None) , 64 , )),
	(( 'UnRegisterDebugCExtensionHandler' , 'DebugIndex' , ), 32, (32, (), [ (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 312 , (3, 0, None, None) , 1 , )),
	(( 'DeleteNestListByIndex' , 'Index' , ), 33, (33, (), [ (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 320 , (3, 0, None, None) , 0 , )),
	(( 'DeleteAllNestLists' , ), 34, (34, (), [ ], 1 , 1 , 4 , 0 , 328 , (3, 0, None, None) , 0 , )),
	(( 'AutoNest' , 'SheetPath' , 'Count' , 'Nestlist' , 'pVal' , 
			 ), 35, (35, (), [ (9, 1, None, None) , (3, 1, None, None) , (9, 1, None, "IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')") , (16393, 10, None, "IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')") , ], 1 , 1 , 4 , 0 , 336 , (3, 0, None, None) , 0 , )),
	(( 'Abort' , 'pVal' , ), 36, (36, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 344 , (3, 0, None, None) , 0 , )),
	(( 'Abort' , 'pVal' , ), 36, (36, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 352 , (3, 0, None, None) , 0 , )),
	(( 'CreateEventHandler' , 'pEventHandler' , ), 37, (37, (), [ (16393, 10, None, "IID('{9A867723-2B30-4B44-AB02-BAF612A0FBF4}')") , ], 1 , 1 , 4 , 0 , 360 , (3, 0, None, None) , 0 , )),
	(( 'CreateExtensionHandler' , 'pExtensionHandler' , ), 38, (38, (), [ (16393, 10, None, "IID('{576061B6-AF45-4CFB-AD31-2E42C2A68F2E}')") , ], 1 , 1 , 4 , 0 , 368 , (3, 0, None, None) , 0 , )),
	(( 'GetNestInformationForDrawing' , 'Drawing' , 'pVal' , ), 39, (39, (), [ (9, 1, None, None) , 
			 (16393, 10, None, "IID('{6B205E8C-FD6E-44ED-ABA2-9FD6870B42BB}')") , ], 1 , 1 , 4 , 0 , 376 , (3, 0, None, None) , 0 , )),
	(( 'SheetDatabase' , 'pVal' , ), 40, (40, (), [ (16393, 10, None, "IID('{EE72FD01-BA42-4DFC-8BDE-9D522F43DE75}')") , ], 1 , 2 , 4 , 0 , 384 , (3, 0, None, None) , 0 , )),
	(( 'SuppressDialogs' , 'pVal' , ), 41, (41, (), [ (16395, 10, None, None) , ], 1 , 2 , 4 , 0 , 392 , (3, 0, None, None) , 0 , )),
	(( 'SuppressDialogs' , 'pVal' , ), 41, (41, (), [ (11, 1, None, None) , ], 1 , 4 , 4 , 0 , 400 , (3, 0, None, None) , 0 , )),
	(( 'IsNestListNameValid' , 'pNestList' , 'NewName' , 'pVal' , ), 42, (42, (), [ 
			 (9, 1, None, "IID('{32E79675-9214-4CCF-BC22-68AB6B9574A0}')") , (8, 1, None, None) , (16395, 10, None, None) , ], 1 , 1 , 4 , 0 , 408 , (3, 0, None, None) , 0 , )),
	(( 'MakeOffcuts' , 'min_x' , 'min_y' , 'Type' , 'apply_style' , 
			 'cut_side' , 'style_full_path' , 'pVal' , ), 43, (43, (), [ (5, 1, None, None) , 
			 (5, 1, None, None) , (3, 1, None, None) , (11, 1, None, None) , (3, 1, None, None) , (8, 1, None, None) , 
			 (16393, 10, None, None) , ], 1 , 1 , 4 , 0 , 416 , (3, 0, None, None) , 0 , )),
]

INestingExtension3_vtables_dispatch_ = 1
INestingExtension3_vtables_ = [
	(( 'ClassPointerRemoved' , 'pVal' , ), 1, (1, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 1 , )),
]

ISheetDBElem_vtables_dispatch_ = 1
ISheetDBElem_vtables_ = [
	(( 'Material' , 'pVal' , ), 1, (1, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 0 , )),
	(( 'Material' , 'pVal' , ), 1, (1, (), [ (8, 1, None, None) , ], 1 , 4 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'OffCut' , 'pVal' , ), 2, (2, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'OffCut' , 'pVal' , ), 2, (2, (), [ (2, 1, None, None) , ], 1 , 4 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'Cost' , 'pVal' , ), 3, (3, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
	(( 'Cost' , 'pVal' , ), 3, (3, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 96 , (3, 0, None, None) , 0 , )),
	(( 'Weight' , 'pVal' , ), 4, (4, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 104 , (3, 0, None, None) , 0 , )),
	(( 'Weight' , 'pVal' , ), 4, (4, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 112 , (3, 0, None, None) , 0 , )),
	(( 'CostType' , 'pVal' , ), 5, (5, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 120 , (3, 0, None, None) , 0 , )),
	(( 'CostType' , 'pVal' , ), 5, (5, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 128 , (3, 0, None, None) , 0 , )),
	(( 'NumAvailable' , 'pVal' , ), 6, (6, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 136 , (3, 0, None, None) , 0 , )),
	(( 'NumAvailable' , 'pVal' , ), 6, (6, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 144 , (3, 0, None, None) , 0 , )),
	(( 'Thickness' , 'pVal' , ), 7, (7, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 152 , (3, 0, None, None) , 0 , )),
	(( 'Thickness' , 'pVal' , ), 7, (7, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 160 , (3, 0, None, None) , 0 , )),
	(( 'Width' , 'pVal' , ), 8, (8, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 168 , (3, 0, None, None) , 0 , )),
	(( 'Width' , 'pVal' , ), 8, (8, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 176 , (3, 0, None, None) , 0 , )),
	(( 'Length' , 'pVal' , ), 9, (9, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 184 , (3, 0, None, None) , 0 , )),
	(( 'Length' , 'pVal' , ), 9, (9, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 192 , (3, 0, None, None) , 0 , )),
	(( 'Value' , 'pVal' , ), 10, (10, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 200 , (3, 0, None, None) , 0 , )),
	(( 'Value' , 'pVal' , ), 10, (10, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 208 , (3, 0, None, None) , 0 , )),
	(( 'Comment' , 'pVal' , ), 11, (11, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 216 , (3, 0, None, None) , 0 , )),
	(( 'Comment' , 'pVal' , ), 11, (11, (), [ (8, 1, None, None) , ], 1 , 4 , 4 , 0 , 224 , (3, 0, None, None) , 0 , )),
	(( 'DBUid' , 'pVal' , ), 12, (12, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 232 , (3, 0, None, None) , 0 , )),
	(( 'DBUid' , 'pVal' , ), 12, (12, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 240 , (3, 0, None, None) , 1 , )),
	(( 'TimeStamp' , 'pVal' , ), 13, (13, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 248 , (3, 0, None, None) , 1 , )),
	(( 'TimeStamp' , 'pVal' , ), 13, (13, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 256 , (3, 0, None, None) , 1 , )),
	(( 'Init' , 'Config' , ), 14, (14, (), [ (8, 1, None, None) , ], 1 , 1 , 4 , 0 , 264 , (3, 0, None, None) , 1 , )),
	(( 'SetValsRemoved' , 'Data' , ), 15, (15, (), [ (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 272 , (3, 0, None, None) , 1 , )),
]

ISheetDBase_vtables_dispatch_ = 1
ISheetDBase_vtables_ = [
	(( '_NewEnum' , 'pVal' , ), -4, (-4, (), [ (16397, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 1 , )),
	(( 'Item' , 'Index' , 'pVal' , ), 0, (0, (), [ (12, 1, None, None) , 
			 (16393, 10, None, "IID('{65FD3369-7398-404A-852F-0C092EA7BC25}')") , ], 1 , 1 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'FromDisk' , ), 1, (1, (), [ ], 1 , 1 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'ToDisk' , ), 2, (2, (), [ ], 1 , 1 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'Modified' , 'pVal' , ), 3, (3, (), [ (16386, 10, None, None) , ], 1 , 2 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
	(( 'AddSheet' , 'Sheet' , ), 4, (4, (), [ (9, 1, None, "IID('{65FD3369-7398-404A-852F-0C092EA7BC25}')") , ], 1 , 1 , 4 , 0 , 96 , (3, 0, None, None) , 0 , )),
	(( 'Delete' , 'Index' , ), 5, (5, (), [ (12, 1, None, None) , ], 1 , 1 , 4 , 0 , 104 , (3, 0, None, None) , 0 , )),
	(( 'Update' , ), 6, (6, (), [ ], 1 , 1 , 4 , 0 , 112 , (3, 0, None, None) , 0 , )),
	(( 'Count' , 'pVal' , ), 7, (7, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 120 , (3, 0, None, None) , 0 , )),
	(( 'NewSheet' , 'Sheet' , ), 8, (8, (), [ (16393, 10, None, "IID('{65FD3369-7398-404A-852F-0C092EA7BC25}')") , ], 1 , 1 , 4 , 0 , 128 , (3, 0, None, None) , 0 , )),
	(( 'Refresh' , 'Modified' , ), 9, (9, (), [ (16395, 2, None, None) , ], 1 , 1 , 4 , 0 , 136 , (3, 0, None, None) , 0 , )),
	(( 'InsertSheet' , 'Index' , 'pVal' , ), 10, (10, (), [ (12, 1, None, None) , 
			 (16393, 10, None, None) , ], 1 , 1 , 4 , 0 , 144 , (3, 0, None, None) , 0 , )),
	(( 'ClassPointerRemoved' , 'pVal' , ), 11, (11, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 152 , (3, 0, None, None) , 65 , )),
	(( 'UpdateFromScreen' , ), 12, (12, (), [ ], 1 , 1 , 4 , 0 , 160 , (3, 0, None, None) , 0 , )),
	(( 'CreateOffcuts' , ), 13, (13, (), [ ], 1 , 1 , 4 , 0 , 168 , (3, 0, None, None) , 0 , )),
	(( 'UseOffcuts' , ), 14, (14, (), [ ], 1 , 1 , 4 , 0 , 176 , (3, 0, None, None) , 0 , )),
]

ISheetDatabase_vtables_dispatch_ = 1
ISheetDatabase_vtables_ = [
	(( 'Materials' , 'pVal' , ), 0, (0, (), [ (16393, 10, None, "IID('{E838A5C4-4986-451E-8BAA-DDDDC5FE51E6}')") , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 0 , )),
	(( 'AddMaterial' , 'Name' , 'pVal' , ), 1, (1, (), [ (8, 1, None, None) , 
			 (16393, 10, None, "IID('{26947A4F-EE56-4834-A341-A8166EA72D77}')") , ], 1 , 1 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'LengthUnits' , 'pVal' , ), 2, (2, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'LengthUnits' , 'pVal' , ), 2, (2, (), [ (3, 1, None, None) , ], 1 , 4 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'Sheets' , 'pVal' , ), 3, (3, (), [ (16393, 10, None, "IID('{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}')") , ], 1 , 2 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
	(( 'WholeSheets' , 'pVal' , ), 4, (4, (), [ (16393, 10, None, "IID('{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}')") , ], 1 , 2 , 4 , 0 , 96 , (3, 0, None, None) , 0 , )),
	(( 'Offcuts' , 'pVal' , ), 5, (5, (), [ (16393, 10, None, "IID('{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}')") , ], 1 , 2 , 4 , 0 , 104 , (3, 0, None, None) , 0 , )),
	(( 'FindMaterial' , 'Name' , 'pVal' , ), 6, (6, (), [ (8, 1, None, None) , 
			 (16393, 10, None, "IID('{26947A4F-EE56-4834-A341-A8166EA72D77}')") , ], 1 , 1 , 4 , 0 , 112 , (3, 0, None, None) , 0 , )),
	(( 'CreateSheetCollection' , 'pVal' , ), 7, (7, (), [ (16393, 10, None, "IID('{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}')") , ], 1 , 1 , 4 , 0 , 120 , (3, 0, None, None) , 0 , )),
	(( 'FindSheet' , 'Name' , 'pVal' , ), 8, (8, (), [ (8, 1, None, None) , 
			 (16393, 10, None, "IID('{B843219A-C9CE-419A-9153-577BF8C9362D}')") , ], 1 , 1 , 4 , 0 , 128 , (3, 0, None, None) , 0 , )),
	(( 'FindMaterialByDatabaseID' , 'Id' , 'pVal' , ), 9, (9, (), [ (3, 1, None, None) , 
			 (16393, 10, None, "IID('{26947A4F-EE56-4834-A341-A8166EA72D77}')") , ], 1 , 1 , 4 , 0 , 136 , (3, 0, None, None) , 0 , )),
	(( 'FindThicknessByDatabaseID' , 'Id' , 'pVal' , ), 10, (10, (), [ (3, 1, None, None) , 
			 (16393, 10, None, "IID('{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}')") , ], 1 , 1 , 4 , 0 , 144 , (3, 0, None, None) , 0 , )),
	(( 'FindSheetByDatabaseID' , 'Id' , 'pVal' , ), 11, (11, (), [ (3, 1, None, None) , 
			 (16393, 10, None, "IID('{B843219A-C9CE-419A-9153-577BF8C9362D}')") , ], 1 , 1 , 4 , 0 , 152 , (3, 0, None, None) , 0 , )),
	(( 'Save' , 'pRetCode' , ), 12, (12, (), [ (16387, 10, None, None) , ], 1 , 1 , 4 , 0 , 160 , (3, 0, None, None) , 0 , )),
	(( 'CreateOffcuts' , ), 13, (13, (), [ ], 1 , 1 , 4 , 0 , 168 , (3, 0, None, None) , 0 , )),
	(( 'SaveOffcutToDatabase' , 'i_sheet' , 'i_drw' , 'pVal' , ), 14, (14, (), [ 
			 (9, 1, None, None) , (9, 1, None, None) , (16392, 10, None, None) , ], 1 , 1 , 4 , 0 , 176 , (3, 0, None, None) , 0 , )),
]

ISheetList_vtables_dispatch_ = 1
ISheetList_vtables_ = [
	(( '_NewEnum' , 'pVal' , ), -4, (-4, (), [ (16397, 10, None, None) , ], 1 , 2 , 4 , 0 , 56 , (3, 0, None, None) , 1 , )),
	(( 'Item' , 'Index' , 'pVal' , ), 0, (0, (), [ (3, 1, None, None) , 
			 (16393, 10, None, "IID('{393B862B-F535-4010-B5EF-1D1482809F2A}')") , ], 1 , 1 , 4 , 0 , 64 , (3, 0, None, None) , 0 , )),
	(( 'Count' , 'pVal' , ), 1, (1, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 72 , (3, 0, None, None) , 0 , )),
	(( 'ListName' , 'pVal' , ), 2, (2, (), [ (16392, 10, None, None) , ], 1 , 2 , 4 , 0 , 80 , (3, 0, None, None) , 0 , )),
	(( 'ListName' , 'pVal' , ), 2, (2, (), [ (8, 1, None, None) , ], 1 , 4 , 4 , 0 , 88 , (3, 0, None, None) , 0 , )),
	(( 'ClassPointerRemoved' , 'pVal' , ), 3, (3, (), [ (16387, 10, None, None) , ], 1 , 2 , 4 , 0 , 96 , (3, 0, None, None) , 1 , )),
	(( 'Add' , 'Path' , 'pVal' , ), 4, (4, (), [ (9, 1, None, None) , 
			 (16393, 10, None, "IID('{393B862B-F535-4010-B5EF-1D1482809F2A}')") , ], 1 , 1 , 4 , 0 , 104 , (3, 0, None, None) , 0 , )),
	(( 'DeleteSheet' , 'Sheet' , ), 5, (5, (), [ (9, 1, None, "IID('{393B862B-F535-4010-B5EF-1D1482809F2A}')") , ], 1 , 1 , 4 , 0 , 112 , (3, 0, None, None) , 0 , )),
	(( 'SheetHGap' , 'pVal' , ), 6, (6, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 120 , (3, 0, None, None) , 0 , )),
	(( 'SheetHGap' , 'pVal' , ), 6, (6, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 128 , (3, 0, None, None) , 0 , )),
	(( 'SheetVGap' , 'pVal' , ), 7, (7, (), [ (16389, 10, None, None) , ], 1 , 2 , 4 , 0 , 136 , (3, 0, None, None) , 0 , )),
	(( 'SheetVGap' , 'pVal' , ), 7, (7, (), [ (5, 1, None, None) , ], 1 , 4 , 4 , 0 , 144 , (3, 0, None, None) , 0 , )),
	(( 'DeleteSheetByIndex' , 'SheetIndex' , ), 8, (8, (), [ (3, 1, None, None) , ], 1 , 1 , 4 , 0 , 152 , (3, 0, None, None) , 0 , )),
]

RecordMap = {
}

CLSIDToClassMap = {
	'{175E5A9E-72D2-4163-B751-382357CD5D6A}' : INestData,
	'{A3E9AAD4-E240-4382-9DDB-5F4EFC9E8FB9}' : NestData,
	'{31DEE408-CC4F-44A8-87AC-C1C8770CA018}' : INesting,
	'{32E79675-9214-4CCF-BC22-68AB6B9574A0}' : INestList,
	'{8ACC255D-1758-4296-AE13-FA3DC51E1641}' : INestPart,
	'{8B25EDA4-0887-4EA2-A9B6-D78ABCDDC8D9}' : INestPartInstances,
	'{972F8639-17D0-4413-A31B-E0F509880998}' : INestPartInstance,
	'{393B862B-F535-4010-B5EF-1D1482809F2A}' : INestSheet,
	'{0687113C-A6A0-4D3C-B56F-432DF61A5774}' : ISheetList,
	'{9A867723-2B30-4B44-AB02-BAF612A0FBF4}' : INestEvents3,
	'{6B205E8C-FD6E-44ED-ABA2-9FD6870B42BB}' : INestInformation,
	'{D55B5242-FAEA-4704-8C71-0EB0746BC751}' : INestSheets,
	'{5FFBEE0B-0A71-4255-BEBB-99F138EEFC4D}' : INestParts,
	'{98D8443D-C842-4F05-9D64-BB03AE1A65C6}' : ISheetDBase,
	'{65FD3369-7398-404A-852F-0C092EA7BC25}' : ISheetDBElem,
	'{67426269-0738-4335-AC13-6AE288FE096D}' : INestEngine,
	'{7B37B17F-B44C-4625-A435-B137E03E6AAF}' : INestExtensions,
	'{6EC96D6F-3CA5-4B12-A9A0-3BE960F94DB0}' : INestExtension,
	'{576061B6-AF45-4CFB-AD31-2E42C2A68F2E}' : INestingExtension3,
	'{EE72FD01-BA42-4DFC-8BDE-9D522F43DE75}' : ISheetDatabase,
	'{E838A5C4-4986-451E-8BAA-DDDDC5FE51E6}' : IDatabaseMaterials,
	'{26947A4F-EE56-4834-A341-A8166EA72D77}' : IDatabaseMaterial,
	'{A09823E9-8D42-42A1-B8DF-A2D9342DAFB1}' : IDatabaseThicknesses,
	'{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}' : IDatabaseThickness,
	'{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}' : IDatabaseSheets,
	'{B843219A-C9CE-419A-9153-577BF8C9362D}' : IDatabaseSheet,
	'{07D9A612-7B31-4B54-94BF-2E947A15A8DC}' : IDatabaseZones,
	'{97F97832-6E45-4C52-91EA-9F23CC038F29}' : IDatabaseZone,
	'{FCC7E45F-B0AC-4835-99DF-552F5C18014E}' : NestInformation,
	'{ACDEA351-A51F-4553-821E-B51EC78FC231}' : NestSheets,
	'{12FFBF81-08E5-4038-A2CD-C952A262C7FD}' : NestParts,
	'{00406E2C-CFE4-4A81-A05E-7445826669B5}' : NestSheet,
	'{1287E979-83A6-4C8E-90B2-DB71CA4C1F37}' : NestPartInstance,
	'{4BCC51A8-6934-4B04-BE49-E105CE847FA8}' : NestPartInstances,
	'{485EF309-87A4-41C5-91CC-C9ECB28BF7B5}' : NestPart,
	'{9FC79BC5-07C6-4DCF-A08D-80E076BB2316}' : NestEngine,
	'{A027C40B-1156-4F95-B126-455E37FEA178}' : Nestlist,
	'{426370B5-A456-4270-BB81-725FAB9884C7}' : SheetList,
	'{57250022-AD47-4205-AA0D-9F8039C315B3}' : Nesting,
	'{03762FE5-DFDF-4534-B1AE-7D34AF943D86}' : INestEventsEvents,
	'{F4C7709A-132D-4182-9414-B5DA62D7F763}' : NestEvents,
	'{F2339392-DB43-4B6C-95CF-D67B51B577AF}' : INestingExtensionEvents,
	'{C575F813-38F0-44D4-8D08-227D2794A94F}' : NestingExtension,
	'{CEBB82E2-828A-4E84-BC64-D05CB076DB04}' : NestExtension,
	'{3061A13F-96CC-45F0-8FD6-F5850D262A55}' : NestExtensions,
	'{0D12AADE-D65D-47B4-B924-FC1099CF9207}' : SheetDBase,
	'{308D5B14-E22B-4963-8814-F665C10E9A13}' : SheetDBElem,
	'{1C2252AB-0AED-4650-A92C-F5354919A8AE}' : SheetDatabase,
	'{82CA8D6B-39DD-4036-9EA4-68751525CA41}' : DatabaseMaterial,
	'{142B2338-8688-4EE7-B34A-305DBB1BCB7E}' : DatabaseMaterials,
	'{9CBA1ED5-B394-4E28-A147-8C52EAB77C28}' : DatabaseThickness,
	'{DACBC1D5-64AA-4648-B06C-4E90289DF069}' : DatabaseThicknesses,
	'{3EF55026-A506-47EE-A86A-C87304F1EE53}' : DatabaseSheet,
	'{5F0A5D97-AEF4-4FCE-81E9-FEF202EBDB65}' : DatabaseSheets,
	'{C1746D4A-91A8-4B8D-BE95-5B35BB968CD8}' : DatabaseZone,
	'{D6908C61-2E6E-4B36-A147-603BF2DCF875}' : DatabaseZones,
}
CLSIDToPackageMap = {}
win32com.client.CLSIDToClass.RegisterCLSIDsFromDict( CLSIDToClassMap )
VTablesToPackageMap = {}
VTablesToClassMap = {
	'{175E5A9E-72D2-4163-B751-382357CD5D6A}' : 'INestData',
	'{31DEE408-CC4F-44A8-87AC-C1C8770CA018}' : 'INesting',
	'{32E79675-9214-4CCF-BC22-68AB6B9574A0}' : 'INestList',
	'{8ACC255D-1758-4296-AE13-FA3DC51E1641}' : 'INestPart',
	'{8B25EDA4-0887-4EA2-A9B6-D78ABCDDC8D9}' : 'INestPartInstances',
	'{972F8639-17D0-4413-A31B-E0F509880998}' : 'INestPartInstance',
	'{393B862B-F535-4010-B5EF-1D1482809F2A}' : 'INestSheet',
	'{0687113C-A6A0-4D3C-B56F-432DF61A5774}' : 'ISheetList',
	'{9A867723-2B30-4B44-AB02-BAF612A0FBF4}' : 'INestEvents3',
	'{6B205E8C-FD6E-44ED-ABA2-9FD6870B42BB}' : 'INestInformation',
	'{D55B5242-FAEA-4704-8C71-0EB0746BC751}' : 'INestSheets',
	'{5FFBEE0B-0A71-4255-BEBB-99F138EEFC4D}' : 'INestParts',
	'{98D8443D-C842-4F05-9D64-BB03AE1A65C6}' : 'ISheetDBase',
	'{65FD3369-7398-404A-852F-0C092EA7BC25}' : 'ISheetDBElem',
	'{67426269-0738-4335-AC13-6AE288FE096D}' : 'INestEngine',
	'{7B37B17F-B44C-4625-A435-B137E03E6AAF}' : 'INestExtensions',
	'{6EC96D6F-3CA5-4B12-A9A0-3BE960F94DB0}' : 'INestExtension',
	'{576061B6-AF45-4CFB-AD31-2E42C2A68F2E}' : 'INestingExtension3',
	'{EE72FD01-BA42-4DFC-8BDE-9D522F43DE75}' : 'ISheetDatabase',
	'{E838A5C4-4986-451E-8BAA-DDDDC5FE51E6}' : 'IDatabaseMaterials',
	'{26947A4F-EE56-4834-A341-A8166EA72D77}' : 'IDatabaseMaterial',
	'{A09823E9-8D42-42A1-B8DF-A2D9342DAFB1}' : 'IDatabaseThicknesses',
	'{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}' : 'IDatabaseThickness',
	'{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}' : 'IDatabaseSheets',
	'{B843219A-C9CE-419A-9153-577BF8C9362D}' : 'IDatabaseSheet',
	'{07D9A612-7B31-4B54-94BF-2E947A15A8DC}' : 'IDatabaseZones',
	'{97F97832-6E45-4C52-91EA-9F23CC038F29}' : 'IDatabaseZone',
}


NamesToIIDMap = {
	'INestData' : '{175E5A9E-72D2-4163-B751-382357CD5D6A}',
	'INesting' : '{31DEE408-CC4F-44A8-87AC-C1C8770CA018}',
	'INestList' : '{32E79675-9214-4CCF-BC22-68AB6B9574A0}',
	'INestPart' : '{8ACC255D-1758-4296-AE13-FA3DC51E1641}',
	'INestPartInstances' : '{8B25EDA4-0887-4EA2-A9B6-D78ABCDDC8D9}',
	'INestPartInstance' : '{972F8639-17D0-4413-A31B-E0F509880998}',
	'INestSheet' : '{393B862B-F535-4010-B5EF-1D1482809F2A}',
	'ISheetList' : '{0687113C-A6A0-4D3C-B56F-432DF61A5774}',
	'INestEvents3' : '{9A867723-2B30-4B44-AB02-BAF612A0FBF4}',
	'INestInformation' : '{6B205E8C-FD6E-44ED-ABA2-9FD6870B42BB}',
	'INestSheets' : '{D55B5242-FAEA-4704-8C71-0EB0746BC751}',
	'INestParts' : '{5FFBEE0B-0A71-4255-BEBB-99F138EEFC4D}',
	'ISheetDBase' : '{98D8443D-C842-4F05-9D64-BB03AE1A65C6}',
	'ISheetDBElem' : '{65FD3369-7398-404A-852F-0C092EA7BC25}',
	'INestEngine' : '{67426269-0738-4335-AC13-6AE288FE096D}',
	'INestExtensions' : '{7B37B17F-B44C-4625-A435-B137E03E6AAF}',
	'INestExtension' : '{6EC96D6F-3CA5-4B12-A9A0-3BE960F94DB0}',
	'INestingExtension3' : '{576061B6-AF45-4CFB-AD31-2E42C2A68F2E}',
	'ISheetDatabase' : '{EE72FD01-BA42-4DFC-8BDE-9D522F43DE75}',
	'IDatabaseMaterials' : '{E838A5C4-4986-451E-8BAA-DDDDC5FE51E6}',
	'IDatabaseMaterial' : '{26947A4F-EE56-4834-A341-A8166EA72D77}',
	'IDatabaseThicknesses' : '{A09823E9-8D42-42A1-B8DF-A2D9342DAFB1}',
	'IDatabaseThickness' : '{90B2BF65-02D7-47BB-9F1B-4B7035C8D9A2}',
	'IDatabaseSheets' : '{6E1E0BC1-947A-47F9-B4DA-3B867F0FD960}',
	'IDatabaseSheet' : '{B843219A-C9CE-419A-9153-577BF8C9362D}',
	'IDatabaseZones' : '{07D9A612-7B31-4B54-94BF-2E947A15A8DC}',
	'IDatabaseZone' : '{97F97832-6E45-4C52-91EA-9F23CC038F29}',
	'INestEventsEvents' : '{03762FE5-DFDF-4534-B1AE-7D34AF943D86}',
	'INestingExtensionEvents' : '{F2339392-DB43-4B6C-95CF-D67B51B577AF}',
}

win32com.client.constants.__dicts__.append(constants.__dict__)

