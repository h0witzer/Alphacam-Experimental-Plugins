Attribute VB_Name = "Events"
Option Explicit

Function InitAlphacamAddIn(AcamVersion As Long) As Integer
  
  Dim MenuName2 As String
  Dim MenuName3 As String
  
  Dim RibbonGroupName3 As String
  
  Dim ItemName2  As String
  Dim ItemName3  As String
  Dim ItemName4  As String
  
'
  MenuName2 = "Menu 2 Name"
  MenuName3 = "Menu 3 Name"
  
  ItemName2 = "Item 2"
  ItemName3 = "Item 3"
  ItemName4 = "Item 4"
  
  RibbonGroupName3 = "Group Name 3"
  
  ' For all .AddButton calls, a button bar ID of 0 may be used
  ' Button bar ID's are now deprecated since the introduction of the ribbon bar interface
    
  ' ** AddMenuItem2
  ' Can be used to add a new menu items and menu items to existing predefined Alphacam groups
  ' It is not possible to set the ribbon bar group text. This will have the macro project name
  
  ' Example 1 - add a new ribbon button to a new ribbon tab
  If Frame.AddMenuItem2(ItemName2, "Main2", acamMenuNEW, MenuName2) Then
    Frame.AddButton 0, Frame.PathOfThisAddin & "\2.png", Frame.LastMenuCommandID
  End If
  
  ' Example 2 - add a new ribbon button to the "File" ribbon group of the "Home" ribbon tab
  ' When adding to an existing group, pass an empty string "" to the final argument
  If Frame.AddMenuItem2(ItemName2, "Main2", acamMenuFILE_SAVE, "") Then
    Frame.AddButton 0, Frame.PathOfThisAddin & "\2.png", Frame.LastMenuCommandID
  End If
    
  ' ** AddMenuItem3
  ' Allows menu items to be added to their own custom group names
  ' Example 3 - add a new ribbon button to a new ribbon tab, in a new ribbon group
  If Frame.AddMenuItem3(ItemName3, "Main3", acamMenuNEW, MenuName3, RibbonGroupName3) Then
    Frame.AddButton 0, Frame.PathOfThisAddin & "\3.png", Frame.LastMenuCommandID
  End If
    
  ' Example 4 - add a new ribbon button to a new ribbon tab, in a new ribbon group
  If Frame.AddMenuItem3(ItemName3 & "_1", "Main3_1", acamMenuNEW, MenuName3, RibbonGroupName3 & "_1") Then
    Frame.AddButton 0, Frame.PathOfThisAddin & "\3.png", Frame.LastMenuCommandID
  
    ' Add a second command to this ribbon group
    If Frame.AddMenuItem3(ItemName3 & "_2", "Main3_2", acamMenuNEW, MenuName3, RibbonGroupName3 & "_1") Then
      Frame.AddButton 0, Frame.PathOfThisAddin & "\3.png", Frame.LastMenuCommandID
    End If
  End If
  
  ' ** AddMenuItem32
  ' As AddMenuItem3 but allows command ID's to be passed.
  ' The command ID's passed will be used internally for some add-ins only
  ' For a user or developer AddMenuItem3 should be used
  
  ' ** AddMenuItem33
  ' AddMenuItem33 is not supported for VBA Addins and should not be used.
  ' This is used for .net and C++ addins only

  ' ** AddMenuItem4
  ' Allows a command to be added next to an existing command that is in a Pop-Up Menu or in a Ribbon Group
  
  ' AddMenuItem4, AddMenuItem42 and AddMenuItem43 cannot be used add buttons to a new tab,
  
  ' Use True for the "After" boolean argument to specify if the item should be
  ' added after the specified command. Passing False to this parameter will add
  ' the item before the specified command
  
  ' Example 5 - add a new ribbon button after the "Output NC" ribbon button
  If Frame.AddMenuItem4(ItemName4, "Main4", acamCmdFILE_OUTPUTNC, True, "") Then
    Frame.AddButton 0, Frame.PathOfThisAddin & "\4.png", Frame.LastMenuCommandID
  End If

  ' Example 6 - add a new item in the edit machining drop down pop-up menu,
  ' after the "Toolpath Data" menu item
  If Frame.AddMenuItem4(ItemName4, "Main4_1", acamCmdMACHINE_EDIT_TOOLPATHS, True, "") Then
    Frame.AddButton acamButtonBarMACHINING, Frame.PathOfThisAddin & "\4.png", Frame.LastMenuCommandID
  End If
  
  ' ** AddMenuItem42
  ' As AddMenuItem4 but allows command ID's to be passed.
  ' The command ID's passed will be used internally for some add-ins only
  ' For a user or developer AddMenuItem4 should be used
  
  
  ' ** AddMenuItem43
  ' As above for AddMenuItem33
  ' AddMenuItem43 is not supported for VBA Addins. This is used for .net and C++ addins only
    
    
  ' Summary from the above
  ' ----------------------
  
  ' Use AddMenuItem3 for adding new commands to new ribbon tabs in the ribbon bar
  ' (AddMenuItem3 can also be used to add command to sections based on the legacy menu names)
  '
  ' Use AddMenuItem4 for adding new commands to existing ribbon tabs
  '
  ' Use AddMenuItem33 and AddMenuItem43 when developing .net Add-ins
  ' See the ExampleFiles\API\DotNetAddins folder for sample code
    
  InitAlphacamAddIn = 0
End Function

Sub Main2()
  MsgBox "Item 2 has been clicked", vbInformation
End Sub

Sub Main3()
  MsgBox "Item 3 has been clicked", vbInformation
End Sub

Sub Main3_1()
  MsgBox "Item 3_1 has been clicked", vbInformation
End Sub

Sub Main3_2()
  MsgBox "Item 3_2 has been clicked", vbInformation
End Sub

Sub Main4()
  MsgBox "Item 4 has been clicked", vbInformation
End Sub

Sub Main4_1()
  MsgBox "Item 4 has been clicked", vbInformation
End Sub

