Imports AlphaCAMMill
Imports System.Runtime.InteropServices
Public Class AlphacamEvents

    Dim Acam As IAlphaCamApp
    Dim theAddInInterface As AddInInterfaceClass
    Dim CmdFillet As Fillet

    Public Sub New(App As IAlphaCamApp)

        Dim Frm As Frame

        Acam = App
        Frm = Acam.Frame

        theAddInInterface = TryCast(Frm.CreateAddInInterface(), AddInInterfaceClass)
        If (theAddInInterface Is Nothing) Then
            MsgBox("Unexpected Error - failed to convert Addin Interface")
            Return
        End If

        AddHandler theAddInInterface.InitAlphacamAddIn, AddressOf theAddInInterface_InitAlphacamAddIn

        Marshal.ReleaseComObject(Frm)

    End Sub


    ' Called when the add-in Is loaded (Action == acamInitAddInActionInitialise)
    ' And when it Is reloaded after being disabled (Action == acamInitAddInActionReload)
    Protected Sub theAddInInterface_InitAlphacamAddIn(Action As AcamInitAddInAction, Data As EventData)

        CmdFillet = New Fillet(Acam)

        Data.ReturnCode = 0

    End Sub


End Class

Public Class Fillet : Implements IDisposable

    Dim Acam As IAlphaCamApp
    Dim Item As CommandItemClass
    Dim Frm As Frame

    Public Sub New(App As IAlphaCamApp)

        Acam = App
        Frm = Acam.Frame

        Item = TryCast(Frm.CreateCommandItem(), CommandItemClass)
        If (Item Is Nothing) Then
            MsgBox("Unexpected Error - CommandItemClass is not valid.")
            Return
        End If

        AddHandler Item.OnCommand, AddressOf Item_OnCommand
        AddHandler Item.OnUpdate, AddressOf Item_OnUpdate

        Dim bOK As Boolean
        bOK = Frm.AddMenuItem43("Fillet by specified value", Me.GetType.Name, AcamCommand.acamCmdEDIT_DELETE, True, "", 0, Item)
        If (bOK = False) Then
            MsgBox("Unexpected Error - Failed to create VBExampleAddin ribbon button command.")
        End If

    End Sub


    Protected Sub Item_OnCommand()

        Dim FilletAmount As Double
        If (Frm.InputFloatDialog("Example Add-in", "Fillet amount", AcamFloat.acamFloatNON_NEG, FilletAmount)) Then

            Dim Drw As Drawing = Acam.ActiveDrawing
            Dim Geos As Paths = Drw.Geometries

            Dim GeosCount As Integer = Geos.Count
            For i = 1 To GeosCount Step 1

                Dim Path As Path = Geos.Item(i)
                Path.Fillet(FilletAmount)

                Marshal.ReleaseComObject(Path)
            Next

            Drw.RedrawShadedViews()

            Marshal.ReleaseComObject(Geos)
            Marshal.ReleaseComObject(Drw)

        End If

    End Sub

    Protected Function Item_OnUpdate() As AcamOnUpdateReturn

        Dim AcamOnUpdateReturn As AcamOnUpdateReturn
        Dim drw As Drawing = Acam.ActiveDrawing

        If (drw.GetGeoCount() > 0) Then
            AcamOnUpdateReturn = AcamOnUpdateReturn.acamOnUpdate_UncheckedEnabled
        Else
            AcamOnUpdateReturn = AcamOnUpdateReturn.acamOnUpdate_UncheckedDisabled
        End If

        Marshal.ReleaseComObject(drw)

        Return AcamOnUpdateReturn

    End Function

#Region "IDisposable"
    Private _disposed As Boolean ' To detect redundant calls

    ' IDisposable
    Protected Overridable Sub Dispose(disposing As Boolean)

        If (_disposed) Then
            Return
        End If

        If disposing Then
            'Dispose Manageted objects
        End If

        If (Not Item Is Nothing) Then
            Marshal.ReleaseComObject(Item)
        End If

        If (Not Frm Is Nothing) Then
            Marshal.ReleaseComObject(Frm)
        End If

        Me._disposed = True
    End Sub

    Protected Overrides Sub Finalize()
        Dispose(False)
        MyBase.Finalize()
    End Sub

    ' This code added by Visual Basic to correctly implement the disposable pattern.
    Public Sub Dispose() Implements IDisposable.Dispose
        Dispose(True)
        GC.SuppressFinalize(Me)
    End Sub
#End Region

End Class
