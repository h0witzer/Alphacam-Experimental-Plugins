Attribute VB_Name = "modMain"
Option Explicit
Option Private Module

Public Const DEF_ATT_IS_BA2DL               As String = "AcamUSrg_IsBoringAlong2DLine"
'

Public Function gb_DrillEm(PS As Paths, oBD As CBoringData, MD As MillData) As Boolean
        
        Dim Drw                     As Drawing
        Dim WP                      As WorkPlane
        Dim P                       As Path
        Dim E1                      As Element
        Dim pRotateX                As Path
        Dim pRotateY                As Path
        Dim pCircle                 As Path
        Dim pthsToolPaths           As Paths
        Dim blnRet                  As Boolean
                
On Error GoTo ErrTrap
        
        blnRet = True
                
        Set Drw = App.ActiveDrawing
        
        ' lets make sure we've got something
        If (PS Is Nothing) Then GoTo Controlled_Exit
        If (PS.Count = 0) Then GoTo Controlled_Exit
        
        ' lock up the acam screen
        Call g_LockAcam
        
        For Each P In PS
                
                Set E1 = P.Elements(1)
                                                                                        
                With E1
                                                                                
                        ' copy the circle center line for rotation
                        Set pRotateX = P.Copy
                        
                        ' 09/08/06 - rg
                        '   + CHANGED to -90 for proper XY workplane orientation
                        '
                        ' rotate the circle center line -90 degrees locally
                        Call pRotateX.RotateL(-90, .StartXL, .StartYL)
                        
                        ' make another copy of the original for rotation the other way
                        Set pRotateY = P.Copy

                        Call pRotateY.RotateG(90, pRotateX.Elements(1).StartXG, pRotateX.Elements(1).StartYG, pRotateX.Elements(1).StartZG, _
                                                  pRotateX.Elements(1).EndXG, pRotateX.Elements(1).EndYG, pRotateX.Elements(1).EndZG)
                                                                                                                                        
                        ' create a new workplane
                        Set WP = Drw.CreateWorkPlane(.StartXG, .StartYG, .StartZG, _
                                                     pRotateX.Elements(1).EndXG, pRotateX.Elements(1).EndYG, pRotateX.Elements(1).EndZG, _
                                                     pRotateY.Elements(1).EndXG, pRotateY.Elements(1).EndYG, pRotateY.Elements(1).EndZG)
                             
                        ' activate the workplane
                        Call Drw.SetWorkPlane(WP)
                        
                        ' create the circle
                        Set pCircle = Drw.CreateCircle(oBD.Tool.Diameter, 0, 0)
                        
                        ' put at proper z
                        Call pCircle.MoveG(0, 0, oBD.HoleCenterZShift)
                        
                        ' make sure there's nothing selected
                        Call Drw.SetGeosSelected(False)
                                                
                        ' try to drill it
                        If Not mb_DrillHole(pCircle, .Length, oBD, pthsToolPaths, MD) Then GoTo Controlled_Exit
                        
                        ' IMPORTANT: If toolpaths were created set the associativity.
                        '            See modMain.m_SetAssociativity for more details.
                        '
                        Call m_SetAssociativity(MD, oBD, P, pthsToolPaths)
                        
                        ' wipe out the temp geo
                        pCircle.Selected = True
                        pRotateX.Selected = True
                        pRotateY.Selected = True
                        
                        ' cancel the workplane and wipe out the selected geo
                        With Drw
                                .CancelWorkPlane
                                .DeleteSelected
                        End With
                                                                                
                End With
                                        
        Next P
        
Controlled_Exit:
                
        Call App.ActiveDrawing.SetGeosSelected(False)
        
        ' unlock acam screen
        Call g_UnlockAcam
        
        DoEvents
        
        Set Drw = Nothing
        Set WP = Nothing
        Set P = Nothing
        Set E1 = Nothing
        Set pCircle = Nothing
        Set pRotateX = Nothing
        
        gb_DrillEm = blnRet
        
Exit Function
        
ErrTrap:
        
        MsgBox Err.Description, vbExclamation
        blnRet = False
        Resume Controlled_Exit
        
End Function

Private Function mb_DrillHole(pCircle As Path, ByVal dELength As Double, oBD As CBoringData, psToolpaths As Paths, Optional MD As MillData = Nothing) As Boolean
                
        Dim blnRet                  As Boolean
                
On Error GoTo ErrTrap
        
        ' so far, so good
        blnRet = False
        
        ' make sure the circle is selected
        pCircle.Selected = True
        
        ' create the mill data, if needed
        If (MD Is Nothing) Then Set MD = App.CreateMillData
        
        With MD
                
                Call g_SetOpName(MD, PText(100, 1, "BORING 2D LINE"))
                
                .DrillType = IIf(oBD.Pecking, acamPECK, acamDRILL)
                .DrillGlobalLinear = False
                .HoleDepthIsShoulder = oBD.DepthAtShoulder
                
                ' look to get depth from line endpoint
                If oBD.BottomAtLineEndpoint Then
                        .BottomOfHole = -dELength
                Else
                        .BottomOfHole = oBD.BottomOfHole
                End If
                
                .SafeRapidLevel = oBD.SafeRapid
                .RapidDownTo = oBD.RapidTo
                .DrillFeed = oBD.DrillFeed
                .SpindleSpeed = oBD.SpindleSpeed
                .ToolNumber = oBD.ToolNumber
                .OffsetNumber = oBD.OffsetNumber
                .TraverseAtRPlane = oBD.TraverseAtRPlane
                .DwellTime = oBD.DwellTime
                .PeckDistance = oBD.PeckDistance
                .RetractPartial = oBD.PeckRetractPartial
                .Coolant = oBD.Coolant
                
                Set psToolpaths = .DrillTap
                
        End With
        
        blnRet = True
        
Controlled_Exit:
                        
        mb_DrillHole = blnRet
        
Exit Function
        
ErrTrap:
        
        MsgBox Err.Description, vbExclamation
        blnRet = False
        Resume Controlled_Exit
        
End Function

Private Sub m_SetAssociativity(MD As MillData, oBD As CBoringData, pGeo As Path, psToolpaths As Paths) 'mdUpdate As MillData,
        
        Dim P                       As Path
    
        ' IMPORTANT: In order for an operation to be editable, we must associate
        '            the appropriate geometries and the generated toolpaths
        '            with the MillData that the toolpaths were created from.
        '
        '            We must also set the names of the functions in the Events module
        '            for this add-in. These names can be anything, but it is good
        '            practice to use names that clearly represent their purpose.
        
        If Not (psToolpaths Is Nothing) Then

                If Not (MD Is Nothing) Then
                
                        With MD
                                
                                ' setup the Events function names and associations
                        
                                ' name of function in Events module to be called when updating
                                ' an operation that was created with this MillData
                                '
                                ' See Events.UpdateOpBoring
                                '
                                Call .SetUpdateFunction("UpdateOpBoring")
                                
                                ' name of function in Events module to be called when editing
                                ' an operation that was created with this MillData
                                '
                                ' See Events.EditOpBoring
                                '
                                Call .SetEditFunction("EditOpBoring")
                                        
                                ' name of function in Events module to be called when adding a
                                ' geometry to an operation that was created with this MillData
                                '
                                ' See Events.BeforeAddGeometriesBoring
                                '
                                Call .SetBeforeAddGeometriesFunction("BeforeAddGeometriesBoring")
                                
                                ' name of function in Events module to be called when removing a
                                ' geometry from an operation that was created with this MillData
                                '                                '
                                ' See Events.BeforeRemoveGeometryBoring
                                '
                                Call .SetBeforeRemoveGeometryFunction("BeforeRemoveGeometryBoring")
                                
                                ' name of function in Events module to be called when moving a
                                ' geometry from an operation that was created with this MillData
                                ' to its own operation
                                '
                                ' See Events.BeforeMoveToOwnOpBoring
                                '
                                Call .SetBeforeMoveToOwnOpFunction("BeforeMoveToOwnOpBoring")
                                                                                
                                ' name of function in Events module to be called when changing a
                                ' tool within an operation that was created with this MillData
                                '
                                ' note that we're passing a null string here as this Event is
                                ' not used by this add-in
                                '
                                ' See Events.BeforeChangeToolBoring
                                '
                                Call .SetBeforeChangeToolFunction(vbNullString)
                                
                                ' associate geometry with the MillData
                                Call .AssociateGeometry(pGeo, 0)
                                
                                ' set an add-in specific flag to each toolpath
                                For Each P In psToolpaths
                                        P.Attribute(DEF_ATT_IS_BA2DL) = 1
                                Next P
                                
                                ' associate the toolpaths with the MillData
                                Call .AssociateToolPaths(psToolpaths)
                        
                        End With
                        
                        ' save the user settings to the MillData
                        Call oBD.SaveSettingsToOp(MD)
                        
                End If
                
        End If
        
End Sub

Public Function gb_AnyInvalidGeos(PS As Paths, psRet As Paths) As Boolean
        
        Dim P                       As Path
        Dim blnRet                  As Boolean
        
        blnRet = False
        
        If (PS Is Nothing) Then GoTo Controlled_Exit
        
        Set psRet = App.ActiveDrawing.CreatePathCollection
        
        For Each P In PS
                                                                
                Select Case True
                        Case P.GetFirstElem.IsArc, P.Is3D: P.Selected = False: blnRet = True
                        Case Else: Call psRet.Add(P)
                End Select
                
        Next P
        
Controlled_Exit:
        
        gb_AnyInvalidGeos = blnRet
                
        Set P = Nothing

Exit Function
                
End Function

