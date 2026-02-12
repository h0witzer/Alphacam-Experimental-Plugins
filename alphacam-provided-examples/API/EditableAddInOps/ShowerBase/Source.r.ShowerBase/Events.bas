Attribute VB_Name = "Events"
Option Explicit
Option Private Module
'

Function InitAlphacamAddIn(lngAcamVersion As Long) As Integer
        
        Dim blnRet                  As Boolean
        
        Const DEF_MENU              As String = "Editable Ops"
                
        ' add menu
        blnRet = App.Frame.AddMenuItem2(PText(3, 1, "Shower &Base..."), "CmdShowBaseMachining", acamMenuNEW, DEF_MENU)
        
        InitAlphacamAddIn = 0
        
End Function

Public Function OnUpdateCmdShowBaseMachining() As Integer

On Error Resume Next
        
        ' only enable if we have geos and a selected tool
        Select Case True
                Case (App.ActiveDrawing.GetGeoCount = 0), (App.GetCurrentTool Is Nothing): OnUpdateCmdShowBaseMachining = 0
                Case Else: OnUpdateCmdShowBaseMachining = 1
        End Select
        
End Function

Sub CmdShowBaseMachining()

On Error Resume Next

        Call Load(frmMain)
        DoEvents
        Call frmMain.Show
        DoEvents
        Call Unload(frmMain)

End Sub

Public Sub UpdateOpShowerBase(Geos As AlphacamObjects, MD As MillData)
        
        Dim PS                      As Paths
        Dim P                       As Path
        Dim pthHole                 As Path
        Dim pthProfile              As Path
        Dim SBD                     As CShowerBaseData
        Dim blnRet                  As Boolean
        
        ' IMPORTANT: This procedure is called when the user updates an operation or
        '            applies a Machining Style that was created with this add-in.
        '            The name of this procedure is determined by the MillData.SetUpdateFunction
        '            procedure, which is called within modMain.m_SetAssociativity.
        '
        '            Arguments...
        '
        '               Geos = Collection of Alphacam objects (geometries) that belong to the operation
        '                      being updated. This collection can consists of any combination of any
        '                      machinable object (Path, Spline, Surface, SolidPart, SolidFace). To reject
        '                      a geometry and prevent it from being (re)machined, deselect it (.Selected = False).
        '
        '               MD = The MillData object that belongs to the operation being updated.
        '
        '            Return value...
        '
        '               None
        
        ' create a new CShowerBaseData object
        Set SBD = New CShowerBaseData
        
        ' IMPORTANT: Attempt to get the geometries (Paths) that belong to this operation.
        '            See modAcam.gps_GetPathsFromObject for more information.
        '
        Set PS = gps_GetPathsFromObject(Geos)
        
        If (PS Is Nothing) Then GoTo Controlled_Exit
        
        ' IMPORTANT: Loop through the operation's geometries and look for hole and profile paths
        '
        For Each P In PS
                If (P.FlagForEditableOp = ID_GEO_HOLE) Then Set pthHole = P
                If (P.FlagForEditableOp = ID_GEO_PROFILE) Then Set pthProfile = P
        Next P
        '
        ' make sure we still have two geos
        Select Case True
                
                Case (pthHole Is Nothing), (pthProfile Is Nothing)
                    
                        ' do nothing - will remove existing tool path
                        GoTo Controlled_Exit
                        
        End Select
        
        ' IMPORTANT: Let's make sure we have valid geometries. if the user has moved the hole geometry to be
        '            outside of the profile geometry, deselect them  - this will remove the existing toolpath(s).
        '
        '            If the geometries are still valid, then get the user settings from the MillData, pass
        '            them to the main machining routine, and (re)machine them (bypassing the GUI).
        '            See CShowerBaseData.GetSettingsFromOp for more info.
        '
        If Not gb_IsHoleInside(pthHole, pthProfile) Then
                pthHole.Selected = False
                pthProfile.Selected = False
        Else
                Call SBD.GetSettingsFromOp(MD)
                blnRet = gb_DoShowerBase(SBD, MD, pthHole, pthProfile)
        End If
                
Controlled_Exit:
                
        Set PS = Nothing
        Set P = Nothing
        Set pthHole = Nothing
        Set pthProfile = Nothing
        Set SBD = Nothing
        
Exit Sub
    
End Sub

Public Function EditOpShowerBase(MD As MillData) As Long
            
        Dim SBD                     As CShowerBaseData
        Dim lngRet                  As Long

        ' IMPORTANT: This procedure is called when the user edits an operation or
        '            that was created with this add-in. The name of this procedure
        '            is determined by the MillData.SetEditFunction procedure,
        '            which is called within modMain.m_SetAssociativity.
        '
        '            Arguments...
        '
        '               MD = The MillData object that belongs to the operation being edited.
        '
        '            Return values...
        '
        '               0 = OK
        '
        '               1 (Non-Zero) = Cancel editing
        
        lngRet = 1
        
        ' IMPORTANT: Let's make sure we have what we need, but first check to see if we're editing
        '            within a Machining Style (MD.GetGeometries will be Nothing in that case)
        '
        If Not (MD.GetGeometries Is Nothing) Then
                
                If (MD.GetGeometries.Count <> 2) Then
                        MsgBox PText(32, 1, "Invalid number of geometries found in the operation, unable to edit."), vbInformation
                        GoTo Controlled_Exit
                End If
                
        End If
        
        ' create a new CShowerBaseData object
        Set SBD = New CShowerBaseData
        
        ' IMPORTANT: Get the user settings from the MillData attributes
        '            See CShowerBaseData.GetSettingsFromOp for more info.
        '
        If Not SBD.GetSettingsFromOp(MD) Then GoTo Controlled_Exit
        
        Call Load(frmMain)
        DoEvents
        
        With frmMain
                
                ' IMPORTANT: Fill the form controls with the values from the MillData attributes.
                '
                Call .SetShowBaseData(SBD, MD)
                Call .Show
                
                ' bail if cancelled, otherwise the machining was done
                If .Cancelled Then GoTo Controlled_Exit
                
                ' IMPORTANT: Fill the CShowerBaseData object with the use values from the form
                '
                Set SBD = .GetShowBaseData
        
        End With
        
        ' IMPORTANT: Save the new user settings to the MillData
        '
        Call SBD.SaveSettingsToOp(MD)
        
        lngRet = 0
        
Controlled_Exit:
        
On Error Resume Next
        
        Call Unload(frmMain)
        
        EditOpShowerBase = lngRet
        
        Set SBD = Nothing

Exit Function
        
End Function

Public Function SelectForStyleShowerBase(MD As MillData) As Long
        
        Dim pthHole                 As Path
        Dim pthProfile              As Path
        Dim lngRet                  As Long

        ' IMPORTANT: This function is called when the user applys a Machining Style
        '            that was created from an operation that was created by this add-in.
        '            The name of this procedure is determined by the MillData.SetSelectForStyleFunction
        '            procedure, which is called within modMain.m_SetAssociativity.
        '
        '            Arguments...
        '
        '               MD = The MillData object that belongs to the Machining Style being applied.
        '
        '            Return values...
        '
        '               0 = OK to apply the Style, Alphacam will then call the function
        '                   set to MillData.SetUpdateFunction (e.g., UpdateOpShowerBase)
        '
        '               1 (Non-Zero) = Cancel and don't apply the Style

        ' set default return value
        lngRet = 1
        
        ' Select the two geometries - bail out if none selected
        If Not gb_SelectGeos(pthHole, pthProfile) Then
                Call App.ActiveDrawing.RedrawShadedViews
                GoTo Controlled_Exit
        End If
    
        ' IMPORTANT: Associate the selected geometries with the passed MillData, setting the
        '            "ID..." flag values so Events.UpdateOpShowerBase knows which is which.
        '
        Call MD.AssociateGeometry(pthHole, ID_GEO_HOLE)
        Call MD.AssociateGeometry(pthProfile, ID_GEO_PROFILE)
        
        ' if we've made it here, we must be good to go
        lngRet = 0
                
Controlled_Exit:

        SelectForStyleShowerBase = lngRet
        
Exit Function
        
End Function

Public Function BeforeAddGeometriesShowerBase(Geos As AlphacamObjects, MD As MillData) As Long
        
        ' !!  THIS EVENT IS NOT USED BY THIS ADD-IN AS IT EXPLICITY REQUIRES 2 GEOMETRIES !!
                
        ' IMPORTANT: This function is called before adding geometries to an operation that was
        '            created by this add-in. The name of this procedure is determined by the
        '            MillData.SetBeforeAddGeometriesFunction procedure which is called within
        '            modMain.m_SetAssociativity. If that method is not called (or is called
        '            with an empty string) the "Add Geometries" menu item will be disabled.
        '
        '            Arguments...
        '
        '               Geos = Collection of Alphacam objects (geometries) that have been selected
        '                      to add to the operation. To reject a geometry and prevent it from
        '                      being machined, deselect it (.Selected = False).
        '
        '               MD = The MillData object that belongs to the operation being edited.
        '
        '            Return values...
        '
        '               0 = OK to add the selected geometry to the operation
        '
        '               1 (Non-Zero) = Reject all selected geometry
        
        BeforeAddGeometriesShowerBase = 1

End Function

Public Function BeforeRemoveGeometryShowerBase(Geos As AlphacamObjects, MD As MillData) As Long
        
        ' !!  THIS EVENT IS NOT USED BY THIS ADD-IN AS IT EXPLICITY REQUIRES 2 GEOMETRIES !!
                
        ' IMPORTANT: This function will be called before showing the context menu for a geometry within
        '            an operation that was created by this add-in. The name of this procedure is determined
        '            by the MillData.SetBeforeRemoveGeometryFunction procedure, which is called within
        '            modMain.m_SetAssociativity. If that method is not called (or is called with an
        '            empty string) the "Remove From Operation" menu item will be disabled.
        '
        '            Arguments...
        '
        '               Geos = Collection of Alphacam objects (geometries) that have been selected
        '                      to remove from the operation. In this event, this collection should
        '                      contain only one object.
        '
        '               MD = The MillData object that belongs to the operation being edited.
        '
        '            Return values...
        '
        '               0 = OK to allow geometry to be removed from the operation
        '
        '               1 (Non-Zero) = Disable the "Remove From Operation" menu item
        
        BeforeRemoveGeometryShowerBase = 1

End Function

Public Function BeforeMoveToOwnOpShowerBase(Geo As Object, MD As MillData) As Integer

        ' !!  THIS EVENT IS NOT USED BY THIS ADD-IN AS IT EXPLICITY REQUIRES 2 GEOMETRIES !!

        ' IMPORTANT: This function will be called before showing the context menu for a geometry within
        '            an operation that was created by this add-in. The name of this procedure is determined
        '            by the MillData.SetBeforeMoveToOwnOpFunction procedure, which is called within
        '            modMain.m_SetAssociativity. If that method is not called (or is called with an
        '            empty string) the "Move to Own Operation" menu item will be disabled.
        '
        '            Arguments...
        '
        '               Geos = Collection of Alphacam objects (geometries) that have been selected
        '                      to move to its own operation. In this event, this collection should
        '                      contain only one object.
        '
        '               MD = The MillData object that belongs to the operation being edited.
        '
        '            Return values...
        '
        '               0 = OK to allow geometry to be removed from the operation
        '
        '               1 (Non-Zero) = Disable the "Move to Own Operation" menu item
        
        BeforeMoveToOwnOpShowerBase = 1
                
End Function

Public Function BeforeChangeToolShowerBase(Tool As MillTool, MD As MillData) As Long
        
        ' !!  THIS EVENT IS NOT USED BY THIS ADD-IN AS THE TOOL CAN BE CHANGED FROM DIALOG WHEN EDITING !!
                
        ' IMPORTANT: This function will be called before showing the context menu for a geometry within
        '            an operation that was created by this add-in. The name of this procedure is determined
        '            by the MillData.SetBeforeChangeToolFunction procedure, which is called within
        '            modMain.m_SetAssociativity. If that method is not called (or is called with an
        '            empty string) the "Change Tool"menu item will be disabled.
        '
        '            Arguments...
        '
        '               Tool = The (new) tool selected by the user
        '
        '               MD = The MillData object that belongs to the operation being edited.
        '
        '            Return values...
        '
        '               0 = OK to allow geometry to be removed from the operation
        '
        '               1 (Non-Zero) = Disable the "Change Tool" menu item
        
        BeforeChangeToolShowerBase = 1

End Function

