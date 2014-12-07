{
lzRichEdit

Copyright (C) 2010 Elson Junio elsonjunio@yahoo.com.br

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

{ TTextAttributes }

function TTextAttributes.GetColor: TColor;
begin
  Result:= TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Font_GetColor(FRichBox);
end;

procedure TTextAttributes.SetColor(Value: TColor);
begin
  TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Font_SetColor(FRichBox, Value);
end;

function TTextAttributes.GetBackColor :TColor;
begin
  Result:= TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Font_GetBackColor(FRichBox);
end;

procedure TTextAttributes.SetBackColor(Value :TColor);
begin
  TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Font_SetBackColor(FRichBox, Value);
end;

function TTextAttributes.GetName: TFontName;
begin
  Result:= TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Font_GetName(FRichBox);
end;

procedure TTextAttributes.SetName(Value: TFontName);
begin
  TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Font_SetName(FRichBox, Value);
end;

function TTextAttributes.GetSize: Integer;
begin
  Result:= TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Font_GetSize(FRichBox);
end;

procedure TTextAttributes.SetSize(Value: Integer);
begin
  TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Font_SetSize(FRichBox, Value);
end;

function TTextAttributes.GetStyle: TFontStyles;
begin
  Result:= TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Font_GetStyle(FRichBox);
end;

procedure TTextAttributes.SetStyle(Value: TFontStyles);
begin
  TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Font_SetStyle(FRichBox, Value);
end;

function TTextAttributes.GetCharset: TFontCharset;
begin
  Result:= TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Font_GetCharset(FRichBox);
end;

procedure TTextAttributes.SetCharset(Value: TFontCharset);
begin
  TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Font_SetCharset(FRichBox, Value);
end;

function TTextAttributes.GetPitch: TFontPitch;
begin
  Result:= TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Font_GetPitch(FRichBox);
end;

procedure TTextAttributes.SetPitch(Value: TFontPitch);
begin
  TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Font_SetPitch(FRichBox, Value);
end;

function TTextAttributes.GetProtected: Boolean;
begin
  Result:= TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Font_GetProtected(FRichBox);
end;

procedure TTextAttributes.SetProtected(Value: Boolean);
begin
  TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Font_SetProtected(FRichBox, Value);
end;

constructor TTextAttributes.Create(AOwner: TCustomRichBox);
begin
  FRichBox:= AOwner;
end;

procedure TTextAttributes.Assign(Source: TPersistent);
begin
  if Source is TTextAttributes then
    begin
      Color:= TTextAttributes(Source).Color;
      Size:= TTextAttributes(Source).Size;
      Name:= TTextAttributes(Source).Name;
      Style:= TTextAttributes(Source).Style;
      Charset:= TTextAttributes(Source).Charset;
      Pitch:= TTextAttributes(Source).Pitch;
      Protect:= TTextAttributes(Source).Protect;
   end
  else inherited Assign(Source);
end;
