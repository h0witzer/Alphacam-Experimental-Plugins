VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmMain 
   Caption         =   "Boring Along 2D Line"
   ClientHeight    =   7560
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7635
   OleObjectBlob   =   "frmMain.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False




Option Explicit

Private m_oBD                       As CBoringData
Private m_oMD                       As MillData
Private m_bCancel                   As Boolean
Private m_bIsEdit                   As Boolean
'

Public Property Get Cancelled() As Boolean
        Cancelled = m_bCancel
End Property

Public Function GetBoringData() As CBoringData
        Set GetBoringData = m_oBD
End Function

Public Sub SetBoringData(BD As CBoringData, MD As MillData)
        
        Set m_oBD = BD
        Set m_oMD = MD
        
        Call m_GetDefaultSettings
        
        m_bIsEdit = True
        
End Sub

Private Sub chkAutoZ_Click()
        
        With chkAutoZ
                lblBottom.Enabled = Not .Value
                txtBottom.Enabled = Not .Value
        End With
        
End Sub

Private Sub chkPecking_Click()
        
        With chkPecking
                lblPeck.Enabled = .Value
                txtPeck.Enabled = .Value
                lblPeckRetract.Enabled = .Value
                cboPeckRetract.Enabled = .Value
        End With
        
End Sub

Private Sub cmdCancel_Click()
        
        Call App.ActiveDrawing.SetGeosSelected(False)
        
        m_bCancel = True
        Me.Hide
        DoEvents
        'Call Unload(Me)
        
End Sub

Private Sub cmdChangeTool_Click()
        
        Dim MT                      As MillTool
        
        Call Me.Hide
        
        If gb_PickTool(, MT) Then Call m_GetToolProps(MT)
        
        Me.Show
        
        Set MT = Nothing

End Sub

Private Sub cmdOK_Click()
                        
        Const REG_SETTINGS = DEF_MACRO_NAME & "\Boring"
                        
On Error Resume Next
        
        ' lets make sure we've got everything we need
        If Not gb_CheckAllText(Me) Then Exit Sub
        
        ' now lets make sure we've got a pecking distance
        If chkPecking.Value Then
                If (PDbl(txtPeck.Text) <= 0) Then
                        MsgBox PText(50, 2, "Please enter a valid pecking distance."), vbInformation
                End If
        End If
                
        m_bCancel = False
                
        ' get me the hell out of the way
        Call Me.Hide
        DoEvents
        
        Call m_SaveSettings
        
        ' 10 jun 11 TFS#44656
        '
        If Not m_bIsEdit Then
                If mb_DrillEm Then Call m_oBD.SaveSettingsToReg
        End If
        
        'Call Unload(Me)
        
End Sub

Private Function mb_DrillEm() As Boolean
        
        Dim PS                      As Paths
        Dim PS2                     As Paths
        Dim blnRet                  As Boolean
                
On Error GoTo ErrTrap
        
        blnRet = True
                
        ' now select the hole center lines
        Set PS = App.ActiveDrawing.UserSelectMultiGeosCollection(PText(100, 1, "BORING 2D LINE") & ": " & _
                                                                 PText(50, 1, "Select Hole Center Lines"), 0)
        
        ' lets make sure we've got something
        If (PS Is Nothing) Then GoTo Controlled_Exit
        If (PS.Count = 0) Then GoTo Controlled_Exit
        
        If gb_AnyInvalidGeos(PS, PS2) Then
                MsgBox PText(75, 1, "Arcs and 3D Polylines will be ignored."), vbInformation
        End If
        
        blnRet = gb_DrillEm(PS2, m_oBD, m_oMD)
        
Controlled_Exit:
        
        Set PS = Nothing
        Set PS2 = Nothing
        
        mb_DrillEm = blnRet
        
Exit Function
        
ErrTrap:
        
        MsgBox Err.Description, vbExclamation
        blnRet = False
        Resume Controlled_Exit
        
End Function

Private Sub m_GetToolProps(MT As MillTool)
        
On Error Resume Next

        With m_oBD
                
                If Not (MT Is Nothing) Then Call .UpdateToolProps(MT)
                        
                With .Tool
                        lblToolName.Caption = gs_TruncateText(.name, (lblToolName.Width - 5))
                        lblToolName.Tag = .name
                        txtDiameter.Text = gs_NoComma(gs_Round(.Diameter, 3))
                End With
                
                txtTool.Text = .ToolNumber
                txtOffset.Text = .OffsetNumber
                                                
                txtFeed.Text = gs_NoComma(gs_Round(.DrillFeed, 0))
                txtSpeed.Text = gs_NoComma(gs_Round(.SpindleSpeed, 0))
                
        End With
                
End Sub

Private Sub txtBottom_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtBottom, Cancel)
End Sub

Private Sub txtDiameter_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtDiameter, Cancel)
End Sub

Private Sub txtDwell_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtDwell, Cancel)
End Sub

Private Sub txtFeed_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtFeed, Cancel)
End Sub

Private Sub txtHoleCenterZ_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtHoleCenterZ, Cancel)
End Sub

Private Sub txtMatTop_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtMatTop, Cancel)
End Sub

Private Sub txtOffset_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_EvalInt(txtOffset, Cancel, False)
End Sub

Private Sub txtPeck_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtPeck, Cancel)
End Sub

Private Sub txtRap_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtRap, Cancel)
End Sub

Private Sub txtSafe_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtSafe, Cancel)
End Sub

Private Sub txtSpeed_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_EvalInt(txtSpeed, Cancel, False)
End Sub

Private Sub txtTool_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_EvalInt(txtTool, Cancel, False)
End Sub

Private Sub m_SetCaptions()
        
On Error Resume Next
        
        Me.Caption = PText(5, 1, Me.Caption)
                
        cmdOK.Caption = PText(8, 1, cmdOK.Caption)
        cmdCancel.Caption = PText(8, 2, cmdCancel.Caption)
        cmdChangeTool.Caption = PText(8, 5, cmdChangeTool.Caption)
         
        fraZLevels.Caption = PText(10, 1, fraZLevels.Caption)
        lblSafe.Caption = PText(10, 2, lblSafe.Caption)
        lblRap.Caption = PText(10, 3, lblRap.Caption)
        lblMatTop.Caption = PText(10, 4, lblMatTop.Caption)
        lblBottom.Caption = PText(10, 5, lblBottom.Caption)
        chkAutoZ.Caption = PText(10, 6, chkAutoZ.Caption)
        lblHoleCenterZ.Caption = PText(10, 7, lblHoleCenterZ.Caption)
        chkPecking.Caption = PText(10, 8, chkPecking.Caption)
        lblPeck.Caption = PText(10, 9, lblPeck.Caption)
        lblDwell.Caption = PText(10, 10, lblDwell.Caption)
        lblPeckRetract.Caption = PText(10, 11, lblPeckRetract.Caption)
        
        With cboPeckRetract
                Call .AddItem(PText(10, 12, "Full"))
                Call .AddItem(PText(10, 13, "Partial"))
        End With
        
        fraTraverseAt.Caption = PText(15, 1, fraTraverseAt.Caption)
        optSafeRapid.Caption = PText(15, 2, optSafeRapid.Caption)
        optRapidLevel.Caption = PText(15, 3, optRapidLevel.Caption)
        
        fraHoleDepth.Caption = PText(20, 1, fraHoleDepth.Caption)
        optDrillTip.Caption = PText(20, 2, optDrillTip.Caption)
        optShoulder.Caption = PText(20, 3, optShoulder.Caption)
        
        fraToolData.Caption = PText(25, 1, fraToolData.Caption)
        lblTool.Caption = PText(25, 2, lblTool.Caption)
        lblOffset.Caption = PText(25, 3, lblOffset.Caption)
        lblDiameter.Caption = PText(25, 4, lblDiameter.Caption)
        lblSpeed.Caption = PText(25, 5, lblSpeed.Caption)
        lblFeed.Caption = PText(25, 6, lblFeed.Caption)
        
        fraCoolant.Caption = PText(30, 1, fraCoolant.Caption)
        optCoolantNone.Caption = PText(30, 2, optCoolantNone.Caption)
        optCoolantMist.Caption = PText(30, 3, optCoolantMist.Caption)
        optCoolantFlood.Caption = PText(30, 4, optCoolantFlood.Caption)
        optCoolantThroughTool.Caption = PText(30, 5, optCoolantThroughTool.Caption)

End Sub

Private Sub m_SaveSettings()

On Error Resume Next

        ' save current settings
        With m_oBD
                                                
'                With .Tool
'                        lblToolName.Caption = gs_TruncateText(.Name, (lblToolName.Width - 5))
'                        lblToolName.Tag = .Name
'                        txtDiameter.Text = gs_NoComma(gs_Round(.Diameter, 3))
'                End With
                
                .ToolNumber = CLng(txtTool.Text)
                .OffsetNumber = CLng(txtOffset.Text)
                                                
                .DrillFeed = PDbl(txtFeed.Text)
                .SpindleSpeed = PDbl(txtSpeed.Text)
        
                .BottomOfHole = PDbl(txtBottom.Text)
                .MaterialTop = PDbl(txtMatTop.Text)
                .RapidTo = PDbl(txtRap.Text)
                .SafeRapid = PDbl(txtSafe.Text)
                               
                .DepthAtShoulder = CBool(optShoulder.Value)
                .TraverseAtRPlane = CBool(optRapidLevel.Value)
                                      
                .HoleCenterZShift = PDbl(txtHoleCenterZ.Text)
                .BottomAtLineEndpoint = CBool(chkAutoZ.Value)
                .DwellTime = PDbl(txtDwell.Text)
                
                .Pecking = CBool(chkPecking.Value)
                .PeckDistance = PDbl(txtPeck.Text)
                .PeckRetractPartial = (cboPeckRetract.ListIndex = 1)
                                               
                .Coolant = Switch(optCoolantFlood.Value, acamCoolFLOOD, _
                                  optCoolantMist.Value, acamCoolMIST, _
                                  optCoolantNone.Value, acamCoolNONE, _
                                  optCoolantThroughTool.Value, acamCoolTOOL)
                                                                                                                                                                                                                              
        End With
        
End Sub

Private Sub m_GetDefaultSettings()
        
On Error Resume Next
                                        
        ' get last settings
        With m_oBD
                                                
                Call m_GetToolProps(Nothing)
        
                txtBottom.Text = gs_NoComma(.BottomOfHole)
                txtHoleCenterZ.Text = gs_NoComma(.HoleCenterZShift)
                
                txtMatTop.Text = gs_NoComma(.MaterialTop)
                txtRap.Text = gs_NoComma(.RapidTo)
                txtSafe.Text = gs_NoComma(.SafeRapid)
                               
                optShoulder.Value = .DepthAtShoulder
                optDrillTip.Value = Not optShoulder.Value
                                    
                optRapidLevel.Value = .TraverseAtRPlane
                optSafeRapid.Value = Not optRapidLevel.Value
                                      
                chkAutoZ.Value = .BottomAtLineEndpoint
                txtDwell.Text = gs_NoComma(.DwellTime)
                
                chkPecking.Value = .Pecking
                txtPeck.Text = gs_NoComma(.PeckDistance)
                cboPeckRetract.ListIndex = IIf(.PeckRetractPartial, 1, 0)
                                               
                optCoolantFlood.Value = (.Coolant = acamCoolFLOOD)
                optCoolantMist.Value = (.Coolant = acamCoolMIST)
                optCoolantNone.Value = (.Coolant = acamCoolNONE)
                optCoolantThroughTool.Value = (.Coolant = acamCoolTOOL)
                           
        End With
        
        lblToolName.BackColor = vbButtonFace
        
        Call chkPecking_Click
        Call chkAutoZ_Click
        
End Sub

Private Sub UserForm_Initialize()

On Error Resume Next

        Set m_oBD = New CBoringData

        Call m_SetCaptions
        Call m_GetDefaultSettings
                
        Call g_SetAccelerators(Me)
        
        m_bCancel = False
        m_bIsEdit = False
        
End Sub

Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)

On Error Resume Next
        
        If (CloseMode <> vbFormCode) Then
                Cancel = 1
                Call cmdCancel_Click
        End If

End Sub

Private Sub UserForm_Terminate()
        
On Error Resume Next

        Set m_oBD = Nothing
        Set frmMain = Nothing
        
End Sub


