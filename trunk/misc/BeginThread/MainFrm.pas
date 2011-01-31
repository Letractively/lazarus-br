unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, StdCtrls, Classes;

type

  { TMainForm }

  TMainForm = class(TForm)
    StartButton: TButton;
    UseThreadCheckBox: TCheckBox;
    DisplayLabel: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
  protected
    procedure DoUpdateDisplay;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

var
  _ThreadID: TThreadID;
  _ProgressValue: Integer = 0;

procedure HeavyProcess;
begin
  while _ProgressValue < 1000 do
  begin
    Inc(_ProgressValue);
    Sleep(4);
    TThread.Synchronize(nil, @MainForm.DoUpdateDisplay);
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

procedure TMainForm.DoUpdateDisplay;
begin
  DisplayLabel.Caption := IntToStr(_ProgressValue);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if _ThreadID <> 0 then
    SuspendThread(_ThreadID);
end;

end.

