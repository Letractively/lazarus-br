unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, StdCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    StartButton: TButton;
    UseThreadCheckBox: TCheckBox;
    DisplayLabel: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
  end; 

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

var
  _ThreadID: TThreadID;

procedure HeavyProcess;
var
  I: Integer = 0;
begin
  while I < 1000 do
  begin
    MainForm.DisplayLabel.Caption := IntToStr(I);
    Sleep(4);
    Inc(I);
  end;
end;

{ TMainForm }

procedure TMainForm.StartButtonClick(Sender: TObject);
begin
  if UseThreadCheckBox.Checked then
    _ThreadID := BeginThread(TThreadFunc(@HeavyProcess))
  else
    HeavyProcess;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if _ThreadID <> 0 then
    SuspendThread(_ThreadID);
end;

end.

