Attribute VB_Name = "ImportUserLayers"
Option Explicit
'

Public Sub ImportUserLayers()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim oAddIn As AcamAddIns.ImportUserLayers
    
On Error GoTo ErrTrap
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    
    ' set the instance of the specific addin object
    Set oAddIn = AA.GetImportUserLayersAddIn
    
    ' calling .Run will prompt the user to select the files to and
    ' then import the layers within those files to the active drawing.
    
    Call oAddIn.Run
    
    ' NOTE: layers can be imported into a drawing other than the active
    ' drawing (e.g., a temp drawing) by passing the appropriate
    ' Drawing object to the Run procedure per the example below.
    '
    'Dim Drw As Drawing
    'Set Drw = App.CreateTempDrawing
    'Call oAddIn.Run(Drw)
    'Call Drw.SaveAs(App.LicomdirPath & "LICOMDIR\ImportLayersTemp.ard")
        
Controlled_Exit:

    Set oAddIn = Nothing
    Set AA = Nothing
    Set AI = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub

Public Sub GetAndImportLayersInformation()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim AE As AcamAddIns.AcamEx
    Dim oLayersInfo As AcamAddIns.LayerInformationCollection
    Dim Drw As Drawing
    Dim strFileName As String
    Dim strFullName As String
    Dim lngCreatedLayers As Long
    Dim lngExistingLayers As Long
    
On Error GoTo ErrTrap
    
    ' get a drawing that contains user layers
    If Not App.GetAlphaCamFileName("Select Drawing Containing Layers", _
        acamFileTypeDRAWING, acamFileActionOPEN, strFullName, strFileName) Then
        
        Exit Sub
        
    End If
    
    Set Drw = App.OpenTempDrawing(strFullName)
    If (Drw Is Nothing) Then Exit Sub
    
    App.Frame.ProjectBarUpdating = False
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set AE = AI.GetAcamExInterface(App)
    
    Set oLayersInfo = AE.GetUserLayersInformationFromDrawing(Drw)
    
    If Not (oLayersInfo Is Nothing) Then
        
        If AE.ImportUserLayersInformation(App.ActiveDrawing, oLayersInfo, lngCreatedLayers, lngExistingLayers) Then
            MsgBox "Created " & lngCreatedLayers & " layers.", vbInformation
        End If
        
    End If
        
Controlled_Exit:

    App.Frame.ProjectBarUpdating = True

    Set oLayersInfo = Nothing
    Set AA = Nothing
    Set AE = Nothing
    Set AI = Nothing
    Set Drw = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub

Public Sub GetAndImportLayersInformation2()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AA As AcamAddIns.AddIns
    Dim AE As AcamAddIns.AcamEx
    Dim oLayersInfo As AcamAddIns.LayerInformationCollection
    Dim lngCreatedLayers As Long
    Dim lngCreatedLayersAll As Long
    Dim lngExistingLayers As Long
    Dim strFile As String
    
On Error GoTo ErrTrap
    
    App.Frame.ProjectBarUpdating = False
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AA = AI.GetAddInsInterface(App)
    Set AE = AI.GetAcamExInterface(App)
    
    ' import layers from a drawing and then a drawing template
    
    strFile = App.LicomdirPath & "LICOMDIR\LayeredDrawing.ard"
    Set oLayersInfo = AE.GetUserLayersInformationFromFile(strFile)
    
    If Not (oLayersInfo Is Nothing) Then
        If AE.ImportUserLayersInformation(App.ActiveDrawing, oLayersInfo, lngCreatedLayers, lngExistingLayers) Then
            lngCreatedLayersAll = lngCreatedLayers
        End If
    End If
    
    strFile = App.LicomdirPath & "LICOMDIR\Templates\LayeredTemplate.adt"
    Set oLayersInfo = AE.GetUserLayersInformationFromFile(strFile)
        
    If Not (oLayersInfo Is Nothing) Then
        If AE.ImportUserLayersInformation(App.ActiveDrawing, oLayersInfo, lngCreatedLayers, lngExistingLayers) Then
            lngCreatedLayersAll = lngCreatedLayersAll + lngCreatedLayers
        End If
    End If
        
    MsgBox "Created " & lngCreatedLayersAll & " layers.", vbInformation
        
Controlled_Exit:
    
    App.Frame.ProjectBarUpdating = True
    
    Set oLayersInfo = Nothing
    Set AA = Nothing
    Set AE = Nothing
    Set AI = Nothing
    
Exit Sub

ErrTrap:
        
    MsgBox Err.Description, vbExclamation
    Resume Controlled_Exit
    
End Sub

