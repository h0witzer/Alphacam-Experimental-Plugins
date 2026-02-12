unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComObj, StdCtrls, AlphaCAMMill_TLB;

type
  TForm1 = class(TForm)
    Button3: TButton;
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

///////////////////////////////////////////////////////////
//
// Run 5-axis Mill

procedure TForm1.Button3Click(Sender: TObject);
var
   acam: IAlphaCamApp;
   drw: IDrawing;
   p1: IPath;
begin
       // Create the required Object eg Advanced Mill or Basic Mill etc
       // Return value from CreateOleObject is an IDispatch interface.
       // The "As" operator is used to QueryInterface for the IAlphaCamApp interface.
       // Do NOT use acam := CoApp.Create;
       // This will get the exe that was last run and matches the library ie any Mill exe
       // CreateOleObject ensures that the required one is run.
       // NOTE: The try ... except does not trap the error when in the IDE, only when the exe is run standalone
     try
           acam := CreateOleObject ('am5axaps.application') as IAlphaCamApp;
     except
           ShowMessage('Error running AlphaCAM');
           exit;
     end;

     try
          drw := acam.OpenDrawing (acam.LicomdirPath + '\licomdir\Tutorial\Mill Simple Shape + tool paths.amd');
     except
           ShowMessage('File not found');
//           exit;
     end;

     drw := acam.ActiveDrawing;

     p1 := drw.CreateRectangle (-150, -50, 150, 200);
     drw.ZoomAll;
     p1.Fillet (10);
     acam.Visible := true;

     // acam is a valid App pointer which can be used to access other
     // AlphaCAM objects. See the DLL example.
end;

end.
