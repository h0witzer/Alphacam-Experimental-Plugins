Attribute VB_Name = "ReverseSideNesting"
Option Explicit

Public Sub ReverseSideNesting()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.ReverseSideNesting
    
On Error GoTo ErrTrap
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetReverseSideNestingAddIn
    
    ' *************************************************************************************
    ' Open a valid nested drawing with suitable reverse side nested components defined here
    ' *************************************************************************************
    
    ' calling .Run will display the settings dialog and reverse nest
    'oAddIn.Run False
    
    ' the full call to apply reverse side nesting to the current drawing
    oAddIn.ApplyReverseSideNesting ReverseSideNestingMachiningOrder_ReverseSideFirst, ReverseSideNestingSheetOrdering_BySide, ReverseSideNestingSheetTurning_YAxis, False, False, False, False, False, "", 0, ""
        
Controlled_Exit:

    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub

