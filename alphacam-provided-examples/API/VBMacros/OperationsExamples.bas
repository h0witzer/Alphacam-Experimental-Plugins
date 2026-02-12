Attribute VB_Name = "OperationsExamples"
Option Explicit

' Show tool for each operation and name of each sub-operation, and highlight the tool paths

Public Sub ShowOperations()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    
    Dim Ops As Operations
    Set Ops = Drw.Operations
    
    Dim Op As Operation
    For Each Op In Ops
        MsgBox "Op No. " & Op.Number & vbCr & "Tool = " & Op.Tool.Name
        Dim SubOp As SubOperation
        For Each SubOp In Op.SubOperations
            SubOp.ToolPaths.Selected = True
            Drw.Redraw
            MsgBox "Sub-op Name: " & SubOp.Name
            SubOp.ToolPaths.Selected = False
            Drw.Redraw
        Next SubOp
    Next Op
End Sub

' Change stock for operation 1 and regenerate tool paths

Public Sub EditOperation1()
    App.OpenDrawing App.LicomdirPath & "licomdir\Tutorial\Mill Simple Shape + tool paths.amd"

    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
        
    Dim SubOp As SubOperation
    Set SubOp = Drw.Operations(1).SubOperations(1)
    
    Dim MD As MillData
    Set MD = SubOp.GetMillData
'    MsgBox "Process Type = " & MD.ProcessType
    
    MD.Stock = 2
    
    SubOp.SetMillData MD
End Sub

' Change operation 2 from Drilling to Pecking

Public Sub EditOperation2()
'    App.OpenDrawing App.LicomdirPath & "licomdir\Tutorial\Mill Simple Shape + tool paths.amd"

    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
        
    Dim SubOp As SubOperation
    Set SubOp = Drw.Operations(2).SubOperations(1)
    
    Dim MD As MillData
    Set MD = SubOp.GetMillData
'    MsgBox "Process Type = " & MD.ProcessType
    
    MD.DrillType = acamPECK
    MD.PeckDistance = 1
    
    SubOp.SetMillData MD
End Sub

' Change the geometry for operation 3 and regenerate the tool paths

Public Sub EditOperation3()
'    App.OpenDrawing App.LicomdirPath & "licomdir\Tutorial\Mill Simple Shape + tool paths.amd"

    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
        
    Dim SubOp As SubOperation
    Set SubOp = Drw.Operations(3).SubOperations(1)
    
    Dim P As Path
    Set P = SubOp.Geometries(1)
    P.ScaleL 1.5, P.Elements(1).CenterXL, P.Elements(1).CenterYL
    
    ' To regenerate the tool paths after the geometries are changed
    ' just get and set the MillData object
    
    Dim MD As MillData
    Set MD = SubOp.GetMillData
'    MsgBox "Process Type = " & MD.ProcessType
    SubOp.SetMillData MD
End Sub

' Move tool paths in an operation to the current work plane
' This will move any tool path, even 3D surface machining.
' It is up to the user to ensure that the post and machine are capable of handling the tool paths

Public Sub MoveToolPathsToWorkPlane()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    
    Dim WP As WorkPlane
    Set WP = Drw.GetWorkPlane
    
    If WP Is Nothing Then
        MsgBox "No work plane selected"
        End
    End If
    
    Dim OpNum As Long
    If Not App.Frame.InputIntegerDialog("Move Operation to Work Plane", "Operation number to move", acamFloatPOSITIVE, OpNum) Then
        End
    End If
    
    Dim Ops As Operations
    Set Ops = Drw.Operations
    
    Dim SOP As SubOperation
    For Each SOP In Ops(OpNum).SubOperations
        MsgBox SOP.Name
        Dim P As Path
        For Each P In SOP.ToolPaths
            P.SetWorkPlane WP
            P.Redraw
        Next P
    Next SOP
End Sub

' Renumber operations with the same tool. The Operations object is
' invalid after each renumber method call, so the function ReNumberOneOp
' is used. When it renumbers an operation it returns, destroying the object.
' It is then recreated in the Do While Loop.
' The loop is repeated until no more could be renumbered.

Public Sub ReNumber()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    
    Do While ReNumberOneOp(Drw.Operations)  ' recreate Operations object after each renumber
    Loop
End Sub

' Helper function for ReNumber

Private Function ReNumberOneOp(Ops As Operations) As Boolean
    Dim I As Integer, J As Integer
    For I = 1 To Ops.Count
        For J = I + 1 To Ops.Count
            If Ops(I).Tool.Number = Ops(J).Tool.Number Then
'                MsgBox "Trying to renumber " & I & " and " & J
                Ops.ReNumber J, I, acamOpADD_TO_OPERATION
                ReNumberOneOp = True
                Exit Function
            End If
        Next J
    Next I
    ReNumberOneOp = False
End Function

