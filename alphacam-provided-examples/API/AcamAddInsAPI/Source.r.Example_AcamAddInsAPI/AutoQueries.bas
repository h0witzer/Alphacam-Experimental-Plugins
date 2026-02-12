Attribute VB_Name = "AutoQueries"
Option Explicit
'

Public Sub AutoQueriesRun()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim AE As AcamAddIns.AcamEx
    Dim oAddIn As AcamAddIns.AutoQueries
    Dim strQueryDir As String
    Dim strAutoQueryFile As String
        
On Error GoTo ErrTrap
        
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set AE = AI.GetAcamExInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetAutoQueriesAddIn
    
    strQueryDir = AE.GetPathToQueries
    strAutoQueryFile = strQueryDir & "CirclesAndRectangles.agqa"
    
    Call oAddIn.Run(strAutoQueryFile)
        
    ' NOTE: to force the user to select the autoquery file to run
    '       simply call .Run without passing the FileName argument
    '
    'Call oAddIn.Run
    
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

Public Sub AutoQueriesEdit()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim AE As AcamAddIns.AcamEx
    Dim oAddIn As AcamAddIns.AutoQueries
    Dim strQueryDir As String
    Dim strAutoQueryFile As String
        
On Error GoTo ErrTrap
        
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set AE = AI.GetAcamExInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetAutoQueriesAddIn
    
    strQueryDir = AE.GetPathToQueries
    strAutoQueryFile = strQueryDir & "CirclesAndRectangles.agqa"
    
    Call oAddIn.Edit(strAutoQueryFile)
        
    ' NOTE: to force the user to select the autoquery file to edit
    '       simply call .Edit without passing the FileName argument
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

Public Sub AutoQueriesCreate()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim AE As AcamAddIns.AcamEx
    Dim oAddIn As AcamAddIns.AutoQueries
    Dim oAutoQuery As AcamAddIns.AutoQueriesFile
    Dim strQueryDir As String
    Dim strQueryFile As String
    Dim strAutoQueryFile As String
        
On Error GoTo ErrTrap
        
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set AE = AI.GetAcamExInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetAutoQueriesAddIn

    Set oAutoQuery = oAddIn.CreateAutoQueriesFile
    
    strQueryDir = AE.GetPathToQueries
    
    ' add the alphacam geometry query files to the autoquery
    strQueryFile = strQueryDir & "Circles.agq"
    Call oAutoQuery.AddFromFile(strQueryFile)
    
    strQueryFile = strQueryDir & "Rectangles.agq"
    Call oAutoQuery.AddFromFile(strQueryFile)
    
    ' run it
    Call oAutoQuery.RunAutoQuery(App.ActiveDrawing)
    
    ' undo it
    Call App.ActiveDrawing.Undo
    
    ' move the the rectangles query to be the first and run it again
    If oAutoQuery.MoveUpInRunningOrder(2) Then
        Call oAutoQuery.RunAutoQuery(App.ActiveDrawing)
    End If
    
    ' save it, prompt the user for a filename
    Call oAutoQuery.Save
    
    ' NOTE: can also save to a specific file using SaveAs
    '
    'If oAddIn.GetAutoQueryFileName(AlphaFileAction_Open, "", strAutoQueryFile) Then
    '    Call oAutoQuery.SaveAs(strAutoQueryFile)
    'End If
    
Controlled_Exit:

    Set oAddIn = Nothing
    Set oAutoQuery = Nothing
    Set AA = Nothing
    Set AI = Nothing
    Set AE = Nothing
    
Exit Sub

ErrTrap:

    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit

End Sub

