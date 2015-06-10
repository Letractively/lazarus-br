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

unit WSRichBox;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, WSStdCtrls, WSRichBoxFactory, Graphics, RichBox;

type

  { TWSCustomRichBox }

  TWSCustomRichBox = class(TWSCustomMemo)
    class function Font_GetCharset(const AWinControl: TWinControl): TFontCharset; virtual;
    class function Font_GetBackColor(const AWinControl: TWinControl): TColor; virtual; // added
    class function Font_GetColor(const AWinControl: TWinControl): TColor; virtual;
    class function Font_GetName(const AWinControl: TWinControl): TFontName; virtual;
    class function Font_GetPitch(const AWinControl: TWinControl): TFontPitch; virtual;
    class function Font_GetProtected(const AWinControl: TWinControl): Boolean; virtual;
    class function Font_GetSize(const AWinControl: TWinControl): Integer; virtual;
    class function Font_GetStyle(const AWinControl: TWinControl): TFontStyles; virtual;
    //
    class function Para_GetAlignment(const AWinControl: TWinControl): {$IFNDEF WINDOWS}TAlignment;{$ELSE}TRichEditAlignment;{$ENDIF} virtual;
    class function Para_GetFirstIndent(const AWinControl: TWinControl): Longint; virtual;
    class function Para_GetLeftIndent(const AWinControl: TWinControl): Longint; virtual;
    class function Para_GetRightIndent(const AWinControl: TWinControl): Longint; virtual;
    class function Para_GetNumbering(const AWinControl: TWinControl): TNumberingStyle; virtual;
    class function Para_GetTab(const AWinControl: TWinControl; Index: Byte): Longint; virtual;
    class function Para_GetTabCount(const AWinControl: TWinControl): Integer; virtual;
    //
    class procedure Font_SetCharset(const AWinControl: TWinControl; Value: TFontCharset); virtual;
    class procedure Font_SetBackColor(const AWinControl: TWinControl; Value :TColor); virtual; // added
    class procedure Font_SetColor(const AWinControl: TWinControl; Value: TColor); virtual;
    class procedure Font_SetName(const AWinControl: TWinControl; Value: TFontName); virtual;
    class procedure Font_SetPitch(const AWinControl: TWinControl; Value: TFontPitch); virtual;
    class procedure Font_SetProtected(const AWinControl: TWinControl; Value: Boolean); virtual;
    class procedure Font_SetSize(const AWinControl: TWinControl; Value: Integer);  virtual;
    class procedure Font_SetStyle(const AWinControl: TWinControl; Value: TFontStyles); virtual;
    //
    class procedure Para_SetAlignment(const AWinControl: TWinControl; Value: {$IFNDEF WINDOWS}TAlignment{$ELSE} TRichEditAlignment{$ENDIF}); virtual;
    class procedure Para_SetFirstIndent(const AWinControl: TWinControl; Value: Longint); virtual;
    class procedure Para_SetLeftIndent(const AWinControl: TWinControl; Value: Longint); virtual;
    class procedure Para_SetRightIndent(const AWinControl: TWinControl; Value: Longint); virtual;
    class procedure Para_SetNumbering(const AWinControl: TWinControl; Value: TNumberingStyle); virtual;
    class procedure Para_SetTab(const AWinControl: TWinControl; Index: Byte; Value: Longint); virtual;
    class procedure Para_SetTabCount(const AWinControl: TWinControl; Value: Integer); virtual;
    //
    class procedure SaveToStream (const AWinControl: TWinControl; var Stream: TStream); virtual;
    class procedure LoadFromStream (const AWinControl: TWinControl; const Stream: TStream); virtual;
    //
    class function FindText(const AWinControl: TWinControl;
      const SearchStr: string; StartPos, Length: Integer; Options: TSearchTypes;
      Backwards :boolean): Integer; virtual;                           // added
    class function GetFirstVisibleLine(const AWinControl: TWinControl)
      :integer; virtual;                                               // added
    class function GetCaretCoordinates(const AWinControl: TWinControl)
      :TCaretCoordinates; virtual;                                     // added
    class function GetCaretPoint(const AWinControl: TWinControl)
      :Classes.TPoint; virtual;                                         // added
    class procedure GetRTFSelection(const AWinControl: TWinControl; intoStream :TStream); virtual;      // added
    class function GetScrollPoint(const AWinControl: TWinControl)
      :Classes.TPoint; virtual; // added
    class function GetSelText(const AWinControl: TWinControl):string; virtual; // added
    class function GetTextBuf (const AWinControl: TWinControl):string; virtual;
    class function GetTextSel (const AWinControl: TWinControl):string; virtual;
    class function GetWordAtPoint(const AWinControl;
      X, Y :integer) :string; virtual;                                 // added
    class function GetWordAtPos(const AWinControl;
      Pos :integer):string; virtual;                                   // added
    class function GetZoomState(const AWinControl: TWinControl)
      :TZoomPair; virtual;                                             // added
    class procedure Loaded(const AWinControl: TWinControl); virtual;   // added
    class procedure Print(const AWinControl: TWinControl;
      const DocumentTitle: string; Margins :TMargins); virtual;        // added
    class procedure PutRTFSelection(const AWinControl:
      TWinControl; sourceStream :TStream); virtual;                    // added
    class procedure Redo(const AWinControl: TWinControl); virtual;     // added
    class procedure ScrolLine(const AWinControl: TWinControl;
      Delta :integer); virtual;                                        // added
    class procedure ScrollToCaret(const AWinControl: TWinControl); virtual; // added
    class procedure SetColor(const AWinControl: TWinControl;
      AValue :TColor); virtual;
    class procedure SetScrollPoint(const AWinControl: TWinControl;
      AValue :Classes.TPoint); virtual;// added
    class procedure SetSelText(const AWinControl: TWinControl;
      AValue :string); virtual;// added
    class procedure SetZoomState(const AWinControl: TWinControl;
      ZoomPair :TZoomPair); virtual;                                   // added
  end;
  TWSCustomRichBoxClass = class of TWSCustomRichBox;

{ WidgetSetRegistration }

procedure RegisterCustomRichBox;
implementation

procedure RegisterCustomRichBox;
const
  Done: Boolean = False;
begin
  if Done then exit;
  WSRegisterCustomRichBox;
  Done := True;
end;

{ TWSCustomRichBox }

class function TWSCustomRichBox.Font_GetCharset(const AWinControl: TWinControl
  ): TFontCharset;
begin

end;

class function TWSCustomRichBox.Font_GetBackColor(const AWinControl :TWinControl
  ) :TColor;
begin

end;

class function TWSCustomRichBox.Font_GetColor(const AWinControl: TWinControl
  ): TColor;
begin

end;

class function TWSCustomRichBox.Font_GetName(const AWinControl: TWinControl
  ): TFontName;
begin

end;

class function TWSCustomRichBox.Font_GetPitch(const AWinControl: TWinControl
  ): TFontPitch;
begin

end;

class function TWSCustomRichBox.Font_GetProtected(const AWinControl: TWinControl
  ): Boolean;
begin

end;

class function TWSCustomRichBox.Font_GetSize(const AWinControl: TWinControl
  ): Integer;
begin

end;

class function TWSCustomRichBox.Font_GetStyle(const AWinControl: TWinControl
  ): TFontStyles;
begin

end;

class function TWSCustomRichBox.Para_GetAlignment(const AWinControl: TWinControl
  ): {$IFNDEF WINDOWS}TAlignment{$ELSE} TRichEditAlignment{$ENDIF};
begin

end;

class function TWSCustomRichBox.Para_GetFirstIndent(
  const AWinControl: TWinControl): Longint;
begin

end;

class function TWSCustomRichBox.Para_GetLeftIndent(
  const AWinControl: TWinControl): Longint;
begin

end;

class function TWSCustomRichBox.Para_GetRightIndent(
  const AWinControl: TWinControl): Longint;
begin

end;

class function TWSCustomRichBox.Para_GetNumbering(const AWinControl: TWinControl
  ): TNumberingStyle;
begin

end;

class function TWSCustomRichBox.Para_GetTab(const AWinControl: TWinControl;
  Index: Byte): Longint;
begin

end;

class function TWSCustomRichBox.Para_GetTabCount(const AWinControl: TWinControl
  ): Integer;
begin

end;

class procedure TWSCustomRichBox.Font_SetCharset(
  const AWinControl: TWinControl; Value: TFontCharset);
begin

end;

class procedure TWSCustomRichBox.Font_SetBackColor(
  const AWinControl :TWinControl; Value :TColor);
begin

end;

class procedure TWSCustomRichBox.Font_SetColor(const AWinControl: TWinControl;
  Value: TColor);
begin

end;

class procedure TWSCustomRichBox.Font_SetName(const AWinControl: TWinControl;
  Value: TFontName);
begin

end;

class procedure TWSCustomRichBox.Font_SetPitch(const AWinControl: TWinControl;
  Value: TFontPitch);
begin

end;

class procedure TWSCustomRichBox.Font_SetProtected(
  const AWinControl: TWinControl; Value: Boolean);
begin

end;

class procedure TWSCustomRichBox.Font_SetSize(const AWinControl: TWinControl;
  Value: Integer);
begin

end;

class procedure TWSCustomRichBox.Font_SetStyle(const AWinControl: TWinControl;
  Value: TFontStyles);
begin

end;

class procedure TWSCustomRichBox.Para_SetAlignment(
  const AWinControl: TWinControl; Value: {$IFNDEF WINDOWS}TAlignment{$ELSE} TRichEditAlignment{$ENDIF} );
begin

end;

class procedure TWSCustomRichBox.Para_SetFirstIndent(
  const AWinControl: TWinControl; Value: Longint);
begin

end;

class procedure TWSCustomRichBox.Para_SetLeftIndent(
  const AWinControl: TWinControl; Value: Longint);
begin

end;

class procedure TWSCustomRichBox.Para_SetRightIndent(
  const AWinControl: TWinControl; Value: Longint);
begin

end;

class procedure TWSCustomRichBox.Para_SetNumbering(
  const AWinControl: TWinControl; Value: TNumberingStyle);
begin

end;

class procedure TWSCustomRichBox.Para_SetTab(const AWinControl: TWinControl;
  Index: Byte; Value: Longint);
begin

end;

class procedure TWSCustomRichBox.Para_SetTabCount(
  const AWinControl: TWinControl; Value: Integer);
begin

end;

class procedure TWSCustomRichBox.SaveToStream(const AWinControl: TWinControl;
  var Stream: TStream);
begin

end;

class procedure TWSCustomRichBox.LoadFromStream(const AWinControl: TWinControl;
  const Stream: TStream);
begin

end;

class function TWSCustomRichBox.FindText(const AWinControl: TWinControl;
  const SearchStr: string; StartPos, Length: Integer; Options: TSearchTypes; Backwards :boolean): Integer;
begin

end;

class function TWSCustomRichBox.GetFirstVisibleLine(
  const AWinControl :TWinControl) :integer;
begin

end;

class function TWSCustomRichBox.GetCaretCoordinates(const AWinControl: TWinControl)
  :TCaretCoordinates;
begin

end;

class function TWSCustomRichBox.GetCaretPoint(const AWinControl :TWinControl
  ) :Classes.TPoint;
begin

end;

class procedure TWSCustomRichBox.GetRTFSelection(const AWinControl: TWinControl; intoStream :TStream);
begin

end;

class function TWSCustomRichBox.GetScrollPoint(const AWinControl :TWinControl
  ) :Classes.TPoint;
begin

end;

class function TWSCustomRichBox.GetSelText(const AWinControl :TWinControl
  ) :string;
begin

end;

class function TWSCustomRichBox.GetTextBuf(const AWinControl :TWinControl
  ) :string;
begin

end;

class function TWSCustomRichBox.GetTextSel(const AWinControl :TWinControl
  ) :string;
begin

end;

class function TWSCustomRichBox.GetWordAtPoint(const AWinControl; X, Y :integer) :string;
begin

end;

class function TWSCustomRichBox.GetWordAtPos(const AWinControl; Pos :integer) :string;
begin

end;

class function TWSCustomRichBox.GetZoomState(const AWinControl :TWinControl
  ) :TZoomPair;
begin

end;

class procedure TWSCustomRichBox.Loaded(const AWinControl: TWinControl);
begin

end;

class procedure TWSCustomRichBox.Print(const AWinControl: TWinControl; const DocumentTitle :string;
  Margins :TMargins);
begin

end;

class procedure TWSCustomRichBox.PutRTFSelection(
  const AWinControl :TWinControl; sourceStream :TStream);
begin

end;

class procedure TWSCustomRichBox.Redo(const AWinControl :TWinControl);
begin

end;

class procedure TWSCustomRichBox.ScrolLine(const AWinControl :TWinControl;
  Delta :integer);
begin

end;

class procedure TWSCustomRichBox.ScrollToCaret(const AWinControl :TWinControl
  );
begin

end;

class procedure TWSCustomRichBox.SetColor(const AWinControl :TWinControl;
  AValue :TColor);
begin

end;

class procedure TWSCustomRichBox.SetScrollPoint(const AWinControl :TWinControl;
  AValue :Classes.TPoint);
begin

end;

class procedure TWSCustomRichBox.SetSelText(const AWinControl :TWinControl;
  AValue :string);
begin

end;

class procedure TWSCustomRichBox.SetZoomState(const AWinControl :TWinControl;
  ZoomPair :TZoomPair);
begin

end;

end.

