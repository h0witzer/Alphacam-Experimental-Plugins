Attribute VB_Name = "Evaluate"
' Format the number returned from VB Format function to be consistent with AlphaCAM

Public Function StripTrailingZeros(S As String) As String
    ' Replace comma with point because AlphaCAM always uses point
    Dim I As Integer
    I = InStr(S, ",")
    If I > 0 Then
        Mid(S, I) = "."
    End If
    ' Strip trailing zeros
    Do While Right(S, 1) = "0"
        S = Left(S, Len(S) - 1)
    Loop
    ' Strip decimal point if it is the last character
    If Right(S, 1) = "." Then
        S = Left(S, Len(S) - 1)
    End If
    StripTrailingZeros = S
End Function

Public Sub TextBoxCalculate(TB As TextBox, ByVal Cancel As MSForms.ReturnBoolean)
    If Len(TB.Text) = 0 Then Exit Sub
    If TB.SelLength > 0 Then Exit Sub
    Dim X As Double
    On Error GoTo HandleError
    X = App.Frame.Evaluate(TB.Text)
    TB.Text = Format(X, "#0.0000")
    TB.Text = StripTrailingZeros(TB.Text)
    TB.SelStart = 0
Exit Sub
HandleError:
    MsgBox Err.Description
    Cancel = True   ' stay in the box
End Sub

' This function should always be used to convert a string eg from
' a text box to a Double or Single value
'
' Convert string to floating point value.
' Uses Val at the moment, but may use CDbl in future to allow
' "," as decimal separator.
' Val always use ".", CDbl uses "," or ".", depending on the Regional
' Settings in Control Panel. But the AlphaCAM Evaluate function uses
' "." for decimal, and "," for parameter separators in some functions.
' To allow "," as decimal separator, extensive changes would be needed
' in AlphaCAM, so VBA should only use "." to be consistent.

Public Function LicomDbl(S As String) As Double
    LicomDbl = Val(S)
End Function
