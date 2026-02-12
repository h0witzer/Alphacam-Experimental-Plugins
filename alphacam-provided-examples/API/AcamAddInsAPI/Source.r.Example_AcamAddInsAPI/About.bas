Attribute VB_Name = "About"
Option Explicit
'

Public Sub About()

    Dim AI As AcamAddInsInterface.AddInsInterface
    Dim AX As AcamAddIns.AcamEx
    
    ' set the instance of the addins interface
    Set AI = New AcamAddInsInterface.AddInsInterface
    Set AX = AI.GetAcamExInterface(App)
    
    Call AX.ShowAboutBox
    
    Set AX = Nothing
    Set AI = Nothing
    
End Sub
