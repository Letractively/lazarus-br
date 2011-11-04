{ TTextAttributes }

procedure TTextAttributes.GetAttributes(var Format: TlzFontParams);
begin
  TCustomlzRichEdit(FlzRichEdit).GetTextAttributes(TCustomlzRichEdit(FlzRichEdit).SelStart, Format);
end;

function TTextAttributes.GetColor: TColor;
begin
  GetAttributes(FFontParams);
  Result:= FFontParams.Color;
end;

procedure TTextAttributes.SetColor(Value: TColor);
begin
  FlzRichEdit.SetFontColor(FlzRichEdit.SelStart, FlzRichEdit.SelLength, Value);
end;

function TTextAttributes.GetName: TFontName;
begin
  GetAttributes(FFontParams);
  Result:= FFontParams.Name;
end;

procedure TTextAttributes.SetName(Value: TFontName);
begin
  FlzRichEdit.SetFontName(FlzRichEdit.SelStart, FlzRichEdit.SelLength, Value);
end;

function TTextAttributes.GetSize: Integer;
begin
  GetAttributes(FFontParams);
  Result:= FFontParams.Size;
end;

procedure TTextAttributes.SetSize(Value: Integer);
begin
  FlzRichEdit.SetFontSize(FlzRichEdit.SelStart, FlzRichEdit.SelLength, Value);
end;

function TTextAttributes.GetStyle: TFontStyles;
begin
  GetAttributes(FFontParams);
  Result:= FFontParams.Style;
end;

procedure TTextAttributes.SetStyle(Value: TFontStyles);
begin
  FlzRichEdit.SetFontStyle(FlzRichEdit.SelStart, FlzRichEdit.SelLength, Value);
end;

constructor TTextAttributes.Create(AOwner: TCustomlzRichEdit);
begin
  inherited Create;
  FlzRichEdit:= AOwner;
end;

procedure TTextAttributes.Assign(Source: TPersistent);
begin
  if Source is TTextAttributes then
    begin
      Color:= TTextAttributes(Source).Color;
      Size:= TTextAttributes(Source).Size;
      Name:= TTextAttributes(Source).Name;
      Style:= TTextAttributes(Source).Style;
   end
  else inherited Assign(Source);
end;

{ TParaAttributes }

function TParaAttributes.GetAlignment: TlzRichEdit_Align;
begin
  Result:= taLeft;
  FlzRichEdit.GetAlignment(FlzRichEdit.SelStart, Result);
end;

procedure TParaAttributes.SetAlignment(Value: TlzRichEdit_Align);
begin
  FlzRichEdit.SetAlignment(FlzRichEdit.GetPosStartCharLine, FlzRichEdit.GetPosCharEndLine - FlzRichEdit.GetPosStartCharLine, Value);
end;

function TParaAttributes.GetFirstIndent: LongInt;
begin
  FlzRichEdit.GetIndent(FlzRichEdit.GetPosStartCharLine, Result);
end;

procedure TParaAttributes.SetFirstIndent(Value: LongInt);
begin
  FlzRichEdit.SetIndent(FlzRichEdit.GetPosStartCharLine, FlzRichEdit.GetPosCharEndLine - FlzRichEdit.GetPosStartCharLine, Value);
end;

function TParaAttributes.GetLeftIndent: LongInt;
begin
  Result:= 0;
  FlzRichEdit.GetLeftMargin(FlzRichEdit.GetPosStartCharLine, Result);
end;

procedure TParaAttributes.SetLeftIndent(Value: LongInt);
begin
  FlzRichEdit.SetLeftMargin(FlzRichEdit.GetPosStartCharLine, FlzRichEdit.GetPosCharEndLine - FlzRichEdit.GetPosStartCharLine, Value);
end;

function TParaAttributes.GetNumbering: TNumberingStyle;
var
  Numb:Boolean=False;
begin
  Result:= nsNone;
  Numb:= FlzRichEdit.GetNumbering;
  if Numb then Result:= nsBullet;
end;

procedure TParaAttributes.SetNumbering(Value: TNumberingStyle);
var
  Numb:Boolean=False;
begin
  if Value = nsBullet then Numb := True;
  FlzRichEdit.SetNumbering(Numb);
end;

function TParaAttributes.GetRightIndent: LongInt;
begin
  Result:= 0;
  FlzRichEdit.GetRightMargin(FlzRichEdit.GetPosStartCharLine, Result);
end;

procedure TParaAttributes.SetRightIndent(Value: LongInt);
begin
  FlzRichEdit.SetRightMargin(FlzRichEdit.GetPosStartCharLine, FlzRichEdit.GetPosCharEndLine - FlzRichEdit.GetPosStartCharLine, Value);
end;

constructor TParaAttributes.Create(AOwner: TCustomlzRichEdit);
begin
  inherited Create;
  FlzRichEdit:= AOwner;
end;

procedure TParaAttributes.Assign(Source: TPersistent);
begin
  if Source is TParaAttributes then
  begin
    Alignment := TParaAttributes(Source).Alignment;
    FirstIndent := TParaAttributes(Source).FirstIndent;
    LeftIndent := TParaAttributes(Source).LeftIndent;
    RightIndent := TParaAttributes(Source).RightIndent;
    Numbering := TParaAttributes(Source).Numbering;
  end
  else inherited Assign(Source);
end;

