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

unit Win32WSRichBox;

{$mode objfpc}{$H+}


interface

uses
  Windows, Classes, SysUtils, Controls, LCLType, StdCtrls, Graphics, Win32Proc, Win32Int,
  Win32WSControls, WSRichBox, RichEdit, RichBox, Printers;

type

  TGetTextLengthEx = record
    flags: DWORD;              { flags (see GTL_XXX defines)  }
    codepage: UINT;            { code page for translation    }
  end;

  { TWin32WSCustomRichBox }
  TWin32WSCustomRichBox = class(TWSCustomRichBox)
    class function CreateHandle(const AWinControl: TWinControl;
      const AParams: TCreateParams): HWND; override;
    //--
    //Funções de Fonte
    class function Font_GetCharset(const AWinControl: TWinControl): TFontCharset; override;
    class function Font_GetBackColor(const AWinControl: TWinControl): TColor; override;
    class function Font_GetColor(const AWinControl: TWinControl): TColor; override;
    class function Font_GetName(const AWinControl: TWinControl): TFontName; override;
    class function Font_GetPitch(const AWinControl: TWinControl): TFontPitch; override;
    class function Font_GetProtected(const AWinControl: TWinControl): boolean; override;
    class function Font_GetSize(const AWinControl: TWinControl): integer; override;
    class function Font_GetStyle(const AWinControl: TWinControl): TFontStyles; override;
    //
    //Funções de Paragrafos
    class function Para_GetAlignment(const AWinControl: TWinControl): {TAlignment} TRichEditAlignment; override;
    class function Para_GetFirstIndent(const AWinControl: TWinControl): Longint; override;
    class function Para_GetLeftIndent(const AWinControl: TWinControl): Longint; override;
    class function Para_GetRightIndent(const AWinControl: TWinControl): Longint; override;
    class function Para_GetNumbering(const AWinControl: TWinControl): TNumberingStyle; override;
    class function Para_GetTab(const AWinControl: TWinControl; Index: Byte): Longint; override;
    class function Para_GetTabCount(const AWinControl: TWinControl): Integer; override;
    //
    //Procedimentos de Fonte
    class procedure Font_SetCharset(const AWinControl: TWinControl; Value: TFontCharset); override;
    class procedure Font_SetBackColor(const AWinControl: TWinControl; Value :TColor); override;
    class procedure Font_SetColor(const AWinControl: TWinControl; Value: TColor); override;
    class procedure Font_SetName(const AWinControl: TWinControl; Value: TFontName); override;
    class procedure Font_SetPitch(const AWinControl: TWinControl; Value: TFontPitch); override;
    class procedure Font_SetProtected(const AWinControl: TWinControl; Value: boolean); override;
    class procedure Font_SetSize(const AWinControl: TWinControl; Value: integer); override;
    class procedure Font_SetStyle(const AWinControl: TWinControl; Value: TFontStyles); override;
    //
    //Procedimentos de Paragrafos
    class procedure Para_SetAlignment(const AWinControl: TWinControl; Value: {TAlignment} TRichEditAlignment); override;
    class procedure Para_SetFirstIndent(const AWinControl: TWinControl; Value: Longint); override;
    class procedure Para_SetLeftIndent(const AWinControl: TWinControl; Value: Longint); override;
    class procedure Para_SetRightIndent(const AWinControl: TWinControl; Value: Longint); override;
    class procedure Para_SetNumbering(const AWinControl: TWinControl; Value: TNumberingStyle); override;
    class procedure Para_SetTab(const AWinControl: TWinControl; Index: Byte; Value: Longint); override;
    class procedure Para_SetTabCount(const AWinControl: TWinControl; Value: Integer); override;
    //--
    class function FindText(const AWinControl: TWinControl;
      const SearchStr: string; StartPos, Length: Integer; Options: TSearchTypes;
      Backwards :boolean): Integer;  override;
    class function GetFirstVisibleLine(const AWinControl: TWinControl)
      :integer; override;
    class function GetCaretCoordinates(const AWinControl: TWinControl)
      :TCaretCoordinates; override;
    class function GetCaretPoint(const AWinControl: TWinControl)
      :Classes.TPoint; override;
    class procedure GetRTFSelection(const AWinControl: TWinControl;
      intoStream :TStream); override;
    class function GetScrollPoint(const AWinControl: TWinControl)
      :Classes.TPoint; override;
    class function GetSelText(const AWinControl: TWinControl)
      :string; override;
    class function GetWordAtPoint(const AWinControl;
      X, Y :integer) :string; override;
    class function GetWordAtPos(const AWinControl;
      Pos :integer):string; override;
    class function GetZoomState(const AWinControl: TWinControl)
      :TZoomPair; override;
    class procedure Loaded(const AWinControl: TWinControl); override;
    class procedure LoadFromStream(const AWinControl: TWinControl;
      const Stream: TStream); override;
    class procedure Print(const AWinControl: TWinControl;
      const DocumentTitle: string; Margins :TMargins); override;
        class procedure PutRTFSelection(const AWinControl:
      TWinControl; sourceStream :TStream); override;
    class procedure Redo(const AWinControl: TWinControl); override;
    class procedure SaveToStream(const AWinControl: TWinControl;
      var Stream: TStream); override;
    class procedure ScrolLine(const AWinControl: TWinControl;
      Delta :integer); override;
    class procedure ScrollToCaret(const AWinControl: TWinControl); override;
    class procedure SetColor(const AWinControl: TWinControl; AValue :TColor); override;
    class procedure SetScrollPoint(const AWinControl: TWinControl;
      AValue :Classes.TPoint); override;
    class procedure SetSelText(const AWinControl: TWinControl;
      AValue :string); override;
    class procedure SetZoomState(const AWinControl: TWinControl;
      ZoomPair :TZoomPair); override;
  end;

{Exceptional}
procedure InitFMT(var FMT: TCHARFORMAT2);
procedure F_GetAttributes(const Window: HWND; var FMT: TCHARFORMAT2);
procedure F_SetAttributes(const Window: HWND; var FMT: TCHARFORMAT2);
//
procedure InitPARAFMT(var PARAFMT: TPARAFORMAT2);
procedure P_GetAttributes(const Window: HWND; var PARAFMT: TPARAFORMAT2);
procedure P_SetAttributes(const Window: HWND; var PARAFMT: TPARAFORMAT2);
//
function StreamSave(dwCookie: PDWORD; pbBuff: LPBYTE; cb: LONG; var pcb: LONG): DWORD; stdcall;
function StreamLoad(dwCookie: PDWORD; pbBuff: LPBYTE; cb: LONG; var pcb: LONG): DWORD; stdcall;
{...}
implementation

var
  RichEditLibrary_HWND: THandle;

const
  RichEditClass: ansistring = '';

function RichEditProc(Window: HWnd; Msg: UInt; WParam: Windows.WParam;
  LParam: Windows.LParam): LResult; stdcall;
begin
  if Msg = WM_PAINT then
  begin
    Result := CallDefaultWindowProc(Window, Msg, WParam, LParam);
  end
  else
    Result := WindowProc(Window, Msg, WParam, LParam);
end;

{Exceptional}
procedure InitFMT(var FMT: TCHARFORMAT2);
begin
  FillChar(FMT, SizeOf(TCHARFORMAT2), 0);
  FMT.cbSize := SizeOf(TCHARFORMAT2);
end;

procedure F_GetAttributes(const Window: HWND; var FMT: TCHARFORMAT2);
begin
  InitFMT(FMT);
  SendMessage(Window, EM_GETCHARFORMAT, SCF_SELECTION, LPARAM(@FMT));
end;

procedure F_SetAttributes(const Window: HWND; var FMT: TCHARFORMAT2);
begin
  SendMessage(Window, EM_SETCHARFORMAT, SCF_SELECTION, LPARAM(@FMT));
end;
//
procedure InitPARAFMT(var PARAFMT: TPARAFORMAT2);
begin
  FillChar(PARAFMT, SizeOf(TPARAFORMAT2), 0);
  PARAFMT.cbSize := SizeOf(TPARAFORMAT2);
end;

procedure P_GetAttributes(const Window: HWND; var PARAFMT: TPARAFORMAT2);
begin
  InitPARAFMT(PARAFMT);
  SendMessage(Window, EM_GETPARAFORMAT, 0, LPARAM(@PARAFMT));
end;

procedure P_SetAttributes(const Window: HWND; var PARAFMT: TPARAFORMAT2);
begin
  SendMessage(Window, EM_SETPARAFORMAT, 0, LPARAM(@PARAFMT));
end;

function StreamSave(dwCookie: PDWORD; pbBuff: LPBYTE; cb: LONG; var pcb: LONG
  ): DWORD; stdcall;
var
  Stream: TStream;
begin
  try
    Stream := TStream(dwCookie^);
    pcb := Stream.Write(pbBuff^, cb);
    Result := 0;
  except
    Result := 1;
  end;
end;

function StreamLoad(dwCookie: PDWORD; pbBuff: LPBYTE; cb: LONG; var pcb: LONG
  ): DWORD; stdcall;
var
  s: TStream;
begin
  try
    s := TStream(dwCookie^);
    pcb := s.Read(pbBuff^, cb);
    Result := 0;
  except
    Result := 1;
  end;
end;

{------------------------------------}

function EditStreamInCallback(dwCookie: Longint; pbBuff: PByte;
cb: Longint; var pcb: Longint): DWORD; Stdcall;
var
  theStream: TStream;
  dataAvail: LongInt;
begin
  theStream := TStream(dwCookie);
  with theStream do
  begin
    dataAvail := Size - Position;
    Result := 0;
    if dataAvail <= cb then
    begin
      pcb := Read(pbBuff^, dataAvail);
      if pcb <> dataAvail then
        result := DWord(E_FAIL);
    end
    else
    begin
      pcb := Read(pbBuff^, cb);
      if pcb <> cb then
        result := DWord(E_FAIL);
    end;
  end;
end;

function EditStreamOutCallback(dwCookie: Longint; pbBuff: PByte; cb: Longint; var pcb: Longint): DWORD; stdcall;
var
  theStream: TStream;
begin
  theStream := TStream(dwCookie);
  with theStream do
  begin
    if cb > 0 then
    pcb := Write(pbBuff^, cb);
    Result := 0;
  end;
end;
{------------------------------------}

{ TWin32WSCustomRichBox }

class function TWin32WSCustomRichBox.CreateHandle(const AWinControl: TWinControl;
  const AParams: TCreateParams): HWND;
const
  AlignmentToEditFlags: array[TAlignment] of DWord =
    (
    { taLeftJustify  } ES_LEFT,
    { taRightJustify } ES_RIGHT,
    { taCenter       } ES_CENTER
    );
var
  Params: TCreateWindowExParams;
begin
  //--
  if (RichEditLibrary_HWND = 0) then
  begin
    RichEditLibrary_HWND := LoadLibrary('Msftedit.dll');
    if (RichEditLibrary_HWND <> 0) and (RichEditLibrary_HWND <>
      HINSTANCE_ERROR) then
      RichEditClass := 'RichEdit50W'
    else
      RichEditLibrary_HWND := 0;
  end;
  //--
  if (RichEditLibrary_HWND = 0) then
  begin
    RichEditLibrary_HWND := LoadLibrary('RICHED20.DLL');
    if (RichEditLibrary_HWND <> 0) and (RichEditLibrary_HWND <>
      HINSTANCE_ERROR) then
    begin
      if UnicodeEnabledOS then
        RichEditClass := 'RichEdit20W'
      else
        RichEditClass := 'RichEdit20A';
    end
    else
      RichEditLibrary_HWND := 0;
  end;
  //--
  if (RichEditLibrary_HWND = 0) then
  begin
    RichEditLibrary_HWND := LoadLibrary('RICHED32.DLL');
    if (RichEditLibrary_HWND <> 0) and (RichEditLibrary_HWND <>
      HINSTANCE_ERROR) then
      RichEditClass := 'RICHEDIT'
    else
      RichEditLibrary_HWND := 0;
  end;
  //--
  if (RichEditLibrary_HWND = 0) then
  begin
    //'Aqui devo abortar a criação do componete!!!!'
  end;
  //--
  //--
  PrepareCreateWindow(AWinControl, AParams, Params);
  //--

  with Params do
  begin
    SubClassWndProc := @RichEditProc;

    Flags := Flags or ES_AUTOVSCROLL or ES_MULTILINE or ES_WANTRETURN;

    if TCustomRichBox(AWinControl).ReadOnly then
      Flags := Flags or ES_READONLY;
    Flags := Flags or AlignmentToEditFlags[TCustomRichBox(AWinControl).Alignment];
    case TCustomRichBox(AWinControl).ScrollBars of
      ssHorizontal, ssAutoHorizontal:
        Flags := Flags or WS_HSCROLL;
      ssVertical, ssAutoVertical:
        Flags := Flags or WS_VSCROLL;
      ssBoth, ssAutoBoth:
        Flags := Flags or WS_HSCROLL or WS_VSCROLL;
    end;
    if TCustomRichBox(AWinControl).WordWrap then
      Flags := Flags and not WS_HSCROLL
    else
      Flags := Flags or ES_AUTOHSCROLL;

    if TCustomRichBox(AWinControl).BorderStyle = bsSingle then
      FlagsEx := FlagsEx or WS_EX_CLIENTEDGE;

    pClassName := @RichEditClass[1];
    WindowTitle := StrCaption;
  end;
  //--
  FinishCreateWindow(AWinControl, Params, False);

  Params.WindowInfo^.needParentPaint := False;
  Result := Params.Window;
end;

class function TWin32WSCustomRichBox.Font_GetCharset(
  const AWinControl: TWinControl): TFontCharset;
var
  FMT: TCHARFORMAT2;
begin
  F_GetAttributes(AWinControl.Handle, FMT);
  Result := FMT.bCharset;
end;

class function TWin32WSCustomRichBox.Font_GetBackColor(
  const AWinControl :TWinControl) :TColor;
const
  CFE_AUTOBACKCOLOR = $04000000;
var
  FMT: TCHARFORMAT2;
begin
  F_GetAttributes(AWinControl.Handle, FMT);
  with FMT do
    if (dwEffects and CFE_AUTOBACKCOLOR) <> 0 then
      Result := clWindow
    else
      Result := crBackColor;
end;

class function TWin32WSCustomRichBox.Font_GetColor(
  const AWinControl: TWinControl): TColor;
var
  FMT: TCHARFORMAT2;
begin
  F_GetAttributes(AWinControl.Handle, FMT);
  with FMT do
    if (dwEffects and CFE_AUTOCOLOR) <> 0 then
      Result := clWindowText
    else
      Result := crTextColor;
end;

class function TWin32WSCustomRichBox.Font_GetName(
  const AWinControl: TWinControl): TFontName;
var
  FMT: TCHARFORMAT2;
begin
  F_GetAttributes(AWinControl.Handle, FMT);
  Result := FMT.szFaceName;
end;

class function TWin32WSCustomRichBox.Font_GetPitch(
  const AWinControl: TWinControl): TFontPitch;
var
  FMT: TCHARFORMAT2;
begin
  F_GetAttributes(AWinControl.Handle, FMT);
  case (FMT.bPitchAndFamily and $03) of
    DEFAULT_PITCH: Result := fpDefault;
    VARIABLE_PITCH: Result := fpVariable;
    FIXED_PITCH: Result := fpFixed;
    else
      Result := fpDefault;
  end;
end;

class function TWin32WSCustomRichBox.Font_GetProtected(
  const AWinControl: TWinControl): boolean;
var
  FMT: TCHARFORMAT2;
begin
  F_GetAttributes(AWinControl.Handle, FMT);
  with FMT do
    if (dwEffects and CFE_PROTECTED) <> 0 then
      Result := True
    else
      Result := False;
end;

class function TWin32WSCustomRichBox.Font_GetSize(
  const AWinControl: TWinControl): integer;
var
  FMT: TCHARFORMAT2;
begin
  F_GetAttributes(AWinControl.Handle, FMT);
  Result := FMT.yHeight div 20;
end;

class function TWin32WSCustomRichBox.Font_GetStyle(
  const AWinControl: TWinControl): TFontStyles;
var
  FMT: TCHARFORMAT2;
begin
  Result := [];
  F_GetAttributes(AWinControl.Handle, FMT);
  with FMT do
  begin
    if (dwEffects and CFE_BOLD) <> 0 then
      Include(Result, fsBold);
    if (dwEffects and CFE_ITALIC) <> 0 then
      Include(Result, fsItalic);
    if (dwEffects and CFE_UNDERLINE) <> 0 then
      Include(Result, fsUnderline);
    if (dwEffects and CFE_STRIKEOUT) <> 0 then
      Include(Result, fsStrikeOut);
  end;
end;

class function TWin32WSCustomRichBox.Para_GetAlignment(
  const AWinControl: TWinControl): {TAlignment} TRichEditAlignment;
var
  Paragraph: TPARAFORMAT2;
begin
  P_GetAttributes(AWinControl.Handle, Paragraph);
  Result := {TAlignment} TRichEditAlignment(Paragraph.wAlignment - 1);
end;

class function TWin32WSCustomRichBox.Para_GetFirstIndent(
  const AWinControl: TWinControl): Longint;
var
  Paragraph: TPARAFORMAT2;
begin
  P_GetAttributes(AWinControl.Handle, Paragraph);
  Result := Paragraph.dxOffset div 20;
end;

class function TWin32WSCustomRichBox.Para_GetLeftIndent(
  const AWinControl: TWinControl): Longint;
var
  Paragraph: TPARAFORMAT2;
begin
  P_GetAttributes(AWinControl.Handle, Paragraph);
  Result := Paragraph.dxStartIndent div 20
end;

class function TWin32WSCustomRichBox.Para_GetRightIndent(
  const AWinControl: TWinControl): Longint;
var
  Paragraph: TPARAFORMAT2;
begin
  P_GetAttributes(AWinControl.Handle, Paragraph);
  Result := Paragraph.dxRightIndent div 20;
end;

class function TWin32WSCustomRichBox.Para_GetNumbering(
  const AWinControl: TWinControl): TNumberingStyle;
var
  Paragraph: TPARAFORMAT2;
begin
  P_GetAttributes(AWinControl.Handle, Paragraph);
  Result := TNumberingStyle(Paragraph.wNumbering);
end;

class function TWin32WSCustomRichBox.Para_GetTab(
  const AWinControl: TWinControl; Index: Byte): Longint;
var
  Paragraph: TPARAFORMAT2;
begin
  P_GetAttributes(AWinControl.Handle, Paragraph);
  Result := Paragraph.rgxTabs[Index] div 20;
end;

class function TWin32WSCustomRichBox.Para_GetTabCount(
  const AWinControl: TWinControl): Integer;
var
  Paragraph: TPARAFORMAT2;
begin
  P_GetAttributes(AWinControl.Handle, Paragraph);
  Result := Paragraph.cTabCount;
end;

class procedure TWin32WSCustomRichBox.Font_SetCharset(const AWinControl: TWinControl;
  Value: TFontCharset);
var
  FMT: TCHARFORMAT2;
begin
  InitFMT(FMT);
  with FMT do
  begin
    dwMask := CFM_CHARSET;
    bCharSet := Value;
  end;
  F_SetAttributes(AWinControl.Handle, FMT);
end;

class procedure TWin32WSCustomRichBox.Font_SetBackColor(const AWinControl: TWinControl;
  Value: TColor);
const
  CFM_BACKCOLOR = $04000000;
var
  FMT: TCHARFORMAT2;
begin
  InitFMT(FMT);
  with FMT do
  begin
    dwMask := CFM_BACKCOLOR;
    crBackColor := ColorToRGB(Value);
  end;
  F_SetAttributes(AWinControl.Handle, FMT);
end;

class procedure TWin32WSCustomRichBox.Font_SetColor(const AWinControl: TWinControl;
  Value: TColor);
var
  FMT: TCHARFORMAT2;
begin
  InitFMT(FMT);
  with FMT do
  begin
    dwMask := CFM_COLOR;
    if Value = clWindowText then
      dwEffects := CFE_AUTOCOLOR
    else
      crTextColor := ColorToRGB(Value);
  end;
  F_SetAttributes(AWinControl.Handle, FMT);
end;

class procedure TWin32WSCustomRichBox.Font_SetName(const AWinControl: TWinControl;
  Value: TFontName);
var
  FMT: TCHARFORMAT2;
begin
  InitFMT(FMT);
  with FMT do
  begin
    dwMask := CFM_FACE;
    StrPLCopy(szFaceName, Value, SizeOf(szFaceName));
  end;
  F_SetAttributes(AWinControl.Handle, FMT);
end;

class procedure TWin32WSCustomRichBox.Font_SetPitch(const AWinControl: TWinControl;
  Value: TFontPitch);
var
  FMT: TCHARFORMAT2;
begin
  InitFMT(FMT);
  with FMT do
  begin
    case Value of
      fpVariable: FMT.bPitchAndFamily := VARIABLE_PITCH;
      fpFixed: FMT.bPitchAndFamily := FIXED_PITCH;
      else
        FMT.bPitchAndFamily := DEFAULT_PITCH;
    end;
  end;
  F_SetAttributes(AWinControl.Handle, FMT);
end;

class procedure TWin32WSCustomRichBox.Font_SetProtected(const AWinControl: TWinControl;
  Value: boolean);
var
  FMT: TCHARFORMAT2;
begin
  InitFMT(FMT);
  with FMT do
  begin
    dwMask := CFM_PROTECTED;
    if Value then
      dwEffects := CFE_PROTECTED;
  end;
  F_SetAttributes(AWinControl.Handle, FMT);
end;

class procedure TWin32WSCustomRichBox.Font_SetSize(const AWinControl: TWinControl;
  Value: integer);
var
  FMT: TCHARFORMAT2;
begin
  InitFMT(FMT);
  with FMT do
  begin
    dwMask := integer(CFM_SIZE);
    yHeight := Value * 20;
  end;
  F_SetAttributes(AWinControl.Handle, FMT);
end;

class procedure TWin32WSCustomRichBox.Font_SetStyle(const AWinControl: TWinControl;
  Value: TFontStyles);
var
  FMT: TCHARFORMAT2;
begin
  InitFMT(FMT);
  with FMT do
  begin
    dwMask := CFM_BOLD or CFM_ITALIC or CFM_UNDERLINE or CFM_STRIKEOUT;
    if fsBold in Value then
      dwEffects := dwEffects or CFE_BOLD;
    if fsItalic in Value then
      dwEffects := dwEffects or CFE_ITALIC;
    if fsUnderline in Value then
      dwEffects := dwEffects or CFE_UNDERLINE;
    if fsStrikeOut in Value then
      dwEffects := dwEffects or CFE_STRIKEOUT;
  end;
  F_SetAttributes(AWinControl.Handle, FMT);
end;

class procedure TWin32WSCustomRichBox.Para_SetAlignment(
  const AWinControl: TWinControl; Value: {TAlignment} TRichEditAlignment);
var
  Paragraph: TPARAFORMAT2;
begin
  InitPARAFMT(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_ALIGNMENT;
    wAlignment := Ord(Value) + 1;
  end;
  P_SetAttributes(AWinControl.Handle, Paragraph);
end;

class procedure TWin32WSCustomRichBox.Para_SetFirstIndent(
  const AWinControl: TWinControl; Value: Longint);
var
  Paragraph: TPARAFORMAT2;
begin
  InitPARAFMT(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_OFFSET;
    dxOffset := Value * 20;
  end;
  P_SetAttributes(AWinControl.Handle, Paragraph);
end;

class procedure TWin32WSCustomRichBox.Para_SetLeftIndent(
  const AWinControl: TWinControl; Value: Longint);
var
  Paragraph: TPARAFORMAT2;
begin
  InitPARAFMT(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_STARTINDENT;
    dxStartIndent := Value * 20;
  end;
  P_SetAttributes(AWinControl.Handle, Paragraph);
end;

class procedure TWin32WSCustomRichBox.Para_SetRightIndent(
  const AWinControl: TWinControl; Value: Longint);
var
  Paragraph: TPARAFORMAT2;
begin
  InitPARAFMT(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_RIGHTINDENT;
    dxRightIndent := Value * 20;
  end;
  P_SetAttributes(AWinControl.Handle, Paragraph);
end;

class procedure TWin32WSCustomRichBox.Para_SetNumbering(
  const AWinControl: TWinControl; Value: TNumberingStyle);
var
  Paragraph: TPARAFORMAT2;
begin
  case Value of
    nsBullets: if TWin32WSCustomRichBox.Para_GetLeftIndent(AWinControl) < 10 then
                 TWin32WSCustomRichBox.Para_SetLeftIndent(AWinControl, 10);
    nsNone: TWin32WSCustomRichBox.Para_SetLeftIndent(AWinControl, 0);
  end;
  InitPARAFMT(Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_NUMBERING;
    wNumbering := Ord(Value);
  end;
  P_SetAttributes(AWinControl.Handle, Paragraph);
end;

class procedure TWin32WSCustomRichBox.Para_SetTab(
  const AWinControl: TWinControl; Index: Byte; Value: Longint);
var
  Paragraph: TPARAFORMAT2;
begin
  InitPARAFMT(Paragraph);
  with Paragraph do
  begin
    rgxTabs[Index] := Value * 20;
    dwMask := PFM_TABSTOPS;
    if cTabCount < Index then cTabCount := Index;
    P_SetAttributes(AWinControl.Handle, Paragraph);
  end;
end;

class procedure TWin32WSCustomRichBox.Para_SetTabCount(
  const AWinControl: TWinControl; Value: Integer);
var
  Paragraph: TPARAFORMAT2;
begin
  P_GetAttributes(AWinControl.Handle, Paragraph);
  with Paragraph do
  begin
    dwMask := PFM_TABSTOPS;
    cTabCount := Value;
    P_SetAttributes(AWinControl.Handle, Paragraph);
  end;
end;

class function TWin32WSCustomRichBox.FindText(const AWinControl: TWinControl;
  const SearchStr: string; StartPos, Length: Integer; Options: TSearchTypes;
  Backwards :boolean): Integer;
var
  Find: TFINDTEXTEXW;
  Flags: Integer;
begin
  Find.chrg.cpMin := StartPos;
  Find.chrg.cpMax := Find.chrg.cpMin + Length;
  Find.chrgText.cpMin := 0;
  Find.chrgText.cpMax := 0;
  Find.lpstrText := PWideChar(UTF8Decode(SearchStr));
  if not Backwards then Flags := FR_DOWN else Flags := 0;
  if stWholeWord in Options then Flags := Flags or FR_WHOLEWORD;
  if stMatchCase in Options then Flags := Flags or FR_MATCHCASE;
  Result := Windows.SendMessage(AWinControl.Handle,
                                EM_FINDTEXTEXW, Flags, LPARAM(@Find));
end;

class function TWin32WSCustomRichBox.GetFirstVisibleLine(
  const AWinControl :TWinControl) :integer;
begin
  Result := Windows.SendMessage(AWinControl.Handle, EM_GETFIRSTVISIBLELINE , 0, 0)
end;

class function TWin32WSCustomRichBox.GetCaretCoordinates(const AWinControl: TWinControl)
  :TCaretCoordinates;
begin
  Result.Column := 0;
  Result.Line := 0;
  Result.Line := Windows.SendMessage(AWinControl.Handle, EM_LINEFROMCHAR,
                                  TlzRichEdit(AWinControl).SelStart, 0) ;
  Result.Column := TlzRichEdit(AWinControl).SelStart
              - Windows.SendMessage(AWinControl.Handle, EM_LINEINDEX,
                                    Result.Line, 0) ;
end;

class function TWin32WSCustomRichBox.GetCaretPoint(
  const AWinControl :TWinControl) :Classes.TPoint;
begin
  if LongInt(Windows.GetCaretPos(Result)) = 0 then
  begin
    Result.X := 0;
    Result.Y := 0;
  end;
end;

class procedure TWin32WSCustomRichBox.GetRTFSelection(const AWinControl:
  TWinControl; intoStream :TStream);
type
  TEditStreamCallBack = function (dwCookie: Longint; pbBuff: PByte;cb:
  Longint; var pcb: Longint): DWORD; stdcall;

TEditStream = record
  dwCookie: Longint;
  dwError: Longint;
  pfnCallback: TEditStreamCallBack;
end;
var
  editstream: TEditStream;
begin
  with editstream do
  begin
    dwCookie:= Longint(intoStream);
    dwError:= 0;
    pfnCallback:= @EditStreamOutCallBack;
end;
  Windows.SendMessage(AWinControl.Handle, EM_STREAMOUT, SF_RTF or SFF_SELECTION, longint(@editstream));
end;

class function TWin32WSCustomRichBox.GetScrollPoint(
  const AWinControl :TWinControl) :Classes.TPoint;
begin
  Windows.SendMessage(AWinControl.Handle, EM_GETSCROLLPOS, 0, LPARAM(@Result));
end;

class function TWin32WSCustomRichBox.GetSelText(const AWinControl :TWinControl
  ) :string;
var
  buf :array[0..MAX_PATH] of WideChar;
begin
  Windows.SendMessageW(AWinControl.Handle, EM_GETSELTEXT, 0, Longint(@buf));
  Result := buf;
end;

function GetWord(RichEdit: TlzRichEdit; FirstValue, SecondValue: Integer): string;
type
  TTextRange = record
    chrg: TCharRange;
    lpstrText: PAnsiChar;
  end;

  function RichEditGetTextRange(RichEdit: TlzRichEdit; BeginPos, MaxLength: Integer): string;
  var
   TextRange: TTextRange;
   CharBuffer :array[0..999] of WideChar;
  begin
    if MaxLength > 0 then
    begin
      TextRange.chrg.cpMin := BeginPos;
      TextRange.chrg.cpMax := BeginPos+MaxLength;
      TextRange.lpstrText := @CharBuffer;
      Windows.SendMessage(RichEdit.Handle, EM_GETTEXTRANGE, 0, Longint(@TextRange));
      Result := CharBuffer;
      Result := UTF8Encode(Result);
    end
      else Result := '';
  end;

  function CharIndexFromPoint(RichEdit: TlzRichEdit; X, Y: Integer): Integer;
  var
    P: TPoint;
  begin
    P := Point(X, Y);
    Result := Windows.SendMessage(RichEdit.Handle, EM_CHARFROMPOS, 0, Longint(@P));
  end;

var
  StartPos, EndPos: Integer;
begin
  if SecondValue > -1 then
    StartPos := CharIndexFromPoint(RichEdit, FirstValue, SecondValue)
  else
    StartPos := FirstValue;
  if (StartPos < 0) or
    (Windows.SendMessage(RichEdit.Handle,EM_FINDWORDBREAK,WB_CLASSIFY,StartPos) and
    (WBF_BREAKLINE or WBF_ISWHITE) <> 0 ) then
  begin
    Result := '';
    Exit;
  end;
  if Windows.SendMessage(RichEdit.Handle, EM_FINDWORDBREAK, WB_CLASSIFY, StartPos - 1) and
    (WBF_BREAKLINE or WBF_ISWHITE) = 0 then
    StartPos := Windows.SendMessage(RichEdit.Handle, EM_FINDWORDBREAK, WB_MOVEWORDLEFT, StartPos);
  EndPos := Windows.SendMessage(RichEdit.Handle, EM_FINDWORDBREAK, WB_MOVEWORDRIGHT, StartPos);
  Result := TrimRight(RichEditGetTextRange(RichEdit, StartPos, EndPos - StartPos));
end;

class function TWin32WSCustomRichBox.GetWordAtPoint(const AWinControl; X, Y :integer) :string;
begin
  Result := GetWord(TlzRichEdit(AWinControl), X, Y);
end;

class function TWin32WSCustomRichBox.GetWordAtPos(const AWinControl; Pos :integer) :string;
begin
  Result := GetWord(TlzRichEdit(AWinControl), Pos, -1);
end;

class function TWin32WSCustomRichBox.GetZoomState(const AWinControl :TWinControl
  ) :TZoomPair;
const
  EM_GETZOOM = WM_USER + 224;
begin
  Windows.SendMessage((AWinControl as TlzRichEdit).Handle, EM_SETZOOM,
                               WPARAM(@Result.Numerator), LPARAM(@Result.Denominator));
end;

class procedure TWin32WSCustomRichBox.Loaded(const AWinControl: TWinControl);
const
  TO_ADVANCEDTYPOGRAPHY = $1;
  EM_SETTYPOGRAPHYOPTIONS = (WM_USER + 202);
begin
  //inherited Loaded(AWinControl);

  Windows.SendMessage(AWinControl.Handle, EM_SETTYPOGRAPHYOPTIONS,
                      TO_ADVANCEDTYPOGRAPHY, TO_ADVANCEDTYPOGRAPHY);
end;

class procedure TWin32WSCustomRichBox.SaveToStream(const AWinControl: TWinControl;
  var Stream: TStream);
var
  EditStream_: TEditStream;
  StrType: integer;
begin
  EditStream_.dwCookie := longint(Pointer(@Stream));
  EditStream_.pfnCallback := @StreamSave;
  EditStream_.dwError := 0;

  if TCustomRichBox(AWinControl).PlainText then
    StrType := SF_TEXT
  else
    StrType := SF_RTF;

  SendMessage(AWinControl.Handle, EM_STREAMOUT, StrType, longint(@EditStream_));
end;

class procedure TWin32WSCustomRichBox.ScrolLine(const AWinControl :TWinControl;
  Delta :integer);
begin
  Windows.SendMessage(AWinControl.Handle, EM_LINESCROLL, 0, Delta);
end;

class procedure TWin32WSCustomRichBox.ScrollToCaret(
  const AWinControl :TWinControl);
begin
  Windows.SendMessage(AWinControl.Handle, EM_SCROLLCARET, 0, 0);
end;

class procedure TWin32WSCustomRichBox.SetColor(const AWinControl :TWinControl;
  AValue :TColor);
begin
  // many thanks to WP
  if not (csLoading in AWinControl.ComponentState) then
    Windows.SendMessage(AWinControl.Handle, EM_SETBKGNDCOLOR, 0, ColorToRGB(AValue));
end;

class procedure TWin32WSCustomRichBox.SetScrollPoint(
  const AWinControl :TWinControl; AValue :Classes.TPoint);
begin
  Windows.SendMessage(AWinControl.Handle, EM_SETSCROLLPOS, 0, Longint(@AValue));
end;

class procedure TWin32WSCustomRichBox.SetSelText(
  const AWinControl :TWinControl; AValue :string);
begin
  Windows.SendMessageW(AWinControl.Handle, EM_REPLACESEL , 1,
                                          Longint(PChar(widestring(AValue))));
end;

class procedure TWin32WSCustomRichBox.SetZoomState(
  const AWinControl :TWinControl; ZoomPair :TZoomPair);
const
  EM_SETZOOM = WM_USER + 225;
begin
  Windows.SendMessage(AWinControl.Handle, EM_SETZOOM,
                                     ZoomPair.Numerator, ZoomPair.Denominator);
end;

class procedure TWin32WSCustomRichBox.LoadFromStream(
  const AWinControl: TWinControl; const Stream: TStream);
var
  EditStream_: TEditStream;
  StrType: integer;
begin
  EditStream_.dwCookie := longint(Pointer(@Stream));
  EditStream_.pfnCallback := @StreamLoad;
  EditStream_.dwError := 0;

  if TCustomRichBox(AWinControl).PlainText then
    StrType := SF_TEXT
  else
    StrType := SF_RTF;

  SendMessage(AWinControl.Handle, EM_STREAMIN, StrType, LPARAM(@EditStream_));
end;

class procedure TWin32WSCustomRichBox.Print(const AWinControl: TWinControl;
  const DocumentTitle :string; Margins :TMargins);
const
  EM_GETTEXTLENGTHEX = WM_USER + 95;
  GTL_DEFAULT = 0;
var
  Range: TFormatRange;
  LastChar, MaxLen, LogX, LogY: Integer;
  n :Integer;
  TextLenEx: TGetTextLengthEx;
begin
  FillChar(Range, SizeOf(TFormatRange), 0);
  with Printer, Range do
  begin
    LogX :=  Printer.XDPI;
    LogY := Printer.YDPI;
    hdc := Printer.Canvas.Handle;
    hdcTarget := hdc;
    {----------}
    rc.Left := Margins.Left * 1440 div LogX;
    rc.Top := Margins.Top * 1440 div LogY;
    rc.Right := (PageWidth - Margins.Right)* 1440 div LogX;
    rc.Bottom := (PageHeight - Margins.Bottom) * 1440 div LogY;
    {----------}
    rcPage := rc;
    Title := DocumentTitle;
    BeginDoc;
    LastChar := 0;
    //---// if RichEdit version > 2
    TextLenEx.flags := GTL_DEFAULT;
    TextLenEx.codepage := CP_ACP;
    MaxLen := AWinControl.Perform(EM_GETTEXTLENGTHEX, WParam(@TextLenEx), 0);
    //---//
    chrg.cpMax := -1;
    Windows.SendMessage(AWinControl.Handle, EM_FORMATRANGE, 0, 0);    { flush buffer }
    try
    repeat
      chrg.cpMin := LastChar;
      LastChar := Windows.SendMessage(AWinControl.Handle, EM_FORMATRANGE, 1, LPARAM(@Range));
      if (LastChar < MaxLen) and (LastChar <> -1) then NewPage;
    until (LastChar >= MaxLen) or (LastChar = -1);
    EndDoc;
    finally
      Windows.SendMessage(AWinControl.Handle, EM_FORMATRANGE, 0, 0);   { flush buffer }
    end;
  end;
end;

class procedure TWin32WSCustomRichBox.PutRTFSelection(
  const AWinControl :TWinControl; sourceStream :TStream);
type
  TEditStreamCallBack = function (dwCookie: Longint; pbBuff: PByte;cb:
  Longint; var pcb: Longint): DWORD; stdcall;

  TEditStream = record
    dwCookie: Longint;
    dwError: Longint;
    pfnCallback: TEditStreamCallBack;
  end;
var
  editstream: TEditStream;
begin
  with editstream do
  begin
    dwCookie:= Longint(sourceStream);
    dwError:= 0;
    pfnCallback:= @EditStreamInCallBack;
  end;
  Windows.SendMessage(AWinControl.Handle, EM_STREAMIN, SF_RTF or SFF_SELECTION, longint(@editstream));
end;

class procedure TWin32WSCustomRichBox.Redo(const AWinControl :TWinControl);
const
  EM_REDO = WM_USER + 84;
begin
  Windows.SendMessage(AWinControl.Handle, EM_REDO, 0, 0);
end;

initialization

finalization
  if (RichEditLibrary_HWND <> 0) then
      FreeLibrary(RichEditLibrary_HWND);
end.

