unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  uFuncs_Dialogs;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  TDialogs.ExecTime('Responda logo', 'Vai ou não?', False, 30, mtWarning);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i : TModalResult;
begin
  i := TDialogs.ExecTime('vamos lá', 'escolha', mtConfirmation, mbYesNoCancel, mbCancel, 5);
  ShowMessage(IntToStr(i));
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i : TModalResult;
begin
  i := TDialogs.ExecTime('vamos lá', 'escolha', mtInformation, [mbIgnore, mbRetry, mbCancel, mbAll], mbRetry, 5);
  ShowMessage(IntToStr(i));
end;

end.

