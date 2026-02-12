Attribute VB_Name = "Events"
Option Explicit
Option Private Module

' Example macro originally written by David Butterfield
' Edited by Rich Greenhoe
'
' Two commands:
'
' CmdSolidRoughFinish creates an editable rough/finish pass around selected solid parts and surfaces.
' Selected geometries and splines will added to the op.

' CmdSolidRoughFinishFaces just allows solid faces

Public g_nStock                     As Single
Private Const LicomUKDMBSRF         As String = "LicomUKDMBSRF"
'

Function InitAlphacamAddIn(AcamVersion As Long) As Integer

        Dim blnRet                  As Boolean
        
        Const DEF_MENU              As String = "Editable Ops"
                
        ' add menus
        With App.Frame
                blnRet = .AddMenuItem2("Solid Rough/Finish", "CmdSolidRoughFinish", acamMenuNEW, DEF_MENU)
                blnRet = .AddMenuItem2("Solid Rough/Finish Faces", "CmdSolidRoughFinishFaces", acamMenuNEW, DEF_MENU)
        End With
        
        InitAlphacamAddIn = 0

End Function

Public Sub CmdSolidRoughFinish()
    
        ' if we get the user property then call sub to do the machining
        If ShowForms Then DoSolidRoughFinish
               
End Sub

Public Sub CmdSolidRoughFinishFaces()
        
        ' if we get the user property then call sub to do the machining
        If ShowForms Then DoSolidRoughFinishFaces
        
End Sub

Function OnUpdateCmdSolidRoughFinish()
        
        Dim Drw                 As Drawing
        
        Set Drw = App.ActiveDrawing

        Select Case True
                
                Case (App.GetCurrentTool Is Nothing), _
                     ((Drw.SolidParts.Count + Drw.Surfaces.Count = 0))
                        
                        OnUpdateCmdSolidRoughFinish = 0 ' disable
                        
                Case Else
                        
                        OnUpdateCmdSolidRoughFinish = 1 ' enable
        
        End Select
        
        Set Drw = Nothing
        
End Function

Function OnUpdateCmdSolidRoughFinishFaces()

        Dim Drw                 As Drawing
        
        Set Drw = App.ActiveDrawing
        
        Select Case True
        
                Case (App.GetCurrentTool Is Nothing), (Drw.SolidParts.Count = 0)
            
                        OnUpdateCmdSolidRoughFinishFaces = 0 ' disable
            
                Case Else
                        
                        OnUpdateCmdSolidRoughFinishFaces = 1 ' enable
                        
        End Select
            
        Set Drw = Nothing
        
End Function

Private Function ShowForms() As Boolean
                
        ShowForms = App.Frame.InputFloatDialog("Solid Rough/Finish", "Stock", acamFloatNON_NEG, g_nStock)
        
End Function

Public Sub UpdateSolidRoughFinish(Geos As AlphacamObjects, MD As MillData)
        
        ' IMPORTANT: This procedure is called when the user updates an operation or applies
        '            a Machining Style that was created with this add-in. The name of this
        '            procedure is determined by the MillData.SetUpdateFunction procedure.
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
        
        ' Alphacam will redraw after re-ordering the operations so no point drawing here
        App.ActiveDrawing.ScreenUpdating = False
        
        ' IMPORTANT: Get the user settings from the MillData attributes
        '            See Events.AttributesToGlobals for more info.
        '
        Call AttributesToGlobals(MD)
        
        Call McSolidRoughFinish(Geos, MD)
        
        App.ActiveDrawing.ScreenUpdating = True
        
End Sub

Public Function EditSolidRoughFinish(MD As MillData) As Long
    
        Dim Geos                    As AlphacamObjects
        Dim lngRet                  As Long
    
        ' IMPORTANT: This procedure is called when the user edits an operation or
        '            that was created with this add-in. The name of this procedure
        '            is determined by the MillData.SetEditFunction procedure.
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
    
        Set Geos = MD.GetGeometries
    
        lngRet = 1
        
        ' IMPORTANT: Get the user settings from the MillData attributes
        '            See Events.AttributesToGlobals for more info.
        '
        Call AttributesToGlobals(MD)
        
        If ShowForms Then
                
                lngRet = 0  ' OK
                
                ' IMPORTANT: Save the new user settings to the MillData
                '
                Call GlobalsToAttributes(MD)
                
        End If
        
        EditSolidRoughFinish = lngRet
        
        Set Geos = Nothing
        
End Function

Public Sub GlobalsToAttributes(MD As MillData)
    
        ' IMPORTANT: Save the appropriate user setting values to MillData
        '            attributes. Any value that can be edited by the user
        '            when editing the operation or applying a Machining Style
        '            should be assigned here.
        '
        '            It's important to note that these values are being assigned to the
        '            MillData's "AttributOp" property, rather than its "Attribute" property.
        '            The difference here is that "AttributeOp" assigns the attribute to
        '            the Operation only, while "Attribute" also copies the attribute and
        '            its value to the tool paths (Path.Attribute) within the operation.
        '
        '            SEE ALSO: AttributesToGlobals below
    
        MD.AttributeOp(LicomUKDMBSRF & "g_nStock") = g_nStock
    
End Sub

Public Sub AttributesToGlobals(MD As MillData)
    
        ' IMPORTANT: Get the appropriate user setting values from MillData
        '            attributes. These values will be used when the operation
        '            is edited or updated by the user, as well as when a
        '            Machining Style created from this add-in is applied.
        '
        '            It's important to note that these values are being retrieved from the
        '            MillData's "AttributOp" property, rather than its "Attribute" property.
        '
        '            SEE ALSO: GlobalsToAttributes above
        
        g_nStock = MD.AttributeOp(LicomUKDMBSRF & "g_nStock")
    
End Sub

Public Function BeforeAddGeometriesSolidRoughFinish(Geos As AlphacamObjects, MD As MillData)
        
        Dim Geo                 As Object
        Dim SP                  As SolidPart
        Dim Spl                 As Spline
        Dim Surf                As Surface
        Dim strName             As String
        
        ' IMPORTANT: This function is called before adding geometries to an operation that was
        '            created from an operation that was created by this add-in. The name of this
        '            procedure is determined by the MillData.SetBeforeAddGeometriesFunction procedure
        '            If that method is not called (or is called with an empty string) the
        '            "Add Geometries" menu item will be disabled.
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
        
        ' IMPORTANT: Loop through the selected objects and deselect those that are invalid
        '
        For Each Geo In Geos
        
                Set SP = gsp_GetSolidPartFromObject(Geo)
                
                If Not (SP Is Nothing) Then
                        
                        ' Reject solid part if the name contains "Ball"
                        strName = SP.Name
                        
                        If (InStr(strName, "Ball") > 0) Then SP.Selected = False
                        
                Else
            
                        Set Spl = gsl_GetSplineFromObject(Geo)
                        
                        If Not (Spl Is Nothing) Then
                                
                                ' Reject 3D splines
                                If Spl.Is3D Then Spl.Selected = False
                        
                        Else
                
                                Set Surf = gsu_GetSurfaceFromObject(Geo)
                                
                                If Not (Surf Is Nothing) Then
                                        
                                        Select Case True
                                        
                                                Case (Surf.NumberVerticesS > 4), (Surf.NumberVerticesT > 4)
                                                        
                                                        Surf.Selected = False
                                                        
                                        End Select
                                        
                                End If
                        
                        End If
                
                End If
        
        Next Geo

        BeforeAddGeometriesSolidRoughFinish = 0
        
        Set Geo = Nothing
        Set SP = Nothing
        Set Spl = Nothing
        Set Surf = Nothing
    
End Function

Public Function BeforeRemoveGeometrySolidRoughFinish(Geo As Object, MD As MillData)

        Dim N                   As Long
        Dim Obj                 As Object

        ' IMPORTANT: This function will be called before showing the context menu for a geometry within
        '            an operation that was created by this add-in. The name of this procedure is determined
        '            by the MillData.SetBeforeRemoveGeometryFunction procedure. If that method is not called
        '            (or is called with an empty string) the "Remove From Operation" menu item will be disabled.
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
        
        ' For this add-in we must have at least one solid part, solid face, or surface (for the Z extent)
        Select Case True
        
                Case Not (gsp_GetSolidPartFromObject(Geo) Is Nothing), _
                     Not (gsu_GetSurfaceFromObject(Geo) Is Nothing), _
                     Not (gsf_GetSolidFaceFromObject(Geo) Is Nothing)
                     
                        ' we must have something
                        
                Case Else
                        
                        ' Not a solid or surface so can remove it
                        BeforeRemoveGeometrySolidRoughFinish = 0    ' Enable
                        
                        Exit Function
                        
        End Select
        
        ' Is a solid or surface so need to see how many there are
        N = 0
    
        ' IMPORTANT: Don't allow Solid/Surface to be removed if only 1
        '
        For Each Obj In MD.GetGeometries
                
                If Not (gsp_GetSolidPartFromObject(Obj) Is Nothing) Then N = (N + 1)
                If Not (gsu_GetSurfaceFromObject(Obj) Is Nothing) Then N = (N + 1)
                If Not (gsf_GetSolidFaceFromObject(Obj) Is Nothing) Then N = (N + 1)
                
                If (N > 1) Then Exit For
        
        Next Obj
                
        If (N = 1) Then
                BeforeRemoveGeometrySolidRoughFinish = 1    ' Disable
        Else
                BeforeRemoveGeometrySolidRoughFinish = 0    ' Enable
        End If
        
        Set Obj = Nothing
        
End Function

Public Function BeforeMoveToOwnOpSolidRoughFinish(Geo As Object, MD As MillData) As Integer

        ' IMPORTANT: This function will be called before showing the context menu for a geometry within
        '            an operation that was created by this add-in. The name of this procedure is determined
        '            by the MillData.SetBeforeMoveToOwnOpFunction procedure. If that method is not called
        '            (or is called with an empty string) the "Move to Own Operation" menu item will be disabled.
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
        
        ' we can simply use the BeforeRemoveGeometrySolidRoughFinish function as it requires the same logic
        BeforeMoveToOwnOpSolidRoughFinish = BeforeRemoveGeometrySolidRoughFinish(Geo, MD)
        
End Function

Public Function BeforeChangeToolSolidRoughFinish(Tool As MillTool, MD As MillData) As Integer
                
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
        
        BeforeChangeToolSolidRoughFinish = 0 ' always OK
        
End Function
