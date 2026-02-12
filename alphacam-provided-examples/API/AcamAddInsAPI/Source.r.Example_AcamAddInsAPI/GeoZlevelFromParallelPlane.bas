Attribute VB_Name = "GeoZlevelFromParallelPlane"
Option Explicit
'

Public Sub GeoZlevelFromParallelPlane()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.GeoZFromParallelPlanes
    Dim PS As Paths
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetGeoZFromParallelPlanesAddIn
    
    ' get geos to use
    Set PS = App.ActiveDrawing.Geometries
    
    ' set z levels using all geos within the active drawing
    Call oAddIn.Run(PS)
    
    ' NOTE: to have the user select which geos to use, call .Run with no arguments
    'Call oAddIn.Run
    
    Set PS = Nothing
    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
End Sub
