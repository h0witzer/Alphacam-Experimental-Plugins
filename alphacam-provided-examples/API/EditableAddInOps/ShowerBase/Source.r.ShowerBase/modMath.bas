Attribute VB_Name = "modMath"
Option Explicit
Option Private Module

' >< ENUM ><
'
Public Enum AlphaIntersectPoint
        alphaIntersect_PARALLEL = -1
        alphaIntersect_NONE = 0
        alphaIntersect_LINE_1 = 1
        alphaIntersect_LINE_2 = 2
        alphaIntersect_BOTH_LINES = 3
End Enum
        
' >< UDT ><
'
Public Type POINT_XYZ
        X                           As Double
        Y                           As Double
        z                           As Double
End Type

Public Type WP_XYZ
        X                           As POINT_XYZ
        Y                           As POINT_XYZ
        z                           As POINT_XYZ
        Origin                      As POINT_XYZ
End Type

Public Type LINE_XYZ
        StartPoint                  As POINT_XYZ    'Starting point (X,Y,Z) on line.
        EndPoint                    As POINT_XYZ    'Ending point (X,Y,Z) on line.
End Type

Public Type ARC_DETAILS
        IsValidArc                  As Boolean      'Is this a valid arc.
        StartPoint                  As POINT_XYZ    'Starting point.
        MidPoint                    As POINT_XYZ    'Mid point.
        EndPoint                    As POINT_XYZ    'Ending point.
        CenterPoint                 As POINT_XYZ    'Center point.
        Radius                      As Double       'Radius.
        StartAngle                  As Double       'Starting angle in radians.
        MidAngle                    As Double       'Mid angle in radians.
        EndAngle                    As Double       'Ending angle in radians.
End Type

' >< CONSTANTS ><
'
Public Const Pi                     As Double = 3.14159265358979
'

Public Function gb_Equal(ByVal dVal1 As Double, ByVal dVal2 As Double, ByVal dTol As Double) As Boolean

        ' return true if the two given values are equal to within a tolerance
        gb_Equal = (Abs(dVal1 - dVal2) <= dTol)

End Function

Public Function gd_GetElementAngle(E As Element) As Double
                        
        Dim LDbl                    As LINE_XYZ
        Dim dblRet                  As Double
        
On Error GoTo ErrTrap
        
        ' capture the start and end points
        With LDbl
                
                With .StartPoint
                        .X = E.StartXL
                        .Y = E.StartYL
                End With
                
                With .EndPoint
                        .X = E.EndXL
                        .Y = E.EndYL
                End With
        
        End With
                                        
        ' calculate the angle of the line according to alphacam
        dblRet = gd_LineAcamAngleDegrees(LDbl)
                                
        'Debug.Print "The angle of the selected element is " & CStr(dblAngle) & "."
        
Controlled_Exit:
        
        gd_GetElementAngle = dblRet
        
Exit Function

ErrTrap:
        
        MsgBox Err.Description, vbExclamation
        dblRet = 0
        Resume Controlled_Exit
        
End Function

Public Function gpt_PointOnLine(ptStart As POINT_XYZ, ptEnd As POINT_XYZ, ByVal dDistance As Double) As POINT_XYZ

        ' Returns a point on a line at dDistance from ptStart.
        ' This point need not be between ptStart and ptEnd.

        Dim dDX                     As Double
        Dim dDY                     As Double
        Dim dLen                    As Double
        Dim dPct                    As Double

        If (dDistance > 1000000) Then dDistance = 1000000

        dLen = gd_Distance(ptStart, ptEnd)
    
        If (dLen > 0) Then
                dDX = (ptEnd.X - ptStart.X)
                dDY = (ptEnd.Y - ptStart.Y)
                dPct = gd_Div(dDistance, dLen)
                gpt_PointOnLine.X = (ptStart.X + (dDX * dPct))
                gpt_PointOnLine.Y = (ptStart.Y + (dDY * dPct))
        Else
                gpt_PointOnLine.X = ptStart.X
                gpt_PointOnLine.Y = ptStart.Y
        End If

End Function

Public Function gd_Div(ByVal dNumer As Double, ByVal dDenom As Double) As Double

        ' Divides 2 numbers avoiding a "Division by zero" error.

        If (dDenom <> 0) Then
                gd_Div = (dNumer / dDenom)
        Else
                gd_Div = 0
        End If

End Function

Public Function garc_CalcArc(Point1 As POINT_XYZ, Point2 As POINT_XYZ, Point3 As POINT_XYZ) As ARC_DETAILS

        'Calculates all data needed to draw an arc from 3 points
        'Returns an ARC_DETAILS UDT
                
        Dim udtRet                  As ARC_DETAILS
        Dim dRads(3)                As Double
        Dim uLine(3)                As LINE_XYZ
        Dim ptCenter                As POINT_XYZ

        'Setup 2 lines using the 3 points.
        uLine(0).StartPoint = Point1
        uLine(0).EndPoint = Point2
        uLine(1).StartPoint = Point2
        uLine(1).EndPoint = Point3

        'Create a perpendicular line from the
        'centers of each of the two lines.
        uLine(2) = gln_PerpLineCenter(uLine(0))
        uLine(3) = gln_PerpLineCenter(uLine(1))

        'If the perp lines don't intersect then the 3 points
        'are on a straight line and cannot be an arc.
        If gi_LineIntersect(uLine(2), uLine(3), ptCenter) <> -1 Then
        
                'If the perp lines intersect then it forms an arc.
                'Setup 3 lines from the center; 1 line to each outer point.
                uLine(0).StartPoint = ptCenter
                uLine(0).EndPoint = Point1
                uLine(1).StartPoint = ptCenter
                uLine(1).EndPoint = Point2
                uLine(2).StartPoint = ptCenter
                uLine(2).EndPoint = Point3
                dRads(0) = gd_LineAngleRadians(uLine(0))
                dRads(1) = gd_LineAngleRadians(uLine(1))
                dRads(2) = gd_LineAngleRadians(uLine(2))

                'An arc is always drawn counter-clockwise, so order the points.
                If Not gb_IsBetween(dRads(1), dRads(0), dRads(2), False) Then
                
                        'dRads(1) is not between dRads(0) and dRads(2),
                        'so the arc must wrap around the 0? mark. This means the
                        'greater of dRads(0) and dRads(2) is the start point.
                        If (dRads(2) > dRads(0)) Then 'Reversed, so swap points.
                                dRads(3) = dRads(0)
                                uLine(3) = uLine(0)
                                dRads(0) = dRads(2)
                                uLine(0) = uLine(2)
                                dRads(2) = dRads(3)
                                uLine(2) = uLine(3)
                        End If
                
                Else
                        
                        'No wrap around, so the lessor of dRads(0)
                        'and dRads(2) is the start point.
                        If (dRads(2) < dRads(0)) Then 'Reversed, so swap points.
                                dRads(3) = dRads(0)
                                uLine(3) = uLine(0)
                                dRads(0) = dRads(2)
                                uLine(0) = uLine(2)
                                dRads(2) = dRads(3)
                                uLine(2) = uLine(3)
                        End If
                
                End If
    
                'Now that the points and angles are all in order, return the data.
                With udtRet
                        .IsValidArc = True
                        .StartPoint = uLine(0).EndPoint
                        .MidPoint = uLine(1).EndPoint
                        .EndPoint = uLine(2).EndPoint
                        .CenterPoint = ptCenter
                        .Radius = gd_Distance(.CenterPoint, .StartPoint)
                        .StartAngle = dRads(0)
                        .MidAngle = dRads(1)
                        .EndAngle = dRads(2)
                End With
    
        Else
        
                'Straight line; Set IsValidArc to False.
                udtRet.IsValidArc = False
    
        End If
        
        garc_CalcArc = udtRet

End Function

Public Function gd_Distance(ptStart As POINT_XYZ, ptEnd As POINT_XYZ) As Double

        'Calculates the distance between 2 points.

        'Standard hypotenuse equation (c = Sqr(a^2 + b^2))
        gd_Distance = Sqr(((ptEnd.X - ptStart.X) ^ 2) + ((ptEnd.Y - ptStart.Y) ^ 2))

End Function

Public Function gd_GetDiagnalDistance(P As Path) As Double
        
        Dim udtMin                  As POINT_XYZ
        Dim udtMax                  As POINT_XYZ
        Dim udtStart                As POINT_XYZ
        Dim udtEnd                  As POINT_XYZ
        Dim dblRet                  As Double
        
        dblRet = 0
        
        If (P Is Nothing) Then GoTo Controlled_Exit
        
        If P.GetFeedExtent(udtMin.X, udtMin.Y, udtMax.X, udtMax.Y) Then
                
                ' convert to global
                Call g_LtoG(P.GetWorkPlane, udtMin.X, udtMin.Y, 0)
                Call g_LtoG(P.GetWorkPlane, udtMax.X, udtMax.Y, 0)
                
                With udtStart
                        .X = udtMin.X
                        .Y = udtMax.Y
                End With
                
                With udtEnd
                        .X = udtMax.X
                        .Y = udtMin.Y
                End With
                
                dblRet = gd_Distance(udtStart, udtEnd)
        
        End If

Controlled_Exit:
        
        gd_GetDiagnalDistance = dblRet

Exit Function

End Function

Public Function gb_IsBetween(ByVal dTestData As Double, ByVal dLowerBound As Double, _
                             ByVal dUpperBound As Double, Optional ByVal bInclusive As Boolean = True) As Boolean

        'Returns True if dTestData is between dLowerBound and dUpperBound.
        'bInclusive = Are the bounds included in the test?

        Dim dTemp                   As Double
        Dim blnRet                  As Boolean
        
        blnRet = False
        
        If (dLowerBound <> dUpperBound) Then
                
                If (dLowerBound > dUpperBound) Then
                        'If bounds are reversed, swap them.
                        dTemp = dLowerBound
                        dLowerBound = dUpperBound
                        dUpperBound = dTemp
                End If
                
                If bInclusive Then
                        'If bounds are included in test (use >= and <=).
                        blnRet = (dTestData >= dLowerBound) And (dTestData <= dUpperBound)
                Else
                        'If bounds are not included in test (use > and <).
                        blnRet = (dTestData > dLowerBound) And (dTestData < dUpperBound)
                End If
                
        End If
        
        gb_IsBetween = blnRet

End Function

Public Function gd_LineAngleDegrees(Line As LINE_XYZ) As Double
    
        'Returns the angle of a line in degrees (see gd_LineAngleRadians).

        Dim dblRet                  As Double

        dblRet = gd_RadiansToDegrees(gd_LineAngleRadians(Line))
        dblRet = PTol(dblRet)
        
        gd_LineAngleDegrees = dblRet

End Function

Public Function gd_LineAcamAngleDegrees(Line As LINE_XYZ) As Double
    
        'Returns the angle of a line in degrees (see gd_LineAngleRadians).
        'We take away from 360 to adapt to Acam polar system

        Dim dblRet                  As Double

        dblRet = gd_RadiansToDegrees(gd_LineAngleRadians(Line))
        dblRet = PTol(dblRet)
        
        If (dblRet <> 0) Then dblRet = (360 - dblRet)
        
        gd_LineAcamAngleDegrees = dblRet

End Function

Public Function gd_LineAngleRadians(Line As LINE_XYZ) As Double

        'Calculates the angle(in radians) of a line from ptStart to ptEnd.
        
        Dim dDeltaX                 As Double
        Dim dDeltaY                 As Double
        Dim dAngle                  As Double
        
        With Line
                dDeltaX = (.EndPoint.X - .StartPoint.X)
                dDeltaY = (.EndPoint.Y - .StartPoint.Y)
        End With

        If (dDeltaX = 0) Then      'Vertical
                If (dDeltaY < 0) Then
                        dAngle = (Pi / 2)
                Else
                        dAngle = (Pi * 1.5)
                End If
        ElseIf (dDeltaY = 0) Then  'Horizontal
                If (dDeltaX >= 0) Then
                    dAngle = 0
                Else
                    dAngle = Pi
                End If
    
        Else    'Angled
        
                'Note: ++ = positive X, positive Y; +- = positive X, negative Y; etc.
                'On a true coordinate plane, Y increases as it move upward.
                'In VB coordinates, Y is reversed. It increases as it moves downward.
        
                'Calc for true Upper Right Quadrant (++) (For VB this is +-)
                dAngle = Atn(Abs(dDeltaY / dDeltaX))            'VB Upper Right (+-)
        
                'Correct for other 3 quadrants in VB coordinates (Reversed Y)
                If (dDeltaX >= 0) And (dDeltaY >= 0) Then       'VB Lower Right (++)
                        dAngle = (Pi * 2) - dAngle
                ElseIf (dDeltaX < 0) And (dDeltaY >= 0) Then    'VB Lower Left (-+)
                        dAngle = (Pi + dAngle)
                ElseIf (dDeltaX < 0) And (dDeltaY < 0) Then     'VB Upper Left (--)
                        dAngle = (Pi - dAngle)
                End If
    
        End If

        gd_LineAngleRadians = dAngle

End Function

Public Function gln_PerpLineCenter(Line As LINE_XYZ) As LINE_XYZ

        'Returns a line perpendicular (90?) to Line1 using
        'the center of Line1 as the first point.
        
        Dim dDeltaX                 As Double
        Dim dDeltaY                 As Double
        Dim Line2                   As LINE_XYZ

        With Line
                Line2.StartPoint.X = ((.StartPoint.X + .EndPoint.X) / 2)
                Line2.StartPoint.Y = ((.StartPoint.Y + .EndPoint.Y) / 2)
                dDeltaX = (Line2.StartPoint.X - .StartPoint.X)
                dDeltaY = (Line2.StartPoint.Y - .StartPoint.Y)
                Line2.EndPoint.X = (Line2.StartPoint.X + -dDeltaY)
                Line2.EndPoint.Y = (Line2.StartPoint.Y + dDeltaX)
        End With
    
        gln_PerpLineCenter = Line2

End Function

Public Function gi_LineIntersect(Line1 As LINE_XYZ, Line2 As LINE_XYZ, ptIntersect As POINT_XYZ) As AlphaIntersectPoint

        'Calculate the intersection point of any two given non-parallel lines.
        '
        'Returns:  -1 = lines are parallel (no intersection).
        '           0 = Neither line contains the intersect point between its points.**
        '           1 = Line1 contains the intersect point between its points.**
        '           2 = Line2 contains the intersect point between its points.**
        '           3 = Both Lines contain the intersect point between their points.**
        '           ** Lines Do intersect; Also fills in the ptIntersect point.
        '

        Dim iReturn                 As AlphaIntersectPoint
        Dim dDenom                  As Double
        Dim dPctDelta1              As Double
        Dim dPctDelta2              As Double
        Dim Delta(2)                As POINT_XYZ
        
        iReturn = alphaIntersect_PARALLEL
        
        'Calculate the Deltas (distance of X2 - X1 or Y2 - Y1 of any 2 points)
        With Line1
                Delta(0).X = (.StartPoint.X - Line2.StartPoint.X)
                Delta(0).Y = (.StartPoint.Y - Line2.StartPoint.Y)
                Delta(1).X = (.EndPoint.X - .StartPoint.X)
                Delta(1).Y = (.EndPoint.Y - .StartPoint.Y)
                Delta(2).X = (Line2.EndPoint.X - Line2.StartPoint.X)
                Delta(2).Y = (Line2.EndPoint.Y - Line2.StartPoint.Y)
        End With

        'Calculate the denominator (zero = parallel (no intersection))
        'Formula: (L2Dy * L1Dx) - (L2Dx * L1Dy)
        dDenom = (Delta(2).Y * Delta(1).X) - (Delta(2).X * Delta(1).Y)

        If (dDenom <> 0) Then
            
                'The lines will intersect somewhere.
                'Solve for both lines using the Cross-Deltas (Delta(0))
    
                'This yields percentage (0.1 = 10%; 1 = 100%) of the distance
                'between ptStart and ptEnd, of the opposite line, where the line used
                'in the calculation will cross it.
                '0 = ptStart direct hit; 1 = ptEnd direct hit; 0.5 = Centered between Pts; etc.
                'If < 0 or > 1 then the lines still intersect, just not between the points.
    
                'Solve for Line1 where Line2 will cross it.
                dPctDelta1 = (((Delta(2).X * Delta(0).Y) - (Delta(2).Y * Delta(0).X)) / dDenom)
    
                'Solve for Line2 where Line1 will cross it.
                dPctDelta2 = (((Delta(1).X * Delta(0).Y) - (Delta(1).Y * Delta(0).X)) / dDenom)
    
                'Check for absolute intersection. If the percentage is not between
                '0 and 1 then the lines will not intersect between their points.
                'Returns 0, 1, 2 or 3.
                iReturn = IIf(gb_IsBetween(dPctDelta1, 0, 1), alphaIntersect_LINE_1, alphaIntersect_NONE) Or _
                          IIf(gb_IsBetween(dPctDelta2, 0, 1), alphaIntersect_LINE_2, alphaIntersect_NONE)
    
                'Calculate point of intersection on Line1 and fill ptIntersect.
                With ptIntersect
                        .X = (Line1.StartPoint.X + (dPctDelta1 * Delta(1).X))
                        .Y = (Line1.StartPoint.Y + (dPctDelta1 * Delta(1).Y))
                End With

        End If

        'Return the results.
        gi_LineIntersect = iReturn

End Function

Public Function gd_RadiansToDegrees(ByVal dRadians As Double) As Double

        ' Converts Radians to Degrees
        gd_RadiansToDegrees = (dRadians * (180 / Pi))

End Function

Public Function gd_DegreesToRadians(ByVal dDegrees As Double) As Double

        ' Converts Degrees to Radians
        gd_DegreesToRadians = (dDegrees * (Pi / 180))

End Function

Public Function gd_Sine(ByVal dVal As Double) As Double

        ' Degree Input Radian Output
        
        Dim dblPi                   As Double
        Dim dblRadian               As Double
        Dim dblRet                  As Double

On Error GoTo ErrTrap

        ' Calculate the value of Pi.
        dblPi = 4 * Atn(1)
        
        ' To convert degrees to radians, multiply degrees by Pi / 180.
        
        dblRadian = (dblPi / 180)
        dblRet = Val(dVal * dblRadian)
        dblRet = sIn(dblRet)
    
Controlled_Exit:
        
        gd_Sine = dblRet
    
Exit Function
    
ErrTrap:
    
        dblRet = 0
        MsgBox Err.Description, vbExclamation
        Resume Controlled_Exit
    
End Function

Public Function gd_Cosine(ByVal dVal As Double) As Double
    
        'Degree Input Radian Output
        
        Dim dblPi                   As Double
        Dim dblRadian               As Double
        Dim dblRet                  As Double
    
On Error GoTo ErrTrap
    
        ' Calculate the value of Pi.
        dblPi = 4 * Atn(1)
        
        ' To convert degrees to radians, multiply degrees by Pi / 180.
        
        dblRadian = (dblPi / 180)
        dblRet = Val(dVal * dblRadian)
        dblRet = Cos(dblRet)
    
Controlled_Exit:
        
        gd_Cosine = dblRet
        
Exit Function

ErrTrap:
    
        dblRet = 0
        MsgBox Err.Description, vbExclamation
        Resume Controlled_Exit

End Function

Public Function gd_ArcCos(ByVal dX As Double) As Double
        
        Dim dblRet                  As Double
        
On Error GoTo ErrTrap

        dblRet = Atn(-dX / Sqr(-dX * dX + 1)) + 2 * Atn(1)

Controlled_Exit:
        
        gd_ArcCos = dblRet

Exit Function

ErrTrap:

        dblRet = (4 * Atn(1))
        Resume Controlled_Exit

End Function

Public Function gd_Tangent(ByVal dVal As Double) As Double

        'Degree Input Radian Output
        
        Dim dblPi                   As Double
        Dim dblRadian               As Double
        Dim dblRet                  As Double
        
On Error GoTo ErrTrap
    
        ' Calculate the value of Pi.
        dblPi = (4 * Atn(1))
        
        ' To convert degrees to radians, multiply degrees by Pi / 180.
        dblRadian = (dblPi / 180)
        dblRet = Val(dVal * dblRadian)
        dblRet = Tan(dblRet)
    
Controlled_Exit:

        gd_Tangent = dblRet

Exit Function

ErrTrap:
    
        dblRet = 0
        MsgBox Err.Description, vbExclamation
        Resume Controlled_Exit

End Function

Public Function gd_InvSinDeg(ByVal dVal As Double) As Double
    
        'Radian Input Degree Output
        
        Dim dblSqr                  As Double
        Dim dblPi                   As Double
        Dim dblDegree               As Double
        Dim dblRet                  As Double

On Error GoTo ErrTrap
    
        ' Calculate the value of Pi.
        dblPi = 4 * Atn(1)
        
        ' To convert radians to degrees, multiply radians by 180/pi.
        dblDegree = (180 / dblPi)
        dblRet = Val(dVal)
        dblSqr = Sqr(-dblRet * dblRet + 1)
        
        ' Prevent division by Zero error
    
        If (dblSqr = 0) Then dblSqr = 1E-30
    
        dblRet = Atn(dblRet / dblSqr) * dblDegree
    
Controlled_Exit:
        
        gd_InvSinDeg = dblRet
        
Exit Function

ErrTrap:
    
        dblRet = 0
        MsgBox Err.Description, vbExclamation
        Resume Controlled_Exit

End Function

Public Function gd_InvCosDeg(ByVal dVal As Double) As Double

        'Radian Input Degree Output
        
        Dim dblSqr                  As Double
        Dim dblPi                   As Double
        Dim dblDegree               As Double
        Dim dblRet                  As Double

On Error GoTo ErrTrap
    
        ' xx Calculate the value of Pi.
        dblPi = (4 * Atn(1))
        
        ' To convert radians to degrees, multiply radians by 180/pi.
        dblDegree = (180 / dblPi)
        dblRet = Val(dVal)
        dblSqr = Sqr(-dblRet * dblRet + 1)
        
        ' Prevent division by Zero error
        If (dblSqr = 0) Then dblSqr = 1E-30
        
        dblRet = (Atn(-dblRet / dblSqr) + 2 * Atn(1)) * dblDegree
    
Controlled_Exit:
        
        gd_InvCosDeg = dblRet
        
Exit Function

ErrTrap:
    
        dblRet = 0
        MsgBox Err.Description, vbExclamation
        Resume Controlled_Exit

End Function

Public Function gd_InvTanDeg(ByVal dVal As Double) As Double

        'Radian Input Degree Output
        
        Dim dblDegree               As Double
        Dim dblRet                  As Double
        
On Error GoTo ErrTrap
        
        ' To convert radians to degrees, multiply radians by 180/pi.
        dblDegree = (180 / Pi)
        dblRet = Val(dVal)
        dblRet = (Atn(dblRet) * dblDegree)
    
Controlled_Exit:
        
        gd_InvTanDeg = dblRet
    
Exit Function

ErrTrap:
    
        dblRet = 0
        MsgBox Err.Description, vbExclamation
        Resume Controlled_Exit

End Function

Public Function gd_SinDeg(ByVal dAngleInDegrees As Double) As Double
        
        ' Returns Sin of degree angle

        gd_SinDeg = sIn(dAngleInDegrees * Pi / 180)
        
End Function

Public Function gd_CosDeg(ByVal dAngleInDegrees As Double) As Double
        
        ' Returns Cosine of degree angle
        
        gd_CosDeg = sIn(dAngleInDegrees * Pi / 180 + Pi / 2)
        
End Function

Public Function gd_ToDec(ByVal sFraction As String) As Double
    
        Dim strFract                As String
        Dim strWhole                As String
        Dim strNum                  As String
        Dim strDen                  As String
        Dim intSlash                As Integer
        Dim intSpace                As Integer
        Dim intLength               As Integer
        Dim dblRet                  As Double
            
On Error GoTo ErrTrap
                
        ' trim off any spaces
        strFract = Trim$(sFraction)
        
        ' replace any dashes
        strFract = Replace$(strFract, "-", Space$(1))
        
        ' get the length of the entire number
        intLength = Len(strFract)
        
        ' make sure we have something
        If (intLength = 0) Then GoTo Controlled_Exit
        
        ' is already just a number? if so return ok and bail
        If IsNumeric(strFract) Then
                dblRet = PDbl(strFract)
                GoTo Controlled_Exit
        End If
        
        ' find the slash in the fraction
        intSlash = InStr(1, strFract, "/")
        
        If (intSlash = 0) Then
                intSlash = InStr(1, strFract, "\")
        End If
        
        ' if still no slash then bail
        If (intSlash = 0) Then
    
                ' find the space between the number and name starting with a number
                intSpace = InStr(1, strFract, " ")
                
                If (intSpace > 0) Then
                        strWhole = Trim$(Mid$(strFract, 1, intSpace))
                        dblRet = PDbl(strWhole)
                        GoTo Controlled_Exit
                End If
                
                ' just bail
                GoTo Controlled_Exit
                
        End If
        
        ' find the space between the whole and the fraction
        intSpace = InStr(1, strFract, " ")
        
        ' lets make sure the space isn't after the slash
        If (intSpace > intSlash) Then
                strFract = Trim$(Left$(strFract, intSpace))
                intSpace = 0
        End If
        
        ' do we have a whole number along with the fraction?
        If (intSpace > 0) Then
                                       
                ' filter out the whole number
                strWhole = Trim$(Mid$(strFract, 1, intSpace))
                
                If Not IsNumeric(strWhole) Then GoTo Controlled_Exit
                
                ' filter out the numerator
                strNum = Trim$(Mid$(strFract, intSpace, (intSlash - intSpace)))
                
                If Not IsNumeric(strNum) Then GoTo Controlled_Exit
    
                ' filter out the demononator
                strDen = Trim$(Mid$(strFract, (intSlash + 1), intLength))
                
                intSpace = InStr(1, strDen, " ", vbTextCompare)
                
                If (intSpace > 0) Then
                        strDen = Trim$(Left$(strDen, intSpace))
                End If
                
                If Not IsNumeric(strDen) Then GoTo Controlled_Exit
                
                ' lets not divide by zero
                If (Abs(PDbl(strNum)) + Abs(PDbl(strDen)) = 0) Then
                
                        ' return only whole number
                        dblRet = PDbl(strWhole)
                        
                Else
                        
                        ' put the three together
                        dblRet = ((PDbl(strWhole) + (PDbl(strNum)) / PDbl(strDen)))
                
                End If
            
        ' no whole, only fraction
        Else
            
                ' filter out the demononator
                strNum = Trim$(Mid$(strFract, 1, (intSlash - 1)))
                
                If Not IsNumeric(strNum) Then GoTo Controlled_Exit
                
                ' filter out the demononator
                strDen = Trim$(Mid$(strFract, (intSlash + 1), (intLength - intSlash)))
                
                If Not IsNumeric(strDen) Then GoTo Controlled_Exit
                
                ' divid the two
                dblRet = PDbl((PDbl(strNum) / PDbl(strDen)))
            
        End If
        
Controlled_Exit:

        gd_ToDec = dblRet

Exit Function

ErrTrap:
        
        dblRet = 0
        Resume Controlled_Exit

End Function

Public Function gs_ToFraction(ByVal dDec As Double) As String
                                    
        ' converts given decimal to fraction out to 32nd of an inch
                            
        Dim intInch                 As Integer
        Dim i                       As Integer
        Dim dblTemp                 As Double
        Dim strRet                  As String

On Error Resume Next

        intInch = Fix(dDec)                     ' whole number is inches
        i = CInt(32 * (dDec - intInch))         ' calc percentage of inches left
    
        ' if I=32 then we've got a whole inch
        If (i = 32) Then
                    
                intInch = (intInch + 1)
                    
        ElseIf (i > 0) Then                     ' break down the 1/32 to larger fraction
                    
                dblTemp = 32
                
                Do Until i Mod 2 > 0
                        i = (i / 2)
                        dblTemp = (dblTemp / 2)
                Loop
                
                strRet = i & "/" & dblTemp
                
        End If
        
        ' tack on the whole number if not zero
        If (intInch <> 0) Then
                strRet = intInch & " " & strRet
        End If
        
        gs_ToFraction = strRet

End Function

Public Function gs_Round(ByVal dVal As Double, ByVal iNumDec As Integer) As String

        Dim strNumZero              As String
        Dim strValue                As String
        Dim strSign                 As String
        Dim dblValue                As Double

        If (dVal < 0) Then
                strSign = "-"
        Else
                strSign = vbNullString
        End If

        dblValue = Int(Abs(10 ^ iNumDec * dVal) + 0.5)
        strNumZero = vbNullString

        If (iNumDec > 0) Then

                If (dblValue < 10 ^ iNumDec) Then
                        strNumZero = String$(Len(str$(10 ^ iNumDec)) - Len(str(dblValue)), "0")
                End If

                strValue = strNumZero & Mid$(str(dblValue), 2)

                strValue = Left$(strValue, Len(strValue) - iNumDec) & _
                          "." & Mid$(strValue, Len(strValue) - iNumDec + 1)

                strValue = gs_NoZeros(strValue)

                If (Right$(strValue, 1) = ".") Then
                        strValue = Left$(strValue, Len(strValue) - 1)
                End If
        Else
                strValue = Mid$(str(dblValue), 2)
        End If

        If PDbl(strValue) = 0 Then strValue = "0"

        gs_Round = strSign & strValue

End Function

Public Function gd_Atan2(ByVal dY As Double, ByVal dX As Double)
        
On Error Resume Next
        
        gd_Atan2 = App.Frame.Evaluate("ATAN2(" & dY & ", " & dX & ")")
        
End Function

Public Function gd_Mod(ByVal dNumber1 As Double, ByVal dNumber2 As Double)
        
On Error Resume Next
        
        gd_Mod = App.Frame.Evaluate("MOD(" & dNumber1 & ", " & dNumber2 & ")")
        
End Function

