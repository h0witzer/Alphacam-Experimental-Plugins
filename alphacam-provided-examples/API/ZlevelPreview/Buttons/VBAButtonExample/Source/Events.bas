Attribute VB_Name = "Events"
Option Explicit
'

Function InitAlphacamAddIn(AcamVersion As Long) As Integer
    
    Dim lngTB                   As Long
    
    Const DEF_MENU              As String = "2010 VBA Button Example"
    
    With App.Frame
            
        ' create a new toolbar
        lngTB = .CreateButtonBar(DEF_MENU)
        
        ' add a new menu and menu item using a 192/192/192 transparency image
        If .AddMenuItem2("192 Transparency", "g_192", acamMenuNEW, DEF_MENU) Then
                
            ' if the menu item was created successfully, then add a button
            ' to the new toolbar which corresponds to the newly added command
            '
            Call .AddButton(lngTB, "192.bmp", .LastMenuCommandID)
                                    
            ' NOTE...
            '
            ' For large icons, nothing needs to be done within the code
            ' here.  The Frame.AddButton method automatically looks for a
            ' corresponding .bmp which contains "Large" at the end of its
            ' file name.  This file must be located in the same folder as
            ' the file being specified in the BmpFileName argument.
            '
            ' For this example, if a "192Large.bmp" file is found in the
            ' same folder as the "192.bmp", it will added automatically.
            '
            ' Large icons are displayed when the Large Icons option within
            ' the Customize -> Option tab is checked on.
                
        End If
            
        ' do the same as above, this time using a 32-bit Alpha Bitmap image
        If .AddMenuItem2("RGB/A Transparency", "g_RGBA", acamMenuNEW, DEF_MENU) Then
            Call .AddButton(lngTB, "RGBA.bmp", .LastMenuCommandID)
        End If
            
    End With
    
    InitAlphacamAddIn = 0
    
End Function

Public Function g_RGBA()
    MsgBox "RGB/A transparency", vbInformation
End Function

Public Function g_192()
    MsgBox "R192 G192 B192 transparency", vbInformation
End Function

