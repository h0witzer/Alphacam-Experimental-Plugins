VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CShowerBaseData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' IMPORTANT: CShowerBaseData
'
'            This class is used to save/get MillData user setting attibutes
'            as well as last used values from the registry. It is not necessary
'            to use a class to do this. For example, the global variables
'            could also be used to save/get the MillDat attributes. It is
'            simply a programmer preference as to how this is done.

' IMPORTANT: The constant below is used as a prefix for all user settings
'            that are saved to the operation via MillData.AttributeOp.
'
'            SEE ALSO: SaveSettingsToOp and GetSettingsFromOp below
'
'            NOTE: This prefix is not required, but is good practice
'                  so that the attributes can be easily identified.
'                  As with any attribute, the value should be something
'                  that helps identify both the developer and the add-in.
'
'            NOTE: This string begins with an underscore ("_") so that
'                  it is hidden within the project manager property grid.
'                  This is not required and is simply a programmer preference.
'
Private Const AcamUSRGShowerBase    As String = "_AcamUSRGShowerBase_"

Private m_sLastTool                 As String

Public Tool                         As MillTool
Public SafeRapid                    As Double
Public RapidTo                      As Double
Public MaterialTop                  As Double
Public SpindleSpeed                 As Double
Public DownFeed                     As Double
Public CutFeed                      As Double
Public DepthAtProfile               As Double
Public DepthAtHole                  As Double
Public StepAlongProfile             As Double
Public StockToBeLeft                As Double
Public RadialAngle                  As Double
Public CuttingMethodBiDir           As Boolean
Public StartCuttingAtHole           As Boolean
Public CutAlongProfile              As Boolean
Public Coolant                      As AcamCoolant
Public ToolNumber                   As Long
Public OffsetNumber                 As Long
'

Public Sub SaveSettingsToOp(MD As MillData)
        
        ' IMPORTANT: Save the appropriate user setting values to MillData
        '            attributes. Any value that can be edited by the user
        '            when editing the operation or applying a Machining Style
        '            should be assigned here.
        '
        '            It's important to note that these values are being assigned to the
        '            MillData's "AttributOp" property, rather than its "Attribute" property.
        '            The difference here is that "AttributeOp" assigns the attribute to
        '            the Operation only, while "Attribute" also copies the attribute and
        '            its value to the tool paths (Path.Attribute) within the operation.
        '
        '            SEE ALSO: GetSettingsFromOp below
        
        If (MD Is Nothing) Then Exit Sub
        
        With MD
                .AttributeOp(AcamUSRGShowerBase & "SafeRapid") = Me.SafeRapid
                .AttributeOp(AcamUSRGShowerBase & "RapidTo") = Me.RapidTo
                .AttributeOp(AcamUSRGShowerBase & "MaterialTop") = Me.MaterialTop
                .AttributeOp(AcamUSRGShowerBase & "DepthAtProfile") = Me.DepthAtProfile
                .AttributeOp(AcamUSRGShowerBase & "DepthAtHole") = Me.DepthAtHole
                .AttributeOp(AcamUSRGShowerBase & "StepAlongProfile") = Me.StepAlongProfile
                .AttributeOp(AcamUSRGShowerBase & "StockToBeLeft") = Me.StockToBeLeft
                .AttributeOp(AcamUSRGShowerBase & "RadialAngle") = Me.RadialAngle
                .AttributeOp(AcamUSRGShowerBase & "CuttingMethodBiDir") = Abs(Me.CuttingMethodBiDir)
                .AttributeOp(AcamUSRGShowerBase & "StartCuttingAtHole") = Abs(Me.StartCuttingAtHole)
                .AttributeOp(AcamUSRGShowerBase & "CutAlongProfile") = Abs(Me.CutAlongProfile)
                .AttributeOp(AcamUSRGShowerBase & "Coolant") = Me.Coolant
                .AttributeOp(AcamUSRGShowerBase & "ToolNumber") = Me.ToolNumber
                .AttributeOp(AcamUSRGShowerBase & "OffsetNumber") = Me.OffsetNumber
                .AttributeOp(AcamUSRGShowerBase & "SpindleSpeed") = Me.SpindleSpeed
                .AttributeOp(AcamUSRGShowerBase & "DownFeed") = Me.DownFeed
                .AttributeOp(AcamUSRGShowerBase & "CutFeed") = Me.CutFeed
        End With

End Sub

Public Function GetSettingsFromOp(MD As MillData) As Boolean
        
        Dim blnRet                  As Boolean
        
        ' IMPORTANT: Get the appropriate user setting values from MillData
        '            attributes. These values will be used when the operation
        '            is edited or updated by the user, as well as when a
        '            Machining Style created from this add-in is applied.
        '
        '            It's important to note that these values are being retrieved from the
        '            MillData's "AttributOp" property, rather than its "Attribute" property.
        '
        '            SEE ALSO: SaveSettingsToOp above
        
        blnRet = False
        
        If (MD Is Nothing) Then GoTo Controlled_Exit
        
        With MD
                Me.SafeRapid = .AttributeOp(AcamUSRGShowerBase & "SafeRapid")
                Me.RapidTo = .AttributeOp(AcamUSRGShowerBase & "RapidTo")
                Me.MaterialTop = .AttributeOp(AcamUSRGShowerBase & "MaterialTop")
                Me.DepthAtProfile = .AttributeOp(AcamUSRGShowerBase & "DepthAtProfile")
                Me.DepthAtHole = .AttributeOp(AcamUSRGShowerBase & "DepthAtHole")
                Me.StepAlongProfile = .AttributeOp(AcamUSRGShowerBase & "StepAlongProfile")
                Me.StockToBeLeft = .AttributeOp(AcamUSRGShowerBase & "StockToBeLeft")
                Me.RadialAngle = .AttributeOp(AcamUSRGShowerBase & "RadialAngle")
                Me.CuttingMethodBiDir = CBool(.AttributeOp(AcamUSRGShowerBase & "CuttingMethodBiDir"))
                Me.StartCuttingAtHole = CBool(.AttributeOp(AcamUSRGShowerBase & "StartCuttingAtHole"))
                Me.CutAlongProfile = CBool(.AttributeOp(AcamUSRGShowerBase & "CutAlongProfile"))
                Me.Coolant = .AttributeOp(AcamUSRGShowerBase & "Coolant")
                Me.ToolNumber = .AttributeOp(AcamUSRGShowerBase & "ToolNumber")
                Me.OffsetNumber = .AttributeOp(AcamUSRGShowerBase & "OffsetNumber")
                Me.SpindleSpeed = .AttributeOp(AcamUSRGShowerBase & "SpindleSpeed")
                Me.DownFeed = .AttributeOp(AcamUSRGShowerBase & "DownFeed")
                Me.CutFeed = .AttributeOp(AcamUSRGShowerBase & "CutFeed")
        End With
        
        blnRet = True
        
Controlled_Exit:
        
        GetSettingsFromOp = blnRet

Exit Function

ErrTrap:
        
        blnRet = False
        Resume Controlled_Exit

End Function

Public Sub SaveSettingsToReg()
        
On Error Resume Next
        
        ' INFO: Save the last used values to the registry.
        '
        '       This is NOT required for associative operations
        '       and is simply done so these values can be
        '       restored the next time the add-in is run.
        '
        '       SEE ALSO: GetSettingsFromReg below

        With Me
                
                If Not (.Tool Is Nothing) Then Call g_SaveSetting("LastTool", .Tool.FileName, , True)
                
                Call g_SaveSetting("ToolNumber", .ToolNumber)
                Call g_SaveSetting("OffsetNumber", .OffsetNumber)
                Call g_SaveSetting("SpindleSpeed", .SpindleSpeed)
                Call g_SaveSetting("DownFeed", .DownFeed)
                Call g_SaveSetting("CutFeed", .CutFeed)
                
                Call g_SaveSetting("MaterialTop", .MaterialTop)
                Call g_SaveSetting("RapidTo", .RapidTo)
                Call g_SaveSetting("SafeRapid", .SafeRapid)
                Call g_SaveSetting("DepthAtProfile", .DepthAtProfile)
                Call g_SaveSetting("DepthAtHole", .DepthAtHole)
                Call g_SaveSetting("StepAlongProfile", .StepAlongProfile)
                Call g_SaveSetting("StockToBeLeft", .StockToBeLeft)
                Call g_SaveSetting("RadialAngle", .RadialAngle)
                Call g_SaveSetting("CuttingMethodBiDir", Abs(.CuttingMethodBiDir))
                Call g_SaveSetting("StartCuttingAtHole", Abs(.StartCuttingAtHole))
                Call g_SaveSetting("CutAlongProfile", Abs(.CutAlongProfile))
                Call g_SaveSetting("Coolant", .Coolant)
                        
        End With
        
End Sub

Public Sub GetSettingsFromReg()

On Error Resume Next

        ' INFO: Restore the last used values from the registry.
        '
        '       This is NOT required for associative operations
        '       and is simply done so that the last values used
        '       are restored as the defaults when the add-in is run.
        '
        '       SEE ALSO: SaveSettingsToReg above
        
        With Me
                
                m_sLastTool = gv_GetSetting("LastTool", vbNullString, , , True)

                .ToolNumber = gv_GetSetting("ToolNumber", 1, alphaVarType_LONG)
                .OffsetNumber = gv_GetSetting("OffsetNumber", 1, alphaVarType_LONG)
                .SpindleSpeed = gv_GetSetting("SpindleSpeed", 0, alphaVarType_DOUBLE)
                .DownFeed = gv_GetSetting("DownFeed", 0, alphaVarType_DOUBLE)
                .CutFeed = gv_GetSetting("CutFeed", 0, alphaVarType_DOUBLE)
                                                
                If Not (App.GetCurrentTool Is Nothing) Then Call Me.UpdateToolProps(App.GetCurrentTool)
                
                .MaterialTop = gv_GetSetting("MaterialTop", 0, alphaVarType_DOUBLE)
                .RapidTo = gv_GetSetting("RapidTo", App.MachiningDefaults.RapidDownTo, alphaVarType_DOUBLE)
                .SafeRapid = gv_GetSetting("SafeRapid", App.MachiningDefaults.SafeRapidLevel, alphaVarType_DOUBLE)
                .DepthAtProfile = gv_GetSetting("DepthAtProfile", 0, alphaVarType_BOOLEAN)
                .DepthAtHole = gv_GetSetting("DepthAtHole", 0, alphaVarType_DOUBLE)
                .StepAlongProfile = gv_GetSetting("StepAlongProfile", 0, alphaVarType_DOUBLE)
                .StockToBeLeft = gv_GetSetting("StockToBeLeft", 0, alphaVarType_DOUBLE)
                .RadialAngle = gv_GetSetting("RadialAngle", 0, alphaVarType_DOUBLE)
                .CuttingMethodBiDir = gv_GetSetting("CuttingMethodBiDir", 1, alphaVarType_BOOLEAN)
                .StartCuttingAtHole = gv_GetSetting("StartCuttingAtHole", 1, alphaVarType_BOOLEAN)
                .CutAlongProfile = gv_GetSetting("CutAlongProfile", 0, alphaVarType_BOOLEAN)
                .Coolant = gv_GetSetting("Coolant", acamCoolNONE, alphaVarType_INTEGER)
        
        End With
        
End Sub

Public Sub UpdateToolProps(MT As MillTool)
        
On Error Resume Next
        
        If Not (MT Is Nothing) Then
                
                With Me
                
                        Set .Tool = MT

                        If (StrComp(m_sLastTool, .Tool.FileName, vbTextCompare) <> 0) Then
                                
                                m_sLastTool = .Tool.FileName
                                
                                .ToolNumber = .Tool.Number
                                .OffsetNumber = .Tool.OffsetNumber
                        
                                If (.Tool.FixedSpeed = 0) Then
                                        .SpindleSpeed = (App.ActiveDrawing.GetMaterial.Speed * 1000) / (3.14 * .Tool.Diameter)
                                        .CutFeed = (.SpindleSpeed * .Tool.FeedPerTooth)
                                        .DownFeed = (.CutFeed / 4)
                                Else
                                        .SpindleSpeed = .Tool.FixedSpeed
                                        .CutFeed = .Tool.FixedFeed
                                        .DownFeed = .Tool.FixedDownFeed
                                End If
                        
                        End If
                        
                End With
        
        End If
                
End Sub

Private Sub Class_Initialize()
                
On Error Resume Next
        
        ' INFO: Set the last used settings as defaults
        
        Call Me.GetSettingsFromReg
                
End Sub

Private Sub Class_Terminate()

On Error Resume Next
        
        Set Me.Tool = Nothing

End Sub

