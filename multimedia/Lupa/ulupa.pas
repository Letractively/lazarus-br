unit ulupa;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Graphics, ExtCtrls, StdCtrls, ComCtrls, Buttons;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    CloseBitBtn: TBitBtn;
    grpZoom: TGroupBox;
    imgLupa: TImage;
    lbl2x: TLabel;
    lbl4x: TLabel;
    lbl6x: TLabel;
    lbl8x: TLabel;
    tkrZoom: TTrackBar;
    tmrLupa: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tmrLupaTimer(Sender: TObject);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

uses
  LCLIntf;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Top := 2;
  Left := 2;
  DoubleBuffered := True;
end;

{$HINTS OFF}
procedure TfrmMain.tmrLupaTimer(Sender: TObject);
var
  Pt: TPoint;
  Canv: TCanvas;
  SrcRect, DestRect: TRect;
begin
  GetCursorPos(Pt);
  SetRect(DestRect, 0, 0, imgLupa.Width, imgLupa.Height);
  SetRect(SrcRect, Pt.X, Pt.Y, Pt.X, Pt.Y);
  InflateRect(SrcRect, Round(imgLupa.Width / (tkrZoom.Position * 4)),
    Round(imgLupa.Height / (tkrZoom.Position * 4)));
  Canv := TCanvas.Create;
  try
    Canv.Handle := GetDC(0);
    imgLupa.Picture := nil;
    imgLupa.Canvas.CopyRect(DestRect, Canv, SrcRect);
  finally
    FreeAndNil(Canv);
  end;
end;
{$HINTS ON}

end.
