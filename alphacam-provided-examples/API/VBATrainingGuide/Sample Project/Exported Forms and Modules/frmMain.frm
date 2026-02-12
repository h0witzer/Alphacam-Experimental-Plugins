VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmMain 
   Caption         =   "Cathedral Door !!"
   ClientHeight    =   3045
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6690
   OleObjectBlob   =   "frmMain.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "frmMain"
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdCancel_Click()
    ' exit macro
    End
End Sub

Private Sub cmdOK_Click()
    ' hide form
    frmMain.Hide
    DoEvents
    
    'run function to create catherdral door
    CreateCathedralDoor LicomDbl(txtHeight), LicomDbl(txtWidth), LicomDbl(txtDepth), _
        LicomDbl(txtBorder), LicomDbl(txtShoulder), LicomDbl(txtArch)

    ' run function to redraw
    Refresh
    
    ' run solid simulation
    SendKeys "%VSS~", True
    
'    ' output nc to file called temp.anc
'    App.ActiveDrawing.OutputNC App.LicomdirPath & _
'        "licomdir\temp.anc", acamOutNcFILE, True
'
'    ' open nc code in AlphaEdit
'    AlphaEdit.OpenDoc App.LicomdirPath & "licomdir\temp.anc"
    
    ' end macro
    End
End Sub

Private Sub txtArch_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
    TextBoxCalculate txtArch, Cancel
End Sub

Private Sub txtBorder_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
    TextBoxCalculate txtBorder, Cancel
End Sub

Private Sub txtHeight_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
    TextBoxCalculate txtHeight, Cancel
End Sub

Private Sub txtWidth_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
    TextBoxCalculate txtWidth, Cancel
End Sub

Private Sub UserForm_Initialize()
    
    ' set default captions from text file
    With App.Frame
        Me.Caption = .ReadTextFile("CathedralDoor.txt", 20, 1)
        
        fraDoor.Caption = .ReadTextFile("CathedralDoor.txt", 20, 2)
        lblWidth.Caption = .ReadTextFile("CathedralDoor.txt", 20, 3)
        lblHeight.Caption = .ReadTextFile("CathedralDoor.txt", 20, 4)
        lblDepth.Caption = .ReadTextFile("CathedralDoor.txt", 20, 5)
        
        fraPanel.Caption = .ReadTextFile("CathedralDoor.txt", 20, 6)
        lblBorder.Caption = .ReadTextFile("CathedralDoor.txt", 20, 7)
        lblShoulder.Caption = .ReadTextFile("CathedralDoor.txt", 20, 8)
        lblArch.Caption = .ReadTextFile("CathedralDoor.txt", 20, 9)
        
        ' these have come from the encrypted AlphaEdit text file
        cmdOK.Caption = .ReadTextFile("Aedit.ctx", 65, 1)
        cmdCancel.Caption = .ReadTextFile("Aedit.ctx", 65, 2)
        
    End With
    
    ' set accelerators and remove selection margin
    SetAccelerators Me
    
    ' set defaults for door
    txtWidth = 500
    txtHeight = 800
    txtDepth = 25
    
    ' set defaults for panel
    txtBorder = 75
    txtShoulder = 25
    txtArch = 20
    
    ' set focus to first text box and highlight
    txtWidth.SetFocus
    txtWidth.SelStart = 0
    txtWidth.SelLength = 999
    
End Sub


