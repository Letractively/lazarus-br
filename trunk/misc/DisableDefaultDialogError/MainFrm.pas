unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  LResources, Forms, StdCtrls, SysUtils;

type

  { TMainForm }

  TMainForm = class(TForm)
    ProvokeErrorButton: TButton;
    procedure ProvokeErrorButtonClick(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

uses
  DisableDefaultDialogError;

{ TMainForm }

procedure TMainForm.ProvokeErrorButtonClick(Sender: TObject);
begin
  StrToInt('a');
end;

initialization
  {$I MainFrm.lrs}
  //TDisableDefaultDialogError.Register;
  TDisableDefaultDialogError.Register(ndtAsterick);

end.
