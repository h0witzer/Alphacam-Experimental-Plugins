Attribute VB_Name = "Events"
Option Explicit

Public Function InitAlphacamAddIn(acamversion As Long) As Integer
    Dim fr As Frame
    Set fr = App.Frame
    With fr
        ' get item and menu names from text file
        Dim ItemName As String, MenuName As String
        MenuName = .ReadTextFile("CathedralDoor.txt", 10, 1)
        ItemName = .ReadTextFile("CathedralDoor.txt", 10, 2)
        ' create new menu
        .AddMenuItem2 ItemName, "ShowfrmMain", acamMenuNEW, MenuName
    End With
    InitAlphacamAddIn = 0
End Function

Function ShowFrmMain()
    ' run funtion to test if active drawing has any geometries
    FileNew
    ' show main dialog box
    Load frmMain
    frmMain.Show
End Function



