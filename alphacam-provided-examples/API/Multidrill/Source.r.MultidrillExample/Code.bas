Attribute VB_Name = "Code"
Option Explicit

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

Private Sub FindAndSelectHole(HoleName As String)
  
  Dim Geo As Path

  For Each Geo In ActiveDrawing.Geometries
    If Geo.Name = HoleName Then
      Geo.Selected = True
      Exit For
    End If
  Next

End Sub

Public Sub MultiDrillHoles()

    Dim MDU             As MultiDrillUnit
    Dim St              As MDUToolStation
    Dim Md              As MillData
    Dim StationID       As String
    
    App.New
    
    Frame.ProjectBarUpdating = False
    
    App.OpenDrawing Frame.PathOfThisAddin & "\MultidrillAPITest.ard"
    
    Set MDU = App.ActiveDrawing.OpenMultiDrillUnit(Frame.PathOfThisAddin & "\Multidrill Test With 12mm Drills.amultidrill")
    
    ActiveDrawing.SetRapidManager True, 200
    
    ' Drill 2 side holes first - Use tool station 201 as Master and 203 as a slave
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
    
    ' Drill using all vertical tools (101-114)
    For Each St In MDU.Stations
      StationID = St.ToolLocationPoints(1).Id
      If Left(StationID, 1) = "1" Then
          St.Active = True
          If StationID = "101" Then
            St.ToolLocationPoints(1).Master = True
          End If
      Else
          St.Active = False
      End If
    Next St
    
    FindAndSelectHole "Master1"
    
    DrillHole
    
    ' Drill using selected vertical tools (101,102,104,106,108,110,112,114)
    ' Master drill is 108
    For Each St In MDU.Stations
      StationID = St.ToolLocationPoints(1).Id
      
      Select Case StationID
        Case "101", "102", "104", "106", "110", "112", "114"
          St.Active = True
        Case "108"
          St.Active = True
          St.ToolLocationPoints(1).Master = True
        Case Else
          St.Active = False
      End Select
    Next St
    
    FindAndSelectHole "Master2"
    
    DrillHole
    
    ' Drill using selected vertical tools (103,105,107,109,111,113)
    ' Master drill is 103
    For Each St In MDU.Stations
      StationID = St.ToolLocationPoints(1).Id
      
      Select Case StationID
        Case "105", "107", "109", "111", "113"
          St.Active = True
        Case "103"
          St.Active = True
          St.ToolLocationPoints(1).Master = True
        Case Else
          St.Active = False
      End Select
    Next St
    
    FindAndSelectHole "Master3"
    
    DrillHole

    Frame.ProjectBarUpdating = True
    ActiveDrawing.RedrawShadedViews

End Sub


