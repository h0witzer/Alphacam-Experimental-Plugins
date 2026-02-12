Attribute VB_Name = "ExportEverything"
Option Explicit



' *****************************************************
' To use this the following reference must be turned on
'
' Microsoft Visual Basic For Applications Extensibilty
'
' *****************************************************
   

Private Sub ExportAll()
   
    ' Use the active project
    Dim VBP As VBProject
    Set VBP = Application.VBE.ActiveVBProject
    With VBP
    
      ' loop through each component
      Dim vbc As VBComponent
      For Each vbc In VBP.VBComponents
         Dim ProjectName As String, ExportPath As String
         ProjectName = VBP.name
         ExportPath = App.Frame.PathOfThisAddin & "\Export Files for " & ProjectName & "\"
         Dim TestDir As String
         TestDir = Dir(ExportPath, vbDirectory)
         If TestDir = "" Then
            MkDir ExportPath
         End If
         Dim vbcName As String, vbcType As String
         vbcName = vbc.name: vbcType = vbc.Type
         Select Case vbcType
            Case vbext_ct_StdModule
               vbcName = ExportPath & vbcName & ".bas"
            Case vbext_ct_ClassModule
               vbcName = ExportPath & vbcName & ".cls"
            Case vbext_ct_MSForm
               vbcName = ExportPath & vbcName & ".frm"
            Case Else
            
         End Select
         
         vbc.Export vbcName
         
      Next

   End With
    
End Sub

