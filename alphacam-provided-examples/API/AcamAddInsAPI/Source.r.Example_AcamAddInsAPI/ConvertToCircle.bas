Attribute VB_Name = "ConvertToCircle"
Option Explicit
'

Public Sub ConvertToCircle()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.ConvertToCircle
    
On Error GoTo ErrTrap
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetConvertToCircleAddIn
    
    ' calling .Run will display the settings dialog and convert
    ' all selected geometries. this is the same as running the
    ' Convert to Circle command from within Alphacam.
    
    Call oAddIn.Run
        
Controlled_Exit:

    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub

Public Sub ConvertToCircle2()

    Dim AA              As AcamAddIns.AddIns
    Dim AI              As AcamAddInsInterface.AddInsInterface
    Dim objAddIn        As AcamAddIns.ConvertToCircle
    Dim pthRect         As Path
    Dim pthReturn       As Path
    Dim pthsRect        As Paths
    Dim pthsReturn      As Paths
    Dim pthSpline       As Path
    Dim splTest         As Spline
    Dim splsTest        As Splines
    
On Error GoTo ErrTrap

    App.New

    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set objAddIn = AA.GetConvertToCircleAddIn
    
    Set pthRect = ActiveDrawing.CreateRectangle(100, 0, 200, 100)
    Set pthReturn = objAddIn.ConvertGeo(pthRect, 0.1)
    pthReturn.Color = acamDARK_RED
    pthReturn.Redraw
    
    Set pthsRect = ActiveDrawing.CreatePathCollection
    pthsRect.Add ActiveDrawing.CreateRectangle(300, 0, 400, 100)
    pthsRect.Add ActiveDrawing.CreateRectangle(300, 300, 400, 400)
    
    Set pthsReturn = ActiveDrawing.CreatePathCollection
    Set pthsReturn = objAddIn.ConvertGeos(pthsRect, 0.1)
    
    For Each pthReturn In pthsReturn
      pthReturn.Color = acamYELLOW
      pthReturn.Redraw
    Next
    
    Set pthSpline = ActiveDrawing.CreateRectangle(500, 0, 600, 100)
    Set splTest = pthSpline.CreateSpline(0.1)
    
    Set pthReturn = objAddIn.ConvertSpline(splTest, 0.1)
    pthReturn.Color = acamCYAN
    pthReturn.Redraw
    
    Set pthsRect = ActiveDrawing.CreatePathCollection
    pthsRect.Add ActiveDrawing.CreateRectangle(700, 0, 800, 100)
    pthsRect.Add ActiveDrawing.CreateRectangle(700, 300, 800, 400)
    
    Set splsTest = ActiveDrawing.CreateSplineCollection
    
    For Each pthRect In pthsRect
      splsTest.Add pthRect.CreateSpline(0.1)
    Next
    
    Set pthsReturn = ActiveDrawing.CreatePathCollection
    Set pthsReturn = objAddIn.ConvertSplines(splsTest, 0.1)
    
    For Each pthReturn In pthsReturn
      pthReturn.Color = acamMAGENTA
      pthReturn.Redraw
    Next
    
    ActiveDrawing.ZoomAll
        
Controlled_Exit:
        
        
    Set AA = Nothing
    Set AI = Nothing
    Set objAddIn = Nothing
        
Exit Sub

ErrTrap:
  
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit

End Sub

