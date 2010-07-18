unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls, SysUtils;

type

  { TMainForm }

  TMainForm = class(TForm)
    ProvokeErrorButton: TButton;
    procedure ProvokeErrorButtonClick(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  DisableDefaultDialogError;

{ TMainForm }

procedure TMainForm.ProvokeErrorButtonClick(Sender: TObject);
begin
  StrToInt('a');
end;

initialization
  //TDisableDefaultDialogError.Register;
  TDisableDefaultDialogError.Register(ndtAsterick);

end.

