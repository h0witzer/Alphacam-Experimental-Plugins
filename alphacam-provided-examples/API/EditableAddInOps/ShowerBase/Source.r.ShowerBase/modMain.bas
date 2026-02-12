Attribute VB_Name = "modMain"
Option Explicit
Option Private Module

' IMPORTANT: The two constants below are used as flags to identify the
'            hole and profile geometries when associating the MillData
'            and updating an opereration. The values of these constants
'            can be any number as long as they are different from one another.
'
'            See modMain.m_SetAssociativity to see how these are written
'            and Events.UpdateOpShowerBase to see how they are read.
'
Public Const ID_GEO_HOLE            As Long = 1
Public Const ID_GEO_PROFILE         As Long = 2
'

Public Function gps_BidirectionalAlongProfile(MD As MillData, ByVal bStartAtHole As Boolean, eFirstHoleElem As Element, pProfile As Path, _
                                              ByVal dStepOver As Double, ByVal dProfileDepth As Double, ByVal dHoleDepth As Double) As Paths
        
        Dim Drw                     As Drawing
        Dim MTP                     As MillManualToolPath
        Dim Elem                    As Element
        Dim E                       As Element
        Dim pthBroken               As Path
        Dim pthsRet                 As Paths
        Dim dblProfileLen           As Double
        Dim dblCenterX              As Double
        Dim dblCenterY              As Double
        Dim dblDist                 As Double
        Dim dblXp                   As Double
        Dim dblYp                   As Double
        Dim dblProfileModCheck      As Double
        Dim dblStepOverModCheck     As Double
        Dim lngSteps                As Long
        Dim lngRet                  As Long
        Dim blnInHole               As Boolean
        Dim blnPointOnProfile       As Boolean
        
On Error GoTo ErrTrap

        Set Drw = App.ActiveDrawing

        With eFirstHoleElem
                dblCenterX = .CenterXL
                dblCenterY = .CenterYL
        End With
        
        dblProfileLen = pProfile.Length
        
        If (App.GetCurrentTool.Units = 1) Then
                dblProfileModCheck = (dblProfileLen * 25.4)
                dblStepOverModCheck = (dStepOver * 25.4)
        Else
                dblProfileModCheck = dblProfileLen
                dblStepOverModCheck = dStepOver
        End If
        
        If (dblProfileModCheck Mod dblStepOverModCheck <> 0) Then
                lngSteps = (Int(dblProfileLen / dStepOver) + 1)
                dStepOver = (dblProfileLen / lngSteps)
        Else
                lngSteps = (dblProfileLen / dStepOver)
        End If
        
        If bStartAtHole Then
                Set MTP = MD.ManualToolPath(dblCenterX, dblCenterY, dHoleDepth)
                Call MTP.Add3DLine(pProfile.GetFirstElem.StartXL, pProfile.GetFirstElem.StartYL, dProfileDepth)
                blnInHole = False
        Else
                Set MTP = MD.ManualToolPath(pProfile.GetFirstElem.StartXL, pProfile.GetFirstElem.StartYL, dProfileDepth)
                Call MTP.Add3DLine(dblCenterX, dblCenterY, dHoleDepth)
                blnInHole = True
        End If
        
        Do
        
                blnPointOnProfile = pProfile.PointAtDistanceAlongPathL(dStepOver, dblXp, dblYp, Elem)
                
                Set pthBroken = pProfile.BreakAtPoint(dblXp, dblYp)
                
                If Not (pthBroken Is Nothing) Then
                            
                        If blnInHole Then
                        
                                Call MTP.Add3DLine(dblXp, dblYp, dProfileDepth)
                                blnInHole = False
                                
                        Else
                        
                                For Each E In pProfile.Elements
                                        If E.IsLine Then
                                                Call MTP.Add3DLine(E.EndXL, E.EndYL, dProfileDepth)
                                        ElseIf E.IsArc Then
                                                Call MTP.Add3DArcPointRadius(E.EndXL, E.EndYL, dProfileDepth, E.Radius, E.CW, False)
                                        End If
                                Next E
                                
                                blnInHole = True
                                
                                Call MTP.Add3DLine(dblCenterX, dblCenterY, dHoleDepth)
                                
                        End If
                        
                        Call pProfile.Delete
                        
                        Set pProfile = pthBroken
                        
                Else
                        
                        If blnInHole Then
                                
                                Call MTP.Add3DLine(pProfile.GetLastElem.EndXL, pProfile.GetLastElem.EndYL, dProfileDepth)
                        
                        Else
                                
                                For Each E In pProfile.Elements
                                        If E.IsLine Then
                                                Call MTP.Add3DLine(E.EndXL, E.EndYL, dProfileDepth)
                                        ElseIf E.IsArc Then
                                                Call MTP.Add3DArcPointRadius(E.EndXL, E.EndYL, dProfileDepth, E.Radius, E.CW, False)
                                        End If
                                Next E
                        
                        End If
                        
                        Call pProfile.Delete
                        
                        Exit Do
                        
                End If
                
        Loop
        
        Set pthsRet = MTP.Finish
        
Controlled_Exit:
            
        Set gps_BidirectionalAlongProfile = pthsRet
        
        Set Drw = Nothing
        Set MTP = Nothing
        Set E = Nothing
        Set Elem = Nothing
        Set pthBroken = Nothing
        Set pthsRet = Nothing
        
Exit Function

ErrTrap:
        
        MsgBox Err.Description, vbExclamation
        Resume Controlled_Exit
        
End Function

Public Function gps_BidirectionalRadial(MD As MillData, bStartAtHole As Boolean, eFirstHoleElem As Element, pProfile As Path, _
                                 ByVal dRadialAngle As Double, ByVal dProfileDepth As Double, ByVal dHoleDepth As Double) As Paths
        
        Dim Drw                     As Drawing
        Dim MTP                     As MillManualToolPath
        Dim E                       As Element
        Dim pthBroken               As Path
        Dim pthsRet                 As Paths
        Dim dblCenterX              As Double
        Dim dblCenterY              As Double
        Dim dblDist                 As Double
        Dim dblXp                   As Double
        Dim dblYp                   As Double
        Dim dblProfileStartX        As Double
        Dim dblProfileStartY        As Double
        Dim dblAngleIncrement       As Double
        Dim dblAngle                As Double
        Dim dblAngleAtZ             As Double
        Dim dblCheck                As Double
        Dim varXint                 As Variant
        Dim varYint                 As Variant
        Dim lngRet                  As Long
        Dim lngN                    As Long
        Dim blnInHole               As Boolean
        
On Error GoTo ErrTrap

        Set Drw = App.ActiveDrawing
                
        With pProfile.GetFirstElem
                dblProfileStartX = .StartXL
                dblProfileStartY = .StartYL
        End With
        
        With eFirstHoleElem
                dblCenterX = .CenterXL
                dblCenterY = .CenterYL
        End With
        
        dblAngleAtZ = gd_DegreesToRadians(Arcotan(dblProfileStartY - dblCenterY, dblProfileStartX - dblCenterX))
        
        If (pProfile.CW = 1) Then
                dblAngleIncrement = (gd_DegreesToRadians(dRadialAngle) * (-1))
        Else
                dblAngleIncrement = gd_DegreesToRadians(dRadialAngle)
        End If
        
        If bStartAtHole Then
                Set MTP = MD.ManualToolPath(dblCenterX, dblCenterY, dHoleDepth)
                Call MTP.Add3DLine(pProfile.GetFirstElem.StartXL, pProfile.GetFirstElem.StartYL, dProfileDepth)
                blnInHole = False
        Else
                Set MTP = MD.ManualToolPath(pProfile.GetFirstElem.StartXL, pProfile.GetFirstElem.StartYL, dProfileDepth)
                Call MTP.Add3DLine(dblCenterX, dblCenterY, dHoleDepth)
                blnInHole = True
        End If
        
        dblAngle = 0
        
        Do
                
                dblAngle = (dblAngle + dblAngleIncrement)
                
                lngN = pProfile.IntersectWithLine(dblCenterX, dblCenterY, dblCenterX + 100 * Cos(dblAngleAtZ + dblAngle), _
                                                  dblCenterY + 100 * sIn(dblAngleAtZ + dblAngle), False, varXint, varYint)
                
                If (lngN <> 0) Then Set pthBroken = pProfile.BreakAtPoint(varXint(0), varYint(0))
                
                dblCheck = 6.28
                
                If (Abs(dblAngle) < dblCheck) Then
                                
                        If blnInHole Then
                        
                                Call MTP.Add3DLine(varXint(0), varYint(0), dProfileDepth)
                                blnInHole = False
                                
                        Else
                                
                                For Each E In pProfile.Elements
                                        If E.IsLine Then
                                                Call MTP.Add3DLine(E.EndXL, E.EndYL, dProfileDepth)
                                        ElseIf E.IsArc Then
                                                Call MTP.Add3DArcPointRadius(E.EndXL, E.EndYL, dProfileDepth, E.Radius, E.CW, False)
                                        End If
                                Next E
                                
                                blnInHole = True
                                Call MTP.Add3DLine(dblCenterX, dblCenterY, dHoleDepth)
                                
                        End If
                        
                        Call pProfile.Delete
                        Set pProfile = pthBroken
                        
                Else
                        
                        If Not blnInHole Then
                                
                                For Each E In pProfile.Elements
                                        If E.IsLine Then
                                                Call MTP.Add3DLine(E.EndXL, E.EndYL, dProfileDepth)
                                        ElseIf E.IsArc Then
                                                Call MTP.Add3DArcPointRadius(E.EndXL, E.EndYL, dProfileDepth, E.Radius, E.CW, False)
                                        End If
                                Next E
                                
                        End If
                        
                        Call pProfile.Delete
                        
                        Exit Do
                        
                End If
        Loop
        
        Set pthsRet = MTP.Finish
        
Controlled_Exit:
                
        Set gps_BidirectionalRadial = pthsRet
        
        Set Drw = Nothing
        Set pthBroken = Nothing
        Set E = Nothing
        Set MTP = Nothing
        Set pthsRet = Nothing
        
Exit Function

ErrTrap:
        
        MsgBox Err.Description, vbExclamation
        Resume Controlled_Exit
        
End Function

Public Function gps_OneWayAlongProfile(MD As MillData, ByVal bStartAtHole As Boolean, eFirstHoleElem As Element, _
                                pProfile As Path, ByVal dStepOver As Double, ByVal dProfileDepth As Double, ByVal dHoleDepth As Double) As Paths
                
        Dim MTP                     As MillManualToolPath
        Dim pthsRet                 As Paths
        Dim pthsTmp                 As Paths
        Dim P                       As Path
        Dim E                       As Element
        Dim dblLength               As Double
        Dim dblCenterX              As Double
        Dim dblCenterY              As Double
        Dim dblDist                 As Double
        Dim dblXp                   As Double
        Dim dblYp                   As Double
        Dim dblProfileModCheck      As Double
        Dim dblStepOverModCheck     As Double
        Dim lngSteps                As Long
        Dim lngRet                  As Long
        Dim blnFound                As Boolean
        
On Error GoTo ErrTrap
        
        With eFirstHoleElem
                dblCenterX = .CenterXL
                dblCenterY = .CenterYL
        End With
        
        dblLength = pProfile.Length
        
        If (App.GetCurrentTool.Units = 1) Then
                dblProfileModCheck = (dblLength * 25.4)
                dblStepOverModCheck = (dStepOver * 25.4)
        Else
                dblProfileModCheck = dblLength
                dblStepOverModCheck = dStepOver
        End If
        
        If (dblProfileModCheck Mod dblStepOverModCheck <> 0) Then
                lngSteps = ((dblLength / dStepOver) + 1)
                dStepOver = (dblLength / lngSteps)
        End If
        
        Set pthsRet = App.ActiveDrawing.CreatePathCollection
        
        For dblDist = 0 To dblLength Step dStepOver
                
                blnFound = pProfile.PointAtDistanceAlongPathL(dblDist, dblXp, dblYp, E)
                
                If blnFound Then
                
                        If bStartAtHole Then
                                Set MTP = MD.ManualToolPath(dblCenterX, dblCenterY, dHoleDepth)
                                Call MTP.Add3DLine(dblXp, dblYp, dProfileDepth)
                                Set pthsTmp = MTP.Finish
                        Else
                                Set MTP = MD.ManualToolPath(dblXp, dblYp, dProfileDepth)
                                Call MTP.Add3DLine(dblCenterX, dblCenterY, dHoleDepth)
                                Set pthsTmp = MTP.Finish
                        End If
                        
                        If Not (pthsTmp Is Nothing) Then
                                For Each P In pthsTmp
                                        Call pthsRet.Add(P)
                                Next P
                        End If
                        
                Else
                        Exit For
                End If
                
        Next dblDist
        
Controlled_Exit:
        
        Set gps_OneWayAlongProfile = pthsRet
        
        Set MTP = Nothing
        Set E = Nothing
        Set P = Nothing
        Set pthsTmp = Nothing
        Set pthsRet = Nothing
        
Exit Function

ErrTrap:
        
        MsgBox Err.Description, vbExclamation
        Set pthsRet = Nothing
        Resume Controlled_Exit
        
End Function

Public Function gps_OneWayRadial(MD As MillData, ByVal bStartAtHole As Boolean, eFirstHoleElem As Element, _
                          pProfile As Path, ByVal dRadialAngle As Double, ByVal dProfileDepth As Double, ByVal dHoleDepth As Double) As Paths
        
        Dim Drw                     As Drawing
        Dim MTP                     As MillManualToolPath
        Dim pthBroken               As Path
        Dim pthsRet                 As Paths
        Dim pthsTmp                 As Paths
        Dim P                       As Path
        Dim dblCenterX              As Double
        Dim dblCenterY              As Double
        Dim dblDist                 As Double
        Dim dblXp                   As Double
        Dim dblYp                   As Double
        Dim dblAngleIncrement       As Double
        Dim dblAngle                As Double
        Dim dblAngleAtZ             As Double
        Dim dblStartX               As Double
        Dim dblStartY               As Double
        Dim dblCheck                As Double
        Dim varXint                 As Variant
        Dim varYint                 As Variant
        Dim lngRet                  As Long
        Dim lngN                    As Long
                        
On Error GoTo ErrTrap
                        
        Set Drw = App.ActiveDrawing

        With pProfile.GetFirstElem
                dblStartX = .StartXL
                dblStartY = .StartYL
        End With
        
        With eFirstHoleElem
                dblCenterX = .CenterXL
                dblCenterY = .CenterYL
        End With
        
        dblAngleAtZ = gd_DegreesToRadians(Arcotan(dblStartY - dblCenterY, dblStartX - dblCenterX))
        
        If (pProfile.CW = 1) Then
                dblAngleIncrement = (gd_DegreesToRadians(dRadialAngle) * (-1))
        Else
                dblAngleIncrement = gd_DegreesToRadians(dRadialAngle)
        End If
        
        dblAngle = 0
        
        Set pthsTmp = Drw.CreatePathCollection
        
        Do
        
                dblAngle = (dblAngle + dblAngleIncrement)
                
                lngN = pProfile.IntersectWithLine(dblCenterX, dblCenterY, dblCenterX + 100 * Cos(dblAngleAtZ + dblAngle), _
                                                  dblCenterY + 100 * sIn(dblAngleAtZ + dblAngle), False, varXint, varYint)
                
                If (lngN <> 0) Then Set pthBroken = pProfile.BreakAtPoint(varXint(0), varYint(0))
                
                dblCheck = 6.28
                                
                If (Abs(dblAngle) < dblCheck) Then
                        
                        If bStartAtHole Then
                                Set MTP = MD.ManualToolPath(dblCenterX, dblCenterY, dHoleDepth)
                                Call MTP.Add3DLine(varXint(0), varYint(0), dProfileDepth)
                                Set pthsTmp = MTP.Finish
                        Else
                                Set MTP = MD.ManualToolPath(varXint(0), varYint(0), dProfileDepth)
                                Call MTP.Add3DLine(dblCenterX, dblCenterY, dHoleDepth)
                                Set pthsTmp = MTP.Finish
                        End If
                        
                        If Not (pthsTmp Is Nothing) Then
                                For Each P In pthsTmp
                                        Call pthsRet.Add(P)
                                Next P
                        End If
                                                
                        Call pProfile.Delete
                        
                        Set pProfile = pthBroken
                        
                Else
                        
                        If bStartAtHole Then
                                Set MTP = MD.ManualToolPath(dblCenterX, dblCenterY, dHoleDepth)
                                Call MTP.Add3DLine(pProfile.GetLastElem.EndXL, pProfile.GetLastElem.EndYL, dProfileDepth)
                                Set pthsTmp = MTP.Finish
                        Else
                                Set MTP = MD.ManualToolPath(pProfile.GetLastElem.EndXL, pProfile.GetLastElem.EndYL, dProfileDepth)
                                Call MTP.Add3DLine(dblCenterX, dblCenterY, dHoleDepth)
                                Set pthsTmp = MTP.Finish
                        End If
                        
                        If Not (pthsTmp Is Nothing) Then
                                For Each P In pthsTmp
                                        Call pthsRet.Add(P)
                                Next P
                        End If
                                                
                        Call pProfile.Delete
                        
                        Exit Do
                        
                End If
        Loop
        
Controlled_Exit:

        Set gps_OneWayRadial = pthsRet

        Set MTP = Nothing
        Set Drw = Nothing
        Set pthBroken = Nothing
        Set P = Nothing
        Set pthsTmp = Nothing
        Set pthsRet = Nothing

Exit Function

ErrTrap:
        
        MsgBox Err.Description, vbExclamation
        Resume Controlled_Exit
        
End Function

Public Function Arcotan(dblSeno As Double, dblCoseno As Double)
        
        Dim dblAngolo               As Double
        Dim dblToll                 As Double
        
        dblToll = 0.00001
        
        Select Case True
        
                Case (Abs(dblSeno) < dblToll And dblCoseno > 0): dblAngolo = 0
                Case (Abs(dblSeno) < dblToll And dblCoseno < 0): dblAngolo = 180
                Case (Abs(dblCoseno) < dblToll And dblSeno > 0): dblAngolo = 90
                Case (Abs(dblCoseno) < dblToll And dblSeno < 0): dblAngolo = -90
                Case (dblCoseno < 0)
                        
                        If (dblSeno > 0) Then
                                dblAngolo = 180 + Atn(dblSeno / dblCoseno) * (180 / Pi)
                        Else
                                dblAngolo = -180 + Atn(dblSeno / dblCoseno) * (180 / Pi)
                        End If
                        
                Case Else: dblAngolo = Atn(dblSeno / dblCoseno) * (180 / Pi)
        
        End Select
        
        Arcotan = dblAngolo
        
End Function

Public Function gb_DoShowerBase(SBD As CShowerBaseData, MD As MillData, pHole As Path, pProfile As Path) As Boolean

        Dim Drw                     As Drawing
        Dim pthsOffset              As Paths
        Dim PS                      As Paths
        Dim dblStepAlongProfile     As Double
        Dim dblRadialAngle          As Double
        Dim dblToolRadius           As Double
        Dim dblProfileDepth         As Double
        Dim dblHoleDepth            As Double
        Dim dblStartZ               As Double
        Dim dblStock                As Double
        Dim blnExitLoop             As Boolean
        Dim blnBidirectional        As Boolean
        Dim blnStartAtHole          As Boolean
        Dim blnCutAlongProfile      As Boolean
        Dim blnRet                  As Boolean
        Dim lngRet                  As Long

On Error GoTo ErrTrap
        
        Set Drw = App.ActiveDrawing
        
        blnExitLoop = False
        blnRet = False
        
        With SBD
                
                dblToolRadius = (App.GetCurrentTool.Diameter / 2)
        
                dblStepAlongProfile = .StepAlongProfile
                dblRadialAngle = .RadialAngle
                blnBidirectional = .CuttingMethodBiDir
                blnStartAtHole = .StartCuttingAtHole
                blnCutAlongProfile = .CutAlongProfile
                        
                dblStartZ = pHole.GetFirstElem.StartZG
                dblProfileDepth = (dblStartZ + .DepthAtProfile)
                dblHoleDepth = (dblStartZ + .DepthAtHole)
                dblStock = .StockToBeLeft
                
        End With
                        
        Call App.Frame.ShowProgressBox(DEF_APP_TITLE, PText(70, 1, "Applying toolpath, please wait..."))

        ' deselect all before we delete anything
        Call Drw.SetGeosSelected(False)
                        
        Call g_LockAcam
                
        ' lets offset the profile for boundary
        Set pthsOffset = pProfile.Offset((dblToolRadius + dblStock), IIf(CBool(pProfile.CW), acamRIGHT, acamLEFT))
        
        If (MD Is Nothing) Then Set MD = App.CreateMillData
        
        With MD
                
                Call g_SetOpName(MD, PText(100, 1, "SHOWER BASE"))
                                
                .Coolant = SBD.Coolant
                .ToolNumber = SBD.ToolNumber
                .OffsetNumber = SBD.OffsetNumber
                .CutFeed = SBD.CutFeed
                .DownFeed = SBD.DownFeed
                .SpindleSpeed = SBD.SpindleSpeed
                .SafeRapidLevel = (dblStartZ + SBD.SafeRapid)
                .RapidDownTo = (dblStartZ + SBD.RapidTo)
                
        End With
                
        If blnBidirectional Then
        
                If blnCutAlongProfile Then
                        Set PS = gps_BidirectionalAlongProfile(MD, blnStartAtHole, pHole.GetFirstElem, pthsOffset(1), dblStepAlongProfile, dblProfileDepth, dblHoleDepth)
                Else
                        Set PS = gps_BidirectionalRadial(MD, blnStartAtHole, pHole.GetFirstElem, pthsOffset(1), dblRadialAngle, dblProfileDepth, dblHoleDepth)
                End If
        
        Else
        
                If blnCutAlongProfile Then
                        Set PS = gps_OneWayAlongProfile(MD, blnStartAtHole, pHole.GetFirstElem, pthsOffset(1), dblStepAlongProfile, dblProfileDepth, dblHoleDepth)
                Else
                        Set PS = gps_OneWayRadial(MD, blnStartAtHole, pHole.GetFirstElem, pthsOffset(1), dblRadialAngle, dblProfileDepth, dblHoleDepth)
                End If
                
                ' delete the offset path
                Call pthsOffset.Delete
        
        End If
        
        ' IMPORTANT: If toolpaths were created set the associativity.
        '            See modMain.m_SetAssociativity for more details.
        '
        If Not (PS Is Nothing) Then
                Call m_SetAssociativity(MD, SBD, pHole, pProfile, PS)
                blnRet = True
        End If
        
        DoEvents
        
Controlled_Exit:
        
        gb_DoShowerBase = blnRet
                
        Call App.Frame.CloseProgressBox

        ' ensure we don't leave anything selected
        With App.ActiveDrawing
                Call .SetGeosSelected(False)
                'Call .RedrawShadedViews
        End With

        Call g_UnlockAcam

        Set pthsOffset = Nothing
        Set Drw = Nothing

Exit Function

ErrTrap:
        
        MsgBox Err.Description, vbExclamation
        blnRet = False
        Resume Controlled_Exit

End Function

Public Function gb_SelectGeos(pHole As Path, pProfile As Path) As Boolean
        
        Dim CP                      As CircleProperties
        Dim blnExitLoop             As Boolean
        Dim blnRet                  As Boolean
            
On Error GoTo ErrTrap

        blnRet = False
        
        ' lets get the hole
        Do
        
                Set pHole = App.ActiveDrawing.UserSelectOneGeo(PText(100, 1, "SHOWER BASE") & ": " & PText(40, 2, "Select Hole Geometry"))
                
                If (pHole Is Nothing) Then GoTo Controlled_Exit
                
                If gb_IsCircle(pHole, CP) Then
                                        
                        ' look for invalid tool diamter
                        If (App.GetCurrentTool.Diameter >= CP.Diameter) Then
                        
                                MsgBox PText(30, 2, "The diameter of the selected hole is smaller or") & vbCrLf & _
                                       PText(30, 3, "equal to the diameter of the selected tool."), vbInformation
                                       
                                blnExitLoop = False
                        
                        Else
                                
                                blnExitLoop = True
                                
                        End If
                        
                End If
                
        Loop While Not blnExitLoop
    
        pHole.Selected = True
        Call pHole.Redraw
        DoEvents
        
        blnExitLoop = False
        
        ' now lets get the profile
        Do
                Set pProfile = App.ActiveDrawing.UserSelectOneGeo(PText(100, 1, "SHOWER BASE") & ": " & PText(40, 3, "Select Profile Geometry"))
                
                If (pProfile Is Nothing) Then GoTo Controlled_Exit
                If Not gb_IsHoleInside(pHole, pProfile) Then GoTo Controlled_Exit
                
                blnExitLoop = True  ' ok to continue
                                                
        Loop While Not blnExitLoop
        
        ' show hole
        pHole.Selected = True
        Call pHole.Redraw
        DoEvents
        
        If Not pProfile.Closed Then

                MsgBox DEF_APP_TITLE, vbInformation, PText(30, 1, "WARNING") & vbCrLf & vbCrLf & _
                                                     PText(30, 8, "The selected external geometry is open.")
                pHole.Selected = False
                pProfile.Selected = False
                DoEvents
                GoTo Controlled_Exit
                
        End If
        
        ' show profile
        pProfile.Selected = True
        Call pProfile.Redraw
        DoEvents
        
        blnRet = True
        
Controlled_Exit:
        
        Call App.ActiveDrawing.SetGeosSelected(False)
        
        gb_SelectGeos = blnRet
        
        Set CP = Nothing
        
Exit Function

ErrTrap:
        
        MsgBox Err.Description, vbInformation
        Set pHole = Nothing
        Set pProfile = Nothing
        Resume Controlled_Exit
        
End Function

Public Function gb_IsHoleInside(pHole As Path, pProfile As Path) As Boolean

        Dim CP                      As CircleProperties
        Dim blnRet                  As Boolean
        
On Error GoTo ErrTrap

        blnRet = False
        
        Select Case True
        
                Case (pHole Is Nothing), _
                     (pProfile Is Nothing), _
                     Not gb_IsCircle(pHole, CP), _
                     Not pProfile.Closed, _
                     pHole.IsSame(pProfile)
                     
                        GoTo Controlled_Exit
                
                Case Not pProfile.IsPointInside(CP.CenterXG, CP.CenterYG)
                        
                        MsgBox PText(30, 10, "Hole center must reside inside of profile geometry."), vbInformation
                        GoTo Controlled_Exit
                        
        End Select
        
        blnRet = True

Controlled_Exit:
        
        gb_IsHoleInside = blnRet
        
        Set CP = Nothing

Exit Function

ErrTrap:
        
        blnRet = False
        Resume Controlled_Exit

End Function

Private Sub m_SetAssociativity(MD As MillData, oSBD As CShowerBaseData, pHole As Path, pProfile As Path, psToolpaths As Paths)
            
        ' IMPORTANT: In order for an operation to be editable, we must associate
        '            the appropriate geometries and the generated toolpaths
        '            with the MillData that the toolpaths were created from.
        '
        '            We must also set the names of the functions in the Events module
        '            for this add-in. These names can be anything, but it is good
        '            practice to use names that clearly represent their purpose.
            
        If Not (MD Is Nothing) Then

                With MD
                        
                        ' setup the Events function names and associations
                        
                        ' name of function in Events module to be called when applying a Machining Style
                        ' that was created from an operation that was created with this MillData
                        '
                        ' See Events.SelectForStyleShowerBase
                        '
                        Call .SetSelectForStyleFunction("SelectForStyleShowerBase")
                        
                        ' name of function in Events module to be called when updating
                        ' an operation that was created with this MillData
                        '
                        ' See Events.UpdateOpShowerBase
                        '
                        Call .SetUpdateFunction("UpdateOpShowerBase")
                        
                        ' name of function in Events module to be called when editing
                        ' an operation that was created with this MillData
                        '
                        ' See Events.EditOpShowerBase
                        '
                        Call .SetEditFunction("EditOpShowerBase")
                        
                        ' name of function in Events module to be called when adding a
                        ' geometry to an operation that was created with this MillData
                        '
                        ' note that we're passing a null string here as this Event is
                        ' not used by this add-in
                        '
                        ' See Events.BeforeAddGeometriesShowerBase
                        '
                        Call .SetBeforeAddGeometriesFunction(vbNullString)
                        
                        ' name of function in Events module to be called when removing a
                        ' geometry from an operation that was created with this MillData
                        '
                        ' note that we're passing a null string here as this Event is
                        ' not used by this add-in
                        '
                        ' See Events.BeforeRemoveGeometryShowerBase
                        '
                        Call .SetBeforeRemoveGeometryFunction(vbNullString)
                        
                        ' name of function in Events module to be called when moving a
                        ' geometry from an operation that was created with this MillData
                        ' to its own operation
                        '
                        ' note that we're passing a null string here as this Event is
                        ' not used by this add-in
                        '
                        ' See Events.BeforeMoveToOwnOpBoring
                        '
                        Call .SetBeforeMoveToOwnOpFunction(vbNullString)
                                                
                        ' name of function in Events module to be called when changing a
                        ' tool within an operation that was created with this MillData
                        '
                        ' note that we're passing a null string here as this Event is
                        ' not used by this add-in
                        '
                        ' See Events.BeforeChangeToolShowerBase
                        '
                        Call .SetBeforeChangeToolFunction(vbNullString)
                        
                        ' associate hole and profile geometries with the MillData, passing the
                        ' "ID..." flag so that they can be identified when the operation is updated
                        '
                        ' See Events.UpdateOpShowerBase to see how the flags are read
                        '
                        Call .AssociateGeometry(pHole, ID_GEO_HOLE)
                        Call .AssociateGeometry(pProfile, ID_GEO_PROFILE)
                        
                        ' associate the created toolpaths with the MillData
                        Call .AssociateToolPaths(psToolpaths)
                        
                End With
                
                ' save the user settings to the MillData
                Call oSBD.SaveSettingsToOp(MD)
                
        End If
        
End Sub
