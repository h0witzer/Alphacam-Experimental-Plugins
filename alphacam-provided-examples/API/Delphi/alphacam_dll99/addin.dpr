library addin;

///////////////////////////////////////////////////////////
//
// Example add-in Delphi DLL for AlphaCAM.
// David Butterfield  Licom Systems Ltd  25 Jan 99.
// For support email:  apisupport@licom.com.
// For a description of the AlphaCAM API see acamapi.hlp.
// The section in the help file describing events is for VBA projects,
// the routines in this file show how to use them in Delphi.
// Each routine in Delphi has an extra parameter (at the start) which gives
// the application object. This can be used to call AlphaCAM API methods
// and get other AlphaCAM objects.
// To make AlphaCAM load the DLL put an entry in the registry.
// Create a .reg file with the following:
//
// REGEDIT4
//
// [HKEY_LOCAL_MACHINE\SOFTWARE\LicomSystems\am5axaps\Applications\Delphi Add-In 1]
// @="C:\\DelphiProjects\\alphacam_addin\\addin.dll"
//
// double-click on the reg file to copy it into the registry.
//
// This will cause 5-axis Mill (am5axaps) to use the DLL.
// Replace am5axaps with the name of the exe if a different one is required.
// (This is NOT a path name - do not put directory or extension)

// Replace "Delphi Add-In 1" with a description of your add-in.
// Replace the text after @= with the full path of your DLL, which may be
// anywhere on the computer.
//
// AlphaCAM will load the DLL at start-up, and call InitAlphacamAddIn()
// Event procedures will be called when the events happen.
// The DLL must have (and export) InitAlphacamAddIn(), the event routines are optional.

uses
  SysUtils,
  ComObj,
  Classes,
  Dialogs,
  Forms,
  Controls,
  Windows,
  ShellAPI,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  AlphaCAMMill_TLB in '..\..\borland\Delphi 3\Imports\AlphaCAMMill_TLB.pas';
  // Use Project | Import type Library to create the AlphaCAMMill_TLB.pas file.
  // When AlphaCAM is updated use the command again. (After running the new version)

///////////////////////////////////////////////////////////
//
// Called when AlphaCAM loads add-in.
// Return 0 if OK, -1 if add-in is not to be loaded

 function InitAlphacamAddIn(vAcam:Variant; version:Integer) : Integer; stdcall;
 var
    acam: IAlphaCamApp;
    frm: IFrame;
 begin
    acam := IDispatch(vAcam) as IAlphaCamApp;
    frm := acam.Frame;

    frm.AddMenuItem2 ('&Pocket Rectangle', 'CmdPocketRectangle', acamMenuNEW, '&DelphiAddin');
    frm.AddMenuItem2 ('&Notepad', 'RunNotepad', acamMenuNEW, '&DelphiAddin');
    frm.AddMenuItem2 ('Licom &Web Site', 'LicomWeb', acamMenuNEW, '&DelphiAddin');

    frm.AddMenuItem2 ('Fillet Geometries in Work Plane', 'CmdWpGeosFillet', acamMenu3D, '');
    frm.AddMenuItem2 ('Find Circles in Layer', 'CmdFindCirclesInLayer', acamMenuUTILS, '');

    frm.AddMenuItem2 ('&Fast Geometry Example', 'CmdFastGeometryEx1', acamMenuGEO, '');

    frm.AddMenuItem2 ('&Set Attributes', 'CmdSetAttributes', acamMenuUTILS, '');
    frm.AddMenuItem2 ('&Read Attributes', 'CmdReadAttributes', acamMenuUTILS, '');

    Result := 0;
 end;

///////////////////////////////////////////////////////////
//
// Called before AlphaCAM shows open file dialog box,
// when user has selected the File / Open command to open an AlphaCAM drawing.
// Add-in may copy name of file to be opened to string,
// and return 1, or return 0 if AlphaCAM is to show normal dialog box,
// or return 2 to cancel the Open command.

   function BeforeOpenFile(vAcam:Variant; file_name:PChar) : Integer; stdcall;
   begin
     Result := 0;
     Application.CreateForm(Tform1, form1);
  if form1.ShowModal = mrOK then   // do not use Show, it closes AlphaCAM
     begin
          if form1.radiogroup1.itemindex = 1 then
          begin
               strcopy(file_name, 'c:\licomdir\123.amd');
               Result := 1;
          end
     end
     else
     begin
         Result := 2; // Cancel
     end;
     form1.free;
    end;

///////////////////////////////////////////////////////////
//
// Called after AlphaCAM has opened and loaded a file.
// file_name is the complete path name of the file that has been opened.

 procedure AfterOpenFile(vAcam:Variant; file_name:PChar) stdcall;
 begin
 end;

///////////////////////////////////////////////////////////
//
// Called before AlphaCAM saves a file with Save command, NOT Save As command
// Add-in may copy name of file to be saved to string,
// and return 1, or return 0 if AlphaCAM is to use current file name.

 function BeforeSaveFile(vAcam:Variant; file_name:PChar) : Integer; stdcall;
 begin
      Result := 0;
 end;

///////////////////////////////////////////////////////////
//
// Called before AlphaCAM shows save file dialog box, for Save As command.
// Add-in may copy name of file to be saved to string,
// and return 1, or return 0 if AlphaCAM is to show normal dialog box.

 function BeforeSaveAsFile(vAcam:Variant; file_name:PChar) : Integer; stdcall;
 begin
      Result := 0;
 end;

///////////////////////////////////////////////////////////
//
// Called after AlphaCAM has saved a file.
// file_name is the complete path name of the file that has been saved.

 procedure AfterSaveFile(vAcam:Variant; file_name:PChar) stdcall;
 begin
 end;

///////////////////////////////////////////////////////////
//
// Called before AlphaCAM shows save file dialog box, for Output NC command.
// Add-in may copy name of file to be saved to string,
// and return 1, or return 0 if AlphaCAM is to show normal dialog box.

 function BeforeOutputNc(vAcam:Variant; file_name:PChar) : Integer; stdcall;
 begin
      Result := 0;
 end;

///////////////////////////////////////////////////////////
//
// Called after AlphaCAM has output NC.
// file_name is the complete path name of the file that has been saved.

 procedure AfterOutputNc(vAcam:Variant; file_name:PChar) stdcall;
 begin
 end;

///////////////////////////////////////////////////////////
//
// Called before AlphaCAM shows open file dialog box to select post.
// Add-in may copy name of file to be opened to string,
// and return 1, or return 0 if AlphaCAM is to show normal dialog box.

 function BeforeOpenPost(vAcam:Variant; file_name:PChar) : Integer; stdcall;
 begin
      Result := 0;
 end;

///////////////////////////////////////////////////////////
//
// Called before AlphaCAM shows open file dialog box to select file to insert
// Add-in may copy name of file to be opened to string,
// and return 1, or return 0 if AlphaCAM is to show normal dialog box.

 function BeforeInsertFile(vAcam:Variant; file_name:PChar) : Integer; stdcall;
 begin
      Result := 0;
 end;

///////////////////////////////////////////////////////////
//
// Called before AlphaCAM shows open file dialog box to select file for input CAD
// Add-in may copy name of file to be opened to string,
// and return 1, or return 0 if AlphaCAM is to show normal dialog box.
// cad_type is an integer giving the type of CAD file that the user has selected
// from the dialog box. It will have one of the following values:
// acamDXF, acamDWG, acamIGES, acamCADL, acamVDA, acamANVIL, acamXYZ, acamSTL

 function BeforeInputCad(vAcam:Variant; cad_type:Integer; file_name:PChar) : Integer; stdcall;
 begin
      Result := 0;
 end;

///////////////////////////////////////////////////////////
//
// Called before AlphaCAM shows open file dialog box to select file for input NC
// Add-in may copy name of file to be opened to string,
// and return 1, or return 0 if AlphaCAM is to show normal dialog box.

 function BeforeInputNc(vAcam:Variant; file_name:PChar) : Integer; stdcall;
 begin
      Result := 0;
 end;

///////////////////////////////////////////////////////////
//
// Called after AlphaCAM has input a CAD file
// cad_type is an integer giving the type of CAD file that the user has selected
// from the dialog box. It will have one of the following values:
// acamDXF, acamDWG, acamIGES, acamCADL, acamVDA, acamANVIL, acamXYZ, acamSTL

 procedure AfterInputCad(vAcam:Variant; cad_type:Integer; file_name:PChar) stdcall;
 begin
 end;

///////////////////////////////////////////////////////////
//
// Called after AlphaCAM has input an NC file

 procedure AfterInputNc(vAcam:Variant; file_name:PChar) stdcall;
 begin
 end;

///////////////////////////////////////////////////////////
//
// If this function exists and returns 1, a button will be placed
// in the Feeds and Speeds dialog box in Rough / Finish, Drilling etc.
// The text for the button should be copied to the text parameter.
// If the button is clicked by the user the NewFeedsAndSpeed function will be called.
// Return 1 to use new text and enable it, 0 to disable button

 function GetFeedsAndSpeedsButtonText(vAcam:Variant; text:PChar) : Integer; stdcall;
 begin
      Result := 0;
//      StrCopy(text, 'Delphi Manager');
//      Result := 1;
 end;

///////////////////////////////////////////////////////////
//
// Called when button in Feeds and Speeds dialog box clicked.
// (See GetFeedsAndSpeedsButtonText).
// Button will only be shown if GetFeedsAndSpeedsButtonText returns 1
// milldata is a MillData object whose properties may be modified if required
// eg DownFeed or CutFeed. Tool is the current tool,
// read-only ie its properties may be read but not changed.
// Return 1 to use new values, 0 to use existing values.

 function NewFeedsAndSpeed (vAcam:Variant; milldata:Variant; tool:Variant) : Integer; stdcall;
 begin
      Result := 0;
//      milldata.CutFeed := 155;
//      Result := 1;
 end;

///////////////////////////////////////////////////////////
//
// Called before AlphaCAM shows tool selection dialog box.
// Add-in may copy name of tool file to be used to string,
// and return 1, or may get the tool from an external database,
// and create and select it using CreateTool call, and return 2,
// or return 0 if AlphaCAM is to show normal dialog box.

 Function BeforeSelectTool (vAcam:Variant; file_name:PChar) : Integer; stdcall;
 var
    acam: IAlphaCamApp;
//    Tool: IMillTool;
 begin
    acam := IDispatch(vAcam) as IAlphaCamApp;
    Result := 0;
//    Tool := acam.CreateTool;
//    Tool.Type_ := acamToolBALL;
//    Tool.Name := 'Delphi: T82, Ball, Dia 15';
//    Tool.Number := 82;
//    Tool.FeedPerTooth := 0.1;
//    Tool.Diameter := 15;
//    Tool.Length := 50;
//    Tool.Note := 'the note';
//    Tool.TPD[1] := 'tpd one';
//    Tool.Select;
//    ShowMessage('T82 Selected');
//    Result := 2;
 end;

///////////////////////////////////////////////////////////
//
// Called after AlphaCAM has selected a tool.
// tool is the new tool.

 procedure AfterSelectTool(vAcam:Variant; vTool:Variant) stdcall;
// var
//    Tool: IMillTool;
 begin
//      Tool := IDispatch(vTool) as IMillTool;
//      ShowMessage(Tool.Name);
 end;

///////////////////////////////////////////////////////////
//
// Called before AlphaCAM defines a tool.

 Function BeforeDefineTool(vAcam:Variant) : Integer; stdcall;
 begin
      ShowMessage('Can not define a tool');
      Result := 1;
 end;

///////////////////////////////////////////////////////////
//
// Example command that can be called from the AlphaCAM menu.
// The command is added to the menu by the statement
//     acam.Frame.AddMenuItem ('&Pocket Rectangle', 'CmdPocketRectangle');
// in the  InitAlphacamAddIn function.
// Note that the procedure (CmdPocketRectangle) must be exported by listing it in
// the exports section at the end of the file.
// The syntax of the procedure heading must be exactly as this one, ie
//  Procedure YourCommandName (vAcam:Variant) stdcall;
// acam is a Variant containing the AlphaCAM Application object
// which can be used to call AlphaCAM methods.

var
   width : double = 200;
   height : double = 150;
   corner_rad: Double = 10;

 Procedure CmdPocketRectangle (vAcam:Variant) stdcall;
 var
   acam: IAlphaCamApp;
   drw: IDrawing;
   geo1, geo2: IPath;
   mc: IMillData;
   I: Integer;
   s: String;
 begin
     acam := IDispatch(vAcam) as IAlphaCamApp;
     // Show dialog box
     Application.CreateForm(Tform2, form2);
  Str(height : 8:2, s);  form2.Edit1.Text := s;
     Str(width : 8:2, s);  form2.Edit2.Text := s;
     Str(corner_rad : 8:2, s);  form2.Edit3.Text := s;
     if form2.ShowModal = mrOK then   // do not use Show, it closes AlphaCAM
     begin
     Val(form2.Edit1.text, height, I);
     Val(form2.Edit2.text, width, I);
     Val(form2.Edit3.text, corner_rad, I);
     // Draw a rectangle
     drw := acam.ActiveDrawing;
     geo1 := drw.CreateRectangle(-width / 2, 0, width / 2, height);
     // Fillet the rectangle
     geo1.Fillet (corner_rad);
     // Put ghost tool on inside
     geo1.ToolInOut := acamINSIDE;
     // Draw a circle
     geo2 := drw.CreateCircle (height * 0.6, 0, height / 2);
     // Put ghost tool on outside
     geo2.ToolInOut := acamOUTSIDE;
     // Select the two geometries
     geo1.Selected := True;
     geo2.Selected := True;

     // Select a tool and pocket the selected geometries
     acam.SelectTool ('C:\licomdat\mtools.alp\Flat - 10mm.amt');
     mc := acam.CreateMillData;
     mc.PocketType := acamPocketCONTOUR;
     mc.SafeRapidLevel := 20;
     mc.RapidDownTo := 1;
     mc.FinalDepth := -8;
     mc.WidthOfCut := 7.5;
     mc.Stock := 1;
     mc.Pocket;
     drw.ZoomAll;
     end;
 end;

///////////////////////////////////////////////////////////
//
// Function copied from Delphi demo example (FILMANEX\FMXUTILS.PAS)
// to show how to run an external program. Note that the function
// uses Application.MainForm.Handle which is not valid in a DLL
// as there is no main form or window. 0 should be passed as the
// first parameter.
// Also note that this function can be used to access a Web Site.
// This assumes that your system has a Web Browser correctly installed.

function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..79] of Char;
begin
//  Result := ShellExecute(Application.MainForm.Handle, nil,    // NO!! MainForm is 0
  Result := ShellExecute(0, nil,
    StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;

 Procedure RunNotepad (vAcam:Variant) stdcall;
 begin
      // Run Notepad and return immediately
      ExecuteFile ('notepad.exe', '', '', SW_SHOW);  // Delphi routine

      // Run Notepad and wait until Notepad exits
//      acam.ShellAndWait ('notepad.exe');              // AlphaCAM routine
 end;

 Procedure LicomWeb (vAcam:Variant) stdcall;
 begin
      ExecuteFile ('http://www.licom.com', '', '', SW_SHOW);
 end;

///////////////////////////////////////////////////////////
//
// Example command to fillet all geometries in the current work plane

 Procedure CmdWpGeosFillet (vAcam:Variant) stdcall;
 var
   acam: IAlphaCamApp;
   drw: IDrawing;
   wp: IWorkPlane;
   paths: IPaths;
   path: IPath;
   I: Integer;
 begin
     acam := IDispatch(vAcam) as IAlphaCamApp;
     drw := acam.ActiveDrawing;

     // Is there a current work plane?
     wp := drw.GetWorkPlane;
     if wp <> nil then
     begin
          // Yes there is, get the collection of geometries in this work plane
          paths := wp.Geometries;
          // Loop for each geometry
          for I := 1 to paths.Count do
          begin
               path := paths.Item(I);
               path.Fillet(5);
          end;
     end;
 end;

///////////////////////////////////////////////////////////
//
// Enable / disable menu item for command CmdWpGeosFillet.
// Enable if there is a current work plane.

 Function OnUpdateCmdWpGeosFillet (vAcam:Variant) : Integer; stdcall;
 var
   acam: IAlphaCamApp;
   drw: IDrawing;
   wp: IWorkPlane;
 begin
     acam := IDispatch(vAcam) as IAlphaCamApp;
     drw := acam.ActiveDrawing;

     wp := drw.GetWorkPlane;
     if wp <> nil then
         Result := 1 // enable
     else
         Result := 0; // disable
 end;

///////////////////////////////////////////////////////////
//
// Find included angle of arcs in given path

function PathIncludedAngle(path:IPath): double ;
var
   ang: double;
   I: Integer;
   elems: IElements;
begin
     elems := path.Elements;
     ang := 0;
     for I := 1 to elems.Count do
     begin
          ang := ang + elems.Item(I).IncludedAngle;
     end;
     Result := ang;
end;

///////////////////////////////////////////////////////////
//
// Example command to find all circles in the current layer

 Procedure CmdFindCirclesInLayer (vAcam:Variant) stdcall;
 var
   acam: IAlphaCamApp;
   drw: IDrawing;
   layer: ILayer;
   paths: IPaths;
   path: IPath;
   I, N: Integer;
   CP: ICircleProperties;
 begin
     acam := IDispatch(vAcam) as IAlphaCamApp;
     drw := acam.ActiveDrawing;

     // Is there a current layer?
     layer := drw.GetLayer;
     if layer <> nil then
     begin
          // Yes there is, get the collection of geometries in this layer
          paths := layer.Geometries;
          N := 0;
          // Loop for each geometry
          for I := 1 to paths.Count do
          begin
               path := paths.Item(I);
               CP := path.GetCircleProperties;
               if CP <> nil then
               begin
                    if PathIncludedAngle(path) > 359.99 then
                    begin
                       path.Selected := True;
                       path.Redraw;
                       N := N + 1;
                    end;
               end;
          end;
          if N > 0 then
          begin
              ShowMessageFmt ('%d Circles found', [N]);
              paths.Selected := False;    // de-select all in layer
              paths.Redraw;
          end;
     end;
 end;
///////////////////////////////////////////////////////////
//
// Enable / disable menu item for command CmdFindCirclesInLayer.
// Enable if there is a current layer

 Function OnUpdateCmdFindCirclesInLayer (vAcam:Variant) : Integer; stdcall;
 var
   acam: IAlphaCamApp;
   drw: IDrawing;
   layer: ILayer;
 begin
     acam := IDispatch(vAcam) as IAlphaCamApp;
     drw := acam.ActiveDrawing;

     layer := drw.GetLayer;
     if layer <> nil then
         Result := 1 // enable
     else
         Result := 0; // disable
 end;

///////////////////////////////////////////////////////////
//
// Example command to draw a geometry using Fast Geometry

 Procedure CmdFastGeometryEx1 (vAcam:Variant) stdcall;
 var
   acam: IAlphaCamApp;
   drw: IDrawing;
   path: IPath;
   fg: IFastGeometry;
   vtMissing: OleVariant;
 begin
      // Set up a Variant to represent an Unknown value, for Optional parameters
     TVarData(vtMissing).VType := varError;
     TVarData(vtMissing).VError := $80020004;

     acam := IDispatch(vAcam) as IAlphaCamApp;
     drw := acam.ActiveDrawing;
     fg := drw.CreateFastGeometry;

     fg.KnownArc (50, True, 0., 0., 90., vtMissing);

     fg.ArcToArc (20., False, False);

     fg.KnownArc (25, True, 100., 10., vtMissing, vtMissing);

     // X is unknown (vtMissing) so DirIn is given
     fg.LineToLineBlend (5., vtMissing, -50., 260., vtMissing, vtMissing, vtMissing);

     path := fg.CloseAndFinish ();

     path.ToolInOut := acamOUTSIDE;
 end;

Const ATTR1 = 'LicomUKdmbManualExampleTest1';
Const ATTR2 = 'LicomUKdmbManualExampleTest2';

///////////////////////////////////////////////////////////
//
// Example command to set attributes

Procedure CmdSetAttributes (vAcam:Variant) stdcall;
var
   acam: IAlphaCamApp;
   Drw: IDrawing;
   PS: IPaths;
   P1: IPath;
   X: Double;
   I, CH: Integer;
begin
     acam := IDispatch(vAcam) as IAlphaCamApp;
     Drw := acam.ActiveDrawing;

    X := 0.5;
    For CH := 65 To 69 do
    begin
        PS := Drw.CreateText(Chr(CH), X, 0, 10);
        For I := 1 to PS.Count do
        begin
            P1 := PS.Item(I);
            P1.Attribute[ATTR1] := Chr(CH);
        end;
        X := X + 20;
    end;
end;

///////////////////////////////////////////////////////////
//
// Example command to read attributes

Procedure CmdReadAttributes (vAcam:Variant) stdcall;
var
   acam: IAlphaCamApp;
   Drw: IDrawing;
   P1: IPath;
   Attr: OleVariant;
begin
     acam := IDispatch(vAcam) as IAlphaCamApp;
     Drw := acam.ActiveDrawing;

     repeat
          P1 := Drw.UserSelectOneGeo('Select a Geometry');
          if P1 <> nil then
          begin
              Attr := P1.Attribute[ATTR1];
              if VarType(Attr) <> varEmpty then
                 ShowMessage (Attr);
          end;
     until P1 = nil
end;

  exports
  InitAlphacamAddIn,
  BeforeOpenFile,
  AfterOpenFile,
  BeforeSaveFile,
  BeforeSaveAsFile,
  AfterSaveFile,
  BeforeOutputNc,
  AfterOutputNc,
  BeforeOpenPost,
  BeforeInsertFile,
  BeforeInputCad,
  BeforeInputNc,
  AfterInputCad,
  AfterInputNc,
  NewFeedsAndSpeed,
  GetFeedsAndSpeedsButtonText,
  BeforeSelectTool,
  AfterSelectTool,
  BeforeDefineTool,
  CmdPocketRectangle,
  RunNotepad,
  LicomWeb,
  CmdWpGeosFillet,
  OnUpdateCmdWpGeosFillet,
  CmdFindCirclesInLayer,
  OnUpdateCmdFindCirclesInLayer,
  CmdFastGeometryEx1,
  CmdSetAttributes,
  CmdReadAttributes;
begin
end.

