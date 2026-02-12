program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  AlphaCAMMill_TLB in '..\..\borland\Delphi 3\Imports\AlphaCAMMill_TLB.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
