Attribute VB_Name = "modMain"
Option Explicit
Option Private Module
'

Public Sub DoSolidRoughFinish()
    
        Dim Geos                As AlphacamObjects
        Dim SP                  As SolidPart
        Dim P                   As Path
        Dim S                   As Surface
        Dim C                   As Spline
    
        ' Select solids and geometry paths and call the routine to do the machining

        If Not App.ActiveDrawing.UserSelectMultiGeos2("Solid Rough/Finish: Select Solids/Surfaces/Geometries", _
                                                      acamSelectSPLINES + acamSelectSURFACES + acamSelectDRAW_SELECTED, _
                                                      acamSelectSOLIDS + acamSelectGEOMETRY_PATHS) Then
                                                      
                Exit Sub
        
        End If
    
        ' Build a collection for everything selected
        Set Geos = App.ActiveDrawing.CreateAlphacamObjectsCollection
    
        For Each SP In App.ActiveDrawing.SolidParts
                If SP.Selected Then
                        Call Geos.Add(SP)
                        SP.Selected = False
                End If
        Next SP
    
        For Each P In App.ActiveDrawing.Geometries
                If P.Selected Then
                        Call Geos.Add(P)
                        P.Selected = False
                End If
        Next P
        
        For Each S In App.ActiveDrawing.Surfaces
                If S.Selected Then
                        Call Geos.Add(S)
                        S.Selected = False
                End If
        Next S
    
        For Each C In App.ActiveDrawing.Splines
                If C.Selected Then
                        Call Geos.Add(C)
                        C.Selected = False
                End If
        Next C
    
        Call McSolidRoughFinish(Geos, Nothing)
        
        Set SP = Nothing
        Set S = Nothing
        Set C = Nothing
        Set P = Nothing
        Set Geos = Nothing
        
End Sub

Public Sub DoSolidRoughFinishFaces()
        
        Dim Geos                As AlphacamObjects
        Dim SF                  As SolidFeatures
        Dim Sel                 As SolidSelector
        Dim F                   As SolidFace
    
        ' Select solid faces only and call the routine to do the machining

        Set SF = App.ActiveDrawing.SolidInterface
        Set Sel = SF.Selector
    
        Sel.What = FeatureSelectFace
        Call Sel.Select("Solid Rough/Finish: Select Solid Faces")

        ' Build a collection for the selected faces
        Set Geos = App.ActiveDrawing.CreateAlphacamObjectsCollection
        
        For Each F In Sel
                Call Geos.Add(F)
        Next F
        
        If (Geos.Count > 0) Then Call McSolidRoughFinish(Geos, Nothing)
        
        Set F = Nothing
        Set Sel = Nothing
        Set SF = Nothing
        Set Geos = Nothing
        
End Sub

Public Sub McSolidRoughFinish(Geos As AlphacamObjects, MDForAssociate As MillData)
        
        Dim MT                  As MillTool
        Dim MD                  As MillData
        Dim SP                  As SolidPart
        Dim SF                  As SolidFace
        Dim S                   As Surface
        Dim P                   As Path
        Dim P2                  As Path
        Dim C                   As Spline
        Dim PathsToDelete       As Paths
        Dim Rect                As Path
        Dim ToolPaths           As Paths
        Dim Geo                 As Object
        Dim A                   As Double
        Dim MinX                As Double
        Dim MaxX                As Double
        Dim MinY                As Double
        Dim MaxY                As Double
        Dim MinZ                As Double
        Dim MaxZ                As Double
    
        Const DEF_BIG           As Double = 10000000000#
    
        ' Do the op given geometry, which must include at least one solid
        ' or surface (to set the Z) and may include splines and geometries
    
        If (Geos.Count = 0) Then GoTo Controlled_Exit
    
        Set MT = App.GetCurrentTool
        
        If (MT Is Nothing) Then GoTo Controlled_Exit
        
        Set MD = App.CreateMillData
        
        ' set the milldata for association, if not already
        If (MDForAssociate Is Nothing) Then Set MDForAssociate = MD
    
        ' Find the extent
        
        MinX = DEF_BIG
        MinY = DEF_BIG
        MinZ = DEF_BIG
        MaxX = -DEF_BIG
        MaxY = -DEF_BIG
        MaxZ = -DEF_BIG
    
        ' Loop through the passed geometries looking for the SolidParts and surfaces
        For Each Geo In Geos
        
                Set SP = gsp_GetSolidPartFromObject(Geo)
                
                If Not (SP Is Nothing) Then
                        
                        ' IMPORTANT: Associate the solid part with the MillData
                        '
                        Call MDForAssociate.AssociateGeometry(SP, 0)
                        
                        A = SP.MinX
                        If A < MinX Then MinX = A
                        A = SP.MaxX
                        If A > MaxX Then MaxX = A
                        A = SP.MinY
                        If A < MinY Then MinY = A
                        A = SP.MaxY
                        If A > MaxY Then MaxY = A
                        A = SP.MinZ
                        If A < MinZ Then MinZ = A
                        A = SP.MaxZ
                        If A > MaxZ Then MaxZ = A
        
                Else
            
                        Set S = gsu_GetSurfaceFromObject(Geo)
                        
                        If Not (S Is Nothing) Then
                
                                ' IMPORTANT: Associate the surface with the MillData
                                '
                                Call MDForAssociate.AssociateGeometry(S, 0)
                                
                                A = S.MinX
                                If A < MinX Then MinX = A
                                A = S.MaxX
                                If A > MaxX Then MaxX = A
                                A = S.MinY
                                If A < MinY Then MinY = A
                                A = S.MaxY
                                If A > MaxY Then MaxY = A
                                A = S.MinZ
                                If A < MinZ Then MinZ = A
                                A = S.MaxZ
                                If A > MaxZ Then MaxZ = A
                        
                        Else
                
                                Set SF = gsf_GetSolidFaceFromObject(Geo)
                                
                                If Not (SF Is Nothing) Then
                                                
                                        ' IMPORTANT: Associate the solid face with the MillData
                                        '
                                        Call MDForAssociate.AssociateGeometry(SF, 0)
                                        
                                        A = SF.Bounds.x
                                        If A < MinX Then MinX = A
                                        A = SF.Bounds.y
                                        If A < MinY Then MinY = A
                                        A = SF.Bounds.z
                                        If A < MinZ Then MinZ = A
                                        A = SF.Bounds.x + SF.Bounds.dx
                                        If A > MaxX Then MaxX = A
                                        A = SF.Bounds.y + SF.Bounds.dy
                                        If A > MaxY Then MaxY = A
                                        A = SF.Bounds.z + SF.Bounds.dz
                                        If A > MaxZ Then MaxZ = A
                                
                                End If
                        
                        End If
                End If
                
        Next Geo
    
        If (MaxZ < MinZ) Then GoTo Controlled_Exit
    
        Set PathsToDelete = App.ActiveDrawing.CreatePathCollection

        ' Create a rectangle around the extent
    
        Set Rect = App.ActiveDrawing.CreateRectangle(MinX, MinY, MaxX, MaxY)
        Rect.ToolInOut = acamOUTSIDE
        Rect.Selected = True
        Call PathsToDelete.Add(Rect)
       
        ' Select the geometries
        For Each Geo In Geos
        
                Set P = gp_GetPathFromObject(Geo)
                
                If Not (P Is Nothing) Then
                        
                        ' select it for machining
                        P.Selected = True
                        
                        ' IMPORTANT: Associate the geometry with the MillData
                        '
                        Call MDForAssociate.AssociateGeometry(P, 0)
                
                End If
                
        Next Geo
    
        ' Select the splines
        For Each Geo In Geos
                
                Set C = gsl_GetSplineFromObject(Geo)
                
                If Not (C Is Nothing) Then
                
                        Set P2 = C.CreatePath(0.5)
                        
                        If P2.Closed Then P2.ToolInOut = acamOUTSIDE
                        
                        ' select it for machining
                        P2.Selected = True
                        
                        Call PathsToDelete.Add(P2)
            
                        ' IMPORTANT: Associate the spline with the MillData
                        '
                        Call MDForAssociate.AssociateGeometry(C, 0)
            
                End If
        
        Next Geo
            
        With MD
                
                .SafeRapidLevel = MaxZ + MT.Diameter * 0.5
                .RapidDownTo = MaxZ + MT.Diameter * 0.1
                .MaterialTop = MaxZ
                .FinalDepth = MinZ
                .NumberOfCuts = (MaxZ - MinZ) / MT.Diameter * 2 + 1
                .Stock = g_nStock
      
                Set ToolPaths = .RoughFinish
        
        End With
    
        ' delete the temp geos
        Call PathsToDelete.Delete
            
        ' IMPORTANT: In order for an operation to be editable, we must associate
        '            the appropriate geometries and the generated toolpaths
        '            with the MillData that the toolpaths were created from.
        '
        '            We must also set the names of the functions in the Events module
        '            for this add-in. These names can be anything, but it is good
        '            practice to use names that clearly represent their purpose.
        '
        With MDForAssociate
        
                Call .AssociateToolPaths(ToolPaths)
                        
                ' name of function in Events module to be called when updating
                ' an operation that was created with this MillData
                '
                ' See Events.UpdateSolidRoughFinish
                '
                Call .SetUpdateFunction("UpdateSolidRoughFinish")
                
                ' name of function in Events module to be called when editing
                ' an operation that was created with this MillData
                '
                ' See Events.EditSolidRoughFinish
                '
                Call .SetEditFunction("EditSolidRoughFinish")
                
                ' name of function in Events module to be called when adding a
                ' geometry to an operation that was created with this MillData
                '
                ' See Events.BeforeAddGeometriesSolidRoughFinish
                '
                Call .SetBeforeAddGeometriesFunction("BeforeAddGeometriesSolidRoughFinish")
                
                ' name of function in Events module to be called when removing a
                ' geometry from an operation that was created with this MillData
                '
                ' See Events.BeforeRemoveGeometrySolidRoughFinish
                '
                Call .SetBeforeRemoveGeometryFunction("BeforeRemoveGeometrySolidRoughFinish")
                
                ' name of function in Events module to be called when moving a
                ' geometry from an operation that was created with this MillData
                ' to its own operation
                '
                ' See Events.BeforeMoveToOwnOpSolidRoughFinish
                '
                Call .SetBeforeMoveToOwnOpFunction("BeforeMoveToOwnOpSolidRoughFinish")
                                
                ' name of function in Events module to be called when changing a
                ' tool within an operation that was created with this MillData
                '
                ' See Events.BeforeChangeToolSolidRoughFinish
                '
                Call .SetBeforeChangeToolFunction("BeforeChangeToolSolidRoughFinish")
                
        End With
        
        ' IMPORTANT: Save the new user settings to the MillData
        '
        Call GlobalsToAttributes(MDForAssociate)
        
Controlled_Exit:
        
        Set MT = Nothing
        Set MD = Nothing
        Set SP = Nothing
        Set SF = Nothing
        Set S = Nothing
        Set P = Nothing
        Set P2 = Nothing
        Set C = Nothing
        Set PathsToDelete = Nothing
        Set Rect = Nothing
        Set ToolPaths = Nothing

Exit Sub
        
End Sub

Public Function gp_GetPathFromObject(AO As Object) As Path
        
        Dim pthRet                  As Path
        
On Error GoTo ErrTrap
         
        If (AO Is Nothing) Then GoTo Controlled_Exit
                
        ' attempt to extract a single Path object from the passed AlphacamObject
                
        Set pthRet = Nothing
        Set pthRet = AO
        
Controlled_Exit:

        Set gp_GetPathFromObject = pthRet
        
        Set pthRet = Nothing

Exit Function

ErrTrap:
        
        Set pthRet = Nothing
        Resume Controlled_Exit
        
End Function

Public Function gsp_GetSolidPartFromObject(AO As Object) As SolidPart
        
        Dim pthRet                  As SolidPart
        
On Error GoTo ErrTrap
         
        If (AO Is Nothing) Then GoTo Controlled_Exit
                
        ' attempt to extract a single SolidPart object from the passed AlphacamObject
                
        Set pthRet = Nothing
        Set pthRet = AO
        
Controlled_Exit:

        Set gsp_GetSolidPartFromObject = pthRet
        
        Set pthRet = Nothing

Exit Function

ErrTrap:
        
        Set pthRet = Nothing
        Resume Controlled_Exit
        
End Function

Public Function gsu_GetSurfaceFromObject(AO As Object) As Surface
        
        Dim pthRet                  As Surface
        
On Error GoTo ErrTrap
         
        If (AO Is Nothing) Then GoTo Controlled_Exit
                
        ' attempt to extract a single Surface object from the passed AlphacamObject
                
        Set pthRet = Nothing
        Set pthRet = AO
        
Controlled_Exit:

        Set gsu_GetSurfaceFromObject = pthRet
        
        Set pthRet = Nothing

Exit Function

ErrTrap:
        
        Set pthRet = Nothing
        Resume Controlled_Exit
        
End Function

Public Function gsl_GetSplineFromObject(AO As Object) As Spline
        
        Dim pthRet                  As Spline
        
On Error GoTo ErrTrap
         
        If (AO Is Nothing) Then GoTo Controlled_Exit
                
        ' attempt to extract a single Spline object from the passed AlphacamObject
                
        Set pthRet = Nothing
        Set pthRet = AO
        
Controlled_Exit:

        Set gsl_GetSplineFromObject = pthRet
        
        Set pthRet = Nothing

Exit Function

ErrTrap:
        
        Set pthRet = Nothing
        Resume Controlled_Exit
        
End Function

Public Function gsf_GetSolidFaceFromObject(AO As Object) As SolidFace
        
        Dim pthRet                  As SolidFace
        
On Error GoTo ErrTrap
         
        If (AO Is Nothing) Then GoTo Controlled_Exit
                
        ' attempt to extract a single SolidFace object from the passed AlphacamObject
                
        Set pthRet = Nothing
        Set pthRet = AO
        
Controlled_Exit:

        Set gsf_GetSolidFaceFromObject = pthRet
        
        Set pthRet = Nothing

Exit Function

ErrTrap:
        
        Set pthRet = Nothing
        Resume Controlled_Exit
        
End Function

