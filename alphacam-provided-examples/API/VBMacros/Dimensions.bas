Attribute VB_Name = "Module1"
Option Explicit


Public Sub Aligned2Points()
    App.New
    With App.ActiveDrawing
        .Create2DLine 50, 20, 200, 70
        .Font = "AStencil"
        With .Dimension
            .TextPosition = acamDimCENTER
            .TextAlignment = acamDimHORIZONTAL
            .TextHeight = 6
            .ArrowLength = 4
            .CreateAligned 50, 20, 200, 70, 300, 110, 150, 75
        End With
        .ZoomAll
    End With
End Sub

Public Sub Diameter()
    App.New
    With App.ActiveDrawing
        Dim P As Path
        Set P = .CreateCircle(100, 0, 0)
        .Font = "AStencil"
        With .Dimension
            .TextAlignment = acamDimALIGNED
            .TextPosition = acamDimABOVE_LINE
            .CreateDiameter P.Elements(1), -100, -60, -10, -10
        End With
        .ZoomAll
    End With
End Sub
Public Sub Radius()
    App.New
    With App.ActiveDrawing
        Dim P As Path
        Dim E As Element
        Set P = .CreateCircle(100, 0, 0)
        Set E = P.Elements(1)
        .Font = "AStencil"
        With .Dimension
            .TextAlignment = acamDimALIGNED
            .TextPosition = acamDimABOVE_LINE
            .MarkRadsWithR = True
            .CreateRadius E, E.CenterXL + E.Radius * 1.3, E.CenterYL + E.Radius * 0.5, 10, 5
        End With
        .ZoomAll
    End With
End Sub

Public Sub AlignedArc()
    App.New
    With App.ActiveDrawing
        Dim G2 As Geo2D
        Set G2 = .Create2DGeometry(-50, 10)
        G2.AddArc2Point 50, 50, 150, 20
        Dim P As Path, E As Element
        Set P = G2.Finish
        Set E = P.Elements(1)
        .Font = "AStencil"
        With .Dimension
            .TextPosition = acamDimCENTER
            .TextAlignment = acamDimALIGNED
            .TextHeight = 6
            .ArrowLength = 4
            .Gap = 1
            .CreateAlignedArc E, 50, 0, 0, 0
        End With
        .ZoomAll
    End With
End Sub

Public Sub Angle()
    App.New
    With App.ActiveDrawing
        Dim P1 As Path, P2 As Path
        Set P1 = .Create2DLine(0, 0, 50, 0)
        Set P2 = .Create2DLine(0, 0, 10, 60)
        .Font = "AStencil"
        With .Dimension
            .TextPosition = acamDimCENTER
            .TextAlignment = acamDimALIGNED
            .TextHeight = 6
            .ArrowLength = 4
            .Gap = 1
            .CreateAngle P1.Elements(1), P2.Elements(1), -60, 45, 30, 30
        End With
        .ZoomAll
    End With
End Sub

Public Sub Point()
    App.New
    With App.ActiveDrawing
        Dim P As Path
        Set P = .Create2DLine(0, 0, 50, 0)
        .Font = "AStencil"
        With .Dimension
            .TextPosition = acamDimCENTER
            .TextAlignment = acamDimALIGNED
            .CreatePoint P.Elements(1).EndXL, P.Elements(1).EndYL, 200, 50
        End With
        .ZoomAll
    End With
End Sub

Public Sub MaxXX()
    With App.ActiveDrawing
        Dim PS As Paths
        Set PS = .UserSelectMultiGeosCollection("MaxXX Dimension: Select Geometries", 0)
        If PS.Count = 0 Then Exit Sub
        Dim X1 As Double, Y1 As Double, X2 As Double, Y2 As Double
        PS.GetExtentL X1, Y1, X2, Y2
        .Font = "AStencil"
        With .Dimension
            .TextPosition = acamDimCENTER
            .TextAlignment = acamDimALIGNED
            .CreateMaxXX PS, (X1 + X2) * 0.5, Y2 + 50
        End With
        .ZoomAll
    End With
End Sub

Public Sub MaxYY()
    With App.ActiveDrawing
        Dim PS As Paths
        Set PS = .UserSelectMultiGeosCollection("MaxYY Dimension: Select Geometries", 0)
        .Font = "AStencil"
        With .Dimension
            .TextPosition = acamDimCENTER
            .TextAlignment = acamDimHORIZONTAL
            .TextHeight = 6
            .ArrowLength = 4
            .Gap = 1
            .TrailingZeroes = False
            .DecimalPlacesLinear = 2
            .CreateMaxYY PS, 70, 90, 30, 30
        End With
        .ZoomAll
    End With
End Sub

Public Sub XOrdinate()
    App.New
    With App.ActiveDrawing
        With .Dimension
            .SetOrdinateReference 50, 150
            .CreateXOrdinate 0, 40, 100
            .CreateXOrdinate 100, 50, 100
            .CreateXOrdinate 120, 50, 100
            .CreateXOrdinate 140, 50, 100
        End With
        .ZoomAll
    End With
End Sub

Public Sub YOrdinate()
    App.New
    With App.ActiveDrawing
        With .Dimension
            .SetOrdinateReference 50, 50
            .CreateYOrdinate 0, 40, 100
            .CreateYOrdinate 50, 50, 100
            .CreateYOrdinate 100, 50, 100
            .CreateYOrdinate 120, 50, 100
            .CreateYOrdinate 140, 50, 100
        End With
        .ZoomAll
    End With
End Sub

Public Sub HorizontalLine()
App.New
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim P As Path
    Set P = Drw.Create2DLine(-50, 10, 50, 10)
    Dim E As Element
    Set E = P.Elements(1)
    With Drw.Dimension
        .TextHeight = 5
        .ArrowLength = 3
        .TextPosition = acamDimABOVE_LINE
        .CreateHorizontal E.StartXL, E.StartYL, E.EndXL, E.EndYL, _
        (E.StartXL + E.EndXL) * 0.5, E.EndYL + 20
    End With
    Drw.ZoomAll
End Sub

Public Sub Horizontal2Circles()
App.New
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim P1 As Path, P2 As Path
    Set P1 = Drw.CreateCircle(50, 0, 0)
    Set P2 = Drw.CreateCircle(50, 100, 0)
    With Drw.Dimension
        .TextHeight = 5
        .ArrowLength = 3
        .TextPosition = acamDimABOVE_LINE
        .MarkAsCenter1 = True
        .MarkAsCenter2 = True
        .CreateHorizontal 0, 0, 100, 0, 50, 50
    End With
    Drw.ZoomAll
End Sub

Public Sub Vertical2Points()
App.New
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim P As Path
    Set P = Drw.Create2DLine(0, 0, 0, 40)
    Dim E As Element
    Set E = P.Elements(1)
    With Drw.Dimension
        .TextHeight = 5
        .ArrowLength = 3
        .TextPosition = acamDimABOVE_LINE
        .CreateVertical E.StartXL, E.StartYL, E.EndXL, E.EndYL, _
        E.StartXL - 30, (E.StartYL + E.EndYL) * 0.5
    End With
    Drw.ZoomAll
End Sub

Public Sub LeaderLine()
App.New
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim G As Geo2D
    Dim P As Path
    Set G = Drw.Create2DGeometry(50, 50)
    G.AddLine 100, 100
    G.AddLine 150, 100
    Set P = G.Finish
    With Drw.Dimension
        .ArrowLength = 3
        .CreateLeaderLine P
    End With
    P.Selected = True
    Drw.DeleteSelected
    Drw.ZoomAll
End Sub


