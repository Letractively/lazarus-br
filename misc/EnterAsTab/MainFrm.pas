unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, Controls, StdCtrls, LMessages, LCLType;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Memo1: TMemo;
    procedure FormShortCut(var Msg: TLMKey; var Handled: Boolean);
  end; 

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormShortCut(var Msg: TLMKey; var Handled: Boolean);
var
  VCurrentControl: TControl;
begin
  VCurrentControl := Screen.ActiveControl;
  if not (VCurrentControl is TButtonControl) and (Msg.CharCode = VK_RETURN) then
  begin
    Handled := True;
    Msg.Result := -1;
    SelectNext(Screen.ActiveControl, True, True);
  end;
end;

end.

