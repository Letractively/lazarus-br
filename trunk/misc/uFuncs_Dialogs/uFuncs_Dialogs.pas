unit uFuncs_Dialogs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Forms, ExtCtrls;

type

  { TDialogs }

  TDialogs = class
  public
    class function ExecTime(const ACaption, AMens : string; DlgType : TMsgDlgType;
        Buttons : TMsgDlgButtons; DefBtn : TMsgDlgBtn; AWaitInSegs : Word; out IsDef : Boolean) : TModalResult; overload;
    class function ExecTime(const ACaption, AMens : string; DlgType : TMsgDlgType;
        Buttons : TMsgDlgButtons; DefBtn : TMsgDlgBtn; AWaitInSegs : Word) : TModalResult; overload;
    class function ExecTime(const aCaption, aMsg : string; AYesDefault : Boolean;
                    AWaitInSegs : Word; out IsDef : Boolean; ADlgType : TMsgDlgType = mtConfirmation) : Boolean; overload;
    class function ExecTime(const aCaption, aMsg : string; AYesDefault : Boolean;
                                         AWaitInSegs : Word; ADlgType : TMsgDlgType = mtConfirmation) : Boolean; overload;
  public
    const
      BtnsYesNo : array[Boolean] of TMsgDlgBtn = (mbNo, mbYes);
  end;

implementation

uses StdCtrls, Controls;

type
  { TTimerBtn }

  TTimerBtn = class(TTimer)
  strict private
    Ffrm: TCustomForm;
    btn : TCustomButton;
    Cap : string;
    procedure TimerEvent(Sender : TObject);
  public
    constructor Create(AOwner : TCustomForm; ABtn : TCustomButton; Counts : Integer); overload; reintroduce;
  end;

constructor TTimerBtn.Create(AOwner: TCustomForm; ABtn: TCustomButton; Counts: Integer);
begin
  inherited Create(AOwner);
  btn := ABtn;
  Ffrm := AOwner;

  if ABtn <> nil then
    Cap := ABtn.Caption;

  Interval := 1000;
  Tag := Counts;
  Enabled := True;
  OnTimer := @TimerEvent;
end;

procedure TTimerBtn.TimerEvent(Sender : TObject);
begin
  Tag := Tag - 1;
  if Tag < 1 then
  begin
    Enabled := False;
    if btn <> nil then
      TButton(btn).Click
    else if Ffrm <> nil then
      Ffrm.Close();

    Exit;
  end else if btn <> nil then
    btn.Caption := Cap+'('+IntToStr(Tag)+')';
end;

{ TDialogs }

function BtnToModalResult(AType : TMsgDlgBtn) : TModalResult;
begin
  case AType of
    mbYes: Result := mrYes;
    mbNo: Result := mrNo;
    mbOK: Result := mrOK;
    mbCancel: Result := mrCancel;
    mbAbort: Result := mrAbort;
    mbRetry: Result := mrRetry;
    mbIgnore: Result := mrIgnore;
    mbAll: Result := mrAll;
    mbNoToAll: Result := mrNoToAll;
    mbYesToAll: Result := mrYesToAll;
    //mbHelp: Result := mrHelp;
    {$ifdef FPC}
    mbClose: Result := mrClose;
    {$Endif}
    else Result := 0;
  end;
end;

class function TDialogs.ExecTime(const ACaption, AMens : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons;
  DefBtn : TMsgDlgBtn; AWaitInSegs : Word; out IsDef : Boolean) : TModalResult;

  function GetBtnByType (f : TWinControl; AType : TModalResult) : TCustomButton;
  var
    i: Integer;
  begin
    for i := 0 to f.ControlCount - 1 do
    begin
      if not (f.Controls[i] is TCustomButton) then Continue;

      Result := TCustomButton(f.Controls[i]);
      if Result.ModalResult = AType then
        Exit;
    end;
    Result := nil;
  end;

var
  f : TForm;
  t : TTimer;
  vBtn : TCustomButton;
begin
  f := Dialogs.CreateMessageDialog(AMens, DlgType, Buttons);
  try
    if ACaption <> '' then
      f.Caption := ACaption;

    vBtn := GetBtnByType(f, BtnToModalResult(DefBtn));
    if vBtn <> nil then
      vBtn.Default := True;

    t := TTimerBtn.Create(f, vBtn, AWaitInSegs);

    f.Position := poScreenCenter;
    Result := f.ShowModal;
    IsDef := not t.Enabled;
  finally
    f.Free;
  end;
end;

class function TDialogs.ExecTime(const ACaption, AMens : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons;
  DefBtn : TMsgDlgBtn; AWaitInSegs : Word) : TModalResult;
var
  B : Boolean;
begin
  Result := Self.ExecTime(ACaption, AMens, DlgType, Buttons, DefBtn, AWaitInSegs, B);
end;

class function TDialogs.ExecTime(const aCaption, aMsg : string; AYesDefault : Boolean; AWaitInSegs : Word; out
  IsDef : Boolean; ADlgType : TMsgDlgType) : Boolean;
begin
  Result := Self.ExecTime(aCaption, aMsg, ADlgType, mbYesNo, BtnsYesNo[AYesDefault], AWaitInSegs, IsDef) = mrYes;
end;

class function TDialogs.ExecTime(const aCaption, aMsg : string; AYesDefault : Boolean; AWaitInSegs : Word;
  ADlgType : TMsgDlgType) : Boolean;
var
  B : Boolean;
begin
  Result := Self.ExecTime(aCaption, aMsg, AYesDefault, AWaitInSegs, B, ADlgType)
end;

end.
