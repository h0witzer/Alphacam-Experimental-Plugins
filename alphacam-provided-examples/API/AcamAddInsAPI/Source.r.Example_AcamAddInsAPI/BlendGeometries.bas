Attribute VB_Name = "BlendGeometries"
Option Explicit
'

Public Sub BlendGeometries()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.BlendGeometries
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetBlendGeometriesAddIn
    
    ' calling .Run will prompt the user to select the two geos to
    ' blend and automatically detect which end points to join from
    ' the pick points when selecting the geos. this is the same as
    ' when running the Blend Geometries... command from within Alphacam.
    
    Call oAddIn.Run
        
Controlled_Exit:

    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
Exit Sub
    
End Sub

Public Sub BlendGeometries2()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.BlendGeometries
    Dim P1 As Path
    Dim P2 As Path
    Dim pthsRet As Paths
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetBlendGeometriesAddIn
    
    Set P1 = App.ActiveDrawing.UserSelectOneGeo("Select First Geo")
    If (P1 Is Nothing) Then GoTo Controlled_Exit
    
    P1.Selected = True
    P1.Redraw
    
    Set P2 = App.ActiveDrawing.UserSelectOneGeo("Select Second Geo")
    If (P2 Is Nothing) Then
        P1.Selected = False
        P1.Redraw
        GoTo Controlled_Exit
    End If
    
    ' blend the selected geos. alter the UseStart... arguments to see the affect.
    Set pthsRet = oAddIn.BlendGeos(P1, P2, False, True)
        
Controlled_Exit:

    Set P1 = Nothing
    Set P2 = Nothing
    Set pthsRet = Nothing
    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
Exit Sub
    
End Sub

Public Sub BlendGeometriesAuto()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.BlendGeometries
    Dim PS As Paths
    Dim pthsRet As Paths
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetBlendGeometriesAddIn

    Set PS = App.ActiveDrawing.UserSelectMultiGeosCollection("Select Geos to Blend", 0)
    
    If Not (PS Is Nothing) Then
            
        ' BlendGeosAuto will blend the end point of the first geo
        ' with the start point of the second geo, the end point of the
        ' second geo with the start point of the third geo and so on.
        '
        Set pthsRet = oAddIn.BlendGeosAuto(PS)
            
    End If
        
    Set PS = Nothing
    Set pthsRet = Nothing
    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
End Sub


