Attribute VB_Name = "ClipBoard"
Option Explicit

' Select a post and put the complete file name onto the clipboard, ready for pasting into code

Public Sub PostName2ClipBoard()
    Dim s1 As String, s2 As String
    If Not App.GetAlphaCamFileName("Select Post to put on ClipBoard", acamFileTypePOST, acamFileActionOPEN, s1, s2) Then Exit Sub
    
    Dim CB As New DataObject
    CB.SetText s1
    CB.PutInClipboard
End Sub

' Select a tool and put the complete file name onto the clipboard, ready for pasting into code

Public Sub ToolName2ClipBoard()
    Dim s1 As String, s2 As String
    If Not App.GetAlphaCamFileName("Select Tool to put on ClipBoard", acamFileTypeTOOL, acamFileActionOPEN, s1, s2) Then Exit Sub
    
    Dim CB As New DataObject
    CB.SetText s1
    CB.PutInClipboard
End Sub

Public Sub PathLengthToClipBoard()
    Dim P As Path
    Dim PathLength As Double
    
    Set P = App.ActiveDrawing.UserSelectOneGeo("Select a Geometry")
    If Not P Is Nothing Then
        PathLength = P.Length
        ' Put the number into a string and put the string on the ClipBoard
        Dim DAT As DataObject
        Set DAT = New DataObject
        DAT.SetText Str(PathLength)
        DAT.PutInClipboard
    End If
End Sub

