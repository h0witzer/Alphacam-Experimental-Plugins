library FastPost;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  ComObj,
  Classes,
  Dialogs,
  Forms,
  Controls,
  Windows,
  ShellAPI,
  AlphaCAMMill_TLB in '..\..\borland\Delphi 3\Imports\AlphaCAMMill_TLB.pas';

///////////////////////////////////////////////////////////
//
// Called when AlphaCAM loads add-in.
// Return 0 if OK, -1 if add-in is not to be loaded

 function InitAlphacamAddIn(vAcam:Variant; version:Integer) : Integer; stdcall;
 var
    acam: IAlphaCamApp;
 begin
    acam := IDispatch(vAcam) as IAlphaCamApp;
    acam.Frame.AddMenuItem2 ('&Fast Post', 'CmdFastPost', acamMenuFILE, '');
    Result := 0;
 end;

 Procedure CmdFastPost (vAcam:Variant) stdcall;
  var
   acam: IAlphaCamApp;
   f: TextFile;
   drw: IDrawing;
   tp: IPath;
   tps: IPaths;
   elem: IElement;
   elems: IElements;
   ipath, npath, ielem, nelem: Integer;
   x1, y1, z1: double;
 begin
    acam := IDispatch(vAcam) as IAlphaCamApp;
     AssignFile(f, 'C:\temp\nc.anc');
     ReWrite(f);
    drw := acam.ActiveDrawing;
    tps := drw.ToolPaths;
    npath := tps.Count;
    WriteLn(f, 'START');
    for ipath := 1 to npath do
    begin
         tp := tps.Item(ipath);
         elems := tp.Elements;
         nelem := elems.Count;
         for ielem := 1 to nelem do
         begin
              elem := elems.Item(ielem);
              x1 := elem.StartXG;
              y1 := elem.StartYG;
              z1 := elem.StartZG;
              WriteLn(f, 'G1 X', x1:8:3, ' Y', y1:8:3, ' Z', z1:8:3);
         end;
    end;
    CloseFile(f);
    ShowMessage('Nc Output Finished');
 end;

  exports
  InitAlphacamAddIn,
  CmdFastPost;
end.
