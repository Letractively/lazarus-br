unit UPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TBox }

  TBox = class(TFrame)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Box: TBox;

implementation
{$R *.lfm}
{ TBox }

procedure TBox.Button1Click(Sender: TObject);
begin
  ShowMessage('LCL em Biblioteca....');
end;

procedure TBox.FormClick(Sender: TObject);
begin
  ShowMessage('aaaa');
end;

end.

