unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, Forms, LResources, StdCtrls;

type

  TThreadTimer = class;

  { TMainForm }

  TMainForm = class(TForm)
    ClockLabel: TLabel;
    ClockCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ClockCheckBoxClick(Sender: TObject);
  private
    FTimer: TThreadTimer;
  public
    procedure OnTimer(Sender: TObject);
    property Timer: TThreadTimer read FTimer write FTimer;
  end;

  TThreadTimer = class(TThread)
  private
    FOnTimer: TNotifyEvent;
    FEnabled: Boolean;
    FInterval: Integer;
    procedure SetEnabled(const Value: Boolean);
    procedure SetInterval(const Value: Integer);
  protected
    procedure GetEvent;
    procedure Execute; override;
  public
    constructor Create;
  published
    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
    property Interval: Integer read FInterval write SetInterval default 1000;
    property Enabled: Boolean read FEnabled write SetEnabled default False;
  end;

var
  MainForm: TMainForm;

implementation

{ TThreadTimer }

constructor TThreadTimer.Create;
begin
  inherited Create(True);
  FInterval := 1000;
  FEnabled := False;
  FOnTimer := nil;
end;

procedure TThreadTimer.Execute;
begin
  while not Terminated do
  begin
    Sleep(FInterval);
    if FEnabled and Assigned(FOntimer) then
      Synchronize(@GetEvent)
    else
      Sleep(100);
  end;
end;

procedure TThreadTimer.GetEvent;
begin
  FOnTimer(Self);
end;

procedure TThreadTimer.SetEnabled(const Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    if Value and Suspended then
      Resume;
  end;
end;

procedure TThreadTimer.SetInterval(const Value: Integer);
begin
  FInterval := Value;
  if Value = 0 then
    Enabled := False;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FTimer := TThreadTimer.Create;
  FTimer.OnTimer := @OnTimer;
  FTimer.Enabled := True;
  FTimer.OnTimer(Self);
  ClockLabel.Parent.DoubleBuffered := True;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FTimer.Free;
end;

procedure TMainForm.OnTimer(Sender: TObject);
begin
  ClockLabel.Caption := TimeToStr(Time);
end;

procedure TMainForm.ClockCheckBoxClick(Sender: TObject);
begin
  FTimer.Enabled := ClockCheckBox.Checked;
end;

initialization
  {$I MainFrm.lrs}

end.

