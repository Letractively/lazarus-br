unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LazAC;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    LazAC1: TLazAC;
    ODialog: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  if ODialog.Execute then
    begin
      Edit1.Text:= ODialog.FileName;
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if FileExists(Edit1.Text) then
    if not(LazAC1.Play(Edit1.Text)) then ShowMessage('Falhou!!! :[');
end;

end.

