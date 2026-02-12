VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CBoringData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' IMPORTANT: CBoringData
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
Private Const AcamUSRGBoring2DLine  As String = "_AcamUSRGBoring2DLine_"

Private m_sLastTool                 As String

Public Tool                         As MillTool
Public SafeRapid                    As Double
Public RapidTo                      As Double
Public MaterialTop                  As Double
Public BottomAtLineEndpoint         As Boolean
Public BottomOfHole                 As Double
Public Pecking                      As Boolean
Public PeckDistance                 As Double
Public PeckRetractPartial           As Boolean
Public HoleCenterZShift             As Double
Public DwellTime                    As Double
Public TraverseAtRPlane             As Boolean
Public DepthAtShoulder              As Boolean
Public Coolant                      As AcamCoolant
Public ToolNumber                   As Long
Public OffsetNumber                 As Long
Public SpindleSpeed                 As Double
Public DrillFeed                    As Double
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
                .AttributeOp(AcamUSRGBoring2DLine & "SafeRapid") = Me.SafeRapid
                .AttributeOp(AcamUSRGBoring2DLine & "RapidTo") = Me.RapidTo
                .AttributeOp(AcamUSRGBoring2DLine & "MaterialTop") = Me.MaterialTop
                .AttributeOp(AcamUSRGBoring2DLine & "BottomAtLineEndpoint") = Abs(Me.BottomAtLineEndpoint)
                .AttributeOp(AcamUSRGBoring2DLine & "BottomOfHole") = Me.BottomOfHole
                .AttributeOp(AcamUSRGBoring2DLine & "Pecking") = Abs(Me.Pecking)
                .AttributeOp(AcamUSRGBoring2DLine & "PeckDistance") = Me.PeckDistance
                .AttributeOp(AcamUSRGBoring2DLine & "PeckRetractPartial") = Abs(Me.PeckRetractPartial)
                .AttributeOp(AcamUSRGBoring2DLine & "HoleCenterZShift") = Me.HoleCenterZShift
                .AttributeOp(AcamUSRGBoring2DLine & "DwellTime") = Me.DwellTime
                .AttributeOp(AcamUSRGBoring2DLine & "TraverseAtRPlane") = Abs(Me.TraverseAtRPlane)
                .AttributeOp(AcamUSRGBoring2DLine & "DepthAtShoulder") = Abs(Me.DepthAtShoulder)
                .AttributeOp(AcamUSRGBoring2DLine & "Coolant") = Me.Coolant
                .AttributeOp(AcamUSRGBoring2DLine & "ToolNumber") = Me.ToolNumber
                .AttributeOp(AcamUSRGBoring2DLine & "OffsetNumber") = Me.OffsetNumber
                .AttributeOp(AcamUSRGBoring2DLine & "SpindleSpeed") = Me.SpindleSpeed
                .AttributeOp(AcamUSRGBoring2DLine & "DrillFeed") = Me.DrillFeed
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
                Me.SafeRapid = .AttributeOp(AcamUSRGBoring2DLine & "SafeRapid")
                Me.RapidTo = .AttributeOp(AcamUSRGBoring2DLine & "RapidTo")
                Me.MaterialTop = .AttributeOp(AcamUSRGBoring2DLine & "MaterialTop")
                Me.BottomAtLineEndpoint = CBool(.AttributeOp(AcamUSRGBoring2DLine & "BottomAtLineEndpoint"))
                Me.BottomOfHole = .AttributeOp(AcamUSRGBoring2DLine & "BottomOfHole")
                Me.Pecking = CBool(.AttributeOp(AcamUSRGBoring2DLine & "Pecking"))
                Me.PeckDistance = .AttributeOp(AcamUSRGBoring2DLine & "PeckDistance")
                Me.PeckRetractPartial = CBool(.AttributeOp(AcamUSRGBoring2DLine & "PeckRetractPartial"))
                Me.HoleCenterZShift = .AttributeOp(AcamUSRGBoring2DLine & "HoleCenterZShift")
                Me.DwellTime = .AttributeOp(AcamUSRGBoring2DLine & "DwellTime")
                Me.TraverseAtRPlane = CBool(.AttributeOp(AcamUSRGBoring2DLine & "TraverseAtRPlane"))
                Me.DepthAtShoulder = CBool(.AttributeOp(AcamUSRGBoring2DLine & "DepthAtShoulder"))
                Me.Coolant = .AttributeOp(AcamUSRGBoring2DLine & "Coolant")
                Me.ToolNumber = .AttributeOp(AcamUSRGBoring2DLine & "ToolNumber")
                Me.OffsetNumber = .AttributeOp(AcamUSRGBoring2DLine & "OffsetNumber")
                Me.SpindleSpeed = .AttributeOp(AcamUSRGBoring2DLine & "SpindleSpeed")
                Me.DrillFeed = .AttributeOp(AcamUSRGBoring2DLine & "DrillFeed")
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
                Call g_SaveSetting("DrillFeed", .DrillFeed)
                Call g_SaveSetting("MaterialTop", .MaterialTop)
                Call g_SaveSetting("RapidTo", .RapidTo)
                Call g_SaveSetting("SafeRapid", .SafeRapid)
                Call g_SaveSetting("DepthAtShoulder", Abs(.DepthAtShoulder))
                Call g_SaveSetting("TraverseAtRPlane", Abs(.TraverseAtRPlane))
                Call g_SaveSetting("BottomAtLineEndPoint", Abs(.BottomAtLineEndpoint))
                Call g_SaveSetting("DwellTime", .DwellTime)
                Call g_SaveSetting("Pecking", Abs(.Pecking))
                Call g_SaveSetting("PeckRetractPartial", Abs(.PeckRetractPartial))
                Call g_SaveSetting("PeckDistance", .PeckDistance)
                Call g_SaveSetting("Coolant", .Coolant)
        
        End With
        
End Sub

Public Sub GetSettingsFromReg()

        ' INFO: Restore the last used values from the registry.
        '
        '       This is NOT required for associative operations
        '       and is simply done so that the last values used
        '       are restored as the defaults when the add-in is run.
        '
        '       SEE ALSO: SaveSettingsToReg above
        With Me
                                                                
                m_sLastTool = gv_GetSetting("LastTool", vbNullString, , , True)

                .BottomOfHole = 0
                .HoleCenterZShift = 0

                .ToolNumber = gv_GetSetting("ToolNumber", 1, alphaVarType_LONG)
                .OffsetNumber = gv_GetSetting("OffsetNumber", 1, alphaVarType_LONG)
                .SpindleSpeed = gv_GetSetting("SpindleSpeed", 0, alphaVarType_DOUBLE)
                .DrillFeed = gv_GetSetting("DrillFeed", 0, alphaVarType_DOUBLE)
                                                
                If Not (App.GetCurrentTool Is Nothing) Then Call Me.UpdateToolProps(App.GetCurrentTool)
                
                .MaterialTop = gv_GetSetting("MaterialTop", 0, alphaVarType_DOUBLE)
                .RapidTo = gv_GetSetting("RapidTo", App.MachiningDefaults.RapidDownTo, alphaVarType_DOUBLE)
                .SafeRapid = gv_GetSetting("SafeRapid", App.MachiningDefaults.SafeRapidLevel, alphaVarType_DOUBLE)
                .DepthAtShoulder = gv_GetSetting("DepthAtShoulder", 0, alphaVarType_BOOLEAN)
                .TraverseAtRPlane = gv_GetSetting("TraverseAtRPlane", 0, alphaVarType_BOOLEAN)
                .BottomAtLineEndpoint = gv_GetSetting("BottomAtLineEndPoint", 0, alphaVarType_BOOLEAN)
                .DwellTime = gv_GetSetting("DwellTime", 0, alphaVarType_DOUBLE)
                
                .Pecking = gv_GetSetting("Pecking", 0, alphaVarType_BOOLEAN)
                .PeckRetractPartial = gv_GetSetting("PeckRetractPartial", 0, alphaVarType_BOOLEAN)
                .PeckDistance = gv_GetSetting("PeckDistance", 0, alphaVarType_DOUBLE)
                                            
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
                                        .DrillFeed = (.SpindleSpeed * .Tool.FeedPerTooth)
                                Else
                                        .SpindleSpeed = .Tool.FixedSpeed
                                        .DrillFeed = .Tool.FixedFeed
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
