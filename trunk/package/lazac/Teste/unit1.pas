unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, LazAC, LazAC_Type;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LazAC1: TLazAC;
    Memo1: TMemo;
    ODialog: TOpenDialog;
    Timer1: TTimer;
    TrackBar1: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBar1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 
  TrackMouse:Boolean=False;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  Msec:Comp;
  STime:TTimeStamp;
begin
  if ODialog.Execute then
    Edit1.Text:= ODialog.FileName;

  if (Edit1.Text <> '') then
    if not(LazAC1.OpenFile(Edit1.Text)) then Exit;

  TrackBar1.Max:= Trunc(Trunc(LazAC1.GetTotalTime));
  TrackBar1.Position:=0;
  //--
  Memo1.Text:= LazAC1.Comments.Text;

  //--
  //Recebe o tempo total em Segundos e treansforma em Milesegundo
  //Trunc separa a parte inteira do Double
  MSec:= Trunc(LazAC1.GetTotalTime) * 1000;
  //Transforma Milesegundos em TimeStamp
  STime:= MSecsToTimeStamp(MSec);
  //Transforma TimeStamp em TDateTime
  Label2.Caption:= FormatDateTime('hh:mm:ss', TimeStampToDateTime(STime));
  //--
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 if (Edit1.Text <> '') then
   if not(LazAC1.OpenFile(Edit1.Text)) then Exit;

  LazAC1.Play;
  Timer1.Enabled:= True;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  LazAC1.Pause;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  LazAC1.Stop;
  LazAC1.Close;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  Msec:Comp;
  STime:TTimeStamp;
begin
  if LazAC1.Status=acStop then
    begin
      Timer1.Enabled:=False;
      TrackBar1.Position:=0;
      Label4.Caption:= FormatDateTime('hh:mm:ss', 0);
      Exit;
    end
  else
    begin
      ///--
      //Processo semelhante ao  do procedimento Button1Click
      MSec:= Trunc(LazAC1.GetTime) * 1000;
      STime:= MSecsToTimeStamp(MSec);
      Label4.Caption:= FormatDateTime('hh:mm:ss', TimeStampToDateTime(STime));
      if not(TrackMouse) then
        TrackBar1.Position:= Trunc(LazAC1.GetTime);
    end;
end;

procedure TForm1.TrackBar1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  TrackMouse:=True;
end;

procedure TForm1.TrackBar1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  LazAC1.SeekTime(TrackBar1.Position);
  TrackMouse:=False;
end;

end.

