Attribute VB_Name = "Main"
Option Explicit

Function CreateCathedralDoor( _
    Height As Double, Width As Double, Depth As Double, _
    Border As Double, Shoulder As Double, Arch As Double)

    ' define active drawing
    Dim drw As Drawing
    Set drw = App.ActiveDrawing
    
    ' create work volume
    Dim WorkVol As Path
    Set WorkVol = drw.CreateRectangle(0, 0, Height, Width)
    WorkVol.SetWorkVolume 0, -Depth
    
    ' create material
    Dim Material As Path
    Set Material = drw.CreateRectangle(-1, -1, Height + 1, Width + 1)
    Material.SetMaterial 0, -Depth
    
    ' create outside of door
    Dim DoorGeo As Path
    Set DoorGeo = drw.CreateRectangle(0, 0, Height, Width)
    DoorGeo.ToolInOut = acamOUTSIDE
    
    ' machine outside of door
    DoorGeo.Selected = True
    Dim cut_door As Paths
    Dim cut_door_data As MillData
    Dim Tool As MillTool
    On Error Resume Next        ' ignore any errors
        Set Tool = App.SelectTool(App.LicomdatPath & _
            "licomdat\rtools.alp\Flat - 10mm.art")
    On Error GoTo 0             ' cancel error ignore
    ' if tool not found show normal tool select dialog box
    If Tool Is Nothing Then
        Set Tool = App.SelectTool("$User")
    End If
    ' create machining data for outside of door
    Set cut_door_data = App.CreateMillData
    With cut_door_data
        .FinalDepth = -Depth - 5
        .MaterialTop = 0
        .NumberOfCuts = 1
        .OffsetNumber = 1
        .RapidDownTo = 5
        .SafeRapidLevel = 50
        .Stock = 0
        .XYCorners = acamCornersSTRAIGHT
        Set cut_door = .RoughFinish
    End With
    ' apply lead in and lead out
    cut_door.Item(1).SetLeadInOutAuto acamLeadARC, acamLeadARC, 1.2, _
        1.2, 90, False, False, 0
        
    ' create panel
    Dim tempgeo As Geo2D
    Dim PanelGeo As Path
    Dim PanelxStart As Double, PanelyStart As Double
    Dim PanelxFin As Double, PanelyFin As Double
    PanelxStart = Border: PanelyStart = Border
    PanelxFin = Height - Border - Arch: PanelyFin = Width - Border
    Set tempgeo = drw.Create2DGeometry(PanelxStart, PanelyStart)
    With tempgeo
        .AddLine PanelxFin, PanelyStart
        .AddLine PanelxFin, PanelyStart + Shoulder
        .AddArc2Point PanelxFin + Arch, Width / 2, PanelxFin, PanelyFin - Shoulder
        .AddLine PanelxFin, PanelyFin
        .AddLine PanelxStart, PanelyFin
        Set PanelGeo = .CloseAndFinishLine
    End With
    PanelGeo.ToolInOut = acamINSIDE
    PanelGeo.SetStartPoint PanelxStart + ((PanelxFin - PanelxStart) / 2), PanelyStart
        
    ' machine panel
    PanelGeo.Selected = True
    Dim cut_panel As Paths
    Dim cut_panel_data As MillData
    Set Tool = Nothing
    On Error Resume Next        ' ignore any errors
    Set Tool = App.SelectTool(App.LicomdatPath & _
        "licomdat\rtools.alp\Flat - 20mm.art")
    On Error GoTo 0             ' cancel error ignore
    ' if tool not found show normal tool select dialog box
    If Tool Is Nothing Then
        Set Tool = App.SelectTool("$User")   ' ask user to select tool
    End If
    ' create machining data for panel
    Set cut_panel_data = App.CreateMillData
    With cut_panel_data
        .FinalDepth = -5
        .MaterialTop = 0
        .NumberOfCuts = 1
        .OffsetNumber = 1
        .RapidDownTo = 5
        .SafeRapidLevel = 50
        .Stock = 0
        .XYCorners = acamCornersSTRAIGHT
        Set cut_panel = .RoughFinish
    End With
        
End Function

Function FileNew()
    ' function to test if active drawing has any geometries
    ' and show a warning that any unsaved data will be lost
    Dim MsgText As String
    MsgText = App.Frame.ReadTextFile("CathedralDoor.txt", 15, 1)
    Dim MsgBoxReturn As Integer
    If App.ActiveDrawing.GetGeoCount > 0 Then
        MsgBoxReturn = MsgBox(MsgText, vbOKCancel)
        If MsgBoxReturn = vbOK Then
            App.New
        Else
            End
        End If
    End If
End Function

Function Refresh()

    With App.ActiveDrawing
        .ThreeDViews = True
        .Options.ShowRapids = False
        .Options.ShowTools = False
        .Redraw
    End With

End Function
