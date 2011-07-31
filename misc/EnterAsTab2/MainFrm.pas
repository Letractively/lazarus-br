unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls, Controls, Buttons, ExtCtrls, Classes, Dialogs;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
var
  VWinControl: TWinControl;
begin
  if Key = #13 then
  begin
    VWinControl := ActiveControl.Parent;
    if Assigned(VWinControl) then
    begin
      while Assigned(VWinControl.Parent) do
        VWinControl := VWinControl.Parent;
      if not ((ActiveControl is TButtonControl) or
        (ActiveControl is TCustomMemo)) then
      begin
        VWinControl.SelectNext(ActiveControl, True, True);
        Key := #0;
      end;
    end;
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  ShowMessage(TButton(Sender).Name);
end;

end.

