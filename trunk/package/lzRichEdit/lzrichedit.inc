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

function TCustomlzRichEdit.GetPosStartCharLine: integer;
var
 S: string;
 CH: TUTF8Char;
 I, I2: integer;
begin

    S := GetRealTextBuf;
    for I := SelStart downto 0 do
    begin
      CH := UTF8Copy(S, I, 1);
      if (UTF8CharacterToUnicode(@CH[1], I2) = $A) or (I = 0) then
      begin
        Result := I;
        Exit;
      end;
    end;
    Result := SelStart;
end;

function TCustomlzRichEdit.GetPosCharEndLine: integer;
var
  S: string;
  CH: TUTF8Char;
  I, I2: integer;
  Len: integer;
begin
  S := GetRealTextBuf;
  Len := UTF8Length(S);
  for I := SelStart to Len do
  begin
    CH := UTF8Copy(S, I, 1);
    if (UTF8CharacterToUnicode(@CH[1], I2) = $A) or (I = Len) then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := SelStart;
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

procedure TCustomlzRichEdit.SetIndent(iSelStart, iSelLength: integer; I: integer
  );
begin
  TWSCustomlzRichEditClass(WidgetSetClass).SetIndent(Self, iSelStart, iSelLength, I);
end;

procedure TCustomlzRichEdit.GetIndent(Position: integer; var I: integer);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).GetIndent(Self, Position, I);
end;

procedure TCustomlzRichEdit.SetRightMargin(iSelStart, iSelLength: Integer;
  I: Integer);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).SetRightMargin(Self, iSelStart, iSelLength, I);
end;

procedure TCustomlzRichEdit.GetRightMargin(Position: Integer; var I: Integer);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).GetRightMargin(Self, Position, I);
end;

procedure TCustomlzRichEdit.SetLeftMargin(iSelStart, iSelLength: Integer;
  I: Integer);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).SetLeftMargin(Self, iSelStart, iSelLength, I);
end;

procedure TCustomlzRichEdit.GetLeftMargin(Position: Integer; var I: Integer);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).GetLeftMargin(Self, Position, I);
end;

procedure TCustomlzRichEdit.SetFontColor(iSelStart, iSelLength: integer;
  iColor: TColor);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).SetFontColor(Self, iSelStart, iSelLength, iColor);
end;

procedure TCustomlzRichEdit.SetFontName(iSelStart, iSelLength: integer;
  iFontName: TFontName);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).SetFontName(Self, iSelStart, iSelLength, iFontName);
end;

procedure TCustomlzRichEdit.SetFontSize(iSelStart, iSelLength: integer;
  iSize: Integer);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).SetFontSize(Self, iSelStart, iSelLength, iSize);
end;

procedure TCustomlzRichEdit.SetFontStyle(iSelStart, iSelLength: integer;
  Style: TFontStyles);
begin
  TWSCustomlzRichEditClass(WidgetSetClass).SetFontStyle(Self, iSelStart, iSelLength, Style);
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

constructor TCustomlzRichEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParagraph := TParaAttributes.Create(Self);
  FSelAttributes:= TTextAttributes.Create(Self);
end;

destructor TCustomlzRichEdit.Destroy;
begin
  FParagraph.Free;
  FSelAttributes.Free;
  inherited Destroy;
end;



