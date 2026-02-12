' Example VBA Macro: Hello World
' 
' Description: A simple example macro that demonstrates basic Alphacam API usage
' Author: Alphacam Experimental Plugins
' Date: 2024
' Version: 1.0

Option Explicit

Sub HelloWorld()
    On Error GoTo ErrorHandler
    
    Dim message As String
    message = "Hello World from Alphacam VBA Macro!" & vbCrLf & vbCrLf
    message = message & "This is a simple example to get you started." & vbCrLf
    message = message & "Check the templates folder for more complex examples."
    
    MsgBox message, vbInformation, "Hello World Example"
    
    Exit Sub

ErrorHandler:
    MsgBox "Error: " & Err.Description, vbCritical, "Hello World Example"
End Sub
