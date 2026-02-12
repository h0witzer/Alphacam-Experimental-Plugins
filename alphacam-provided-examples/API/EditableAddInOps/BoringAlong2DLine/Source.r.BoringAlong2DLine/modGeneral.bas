Attribute VB_Name = "modGeneral"
Option Explicit
Option Private Module

' >< UDT ><
'
Private Type RECT
        Left                        As Long
        Top                         As Long
        Right                       As Long
        Bottom                      As Long
End Type

Private Type SH_ITEM_ID
        cb                          As Long
        abID                        As Byte
End Type

Private Type ITEMIDLIST
        mkid                        As SH_ITEM_ID
End Type

Private Type BROWSEINFO
        hWndOwner                   As LongPtr
        pIDLRoot                    As Long
        pszDisplayName              As String
        lpszTitle                   As String
        ulFlags                     As Long
        lpfnCallback                As LongPtr
        lParam                      As LongPtr
        iImage                      As Long
End Type

Private Type GUID
        Guid1                       As Long
        Guid2                       As Integer
        Guid3                       As Integer
        Guid4(0 To 7)               As Byte
End Type

' >< ENUMS ><
'
Public Enum SystemSpecialFolder
        sysSpecialFolder_AdministrativeTools = &H30&
        sysSpecialFolder_CommonAdministrativeTools = &H2F&
        sysSpecialFolder_ApplicationData = &H1A&
        sysSpecialFolder_CommonAppData = &H23&
        sysSpecialFolder_CommonDocuments = &H2E&
        sysSpecialFolder_Cookies = &H21&
        sysSpecialFolder_History = &H22&
        sysSpecialFolder_InternetCache = &H20&
        sysSpecialFolder_LocalApplicationData = &H1C&
        sysSpecialFolder_MyPictures = &H27&
        sysSpecialFolder_Personal = &H5&
        sysSpecialFolder_ProgramFiles = &H26&
        sysSpecialFolder_CommonProgramFiles = &H2B&
        sysSpecialFolder_System = &H25&
        sysSpecialFolder_Windows = &H24&
        sysSpecialFolder_Fonts = &H14&
End Enum

Public Enum SystemRegionalSetting
        RegionalSetting_DATE_SEPARATOR
        RegionalSetting_DECIMAL_SYMBOL
        RegionalSetting_SHORT_DATE
        RegionalSetting_LONG_DATE
        RegionalSetting_CURRENCY_CODE
        RegionalSetting_COUNTRY
        RegionalSetting_THOUSAND_SEPARATOR
        RegionalSetting_TIME_SEPARATOR
        RegionalSetting_LIST_SEPARATOR
End Enum

' >< CONSTANTS ><
'
Private Const WM_INITDIALOG                 As Long = &H110
Private Const WM_USER                       As Long = &H400
Private Const BFFM_INITIALIZED              As Long = 1
Private Const BFFM_SELCHANGED               As Long = 2
Private Const BFFM_SETSTATUSTEXT            As Long = (WM_USER + 100)
Private Const BFFM_SETSELECTION             As Long = (WM_USER + 102)
Private Const BIF_DEFAULT                   As Long = &H0
Private Const BIF_RETURNONLYFSDIRS          As Long = &H1       ' only local Directory
Private Const BIF_DONTGOBELOWDOMAIN         As Long = &H2
Private Const BIF_STATUSTEXT                As Long = &H4       ' Not With BIF_NEWDIALOGSTYLE
Private Const BIF_RETURNFSANCESTORS         As Long = &H8
Private Const BIF_EDITBOX                   As Long = &H10
Private Const BIF_VALIDATE                  As Long = &H20      ' use With BIF_EDITBOX or BIF_USENEWUI
Private Const BIF_NEWDIALOGSTYLE            As Long = &H40      ' Use OleInitialize before
Private Const BIF_USENEWUI                  As Long = &H50      ' = (BIF_NEWDIALOGSTYLE + BIF_EDITBOX)
Private Const BIF_BROWSEINCLUDEURLS         As Long = &H80
Private Const BIF_UAHINT                    As Long = &H100     ' use With BIF_NEWDIALOGSTYLE, add Usage Hint if no EditBox
Private Const BIF_NONEWFOLDERBUTTON         As Long = &H200
Private Const BIF_NOTRANSLATETARGETS        As Long = &H400
Private Const BIF_BROWSEFORCOMPUTER         As Long = &H1000
Private Const BIF_BROWSEFORPRINTER          As Long = &H2000
Private Const BIF_BROWSEINCLUDEFILES        As Long = &H4000
Private Const BIF_SHAREABLE                 As Long = &H8000    ' use With BIF_NEWDIALOGSTYLE

Private Const MAX_PATH                      As Long = 260

Private Const ANSI_CHARSET                  As Long = 0
Private Const DEFAULT_CHARSET               As Long = 1
Private Const SYMBOL_CHARSET                As Long = 2

Private Const SHIFTJIS_CHARSET              As Long = 128
Private Const HANGEUL_CHARSET               As Long = 129
Private Const JOHAB_CHARSET                 As Long = 130
Private Const CHINESEBIG5_CHARSET           As Long = 136
Private Const CHINESESIMPLIFIED_CHARSET     As Long = 134
Private Const GREEK_CHARSET                 As Long = 161
Private Const TURKISH_CHARSET               As Long = 162
Private Const VIETNAMESE_CHARSET            As Long = 163
Private Const HEBREW_CHARSET                As Long = 177
Private Const ARABIC_CHARSET                As Long = 178
Private Const BALTIC_CHARSET                As Long = 186
Private Const RUSSIAN_CHARSET               As Long = 204
Private Const THAI_CHARSET                  As Long = 222
Private Const EASTEUROPE_CHARSET            As Long = 238
Private Const OEM_CHARSET                   As Long = 255

Private Const CHINESETRADITIONAL_LCID       As Long = &H404
Private Const CHINESESIMPLIFIED_LCID        As Long = &H804
Private Const JAPANESE_LCID                 As Long = &H411
Private Const KOREAN_LCID                   As Long = &H412
Private Const HEBREW_LCID                   As Long = &H40D

Private Const RDW_INVALIDATE                As Long = &H1
Private Const CLR_INVALID                   As Long = &HFFFF
Private Const GUID_OK                       As Long = 0

Private Const HH_DISPLAY_TOPIC              As Long = &H0
Private Const HH_HELP_CONTEXT               As Long = &HF       ' Display mapped numeric value in  dwData.

' >< API ><
'
Private Declare PtrSafe Sub OutputDebugString Lib "kernel32" Alias "OutputDebugStringA" (ByVal lpOutputString As String)
Private Declare PtrSafe Sub OleInitialize Lib "OLE32.DLL" (pvReserved As Any)
Private Declare PtrSafe Sub CoTaskMemFree Lib "OLE32.DLL" (ByVal hMem As LongPtr)
Private Declare PtrSafe Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal HWND As LongPtr, ByVal wMsg As Long, ByVal wParam As LongPtr, ByVal lParam As Any) As LongPtr
Private Declare PtrSafe Function IsWindow Lib "user32" (ByVal HWND As LongPtr) As Long
Private Declare PtrSafe Function RedrawWindow Lib "user32" (ByVal HWND As LongPtr, lprcUpdate As Any, ByVal hrgnUpdate As LongPtr, ByVal fuRedraw As Long) As Long
Private Declare PtrSafe Function FindWindowStr Lib "user32" Alias "FindWindowA" (ByVal ClassName As String, ByVal WndName As String) As LongPtr
Private Declare PtrSafe Function GetUserDefaultLCID Lib "kernel32" () As Long
Private Declare PtrSafe Function GetProfileString Lib "kernel32" Alias "GetProfileStringA" (ByVal lpAppName As String, ByVal lpKeyName As String, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long) As Long
Private Declare PtrSafe Function OleTranslateColor Lib "OLEAUT32.DLL" (ByVal OLE_COLOR As Long, ByVal HPALETTE As LongPtr, pccolorref As Long) As Long
Private Declare PtrSafe Function CoCreateGuid Lib "OLE32.DLL" (pGuid As GUID) As Long
Private Declare PtrSafe Function StringFromGUID2 Lib "OLE32.DLL" (pGuid As GUID, ByVal PointerToString As LongPtr, ByVal MaxLength As Long) As Long
Private Declare PtrSafe Function HtmlHelp Lib "hhctrl.ocx" Alias "HtmlHelpA" (ByVal hwndCaller As LongPtr, ByVal pszFile As String, ByVal uCommand As Long, ByVal dwData As LongPtr) As LongPtr
Private Declare PtrSafe Function SHGetSpecialFolderLocation Lib "shell32.dll" (ByVal hWndOwner As LongPtr, ByVal nFolder As Long, pidl As ITEMIDLIST) As Long
Private Declare PtrSafe Function SHBrowseForFolder Lib "shell32.dll" (lpbi As BROWSEINFO) As Long
Private Declare PtrSafe Function SHGetFolderPath Lib "shfolder" Alias "SHGetFolderPathA" (ByVal hWndOwner As LongPtr, ByVal nFolder As Long, ByVal hToken As LongPtr, ByVal dwFlags As Long, ByVal pszPath As String) As LongPtr
Private Declare PtrSafe Function PathIsDirectory Lib "shlwapi.dll" Alias "PathIsDirectoryA" (ByVal pszPath As String) As Long
Private Declare PtrSafe Function SHParseDisplayName Lib "shell32.dll" (ByVal pszName As LongPtr, ByVal pbc As LongPtr, ByRef ppidl As Long, ByVal sfgaoIn As Long, ByRef psfgaoOut As LongPtr) As Long
Private Declare PtrSafe Function SHGetPathFromIDList Lib "shell32.dll" (ByVal pidList As LongPtr, ByVal lpBuffer As String) As Long
Private Declare PtrSafe Function GetWindowRect Lib "user32" (ByVal HWND As LongPtr, lpRect As RECT) As Long
Private Declare PtrSafe Function GetParent Lib "user32" (ByVal HWND As LongPtr) As LongPtr
Private Declare PtrSafe Function GetDesktopWindow Lib "user32" () As LongPtr
Private Declare PtrSafe Function MoveWindow Lib "user32" (ByVal HWND As LongPtr, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal bRepaint As Long) As Long

Private m_sCurrentDir                       As String
'

Public Sub g_SetAccelerators(Frm As UserForm, Optional nFontSize As Single = 8, Optional bClearTipText As Boolean = False, Optional vSkipTag As Variant = Empty)
            
        Dim objCtl                  As Control
        Dim objPage                 As Page
        Dim strCaption              As String
    
On Error Resume Next
    
        For Each objCtl In Frm.Controls
                                
                If TypeOf objCtl Is MultiPage Then
                        
                        For Each objPage In objCtl.Pages
                                                                        
                                strCaption = objPage.Caption
                
                                If (Err.Number = 0) Then
                                        If Not mb_SkipAccelerator(objPage, vSkipTag) Then Call g_SetAccelerator(objPage)
                                Else
                                        Call Err.Clear
                                End If
                        
                        Next objPage
                
                Else
                                        
                        strCaption = objCtl.Caption
                                        
                        If (Err.Number = 0) Then
                                If Not mb_SkipAccelerator(objCtl, vSkipTag) Then Call g_SetAccelerator(objCtl)
                        Else
                                Call Err.Clear
                        End If
                
                End If

                objCtl.SelectionMargin = False

                If (Err.Number <> 0) Then Call Err.Clear

                Call g_SetCharset(objCtl.Font, nFontSize)
                
                If (Err.Number <> 0) Then Call Err.Clear
                
                If bClearTipText Then
                        objCtl.ControlTipText = vbNullString
                        If (Err.Number <> 0) Then Call Err.Clear
                End If

        Next objCtl
    
Controlled_Exit:

Exit Sub
    
End Sub

Private Function mb_SkipAccelerator(Ctl As Object, ByVal vSkipTag As Variant) As Boolean

        Dim blnRet                  As Boolean
        
On Error GoTo ErrTrap
        
        blnRet = False
        
        If Not IsEmpty(vSkipTag) Then
                blnRet = (StrComp(Ctl.Tag, CStr(vSkipTag), vbTextCompare) = 0)
        End If

Controlled_Exit:
        
        If (Err.Number <> 0) Then Call Err.Clear
        
        mb_SkipAccelerator = blnRet
        
Exit Function
        
ErrTrap:
        
        blnRet = False
        Resume Controlled_Exit

End Function

Public Sub g_SetAccelerator(Ctl As Object)
        
        Dim intAcc                  As Integer
        Dim strAcc                  As String
        Dim strRet                  As String
                
        strRet = Ctl.Caption
        
        intAcc = InStr(strRet, "&")

        If (intAcc > 0) Then

                strAcc = Mid$(strRet, (intAcc + 1), 1)
                strRet = Left$(strRet, (intAcc - 1)) & Right$(strRet, (Len(strRet) - intAcc))

                If (strAcc <> "&") Then Ctl.Accelerator = strAcc

        End If
        
        Ctl.Caption = strRet
                
        If (Err.Number <> 0) Then Err.Clear
        
End Sub

Public Sub g_SetCharset(oFont As Object, ByVal nFontSize As Single)
        
        Dim lngLCID                 As Long

On Error GoTo ErrTrap
        
        lngLCID = GetUserDefaultLCID
    
        Select Case lngLCID
                        
                Case CHINESETRADITIONAL_LCID
                        
                        oFont.Charset = CHINESEBIG5_CHARSET
                        oFont.name = ChrW$(&H65B0) + ChrW$(&H7D30) + _
                                     ChrW$(&H660E) + ChrW$(&H9AD4)   'New Ming-Li
                        oFont.Size = 9
                
                Case CHINESESIMPLIFIED_LCID
                        
                        oFont.Charset = CHINESESIMPLIFIED_CHARSET
                        oFont.name = ChrW$(&H5B8B) + ChrW$(&H4F53)
                        oFont.Size = 9
                
                Case JAPANESE_LCID
                        
                        oFont.Charset = SHIFTJIS_CHARSET
                        oFont.name = ChrW$(&HFF2D) + ChrW$(&HFF33) + ChrW$(&H20) + _
                                     ChrW$(&HFF30) + ChrW$(&H30B4) + ChrW$(&H30B7) + _
                                     ChrW$(&H30C3) + ChrW$(&H30AF)
                        oFont.Size = 9
                
                Case KOREAN_LCID
                        
                        oFont.Charset = HANGEUL_CHARSET
                        oFont.name = ChrW$(&HAD74) + ChrW(&HB9BC)
                        oFont.Size = 9
                
                Case HEBREW_LCID
                        
                        oFont.Charset = HEBREW_CHARSET
                        oFont.Size = nFontSize
                        
                Case Else   ' Others
                
                        ' 11 aug 11 TFS#45626
                        '
                        oFont.Charset = DEFAULT_CHARSET
                        oFont.Size = nFontSize
                        
                        ' DON'T DO THIS! will crash if ComboBox
                        '
                        'Obj.Name = vbnullstring   ' Get the default UI font.
                                                        
            End Select

Controlled_Exit:

Exit Sub
    
ErrTrap:
        
        Call Err.Clear
        Resume Controlled_Exit
    
End Sub

Public Sub g_SetCaption(Ctl As Control, ByVal sCaption As String)
        
On Error Resume Next
        
        If (Ctl Is Nothing) Then Exit Sub
        
        Ctl.Caption = sCaption
        
        Call g_SetAccelerator(Ctl)
        Call g_SetCharset(Ctl.Font, Ctl.Font.Size)

End Sub

Public Function gs_GetRegionalSetting(ByVal lSetting As SystemRegionalSetting) As String
    
        Dim strSecName              As String
        Dim strKey                  As String
        Dim strRetString            As String * 256
        Dim lngSuccess              As Long
        Dim strRet                  As String
    
On Error GoTo ErrTrap
        
        Select Case lSetting
                Case RegionalSetting_DATE_SEPARATOR: strKey = "sDate"
                Case RegionalSetting_DECIMAL_SYMBOL: strKey = "sDecimal"
                Case RegionalSetting_SHORT_DATE: strKey = "sShortDate"
                Case RegionalSetting_LONG_DATE: strKey = "sLongDate"
                Case RegionalSetting_CURRENCY_CODE: strKey = "sCurrency"
                Case RegionalSetting_COUNTRY: strKey = "sCountry"
                Case RegionalSetting_THOUSAND_SEPARATOR: strKey = "sThousand"
                Case RegionalSetting_TIME_SEPARATOR: strKey = "sTime"
                Case RegionalSetting_LIST_SEPARATOR: strKey = "sList"
        End Select
        
        strRet = vbNullString
        
        strSecName = "Intl"
        
        lngSuccess = GetProfileString(strSecName, strKey, vbNullString, strRetString, Len(strRetString))
        
        If (lngSuccess <> 0) Then
                strRet = Left$(strRetString, InStr(strRetString, Chr$(0)) - 1)
        End If

Controlled_Exit:
        
        gs_GetRegionalSetting = strRet

Exit Function

ErrTrap:
        
        MsgBox Err.Description, vbExclamation
        strRet = vbNullString
        Resume Controlled_Exit
        
End Function

Public Sub g_UnLoadAllForms(Optional ByVal bEnd As Boolean = False)

        Dim Frm                     As UserForm
    
On Error Resume Next
        
        ' loop thru all the forms in the project
        For Each Frm In VBA.UserForms
        
                Frm.Hide
                Call Unload(Frm)
                Set Frm = Nothing
               
                If (Err.Number <> 0) Then Err.Clear
                
        Next Frm
        
        'Call g_Redraw
        DoEvents

        ' hard end if needed
        If bEnd Then End

End Sub

Public Sub g_Eval(oTB As TextBox, bCancel As MSForms.ReturnBoolean, _
                  Optional ByVal bAllowNeg As Boolean = True, Optional ByVal bUseTag As Boolean = False)
                    
        Dim dblX                    As Double
        Dim strX                    As String

On Error GoTo ErrTrap

        ' start out cool
        bCancel = False
    
        With oTB
    
                If (Len(Trim$(.Text)) = 0) Then Exit Sub
                If (.SelLength > 0) Then Exit Sub
        
                dblX = App.Frame.Evaluate(gs_NoComma(.Text))
                
                If Not bAllowNeg Then dblX = Abs(dblX)
                
                strX = Format$(CStr(dblX), "#0.0000")
                
                ' 07/15/08 - rg
                '
                If bUseTag Then .Tag = dblX
                
                .Text = gs_NoZeros(gs_NoComma(strX))
                .SelStart = 0
    
        End With
    
Controlled_Exit:

Exit Sub

ErrTrap:

        MsgBox Err.Description, vbInformation
        bCancel = True
        
        With oTB
                .SetFocus
                .SelStart = 0
        End With
    
        Resume Controlled_Exit

End Sub

Public Sub g_EvalInt(oTB As TextBox, bCancel As MSForms.ReturnBoolean, ByVal bAllowNeg As Boolean)
        
        Call g_Eval(oTB, bCancel)
        
        ' if ok then convert to integer
        If Not bCancel Then
                With oTB
                        If bAllowNeg Then
                                .Text = CInt(.Text)
                        Else
                                .Text = Abs(CInt(.Text))
                        End If
                End With
        End If

Controlled_Exit:

Exit Sub

End Sub

Public Sub g_EvalS(ByVal sVal As String, sReturn As String, Cancel As Boolean)

        Dim X                       As Double
    
        If (Len(Trim$(sVal)) = 0) Then sVal = "0"

On Error GoTo ErrTrap

        X = App.Frame.Evaluate(gs_NoComma(sVal))
        sReturn = Format$(X, "#0.0###")
        sReturn = gs_NoZeros(sReturn)

Exit Sub

ErrTrap:

        Cancel = True
        MsgBox Err.Description, vbExclamation
        
End Sub

Public Sub g_EvalSLng(ByVal sVal As String, sReturn As String, Cancel As Boolean)

        Dim X                       As Double
    
        If (Len(Trim$(sVal)) = 0) Then sVal = "0"

On Error GoTo ErrTrap

        X = App.Frame.Evaluate(gs_NoComma(sVal))
        sReturn = CStr(CLng(X))
        
Exit Sub

ErrTrap:

        Cancel = True
        MsgBox Err.Description, vbExclamation
        
End Sub

Public Sub g_EvalGrid(ByVal sVal As String, vReturn As Variant, Cancel As Boolean)

        Dim X                       As Double
        Dim strRet                  As String

        If (Len(Trim$(sVal)) = 0) Then sVal = "0"

On Error GoTo ErrTrap

        X = App.Frame.Evaluate(gs_NoComma(sVal))
        strRet = Format$(X, "#0.00000")
        strRet = gs_NoZeros(strRet)

        vReturn = strRet

Exit Sub

ErrTrap:

        Cancel = True
        MsgBox Err.Description, vbExclamation, DEF_APP_TITLE

End Sub

Public Sub g_EvalGridLng(ByVal sVal As String, vReturn As Variant, Cancel As Boolean)

        Dim X                       As Double
        Dim strRet                  As String

        If (Len(Trim$(sVal)) = 0) Then sVal = "0"

On Error GoTo ErrTrap

        X = App.Frame.Evaluate(gs_NoComma(sVal))
        strRet = CStr(CLng(X))

        vReturn = strRet

Exit Sub

ErrTrap:

        Cancel = True
        MsgBox Err.Description, vbExclamation, DEF_APP_TITLE

End Sub

Public Function gb_IsValOK(ByVal sVal As String, Optional ByVal bDecimal As Boolean = False, Optional ByVal bNegative As Boolean = False) As Boolean

        Dim strValidChars           As String
        Dim strChar                 As String
        Dim i                       As Integer
        Dim intMax                  As Integer
        Dim intDec                  As Integer
        Dim intNeg                  As Integer

        ' assign chars
        strValidChars = "0123456789"
        intNeg = 0
        intDec = 0

        ' assume success
        gb_IsValOK = True
        
        ' allow decimal?
        If bDecimal Then strValidChars = strValidChars & "."
           
        ' allow negative
        If bNegative Then strValidChars = strValidChars & "-"
           
        intMax = Len(sVal)
        
        ' loop string
        For i = 1 To intMax
            
                ' get a char
                strChar = Mid$(sVal, i, 1)
               
                If strChar = "." Then intDec = (intDec + 1)
                If strChar = "-" Then intNeg = (intNeg + 1)
                
                Select Case True
                
                        Case (InStr(1, strValidChars, strChar) = 0), (intDec > 1), (intNeg > 1)
                                gb_IsValOK = False
                                Exit Function
                End Select
            
        Next i

End Function

Public Function gb_CheckAllText(Container As Object) As Boolean
        
        Dim Ctl                     As Control
        
        'start out cool
        gb_CheckAllText = True
        
        'check for empty text boxes and warn user if any
        For Each Ctl In Container.Controls
        
                If TypeOf Ctl Is TextBox Then
                        
                        If (Ctl.Tag <> "999") Then
                        
                                ' check for empty if enabled
                                If Ctl.Enabled Then
                                        If (Len(Trim$(Ctl.Text)) = 0) Then
                                                MsgBox "Please complete all information." & Space$(3), vbInformation, App.name
                                                Ctl.SetFocus
                                                gb_CheckAllText = False
                                                Exit For
                                        End If
                                End If
                        
                        End If
                        
                End If
                
        Next Ctl
        
        Set Ctl = Nothing

Exit Function

End Function

Public Function go_DelimitedStringToCollection(ByVal sSubItems As String, Optional ByVal sDelimitChar As String = ",", Optional ByVal bIncludeNulls As Boolean = False) As Collection

        Dim strLen                  As Long
        Dim i                       As Long
        Dim J                       As Long
        Dim lngDelLen               As Long
        Dim strTemp                 As String
        Dim strRet                  As String
        Dim colRet                  As Collection
        
        ' Delimits a string, using the specified character(s) or the default
        ' comma, and returns a collection of strings
        
        Set colRet = New Collection
  
        If (sSubItems = vbNullString) Then
                If bIncludeNulls Then
                        Call colRet.Add(vbNullString)
                        GoTo Controlled_Exit
                End If
        End If
        
        lngDelLen = Len(sDelimitChar)
        
        If (Right$(sSubItems, 1) <> sDelimitChar) Then
                strTemp = sSubItems & sDelimitChar
        Else
                strTemp = sSubItems
        End If
  
        strLen = Len(strTemp)
  
        J = 1
        i = 1
  
        While (J < strLen) And (J > 0)
                
                J = InStr(i, strTemp, sDelimitChar)
                
                If ((i * J) > 0) Then
      
                        strRet = Trim$(Mid$(strTemp, i, J - i))
                        
                        If (strRet <> vbNullString) Then
                                Call colRet.Add(strRet)
                        Else
                                If (strRet = vbNullString) Then
                                        If bIncludeNulls Then Call colRet.Add(strRet)
                                End If
                        End If
                        
                End If
                
                i = (J + lngDelLen)
                
        Wend
        
Controlled_Exit:
        
        Set go_DelimitedStringToCollection = colRet
        
        Set colRet = Nothing
        
Exit Function
  
End Function

Public Function gv_Split(ByVal sString As String, Optional ByVal sDelimeter As String = ",", Optional ByVal bBase1 As Boolean = False) As Variant

        Dim strSDelim               As String
        Dim strString               As String
        Dim intIStringLength        As Integer
        Dim intIDelimPosition       As Integer
        Dim strSDoubleQuoteMark     As String
        Dim intIIndex               As Integer
        Dim arystrAData1()          As String
        Dim strSDatafield           As String
        
        strString = sString
        strSDelim = sDelimeter
        strSDoubleQuoteMark = Chr$(34)
        intIStringLength = Len(strString)
        
        intIIndex = IIf(bBase1, 1, 0)
        
        ' if the length of the data string is greater than zero
        If (intIStringLength > 0) Then
        
                'Debug.Print strString
        
                ' search for a sDelimiter in the datastring
                intIDelimPosition = InStr(strString, strSDelim)
                
                Do While (intIDelimPosition <> 0)
                
                        ' snag the datafield
                        strSDatafield = Trim$(Left$(strString, (intIDelimPosition - 1)))
                        
                        ' look for and remove leading/trailing quotes,
                        ' leave if only one or the other or within the string
                        If (Left$(strSDatafield, 1) = strSDoubleQuoteMark) Then
                                
                                If (Right$(strSDatafield, 1) = strSDoubleQuoteMark) Then
                                        strSDatafield = Left$(strSDatafield, (Len(strSDatafield) - 1))
                                        strSDatafield = Right$(strSDatafield, (Len(strSDatafield) - 1))
                                End If
                        
                        End If

                        ' sort out the rest of the string
                        strString = Right$(strString, (Len(strString) - intIDelimPosition))
                                                                
                        ReDim Preserve arystrAData1(intIIndex)
                        arystrAData1(intIIndex) = strSDatafield
                        intIDelimPosition = InStr(strString, strSDelim)
                        
                        intIIndex = (intIIndex + 1)
                        
                Loop
                
                'iIndex = iIndex + 1
                ReDim Preserve arystrAData1(intIIndex)
                arystrAData1(intIIndex) = strString
                
        End If
        
        gv_Split = arystrAData1
        
End Function

Public Function gs_NoComma(ByVal sVal As String) As String

        ' this function is designed to replace the comma in the German
        ' numbering system with a decimal point as needed by Alphacam

        Dim strRet                  As String
        
On Error GoTo ErrTrap
        
        strRet = Replace$(sVal, ",", ".")
        
Controlled_Exit:
        
        gs_NoComma = strRet

Exit Function

ErrTrap:
        
        strRet = sVal
        Resume Controlled_Exit

End Function

Public Function gs_ReplaceSpaces(ByVal sVal As String, Optional ByVal sChr As String = "_")
        
        Dim strRet                  As String
        
        strRet = Replace$(sVal, Space$(1), sChr)
        
        gs_ReplaceSpaces = strRet

End Function

Public Function gs_RemoveIllegalChars(ByVal sVal As String, ByVal bReplaceDecWithP As Boolean, Optional ByVal sChr As String = "_") As String

        Dim i                       As Integer
        Dim intMax                  As Integer
        Dim strChar                 As String
        Dim strRet                  As String

On Error GoTo ErrTrap
        
        Const DEF_ILLEGAL           As String = "\/:*?<>|"""
        
        ' set default return val
        strRet = vbNullString
        
        sVal = Trim$(sVal)
        intMax = Len(sVal)
                
        If (intMax > 0) Then
        
                For i = 1 To intMax
                
                        strChar = Mid$(sVal, i, 1)
                        
                        If InStr(DEF_ILLEGAL, strChar) > 0 Then
                                strChar = sChr
                                strRet = strRet & strChar
                        Else
                                If bReplaceDecWithP Then
                                        If (strChar = ".") Then
                                                strRet = strRet & "P"
                                        Else
                                                strRet = strRet & strChar
                                        End If
                                Else
                                        strRet = strRet & strChar
                                End If
                        End If
                    
                Next i
        
        End If
                                    
Controlled_Exit:

        gs_RemoveIllegalChars = strRet

Exit Function

ErrTrap:
    
        MsgBox Err.Description, vbExclamation
        strRet = sVal
        Resume Controlled_Exit
    
End Function

Public Function gs_RemoveNullChars(ByVal sVal As String) As String
        gs_RemoveNullChars = Replace$(sVal, Chr$(0), vbNullString)
End Function

Public Function gs_DateToString(ByVal dtNow As Date) As String
        gs_DateToString = Trim$(str$(Year(dtNow))) + Trim$(str$(Month(dtNow))) + Trim$(str$(Day(dtNow)))
End Function

Public Function gs_AddQuotes(ByVal S As String) As String
        gs_AddQuotes = Chr$(34) & S & Chr$(34)
End Function

Public Function gs_TruncateText(ByVal sText As String, ByVal lControlWidth As Long) As String
        
        Dim strText                 As String
        Dim strLeft                 As String
        Dim strRight                As String
        Dim lngMid                  As Long
        Dim lngLen                  As Long
        Dim lngTrimR                As Long
        Dim lngTrimL                As Long
        Dim lngBackSlash            As Long
        Dim lngMax                  As Long
        
        Const DEF_ELLIPSE           As String = "..."
        
On Error Resume Next
        
        ' init
        gs_TruncateText = sText
                        
        ' get the overall length and the middle char
        strText = sText
        lngLen = Len(strText)
        lngMax = ((lControlWidth * 0.25) - 7)
        
        If (lngLen >= lngMax) Then
                                
                ' we'll look for a backslash in hopes to leave the entire
                ' file/folder name visible if tuncating a file/folder path
                lngBackSlash = InStrRev(strText, "\")

                If (lngBackSlash > 0) Then
                        lngMid = (lngBackSlash - 1)
                        lngTrimL = (lngLen - lngMax)
                        lngTrimR = 0
                Else
                        lngMid = (lngLen / 2)
                        lngTrimL = ((lngLen - lngMax) / 2)
                        lngTrimR = lngTrimL
                End If
                
                'Debug.Print "MID: " & lngMid & " ~ TRIM_L: " & lngTrimL & " ~ TRIM_R: " & lngTrimR
                
                strLeft = Left$(strText, lngMid)
                strRight = Right$(strText, (lngLen - lngMid))
                
                strLeft = Left$(strLeft, (Len(strLeft) - lngTrimL))
                strLeft = Left$(strLeft, (Len(strLeft) - 3))
                strRight = Right$(strRight, (Len(strRight) - lngTrimR))
                
                'Debug.Print "LEFT: " & strLeft & " ~ RIGHT: " & strRight
                
                strText = strLeft & DEF_ELLIPSE & strRight

        End If

        'Debug.Print "MAX: " & lMaxWidth & " ~ ACTUAL: " & Len(strText)
                
        gs_TruncateText = strText

Exit Function

End Function

Public Function gs_SetWaitText(ByVal sText As String) As String
        
        Dim strRet                  As String
        
        strRet = sText
        
        If (Right$(strRet, 3) <> "...") Then strRet = strRet & "..."
        
        gs_SetWaitText = strRet
        
End Function

Public Sub g_EnableDisableControls(oContainer As Object, ByVal bEnable As Boolean, ByVal bIncludeContainer As Boolean)
        
        Dim Ctl                     As Control
        
On Error Resume Next
        
        For Each Ctl In oContainer.Controls
                
                Ctl.Enabled = bEnable
                
                If (Err.Number <> 0) Then Err.Clear
        
        Next Ctl
        
        If bIncludeContainer Then oContainer.Enabled = bEnable
        If (Err.Number <> 0) Then Err.Clear
                        
        Set Ctl = Nothing

End Sub

Public Sub g_Repaint(Frm As UserForm)
        
        Dim lngRet                  As Long
        Dim lngHwnd                 As Long
        
        lngHwnd = gl_FrmHwnd(Frm)
        
        If (IsWindow(lngHwnd) = 0) Then Exit Sub
        
        ' redraw the userform
        lngRet = RedrawWindow(lngHwnd, ByVal 0&, ByVal 0&, RDW_INVALIDATE)
    
End Sub

Public Function gb_IsInCollection(c As Collection, ByVal V As Variant) As Boolean

On Error GoTo ErrTrap
        
        ' simple check - will raise error if item does not exist in collection
        With c(V)
        End With
  
        gb_IsInCollection = True
  
Exit Function
  
ErrTrap:

        gb_IsInCollection = False
        
End Function

Public Function gv_NoNullFromCollection(oCol As Collection, ByVal vIndexOrKey As Variant, ByVal vDefault As Variant) As Variant
        
        Dim varRet                  As Variant
        
On Error GoTo ErrTrap

        varRet = oCol(vIndexOrKey)

Controlled_Exit:

        gv_NoNullFromCollection = varRet

Exit Function
        
ErrTrap:
        
        varRet = vDefault
        Resume Controlled_Exit

End Function

Public Sub g_GetArrayBounds(vArray As Variant, lL As Long, lU As Long)
                
        Dim lngL                    As Long
        Dim lngU                    As Long
        
On Error GoTo ErrTrap
        
        lngL = LBound(vArray)
        lngU = UBound(vArray)
        
Controlled_Exit:

        lL = lngL
        lU = lngU
        
Exit Sub

ErrTrap:
        
        Err.Clear
        lngL = 0
        lngU = -1                   ' set to -1 to avoid loop in for-next
        Resume Controlled_Exit

End Sub

Public Function gl_FrmHwnd(ByRef Frm As Object) As Variant
    
        Dim vRet                    As Variant

On Error GoTo ErrTrap
        
        ' Assume handle will not be found.
        vRet = 0
        
        ' First check for form under Visual Basic for
        ' Applications 6.0 or Visual Basic 5.0/6.0 IDEs.
        vRet = FindWindowStr("ThunderDFrame", Frm.Caption)
        
        ' If handle is not found then keep looking
        If (vRet = 0) Then
        
                ' Check for form under Visual Basic for Applications 5.0 IDE.
                vRet = FindWindowStr("ThunderXFrame", Frm.Caption)
                
                ' If handle is not found--
                If (vRet = 0) Then
                
                        ' Check for form compiled from MSForms
                        ' object library dated 3/22/99 or later.
                        vRet = FindWindowStr("ThunderRT6DFrame", Frm.Caption)
                        
                        ' If handle is not found--
                        If (vRet = 0) Then
                                ' Check for form compiled from initial
                                ' version of MSForms object library.
                                vRet = FindWindowStr("ThunderRT5DFrame", Frm.Caption)
                        End If
                        
                End If
                
        End If
   
ErrTrap:
        
        If Err Then vRet = CVErr(Err)
        gl_FrmHwnd = vRet
   
End Function

Public Function gs_NoZeros(ByVal sVal As String) As String
        
        Dim strVal                  As String
        
On Error Resume Next
        
        strVal = gs_NoComma(sVal)
        
        If (InStr(strVal, ".") > 0) Then
        
                Do While Right$(strVal, 1) = "0"
                        strVal = Left$(strVal, Len(strVal) - 1)
                Loop
                
                If Right$(strVal, 1) = "." Then
                        strVal = Left$(strVal, Len(strVal) - 1)
                End If
                
                If (Len(Trim$(strVal)) = 0) Then strVal = "0"
                
        End If

        gs_NoZeros = strVal
    
Controlled_Exit:

Exit Function
        
End Function

Public Function gs_RemovePointFromZero(ByVal sVal As String) As String
        
        Dim strRet                  As String
        
        strRet = sVal
        
        If (PDbl(sVal) = 0) Then strRet = "0"
        
        gs_RemovePointFromZero = strRet
        
End Function

Public Function gs_RemoveAmpersand(ByVal sString As String) As String
        
        Dim lngPosn                 As Long
        Dim strRet                  As String
        
        strRet = sString
        
        Do
                
                lngPosn = InStr(1, strRet, "&")
                
                If (lngPosn > 0) Then
                        strRet = Left$(strRet, (lngPosn - 1)) & Right$(strRet, (Len(strRet) - lngPosn))
                End If
                
        Loop While (lngPosn > 0)
                
        gs_RemoveAmpersand = strRet
            
End Function

Public Function gs_StripCR(ByVal S As String) As String
        
        Dim dblLen                  As Double
        Dim strRet                  As String
        
        dblLen = Len(Trim$(S))
        strRet = S

        If CBool(dblLen) Then
                If (Right$(strRet, 1) = Chr$(10)) Then
                        strRet = Left$(strRet, (dblLen - 2))
                End If
        End If

        gs_StripCR = strRet

End Function

Public Function gs_StripLF(ByVal sVal As String) As String

        Dim sRet                    As String
        
        sRet = sVal
        
        Do While (Right$(sRet, 1) = Chr$(10))
                sRet = Left$(sRet, (Len(Trim$(sRet)) - 1))
        Loop

        gs_StripLF = sRet

End Function

Public Function gs_StripCRLF(ByVal S As String) As String

        Dim strRet                  As String
        
        strRet = S
        strRet = Trim$(Replace$(strRet, vbCr, vbNullString))
        strRet = Trim$(Replace$(strRet, vbLf, vbNullString))
        
        gs_StripCRLF = strRet

End Function

Public Function gs_GUID() As String
 
        Dim udtGUID                 As GUID
        Dim lngResult               As Long
        Dim strRet                  As String
  
        Const GUID_LENGTH           As Long = 38

        lngResult = CoCreateGuid(udtGUID)

        If (lngResult = GUID_OK) Then
                strRet = String$(GUID_LENGTH, 0)
                lngResult = StringFromGUID2(udtGUID, StrPtr(strRet), (GUID_LENGTH + 1))
        Else
                strRet = vbNullString
        End If
        
        gs_GUID = strRet
        
End Function

Public Function gl_BinaryValue(ByVal lNumber As Long, Optional ByVal lBinary As Long = 0) As Long

        Dim lngRet                  As Long
        Dim dblCheck                As Double

        Const DEF_MAX_VAL           As Long = 2147483647

On Error GoTo ErrTrap

        dblCheck = (2 ^ (lNumber - 1))

        ' prevent potential overflow
        Select Case True

                Case (dblCheck > DEF_MAX_VAL), _
                     ((dblCheck + lBinary) > DEF_MAX_VAL)

                        lngRet = 0

                Case Else

                        lngRet = CLng(dblCheck)

        End Select

Controlled_Exit:

        gl_BinaryValue = lngRet

Exit Function

ErrTrap:

        lngRet = 0
        Resume Controlled_Exit

End Function

Public Function gl_TranslateColor(ByVal clr As OLE_COLOR, Optional hPal As Long = 0) As Long
        If OleTranslateColor(clr, hPal, gl_TranslateColor) Then gl_TranslateColor = CLR_INVALID
End Function

Public Sub g_Help(ByVal sCHM As String, Optional ByVal lIndex As Long = 0)
                
        Dim FSO                     As New Scripting.FileSystemObject
        Dim lngPtrRet               As LongPtr
        
        ' if invalid file, then bail
        If Not FSO.FileExists(sCHM) Then Exit Sub
        
        If (lIndex <> 0) Then
                
                ' try to launch context
                lngPtrRet = HtmlHelp(0, sCHM, HH_HELP_CONTEXT, lIndex)

                ' if context failed, then simply launch the main topic
                If (lngPtrRet = 0) Then
                        lngPtrRet = HtmlHelp(0, sCHM, HH_DISPLAY_TOPIC, 0)
                End If
                
        Else
                lngPtrRet = HtmlHelp(0, sCHM, HH_DISPLAY_TOPIC, 0)
        End If

End Sub

Public Function gs_ReadFileContents(ByVal sFile As String) As String
        
        Dim FSO                     As Scripting.FileSystemObject
        Dim strRet                  As String
        
On Error GoTo ErrTrap
        
        Set FSO = New Scripting.FileSystemObject
        
        strRet = vbNullString
        
        If FSO.FileExists(sFile) Then
                strRet = FSO.GetFile(sFile).OpenAsTextStream.ReadAll
        End If
        
Controlled_Exit:

        gs_ReadFileContents = strRet
        
        Set FSO = Nothing
        
Exit Function

ErrTrap:
        
        strRet = vbNullString
        MsgBox Err.Description, vbExclamation, App.name
        Resume Controlled_Exit
        
End Function

Public Function gs_EnsureBackslash(ByVal sPath As String) As String
        
        Dim strRet                  As String
        
        strRet = sPath
        
        If (Right$(sPath, 1) <> "\") Then strRet = sPath & "\"
        
        gs_EnsureBackslash = strRet

End Function

Public Function gs_StripLeadingBackslash(ByVal sPath As String) As String
        
        Dim strRet                  As String
        
        strRet = sPath
        
        Do While (Left$(strRet, 1) = "\")
                strRet = Right$(strRet, (Len(strRet) - 1))
        Loop
        
        gs_StripLeadingBackslash = strRet

End Function

Public Function gs_ParseFileName(ByVal sPath As String, ByVal bStripExtension As Boolean) As String
  
        Dim strRet                  As String
        Dim intX                    As Integer
        
        intX = InStrRev(sPath, "\")
        
        strRet = Trim$(Right$(sPath, Len(sPath) - intX))
        
        If bStripExtension Then strRet = gs_StripFileExtension(strRet)

        If (Right$(strRet, 1) = Chr$(0)) Then
                strRet = Left$(strRet, (Len(strRet) - 1))
        End If

Controlled_Exit:
        
        gs_ParseFileName = strRet
        
Exit Function

End Function

Public Function gs_ParseDirName(ByVal sPath As String, ByVal bIncludeBackslash As Boolean) As String
  
        Dim strRet                  As String
        Dim intX                    As Integer
        
        strRet = Trim$(sPath)
        
        If (Len(Trim$(strRet)) > 0) Then
        
              intX = InStrRev(sPath, "\")
              
                If (intX > 0) Then
              
                        strRet = Trim$(Left$(sPath, (intX - 1)))
                      
                        If (Left$(strRet, 1) = Chr$(0)) Then
                                strRet = Left$(strRet, (Len(strRet) - 1))
                        End If
                
                        If bIncludeBackslash Then strRet = gs_EnsureBackslash(strRet)
                
                End If
        
        End If
        
Controlled_Exit:

        gs_ParseDirName = strRet

Exit Function

End Function

Public Function gs_ParseFileOrDirName(ByVal sPath As String, ByVal bStripExtension As Boolean) As String
        gs_ParseFileOrDirName = gs_ParseFileName(sPath, bStripExtension)
End Function

Public Function gs_ParseFileExtension(ByVal sFullPath As String, ByVal bIncludePoint As Boolean) As String
    
        Dim intPoint                As Integer
        Dim strRet                  As String
        
        strRet = vbNullString
        
        intPoint = InStrRev(sFullPath, ".")
        
        If (intPoint > 0) Then
        
                If bIncludePoint Then
                        strRet = UCase$(Right$(sFullPath, ((Len(sFullPath) - intPoint) + 1)))
                Else
                        strRet = UCase$(Right$(sFullPath, (Len(sFullPath) - intPoint)))
                End If
                
        End If
        
Controlled_Exit:

        gs_ParseFileExtension = strRet

Exit Function

End Function

Public Function gs_StripFileExtension(ByVal sFile As String) As String
        
        Dim strRet                  As String
        Dim intPoint                As Integer
        
        ' set default return val
        strRet = sFile
        
        intPoint = InStrRev(sFile, ".")
        
        If (intPoint > 0) Then
                strRet = Left$(sFile, (Len(sFile) - ((Len(sFile) - intPoint) + 1)))
        End If
        
Controlled_Exit:

        gs_StripFileExtension = strRet

Exit Function

End Function

Public Function gs_ReplaceFileExtension(ByVal sFile As String, ByVal sNewExt As String) As String
    
        Dim strRet                  As String
        
        strRet = gs_StripFileExtension(sFile)
        
        ' only add the new file extension if there is one
        If (Len(Trim$(sNewExt)) > 0) Then
                If (Left$(sNewExt, 1) = ".") Then
                        strRet = strRet & sNewExt
                Else
                        strRet = strRet & "." & sNewExt
                End If
        End If
               
Controlled_Exit:

        gs_ReplaceFileExtension = strRet

Exit Function

End Function

Public Function gs_GetLocalAppDataDir(Optional ByVal bIncludeBackslash As Boolean = True) As String
                
        Dim strPath                 As String
        Dim strRet                  As String

        ' this function will return the path to the users application data dir specific to this addin
        '
        ' e.g...
        '
        ' C:\Users\<USER_NAME>\AppData\Local\Planit\Alphacam\<NAME_OF_ADDIN>\
        
        strRet = gs_GetSpecialFolder(sysSpecialFolder_LocalApplicationData, True)
        
        ' set the name of the path we're after
        strPath = strRet & "Planit\Alphacam\" & DEF_PROJECT_NAME
        
        If gb_DirExists(strPath, True) Then strRet = strPath
        
        If bIncludeBackslash Then strRet = gs_EnsureBackslash(strPath)
        
Controlled_Exit:
                        
        gs_GetLocalAppDataDir = strRet

Exit Function
        
End Function

Public Function gs_GetCommonAppDataDir(Optional ByVal bIncludeBackslash As Boolean = True) As String
                
        Dim strPath                 As String
        Dim strRet                  As String

        ' this function will return the path to the common application data dir specific to this addin
        '
        ' e.g...
        '
        ' C:\ProgramData\Planit\Alphacam\<NAME_OF_ADDIN>\
        
        strRet = gs_GetSpecialFolder(sysSpecialFolder_CommonAppData, True)
        
        ' set the name of the path we're after
        strPath = strRet & "Planit\Alphacam\" & DEF_PROJECT_NAME
        
        If gb_DirExists(strPath, True) Then strRet = strPath
        
        If bIncludeBackslash Then strRet = gs_EnsureBackslash(strPath)
        
Controlled_Exit:
                        
        gs_GetCommonAppDataDir = strRet

Exit Function
        
End Function

Public Function gs_GetSpecialFolder(ByVal iSpecialFolder As SystemSpecialFolder, _
                                    Optional ByVal bCreate As Boolean = False, _
                                    Optional ByVal bIncludeBackslash As Boolean = True) As String
        
        Dim lngPtrRet               As LongPtr
        Dim strRet                  As String
        
        Const SHGFP_TYPE_CURRENT    As Long = 0
        Const SHGFP_TYPE_DEFAULT    As Long = 1
        Const MAX_PATH              As Long = 260
        Const CSIDL_FLAG_CREATE     As Long = &H8000&
        Const S_OK                  As Long = &H0           ' Success
        'Const S_FALSE               As Long = &H1           ' The Folder is valid, but does not exist
        'Const E_INVALIDARG          As Long = &H80070057    ' Invalid CSIDL Value
                
        strRet = String$(MAX_PATH, 0)
        
        If bCreate Then
                lngPtrRet = SHGetFolderPath(0, iSpecialFolder Or CSIDL_FLAG_CREATE, 0, SHGFP_TYPE_CURRENT, strRet)
        Else
                lngPtrRet = SHGetFolderPath(0, iSpecialFolder, 0, SHGFP_TYPE_CURRENT, strRet)
        End If
        
        If (lngPtrRet = S_OK) Then
                
                ' return the string upto the first null character
                strRet = Left$(strRet, InStr(1, strRet, Chr(0)) - 1)
        
                If bIncludeBackslash Then strRet = gs_EnsureBackslash(strRet)
                            
        End If
                
        gs_GetSpecialFolder = strRet
        
End Function

Public Function gs_GetTempFolder(Optional ByVal bIncludeBackslash As Boolean = True) As String
        
        Dim FSO                     As Scripting.FileSystemObject
        Dim strRet                  As String
        
        Set FSO = New Scripting.FileSystemObject
        
        strRet = FSO.GetSpecialFolder(2)
        
        If bIncludeBackslash Then strRet = gs_EnsureBackslash(strRet)
        
        gs_GetTempFolder = strRet
        
        Set FSO = Nothing
        
End Function

Public Function gs_GetTempFileName(Optional ByVal bStripExtension As Boolean = True) As String
        
        Dim FSO                     As Scripting.FileSystemObject
        Dim strRet                  As String
        
        Set FSO = New Scripting.FileSystemObject
        
        strRet = FSO.GetSpecialFolder(2)
        
        strRet = gs_EnsureBackslash(strRet) & FSO.GetTempName
        
        If bStripExtension Then strRet = gs_StripFileExtension(strRet)
        
        gs_GetTempFileName = strRet
        
        Set FSO = Nothing
        
End Function

Public Function gs_FileSize(ByVal sFile As String) As String
    
        Dim FSO                     As New Scripting.FileSystemObject
        Dim fsoFile                 As Scripting.File
        Dim dblBytes                As Double
        Dim strRet                  As String
        
        Const KB                    As Double = 1024
        Const MB                    As Double = KB * 1024
        Const GB                    As Double = MB * 1024
        Const TB                    As Double = GB * 1024
            
On Error Resume Next
        
        strRet = "0 bytes"
        
        ' if no file then bail
        If Not FSO.FileExists(sFile) Then GoTo Controlled_Exit
        
        Set fsoFile = FSO.GetFile(FSO.GetFile(sFile))
        
        dblBytes = fsoFile.Size
        
        ' format the number
        Select Case True
        
                Case (dblBytes < KB): strRet = Format$(dblBytes) & " bytes"
                Case (dblBytes < MB): strRet = Format$(dblBytes / KB, "0.00") & " KB"
                Case (dblBytes < GB): strRet = Format$(dblBytes / MB, "0.00") & " MB"
                Case Else: strRet = Format$(dblBytes / GB, "0.00") & " GB"
            
        End Select
        
Controlled_Exit:
        
        gs_FileSize = strRet
        
        Set fsoFile = Nothing
        Set FSO = Nothing

Exit Function

End Function

Public Function gs_GetDir(Optional ByVal sTitle As String = vbNullString, Optional ByVal sRootDir As String = vbNullString, _
                          Optional ByVal sStartDir As String = vbNullString, Optional lOwnerHwnd As Long = 0, _
                          Optional ByVal bAllowNew As Boolean = True, _
                          Optional ByVal bIncludeFiles As Boolean = False, _
                          Optional ByVal bOnlyMyComputer As Boolean = False) As String

        Dim lngIDList               As Long
        Dim lngIDList2              As Long
        Dim IDL                     As ITEMIDLIST
        Dim strBuffer               As String
        Dim BI                      As BROWSEINFO
        Dim lngRet                  As Long
        Dim strRet                  As String
                
        strRet = vbNullString
        
        If (Len(sRootDir) > 0) Then
        
                If PathIsDirectory(sRootDir) Then
                        lngRet = SHParseDisplayName(StrPtr(sRootDir), ByVal 0&, lngIDList2, ByVal 0&, ByVal 0&)
                        BI.pIDLRoot = lngIDList2
                Else
                        If bOnlyMyComputer Then
                                lngRet = SHGetSpecialFolderLocation(ByVal 0&, &H11, IDL)  '= Start @ "My Computer" Folder
                        Else
                                lngRet = SHGetSpecialFolderLocation(ByVal 0&, 0&, IDL)  ' = Start @ "Desktop" Folder
                        End If
                        If (lngRet = 0) Then BI.pIDLRoot = IDL.mkid.cb
                End If

        Else
                If bOnlyMyComputer Then
                        lngRet = SHGetSpecialFolderLocation(ByVal 0&, &H11, IDL)  '= Start @ "My Computer" Folder
                Else
                        lngRet = SHGetSpecialFolderLocation(ByVal 0&, 0&, IDL)  ' = Start @ "Desktop" Folder
                End If
                If (lngRet = 0) Then BI.pIDLRoot = IDL.mkid.cb
        End If

        If (Len(sStartDir) > 0) Then
                m_sCurrentDir = sStartDir & vbNullChar
        Else
                m_sCurrentDir = vbNullChar
        End If
        
        With BI
        
                If (Len(sTitle) > 0) Then
                        .lpszTitle = sTitle
                Else
                        .lpszTitle = "Select A Directory"
                End If
        
                .lpfnCallback = ml_GetAddressofFunction(AddressOf ml_BrowseCallbackProc)
                .ulFlags = BIF_RETURNONLYFSDIRS
                If bIncludeFiles Then .ulFlags = .ulFlags + BIF_BROWSEINCLUDEFILES
        
                If bAllowNew Then
                        .ulFlags = .ulFlags + BIF_NEWDIALOGSTYLE + BIF_UAHINT
                        Call OleInitialize(Null) ' Initialize OLE and COM
                Else
                        .ulFlags = .ulFlags + BIF_STATUSTEXT
                End If
        
                If (lOwnerHwnd <> 0) Then .hWndOwner = lOwnerHwnd
        
        End With
        
        lngIDList = SHBrowseForFolder(BI)

        If (Len(sRootDir) > 0) Then
                If PathIsDirectory(sRootDir) Then Call CoTaskMemFree(lngIDList2)
        End If

        If (lngIDList) Then
                strBuffer = Space$(MAX_PATH)
                lngRet = SHGetPathFromIDList(lngIDList, strBuffer)
                Call CoTaskMemFree(lngIDList)
                strBuffer = Left$(strBuffer, InStr(strBuffer, vbNullChar) - 1)
                strRet = strBuffer
        Else
                strRet = vbNullString
        End If
        
        gs_GetDir = strRet
        
End Function

Public Function gs_MacroDir(ByVal sMacroName As String, Optional ByVal bIncludeBackslash As Boolean = True, Optional sMacroPath As String = vbNullString) As String

        Dim objVB                   As VBE
        Dim objProject              As VBProject
        Dim strRet                  As String
    
        strRet = vbNullString
        
        Set objVB = App.VBE
        
        For Each objProject In objVB.VBProjects
                With objProject
                        If (StrComp(.name, sMacroName, vbTextCompare) = 0) Then
                                sMacroPath = .FileName
                                strRet = gs_ParseDirName(.FileName, bIncludeBackslash)
                                Exit For
                        End If
                End With
        Next objProject
        
        Set objProject = Nothing
        Set objVB = Nothing
        
        gs_MacroDir = strRet

End Function

Public Function gs_AppDir(Optional ByVal bIncludeBackslash As Boolean = True) As String
        
        Dim strRet                  As String
        
        strRet = App.Path
        
        If bIncludeBackslash Then strRet = gs_EnsureBackslash(strRet)
        
        gs_AppDir = strRet
        
End Function

Public Function gs_ThisDir(Optional ByVal bIncludeBackslash As Boolean = True, Optional sMacroPath As String = vbNullString) As String

        Dim objVB                   As VBE
        Dim objProject              As VBProject
        Dim strRet                  As String
    
        ' the App.Frame.PathOfThisAddin does not always work
        ' if this macro is being utilized while another macro
        ' also being utilized
    
        strRet = vbNullString
                
        Set objVB = App.VBE
        
        For Each objProject In objVB.VBProjects
                With objProject
                        If (StrComp(.name, DEF_PROJECT_NAME, vbTextCompare) = 0) Then
                                sMacroPath = .FileName
                                strRet = gs_ParseDirName(.FileName, bIncludeBackslash)
                                Exit For
                        End If
                End With
        Next objProject
        
        Set objProject = Nothing
        Set objVB = Nothing
        
        gs_ThisDir = strRet

End Function

Public Function gs_ThisFile() As String

        Dim objVB                   As VBE
        Dim objProject              As VBProject
        Dim strRet                  As String
    
        strRet = vbNullString
                
        Set objVB = App.VBE
        
        For Each objProject In objVB.VBProjects
                With objProject
                        If (StrComp(.name, DEF_PROJECT_NAME, vbTextCompare) = 0) Then
                                strRet = .FileName
                                Exit For
                        End If
                End With
        Next objProject
        
        Set objProject = Nothing
        Set objVB = Nothing
        
        gs_ThisFile = strRet

End Function

Public Function gb_IsAddInProjectLoaded(ByVal sProjectName As String, Optional sReturnFileName As String = vbNullString) As Boolean
    
        Dim vbaProjects             As VBProjects
        Dim vbaProject              As VBProject
        Dim blnRet                  As Boolean
    
On Error Resume Next

        blnRet = False
        
        Set vbaProjects = App.VBE.VBProjects
        
        For Each vbaProject In vbaProjects
                                               
                If (StrComp(sProjectName, vbaProject.name, vbTextCompare) = 0) Then
                        
                        ' will get error if project not saved
                        If (Err.Number = 76) Then
                                Err.Clear
                        Else
                                sReturnFileName = vbaProject.FileName
                                blnRet = True
                                Exit For
                        End If
                    
                End If
    
        Next vbaProject
        
Controlled_Exit:
        
        gb_IsAddInProjectLoaded = blnRet
    
        Set vbaProject = Nothing
        Set vbaProjects = Nothing
    
Exit Function

End Function

Public Function gb_IsAddInFileLoaded(ByVal sFileName As String, Optional sReturnProjectName As String = vbNullString) As Boolean
    
        Dim vbaProjects             As VBProjects
        Dim vbaProject              As VBProject
        Dim blnRet                  As Boolean
    
On Error Resume Next

        blnRet = False
        
        Set vbaProjects = App.VBE.VBProjects
        
        For Each vbaProject In vbaProjects
                                               
                If (StrComp(sFileName, vbaProject.FileName, vbTextCompare) = 0) Then
                        
                        ' will get error if project not saved
                        If (Err.Number = 76) Then
                                Err.Clear
                        Else
                                sReturnProjectName = vbaProject.name
                                blnRet = True
                                Exit For
                        End If
                    
                End If
    
        Next vbaProject
        
Controlled_Exit:
        
        gb_IsAddInFileLoaded = blnRet
    
        Set vbaProject = Nothing
        Set vbaProjects = Nothing
    
Exit Function

End Function

Public Function gb_FileExists(ByVal sFile As String) As Boolean
        
        Dim FSO                     As Scripting.FileSystemObject

        Set FSO = New FileSystemObject

        gb_FileExists = FSO.FileExists(Trim$(sFile))

        Set FSO = Nothing

End Function

Public Function gb_DirExists(ByVal sFolder As String, Optional ByVal bCreate As Boolean = False) As Boolean

        Dim FSO                     As Scripting.FileSystemObject
        Dim blnRet                  As Boolean

On Error GoTo ErrTrap
        
        If bCreate Then blnRet = mb_CreateDir(sFolder): GoTo Controlled_Exit
        
        Set FSO = New Scripting.FileSystemObject
        
        blnRet = FSO.FolderExists(sFolder)
        
Controlled_Exit:
        
        gb_DirExists = blnRet
        
        Set FSO = Nothing
        
Exit Function

ErrTrap:
        
        MsgBox Err.Description, vbExclamation
        blnRet = False
        Resume Controlled_Exit

End Function

Private Function mb_CreateDir(ByVal sFolder As String) As Boolean

        Dim FSO                     As Scripting.FileSystemObject
        Dim FLD                     As Scripting.Folder
        Dim intSlash                As Integer
        Dim blnRet                  As Boolean

On Error GoTo ErrTrap
        
        ' will create recursive folder structure
        
        Set FSO = New Scripting.FileSystemObject
        
        blnRet = True
        
        If FSO.FolderExists(sFolder) Then GoTo Controlled_Exit

        ' search from right to find path
        intSlash = InStrRev(sFolder, "\")
        
        If (intSlash > 0) Then blnRet = mb_CreateDir(Left$(sFolder, (intSlash - 1)))
        
        If Not FSO.FolderExists(sFolder) Then Set FLD = FSO.CreateFolder(sFolder)

Controlled_Exit:
        
        mb_CreateDir = blnRet
        
        Set FSO = Nothing
        Set FLD = Nothing
        
Exit Function

ErrTrap:
        
        MsgBox Err.Description, vbExclamation
        blnRet = False
        Resume Controlled_Exit

End Function

Public Function gs_UniqueFileName(ByVal sFile As String) As String
        
        Dim FSO                     As Scripting.FileSystemObject
        Dim lngIndex                As Long
        Dim strExt                  As String
        Dim strFile                 As String
        Dim strFolder               As String
        Dim strTest                 As String
        Dim strRet                  As String
        
        lngIndex = 1
        
        strRet = sFile
        
        strExt = gs_ParseFileExtension(sFile, True)
        strFile = gs_ParseFileName(sFile, True)
        strFolder = gs_ParseDirName(sFile, True)
        
        Set FSO = New Scripting.FileSystemObject
        
        Do While FSO.FileExists(strRet)
                                
                strTest = strFile & " (" & lngIndex & ")" & strExt
                strTest = strFolder & strTest
                
                strRet = strTest
                
                lngIndex = (lngIndex + 1)
        
        Loop
        
        gs_UniqueFileName = strRet
        
        Set FSO = Nothing

End Function

Public Function gl_FileOpenSaveDialogCallbackEx(ByVal lhWnd As LongPtr, ByVal lMsg As Long, _
                                                ByVal lParam As LongPtr, ByVal lpData As LongPtr) As LongPtr

        Dim lngHeight               As Long
        Dim lngWidth                As Long
        Dim lngHwnd                 As LongPtr
        Dim lngRet                  As Long
        Dim udtDialog               As RECT
        Dim udtDesktop              As RECT

On Error Resume Next

        Select Case lMsg

                Case WM_INITDIALOG

                        ' center the window
                        lngHwnd = GetParent(lhWnd)

                        Call GetWindowRect(GetDesktopWindow, udtDesktop)
                        Call GetWindowRect(lngHwnd, udtDialog)

                        lngHeight = (udtDialog.Bottom - udtDialog.Top)
                        lngWidth = (udtDialog.Right - udtDialog.Left)
                        udtDialog.Left = (((udtDesktop.Right - udtDesktop.Left) - lngWidth) / 2)
                        udtDialog.Top = (((udtDesktop.Bottom - udtDesktop.Top) - lngHeight) / 2)

                        lngRet = MoveWindow(lngHwnd, udtDialog.Left, udtDialog.Top, lngWidth, lngHeight, 1)

        End Select

        gl_FileOpenSaveDialogCallbackEx = 0&

End Function

Public Function gl_FileOpenSaveDialogCallback(ByVal lhWnd As LongPtr, ByVal lMsg As Long, _
                                              ByVal lParam As LongPtr, ByVal lpData As LongPtr) As LongPtr
    
        Dim lngHeight               As Long
        Dim lngWidth                As Long
        Dim lngHwnd                 As LongPtr
        Dim lngRet                  As Long
        Dim udtDialog               As RECT
        Dim udtDesktop              As RECT
    
On Error Resume Next
    
        Select Case lMsg
            
                Case WM_INITDIALOG
                
                        Call GetWindowRect(GetDesktopWindow, udtDesktop)
                        Call GetWindowRect(lngHwnd, udtDialog)
                        
                        lngHeight = (udtDialog.Bottom - udtDialog.Top)
                        lngWidth = (udtDialog.Right - udtDialog.Left)
                        udtDialog.Left = (((udtDesktop.Right - udtDesktop.Left) - lngWidth) / 2)
                        udtDialog.Top = (((udtDesktop.Bottom - udtDesktop.Top) - lngHeight) / 2)
                        
                        lngRet = MoveWindow(lngHwnd, udtDialog.Left, udtDialog.Top, lngWidth, lngHeight, 1)
                        
        End Select

        gl_FileOpenSaveDialogCallback = 0&
        
End Function

Private Function ml_GetAddressofFunction(lAdd As LongPtr) As LongPtr
        ml_GetAddressofFunction = lAdd
End Function

Private Function ml_BrowseCallbackProc(ByVal lhWnd As LongPtr, ByVal lMsg As Long, ByVal lPIDList As LongPtr, ByVal lData As LongPtr) As LongPtr

        Dim lngPtrRet                     As LongPtr
        Dim lngRet                         As Long
        Dim strBuffer                     As String
    
On Local Error Resume Next

        Select Case lMsg
    
                Case BFFM_INITIALIZED
                
                        lngPtrRet = SendMessage(lhWnd, BFFM_SETSELECTION, 1, m_sCurrentDir)
                        
                Case BFFM_SELCHANGED
                        
                        strBuffer = Space(MAX_PATH)
                        lngRet = SHGetPathFromIDList(lPIDList, strBuffer)

                        If (lngRet = 1) Then
                                lngPtrRet = SendMessage(lhWnd, BFFM_SETSTATUSTEXT, 0, strBuffer)
                        End If

        End Select

        ml_BrowseCallbackProc = 0

End Function

Public Sub g_DebugNote(ByVal sDebugString As String)
        ' outputs string to external debug viewer (e.g. DEBUGMON.exe)
        Call OutputDebugString(DEF_PROJECT_NAME & ": " & sDebugString & vbCrLf)
End Sub

Public Function PText(ByVal lDollar As Long, ByVal lIndex As Long, vDefault As Variant, _
                      Optional ByVal sFileToRead As String = vbNullString, _
                      Optional ByVal iVarType As AlphaVariableType = alphaVarType_STRING, _
                      Optional ByVal bAddDots As Boolean = False, _
                      Optional ByVal bWipeEquals As Boolean = False, _
                      Optional ByVal bVariableLines As Boolean = False) As Variant
        
        ' we're using the function to retrieve the text
        ' so that we can bypass the error and assign a
        ' default value to the string if not found in CTX
        
        Dim strFile                 As String
        Dim strRet                  As String
        Dim strTmp                  As String
        Dim lngFlag                 As Long
                
        Const DEF_BYPASS_ERR        As Long = 2
        Const DEF_VARIABLE_LINES    As Long = 4
        
On Error Resume Next
        
        ' 14 jun 11 TFS#44875
        '   + UPDATED to use new Frame.ReadTextFile2 function
        
        ' initialize
        strRet = CStr(vDefault)
        strTmp = vbNullString
        lngFlag = DEF_BYPASS_ERR
        
        If bVariableLines Then lngFlag = (lngFlag + DEF_VARIABLE_LINES)
        
        ' build the path to the text file
        If (Len(sFileToRead) > 0) Then
                strFile = sFileToRead
        Else
                strFile = gs_ThisDir & DEF_TEXT
        End If
        
        strTmp = App.Frame.ReadTextFile2(strFile, lDollar, lIndex, lngFlag)
                        
        ' ReadTextFile2 will return a null string if not found
        If (Len(Trim$(strTmp)) > 0) Then
                strRet = strTmp
        Else
                
                ' look for language tag at end of string - is added sometimes at design time
                Select Case True
                        
                        Case (Len(strRet) < 3)      ' do nothing
                        Case (Right$(Trim$(strRet), 3) = "!!!"), _
                             (Right$(Trim$(strRet), 3) = "@@@")
                        
                                strRet = Left$(strRet, (Len(Trim$(strRet)) - 3))
                                
                End Select
                
        End If
                
        If (Err.Number <> 0) Then Err.Clear
        
        ' set return value
        Select Case iVarType
                
                Case alphaVarType_BOOLEAN
                        
                        PText = CBool(strRet)
                        
                        ' look for type mismatch, this will occur if strRet is not "True" or "False"
                        If (Err.Number = 13) Then
                                Call Err.Clear
                                PText = CBool(CInt(Val(strRet)))
                        End If
                        
                Case alphaVarType_SINGLE: PText = CSng(Val(strRet))
                Case alphaVarType_DOUBLE: PText = CDbl(Val(strRet))
                Case alphaVarType_INTEGER: PText = CInt(Val(strRet))
                Case alphaVarType_LONG: PText = CLng(Val(strRet))
                Case Else ' must be a string

                        If bWipeEquals Then strRet = Trim$(Replace$(strRet, "=", vbNullString))

                        If bAddDots Then strRet = gs_SetWaitText(strRet)
                        
                        PText = strRet
                        
        End Select
        
End Function

Public Function PDbl(ByVal S As String) As Double

        ' This function should always be used to convert a string
        ' e.g. from a text box to a Double or Single value
        '
        ' Convert string to floating point value.
        '
        ' Uses Val at the moment, but may use CDbl in future to allow
        ' "," as decimal separator.
        '
        ' Val always use ".", CDbl uses "," or ".", depending on the Regional
        ' Settings in Control Panel. But the Alphacam Evaluate function uses
        ' "." for decimal, and "," for parameter separators in some functions.
        ' To allow "," as decimal separator, extensive changes would be needed
        ' in Alphacam, so VBA should only use "." to be consistent.
        '
        ' Also, if "." is passed to CDbl when regional settings use "," for decimal,
        ' the return value will be incorrect - returns number less any decimal.
        ' Same type of problem if a "," is passed to Val - returns only the whole number.
        
        PDbl = Val(gs_NoComma(S))

End Function

Public Function PLng(ByVal S As String) As Long

        ' This function is the same as PDbl, but returns a long
        
        PLng = CLng(Val(gs_NoComma(S)))

End Function

Public Function PTol(ByVal vVal As Variant, Optional ByVal Places As Long = 4) As Double
        
        Dim lngPlaces               As Long
        Dim strFormat               As String
        Dim strRet                  As String
        
On Error Resume Next
        
        lngPlaces = IIf((Places < 0), 0, (Places - 1))
        strFormat = "#0.0" & String$((lngPlaces), "#")
        
        strRet = Format$(PDbl(vVal), strFormat)
        strRet = PDbl(strRet)
        
        PTol = Val(strRet)
                
End Function

Public Function PStr(ByVal vVal As Variant, Optional ByVal Places As Long = 4) As String

        Dim lngPlaces               As Long
        Dim strFormat               As String
        Dim strRet                  As String
        
On Error Resume Next
        
        lngPlaces = IIf((Places < 0), 0, (Places - 1))
        strFormat = "#0.0" & String$((lngPlaces), "#")
        
        strRet = Format$(PDbl(vVal), strFormat)
        strRet = gs_NoZeros(strRet)
        
        PStr = strRet

End Function




