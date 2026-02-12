Attribute VB_Name = "Events"
Option Explicit
Option Private Module
'

Function InitAlphacamAddIn(AcamVersion As Long) As Integer
        
        Dim blnRet                  As Boolean
        
        Const DEF_MENU              As String = "Editable Ops"
                
        ' add menu
        blnRet = App.Frame.AddMenuItem2(PText(3, 1, "&Boring Along 2D Line..."), "CmdBoringAlong2DLine", acamMenuNEW, DEF_MENU)
        
        InitAlphacamAddIn = 0

End Function
    
Public Sub CmdBoringAlong2DLine()
            
On Error Resume Next
    
        Call Load(frmMain)
        DoEvents
        Call frmMain.Show
        DoEvents
        Call Unload(frmMain)
    
End Sub
    
Function OnUpdateCmdBoringAlong2DLine()

On Error Resume Next

        ' only enable if we have geos and a selected tool
        Select Case True
                Case (App.ActiveDrawing.GetGeoCount = 0), (App.GetCurrentTool Is Nothing): OnUpdateCmdBoringAlong2DLine = 0
                Case Else: OnUpdateCmdBoringAlong2DLine = 1
        End Select

End Function
    
Public Sub UpdateOpBoring(Geos As AlphacamObjects, MD As MillData)
        
        Dim PS                      As Paths
        Dim BD                      As CBoringData
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
        
        ' create a new CBoringData object
        Set BD = New CBoringData
        
        ' IMPORTANT: Attempt to get the geometries (Paths) that belong to this operation.
        '            See modAC.gps_GetPathsFromObject for more information.
        '
        Set PS = gps_GetPathsFromObject(Geos)
        
        ' IMPORTANT: Get the user settings from the MillData, pass them to the main
        '            machining routine, and (re)machine them (bypassing the GUI).
        '            See CBoringData.GetSettingsFromOp for more info.
        '
        Call BD.GetSettingsFromOp(MD)
        blnRet = gb_DrillEm(PS, BD, MD)
                
        Set PS = Nothing
        Set BD = Nothing
    
End Sub

Public Function EditOpBoring(MD As MillData) As Long
            
        Dim BD                      As CBoringData
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
        
        ' create a new CBoringData object
        Set BD = New CBoringData
        
        ' IMPORTANT: Get the user settings from the MillData attributes
        '            See CBoringData.GetSettingsFromOp for more info.
        '
        If Not BD.GetSettingsFromOp(MD) Then GoTo Controlled_Exit
        
        Call Load(frmMain)
        DoEvents
        
        With frmMain
                
                ' IMPORTANT: Fill the form controls with the values from the MillData attributes.
                '
                Call .SetBoringData(BD, MD)
                Call .Show
                
                ' bail if cancelled, otherwise the machining was done
                If .Cancelled Then GoTo Controlled_Exit
                
                ' IMPORTANT: Fill the CShowerBaseData object with the use values from the form
                '
                Set BD = .GetBoringData
        
        End With
        
        ' IMPORTANT: Save the new user settings to the MillData
        '
        Call BD.SaveSettingsToOp(MD)
        
        lngRet = 0
        
Controlled_Exit:
        
On Error Resume Next
        
        Call Unload(frmMain)
        
        EditOpBoring = lngRet
        
        Set BD = Nothing

Exit Function
        
End Function

Public Function BeforeAddGeometriesBoring(Geos As AlphacamObjects, MD As MillData) As Integer
        
        Dim PS                      As Paths
        Dim PS2                     As Paths
        
        ' IMPORTANT: This function is called before adding geometries to an operation that was
        '            created from an operation that was created by this add-in. The name of this
        '            procedure is determined by the MillData.SetBeforeAddGeometriesFunction procedure
        '            which is called within modMain.m_SetAssociativity. If that method is not called
        '            (or is called with an empty string) the "Add Geometries" menu item will be disabled.
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
        
        ' IMPORTANT: Attempt to get the geometries (Paths) that belong to this operation.
        '            See modAC.gps_GetPathsFromObject for more information.
        '
        Set PS = gps_GetPathsFromObject(Geos)
         
        If Not (PS Is Nothing) Then
                
                ' warn the user of any invalid geometries
                If gb_AnyInvalidGeos(PS, PS2) Then
                        MsgBox PText(75, 1, "Arcs and 3D Polylines will be ignored."), vbInformation
                End If
                
        End If
        
        BeforeAddGeometriesBoring = 0
        
        Set PS = Nothing
        Set PS2 = Nothing
        
End Function

Public Function BeforeRemoveGeometryBoring(Geo As Object, MD As MillData) As Integer

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
                
        BeforeRemoveGeometryBoring = 0    ' Enable by default
        
        ' if only one geometry exists within the operation, don't allow it to be removed
        If (MD.GetGeometries.Count = 1) Then BeforeRemoveGeometryBoring = 1    ' Disable
        
End Function

Public Function BeforeMoveToOwnOpBoring(Geo As Object, MD As MillData) As Integer

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
        '               1 (Non-Zero) = Disable the "Remove From Operation" menu item
        
        BeforeMoveToOwnOpBoring = 0    ' Enable by default
        
        ' if only one geometry exists within the operation, don't allow it to be moved
        If (MD.GetGeometries.Count = 1) Then BeforeMoveToOwnOpBoring = 1    ' Disable
        
End Function

Public Function BeforeChangeToolBoring(Tool As MillTool, MD As MillData) As Long
        
        ' !!  THIS EVENT IS NOT USED BY THIS ADD-IN AS THE TOOL CAN BE CHANGED FROM DIALOG WHEN EDITING !!
                
        ' IMPORTANT: This function will be called before the tool is changed by the "Change Tool"
        '            option in the operations manager. The name of this procedure is determined
        '            by the MillData.SetBeforeChangeToolFunction procedure, which is called within
        '            modMain.m_SetAssociativity. If that method is not called (or is called with
        '            an empty string) the "Change Tool" menu item will be disabled.
        '
        '            Arguments...
        '
        '               Tool = The (new) tool selected by the user
        '
        '               MD = The MillData object that belongs to the operation being edited.
        '
        '            Return values...
        '
        '               0 = OK to use the selected tool, Alphacam will then call the function
        '                   set to MillData.SetEditFunction (e.g., EditOpShowerBase) so the user
        '                   can updated any tool specific settings (e.g., Width of Cut)
        '
        '               1 (Non-Zero) = Reject the tool
        
        BeforeChangeToolBoring = 1

End Function
