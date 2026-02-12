VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmMain 
   Caption         =   "Shower Base Machining!!!"
   ClientHeight    =   7650
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   7125
   OleObjectBlob   =   "frmMain.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Option Explicit

Private m_oSBD                      As CShowerBaseData
Private m_oMD                       As MillData
'Private m_sToolName                 As String
Private m_bCancel                   As Boolean
Private m_bIsEdit                   As Boolean
'

Public Property Get Cancelled() As Boolean
        Cancelled = m_bCancel
End Property

Public Function GetShowBaseData() As CShowerBaseData
        Set GetShowBaseData = m_oSBD
End Function

Public Sub SetShowBaseData(SBD As CShowerBaseData, MD As MillData)
        
        Set m_oSBD = SBD
        Set m_oMD = MD
        
        Call m_GetDefaultSettings
        
        m_bIsEdit = True
        
End Sub

Private Sub m_GetToolProps(MT As MillTool)
        
On Error Resume Next

        With m_oSBD
                
                Call .UpdateToolProps(MT)
                        
                With .Tool
                        lblToolName.Caption = gs_TruncateText(.name, (lblToolName.Width - 5))
                        lblToolName.Tag = .name
                        txtDiameter.Text = gs_NoComma(gs_Round(.Diameter, 3))
                End With
                
                txtToolNumber.Text = .ToolNumber
                txtOffsetNumber.Text = .OffsetNumber
                                                
                txtCutFeed.Text = gs_NoComma(gs_Round(.CutFeed, 0))
                txtDownFeed.Text = gs_NoComma(gs_Round(.DownFeed, 0))
                txtSpindleSpeed.Text = gs_NoComma(gs_Round(.SpindleSpeed, 0))
                
        End With
                
End Sub

Private Sub cmdCancel_Click()
        
        m_bCancel = True
        
        Call Me.Hide
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
        
        Dim strMsg                  As String
                
        strMsg = PText(30, 1, "WARNING") & vbCrLf & vbCrLf
        
        Select Case True
        
                Case (PDbl(txtZSafeRapid.Text) < PDbl(txtZRapidTo.Text))
                
                        strMsg = strMsg & PText(30, 4, "The Safe Z is less than the Rapid Z.")
                        MsgBox strMsg, vbInformation
                        txtZSafeRapid.SetFocus
                        Exit Sub
                        
                Case (PDbl(txtZSafeRapid.Text) < PDbl(txtZProfile.Text))
        
                        strMsg = strMsg & PText(30, 5, "The Safe Z is less than the Material Top.")
                        MsgBox strMsg, vbInformation
                        txtZSafeRapid.SetFocus
                        Exit Sub
                        
                Case (PDbl(txtZRapidTo.Text) < PDbl(txtZProfile.Text))
                
                        strMsg = strMsg & PText(30, 6, "The Rapid Z is less than the Material Top.")
                        MsgBox strMsg, vbInformation
                        txtZRapidTo.SetFocus
                        Exit Sub
                        
                Case (optCuttingOptionProfile.Value And (PDbl(txtZStepAlongProfile.Text) <= 0))
                                                
                        txtZStepAlongProfile.SetFocus
                        Exit Sub
                        
                Case (optCuttingOptionRadial.Value And (PDbl(txtZRadialAngle.Text) <= 0))
                        
                        txtZRadialAngle.SetFocus
                        Exit Sub
                                        
        End Select
                
        m_bCancel = False
        
        Call Me.Hide
        DoEvents
        
        Call m_SaveSettings
        
        If Not m_bIsEdit Then
                If mb_Run Then Call m_oSBD.SaveSettingsToReg
        End If
        
End Sub

Private Function mb_Run() As Boolean
        
        Dim pthHole                 As Path
        Dim pthProfile              As Path
        Dim blnRet                  As Boolean
                
On Error GoTo ErrTrap
        
        blnRet = False
        
        If Not gb_SelectGeos(pthHole, pthProfile) Then
                Call App.ActiveDrawing.RedrawShadedViews
                GoTo Controlled_Exit
        End If
                        
        blnRet = gb_DoShowerBase(m_oSBD, m_oMD, pthHole, pthProfile)
        
Controlled_Exit:
        
        Set pthHole = Nothing
        Set pthProfile = Nothing
        
        mb_Run = blnRet
        
Exit Function
        
ErrTrap:
        
        MsgBox Err.Description, vbExclamation
        blnRet = False
        Resume Controlled_Exit
        
End Function

Private Sub optCuttingOptionRadial_Click()
        
        Dim blnEnabled              As Boolean
        
        blnEnabled = optCuttingOptionRadial.Value
        
        ' setup controls
        txtZStepAlongProfile.Enabled = Not blnEnabled
        lblZStepAlongProfile.Enabled = Not blnEnabled
                
        txtZRadialAngle.Enabled = blnEnabled
        lblZRadialAngle.Enabled = blnEnabled
        
End Sub

Private Sub optCuttingOptionProfile_Click()
                
        Dim blnEnabled              As Boolean
        
        blnEnabled = optCuttingOptionProfile.Value
                
        ' setup controls
        txtZRadialAngle.Enabled = Not blnEnabled
        lblZRadialAngle.Enabled = Not blnEnabled
        
        'Abilita txt lungo il profilo
        txtZStepAlongProfile.Enabled = blnEnabled
        lblZStepAlongProfile.Enabled = blnEnabled
        
End Sub

Private Sub txtZRadialAngle_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtZRadialAngle, Cancel)
End Sub

Private Sub txtCutFeed_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtCutFeed, Cancel)
End Sub

Private Sub txtDownFeed_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtDownFeed, Cancel)
End Sub

Private Sub txtDiameter_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtDiameter, Cancel)
End Sub

Private Sub txtZStepAlongProfile_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtZStepAlongProfile, Cancel)
End Sub

Private Sub txtOffsetNumber_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtOffsetNumber, Cancel)
End Sub

Private Sub txtSpindleSpeed_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtSpindleSpeed, Cancel)
End Sub

Private Sub txtToolNumber_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtToolNumber, Cancel)
End Sub

Private Sub txtZStock_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtZStock, Cancel)
End Sub

Private Sub txtZRapidTo_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtZRapidTo, Cancel)
End Sub

Private Sub txtZHole_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtZHole, Cancel)
End Sub

Private Sub txtZProfile_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtZProfile, Cancel)
End Sub

Private Sub txtZSafeRapid_BeforeUpdate(ByVal Cancel As MSForms.ReturnBoolean)
        Call g_Eval(txtZSafeRapid, Cancel)
End Sub

Private Sub UserForm_Initialize()
                        
On Error Resume Next
        
        Set m_oSBD = New CShowerBaseData
                
        m_bCancel = False
        m_bIsEdit = False
        
        Call m_SetCaptions
        Call m_GetDefaultSettings
        Call g_SetAccelerators(Me)

End Sub

Private Sub m_SetCaptions()

On Error Resume Next
        
        Me.Caption = PText(5, 1, Me.Caption)
        
        cmdChangeTool.Caption = PText(10, 1, cmdChangeTool.Caption)
        
        ' tool data
        fraToolData.Caption = PText(10, 2, fraToolData.Caption)
        lblToolNumber.Caption = PText(10, 3, lblToolNumber.Caption)
        lblOffsetNumber.Caption = PText(10, 4, lblOffsetNumber.Caption)
        lblDiameter.Caption = PText(10, 5, lblDiameter.Caption)
        lblSpindleSpeed.Caption = PText(10, 6, lblSpindleSpeed.Caption)
        lblDownFeed.Caption = PText(10, 7, lblDownFeed.Caption)
        lblCutFeed.Caption = PText(10, 8, lblCutFeed.Caption)
        
        ' coolant
        fraCoolant.Caption = PText(12, 1, fraCoolant.Caption)
        optCoolantNone.Caption = PText(12, 2, optCoolantNone.Caption)
        optCoolantMist.Caption = PText(12, 3, optCoolantMist.Caption)
        optCoolantFlood.Caption = PText(12, 4, optCoolantFlood.Caption)
        optCoolantThroughTool.Caption = PText(12, 5, optCoolantThroughTool.Caption)
        
        ' cutting method
        fraCutMethod.Caption = PText(20, 1, fraCutMethod.Caption)
        optCuttingMethodOneWay.Caption = PText(20, 2, optCuttingMethodOneWay.Caption)
        optCuttingMethodBidirectional.Caption = PText(20, 3, optCuttingMethodBidirectional.Caption)
        
        ' start cutting at
        fraStartCutting.Caption = PText(22, 1, fraStartCutting.Caption)
        optStartCuttingHole.Caption = PText(22, 2, optStartCuttingHole.Caption)
        optStartCuttingProfile.Caption = PText(22, 3, optStartCuttingProfile.Caption)
        
        ' cutting options
        fraCuttingOptions.Caption = PText(23, 1, fraCuttingOptions.Caption)
        optCuttingOptionProfile.Caption = PText(23, 2, optCuttingOptionProfile.Caption)
        optCuttingOptionRadial.Caption = PText(23, 3, optCuttingOptionRadial.Caption)
        
        ' z levels
        fraZLevels.Caption = PText(16, 1, fraZLevels.Caption)
        lblZSafeRapid.Caption = PText(16, 2, lblZSafeRapid.Caption)
        lblZRapidTo.Caption = PText(16, 3, lblZRapidTo.Caption)
        lblZProfile.Caption = PText(25, 1, lblZProfile.Caption)
        lblZHole.Caption = PText(25, 2, lblZHole.Caption)
        lblZStepAlongProfile.Caption = PText(25, 3, lblZStepAlongProfile.Caption)
        lblZRadialAngle.Caption = PText(25, 4, lblZRadialAngle.Caption)
        lblZStock.Caption = PText(25, 5, lblZStock.Caption)
        
        ' buttons
        cmdOK.Caption = PText(50, 1, cmdOK.Caption)
        cmdCancel.Caption = PText(50, 2, cmdCancel.Caption)
                        
        txtDiameter.Locked = True
        txtDiameter.BackColor = &H8000000F
                
        lblToolName.BackColor = vbButtonFace
        
End Sub

Private Sub m_GetDefaultSettings()
        
        Dim intCoolant              As AcamCoolant

On Error Resume Next
        
        With m_oSBD

                Call m_GetToolProps(Nothing)
        
                intCoolant = .Coolant
                
                optCoolantFlood.Value = (intCoolant = acamCoolFLOOD)
                optCoolantMist.Value = (intCoolant = acamCoolMIST)
                optCoolantNone.Value = (intCoolant = acamCoolNONE)
                optCoolantThroughTool.Value = (intCoolant = acamCoolTOOL)
        
                optCuttingMethodBidirectional.Value = .CuttingMethodBiDir
                optCuttingMethodOneWay.Value = Not optCuttingMethodBidirectional.Value
                        
                optCuttingOptionProfile.Value = .CutAlongProfile
                optCuttingOptionRadial.Value = Not optCuttingOptionProfile.Value
        
                optStartCuttingHole.Value = .StartCuttingAtHole
                optStartCuttingProfile.Value = Not optStartCuttingHole.Value
        
                txtZHole.Text = gs_NoComma(.DepthAtHole)
                txtZProfile.Text = gs_NoComma(.DepthAtProfile)
                txtZRadialAngle.Text = gs_NoComma(.RadialAngle)
                txtZStepAlongProfile.Text = gs_NoComma(.StepAlongProfile)
                txtZStock.Text = gs_NoComma(.StockToBeLeft)
                
                txtZRapidTo.Text = gs_NoComma(.RapidTo)
                txtZSafeRapid.Text = gs_NoComma(.SafeRapid)
        
        End With
        
        Call optCuttingOptionProfile_Click
        
End Sub

Private Sub m_SaveSettings()

On Error Resume Next

        ' save current settings
        With m_oSBD
                                                                
                .ToolNumber = CLng(txtToolNumber.Text)
                .OffsetNumber = CLng(txtOffsetNumber.Text)
                .DownFeed = PDbl(txtDownFeed.Text)
                .CutFeed = PDbl(txtCutFeed.Text)
                .SpindleSpeed = PDbl(txtSpindleSpeed.Text)
                '.MaterialTop = PDbl(txtMatTop.Text)
                .RapidTo = PDbl(txtZRapidTo.Text)
                .SafeRapid = PDbl(txtZSafeRapid.Text)
                .DepthAtHole = PDbl(txtZHole.Text)
                .RadialAngle = PDbl(txtZRadialAngle.Text)
                .StepAlongProfile = PDbl(txtZStepAlongProfile.Text)
                .StockToBeLeft = PDbl(txtZStock.Text)
                .CutAlongProfile = CBool(optCuttingOptionProfile.Value)
                .CuttingMethodBiDir = CBool(optCuttingMethodBidirectional.Value)
                .StartCuttingAtHole = CBool(optStartCuttingHole.Value)
                                                                                     
                .Coolant = Switch(optCoolantFlood.Value, acamCoolFLOOD, _
                                  optCoolantMist.Value, acamCoolMIST, _
                                  optCoolantNone.Value, acamCoolNONE, _
                                  optCoolantThroughTool.Value, acamCoolTOOL)
                                                                                                                                                                                                                              
        End With
        
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
        
        Set m_oMD = Nothing
        Set m_oSBD = Nothing
        
        Set frmMain = Nothing

End Sub
