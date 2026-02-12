Attribute VB_Name = "General"
Option Explicit
'

Public Sub GetPanelSheets()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AE As AcamAddIns.AcamEx
    Dim oPanels As AcamAddIns.PanelSheets
    Dim oPanel As AcamAddIns.PanelSheet
    Dim Drw As Drawing
    Dim PS As Paths
        
On Error GoTo ErrTrap
    
    ' get Paneling results information
    
    Set Drw = App.ActiveDrawing
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AE = AI.GetAcamExInterface(App)
    
    Set oPanels = AE.GetPanelSheets(Drw)
    
    If Not (oPanels Is Nothing) Then
        
        For Each oPanel In oPanels
            
            Set PS = oPanel.Paths
            
            ' do something here
            Debug.Print oPanel.Path.Name & " contains " & PS.Count & " paths."
        
        Next oPanel
        
        App.Frame.ProjectBarUpdating = False
        
        Call oPanels.MoveToOwnLayers(True)
                
    End If
        
Controlled_Exit:

    App.Frame.ProjectBarUpdating = True

    Set oPanels = Nothing
    Set oPanel = Nothing
    Set AE = Nothing
    Set AI = Nothing
    Set Drw = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub

Public Sub GetPanelSheetsFromPaths()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AE As AcamAddIns.AcamEx
    Dim oPanels As AcamAddIns.PanelSheets
    Dim oPanel As AcamAddIns.PanelSheet
    Dim Drw As Drawing
    Dim pthsCheckGeos As Paths
    Dim PS As Paths
        
On Error GoTo ErrTrap
    
    ' get Paneling results information
    
    Set Drw = App.ActiveDrawing
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AE = AI.GetAcamExInterface(App)
    
    Set pthsCheckGeos = Drw.UserSelectMultiGeosCollection("Select Geos to Check", 0)
    
    If (pthsCheckGeos Is Nothing) Then GoTo Controlled_Exit
    
    Set oPanels = AE.GetPanelSheetsFromPaths(pthsCheckGeos)
    
    If Not (oPanels Is Nothing) Then
        
        For Each oPanel In oPanels
            
            Set PS = oPanel.Paths
            
            ' do something here
            Debug.Print oPanel.Path.Name & " contains " & PS.Count & " paths."
        
        Next oPanel
        
        App.Frame.ProjectBarUpdating = False
        
        Call oPanels.MoveToOwnLayers(True)
                
    End If
        
Controlled_Exit:

    App.Frame.ProjectBarUpdating = True

    Set oPanels = Nothing
    Set oPanel = Nothing
    Set PS = Nothing
    Set AE = Nothing
    Set AI = Nothing
    Set Drw = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub

Public Sub SavePanelSheets()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AE As AcamAddIns.AcamEx
    Dim oPanels As AcamAddIns.PanelSheets
    Dim oFiles As AcamAddIns.FileInformationCollection
    Dim oFile As AcamAddIns.FileInformation
    Dim Drw As Drawing
    Dim strFolder As String
            
On Error GoTo ErrTrap
    
    ' save Paneling results to separate drawings
    
    Set Drw = App.ActiveDrawing
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AE = AI.GetAcamExInterface(App)
    
    Set oPanels = AE.GetPanelSheets(Drw)
    
    If Not (oPanels Is Nothing) Then
                        
        strFolder = App.LicomdirPath & "LICOMDIR\Panel Results"
        If (Len(Dir$(strFolder, vbDirectory)) = 0) Then
            Call MkDir(strFolder)
        End If
        
        ' check again
        If (Len(Dir$(strFolder, vbDirectory)) = 0) Then
            MsgBox "Destination folder does not exist.", vbExclamation
            GoTo Controlled_Exit
        End If
        
        ' save them
        Set oFiles = oPanels.SaveToDrawings(strFolder)
        
        If Not (oFiles Is Nothing) Then
            
            Debug.Print "Saved " & oFiles.Count & " files."
            
            For Each oFile In oFiles
                Debug.Print oFile.FullName
            Next oFile
        
        End If
                        
    End If
        
Controlled_Exit:

    Set oPanels = Nothing
    Set oFiles = Nothing
    Set oFile = Nothing
    Set AE = Nothing
    Set AI = Nothing
    Set Drw = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub

Public Sub GetAlphacamFileInformationCollection()
    
    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AE As AcamAddIns.AcamEx
    Dim objFile As AcamAddIns.FileInformation
    Dim objFiles As AcamAddIns.FileInformationCollection
    Dim strFile As String
        
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AE = AI.GetAcamExInterface(App)
                    
    ' NOTE: passing "$USER" to the "Folder" parameter will prompt the user to select the folder.
    '       a path to a specific folder (e.g., "C:\Alphacam\LICOMDIR") can also be passed.
                
    Set objFiles = AE.GetAlphacamFileInformationCollection("$USER", AlphaFileType_Drawing, True)
    
    If Not (objFiles Is Nothing) Then
        
        For Each objFile In objFiles
            Debug.Print objFile.FullName
        Next objFile
        
        Debug.Print objFiles.Count & " files."
        
    End If
    
Controlled_Exit:
    
    Set objFiles = Nothing
    Set objFile = Nothing
    Set AE = Nothing
    Set AI = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub



