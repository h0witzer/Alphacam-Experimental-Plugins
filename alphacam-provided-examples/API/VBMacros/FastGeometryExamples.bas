Attribute VB_Name = "FastGeometryExamples"
Option Explicit

Public Sub FastGeoEx1()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    
    Dim FastGeo As FastGeometry
    Set FastGeo = Drw.CreateFastGeometry
    
    With FastGeo
        .KnownArc 50, True, 0, 0, 90
        .ArcToArc 20, False, False
        .KnownArc 25, True, 100, 10
        .LineToLineBlend 5, , -50, 260  ' X unknown
        .CloseAndFinish
    End With
    
    Drw.ZoomAll
End Sub
