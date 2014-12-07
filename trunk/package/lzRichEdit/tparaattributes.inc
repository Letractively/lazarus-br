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

{ TParaAttributes }

function TParaAttributes.GetAlignment: {$IFNDEF WINDOWS}TAlignment{$ELSE} TRichEditAlignment{$ENDIF};
begin
  Result:= TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Para_GetAlignment(FRichBox);
end;

procedure TParaAttributes.SetAlignment(Value: {$IFNDEF WINDOWS}TAlignment{$ELSE} TRichEditAlignment{$ENDIF});
begin
  TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Para_SetAlignment(FRichBox, Value);
end;

function TParaAttributes.GetFirstIndent: LongInt;
begin
  Result:= TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Para_GetFirstIndent(FRichBox);
end;

procedure TParaAttributes.SetFirstIndent(Value: LongInt);
begin
  TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Para_SetFirstIndent(FRichBox, Value);
end;

function TParaAttributes.GetLeftIndent: LongInt;
begin
  Result:= TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Para_GetLeftIndent(FRichBox);
end;

procedure TParaAttributes.SetLeftIndent(Value: LongInt);
begin
  TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Para_SetLeftIndent(FRichBox, Value);
end;

function TParaAttributes.GetNumbering: TNumberingStyle;
begin
  Result:= TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Para_GetNumbering(FRichBox);
end;

procedure TParaAttributes.SetNumbering(Value: TNumberingStyle);
begin
  TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Para_SetNumbering(FRichBox, Value);
end;

function TParaAttributes.GetRightIndent: LongInt;
begin
  Result:= TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Para_GetRightIndent(FRichBox);
end;

procedure TParaAttributes.SetRightIndent(Value: LongInt);
begin
  TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Para_SetRightIndent(FRichBox, Value);
end;

function TParaAttributes.GetTab(Index: Byte): Longint;
begin
  Result:= TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Para_GetTab(FRichBox, Index);
end;

procedure TParaAttributes.SetTab(Index: Byte; Value: Longint);
begin
  TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Para_SetTab(FRichBox, Index, Value);
end;

function TParaAttributes.GetTabCount: Integer;
begin
  Result:= TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Para_GetTabCount(FRichBox);
end;

procedure TParaAttributes.SetTabCount(Value: Integer);
begin
  TWSCustomRichBoxClass(FRichBox.WidgetSetClass).Para_SetTabCount(FRichBox, Value);
end;

constructor TParaAttributes.Create(AOwner: TCustomRichBox);
begin
  FRichBox:= AOwner;
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