Imports Microsoft.Win32 ' for RegistryKey

' To add a reference to the Alphacam type library:
' Right-click on the Project name in the Solution Explorer and pick Properties
' Click the References tab and then the Add button
' Select the Alphacam module required
' In the Imported namespaces box select the added library 

Public Class Form1
    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        ' Uncomment the next line to control how Alphacam starts up
        'SetStartUpOptions()
        Dim Acam As AlphaCAMRouter.App
		
		' create instance of Alphacam Advanced Router
		Acam = CreateObject("aroutaps.application")
		
        If Acam.ApiVersion >= 20070810 Then
            'This is V7.5 or later, so we can get the version and show it in the form
            TextBox1.Text = Acam.AlphacamVersion.String
            TextBox2.Text = Acam.ProgramLevel
        End If
        Dim Drw As Drawing
        Drw = Acam.ActiveDrawing
        If Acam.ProgramLevel <> AcamLevel.acamLevelPROUTAPS Then
            Drw.CreateText2("From VB.Net", 0, 0, 10)
        End If
        Drw.CreateRectangle(0, 0, 150, 100)
        Drw.ZoomAll()
        Drw.SaveAsEx(Acam.LicomdirPath + "licomdir\123.ard", AcamSaveAsVersion.acamSaveAsV7)
        'Acam.Quit()
        ' The following 4 lines make .Net release the Alphacam object, otherwise Alphacam stays in memory (until this program exits)
        Acam = Nothing
        System.GC.Collect()
        System.GC.WaitForPendingFinalizers()
        System.GC.Collect()
    End Sub

    Private Sub SetStartUpOptions()
        Dim Rk As RegistryKey
        Rk = Registry.CurrentUser.CreateSubKey("SOFTWARE\LicomSystems\Acam\COM", RegistryKeyPermissionCheck.ReadWriteSubTree)
        Rk.SetValue("ProgramLevel", AlphaCAMRouter.AcamLevel.acamLevelSTANDARD, RegistryValueKind.DWord)
    End Sub
End Class
