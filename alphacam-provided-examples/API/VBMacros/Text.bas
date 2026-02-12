Attribute VB_Name = "Module1"
Option Explicit


Public Sub SearchForString(SearchStr As String)
    Dim T As Text
    For Each T In App.ActiveDrawing.Text
        Dim L As TextLine
        For Each L In T.Lines
            Dim S As String
            S = L.Text
            If StrComp(S, SearchStr) = 0 Then
                T.Selected = True
                T.Redraw
                MsgBox S
                T.Selected = False
                T.Redraw
            End If
        Next L
    Next T
End Sub

Public Sub TestSearch()
    SearchForString "abc"
End Sub

Public Sub InsertText()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim PS As Paths
    Set PS = Drw.CreateText("Geometry", 0, 40, 10)
    Dim T As Text
    Set T = Drw.CreateText2("Text", 0, 20, 10)
    Set T = Drw.CreateText2("Italic Text", 0, 0, 10)
    T.Erase
    T.Font = "TArial"
    T.Italic = True
    T.Redraw
End Sub

Public Sub EditText()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim T As Text
    Set T = Drw.CreateText2("Text", 0, 50, 10)
    MsgBox "Pause"
    T.Erase
    T.Lines(1).Text = "Edited Text"
    T.Redraw
    T.AddText "New Line"
End Sub

Public Sub TextAlongPath()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    
    Dim G As Geo2D
    Dim P As Path
    Set G = Drw.Create2DGeometry(0, 0)
    G.AddArcPointRadius 50, 0, 75, True, False
    Set P = G.Finish
    
    Drw.CreateTextAlongPath2 "AlphaCAM", P, acamJustifySCALED, 3, 0.2
    
    Drw.ZoomAll
End Sub

