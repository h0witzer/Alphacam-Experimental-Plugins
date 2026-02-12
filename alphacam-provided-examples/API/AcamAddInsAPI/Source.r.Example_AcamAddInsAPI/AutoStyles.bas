Attribute VB_Name = "AutoStyles"
Option Explicit
'

Public Sub AutoStylesApply()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim AE As AcamAddIns.AcamEx
    Dim oAddIn As AcamAddIns.AutoStyles
    Dim strStylsDir As String
    Dim strAutoStylesFile As String
    Dim Ret As Long
        
On Error GoTo ErrTrap
        
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set AE = AI.GetAcamExInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetAutoStylesAddIn
    
    strStylsDir = AE.GetPathToStyles
    strAutoStylesFile = strStylsDir & "CirclesAndRectangles.ara"
    
    Call oAddIn.Apply(strAutoStylesFile)
        
    ' NOTE: to force the user to select the autostyle file to run
    '       simply call .Apply without passing the FileName argument
    '
    'Call oAddIn.Apply
    
Controlled_Exit:

    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    Set AE = Nothing
    
Exit Sub

ErrTrap:

    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit

End Sub

Public Sub AutoStylesEdit()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim AE As AcamAddIns.AcamEx
    Dim oAddIn As AcamAddIns.AutoStyles
    Dim strStylesDir As String
    Dim strAutoStylesFile As String
        
On Error GoTo ErrTrap
        
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set AE = AI.GetAcamExInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetAutoStylesAddIn
    
    strStylesDir = AE.GetPathToStyles
    strAutoStylesFile = strStylesDir & "CirclesAndRectangles.ara"
    
    Call oAddIn.Edit(strAutoStylesFile)
        
    ' NOTE: to force the user to select the autostyle file to edit
    '       simply call .edit without passing the FileName argument
    '
    'Call oAddIn.Edit
    
Controlled_Exit:

    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    Set AE = Nothing
    
Exit Sub

ErrTrap:

    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit

End Sub

Public Sub AutoStylesCreate()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim AE As AcamAddIns.AcamEx
    Dim oAddIn As AcamAddIns.AutoStyles
    Dim oStyle As AcamAddIns.AutoStylesStyle
    Dim oAutoStyle As AcamAddIns.AutoStylesFile
    Dim strStylesDir As String
    Dim strStyleFile As String
    Dim strAutoStylesFile As String
    Dim intRet As Integer
    
On Error GoTo ErrTrap
        
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set AE = AI.GetAcamExInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetAutoStylesAddIn

    Set oAutoStyle = oAddIn.CreateAutoStylesFile
    
    With oAutoStyle.Settings
        .ClearEmptyWorkPlanes = False
        .RunGeoQuery = True
        .GeoQueryFileName = AE.GetPathToQueries & "CirclesAndRectangles.agqa"
        .OrderNestedToolPaths = True
        .OrderWorkPlanes = False
    End With
    
    strStylesDir = AE.GetPathToStyles
    
    ' add the alphacam machining styles and settings to the autostyle
    '
    ' add the first one via the AddFromFile method
    strStyleFile = strStylesDir & "In.ary"
    
    Call oAutoStyle.AddFromFile(strStyleFile, "Circles", _
        AlphaToolDirectionOpen_NoChange, AlphaToolDirectionClosed_AutoClimb, _
        AlphaToolInOut_Inside, AlphaToolSide_NoChange, AlphaAutoStartPoint_NoChange)
    
    ' add the second one by adding an AutoStylesStyle object
    Set oStyle = New AcamAddIns.AutoStylesStyle
    
    strStyleFile = strStylesDir & "Out.ary"
    
    With oStyle
        .StyleFileName = strStyleFile
        .LayerName = "Rectangles"
        .ToolDirectionClosed = AlphaToolDirectionClosed_AutoClimb
        .ToolDirectionOpen = AlphaToolDirectionOpen_NoChange
        .ToolInOut = AlphaToolInOut_Outside
        .ToolSide = AlphaToolSide_NoChange
        .ToolStartPoint = AlphaAutoStartPoint_BottomLeft
    End With
        
    Call oAutoStyle.Add(oStyle)
    
    ' apply it (if valid)
    If oAutoStyle.IsValid Then
    
        intRet = oAutoStyle.Apply(App.ActiveDrawing)
        
        ' save it, prompt the user for a filename
        If oAutoStyle.Save Then
            
            For Each oStyle In oAutoStyle
                Debug.Print oStyle.StyleFileName
            Next oStyle
        
        End If
        
        ' NOTE: can also save to a specific file using SaveAs
        '
        'If oAddIn.GetAutoStylesFileName(AlphaFileAction_Open, "", strAutoStylesFile) Then
        '    Call oAutoStyle.SaveAs(strAutoStylesFile)
        'End If
    
    End If
    
Controlled_Exit:

    Set oAddIn = Nothing
    Set oAutoStyle = Nothing
    Set oStyle = Nothing
    Set AA = Nothing
    Set AI = Nothing
    Set AE = Nothing
    
Exit Sub

ErrTrap:

    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit

End Sub
