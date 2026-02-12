Attribute VB_Name = "SplitNest"
Option Explicit
'

Public Sub SplitSheets()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.SplitNest
    Dim oFiles As AcamAddIns.FileInformationCollection
    Dim oFile As AcamAddIns.FileInformation
    
On Error GoTo ErrTrap
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetSplitNestAddIn
    
    ' NOTES: passing a specific Drawing will split and save the
    '        sheets within that drawing, including temp drawings.
    '        if no Drawing is passed, the active drawing is used.
    '
    '        passing a specific Folder will save the drawings to
    '        that folder. if the folder does not exist, it will
    '        be created. if no Folder is passed, the user will be
    '        asked to select one.
    
    Set oFiles = oAddIn.SaveSheets
            
    If Not (oFiles Is Nothing) Then
        
        Debug.Print "Saved " & oFiles.Count & " files."
        
        For Each oFile In oFiles
            Debug.Print oFile.FullName
        Next oFile
    
    End If
            
Controlled_Exit:

    Set oAddIn = Nothing
    Set oFiles = Nothing
    Set oFile = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub

Public Sub SplitParts()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.SplitNest
    Dim oFiles As AcamAddIns.FileInformationCollection
    Dim oFile As AcamAddIns.FileInformation
    
On Error GoTo ErrTrap

    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetSplitNestAddIn
    
    ' NOTES: passing a specific Drawing will split and save the
    '        sheets within that drawing, including temp drawings.
    '        if no Drawing is passed, the active drawing is used.
    '
    '        passing a specific Folder will save the drawings to
    '        that folder. if the folder does not exist, it will
    '        be created. if no Folder is passed, the user will be
    '        asked to select one.
        
    Set oFiles = oAddIn.SaveParts
            
    If Not (oFiles Is Nothing) Then
        
        Debug.Print "Saved " & oFiles.Count & " files."
        
        For Each oFile In oFiles
            Debug.Print oFile.FullName
        Next oFile
    
    End If
    
Controlled_Exit:

    Set oAddIn = Nothing
    Set oFiles = Nothing
    Set oFile = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
Exit Sub
    
ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub
