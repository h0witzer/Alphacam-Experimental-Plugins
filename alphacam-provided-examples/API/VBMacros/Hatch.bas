Attribute VB_Name = "Module1"
Option Explicit


Public Sub TestHatchPath()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim P As Path
    Set P = Drw.CreateCircle(100, 0, 0)
    Dim PS As Paths
    Set PS = Drw.HatchPath(P, acamHatchSingle, 60, 5, 10)
End Sub

Public Sub TestHatchPoint()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Drw.CreateCircle 150, 0, 50
    Drw.CreateRectangle 30, 30, 60, 60
    Dim PS As Paths
    Set PS = Drw.HatchPoint(18, 105, acamHatchSingle, 30, 5, 10, 0.5)
End Sub

