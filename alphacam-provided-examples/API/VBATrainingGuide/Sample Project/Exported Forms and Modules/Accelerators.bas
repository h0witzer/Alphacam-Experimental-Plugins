Attribute VB_Name = "Accelerators"

Private Const DEFAULT_CHARSET = 1
Private Const SYMBOL_CHARSET = 2
Private Const SHIFTJIS_CHARSET = 128
Private Const HANGEUL_CHARSET = 129
Private Const CHINESEBIG5_CHARSET = 136
Private Const CHINESESIMPLIFIED_CHARSET = 134
Private Declare PtrSafe Function GetUserDefaultLCID Lib "kernel32" () As Long

Public Sub SetProperFont(obj As Object)
    On Error GoTo ErrorSetProperFont
    Select Case GetUserDefaultLCID
    Case &H404 ' Traditional Chinese
        obj.Charset = CHINESEBIG5_CHARSET
        obj.Name = ChrW(&H65B0) + ChrW(&H7D30) + ChrW(&H660E) _
         + ChrW(&H9AD4)   'New Ming-Li
        obj.Size = 9
    Case &H411 ' Japan
        obj.Charset = SHIFTJIS_CHARSET
        obj.Name = ChrW(&HFF2D) + ChrW(&HFF33) + ChrW(&H20) + _
         ChrW(&HFF30) + ChrW(&H30B4) + ChrW(&H30B7) + ChrW(&H30C3) + _
         ChrW(&H30AF)
        obj.Size = 9
    Case &H412 'Korea UserLCID
        obj.Charset = HANGEUL_CHARSET
        obj.Name = ChrW(&HAD74) + ChrW(&HB9BC)
        obj.Size = 9
    Case &H804 ' Simplified Chinese
        obj.Charset = CHINESESIMPLIFIED_CHARSET
        obj.Name = ChrW(&H5B8B) + ChrW(&H4F53)
        obj.Size = 9
    Case Else   ' The other countries
' Do Nothing, makes Combo boxes crash
'        obj.Charset = DEFAULT_CHARSET
'        obj.Name = ""   ' Get the default UI font.
'        obj.Size = 8
    End Select
    Exit Sub
ErrorSetProperFont:
    Err.Number = Err
End Sub

' Convert "&" in control captions to accelerator property
' Also sets the font to Chinese or Japanese if running on
' Chinese or Japanese Windows
' Call this after reading the text for the form
' For example at the end of Userform_Initialize
' eg SetAccelerators Me

Public Sub SetAccelerators(Frm As UserForm)
    Dim C As Control
    For Each C In Frm.Controls
        Dim S As String
        Dim I As Integer
        On Error Resume Next
        S = C.Caption
        If Err.Number = 0 Then
            I = InStr(S, "&")
            If I > 0 Then
                Dim Acc  As String
                Acc = Mid(S, I + 1, 1)
                S = Left(S, I - 1) + Right(S, Len(S) - I)
                C.Caption = S
                If Acc <> "&" Then
                    C.Accelerator = Acc
                End If
            End If
        End If
        C.SelectionMargin = False
        SetProperFont C.Font
    Next C
End Sub
