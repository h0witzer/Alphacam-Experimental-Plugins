Attribute VB_Name = "SaveSelected"
Option Explicit
'

Public Sub SaveSelected()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.SaveSelected
    
On Error GoTo ErrTrap
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetSaveSelectedAddIn
    
    ' calling .Run will prompt the user to select the items to
    ' save and then ask for a file name. this is the same as when
    ' running the Save Selected... command from within Alphacam.
    
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

Public Sub SaveSelected2()

    Dim Drw As Drawing
    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.SaveSelected
    Dim pthSelected As Path
    Dim strFile As String
    
On Error GoTo ErrTrap
    
    Set Drw = App.ActiveDrawing
    
    ' clear any existing selections just in case
    Call Drw.SetGeosSelected(False)
    
    ' first, lets attempt to get a geometry
    If (Drw.GetGeoCount = 0) Then GoTo Controlled_Exit
    
    Set pthSelected = Drw.Geometries(1)
    
    If (pthSelected Is Nothing) Then GoTo Controlled_Exit
    
    ' select it
    pthSelected.Selected = True
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetSaveSelectedAddIn
    
    ' NOTES: passing a specific Drawing will save the selected
    '        items within that drawing, including temp drawings.
    '        if no Drawing is passed, the active drawing is used.
    '
    '        passing a specific filename will save the selected
    '        items to that file. if no file is passed, the user will be
    '        asked to select one.
    
    strFile = App.LicomdirPath & "LICOMDIR\SaveSelectedVbaExample.ard"
    
    If (oAddIn.SaveSelectedObjects(App.ActiveDrawing, strFile)) Then
        MsgBox "Saved ' " & strFile & "'", vbInformation
    End If
        
Controlled_Exit:
    
    ' ensure all is deselected
    Call App.ActiveDrawing.SetGeosSelected(False)

    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    Set pthSelected = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub
