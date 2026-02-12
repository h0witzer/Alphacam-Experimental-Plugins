Attribute VB_Name = "Attributes"
Option Explicit

Const ATTR1 As String = "LicomUKdmbManualExampleTest1"
Const ATTR2 As String = "LicomUKdmbManualExampleTest2"

Public Sub AttributeExample1()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing

    Dim PS As Paths
    Dim P1 As Path
    
    Dim X As Double
    Dim CH As Integer
    X = 0.5
    For CH = Asc("A") To Asc("E")
        Set PS = Drw.CreateText(Chr(CH), X, 0, 10)
        For Each P1 In PS
            P1.Attribute(ATTR1) = Chr(CH)
            P1.Attribute(ATTR2) = X
        Next P1
        X = X + 20
    Next CH
    Drw.ZoomAll
End Sub

Public Sub AttributeExample2()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing

    Dim P1 As Path
    Do
        Set P1 = Drw.UserSelectOneGeo("Select a Geometry")
        If P1 Is Nothing Then
            Exit Do
        End If
        
        Dim V As Variant
        V = P1.Attribute(ATTR1)
        ' Test to see if the attribute has been set
        If VarType(V) <> vbEmpty Then
            MsgBox V
        End If
    Loop
End Sub

