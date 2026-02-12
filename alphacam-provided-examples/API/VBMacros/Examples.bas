Attribute VB_Name = "Examples"
Option Explicit

Public Sub Text()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Drw.Font = "AStencil"
    Drw.CreateText "AlphaCAM Stencil Font", 0, 0, 10
    Drw.Font = "TArial"
    Drw.CreateText "TrueType Arial Font", 0, 20, 8
    Drw.ZoomAll
End Sub

Public Sub TextAlongPath()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    
    Dim G As Geo2D
    Dim P As Path
    Set G = Drw.Create2DGeometry(0, 0)
    G.AddArcPointRadius 50, 0, 75, True, False
    Set P = G.Finish
    
    Drw.CreateTextAlongPath "AlphaCAM", P, acamJustifyCENTER, 3, 0.2
    
    Drw.ZoomAll
End Sub

' Create a work plane and draw a circle in it
Public Sub CircleInWorkPlane()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim WP As WorkPlane
    Set WP = Drw.CreateWorkPlane(100, 0, 0, 100, 1, 0, 100, 0, 1)
    Dim P As Path
    Set P = Drw.CreateCircle(20, 0, 0)
    P.SetWorkPlane WP
    Drw.ThreeDViews = True
End Sub

' Show name of current layer
Public Sub LayerName()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim Lyr As layer
    Set Lyr = Drw.GetLayer
    If Lyr Is Nothing Then
        MsgBox "No active user layer"
    Else
        MsgBox "Layer name is " & Lyr.Name
    End If
End Sub

Public Sub PickElem()
    Dim X As Double, Y As Double
    Dim Drw As Drawing
    Dim P As Path
    Dim Elem As Element
    Set Drw = App.ActiveDrawing
    Set P = Drw.UserSelectOneGeo("Pick Geometry")
    If P Is Nothing Then End
    Set Elem = Drw.GetPickElem
    X = Drw.GetPickPointX
    Y = Drw.GetPickPointY
    MsgBox "Pick Point X, Y = " & X & ", " & Y
    ' Properties of elem may be accessed as required
End Sub

' One way to select geometries,
' also see examples using UserSelectMultiGeosCollection (SelectCollection)

Public Sub SelectGeos()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    
    If Drw.UserSelectMultiGeos("Select Geometries", 0) Then
        Dim Geo As Path
        For Each Geo In Drw.Geometries
            If Geo.Selected Then
                ' do something with geo….
                Geo.ScaleL2 2, 1, 0, 0
                Geo.Selected = False
                Geo.Redraw
            End If
        Next Geo
    End If
End Sub

Public Sub CopyToolGeo()
    Dim Drw As Drawing
    Dim Tool As MillTool
    Set Drw = App.ActiveDrawing
    Set Tool = App.GetCurrentTool
    If Tool Is Nothing Then
        MsgBox "No current tool"
        End
    End If
    If Tool.Type <> acamToolUSER Then
        MsgBox "Tool is not a user-defined tool"
        End
    End If
    
    Dim P As Path
    Set P = Tool.GetGeometry
   
    Dim Elem As Element
    Dim Geo As Geo2D
    Set Elem = P.Elements(1)
    Set Geo = Drw.Create2DGeometry(Elem.StartXL, Elem.StartYL)
    For Each Elem In P.Elements
        If Elem.IsLine Then
            Geo.AddLine Elem.EndXL, Elem.EndYL
        Else
            Geo.AddArcPointCenter Elem.EndXL, Elem.EndYL, Elem.CenterXL, Elem.CenterYL, Elem.CW
        End If
    Next Elem
    Geo.Finish
    Drw.ZoomAll
End Sub

Public Sub DefineUserDefinedTool()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim P2 As Geo2D
    Dim P3 As Path

    ' Define a user defined tool
    ' First define the profile

    Set P2 = Drw.Create2DGeometry(-15, 50)
    P2.AddLine -15, 20
    P2.AddLine -2, 0
    P2.AddLine 2, 0
    P2.AddLine 15, 20
    P2.AddLine 15, 50
    Set P3 = P2.Finish

    ' Define and select the tool, the SetGeometry method takes
    ' the path object returned by the Finish method

    Dim Tool As MillTool
    Set Tool = App.CreateTool
    With Tool
        .Type = acamToolUSER
        .Name = "T85, user shape (API)"
        .Number = 85
        .FeedPerTooth = 0.125
        .Units = 1
        .SetGeometry P3
        If .UserConfirm Then
            .Select
        End If
    End With

End Sub

Sub PocketRectangle()
    App.New
    
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim width As Double
    Dim height As Double
    Dim corner_rad As Double
    
    width = 150
    height = 100
    corner_rad = 10
    Dim Geo As Geo2D
    Dim P1 As Path, P2 As Path
    Set Geo = Drw.Create2DGeometry(-width / 2, 0)
    Geo.AddLine -width / 2, height
    Geo.AddLine width / 2, height
    Geo.AddLine width / 2, 0
    Set P1 = Geo.CloseAndFinishLine
    P1.Fillet corner_rad
    P1.ToolInOut = acamINSIDE
    P1.Selected = True
    Set P2 = Drw.CreateCircle(height * 0.6, 0, height / 2)
    P2.ToolInOut = acamOUTSIDE
    P2.Selected = True
    Drw.ZoomAll
    GetMillTool "Flat - 10mm"
    Dim mc As MillData
    Set mc = App.CreateMillData
    mc.PocketType = acamPocketCONTOUR
    mc.SafeRapidLevel = 20
    mc.RapidDownTo = 1
    mc.FinalDepth = -8
    mc.WidthOfCut = 7.5
    mc.Stock = 1
    mc.Pocket
End Sub

Sub PointsOn3DGeometry()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim P As Path
    Set P = Drw.UserSelectOneGeo("Select 3D Geometry to step along")
    If Not (P Is Nothing) Then
      Dim Dist As Double
      For Dist = 1 To P.Length Step 10
        Dim Elem As Element
        Dim xp As Double, yp As Double, zp As Double, ok As Boolean
        ok = P.PointAtDistanceAlongPathG(Dist, xp, yp, zp, Elem)
        If ok Then
          ' Draw a polyline
          Dim Geo As PolyLine
          Set Geo = Drw.Create3DPolyline(xp, yp, zp)
          Geo.AddLine xp, yp, zp + 5
          Geo.Finish
        End If
      Next Dist
    End If
End Sub

Sub PointsOn2DGeometry()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim P As Path
    Set P = Drw.UserSelectOneGeo("Select 2D Geometry to step along")
    If Not (P Is Nothing) Then
        Dim Dist As Double, PathLen As Double
        PathLen = P.Length
        For Dist = 1 To PathLen Step 10
            Dim Elem As Element
            Dim xp As Double, yp As Double, ok As Boolean
            ok = P.PointAtDistanceAlongPathL(Dist, xp, yp, Elem)
            If ok Then
                ' Draw a circle
                Drw.CreateCircle 5, xp, yp
            Else
                End
            End If
        Next Dist
    End If
End Sub

' Draw the value of the angle (in degrees) to the next element
' at each corner of a selected geometry, assumed closed

Public Sub ElementAngle()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Drw.Font = "TArial"
    Dim P1 As Path
    Do
        Set P1 = Drw.UserSelectOneGeo("ANGLES: Pick Geometry")
        If Not (P1 Is Nothing) Then
            Dim h As Double
            h = (P1.MaxXL - P1.MinXL + P1.MaxYL - P1.MinYL) / 80
            Dim E As Element
            For Each E In P1.Elements
                Dim Ang As Double
                Ang = E.AngleToElement(E.GetNext)
                ' Chr(176) is the degrees symbol in a TrueType font
                Dim s As String
                s = Format(Ang, "0.00") & Chr(176)
                ' Draw the text and loop for each path in the
                ' returned collection, marking it as dimension
                Dim P2 As Path
                For Each P2 In Drw.CreateText(s, E.EndXL + h, E.EndYL + h, h)
                    P2.Dimension = True
                    P2.Redraw
                Next P2
            Next E
        End If
    Loop Until (P1 Is Nothing)
End Sub

Public Sub Chamfer()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim Geo As Geo2D, P1 As Path, E1 As Element, E2 As Element
    Set Geo = Drw.Create2DGeometry(0, 0)
    Geo.AddLine 0, 20
    Geo.AddLine 40, 20
    Geo.AddLine 40, 0
    Set P1 = Geo.Finish
    Set E1 = P1.GetFirstElem
    Set E2 = E1.GetNext
    E1.Chamfer E1.GetNext, False, True, 2, 4
    E2.Chamfer E2.GetNext, False, True, 4, 2
End Sub


Public Sub Circles()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim P1 As Path, P2 As Path
    Dim E1 As Element, E2 As Element
    Dim X1 As Double, Y1 As Double, X2 As Double, Y2 As Double
    Dim N As Long
    Set P1 = Drw.CreateCircle(50, 10, 20)
    Set P2 = Drw.CreateCircle(80, 40, 30)
    Set E1 = P1.GetFirstElem
    Set E2 = P2.GetFirstElem
    N = E1.Intersect(E2, X1#, Y1#, X2#, Y2#)
    If N = 2 Then
    Drw.Create2DLine(X1#, Y1#, X2#, Y2#).Construction = True
    End If
    Drw.ZoomAll

End Sub

Public Sub int2()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim P1 As Path, P2 As Path
    Dim E1 As Element, E2 As Element
    Dim X1 As Double, Y1 As Double, X2 As Double, Y2 As Double
    Dim N As Long
    Set P1 = Drw.Create2DLine(0, 0, 10, 10)
    Set P2 = Drw.Create2DLine(40, 0, 30, 10)
    Set E1 = P1.GetFirstElem
    Set E2 = P2.GetFirstElem
    N = E1.IntersectInfinite(E2, X1#, Y1#, X2#, Y2#)
    If N = 1 Then
    Drw.CreateCircle 5, X1#, Y1#
    End If
    Drw.ZoomAll
End Sub

Public Sub layers1()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim Lyr As layer
    Set Lyr = Drw.CreateLayer("CIRCLES")
    Lyr.Color = acamRED
    Drw.SetLayer Lyr
    Drw.CreateCircle 20, 0, 0
    Drw.SetLayer Nothing    ' Cancel active layer
End Sub

Public Sub layers2()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim Lyr As layer
    Set Lyr = Drw.CreateLayer("CIRCLES")
    Lyr.Color = acamRED
    Dim P As Path
    Set P = Drw.CreateCircle(20, 0, 0)
    P.SetLayer Lyr
End Sub

Public Sub LayersNames()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim Lyr As layer
    For Each Lyr In Drw.Layers
    If Lyr.Special = 0 Then
        MsgBox "Layer name = " & Lyr.Name
    End If
    Next Lyr

End Sub

Public Sub WorkPlaneIntersection()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing

    Dim WP As WorkPlane
    Set WP = Drw.GetWorkPlane
    If WP Is Nothing Then
        MsgBox "There must be a Current Work Plane"
        End
    End If

    Dim P As Path
    Set P = Drw.UserSelectOneGeo("Select Geometry to find Intersection with WP")
    If Not (P Is Nothing) Then
        Dim E1 As Element
        Set E1 = P.GetLastElem
        Dim xp As Double, yp As Double, zp As Double, ok As Boolean
        ok = WP.IntersectLine(E1.StartXG, E1.StartYG, E1.StartZG, E1.EndXG, E1.EndYG, E1.EndZG, xp, yp, zp)
        If ok Then
            ' Draw a vertical 3D polyline at the intersection point
            Dim P3 As PolyLine
            Set P3 = Drw.Create3DPolyline(xp, yp, zp)
            P3.AddLine xp, yp, zp + 10
            P3.Finish
        Else
            MsgBox "Unable to find intersection point"
        End If
    End If

End Sub

Public Sub CircleProps()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim P As Path
    For Each P In Drw.Geometries
        Dim c As CircleProperties
        Set c = P.GetCircleProperties
        If Not (c Is Nothing) Then
            MsgBox "Circle Diameter = " & c.Diameter
        End If
    Next P
End Sub

Public Sub GeoCad2Sections()
    Dim Drw As Drawing
    Dim Geo As GeoCad
    Dim Geos As Paths
    Dim P As Path
    Dim X As Double
    Set Drw = App.ActiveDrawing
    App.New
    Set Geo = Drw.CreateCadGeometry
    For X = 0 To 100 Step 25
    Geo.AddLine X, 0, 0, X, 0, 40
    Geo.AddLine X, 50, 0, X, 50, 40
    Geo.AddArc X, 20, 30, 1, 0, 0, X, 50, 40, X, 0, 40
    Next X
    Set Geos = Geo.Finish
    Drw.ThreeDViews = True
    MsgBox "Number of paths = " & Geos.Count
    Geos.Selected = True
    Drw.SurfaceFromGeoSections
End Sub

'Public Sub NestTest()
'    Dim Drw As Drawing
'    Dim Sheet As Path
'    Dim Nest As NestData
'    Set Drw = App.ActiveDrawing
'    App.New
'    Set Nest = Drw.CreateNestData("C:\apsnlist\ab toolpaths.anl")
'    Set Sheet = Drw.CreateRectangle(0, 0, 150, 100)
'    Nest.AddSheet Sheet, Drw.Materials(1).Name, 0.25, 2
'    Set Sheet = Drw.CreateRectangle(200, 0, 400, 150)
'    Nest.AddSheet Sheet, Drw.Materials(1).Name, 0.25, 2
'    Drw.ZoomAll
'    Nest.DoNest
'    Drw.ZoomAll
'End Sub

Public Sub CurMaterial()
    MsgBox App.ActiveDrawing.GetMaterial.Name
End Sub

Public Sub SelectCollection()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    
    Dim Geos As Paths
    Set Geos = Drw.UserSelectMultiGeosCollection("Select Geometries", 0)
    If Geos.Count > 0 Then
        Dim Geo As Path
        For Each Geo In Geos
            ' do something with geo….
            Geo.ScaleL 0.5, 0, 0
        Next Geo
    End If
End Sub

Public Sub ZoomBox()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    
    Dim Geos As Paths
    Set Geos = Drw.UserSelectMultiGeosCollection("Select Geometries", 0)
    If Not (Geos Is Nothing) Then
        Dim X1 As Double, Y1 As Double, X2 As Double, Y2 As Double
        Geos.GetExtentL X1, Y1, X2, Y2
        Drw.ZoomToBox X1, Y1, X2, Y2, 2
        MsgBox "Zoomed"
    End If
End Sub

Public Sub TestCopySub()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim P1 As Path, P2 As Path
    
    Set P1 = Drw.ToolPaths(1)
    
    Dim group As Integer
    group = Drw.GetNextGroupNumberForToolPaths
    
    ' Set group number of path to be copied
    P1.group = group
    ' Get group number of new path
    group = Drw.GetNextGroupNumberForToolPaths
    
    Set P2 = P1.CopyAsSubroutine(100, 100, group)
    
    Drw.Options.ShowRapids = True
    Drw.ZoomAll
    MsgBox "Pause"
End Sub

Public Sub TestDrag()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim P1 As Path
    
    Set P1 = Drw.Geometries(1)
    Dim Ret As Long
    Dim XBase As Double, YBase As Double
    Dim XNew As Double, YNew As Double
    
    XBase = (P1.MinXL + P1.MaxXL) / 2
    YBase = (P1.MinYL + P1.MaxYL) / 2
    Ret = P1.DragMove("Drag to new position", XBase, YBase, 0, Nothing, XNew, YNew)
    
    If Ret = 0 Then
        P1.MoveL XNew - XBase, YNew - YBase
    End If
    
'    MsgBox Ret
    MsgBox XNew & ", " & YNew
End Sub

Public Sub TestRectangle()
    MsgBox IIf(App.ActiveDrawing.Geometries(1).GetRectangleProperties Is Nothing, "No", "Yes")
End Sub

Public Sub TestSheetArea()
    Dim SheetArea As Double, ScrapArea As Double
    App.ActiveDrawing.Geometries(1).GetSheetArea acamDARK_CYAN, SheetArea, ScrapArea
    MsgBox "Sheet = " & SheetArea & ", scrap = " & ScrapArea
End Sub

Public Sub TestIntersectLine()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    
    Dim P1 As Path
    Set P1 = Drw.CreateRectangle(0, 0, 100, 100)
    
    Dim N As Long
    Dim XInt, YInt
    
    N = P1.IntersectWithLine(10, 10, 20, 120, False, XInt, YInt)
    If N = 2 Then
        Drw.Create2DLine XInt(0), YInt(0), XInt(1), YInt(1)
    End If
End Sub

Public Sub TestSame()
    Dim P1 As Path
    Dim E1 As Element, E2 As Element
    
    Set P1 = App.ActiveDrawing.Geometries(1)
    Set E1 = P1.Elements(1)
    Set E2 = P1.Elements(1)
    MsgBox E1.IsSame(E2)
    MsgBox IIf(E1 Is E2, "Yes", "No")
End Sub

Public Sub TestIntersect()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    
    Drw.SetGeosSelected False
    
    Dim P1 As Path, P2 As Path
    Set P1 = Drw.Geometries(1)
    For Each P2 In Drw.Geometries
        If Not (P1 Is P2) Then
            If P2.TestIntersectPath(P1, 0, 0) Then
                P2.Selected = True
                P2.Redraw
            End If
        End If
    Next P2
End Sub

Public Sub FilletLayer()
    ' Fillet all the geometries on user layer "BOXES"
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    
    Dim Lyr As layer
    On Error Resume Next
    Set Lyr = Drw.Layers("BOXES")
    If Err.Number <> 0 Then
        MsgBox "Layer BOXES not found", vbExclamation
        End
    End If
    
    Dim P As Path
    For Each P In Lyr.Geometries
        P.Fillet 5
    Next P
End Sub

Public Sub Eval()
    Dim X As Double
    X = App.Frame.Evaluate("atan2(1,3)")
    MsgBox "Atan(1/3) = " & X, vbInformation
End Sub


Public Sub GetNumber()
    Dim X As Single
    X = 56
    If App.Frame.InputFloatDialog("AlphaCAM", "Enter X (> 0)", acamFloatPOSITIVE, X) Then
        MsgBox "X = " & X
    End If
End Sub

Public Sub GetLongNumber()
    Dim N As Long
    N = 100
    If App.Frame.InputIntegerDialog("AlphaCAM", "Enter N (> 0)", acamFloatPOSITIVE, N) Then
        MsgBox "N = " & N
    End If
End Sub


' Do multiple rough/finish paths on selected geometries.
' The geometries are selected using a Paths Collection so
' they can be reselected with a single command.

Public Sub CollectionExample2()
    Const NPass As Integer = 5
    Const StockStep As Double = 0.5
    Dim IPass As Integer
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    
    Dim Geos As Paths
    Set Geos = Drw.UserSelectMultiGeosCollection("Multi Finish: Select Geometries", 0)
    If Geos.Count = 0 Then End
    
    ' Set tool sides for rough/finish
    Geos.Selected = True
    Drw.SetToolSideAuto acamToolSideCUT
    
    GetMillTool "Flat - 10mm"
    
    For IPass = 1 To NPass
        Dim MD As MillData
        Set MD = App.CreateMillData
        MD.SafeRapidLevel = 25
        MD.RapidDownTo = 2
        MD.FinalDepth = -8
        
        MD.Stock = StockStep * (NPass - IPass)
        
        Geos.Selected = True ' select all the paths in the collection
        
        Dim Tps As Paths
        Set Tps = MD.RoughFinish
        
        ' Apply lead-in/out on the new tool paths
        Dim Tp As Path
        For Each Tp In Tps
            Tp.SetLeadInOutAuto acamLeadARC, acamLeadLINE, 2, 2, 60, False, False, 2
        Next Tp
    Next IPass
End Sub

' Try to select given Mill tool.
' If not successful, ask the user to select a tool.
' Illustrates error handling.

Private Sub GetMillTool(Name As String) ' Name of tool, eg "Flat - 10mm", no folder or extension
    ' Enable error handling
    On Error Resume Next
    ' Try to select given tool
    App.SelectTool App.LicomdatPath & "LICOMDAT\MTOOLS.ALP\" & Name & ".AMT"
    If Err.Number <> 0 Then
        ' Failed so ask user
        Err.Clear
        Dim F1 As String, F2 As String
        If Not App.GetAlphaCamFileName(Name & " not found: Select Tool", acamFileTypeTOOL, acamFileActionOPEN, F1, F2) Then
            End
        End If
        ' Select chosen tool
        App.SelectTool F1
    End If
End Sub

' Draw a rectangle and create a finish path with lead-in/out

Public Sub FinishPath()
    App.New
    
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing

    GetMillTool "Flat - 10mm"
   
    ' Draw the geometry, set the tool side and select it
    Dim Geo As Path
    Set Geo = Drw.CreateRectangle(0, 0, 100, 100)
    Geo.SetStartPoint 50, 100
    Geo.ToolInOut = acamOUTSIDE
    Geo.Selected = True
    
    ' Setup the machining data
    Dim MD As MillData
    Set MD = App.CreateMillData
    
    MD.XYCorners = acamCornersSTRAIGHT
    MD.SafeRapidLevel = 20
    MD.RapidDownTo = 1
    MD.FinalDepth = -10
    
    ' Create the tool path, storing the returned Paths
    ' object so lead-in/out can be added
    Dim Tps As Paths
    Set Tps = MD.RoughFinish
    
    ' Add lead-in/out
    Tps(1).SetLeadInOutAuto acamLeadARC, acamLeadLINE, 1.5, 1.5, 45, False, False, 0
    
    Drw.ZoomAll
End Sub

' Draw a rectangle and engrave it

Public Sub EngraveRectangle()
    App.New
    
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing

    GetMillTool "User - Cone - 10mm  x  45 deg"
   
    ' Draw the geometry, set the tool side and select it
    Dim Geo As Path
    Set Geo = Drw.CreateRectangle(0, 0, 100, 100)
    Geo.SetStartPoint 50, 100
    Geo.ToolInOut = acamINSIDE
    Geo.Selected = True
    
    ' Setup the machining data
    Dim MD As MillData
    Set MD = App.CreateMillData
    
    MD.EngraveType = acamEngraveGEOMETRIES
    MD.XYCorners = acamCornersSTRAIGHT
    
    MD.SafeRapidLevel = 20
    MD.RapidDownTo = 1
    MD.FinalDepth = -4
    MD.EngraveCornerAngleLimit = 120
        
'    MD.ChordError = 0.01
'    MD.StepLength = 0.1
    
    ' Create the tool path
    Dim Tps As Paths
    Set Tps = MD.Engrave

    Drw.ThreeDViews = True
End Sub

' Draw an array of circles, let the user select ones to drill,
' and drill and tap them

Public Sub DrillAndTapHoles()
    App.New
    
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
   
    ' Draw the circles
    Dim X As Double, Y As Double
    For X = 0 To 200 Step 32
        For Y = 0 To 100 Step 25
            Drw.CreateCircle 10, X, Y
        Next Y
    Next X
    
    ' Let the user select some
    Dim Geos As Paths
    Set Geos = Drw.UserSelectMultiGeosCollection("Select circles to drill", 0)
    If Geos.Count = 0 Then
        End
    End If
   
    ' Select the circles
    Geos.Selected = True
    
    ' Select a drill
    GetMillTool "Drill - 10mm"
    
    ' Setup the machining data
    Dim MD As MillData
    Set MD = App.CreateMillData
    
    MD.DrillType = acamDRILL
    MD.SafeRapidLevel = 20
    MD.RapidDownTo = 1
    MD.BottomOfHole = -15
    
    ' Create the tool paths
    MD.DrillTap

    ' Select the circles again
    Geos.Selected = True
    
    ' Select a tap
    GetMillTool "Tap - 10mm x 1mm pitch"
    
    MD.DrillType = acamTAP
    MD.SafeRapidLevel = 20
    MD.RapidDownTo = 1
    MD.BottomOfHole = -10
    MD.SpindleSpeed = 100
    MD.ThreadPitch = App.GetCurrentTool.Pitch
    
    ' Create the tool paths
    MD.DrillTap
End Sub

Public Sub BridgeTest()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    
    Dim P1 As Path
    Dim P2 As Path
    
    Set P1 = Drw.CreateRectangle(0, 0, 100, 100)
    Set P2 = Drw.CreateRectangle(150, 10, 300, 120)
    
    P1.Bridge P2, 100, 50, 150, 60, 5
    
    Drw.ZoomAll
End Sub

Sub ShowPathLength()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim P As Path
    Do
        Set P = Drw.UserSelectOneGeo("Select Geometry")
        If Not (P Is Nothing) Then
            Dim PathLen As Double
            PathLen = P.Length
            MsgBox "Path Length = " & PathLen
        End If
    Loop Until P Is Nothing
End Sub

Sub ShowPathLengthOfLastGeo()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim P As Path
    Set P = Drw.GetLastGeo
    If Not (P Is Nothing) Then
        Dim PathLen As Double
        PathLen = P.Length
        MsgBox "Path Length = " & PathLen
    End If
End Sub

' Reverse order of all geometries

Public Sub OrderTest()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim P As Path
    Set P = Drw.GetLastGeo
    
    Drw.SetGeosSelected True
    
    Drw.OrderSelectedGeometries P
End Sub

' Ask user for an XY point and draw a line from this point
' to the closest point on each geometry

Public Sub TestClosestPointGeo()
    Dim P As Path
    Dim X1 As Double, Y1 As Double
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    
    If Drw.UserGet2DPoint("Pick Point", X1, Y1) <> acamUserSELECT Then Exit Sub
    
    For Each P In Drw.Geometries
        Dim X2 As Double, Y2 As Double, E As Element
        P.GetClosestPointL X1, Y1, X2, Y2, E
        Drw.Create2DLine X1, Y1, X2, Y2
    Next P
End Sub

' Ask user for an XY point and draw a line from this point
' to the closest point on each tool path

Public Sub TestClosestPointToolpath()
    Dim P As Path
    Dim X1 As Double, Y1 As Double
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    
    If Drw.UserGet2DPoint("Pick Point", X1, Y1) <> acamUserSELECT Then Exit Sub
    
    For Each P In Drw.ToolPaths
        Dim X2 As Double, Y2 As Double, E As Element
        If P.IsPathAllRapids = False Then
            P.GetClosestPointL X1, Y1, X2, Y2, E
            Drw.Create2DLine X1, Y1, X2, Y2
            ' WARNING: If properties of the element (E) are used, and the
            ' path is a subroutine, Path.GetDisplacement must be used and
            ' the returned X and Y added to each point.
            ' GetClosestPointL does this automatically for X1, Y1, X2, Y2
        End If
    Next P
End Sub

Public Sub TestBreak()
    Dim Drw As Drawing
    
    Dim P1 As Path, P2 As Path
    Dim PS As Paths
    
    Set Drw = App.ActiveDrawing
    
    Set P1 = Drw.UserSelectOneGeo("Select a Geometry to Break")
    If P1 Is Nothing Then End
    
    Drw.SetGeosSelected True
    
    Set PS = P1.BreakWithCuttingGeos
    
    ' P1 contains the first bit of the original path.
    ' PS contains the broken off bits.
    
    Drw.SetGeosSelected False
    
    MsgBox PS.Count & " paths broken off"
    
    ' Do something with the broken bits, for example, move them
    
    P1.MoveL 300, 0
    For Each P2 In PS
        P2.MoveL 300, 0
    Next P2
End Sub

' Test slow down for corners

Public Sub SlowDown()
    ' Create a tool path
    FinishPath
    
    ' Apply slow down for corners to it
    Dim P As Path
    Set P = App.ActiveDrawing.ToolPaths(1)
    
    P.SlowDownForCorners 10, 4, 33, 15, 170, True
End Sub
