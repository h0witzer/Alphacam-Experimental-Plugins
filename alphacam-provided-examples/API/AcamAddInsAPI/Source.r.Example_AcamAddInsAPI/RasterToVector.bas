Attribute VB_Name = "RasterToVector"
Option Explicit
'

Public Sub RasterToVector()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.RasterToVector
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetRasterToVectorAddIn
    
    Dim S As String
    If oAddIn.GetVectorizeSettingsFileName(AlphaFileAction_Open, "", S) Then
        Debug.Print S
    End If
    
    Exit Sub
    
    ' setup the r2v settings
    With oAddIn.Settings
            
        .ImageFileName = "C:\Alphacam\LICOMDIR\CADFILES\PEGASUS.TIF"
                            
        .ClearLayer = True
        .ClearMemory = True
        .CreateBorder = True
        .InsertImageIntoBorder = True
                        
        .LayerName = "R2V API Example"
        
        .CropToVectorizedGeometry = False
        .ScaleToFitArea = False
        .ScaleToFitAreaKeepAspectRatio = True
        .ScaleToFitAreaX = 100
        .ScaleToFitAreaY = 200
        
        Call .SetVectorizeSettingsFromFile("C:\Alphacam\LICOMDIR\R2VSettings\Lines, Arcs and Curves.r2v")
    
    End With
        
    ' vectorize
    If Not oAddIn.VectorizeImage(App.ActiveDrawing) Then
        MsgBox "Raster to Vector failed.", vbExclamation
    End If
        
    ' NOTE: to simply launch the main R2V interface, call .Run with no arguments
    'Call oAddIn.Run
    
    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
End Sub

