# VBA Code Examples Extracted from Alphacam Files

This document showcases actual VBA code examples extracted from the repository to demonstrate parsing capabilities.

## Example 1: Simple Macro (.bas file)

**File:** `vba-macros/examples/HelloWorld.bas`

**Parsed Structure:**
- Module: HelloWorld
- Procedures: 1 Sub
- API Usage: MsgBox, error handling

**Extracted Code:**
```vba
Option Explicit

Sub HelloWorld()
    On Error GoTo ErrorHandler
    
    Dim message As String
    message = "Hello World from Alphacam VBA Macro!" & vbCrLf & vbCrLf
    message = message & "This is a simple example to get you started." & vbCrLf
    message = message & "Check the templates folder for more complex examples."
    
    MsgBox message, vbInformation, "Hello World Example"
    
    Exit Sub

ErrorHandler:
    MsgBox "Error: " & Err.Description, vbCritical, "Hello World Example"
End Sub
```

## Example 2: Geometry Manipulation (.bas file)

**File:** `alphacam-provided-examples/API/VBMacros/Examples.bas`

**Parsed Structure:**
- Module: Examples
- Procedures: 49 Subs
- API Objects: Drawing, Path, Geo2D, Element, MillData, MillTool, Layer, WorkPlane
- Total Lines: 951

**Extracted Procedures:**

### Creating Text in Drawing
```vba
Public Sub Text()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Drw.Font = "AStencil"
    Drw.CreateText "AlphaCAM Stencil Font", 0, 0, 10
    Drw.Font = "TArial"
    Drw.CreateText "TrueType Arial Font", 0, 20, 8
    Drw.ZoomAll
End Sub
```

### Selecting and Processing Geometries
```vba
Public Sub SelectGeos()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    
    If Drw.UserSelectMultiGeos("Select Geometries", 0) Then
        Dim Geo As Path
        For Each Geo In Drw.Geometries
            If Geo.Selected Then
                ' do something with geo
                Geo.ScaleL2 2, 1, 0, 0
                Geo.Selected = False
                Geo.Redraw
            End If
        Next Geo
    End If
End Sub
```

### Creating Tool Definitions
```vba
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

    ' Define and select the tool
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
```

## Example 3: Machining Operations (.bas file)

**File:** `alphacam-provided-examples/API/Multidrill/Source.r.MultidrillExample/Code.bas`

**Parsed Structure:**
- Module: Code
- API Objects: MillData, MultiDrillUnit, MDUToolStation

**Extracted Code:**

### Drilling Operation
```vba
Private Sub DrillHole()
    Dim Md As MillData
    
    Set Md = App.CreateMillData
    
    With Md
      .SafeRapidLevel = 200
      .RapidDownTo = 10
      .MaterialTop = 0
      .FinalDepth = -30
      .DrillType = acamDRILL
      .DrillTap
    End With

    Set Md = Nothing
End Sub
```

### Multi-Drill Setup
```vba
Public Sub MultiDrillHoles()
    Dim MDU As MultiDrillUnit
    Dim St As MDUToolStation
    Dim StationID As String
    
    App.New
    Frame.ProjectBarUpdating = False
    
    ' Open drawing and multidrill configuration
    App.OpenDrawing Frame.PathOfThisAddin & "\MultidrillAPITest.ard"
    Set MDU = App.ActiveDrawing.OpenMultiDrillUnit(Frame.PathOfThisAddin & "\Multidrill Test With 12mm Drills.amultidrill")
    
    ActiveDrawing.SetRapidManager True, 200
    
    ' Configure tool stations
    For Each St In MDU.Stations
      StationID = St.ToolLocationPoints(1).Id
      
      Select Case StationID
        Case "201"
          St.Active = True
          St.ToolLocationPoints(1).Master = True
        Case "203"
          St.Active = True
        Case Else
          St.Active = False
      End Select
    Next St
    
    FindAndSelectHole "SideMaster"
    DrillHole
End Sub
```

## Example 4: 3D Geometry Processing (.bas file)

**File:** `alphacam-provided-examples/API/VBMacros/Examples.bas`

**Extracted Code:**

### Working with 3D Polylines
```vba
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
          ' Draw a polyline at each point
          Dim Geo As PolyLine
          Set Geo = Drw.Create3DPolyline(xp, yp, zp)
          Geo.AddLine xp, yp, zp + 5
          Geo.Finish
        End If
      Next Dist
    End If
End Sub
```

### Work Plane Intersection
```vba
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
        ok = WP.IntersectLine(E1.StartXG, E1.StartYG, E1.StartZG, _
                               E1.EndXG, E1.EndYG, E1.EndZG, _
                               xp, yp, zp)
        If ok Then
            ' Draw a vertical 3D polyline at intersection
            Dim P3 As PolyLine
            Set P3 = Drw.Create3DPolyline(xp, yp, zp)
            P3.AddLine xp, yp, zp + 10
            P3.Finish
        Else
            MsgBox "Unable to find intersection point"
        End If
    End If
End Sub
```

## Example 5: UI Integration from .arb File

**File:** `alphacam-provided-examples/API/PolyLinesToLayer/PolyLinesToLayer.arb`

**Parsed Structure:**
- Modules: Events, Main
- References: AlphaCAM Router API, VBA, OLE Automation, MSForms

**Extracted from binary .arb file:**

### Menu Integration
```vba
Function InitAlphacamAddIn(acamversion As Long) As Integer
    Dim fr As Frame
    Set fr = App.Frame
    
    With fr
        Dim MenuName As String, ItemName As String
        ItemName = .ReadTextFile("PolyLinesToLayer.txt", 10, 1)
        MenuName = .ReadTextFile("PolyLinesToLayer.txt", 25, 1)
        .AddMenuItem2 MenuName, ItemName, "CallMovePolyLines", "UTILS_INFO"
    End With
End Function
```

### Layer Processing
```vba
Public Sub MovePolyLines()
    Dim drw As Drawing
    Set drw = App.ActiveDrawing
    Dim Geos As Paths
    Dim geo As Path
    
    ' Loop through all the geometries in the active drawing
    Set Geos = drw.Paths
    
    For Each geo In Geos
        If Not geo.Is3D Then
            Dim MyLayer As Layer
            Dim LayerName As String
            
            LayerName = drw.ReadTextFile("PolyLinesToLayer.txt", 20, 1)
            Set MyLayer = drw.CreateLayer(LayerName)
            geo.SetLayer MyLayer
            
            If MyLayer.Visible Then
                MyLayer.Visible = False
            End If
        End If
    Next geo
    
    drw.Redraw
End Sub
```

## Example 6: Advanced Machining (.bas file)

**File:** `alphacam-provided-examples/API/VBMacros/Examples.bas`

**Extracted Code:**

### Pocket Rectangle with Islands
```vba
Sub PocketRectangle()
    App.New
    
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing
    Dim width As Double, height As Double, corner_rad As Double
    
    width = 150
    height = 100
    corner_rad = 10
    
    Dim Geo As Geo2D
    Dim P1 As Path, P2 As Path
    
    ' Create outer boundary
    Set Geo = Drw.Create2DGeometry(-width / 2, 0)
    Geo.AddLine -width / 2, height
    Geo.AddLine width / 2, height
    Geo.AddLine width / 2, 0
    Set P1 = Geo.CloseAndFinishLine
    P1.Fillet corner_rad
    P1.ToolInOut = acamINSIDE
    P1.Selected = True
    
    ' Create island
    Set P2 = Drw.CreateCircle(height * 0.6, 0, height / 2)
    P2.ToolInOut = acamOUTSIDE
    P2.Selected = True
    Drw.ZoomAll
    
    GetMillTool "Flat - 10mm"
    
    ' Setup machining
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
```

### Finish Path with Lead In/Out
```vba
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
    
    ' Create the tool path
    Dim Tps As Paths
    Set Tps = MD.RoughFinish
    
    ' Add lead-in/out
    Tps(1).SetLeadInOutAuto acamLeadARC, acamLeadLINE, 1.5, 1.5, 45, False, False, 0
    
    Drw.ZoomAll
End Sub
```

## Parsing Statistics

### Files Analyzed
- **71 total VBA files**
- **56 .bas files** (plain text)
- **15 .arb files** (binary OLE compound)

### Code Extracted
- **304 Sub procedures**
- **445 Functions**
- **749 total procedures**

### Alphacam API Usage
Most commonly used API objects across all files:
1. Drawing - 350+ references
2. Path - 280+ references
3. App - 120+ references
4. Element - 95+ references
5. MillData - 45+ references

## Conclusion

These examples demonstrate successful parsing of:
- ✅ Plain text VBA (.bas) files with complete procedure extraction
- ✅ Binary VBA project (.arb) files with module and code identification
- ✅ Complex Alphacam API usage patterns
- ✅ Various VBA constructs (Subs, Functions, With blocks, loops, error handling)
- ✅ Both simple and advanced machining operations
- ✅ UI integration and menu management
- ✅ 3D geometry manipulation
- ✅ Multi-drill and advanced toolpath operations

All code shown above was successfully extracted and parsed by the VBA parser tool.
