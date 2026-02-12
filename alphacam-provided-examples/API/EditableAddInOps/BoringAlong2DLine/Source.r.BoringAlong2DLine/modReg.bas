Attribute VB_Name = "modReg"
Option Explicit
Option Private Module

' >< CONSTANTS ><
'
Private Const DEF_REG_KEY                   As String = "Software\Planit\Alphacam\" & DEF_PROJECT_NAME
'
Private Const KEY_ALL_ACCESS                As Long = &HF003F   'Permission for all types of access.
Private Const KEY_ENUMERATE_SUB_KEYS        As Long = &H8       'Permission to enumerate subkeys.
Private Const KEY_READ                      As Long = &H20019   'Permission for general read access.
Private Const KEY_WRITE                     As Long = &H20006   'Permission for general write access.
Private Const KEY_QUERY_VALUE               As Long = &H1       'Permission to query subkey data.
Private Const REG_FORCE_RESTORE             As Long = 8&        'Permission to overwrite a registry key
Private Const TOKEN_QUERY                   As Long = &H8&
Private Const TOKEN_ADJUST_PRIVILEGES       As Long = &H20&
Private Const SE_PRIVILEGE_ENABLED          As Long = &H2
Private Const SE_RESTORE_NAME               As String = "SeRestorePrivilege"
Private Const SE_BACKUP_NAME                As String = "SeBackupPrivilege"

' >< ENUMS ><
'
Public Enum KeyRoot
        HKEY_CLASSES_ROOT = &H80000000      'stores OLE class information and file associations
        HKEY_CURRENT_CONFIG = &H80000005    'stores computer configuration information
        HKEY_CURRENT_USER = &H80000001      'stores program information for the current user.
        HKEY_LOCAL_MACHINE = &H80000002     'stores program information for all users
        HKEY_USERS = &H80000003             'has all the information for any user (not just the one provided by HKEY_CURRENT_USER)
End Enum

Public Enum KeyType
        REG_BINARY = 3                      'A non-text sequence of bytes
        REG_DWORD = 4                       'A 32-bit integer...visual basic data type of Long
        REG_SZ = 1                          'A string terminated by a null character
End Enum

' >< UDT ><
'
Private Type SECURITY_ATTRIBUTES
        nLength As Long
        lpSecurityDescriptor As LongPtr
        bInheritHandle As Boolean
End Type

Private Type FILETIME
        dwLowDateTime As Long
        dwHighDateTime As Long
End Type

Private Type LUID
        lowpart As Long
        highpart As Long
End Type

Private Type LUID_AND_ATTRIBUTES
        pLuid As LUID
        Attributes As Long
End Type

Private Type TOKEN_PRIVILEGES
        PrivilegeCount As Long
        Privileges As LUID_AND_ATTRIBUTES
End Type

' >< API ><
'
Private Declare PtrSafe Function RegSetValueEx Lib "advapi32.dll" Alias "RegSetValueExA" (ByVal hKey As LongPtr, ByVal lpValueName As String, ByVal Reserved As Long, ByVal dwType As Long, lpData As Any, ByVal cbData As Long) As Long
Private Declare PtrSafe Function RegQueryValueEx Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As LongPtr, ByVal lpValueName As String, ByVal lpReserved As LongPtr, lpType As Long, lpData As Any, lpcbData As Long) As Long
Private Declare PtrSafe Function RegOpenKeyEx Lib "advapi32.dll" Alias "RegOpenKeyExA" (ByVal hKey As LongPtr, ByVal lpSubKey As String, ByVal ulOptions As Long, ByVal samDesired As Long, phkResult As LongPtr) As Long
Private Declare PtrSafe Function RegDeleteValue Lib "advapi32.dll" Alias "RegDeleteValueA" (ByVal hKey As LongPtr, ByVal lpValueName As String) As Long
Private Declare PtrSafe Function RegDeleteKey Lib "advapi32.dll" Alias "RegDeleteKeyA" (ByVal hKey As LongPtr, ByVal lpSubKey As String) As Long
Private Declare PtrSafe Function RegCreateKeyEx Lib "advapi32.dll" Alias "RegCreateKeyExA" (ByVal hKey As LongPtr, ByVal lpSubKey As String, ByVal Reserved As Long, ByVal lpClass As String, ByVal dwOptions As Long, ByVal samDesired As Long, lpSecurityAttributes As SECURITY_ATTRIBUTES, phkResult As LongPtr, lpdwDisposition As Long) As Long
Private Declare PtrSafe Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As LongPtr) As Long
Private Declare PtrSafe Function RegSaveKey Lib "advapi32.dll" Alias "RegSaveKeyA" (ByVal hKey As LongPtr, ByVal lpFile As String, lpSecurityAttributes As SECURITY_ATTRIBUTES) As Long
Private Declare PtrSafe Function RegRestoreKey Lib "advapi32.dll" Alias "RegRestoreKeyA" (ByVal hKey As LongPtr, ByVal lpFile As String, ByVal dwFlags As Long) As Long
Private Declare PtrSafe Function RegEnumKeyEx Lib "advapi32.dll" Alias "RegEnumKeyExA" (ByVal hKey As LongPtr, ByVal dwIndex As Long, ByVal lpName As String, lpcbName As Long, ByVal lpReserved As LongPtr, ByVal lpClass As String, lpcbClass As Long, lpftLastWriteTime As FILETIME) As Long
Private Declare PtrSafe Function RegEnumValue Lib "advapi32.dll" Alias "RegEnumValueA" (ByVal hKey As LongPtr, ByVal dwIndex As Long, ByVal lpValueName As String, lpcbValueName As Long, ByVal lpReserved As LongPtr, lpType As Long, lpData As Byte, lpcbData As Long) As Long
Private Declare PtrSafe Function AdjustTokenPrivileges Lib "advapi32.dll" (ByVal TokenHandle As LongPtr, ByVal DisableAllPrivileges As Long, NewState As TOKEN_PRIVILEGES, ByVal BufferLength As Long, PreviousState As TOKEN_PRIVILEGES, ReturnLength As Long) As Long                'Used to adjust your program's security privileges, can't restore without it!
Private Declare PtrSafe Function LookupPrivilegeValue Lib "advapi32.dll" Alias "LookupPrivilegeValueA" (ByVal lpSystemName As Any, ByVal lpName As String, lpLuid As LUID) As Long          'Returns a valid LUID which is important when making security changes in NT.
Private Declare PtrSafe Function OpenProcessToken Lib "advapi32.dll" (ByVal ProcessHandle As LongPtr, ByVal DesiredAccess As Long, TokenHandle As LongPtr) As Long
Private Declare PtrSafe Function GetCurrentProcess Lib "kernel32" () As LongPtr
'

Public Function gv_GetSetting(ByVal sSetting As String, ByVal vDefault As Variant, _
                              Optional ByVal iSettingType As AlphaVariableType = alphaVarType_STRING, _
                              Optional ByVal sSection As String = vbNullString, _
                              Optional ByVal bModuleSpecific As Boolean = False) As Variant
        
        Dim strRet                  As String
        Dim strKey                  As String
        
        strKey = DEF_REG_KEY
        
        ' if module specific, slap on the program letter to the setting name
        If bModuleSpecific Then sSetting = sSetting & "_" & Chr$(App.ProgramLetter)
        
        If (Len(Trim$(sSection)) > 0) Then strKey = strKey & "\" & sSection
        
        strRet = gs_ReadRegKey(strKey, sSetting, , CStr(vDefault))
        
        ' set return value
        Select Case iSettingType
                
                Case alphaVarType_BOOLEAN
                
                        gv_GetSetting = CBool(strRet)
                        
                        ' look for type mismatch, this will occur if strRet is not "True" or "False"
                        If (Err.Number = 13) Then
                                Call Err.Clear
                                gv_GetSetting = CBool(CInt(Val(strRet)))
                        End If
                
                Case alphaVarType_SINGLE: gv_GetSetting = CSng(Val(strRet))
                Case alphaVarType_DOUBLE: gv_GetSetting = PDbl(strRet)
                Case alphaVarType_INTEGER: gv_GetSetting = CInt(Val(strRet))
                Case alphaVarType_LONG: gv_GetSetting = CLng(Val(strRet))
                Case Else: gv_GetSetting = strRet
                
        End Select
        
End Function

Public Sub g_SaveSetting(ByVal sSetting As String, ByVal vValue As Variant, _
                         Optional ByVal sSection As String = vbNullString, _
                         Optional ByVal bModuleSpecific As Boolean = False)

        Dim strKey                  As String
        Dim blnRet                  As Boolean
                                
        If (Len(Trim$(sSetting)) = 0) Then Exit Sub
        
        strKey = DEF_REG_KEY
        
        ' if module specific, slap on the program letter to the setting name
        If bModuleSpecific Then sSetting = sSetting & "_" & Chr$(App.ProgramLetter)
        
        If (Len(Trim$(sSection)) > 0) Then strKey = strKey & "\" & sSection
                
        blnRet = gb_WriteRegKey(REG_SZ, strKey, sSetting, CStr(vValue))
        
End Sub

'Public Function gb_ExportRegKey(ByVal lKeyRoot As KeyRoot, ByVal sKeyPath As String, ByVal sFileName As String) As Boolean
'
'        Dim lngHKey                 As LongPtr
'        Dim lngRet                  As Long
'        Dim blnRet                  As Boolean
'
'On Error Resume Next
'
'        blnRet = False
'
'        ' check to see if allowed to do this
'        If Not mb_EnablePrivilege(SE_BACKUP_NAME) Then GoTo Controlled_Exit
'
'        ' open the registry key
'        lngRet = RegOpenKeyEx(lKeyRoot, sKeyPath, 0&, KEY_ALL_ACCESS, lngHKey)
'
'        ' error?
'        If (lngRet <> 0) Then
'                lngRet = RegCloseKey(lngHKey)
'                GoTo Controlled_Exit
'        End If
'
'        ' check for a copy of the export and delete old one if applicable
'        If (Dir$(sFileName) <> vbNullString) Then Call Kill(sFileName)
'
'        ' export the registry key, returns 0 if OK
'        lngRet = RegSaveKey(lngHKey, sFileName, 0&)
'
'        blnRet = (lngRet = 0)
'
'        ' close the registry key
'        lngRet = RegCloseKey(lngHKey)
'
'Controlled_Exit:
'
'        gb_ExportRegKey = blnRet
'
'Exit Function
'
'End Function

Public Function gb_ImportRegKey(ByVal lKeyRoot As KeyRoot, ByVal sKeyPath As String, ByVal sFileName As String) As Boolean
        
        ' import (overwrite) registry keys
    
        Dim lngHKey                 As LongPtr
        Dim lngRet                  As Long
        Dim blnRet                  As Boolean

On Error Resume Next

        ' check to see if allowed to do this
        If Not mb_EnablePrivilege(SE_RESTORE_NAME) Then GoTo Controlled_Exit
  
        ' open the registry key
        lngRet = RegOpenKeyEx(lKeyRoot, sKeyPath, 0&, KEY_ALL_ACCESS, lngHKey)
        
        ' error?
        If (lngRet <> 0) Then
                lngRet = RegCloseKey(lngHKey)
                GoTo Controlled_Exit
        End If
        
        ' import the registry key
        lngRet = RegRestoreKey(lngHKey, sFileName, REG_FORCE_RESTORE)
        
        blnRet = (lngRet = 0)
        
        ' close the registry key
        lngRet = RegCloseKey(lngHKey)
        
Controlled_Exit:

        gb_ImportRegKey = blnRet
        
Exit Function
        
End Function

Public Function gs_ReadRegKey(ByVal sKeyPath As String, ByVal sSubKey As String, Optional lKeyRoot As KeyRoot = HKEY_CURRENT_USER, Optional sDefault As String = vbNullString) As String
        
        ' read entry from registry
  
        Dim lngHKey                 As LongPtr
        Dim lngRet                  As Long
        Dim strRet                  As String

On Error Resume Next

        ' open the registry key
        lngRet = RegOpenKeyEx(lKeyRoot, sKeyPath, 0, KEY_READ, lngHKey)
        
        ' if no key, then set default return
        If (lngRet <> 0) Then
                strRet = sDefault
                lngRet = RegCloseKey(lngHKey)
        Else
                
                ' get the keys value
                strRet = gs_GetSubKeyValue(lngHKey, sSubKey, sDefault)
                lngRet = RegCloseKey(lngHKey)
        
        End If

Controlled_Exit:
        
        gs_ReadRegKey = strRet

Exit Function
                
End Function

Public Function gb_WriteRegKey(ByVal lKeyType As KeyType, ByVal sKeyPath As String, ByVal sSubKey As String, _
                               ByVal sSubKeyValue As String, Optional lKeyRoot As KeyRoot = HKEY_CURRENT_USER) As Boolean
                               
        ' write entry to registry
  
        Dim lngHKey                 As LongPtr              ' receives handle to the newly created or opened registry key
        Dim SA                      As SECURITY_ATTRIBUTES  ' security settings of the key
        Dim lngNewKey               As Long                 ' receives 1 if new key was created or 2 if an existing key was opened
        Dim lngRet                  As Long
        Dim blnRet                  As Boolean

On Error Resume Next

        blnRet = False
        
        ' Set the name of the new key and the default security settings
        With SA
                .nLength = Len(SA)              ' size of the structure
                .lpSecurityDescriptor = 0       ' default security level
                .bInheritHandle = True          ' the default value for this setting
        End With

        ' create or open the registry key
        lngRet = RegCreateKeyEx(lKeyRoot, sKeyPath, 0, vbNullString, 0, KEY_WRITE, SA, lngHKey, lngNewKey)
        
        ' error?
        If (lngRet <> 0) Then
                lngRet = RegCloseKey(lngHKey)
                GoTo Controlled_Exit
        End If

        ' determine type of key and write it to the registry
        Select Case lKeyType
                Case REG_SZ: lngRet = RegSetValueEx(lngHKey, sSubKey, 0, lKeyType, ByVal sSubKeyValue, Len(sSubKeyValue))
                Case REG_DWORD: lngRet = RegSetValueEx(lngHKey, sSubKey, 0, lKeyType, CLng(sSubKeyValue), 4)
                Case REG_BINARY: lngRet = RegSetValueEx(lngHKey, sSubKey, 0, lKeyType, CByte(sSubKeyValue), 4)
        End Select

        blnRet = (lngRet = 0)

        lngRet = RegCloseKey(lngHKey)
        
Controlled_Exit:
        
        gb_WriteRegKey = blnRet

Exit Function
                
End Function

Public Function gs_EnumerateRegKeys(ByVal lKeyRoot As KeyRoot, ByVal sKeyPath As String) As String
  
        ' enumerate all subkeys under a registry key
        Dim FT                      As FILETIME
        Dim lngHKey                 As LongPtr         ' receives a handle to the opened registry key
        Dim lngRet                  As Long
        Dim lngCounter              As Long
        Dim strBuffer               As String
        Dim lngBufferSize           As Long
        Dim strClassNameBuffer      As String
        Dim lngClassNameBufferSize  As Long
        Dim strRet                  As String
        
On Error Resume Next

        ' open the registry key
        lngRet = RegOpenKeyEx(lKeyRoot, sKeyPath, 0, KEY_ENUMERATE_SUB_KEYS, lngHKey)
        
        ' anything?
        If (lngRet <> 0) Then
                strRet = vbNullString
                lngRet = RegCloseKey(lngHKey)
                GoTo Controlled_Exit
        End If
        
        lngCounter = 0
  
        ' loop until no more registry keys
        Do Until (lngRet <> 0)
                
                strBuffer = Space(255)
                strClassNameBuffer = Space(255)
                lngBufferSize = 255
                lngClassNameBufferSize = 255
                
                lngRet = RegEnumKeyEx(lngHKey, lngCounter, strBuffer, lngBufferSize, ByVal 0, strClassNameBuffer, lngClassNameBufferSize, FT)
          
                If (lngRet = 0) Then
                        strBuffer = Left$(strBuffer, lngBufferSize)
                        strClassNameBuffer = Left$(strClassNameBuffer, lngClassNameBufferSize)
                        strRet = strRet & strBuffer & ","
                End If
                
                lngCounter = (lngCounter + 1)
                
        Loop
        
        ' trim off the last delimiter
        If (strRet <> vbNullString) Then strRet = Left$(strRet, Len(strRet) - 1)
  
        ' close the registry key
        lngRet = RegCloseKey(lngHKey)
  
Controlled_Exit:
        
        gs_EnumerateRegKeys = strRet

Exit Function
  
End Function

Public Function gs_EnumerateRegKeyValues(ByVal lKeyRoot As KeyRoot, ByVal sKeyPath As String, Optional ByVal bIncludeKeyNames As Boolean = True) As String
  
        ' enumerate all the values under a key in the registry

        Dim KT                      As KeyType
        Dim lngHKey                 As LongPtr         ' receives a handle to the opened registry key
        Dim lngRet                  As Long
        Dim lngCounter              As Long
        Dim strBuffer               As String
        Dim lngBufferSize           As Long
        Dim strRet                  As String

On Error Resume Next
        
        strRet = vbNullString

        ' open the registry key to enumerate the values of
        lngRet = RegOpenKeyEx(lKeyRoot, sKeyPath, 0, KEY_QUERY_VALUE, lngHKey)
        
        ' error?
        If (lngRet <> 0) Then
                lngRet = RegCloseKey(lngHKey)
                GoTo Controlled_Exit
        End If
  
        lngCounter = 0
  
        ' loop until no more registry keys value
        Do Until (lngRet <> 0)
                
                strBuffer = Space$(255)
                lngBufferSize = 255
    
                lngRet = RegEnumValue(lngHKey, lngCounter, strBuffer, lngBufferSize, 0, KT, ByVal 0&, ByVal 0&)
    
                If (lngRet = 0) Then
                        strBuffer = Left$(strBuffer, lngBufferSize)
                        If bIncludeKeyNames Then strRet = strRet & strBuffer & "*"
                        strRet = strRet & gs_GetSubKeyValue(lngHKey, strBuffer, vbNullString) & ","
                End If
                
                lngCounter = (lngCounter + 1)
        Loop
        
        ' trim off the last delimiter
        If (strRet <> vbNullString) Then strRet = Left$(strRet, Len(strRet) - 1)
        
        ' close the registry key
        lngRet = RegCloseKey(lngHKey)
        
Controlled_Exit:
        
        gs_EnumerateRegKeyValues = strRet

Exit Function
  
End Function

Public Function gb_DeleteRegKey(ByVal lKeyRoot As KeyRoot, ByVal sKeyPath As String, ByVal sSubKey As String) As Boolean
  
        ' delete a registry key
        ' under Win NT/2000 all subkeys must be deleted first
        ' under Win 9x all subkeys are deleted
          
        Dim lngRet                      As Long
        Dim blnRet                      As Boolean

On Error Resume Next
        
        blnRet = False

        ' Attempt to delete the desired registry key.
        lngRet = RegDeleteKey(lKeyRoot, sKeyPath & "\" & sSubKey)
  
        blnRet = (lngRet = 0)

        gb_DeleteRegKey = blnRet

End Function

Public Function gb_DeleteRegKeyValue(ByVal lKeyRoot As KeyRoot, ByVal sKeyPath As String, Optional ByVal sSubKey As String = vbNullString) As Boolean
  
        ' delete a value from a key (but not the key) in the registry
  
        Dim lngHKey                 As LongPtr
        Dim lngRet                  As Long
        Dim blnRet                  As Boolean

On Error Resume Next
        
        blnRet = False
        
        ' First, open up the registry key which holds the value to delete.
        lngRet = RegOpenKeyEx(lKeyRoot, sKeyPath, 0, KEY_ALL_ACCESS, lngHKey)
        
        ' error?
        If (lngRet <> 0) Then
                lngRet = RegCloseKey(lngHKey)
                GoTo Controlled_Exit
        End If
        
        ' check to see if we are deleting a subkey or primary key
        If (sSubKey = vbNullString) Then sSubKey = sKeyPath
        
        ' successfully opened registry key so delete the desired value from the key.
        lngRet = RegDeleteValue(lngHKey, sSubKey)
   
        blnRet = (lngRet = 0)
  
        lngRet = RegCloseKey(lngHKey)
  
Controlled_Exit:
        
        gb_DeleteRegKeyValue = blnRet

Exit Function
  
End Function

Private Function gs_GetSubKeyValue(ByVal lHKey As LongPtr, ByVal sSubKey As String, ByVal sDefault As String) As String
  
        ' routine to get the registry key value and convert to a string
  
        Dim KT                      As KeyType
        Dim lngRet                  As Long
        Dim strBuffer               As String
        Dim lngBufferSize           As Long
        Dim lngNewBuffer            As Long
        Dim strRet                  As String

On Error Resume Next
        
        strRet = vbNullString
        
        'get registry key information
        lngRet = RegQueryValueEx(lHKey, sSubKey, 0, KT, ByVal 0, lngBufferSize)
        
        If (lngRet <> 0) Then
                strRet = sDefault
        Else
    
                ' determine what the KT is
                Select Case KT
                    
                        Case REG_SZ
                                
                                ' create a buffer
                                strBuffer = String$(lngBufferSize, Chr$(0))
                                
                                ' retrieve the key's content
                                lngRet = RegQueryValueEx(lHKey, sSubKey, 0, 0, ByVal strBuffer, lngBufferSize)
                                
                                If (lngRet <> 0) Then
                                        strRet = sDefault
                                Else
                                            
                                        ' remove the unnecessary chr$(0)'s
                                        strRet = Left$(strBuffer, InStr(1, strBuffer, Chr$(0)) - 1)
                                            
                                End If
                                
                        Case Else 'REG_DWORD or REG_BINARY
            
                                ' retrieve the key's value
                                lngRet = RegQueryValueEx(lHKey, sSubKey, 0, 0, lngNewBuffer, lngBufferSize)
                                
                                If (lngRet <> 0) Then
                                        strRet = sDefault
                                Else
                                        strRet = CStr(lngNewBuffer)
                                End If
                            
                End Select
                
        End If
        
Controlled_Exit:
        
        gs_GetSubKeyValue = strRet

Exit Function
        
End Function

Private Function mb_EnablePrivilege(ByVal sName As String) As Boolean
        
        ' enable inport/export of registry settings
        Dim udtLUID                 As LUID
        Dim udtTokenPriv            As TOKEN_PRIVILEGES
        Dim udtPrevTokenPriv        As TOKEN_PRIVILEGES
        Dim lngRtn                  As Long
        Dim lngToken                As LongPtr
        Dim lngBufferLen            As Long
        Dim blnRet                  As Boolean

On Error Resume Next
        
        blnRet = False
        
        ' open the current process token
        lngRtn = OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES Or TOKEN_QUERY, lngToken)
                
        ' error?
        If (lngRtn = 0) Then GoTo Controlled_Exit
        If (Err.LastDllError <> 0) Then GoTo Controlled_Exit
  
        ' look up the privileges LUID
        lngRtn = LookupPrivilegeValue(0&, sName, udtLUID)
  
        ' error?
        If (lngRtn = 0) Then GoTo Controlled_Exit

        ' adjust the program's security privilege.
        With udtTokenPriv
                .PrivilegeCount = 1
                .Privileges.Attributes = SE_PRIVILEGE_ENABLED
                .Privileges.pLuid = udtLUID
        End With
  
        ' try to adjust privileges and return success or failure
        blnRet = (AdjustTokenPrivileges(lngToken, False, udtTokenPriv, Len(udtPrevTokenPriv), udtPrevTokenPriv, lngBufferLen) <> 0)
        
Controlled_Exit:
        
        mb_EnablePrivilege = blnRet
        
Exit Function

End Function



