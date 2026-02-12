Attribute VB_Name = "Project3Dto2D"
Option Explicit
'

Public Sub Project3Dto2D()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.Project3Dto2D
    
On Error GoTo ErrTrap
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetProject3Dto2DAddIn
    
    ' calling .Run will display the settings dialog and project
    ' all 3D geos within the active drawing. this is the same as
    ' running the Project 3D to 2D command from within Alphacam.
    
    Call oAddIn.Run
        
Controlled_Exit:

    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub

Public Sub Project3Dto2D2()

    Dim Drw As Drawing
    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim AE As AcamAddIns.AcamEx
    Dim objFile As AcamAddIns.FileInformation
    Dim oAddIn As AcamAddIns.Project3Dto2D
    Dim strFileName As String
    Dim strFullName As String
    Dim strNewFullName As String
    
On Error GoTo ErrTrap
    
    If Not App.GetAlphaCamFileName("Select Drawing", acamFileTypeDRAWING, acamFileActionOPEN, strFullName, strFileName) Then
        GoTo Controlled_Exit
    End If
    
    ' open the selected drawing as a temp drawing
    Set Drw = App.OpenTempDrawing(strFullName)
    
    If (Drw Is Nothing) Then GoTo Controlled_Exit
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set AE = AI.GetAcamExInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetProject3Dto2DAddIn
        
    With oAddIn
        
        ' setup required settings
        With .Settings
            .ChordToleranceForArcs = 0.1
            .ClearGeometryZLevels = True
            .ConvertSplines = False ' True
            .ConvertSplinesJoinLinesArcs = True
            .ConvertSplinesTolerance = 0.1
            .DeleteWorkVolume = True
            .StepLength = 2
            .VisibleGeometriesOnly = False
        End With
        
        ' project...
        If .Project(Drw) Then
            
            ' save the results to a different file
            Set objFile = AE.GetFileInformation(strFullName)
            
            strNewFullName = objFile.FullNameWithoutExtension & "_PROJECT3DTO2D" & objFile.Extension
            
            Call Drw.SaveAs(strNewFullName)
            
            If (MsgBox("Open resulting drawing?", vbQuestion + vbYesNo) = vbYes) Then
                Call App.OpenDrawing(strNewFullName)
            End If
            
        End If
        
    End With
    
Controlled_Exit:
    

    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    Set Drw = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub

