Attribute VB_Name = "SolidFinishME"
Option Explicit

Public Sub FinishSolid(Strategy As AcamMachiningEngineStrategy)
    ' Part
    App.OpenExternalFile App.LicomdirPath & "licomdir\cadfiles\SIMPLE MILL PART.SLDPRT", "", True
     
    ' Tool
    App.SelectTool App.LicomdatPath & "licomdat\mtools.alp\Ball End - 10mm.amt"
    Dim MD As MillData
    Set MD = App.CreateMillData
    
    ' Solids to machine
    SelectSolidsNotMat

    MD.SurfaceMCAction = acamSurfaceMCActionMCSURFACES
    
    MD.ChordError = 0.05
    
    MD.SafeRapidLevel = 40
    MD.RapidDownTo = 1.25
    MD.WidthOfCut = App.GetCurrentTool.Diameter / 2
    'MD.CuspHeight = 0.1
    MD.StockXY = 0.5
    MD.StockZ = 0.25

'    MD.SurfaceMCLeadAndLinks = True
'    MD.SurfaceMCLeadExtensionLength = 5
'    MD.SurfaceMCLeadArcRadius = 10
'    MD.SurfaceMCLeadRampLength = 8
'    MD.SurfaceMCLeadRampAngle = 45
    
    ' Use Machining Engine
    Dim MDME As MillDataMachiningEngine
    Set MDME = MD.MillDataMachiningEngine
    
    MDME.FinishingStrategy = Strategy
    
    MDME.MillType = AcamMillTypeOptimised
    MDME.ConnectAircutLength = App.GetCurrentTool.Diameter
    
    'MD.SurfaceMCLowerZ = 2
    'MD.SurfaceMCUpperZ = 30
    'MDME.ClipToDepth = True

    Select Case Strategy
    Case AcamMachiningEngineStrategy.acamMESParallelLace
        ' General
        MD.CutDirection = 90
        MDME.StepDirection = acamStepLEFT
        ' Advanced
        'MDME.ContactAngleMin = 10
        'MDME.ContactAngleMax = 80
        
        'MDME.ExcludeFlatAreas = True
        'MDME.IgnoreExternalEdges = True
        
        'MDME.PerpendicularLace = acamPerpLaceBounded
        'MDME.PerpendicularLaceContactAngle = 30
        
        'MDME.UpDownMill = acamUpDownUp
        'MDME.FilterAngle = 45
        
        'MDME.FinishCorners = acamFinishCornersLoop
        'MDME.LoopRadius = 4
    Case AcamMachiningEngineStrategy.acamMESHorizontalZ
        ' General
        MDME.Helical = True
        'MDME.PrismaticGeometry = True
        MD.BottomToTop = True
        'MD.SurfaceMCUseFlatAreas = True
        'MD.SurfaceMCZOrder = acamSurfaceMCZOrderDEPTH
        ' Advanced
        'MDME.ContactAngleMin = 10
        'MDME.ContactAngleMax = 80
        'MDME.FinishShallowAreas = acamFSALace
        'MDME.FinishShallowAreasMillType = AcamMillTypeOptimised
        'MDME.FinishShallowAreasXYStep = App.GetCurrentTool.Diameter / 4
        'MDME.FinishCorners = acamFinishCornersHighSpeed
        ' Rest Finish
        'MDME.SetPreviousTool App.OpenTool(App.LicomdatPath & "licomdat\mtools.alp\Ball End - 20mm.amt")
    Case AcamMachiningEngineStrategy.acamMESConstantCusp
        'MDME.UseGuideCurves = True
        'MD.SetSurfaceDriveCurve App.ActiveDrawing.CreateCircle(50, 0, 0)
        ' General
        'MDME.NumberOfPasses = 1
        'MD.StartCutting = acamStartOUTSIDE
        ' Advanced
        'MDME.ContactAngleMax = 80
    Case AcamMachiningEngineStrategy.acamMESFlatland
        ' General
        'MDME.FlatlandStrategy = acamFLSFinish
        'MDME.FlatlandStrategy = acamFLSLace
        'MD.CutDirection = 45
        'MDME.CloseOpenPockets = True
        ' Rest Finish
        'MDME.SetPreviousTool App.OpenTool(App.LicomdatPath & "licomdat\mtools.alp\Ball End - 20mm.amt")
    Case AcamMachiningEngineStrategy.acamMESRestFinish
        MDME.SetPreviousTool App.OpenTool(App.LicomdatPath & "licomdat\mtools.alp\Ball End - 20mm.amt")
    Case AcamMachiningEngineStrategy.acamMESRestFinishSteepShallow
        MDME.ContactAngle = 30
    Case AcamMachiningEngineStrategy.acamMESPencil
        MDME.NumberOfPasses = 1
        MDME.PencilDownMill = True
        MDME.DownMillAngle = 60
    End Select
      
    'MDME.SetPreviousTool Nothing
    'MDME.FindPreviousTool
    
    MDME.MachineSolidBackground
End Sub

Public Sub FinishXY()
    FinishSolid acamMESParallelLace
End Sub

Public Sub FinishHorizontalZ()
    FinishSolid acamMESHorizontalZ
End Sub

Public Sub FinishConstantCusp()
    FinishSolid acamMESConstantCusp
End Sub

Public Sub FinishFlatland()
    FinishSolid acamMESFlatland
End Sub

Public Sub FinishRestFinish()
    FinishSolid acamMESRestFinish
End Sub

Public Sub FinishRestFinishSteepShallow()
    FinishSolid acamMESRestFinishSteepShallow
End Sub

Public Sub FinishRestFinishPencil()
    FinishSolid acamMESPencil
End Sub

' Select solids that aren't materials
Public Sub SelectSolidsNotMat()
    Dim S As SolidPart
    For Each S In App.ActiveDrawing.SolidParts
        S.Selected = (S.Attribute("LicomUKDMBStockType") = 0)
    Next S
End Sub
