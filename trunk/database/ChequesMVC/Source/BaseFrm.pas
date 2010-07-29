(*
  Cheques 2.1, Controle pessoal de cheques.
  Copyright (C) 2010-2012 Everaldo - arcanjoebc@gmail.com

  See the file LGPL.2.1_modified.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

(*
  Powerfull contributors:
  Silvio Clecio - http://blog.silvioprog.com.br
  Joao Morais   - http://blog.joaomorais.com.br
  Luiz Americo  - http://lazarusroad.blogspot.com
*)

unit BaseFrm;

{$I cheques.inc}

interface

uses
  Forms, LCLType, XMLPropStorage, StdCtrls, Graphics, Classes, ChequeConsts,
  LMessages, SysUtils;

type

  { TBaseForm }

  TBaseForm = class(TForm)
  private
    FOldOnShow: TNotifyEvent;
    FOldOnClose: TCloseEvent;
    FXMLPropStorage: TXMLPropStorage;
    procedure InternalOnShow(Sender: TObject); virtual;
    procedure InternalOnClose(Sender: TObject; var CloseAction: TCloseAction); virtual;
    procedure InternalOnUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char); virtual;
    procedure InternalOnShortCut(var Msg: TLMKey; var Handled: Boolean);
  public
    class procedure CreateView(var AForm); virtual;
    class function Execute(var AForm): Integer; virtual;
    class function Execute: Integer; reintroduce;
    class procedure OpenHelp(const AHelpFileName: string = '');
    constructor Create(TheOwner: TComponent); override;
    procedure OnExecute; virtual;
    procedure OnTerminate; virtual;
    procedure OnComponentCount(AComponent: TComponent); virtual;
    property XMLPropStorage: TXMLPropStorage read FXMLPropStorage write FXMLPropStorage;
  end;

implementation

{$R *.lfm}

uses
  LCLIntf;

{ TBaseForm }

procedure TBaseForm.InternalOnUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
begin
  if UTF8Key = #27 then
  begin
    UTF8Key := #0;
    Close;
  end;
end;

constructor TBaseForm.Create(TheOwner: TComponent);
var
  I: Integer;
begin
  inherited Create(TheOwner);
{$ifdef SaveFormSettings}
  FXMLPropStorage := TXMLPropStorage.Create(Self);
{$endif}
  SessionProperties := CDefaultSessionProperties;
  ShowInTaskBar := stNever;
  Position := poDesktopCenter;
  KeyPreview := True;
{$ifdef unix}
  Font.Name := 'Default';
  Font.Size := 9;
{$endif}
{$ifdef mswindows}
  Font.Name := 'Default';
  Font.Size := 9;
{$endif}
  OnUTF8KeyPress := @InternalOnUTF8KeyPress;
  OnShortcut := @InternalOnShortCut;
  OnShow := @InternalOnShow;
  OnClose := @InternalOnClose;
  for I := 0 to Pred(ComponentCount) do
  begin
{$ifdef AllCheckBoxNoParentColor}
    // Avoids error marking in CheckBox (bug in Ubuntu)
    if Components[I] is TCustomCheckBox then
    begin
      TCheckBox(Components[I]).ParentColor := False;
      TCustomCheckBox(Components[I]).Color := clBtnFace;
    end;
{$endif}
    OnComponentCount(Components[I]);
  end;
end;

procedure TBaseForm.OnExecute;
begin
end;

procedure TBaseForm.OnTerminate;
begin
end;

{$HINTS OFF}
procedure TBaseForm.OnComponentCount(AComponent: TComponent);
begin
end;

procedure TBaseForm.InternalOnShortCut(var Msg: TLMKey; var Handled: Boolean);
begin
  if Msg.CharCode = VK_F1 then
  begin
    OpenHelp;
    Msg.Result := -1;
    Abort; // Resolve duplicate event bug
  end;
end;
{$HINTS ON}

procedure TBaseForm.InternalOnShow(Sender: TObject);
begin
  SelectFirst;
  OnExecute;
  if Assigned(FOldOnShow) then
    FOldOnShow(Sender);
end;

procedure TBaseForm.InternalOnClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  OnTerminate;
  if Assigned(FOldOnClose) then
    FOldOnClose(Sender, CloseAction);
end;

class procedure TBaseForm.CreateView(var AForm);
begin
  if not Assigned(TObject(AForm)) then
    Application.CreateForm(Self, AForm);
end;

class function TBaseForm.Execute(var AForm): Integer;
var
  VBaseForm: TBaseForm;
begin
  if not Assigned(TObject(AForm)) then
    CreateView(AForm);
  VBaseForm := TBaseForm(AForm);
  try
    Result := VBaseForm.ShowModal;
  finally
    VBaseForm := nil;
    TBaseForm(AForm) := nil;
  end;
end;

class function TBaseForm.Execute: Integer;
begin
  with Self.Create(nil) do
    try
      Result := ShowModal;
    finally
      Free;
    end;
end;

class procedure TBaseForm.OpenHelp(const AHelpFileName: string);
begin
  if AHelpFileName = '' then
    OpenURL(CHelpFileName)
  else
    OpenURL(AHelpFileName);
end;

end.

