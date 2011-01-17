{ TCustomlzRichEdit }

class procedure TCustomlzRichEdit.WSRegisterClass;
begin
  inherited;
  WSRegisterCustomlzRichEdit;
end;

{function TCustomlzRichEdit.RealGetText: TCaption;
begin
  Result:=TWSCustomlzRichEditClass(WidgetSetClass).GetRealTextBuf(Self);
end;

procedure TCustomlzRichEdit.RealSetText(const Value: TCaption);
begin
  Lines.Text := Value;
end;}

procedure TCustomlzRichEdit.SetActiveRichOle(I: Boolean);
begin
  {$IFDEF Windows}
  if I and (csDesigning in ComponentState) then
    MessageDLG('Perigo!', 'Ativar RichOle pode gerar instabilidade no controle.',
    mtWarning, [mbOK], 0);
  {$ENDIF}
  FActiveRichOle:= I;
end;

procedure TCustomlzRichEdit.SetSelection(StartPos, EndPos: Integer;
  ScrollCaret: Boolean);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).SetSelection(Self, StartPos, EndPos, ScrollCaret);
end;

procedure TCustomlzRichEdit.SetTextAttributes(iSelStart, iSelLength: Integer;
  const TextParams: TlzFontParams);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).SetTextAttributes(Self, iSelStart, iSelLength, TextParams);
end;

procedure TCustomlzRichEdit.SetTextAttributes(iSelStart, iSelLength: Integer;
  const iFont: TFont);
var
  TextParams: TlzFontParams;
begin
  TFontToTFontParams(iFont, TextParams);
  SetTextAttributes(iSelStart, iSelLength, TextParams);
end;

procedure TCustomlzRichEdit.GetTextAttributes(Position: Integer; var Params: TlzFontParams);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).GetTextAttributes(Self, Position, Params);
end;

procedure TCustomlzRichEdit.SetAlignment(iSelStart, iSelLength: Integer; iAlignment: TlzRichEdit_Align);
begin
 TWSCustomlzRichEditClass(WidgetSetClass).SetAlignment(Self, iSelStart, iSelLength, iAlignment);
end;

procedure TCustomlzRichEdit.GetAlignment(Position: Integer; var iAlignment: TlzRichEdit_Align);
begin
   TWSCustomlzRichEditClass(WidgetSetClass).GetAlignment(Self, Position, iAlignment);
end;

procedure TCustomlzRichEdit.SetNumbering(N:Boolean);
begin
 TWSCustomlzRichEditClass(WidgetSetClass).SetNumbering(Self, N);
end;

function TCustomlzRichEdit.GetNumbering: Boolean;
begin
  TWSCustomlzRichEditClass(WidgetSetClass).GetNumbering(Self, Result);
end;

function TCustomlzRichEdit.GetNumbering(Position: Integer): Boolean;
begin
  TWSCustomlzRichEditClass(WidgetSetClass).GetNumbering(Self, Position, Result);
end;

procedure TCustomlzRichEdit.SetOffSetIndent(iSelStart, iSelLength: Integer; I: Integer);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).SetOffSetIndent(Self, I);
end;

function TCustomlzRichEdit.GetOffSetIndent: Integer;
begin
  TWSCustomlzRichEditClass(WidgetSetClass).GetOffSetIndent(Self, Result);
end;

procedure TCustomlzRichEdit.SetRightIndent(iSelStart, iSelLength: Integer;
  I: Integer);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).SetRightIndent(Self, iSelStart, iSelLength, I);
end;

procedure TCustomlzRichEdit.GetRightIndent(Position: Integer; var I: Integer);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).GetRightIndent(Self, Position, I);
end;

procedure TCustomlzRichEdit.SetStartIndent(iSelStart, iSelLength: Integer;
  I: Integer);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).SetStartIndent(Self, iSelStart, iSelLength, I);
end;

procedure TCustomlzRichEdit.GetStartIndent(Position: Integer; var I: Integer);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).GetStartIndent(Self, Position, I);
end;

procedure TCustomlzRichEdit.InsertImage(Position: Integer; Image: TPicture);
begin
   TWSCustomlzRichEditClass(WidgetSetClass).InsertImage(Self, Position, Image);
end;

function TCustomlzRichEdit.GetImage(Position: Integer; var Image: TPicture
  ): Boolean;
begin
  Result:= TWSCustomlzRichEditClass(WidgetSetClass).GetImage(Self, Position, Image);
end;

function TCustomlzRichEdit.GetRealTextBuf: String;
begin
  Result:=TWSCustomlzRichEditClass(WidgetSetClass).GetRealTextBuf(Self);
end;

procedure TCustomlzRichEdit.InsertPosLastChar(const UTF8Char: TUTF8Char);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).InsertPosLastChar(Self, UTF8Char);
end;

procedure TCustomlzRichEdit.SaveToStream(Stream: TStream);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).SaveToStream(Self, Stream);
end;

procedure TCustomlzRichEdit.LoadFromStream(Stream: TStream);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).LoadFromStream(Self, Stream);
end;

destructor TCustomlzRichEdit.Destroy;
begin
  inherited Destroy;
end;


