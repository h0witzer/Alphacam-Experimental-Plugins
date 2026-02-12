Attribute VB_Name = "GetToolGeometry"
Option Explicit
'

Public Sub GetToolGeometry()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.GetToolGeometry
    Dim PS As Paths
    Dim MT As MillTool
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetGetToolGeometryAddIn
    
    ' get geometries from a given tool
    Set MT = App.SelectTool("$USER")
    
    If Not (MT Is Nothing) Then
        Set PS = oAddIn.GetGeometries(MT)
        If Not (PS Is Nothing) Then
            Debug.Print PS.Count
        End If
    End If
    
    ' NOTE: to get the geometry from the currently selected tool
    '       and insert it into the active drawing, simply call .Run
    '
    'Call oAddIn.Run
    
    Set MT = Nothing
    Set PS = Nothing
    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
End Sub

