Attribute VB_Name = "Module1"
Option Explicit

Public Sub TestRubberBandLine()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim X1 As Double, Y1 As Double
    Dim X3 As Double, Y3 As Double
    Drw.UserGet2DPoint "Line: First Point", X1, Y1
    Do
        Dim Ret As Integer
        Ret = Drw.UserGet2DPointWithRubberBand("Line: Next Point", AcamRubberBandLINE, X1, Y1, 0, 0, X3, Y3)
        If Ret = acamUserSELECT Then
            Dim P As Path
            Set P = Drw.Create2DLine(X1, Y1, X3, Y3)
            P.Selected = True   ' for Join command at end
            X1 = X3
            Y1 = Y3
        End If
    Loop Until Ret <> acamUserSELECT
    Drw.Join
End Sub

Public Sub TestRubberBandArcCentre()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim X1 As Double, Y1 As Double, X2 As Double, Y2 As Double
    Dim X3 As Double, Y3 As Double
    Drw.UserGet2DPoint "Arc: Start Point", X1, Y1
    Drw.UserGet2DPoint "Arc: Centre", X2, Y2
    Dim Ret As Integer
    Ret = Drw.UserGet2DPointWithRubberBand("Arc: End Point", AcamRubberBandARC_CENTER, X1, Y1, X2, Y2, X3, Y3)
    If Ret = acamUserSELECT Then
        ' Draw an arc, there are 2 possibilities, choose the one less than 180 degrees
        Dim G2 As Geo2D
        Set G2 = Drw.Create2DGeometry(X1, Y1)
        G2.AddArcPointCenter X3, Y3, X2, Y2, False
        Dim P As Path
        Set P = G2.Finish
        If P.GetFirstElem.IncludedAngle > 180 Then
            P.Selected = True
            Drw.DeleteSelected
            Set G2 = Drw.Create2DGeometry(X1, Y1)
            G2.AddArcPointCenter X3, Y3, X2, Y2, True
            G2.Finish
        End If
    End If
End Sub

Public Sub TestRubberBandCircle()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim X1 As Double, Y1 As Double, X2 As Double, Y2 As Double
    Dim X3 As Double, Y3 As Double
    Drw.UserGet2DPoint "Circle: Centre", X1, Y1
    Dim Ret As Integer
    Ret = Drw.UserGet2DPointWithRubberBand("Circle: Point", AcamRubberBandCIRCLE, X1, Y1, 0, 0, X3, Y3)
    If Ret = acamUserSELECT Then
        Dim Dia As Double
        Dia = Sqr((X3 - X1) ^ 2 + (Y3 - Y1) ^ 2) * 2
        Dim P As Path
        Set P = Drw.CreateCircle(Dia, X1, Y1)
    End If
End Sub

Public Sub TestRubberBandRectangle()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim X1 As Double, Y1 As Double, X2 As Double, Y2 As Double
    Dim X3 As Double, Y3 As Double
    Drw.UserGet2DPoint "Rectangle: First Point", X1, Y1
    Dim Ret As Integer
    Ret = Drw.UserGet2DPointWithRubberBand("Rectangle: Second Point", AcamRubberBandRECTANGLE, X1, Y1, 0, 0, X3, Y3)
    If Ret = acamUserSELECT Then
        Dim P As Path
        Set P = Drw.CreateRectangle(X1, Y1, X3, Y3)
        X1 = X3
        Y1 = Y3
    End If
End Sub

Public Sub TestRubberBand2Lines()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim X1 As Double, Y1 As Double, X2 As Double, Y2 As Double
    Dim X3 As Double, Y3 As Double
    Drw.UserGet2DPoint "Line1:", X1, Y1
    Drw.UserGet2DPoint "Line2:", X2, Y2
    Dim Ret As Integer
    Ret = Drw.UserGet2DPointWithRubberBand("Lines: Midpoint", AcamRubberBand2LINES, X1, Y1, X2, Y2, X3, Y3)
    If Ret = acamUserSELECT Then
        Dim P As Path
        Set P = Drw.Create2DLine(X1, Y1, X3, Y3)
        P.Selected = True
        Set P = Drw.Create2DLine(X3, Y3, X2, Y2)
        P.Selected = True
        X1 = X3
        Y1 = Y3
    End If
End Sub

Public Sub TestRubberBandArc3Points()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim X1 As Double, Y1 As Double, X2 As Double, Y2 As Double
    Dim X3 As Double, Y3 As Double
    Drw.UserGet2DPoint "Arc: Point 1:", X1, Y1
    Drw.UserGet2DPoint "Arc: Point 2:", X2, Y2
    
    Dim Ret As Integer
    Ret = Drw.UserGet2DPointWithRubberBand("Arc: Point 3", AcamRubberBandARC_3POINTS, X1, Y1, X2, Y2, X3, Y3)
    If Ret = acamUserSELECT Then
        Dim G2 As Geo2D
        Set G2 = Drw.Create2DGeometry(X1, Y1)
        G2.AddArc2Point X2, Y2, X3, Y3
        G2.Finish
    End If
End Sub

Public Sub TestRubberBandArc2PointsCentre()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim X1 As Double, Y1 As Double, X2 As Double, Y2 As Double
    Dim X3 As Double, Y3 As Double
    Drw.UserGet2DPoint "Arc: Point 1:", X1, Y1
    Drw.UserGet2DPoint "Arc: Point 2:", X2, Y2
    
    Dim Ret As Integer
    Ret = Drw.UserGet2DPointWithRubberBand("Arc: Point 3", AcamRubberBandARC_2POINTS_CENTER, X1, Y1, X2, Y2, X3, Y3)
    If Ret = acamUserSELECT Then
        Dim G2 As Geo2D
        Set G2 = Drw.Create2DGeometry(X1, Y1)
        G2.AddArcPointCenter X2, Y2, X3, Y3, False
        G2.Finish
    End If
End Sub

