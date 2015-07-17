{
lzRichEdit

Copyright (C) 2010 Elson Junio elsonjunio@yahoo.com.br
                   Additions by Antônio Galvão

This is the file COPYING.modifiedLGPL, it applies to several units in the
Lazarus sources distributed by members of the Lazarus Development Team.
All files contains headers showing the appropriate license. See there if this
modification can be applied.

These files are distributed under the Library GNU General Public License
(see the file COPYING.LGPL) with the following modification:

As a special exception, the copyright holders of this library give you
permission to link this library with independent modules to produce an
executable, regardless of the license terms of these independent modules,
and to copy and distribute the resulting executable under terms of your choice,
provided that you also meet, for each linked independent module, the terms
and conditions of the license of that module. An independent module is a
module which is not derived from or based on this library. If you modify this
library, you may extend this exception to your version of the library, but
you are not obligated to do so. If you do not wish to do so, delete this
exception statement from your version.


If you didn't receive a copy of the file COPYING.LGPL, contact:
      Free Software Foundation, Inc.,
      675 Mass Ave
      Cambridge, MA  02139
      USA
}

{ TCustomRichBox }

procedure TCustomRichBox.SetColor(AValue : TColor);
begin
  FBackgroundColor := AValue;
  //Perform(EM_SETBKGNDCOLOR, 0, ColorToRGB(AValue));
  TWSCustomRichBoxClass(WidgetSetClass).SetColor(Self, AValue);
end;

procedure TCustomRichBox.SetScrollPoint(AValue :Classes.TPoint);
begin
  TWSCustomRichBoxClass(WidgetSetClass).SetScrollPoint(Self, AValue);
end;

procedure TCustomRichBox.SetSelText(AValue :String);
begin
  {$IFDEF WINDOWS}
  TWSCustomRichBoxClass(WidgetSetClass).SetSelText(Self, AValue);
  {$ELSE}
  inherited SetSelText;
  {$ENDIF}
end;

procedure TCustomRichBox.SetZoomState(AValue :TZoomPair);
begin
  TWSCustomRichBoxClass(WidgetSetClass).SetZoomState(Self, AValue);
end;

function TCustomRichBox.GetCaretCoordinates :TCaretCoordinates;
begin
  Result:= TWSCustomRichBoxClass(WidgetSetClass).GetCaretCoordinates(Self);
end;

function TCustomRichBox.GetCaretPoint :Classes.TPoint;
begin
  Result:= TWSCustomRichBoxClass(WidgetSetClass).GetCaretPoint(Self);
end;

function TCustomRichBox.GetScrollPoint :Classes.TPoint;
begin
  Result:= TWSCustomRichBoxClass(WidgetSetClass).GetScrollPoint(Self);
end;

function TCustomRichBox.GetSelText :String;
begin
  {$IFDEF WINDOWS}
  Result:= TWSCustomRichBoxClass(WidgetSetClass).GetSelText(Self);
  {$ELSE}
  inherited GesSelText;
  {$ENDIF}
end;

function TCustomRichBox.GetZoomState :TZoomPair;
begin
  Result:= TWSCustomRichBoxClass(WidgetSetClass).GetZoomState(Self);
end;

class procedure TCustomRichBox.WSRegisterClass;
begin
  inherited WSRegisterClass;
  RegisterCustomRichBox;
end;

constructor TCustomRichBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSelAttributes := TTextAttributes.Create(Self);
  FParagraph := TParaAttributes.Create(Self);
  FBackgroundColor := clWindow;

  FDefaultExtension := '.rtf';
end;

destructor TCustomRichBox.Destroy;
begin
  FParagraph.Free;
  FSelAttributes.Free;
  inherited Destroy;
end;

function TCustomRichBox.FindText(const SearchStr :string; StartPos,
  Length :Integer; Options :TSearchTypes; Backwards :boolean): Integer;
begin
  Result:= TWSCustomRichBoxClass(WidgetSetClass).FindText(Self, SearchStr,
                                                     StartPos, Length, Options, Backwards);
end;

function TCustomRichBox.GetFirsVisibleLine :integer;
begin
  Result:= TWSCustomRichBoxClass(WidgetSetClass).GetFirstVisibleLine(Self);
end;

function TCustomRichBox.GetWordAtPoint(X, Y :integer) :string;
begin
  Result:= TWSCustomRichBoxClass(WidgetSetClass).GetWordAtPoint(Self, X, Y);
end;

function TCustomRichBox.GetWordAtPos(Pos :integer) :string;
begin
  Result:= TWSCustomRichBoxClass(WidgetSetClass).GetWordAtPos(Self, Pos);
end;

function TCustomRichBox.GetRealTextBuf: String;
begin
  Result:= TWSCustomRichBoxClass(WidgetSetClass).GetTextBuf(Self);
end;

function TCustomRichBox.GetRealtextSel: String;
begin
  Result:= TWSCustomRichBoxClass(WidgetSetClass).GetTextSel(Self);
end;

procedure TCustomRichBox.GetRTFSelection(intoStream :TStream);
begin
  TWSCustomRichBoxClass(WidgetSetClass).GetRTFSelection(Self, intoStream);
end;

procedure TCustomRichBox.Loaded;
begin
  inherited Loaded;
  TWSCustomRichBoxClass(WidgetSetClass).Loaded(Self);
  SetColor(FBackgroundColor);
end;

procedure TCustomRichBox.LoadFromFile(AFileName: string);
var
  Str :TMemoryStream;
  Buffer :array[0..4] of Char;
  S :array[0..99999] of WideChar;
begin
  Str := TMemoryStream.Create;
  try
    Str.LoadFromFile(AFileName);
    Str.Read(Buffer, 5);
    Str.Position := 0;

    { Se PlainText é configurado como False e o arquivo é plaintext,
      ele não aparece no controle. }

    if (Buffer = '{\rtf') and
       (UTF8LowerCase(ExtractFileExt(AFileName)) = UTF8LowerCase(FDefaultExtension)) then
      PlainText := False
    else
      PlainText := True;

      if PlainText then
        Lines.LoadFromFile(AFileName)
      else
        LoadFromStream(Str);
  finally
    Str.Free;
  end;
end;

procedure TCustomRichBox.LoadFromStream(Stream: TStream);
begin
  TWSCustomRichBoxClass(WidgetSetClass).LoadFromStream(Self, Stream);
end;

procedure TCustomRichBox.Print(const DocumentTitle: string; Margins :TMargins);
begin
  TWSCustomRichBoxClass(WidgetSetClass).Print(Self, DocumentTitle, Margins);
end;

procedure TCustomRichBox.PutRTFSelection(sourceStream :TStream);
begin
  TWSCustomRichBoxClass(WidgetSetClass).PutRTFSelection(Self, sourceStream);
end;

procedure TCustomRichBox.Redo;
begin
  TWSCustomRichBoxClass(WidgetSetClass).Redo(Self);
end;

procedure TCustomRichBox.SaveToFile(AFileName :string);
var
  Str :TMemoryStream;
begin
  Str := TMemoryStream.Create;
  try
    SaveToStream(Str);
    Str.SaveToFile(AFileName);
  finally
    Str.Free;
  end;
end;

procedure TCustomRichBox.SaveToStream(Stream: TStream);
begin
  TWSCustomRichBoxClass(WidgetSetClass).SaveToStream(Self, Stream);
end;

procedure TCustomRichBox.ScrollLine(Delta :integer);
begin
  TWSCustomRichBoxClass(WidgetSetClass).ScrolLine(Self, Delta);
end;

procedure TCustomRichBox.ScrollToCaret;
begin
  TWSCustomRichBoxClass(WidgetSetClass).ScrollToCaret(Self);
end;


