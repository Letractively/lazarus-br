{
  DBMaskEdit - dbmaskedit.pas

  Copyright (C) 2010 Silvio Clecio - admin@silvioprog.com.br

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}

{
  Contributors:
  Luiz Americo - luizamericop@gmail.com
}

unit DBMaskEdit;

{$mode objfpc}{$H+}

interface

uses
  LResources, LMessages, LCLType, Classes, SysUtils, MaskEdit, DBCtrls, DB, LCLVersion;

type

  { TCustomDBMaskEdit }

  TCustomDBMaskEdit = class(TCustomMaskEdit)
  private
    FDataLink: TFieldDataLink;
    procedure DataChange(Sender: TObject);
    procedure UpdateData(Sender: TObject);
    procedure FocusRequest(Sender: TObject);
    procedure ActiveChange(Sender: TObject);
    procedure LayoutChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    procedure SetDataField(const AValue: string);
    procedure SetDataSource(AValue: TDataSource);
    function IsReadOnly: Boolean;
    procedure CMGetDataLink(var Message: TLMessage); message CM_GETDATALINK;
  protected
    function GetReadOnly: Boolean; override;
    procedure SetReadOnly(AValue: Boolean); override;
    procedure KeyDown(var Key: word; Shift: TShiftState); override;
    procedure UTF8KeyPress(var UTF8Key: TUTF8Char); override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function EditCanModify: Boolean; override;
    function GetEditText: string; override;
    procedure Change; override;
    procedure Reset; override;
    procedure WMSetFocus(var Message: TLMSetFocus); message LM_SETFOCUS;
    procedure WMKillFocus(var Message: TLMKillFocus); message LM_KILLFOCUS;
    procedure LMPasteFromClip(var Message: TLMessage); message LM_PASTE;
    procedure LMCutToClip(var Message: TLMessage); message LM_CUT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Field: TField read GetField;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
  end;

  { TDBMaskEdit }

  TDBMaskEdit = class(TCustomDBMaskEdit)
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderSpacing;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property DataField;
    property DataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property EditMask;
    property Enabled;
    property Font;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property SpaceChar;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnUTF8KeyPress;
  end;

procedure Register;

implementation

uses
  MaskUtils;

{ TCustomDBMaskEdit }

constructor TCustomDBMaskEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := @DataChange;
  FDataLink.OnUpdateData := @UpdateData;
  FDataLink.OnActiveChange := @ActiveChange;
  FDataLink.OnLayoutChange := @LayoutChange;
end;

destructor TCustomDBMaskEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TCustomDBMaskEdit.DataChange(Sender: TObject);
begin
  if not Assigned(FDataLink.Field) or FDataLink.Field.IsNull then
    Text := ''
  else
  begin
    {$if lcl_release >= 29}
    Text := FDataLink.Field.Text;
    {$else}
    Text := FormatMaskText(EditMask, FDataLink.Field.Text);
    {$endif}
    SelectAll;
  end;
end;

procedure TCustomDBMaskEdit.UpdateData(Sender: TObject);
begin
  ValidateEdit;
  FDataLink.Field.Text := Text;
end;

procedure TCustomDBMaskEdit.FocusRequest(Sender: TObject);
begin
  SetFocus;
end;

procedure TCustomDBMaskEdit.ActiveChange(Sender: TObject);
begin
  if FDatalink.Active then
    DataChange(Sender)
  else
  begin
    Text := '';
    FDataLink.Reset;
  end;
end;

procedure TCustomDBMaskEdit.LayoutChange(Sender: TObject);
begin
  DataChange(Sender);
end;

function TCustomDBMaskEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

function TCustomDBMaskEdit.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TCustomDBMaskEdit.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TCustomDBMaskEdit.SetDataField(const AValue: string);
begin
  FDataLink.FieldName := AValue;
end;

procedure TCustomDBMaskEdit.SetDataSource(AValue: TDataSource);
begin
  ChangeDataSource(Self, FDataLink, AValue);
end;

function TCustomDBMaskEdit.IsReadOnly: Boolean;
begin
  if FDatalink.Active then
    Result := not FDatalink.CanModify
  else
    Result := False;
end;

procedure TCustomDBMaskEdit.CMGetDataLink(var Message: TLMessage);
begin
  Message.Result := PtrUInt(FDataLink);
end;

function TCustomDBMaskEdit.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;

procedure TCustomDBMaskEdit.SetReadOnly(AValue: Boolean);
begin
  inherited;
  FDataLink.ReadOnly := AValue;
end;

procedure TCustomDBMaskEdit.KeyDown(var Key: word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if Key = VK_ESCAPE then
  begin
    FDataLink.Reset;
    SelectAll;
    Key := VK_UNKNOWN;
  end
  else
  if Key in [VK_DELETE, VK_BACK] then
  begin
    if not IsReadOnly then
      FDatalink.Edit
    else
      Key := VK_UNKNOWN;
  end
  else
  if Key = VK_TAB then
    if FDataLink.CanModify and FDatalink.Editing then
      FDataLink.UpdateRecord;
end;

procedure TCustomDBMaskEdit.UTF8KeyPress(var UTF8Key: TUTF8Char);

  function CanAcceptKey: Boolean;
  begin
    Result := Field.IsValidChar((UTF8Key)[1]) and (Field.DataType <> ftAutoInc);
  end;

var
  SavedKey: TUTF8Char;
begin
  SavedKey := UTF8Key;
  inherited UTF8KeyPress(UTF8Key);
  if (not IsMasked) or (inherited ReadOnly) then
  begin
    case UTF8Key[1] of
      #8:
        if not IsReadOnly then
          FDatalink.Edit
        else
          UTF8Key := #0;
      #32..#255:
        if not IsReadOnly and CanAcceptKey then
          FDatalink.Edit
        else
          UTF8Key := #0;
    end;
  end
  else
  begin
    case (SavedKey)[1] of
      #8:
        if not IsReadOnly then
          FDatalink.Edit;
      #32..#255:
        if not IsReadOnly and CanAcceptKey then
          FDatalink.Edit;
    end;
  end;
end;

procedure TCustomDBMaskEdit.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then
    DataChange(Self);
end;

procedure TCustomDBMaskEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and Assigned(FDataLink) and (AComponent = DataSource) then
    DataSource := nil;
end;

function TCustomDBMaskEdit.EditCanModify: Boolean;
begin
  Result := FDataLink.Edit;
end;

function TCustomDBMaskEdit.GetEditText: string;
begin
  if not (csDesigning in ComponentState) and not FDatalink.Active then
  begin
    Result := '';
    Exit;
  end;
  Result := inherited GetEditText;
end;

procedure TCustomDBMaskEdit.Change;
begin
  FDataLink.Modified;
  inherited Change;
end;

procedure TCustomDBMaskEdit.Reset;
begin
  FDataLink.Reset;
  inherited Reset;
end;

procedure TCustomDBMaskEdit.WMSetFocus(var Message: TLMSetFocus);
begin
  inherited WMSetFocus(Message);
  if not FDatalink.Editing then
    FDatalink.Reset;
end;

procedure TCustomDBMaskEdit.WMKillFocus(var Message: TLMKillFocus);
begin
  inherited WMKillFocus(Message);
  if not FDatalink.Editing then
    FDatalink.Reset
  else
    FDatalink.UpdateRecord;
end;

procedure TCustomDBMaskEdit.LMPasteFromClip(var Message: TLMessage);
begin
  if not IsReadOnly then
    FDatalink.Edit;
  inherited LMPasteFromClip(Message);
end;

procedure TCustomDBMaskEdit.LMCutToClip(var Message: TLMessage);
begin
  if not IsReadOnly then
    FDatalink.Edit;
  inherited LMCutToClip(Message);
end;

procedure Register;
begin
  RegisterComponents('Data Controls', [TDBMaskEdit]);
end;

initialization
  {$I dbmaskedit.lrs}

end.

