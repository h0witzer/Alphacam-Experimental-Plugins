Attribute VB_Name = "Reports"
Option Explicit
'

Public Sub CreateReports()

    Dim Drw As Drawing
    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.Reports
    Dim rptJob As AcamAddIns.ReportsJob
    Dim strLayoutFile1 As String
    Dim strLayoutFile2 As String
    Dim strDataOutputSettingsFile As String
    Dim strFile As String

On Error GoTo ErrTrap

    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set oAddIn = AA.GetReportsAddIn
    
    ' we're going to create a report from two different drawings.
    ' one will be the active drawing, one will be a temp drawing.
    
    ' >> LAYOUTS
    
    ' first, lets try to get the report layout files
    
    strLayoutFile1 = App.LicomdirPath & "LICOMDIR\Reports\Layouts\part image.acrepx"
    strLayoutFile2 = App.LicomdirPath & "LICOMDIR\Reports\Layouts\sheet image.acrepx"
        
    ' if the recommended layout files don't exist, ask for them
        
    If (Len(Trim$(Dir$(strLayoutFile1))) = 0) Then
        If Not GetReportLayoutFileName(strLayoutFile1) Then
            MsgBox "Report Layout File is required.", vbInformation
            GoTo Controlled_Exit
        End If
    End If
    
    If (Len(Trim$(Dir$(strLayoutFile2))) = 0) Then
        If Not GetReportLayoutFileName(strLayoutFile2) Then
            MsgBox "Report Layout File is required.", vbInformation
            GoTo Controlled_Exit
        End If
    End If
    
    ' >> PRE-LOAD THE DESIGNER/VIEWER
    Call oAddIn.ShowDesigner
    
    ' >> OUTPUT SETTINGS
        
    ' setup some settings
    With oAddIn.Settings
                
        .ReportDataFileLocation = App.LicomdirPath & "LICOMDIR\Reports\Data"
        
        .CreateDataFileOnly = False
        .CustomerName = "Alphacam Customer"
        .DueDate = Now + 2  ' 2 days from now
        .OrderDate = Now
        .IsHighPriority = False
        .JobDescription = "VBA Example Containing 2 Drawings"
        .JobName = "VBA Example 1"
        .PO = "8675309"
        .ProgrammerName = "Alphacam User"
        
        .ReportLayout1.FileName = strLayoutFile1
        .ReportLayout1.Enabled = True
                
        .ReportLayout2.FileName = strLayoutFile2
        .ReportLayout2.Enabled = False  ' DISABLED
        
        ' additional report layouts can also be assigned
        '.ReportLayout3.FileName =
        '.ReportLayout3.Enabled =
        '.ReportLayout4.FileName =
        '.ReportLayout4.Enabled =
        
        ' now setup the data output settings
        With .DataOutputSettings
            
            .CreateNestedSheetOperationData = True
            .CreatePartOperationData = True
            .CycleTimeEfficiencyRate = 90
            .CycleTimeNestedSheetLoadTime = 60
            .CycleTimePartLoadTime = 30
            
            .NestedSheetImageType = ReportsImageType_WireframeBlack
            .PartImageType = ReportsImageType_WireframeColor
            .SuppressItemNumbersFromNestedSheetImages = False
            .SuppressToolPathsFromNestedSheetImages = False
            .SuppressToolPathsFromPartImages = False
            
            .ToolImageType = ReportsImageType_ShadedColor
            .ShadedToolImageBackgroundColor = vbWhite
            .ShadedToolImageHeight = 400
            .ShadedToolImageWidth = 400
            .IncludeHolderInToolImages = True
            
        End With
                
    End With
    
    ' NOTE: optionally, rather than setting the data output settings above,
    ' the data output settings can also be set from a presaved file.
    'If Not GetDataOutputSettingsFileName(strDataOutputSettingsFile) Then
    '    MsgBox "Data Output Settings File is required.", vbInformation
    '    GoTo Controlled_Exit
    'End If
    '
    'Call oAddIn.Settings.SetDataOutputSettingsFromFile(strDataOutputSettingsFile)
        
    ' >> CREATE REPORTS
        
    'rptJob.SuppressProgressBox = True  ' optional

    ' add the active drawing
    Set Drw = App.ActiveDrawing
    
    ' don't bother if there's nothing in the drawing
    If ((Drw.GetGeoCount + Drw.GetToolPathCount) > 0) Then
    
        Set rptJob = oAddIn.CreateReportsJob(Drw)
    
        If Not (rptJob Is Nothing) Then
            If rptJob.Save Then
                Call rptJob.CreateReports
            End If
        End If

    End If
        
    ' now add a temp drawing (if exists)
    strFile = App.LicomdirPath & "LICOMDIR\NestedReportsExample.ard"

    If (Len(Trim$(Dir$(strFile))) > 0) Then

        Set Drw = App.OpenTempDrawing(strFile)

        If Not (Drw Is Nothing) Then
                                            
            Set rptJob = oAddIn.CreateReportsJob(Drw)
            
            ' IMPORTANT
            '
            ' update some settings specific to this job
            '
            ' change the job name to prevent overwritting the
            ' previously created data file and enable the layout 2
            rptJob.Settings.JobName = "VBA Example 2"
            rptJob.Settings.ReportLayout1.Enabled = False
            rptJob.Settings.ReportLayout2.Enabled = True
            rptJob.Settings.DataOutputSettings.PartImageType = ReportsImageType_WireframeBlack
            
            If Not (rptJob Is Nothing) Then
                If rptJob.Save Then
                    Call rptJob.CreateReports
                End If
            End If
            
        End If

    End If
    
Controlled_Exit:

    Set AA = Nothing
    Set AI = Nothing
    Set oAddIn = Nothing
    Set rptJob = Nothing
    Set Drw = Nothing

Exit Sub

ErrTrap:

    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit

End Sub

Public Sub ExportReportsToEmf()

    Dim Drw As Drawing
    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.Reports
    Dim rptJob As AcamAddIns.ReportsJob
    Dim objFile As AcamAddIns.FileInformation
    Dim objFiles As AcamAddIns.FileInformationCollection
    Dim strLayoutFile As String
    Dim strDataOutputSettingsFile As String
    Dim strFile As String

On Error GoTo ErrTrap

    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set oAddIn = AA.GetReportsAddIn
    
    ' add the active drawing
    Set Drw = App.ActiveDrawing
    
    If ((Drw.GetGeoCount + Drw.GetToolPathCount) = 0) Then
        MsgBox "Drawing contains no reportable information.", vbInformation
        GoTo Controlled_Exit
    End If
    
    ' >> LAYOUT
    
    ' first, lets try to get the report layout files
                            
    If Not GetReportLayoutFileName(strLayoutFile) Then
        MsgBox "Report Layout File is required.", vbInformation
        GoTo Controlled_Exit
    End If
                
    ' >> OUTPUT SETTINGS
        
    ' setup some settings
    With oAddIn.Settings
                        
        ' use drawing name as job name, if possible
        .JobName = IIf((Drw.Name <> vbNullString), Drw.Name, "VBA Example 1")
        .JobDescription = "VBA Export Example"
                
        .ReportDataFileLocation = App.LicomdirPath & "LICOMDIR\Reports\Data"
        
        .CreateDataFileOnly = False
        .CustomerName = "Alphacam Customer"
        .DueDate = Now + 2  ' 2 days from now
        .OrderDate = Now
        .IsHighPriority = False
        .PO = "8675309"
        .ProgrammerName = "Alphacam User"
        
        .ReportLayout1.FileName = strLayoutFile
        .ReportLayout1.Enabled = True
        
        ' additional report layouts can also be assigned
        '.ReportLayout2.FileName =
        '.ReportLayout2.Enabled =
        '.ReportLayout3.FileName =
        '.ReportLayout3.Enabled =
        '.ReportLayout4.FileName =
        '.ReportLayout4.Enabled =
        
        ' now setup the data output settings
        With .DataOutputSettings
            
            .CreateNestedSheetOperationData = False
            .CreatePartOperationData = True
            .CycleTimeEfficiencyRate = 90
            .CycleTimeNestedSheetLoadTime = 60
            .CycleTimePartLoadTime = 30
            
            .NestedSheetImageType = ReportsImageType_None
            .PartImageType = ReportsImageType_WireframeBlack
            .SuppressItemNumbersFromNestedSheetImages = False
            .SuppressToolPathsFromNestedSheetImages = False
            .SuppressToolPathsFromPartImages = False
            
            .ToolImageType = ReportsImageType_None
            .ShadedToolImageBackgroundColor = vbWhite
            .ShadedToolImageHeight = 400
            .ShadedToolImageWidth = 400
            .IncludeHolderInToolImages = True
            
        End With
        
        ' now setup the export settings
        With .ExportSettings
            .FileLocation = App.LicomdirPath & "LICOMDIR\Reports\Export"
            .ExportType = ReportsExportType_Emf
            .ExportImageMode = ReportsExportImageMode_DifferentFiles
        End With
        
    End With
    
    ' NOTE: optionally, rather than setting the data output settings above,
    ' the data output settings can also be set from a presaved file.
    'If Not GetDataOutputSettingsFileName(strDataOutputSettingsFile) Then
    '    MsgBox "Data Output Settings File is required.", vbInformation
    '    GoTo Controlled_Exit
    'End If
    '
    'Call oAddIn.Settings.SetDataOutputSettingsFromFile(strDataOutputSettingsFile)
        
    ' >> CREATE AND EXPORT THE REPORTS
        
    'rptJob.SuppressProgressBox = True  ' optional
                
    Set rptJob = oAddIn.CreateReportsJob(Drw)
    
    If Not (rptJob Is Nothing) Then
        
        ' NOTE: uncomment the following lines to add a temp drawing (if exists)
        'strFile = App.LicomdirPath & "LICOMDIR\NestedReportsExample.ard"
        '
        'If (Len(Trim$(Dir$(strFile))) > 0) Then
        '    Set Drw = App.OpenTempDrawing(strFile)
        '    If Not (Drw Is Nothing) Then
        '        Call rptJob.AddToReportData(Drw, "NestedReportsExample")
        '    End If
        'End If
                                
        If rptJob.Save Then
            
            Set objFiles = rptJob.ExportReports
                                    
            ' lets just loop through the exported file names
            For Each objFile In objFiles
                Debug.Print objFile.FullName
            Next objFile
            
            Debug.Print "-- Exported " & objFiles.Count & " files."
            
        End If
                                                                                
    End If
    
Controlled_Exit:

    Set AA = Nothing
    Set AI = Nothing
    Set oAddIn = Nothing
    Set rptJob = Nothing
    Set objFile = Nothing
    Set objFiles = Nothing
    Set Drw = Nothing

Exit Sub

ErrTrap:

    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit

End Sub

Public Sub ExportReportsToPdf()

    Dim Drw As Drawing
    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.Reports
    Dim rptJob As AcamAddIns.ReportsJob
    Dim objFile As AcamAddIns.FileInformation
    Dim objFiles As AcamAddIns.FileInformationCollection
    Dim strLayoutFile As String
    Dim strDataOutputSettingsFile As String
    Dim strFile As String

On Error GoTo ErrTrap

    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set oAddIn = AA.GetReportsAddIn
    
    ' add the active drawing
    Set Drw = App.ActiveDrawing
    
    If ((Drw.GetGeoCount + Drw.GetToolPathCount) = 0) Then
        MsgBox "Drawing contains no reportable information.", vbInformation
        GoTo Controlled_Exit
    End If
    
    ' >> LAYOUT
    
    ' first, lets try to get the report layout files
                            
    If Not GetReportLayoutFileName(strLayoutFile) Then
        MsgBox "Report Layout File is required.", vbInformation
        GoTo Controlled_Exit
    End If
                
    ' >> OUTPUT SETTINGS
        
    ' setup some settings
    With oAddIn.Settings
                        
        ' use drawing name as job name, if possible
        .JobName = IIf((Drw.Name <> vbNullString), Drw.Name, "VBA Example 1")
        .JobDescription = "VBA Export Example"
                
        .ReportDataFileLocation = App.LicomdirPath & "LICOMDIR\Reports\Data"
        
        .CreateDataFileOnly = False
        .CustomerName = "Alphacam Customer"
        .DueDate = Now + 2  ' 2 days from now
        .OrderDate = Now
        .IsHighPriority = False
        .PO = "8675309"
        .ProgrammerName = "Alphacam User"
        
        .ReportLayout1.FileName = strLayoutFile
        .ReportLayout1.Enabled = True
        
        ' additional report layouts can also be assigned
        '.ReportLayout2.FileName =
        '.ReportLayout2.Enabled =
        '.ReportLayout3.FileName =
        '.ReportLayout3.Enabled =
        '.ReportLayout4.FileName =
        '.ReportLayout4.Enabled =
        
        ' now setup the data output settings
        With .DataOutputSettings
            
            .CreateNestedSheetOperationData = False
            .CreatePartOperationData = True
            .CycleTimeEfficiencyRate = 90
            .CycleTimeNestedSheetLoadTime = 60
            .CycleTimePartLoadTime = 30
            
            .NestedSheetImageType = ReportsImageType_None
            .PartImageType = ReportsImageType_WireframeBlack
            .SuppressItemNumbersFromNestedSheetImages = False
            .SuppressToolPathsFromNestedSheetImages = False
            .SuppressToolPathsFromPartImages = False
            
            .ToolImageType = ReportsImageType_None
            .ShadedToolImageBackgroundColor = vbWhite
            .ShadedToolImageHeight = 400
            .ShadedToolImageWidth = 400
            .IncludeHolderInToolImages = True
            
        End With
        
        ' now setup the export settings
        With .ExportSettings
            .ExportType = ReportsExportType_Pdf
            .PdfConvertImagesToJpeg = True
            .PdfImageQuality = ReportsExportPdfImageQuality_Highest
            .FileLocation = App.LicomdirPath & "LICOMDIR\Reports\Export"
        End With
        
    End With
    
    ' NOTE: optionally, rather than setting the data output settings above,
    ' the data output settings can also be set from a presaved file.
    'If Not GetDataOutputSettingsFileName(strDataOutputSettingsFile) Then
    '    MsgBox "Data Output Settings File is required.", vbInformation
    '    GoTo Controlled_Exit
    'End If
    '
    'Call oAddIn.Settings.SetDataOutputSettingsFromFile(strDataOutputSettingsFile)
        
    ' >> CREATE AND EXPORT THE REPORTS
        
    'rptJob.SuppressProgressBox = True  ' optional
                
    Set rptJob = oAddIn.CreateReportsJob(Drw)
    
    If Not (rptJob Is Nothing) Then
        
        ' NOTE: uncomment the following lines to add a temp drawing (if exists)
        'strFile = App.LicomdirPath & "LICOMDIR\NestedReportsExample.ard"
        '
        'If (Len(Trim$(Dir$(strFile))) > 0) Then
        '    Set Drw = App.OpenTempDrawing(strFile)
        '    If Not (Drw Is Nothing) Then
        '        Call rptJob.AddToReportData(Drw, "NestedReportsExample")
        '    End If
        'End If
                                
        If rptJob.Save Then
            
            Set objFiles = rptJob.ExportReports
                                    
            ' lets just loop through the exported file names
            For Each objFile In objFiles
                Debug.Print objFile.FullName
            Next objFile
            
            Debug.Print "-- Exported " & objFiles.Count & " files."
            
        End If
                                                                                
    End If
    
Controlled_Exit:

    Set AA = Nothing
    Set AI = Nothing
    Set oAddIn = Nothing
    Set rptJob = Nothing
    Set objFile = Nothing
    Set objFiles = Nothing
    Set Drw = Nothing

Exit Sub

ErrTrap:

    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit

End Sub

Public Sub ExportReportsToCsv()

    Dim Drw As Drawing
    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.Reports
    Dim rptJob As AcamAddIns.ReportsJob
    Dim objFile As AcamAddIns.FileInformation
    Dim objFiles As AcamAddIns.FileInformationCollection
    Dim strLayoutFile As String
    Dim strDataOutputSettingsFile As String
    Dim strFile As String

On Error GoTo ErrTrap

    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set oAddIn = AA.GetReportsAddIn
    
    ' add the active drawing
    Set Drw = App.ActiveDrawing
    
    If ((Drw.GetGeoCount + Drw.GetToolPathCount) = 0) Then
        MsgBox "Drawing contains no reportable information.", vbInformation
        GoTo Controlled_Exit
    End If
    
    ' >> LAYOUT
    
    ' first, lets try to get the report layout files
                            
    If Not GetReportLayoutFileName(strLayoutFile) Then
        MsgBox "Report Layout File is required.", vbInformation
        GoTo Controlled_Exit
    End If
                
    ' >> OUTPUT SETTINGS
        
    ' setup some settings
    With oAddIn.Settings
                        
        ' use drawing name as job name, if possible
        .JobName = IIf((Drw.Name <> vbNullString), Drw.Name, "VBA Example 1")
        .JobDescription = "VBA Export Example"
                
        .ReportDataFileLocation = App.LicomdirPath & "LICOMDIR\Reports\Data"
        
        .CreateDataFileOnly = False
        .CustomerName = "Alphacam Customer"
        .DueDate = Now + 2  ' 2 days from now
        .OrderDate = Now
        .IsHighPriority = False
        .PO = "8675309"
        .ProgrammerName = "Alphacam User"
        
        .ReportLayout1.FileName = strLayoutFile
        .ReportLayout1.Enabled = True
        
        ' additional report layouts can also be assigned
        '.ReportLayout2.FileName =
        '.ReportLayout2.Enabled =
        '.ReportLayout3.FileName =
        '.ReportLayout3.Enabled =
        '.ReportLayout4.FileName =
        '.ReportLayout4.Enabled =
        
        ' now setup the data output settings
        With .DataOutputSettings
            
            .CreateNestedSheetOperationData = False
            .CreatePartOperationData = True
            .CycleTimeEfficiencyRate = 90
            .CycleTimeNestedSheetLoadTime = 60
            .CycleTimePartLoadTime = 30
            
            .NestedSheetImageType = ReportsImageType_None
            .PartImageType = ReportsImageType_WireframeBlack
            .SuppressItemNumbersFromNestedSheetImages = False
            .SuppressToolPathsFromNestedSheetImages = False
            .SuppressToolPathsFromPartImages = False
            
            .ToolImageType = ReportsImageType_None
            .ShadedToolImageBackgroundColor = vbWhite
            .ShadedToolImageHeight = 400
            .ShadedToolImageWidth = 400
            .IncludeHolderInToolImages = True
            
        End With
        
        ' now setup the export settings
        With .ExportSettings
            .ExportType = ReportsExportType_Csv
            .QuoteTextStringsContainingSeparators = True
            .FileLocation = App.LicomdirPath & "LICOMDIR\Reports\Export"
        End With
        
    End With
    
    ' NOTE: optionally, rather than setting the data output settings above,
    ' the data output settings can also be set from a presaved file.
    'If Not GetDataOutputSettingsFileName(strDataOutputSettingsFile) Then
    '    MsgBox "Data Output Settings File is required.", vbInformation
    '    GoTo Controlled_Exit
    'End If
    '
    'Call oAddIn.Settings.SetDataOutputSettingsFromFile(strDataOutputSettingsFile)
        
    ' >> CREATE AND EXPORT THE REPORTS
        
    'rptJob.SuppressProgressBox = True  ' optional
                
    Set rptJob = oAddIn.CreateReportsJob(Drw)
    
    If Not (rptJob Is Nothing) Then
        
        ' NOTE: uncomment the following lines to add a temp drawing (if exists)
        'strFile = App.LicomdirPath & "LICOMDIR\NestedReportsExample.ard"
        '
        'If (Len(Trim$(Dir$(strFile))) > 0) Then
        '    Set Drw = App.OpenTempDrawing(strFile)
        '    If Not (Drw Is Nothing) Then
        '        Call rptJob.AddToReportData(Drw, "NestedReportsExample")
        '    End If
        'End If
                                
        If rptJob.Save Then
            
            Set objFiles = rptJob.ExportReports
                                    
            ' lets just loop through the exported file names
            For Each objFile In objFiles
                Debug.Print objFile.FullName
            Next objFile
            
            Debug.Print "-- Exported " & objFiles.Count & " files."
            
        End If
                                                                                
    End If
    
Controlled_Exit:

    Set AA = Nothing
    Set AI = Nothing
    Set oAddIn = Nothing
    Set rptJob = Nothing
    Set objFile = Nothing
    Set objFiles = Nothing
    Set Drw = Nothing

Exit Sub

ErrTrap:

    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit

End Sub

Public Function GetReportLayoutFileName(SelectedFileName As String) As Boolean
        
    Dim AA As AcamAddIns.AddIns
    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim oAddIn As AcamAddIns.Reports
    
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set oAddIn = AA.GetReportsAddIn
            
    GetReportLayoutFileName = oAddIn.GetReportLayoutFileName(AlphaFileAction_Open, SelectedFileName, SelectedFileName)
    
    Set oAddIn = Nothing
    Set AI = Nothing
    Set AA = Nothing
        
End Function

Public Function GetDataOutputSettingsFileName(SelectedFileName As String) As Boolean
        
    Dim AA As AcamAddIns.AddIns
    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim oAddIn As AcamAddIns.Reports
    
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set oAddIn = AA.GetReportsAddIn
            
    GetDataOutputSettingsFileName = oAddIn.GetDataOutputSettingsFileName(AlphaFileAction_Open, SelectedFileName, SelectedFileName)
    
    Set oAddIn = Nothing
    Set AI = Nothing
    Set AA = Nothing
        
End Function

Public Sub EditDataOutputSettingsFile()

    Dim AA As AcamAddIns.AddIns
    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim oAddIn As AcamAddIns.Reports
    Dim strFile As String
    Dim blnRet As Boolean
    
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set oAddIn = AA.GetReportsAddIn
        
    If GetDataOutputSettingsFileName(strFile) Then
        blnRet = oAddIn.EditDataOutputSettingsFile(strFile)
    End If
    
    Set oAddIn = Nothing
    Set AI = Nothing
    Set AA = Nothing
        
End Sub

Public Sub CreateDataOutputSettingsFile()

    Dim AA As AcamAddIns.AddIns
    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim oAddIn As AcamAddIns.Reports
    Dim strFile As String
    
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set oAddIn = AA.GetReportsAddIn
            
    If oAddIn.CreateDataOutputSettingsFile(strFile) Then
        Debug.Print "Saved Data Output Settings File Name: " & strFile
    End If
    
    Set oAddIn = Nothing
    Set AI = Nothing
    Set AA = Nothing

End Sub

Public Sub ShowDesigner()

    Dim AA As AcamAddIns.AddIns
    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim oAddIn As AcamAddIns.Reports

    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)

    Set oAddIn = AA.GetReportsAddIn
    Call oAddIn.ShowDesigner

    Set oAddIn = Nothing
    Set AI = Nothing
    Set AA = Nothing

End Sub

