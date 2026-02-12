Attribute VB_Name = "NcOutputManager"
Option Explicit
'

Public Sub RunOutputNc()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.NcOutputManager
    Dim oFile As AcamAddIns.FileInformation
    
On Error GoTo ErrTrap
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetNcOutputManagerAddIn
    
    Set oFile = oAddIn.RunOutputNc
            
Controlled_Exit:

    Set oFile = Nothing
    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub

Public Sub RunMultipleOutputNc()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.NcOutputManager
    Dim oFiles As AcamAddIns.FileInformationCollection
    
On Error GoTo ErrTrap
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetNcOutputManagerAddIn
    
    Set oFiles = oAddIn.RunMultipleOutputNc
            
Controlled_Exit:
    
    Set oFiles = Nothing
    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub

Public Sub EditOutputConfigurationsCollection()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.NcOutputManager
    
On Error GoTo ErrTrap
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetNcOutputManagerAddIn
    
    Call oAddIn.EditOutputConfigurationsCollection
            
Controlled_Exit:

    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub

Public Sub GetOutputConfigurationsCollectionAndOutputNC()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.NcOutputManager
    Dim oConfigurations As AcamAddIns.NcOutputManagerOutputConfigurations
    Dim oConfiguration As AcamAddIns.NcOutputManagerOutputConfiguration
    Dim oFiles As FileInformationCollection
    
On Error GoTo ErrTrap
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetNcOutputManagerAddIn
    
    Set oConfigurations = oAddIn.GetOutputConfigurationsCollection
    
    ' apply some settings
    With oAddIn.MultipleOutputSettings
        .AppendConfigurationNameToNcFileTitle = True
        .OverwriteExistingNcFiles = False
        .SaveToConfigurationsSubdirectories = True
    End With
    '
    oConfigurations.NcFileTitle = App.ActiveDrawing.Name
    
    ' spit out some simple information
    For Each oConfiguration In oConfigurations
        Debug.Print oConfiguration.Name, oConfiguration.PostFileName, oConfiguration.NcFolderName
    Next oConfiguration
    
    ' output multiple nc files for the active drawing (temp drawings also supported)
    '
    ' note that NcOutputManagerOutputConfigurations.OutputNC returns
    ' the number of NC files that were created
    '
    Set oFiles = oConfigurations.OutputNC(App.ActiveDrawing)
            
    Debug.Print oFiles.Count & " NC files were created."
            
Controlled_Exit:

    Set oConfiguration = Nothing
    Set oConfigurations = Nothing
    Set oFiles = Nothing
    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub

Public Sub CreateOutputConfigurationsCollectionAndOutputNC()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.NcOutputManager
    Dim oConfigurations As AcamAddIns.NcOutputManagerOutputConfigurations
    Dim oConfiguration As AcamAddIns.NcOutputManagerOutputConfiguration
    Dim oSettings As AcamAddIns.NcOutputManagerMultipleOutputSettings
    Dim oFiles As AcamAddIns.FileInformationCollection
    Dim oFile As AcamAddIns.FileInformation
    
On Error GoTo ErrTrap
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetNcOutputManagerAddIn
    
    ' create and apply some multiple output settings
    Set oSettings = New AcamAddIns.NcOutputManagerMultipleOutputSettings
    
    With oSettings
        .AppendConfigurationNameToNcFileTitle = False
        .OverwriteExistingNcFiles = True
        .SaveToConfigurationsSubdirectories = True
    End With
                
    ' create a new configurations collection and apply some settings
    Set oConfigurations = oAddIn.CreateOutputConfigurationsCollection
    Set oConfigurations.MultipleOutputSettings = oSettings
    oConfigurations.NcFileTitle = App.ActiveDrawing.Name
    
    ' create a machine 1 and apply some settings
    Set oConfiguration = New AcamAddIns.NcOutputManagerOutputConfiguration
    
    With oConfiguration
        .Enabled = True
        .Name = "Machine 1"
        .NcFileType = "nc"
        .NcFolderName = App.LicomdirPath & "LICOMDIR"
        .OutputVisibleOperationsOnly = False
        .PostFileName = App.LicomdatPath & "LICOMDAT\RPosts.alp\Alpha Standard 3 Ax Router.arp"
        
        ' override the file title and a setting for this configuration
        Set .MultipleOutputSettings = oSettings.Copy
        .MultipleOutputSettings.AppendConfigurationNameToNcFileTitle = True
        .NcFileTitle = "MySpecificFileName"
    End With
    
    ' add machine 1 to the collection
    Call oConfigurations.Add(oConfiguration)
    
    ' create a machine 2 and apply some settings
    Set oConfiguration = New AcamAddIns.NcOutputManagerOutputConfiguration
    
    With oConfiguration
        .Enabled = True
        .Name = "Machine 2"
        .NcFileType = "txt"
        .NcFolderName = App.LicomdirPath & "LICOMDIR"
        .OutputVisibleOperationsOnly = False
        .PostFileName = App.LicomdatPath & "LICOMDAT\RPosts.alp\Alpha Standard 5 Ax Router.arp"
    End With
    
    ' add machine 2 to the collection
    Call oConfigurations.Add(oConfiguration)
    
    ' output multiple nc files for the active drawing
    '
    ' note that NcOutputManagerOutputConfigurations.OutputNC returns
    ' the number of NC files that were created
    '
    Set oFiles = oConfigurations.OutputNC(App.ActiveDrawing)
    
    Debug.Print oFiles.Count & " NC files were created."
            
    ' spit out the names of the saved NC files
    For Each oFile In oFiles
        Debug.Print oFile.FullName
    Next oFile
            
Controlled_Exit:

    Set oConfiguration = Nothing
    Set oConfigurations = Nothing
    Set oSettings = Nothing
    Set oFiles = Nothing
    Set oFile = Nothing
    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub
