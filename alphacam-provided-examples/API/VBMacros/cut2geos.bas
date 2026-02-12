Attribute VB_Name = "Module1"
Option Explicit

Public Sub test2014R1()
    Dim Drw As Drawing
    Set Drw = App.ActiveDrawing

    Dim MD As MillData
    Set MD = App.CreateMillData

    'Put MillData

    MD.SafeRapidLevel = 50
    MD.XYCorners = acamCornersROUND
    MD.LoopRadius = 0
    MD.FeedDownDistance = 1.5
       
    MD.StepLength = 1.5
    MD.ChordError = 0.1
    MD.PolylineToolSide = acamRIGHT
    
    Dim C2G As Cut2GeosData
    Set C2G = MD.Cut2GeosData
    
    C2G.FinalXYStock = 0.1
    C2G.FinalZStock = 0.05
    C2G.InitialXYStock = 2
    C2G.InitialZStock = 0.2
    C2G.RapidDownDistance = 2.5
    
    MD.NumberOfCuts = 3
    
    Dim LD As LeadData3D
    Set LD = App.CreateLeadData3D
    LD.LeadIn = acamLeadARC
    LD.LeadOut = acamLeadLINE
    LD.AngleIn = 90
    LD.AngleOut = 45
    LD.RadiusIn = 10
    LD.LengthOut = 2
    LD.SideIn = acamLeadRIGHT
    LD.SideOut = acamLeadRIGHT

    MD.SetLeadData3D LD
    
    Dim prog As Path
    Set prog = Drw.UserSelectOneGeo("Select Programming Geometry")  'Tool tip side

    Dim aux As Path
    Set aux = Drw.UserSelectOneGeo("Select Auxiliary Geometry")

    Dim tps As Paths
    Set tps = C2G.CutBetween2Geometries(prog, aux)
    'MsgBox tps.Count
End Sub

