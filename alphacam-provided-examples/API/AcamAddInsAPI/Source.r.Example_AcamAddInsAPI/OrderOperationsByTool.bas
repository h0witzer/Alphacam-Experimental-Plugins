Attribute VB_Name = "OrderOperationsByTool"
Option Explicit

Public Sub RunOrderOperationsByTool()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.ToolOrdering
    
On Error GoTo ErrTrap
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetToolOrderingAddIn
    
    ' Apply a already create Tool Ordering List
    Dim bResult As Boolean
    bResult = oAddIn.Apply("Your Tool Ordering list name")
    If (bResult = False) Then
        MsgBox "Failed to Apply Tool Ordering List"
    End If
            
Controlled_Exit:

    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub
