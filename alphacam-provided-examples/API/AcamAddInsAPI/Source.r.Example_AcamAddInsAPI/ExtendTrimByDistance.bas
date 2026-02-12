Attribute VB_Name = "ExtendTrimByDistance"
Option Explicit
'
Public Sub ExtendTrimByDistance()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.ExtendByDistance
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetExtendByDistanceAddIn
    
    ' Create a reference rectangle and a line to be modified
    Dim p As Path
    App.ActiveDrawing.CreateRectangle 0, 0, 100, 100
    Set p = App.ActiveDrawing.Create2DLine(0, 0, 100, 100)
    
    ' Extend the end of the geometry by 10 units.
    oAddIn.ExtendPath2 p, True, 10, False
        
    ' Trim start of the geometry by (-10) units.
    ' The negative value (-) indicates a Trim should be performed in the geometry and not a extend
    oAddIn.ExtendPath2 p, False, -10, False
            
    App.ActiveDrawing.RedrawShadedViews
    
    ' Alternatively, you can run the command by calling
    'oAddIn.Run (False)
    
Controlled_Exit:

    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
Exit Sub

End Sub

Public Sub ExtendTrimByDistanceUsingPoints()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.ExtendByDistance
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetExtendByDistanceAddIn
    
    ' Create a reference rectangle and a line to be modified
    Dim p As Path
    App.ActiveDrawing.CreateRectangle 0, 0, 100, 100
    Set p = App.ActiveDrawing.Create2DLine(0, 0, 100, 100)
    
    Dim SingleLineElement As Element
    Set SingleLineElement = p.Elements(1)
    
    ' Extend the end of the geometry by 10 units.
    oAddIn.ExtendPath p, SingleLineElement.EndXG, SingleLineElement.EndYG, 10, False
        
    ' Trim start of the geometry by (-10) units.
    ' The negative value (-) indicates a Trim should be performed in the geometry and not a extend
    oAddIn.ExtendPath p, SingleLineElement.StartXG, SingleLineElement.StartYG, -10, False
            
    App.ActiveDrawing.RedrawShadedViews
    
Controlled_Exit:

    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
Exit Sub

End Sub
