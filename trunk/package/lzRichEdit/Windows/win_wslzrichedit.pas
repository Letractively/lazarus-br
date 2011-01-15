{
lzRichEdit

Copyright (C) 2010 Elson Junio elsonjunio@yahoo.com.br

This library is free software; you can redistribute it and/or modify it
under the terms of the GNU Library General Public License as published by
the Free Software Foundation; either version 2 of the License, or (at your
option) any later version with the following modification:

As a special exception, the copyright holders of this library give you
permission to link this library with independent modules to produce an
executable, regardless of the license terms of these independent modules,and
to copy and distribute the resulting executable under terms of your choice,
provided that you also meet, for each linked independent module, the terms
and conditions of the license of that module. An independent module is a
module which is not derived from or based on this library. If you modify
this library, you may extend this exception to your version of the library,
but you are not obligated to do so. If you do not wish to do so, delete this
exception statement from your version.

This library is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
for more details.

You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

unit Win_WSlzRichEdit;

{$mode objfpc}{$H+}

interface

uses
  Windows, richedit, Classes, SysUtils, Controls, LCLType, Win32Proc, Win32Int,
  Win32WSControls, StdCtrls, WSlzRichEdit, lzRichEditTypes, lzRichOle, RichOle,
  Dialogs, Graphics;

const
  CFM_BACKCOLOR = $4000000;
  CFE_AUTOBACKCOLOR = $4000000;

type

  { TWin_WSCustomlzRichEdit }

  TWin_WSCustomlzRichEdit = class(TWSCustomlzRichEdit)
    class procedure SetColor(const AWinControl: TWinControl); override;
    class function CreateHandle(const AWinControl: TWinControl;
      const AParams: TCreateParams): HWND; override;
    class procedure DestroyHandle(const AWinControl: TWinControl); override;
    class procedure SaveToStream(const AWinControl: TWinControl;
      var Stream: TStream); override;
    class procedure LoadFromStream(const AWinControl: TWinControl;
      const Stream: TStream); override;
    class procedure LoadFromStreamInSelStart(const AWinControl: TWinControl;
      const Stream: TStream); override;
    class procedure CloseObjects(const AWinControl: TWinControl); override;
    //--
    class procedure SetSelection(const AWinControl: TWinControl;
      StartPos, EndPos: integer; ScrollCaret: boolean); override;
    class procedure SetTextAttributes(const AWinControl: TWinControl;
      iSelStart, iSelLength: integer; const TextParams: TFontParams); override;
    class procedure GetTextAttributes(const AWinControl: TWinControl;
      Position: integer; var TextParams: TFontParams); override;
    class procedure ActiveRichOle(const AWinControl: TWinControl); override;
    class procedure DestroyRichOle(const AWinControl: TWinControl); override;
    class procedure GetAlignment(const AWinControl: TWinControl;
      Position: integer; var Alignment: TRichEdit_Align); override;
    class procedure SetAlignment(const AWinControl: TWinControl;
      iSelStart, iSelLength: integer; Alignment: TRichEdit_Align); override;
    class procedure SetNumbering(const AWinControl: TWinControl; N: boolean); override;
    class procedure GetNumbering(const AWinControl: TWinControl; var N: boolean); override;
    class procedure SetOffSetIndent(const AWinControl: TWinControl; I: integer); override;
    class procedure GetOffSetIndent(const AWinControl: TWinControl; var I: integer); override;
    class procedure SetRightIndent(const AWinControl: TWinControl;
      iSelStart, iSelLength: integer; I: integer); override;
    class procedure GetRightIndent(const AWinControl: TWinControl;
      Position: integer; var I: integer); override;
    class procedure SetStartIndent(const AWinControl: TWinControl;
      iSelStart, iSelLength: integer; I: integer); override;
    class procedure GetStartIndent(const AWinControl: TWinControl;
      Position: integer; var I: integer); override;
  end;

const
  RichEditClass: ansistring = '';

function StreamSave(dwCookie: PDWORD; pbBuff: LPBYTE; cb: LONG;
  var pcb: LONG): DWORD; stdcall;
function StreamLoad(dwCookie: PDWORD; pbBuff: LPBYTE; cb: LONG;
  var pcb: LONG): DWORD; stdcall;
function StreamLoadInSelStart(dwCookie: PDWORD; pbBuff: LPBYTE; cb: LONG;
  var pcb: LONG): DWORD; stdcall;

implementation

uses
  lzRichEdit;

var
  RichEditLibrary_HWND: THandle;


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

{ TWin_WSCustomlzRichEdit }

class function TWin_WSCustomlzRichEdit.CreateHandle(const AWinControl: TWinControl;
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

    if TCustomlzRichEdit(AWinControl).ReadOnly then
      Flags := Flags or ES_READONLY;
    Flags := Flags or AlignmentToEditFlags[TCustomlzRichEdit(AWinControl).Alignment];
    case TCustomlzRichEdit(AWinControl).ScrollBars of
      ssHorizontal, ssAutoHorizontal:
        Flags := Flags or WS_HSCROLL;
      ssVertical, ssAutoVertical:
        Flags := Flags or WS_VSCROLL;
      ssBoth, ssAutoBoth:
        Flags := Flags or WS_HSCROLL or WS_VSCROLL;
    end;
    if TCustomlzRichEdit(AWinControl).WordWrap then
      Flags := Flags and not WS_HSCROLL
    else
      Flags := Flags or ES_AUTOHSCROLL;

    if TCustomlzRichEdit(AWinControl).BorderStyle = bsSingle then
      FlagsEx := FlagsEx or WS_EX_CLIENTEDGE;

    //SubClassWndProc:= nil;
    pClassName := @RichEditClass[1];
    WindowTitle := StrCaption;
  end;
  //--
  FinishCreateWindow(AWinControl, Params, False);

  Params.WindowInfo^.needParentPaint := False;
  Result := Params.Window;
  //--
  if (csDesigning in AWinControl.ComponentState) then
    Exit;
  if TCustomlzRichEdit(AWinControl).ActiveRichOle then
    ActiveRichOle(AWinControl);
  //--

end;

class procedure TWin_WSCustomlzRichEdit.DestroyHandle(const AWinControl: TWinControl);
var
  Handle: HWND;
begin
  DestroyRichOle(AWinControl);
  try
    Handle := AWinControl.Handle;
    DestroyWindow(Handle);
  except
    //Instabilidade nesta parte após DestroyWindow causa uma Exception,
    //Ole32.dll
  end;

end;

function StreamSave(dwCookie: PDWORD; pbBuff: LPBYTE; cb: LONG;
  var pcb: LONG): DWORD; stdcall;
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

class procedure TWin_WSCustomlzRichEdit.SaveToStream(const AWinControl: TWinControl;
  var Stream: TStream);
var
  EditStream_: TEditStream;
  StrType: integer;
begin
  EditStream_.dwCookie := longint(Pointer(@Stream));
  EditStream_.pfnCallback := @StreamSave;
  EditStream_.dwError := 0;

  if TCustomlzRichEdit(AWinControl).PlainText then
    StrType := SF_TEXT
  else
    StrType := SF_RTF;

  SendMessage(TCustomlzRichEdit(AWinControl).Handle, EM_STREAMOUT,
    StrType, longint(@EditStream_));

end;

function StreamLoad(dwCookie: PDWORD; pbBuff: LPBYTE; cb: LONG;
  var pcb: LONG): DWORD; stdcall;
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

class procedure TWin_WSCustomlzRichEdit.LoadFromStream(const AWinControl: TWinControl;
  const Stream: TStream);
var
  EditStream_: TEditStream;
  StrType: integer;
begin
  EditStream_.dwCookie := longint(Pointer(@Stream));
  EditStream_.pfnCallback := @StreamLoad;
  EditStream_.dwError := 0;

  if TCustomlzRichEdit(AWinControl).PlainText then
    StrType := SF_TEXT
  else
    StrType := SF_RTF;

  //TCustomlzRichEdit(AWinControl).Perform(EM_STREAMIN, StrType, longint(@EditStream_));
  SendMessage(AWinControl.Handle, EM_STREAMIN, StrType, LPARAM(@EditStream_));

end;

function StreamLoadInSelStart(dwCookie: PDWORD; pbBuff: LPBYTE; cb: LONG;
  var pcb: LONG): DWORD; stdcall;
var
  s: TStream;
  SizeData: longint;
begin
  try
    s := TStream(dwCookie^);
    SizeData := s.Size - s.Position;

    if SizeData <= cb then
      pcb := s.Read(pbBuff^, SizeData);
    Result := 0;
  except
    Result := 1;
  end;

end;

class procedure TWin_WSCustomlzRichEdit.LoadFromStreamInSelStart(
  const AWinControl: TWinControl; const Stream: TStream);
var
  EditStream_: TEditStream;
  StrType: integer;
begin
  EditStream_.dwCookie := longint(Pointer(@Stream));
  EditStream_.pfnCallback := @StreamLoadInSelStart;
  EditStream_.dwError := 0;

  if TCustomlzRichEdit(AWinControl).PlainText then
    StrType := SF_TEXT
  else
    StrType := SF_RTF;

  //TCustomlzRichEdit(AWinControl).Perform(EM_STREAMIN, StrType or
  //  SFF_SELECTION, longint(@EditStream_));
  SendMessage(AWinControl.Handle, EM_STREAMIN, StrType, LPARAM(@EditStream_));
end;

class procedure TWin_WSCustomlzRichEdit.CloseObjects(const AWinControl: TWinControl);
var
  ReObject: TReObject;
  I: integer;
begin

  if Assigned(TRichOle(TCustomlzRichEdit(AWinControl).RichOle).RichEditOle) then
  begin
    FillChar(ReObject, SizeOf(ReObject), 0);
    ReObject.cbStruct := SizeOf(ReObject);

    with TRichOle(TCustomlzRichEdit(AWinControl).RichOle).RichEditOle do
      for I := GetObjectCount - 1 downto 0 do
        if Succeeded(GetObject(I, ReObject, REO_GETOBJ_POLEOBJ)) then
        begin
          if ReObject.dwFlags and REO_INPLACEACTIVE <> 0 then
            TRichOle(TCustomlzRichEdit(
              AWinControl).RichOle).RichEditOle.InPlaceDeactivate;
          ReObject.poleobj.Close(OLECLOSE_NOSAVE);

          if IUnknown(ReObject.poleobj) <> nil then
          begin
            IUnknown(ReObject.poleobj)._Release;
            IUnknown(ReObject.poleobj) := nil;
          end;
        end;
  end;
end;

class procedure TWin_WSCustomlzRichEdit.SetSelection(const AWinControl: TWinControl;
  StartPos, EndPos: integer; ScrollCaret: boolean);
var
  CharRange: TCharRange;
begin
  CharRange.cpMin := StartPos;
  CharRange.cpMax := StartPos + EndPos;

  SendMessage(AWinControl.Handle, EM_EXSETSEL, 0, longint(@CharRange));

  if ScrollCaret then
    SendMessage(AWinControl.Handle, EM_SCROLLCARET, 0, 0);

end;

class procedure TWin_WSCustomlzRichEdit.SetTextAttributes(
  const AWinControl: TWinControl; iSelStart, iSelLength: integer;
  const TextParams: TFontParams);
var
  fmt: TCHARFORMAT;
  Effects: longword = 0;
begin

  FillChar(fmt, sizeof(fmt), 0);
  fmt.cbSize := sizeof(fmt);

  fmt.dwMask := fmt.dwMask or CFM_COLOR;
  fmt.crTextColor := TextParams.Color;

  fmt.dwMask := fmt.dwMask or CFM_FACE;
  Move(TextParams.Name[1], fmt.szFaceName[0], LF_FACESIZE - 1);

  fmt.dwMask := fmt.dwMask or CFM_SIZE;
  fmt.yHeight := TextParams.Size * 20;

  //--
  if fsBold in TextParams.Style then
    Effects := Effects or CFE_BOLD;
  if fsItalic in TextParams.Style then
    Effects := Effects or CFE_ITALIC;
  if fsStrikeOut in TextParams.Style then
    Effects := Effects or CFE_STRIKEOUT;
  if fsUnderline in TextParams.Style then
    Effects := Effects or CFE_UNDERLINE;
  //--
  fmt.dwMask := fmt.dwMask or CFM_EFFECTS;
  fmt.dwEffects := Effects;
  //--
  SendMessage(AWinControl.Handle, EM_SETCHARFORMAT, SCF_SELECTION, longint(@fmt));
end;

class procedure TWin_WSCustomlzRichEdit.GetTextAttributes(
  const AWinControl: TWinControl; Position: integer; var TextParams: TFontParams);

var
  SelStart: integer;
  SelLength: integer;
  fmt: TCHARFORMAT;
begin
  SelStart := TCustomlzRichEdit(AWinControl).SelStart;
  SelLength := TCustomlzRichEdit(AWinControl).SelLength;
  //--
  SetSelection(AWinControl, SelStart, 1, False);
  //--
  FillChar(fmt, sizeof(fmt), 0);
  fmt.cbSize := sizeof(fmt);
  //--
  fmt.dwMask := CFM_COLOR or CFM_FACE or CFM_SIZE or CFM_EFFECTS;
  //--
  SendMessage(AWinControl.Handle, EM_GETCHARFORMAT, SCF_SELECTION, longint(@fmt));
  //--
  TextParams.Name := fmt.szFaceName;
  TextParams.Size := Round(fmt.yHeight / 20);
  TextParams.Color := fmt.crTextColor;
  //--
  TextParams.Style := [];
  if fmt.dwEffects and CFE_BOLD > 0 then
    Include(TextParams.Style, fsBold);
  if fmt.dwEffects and CFE_ITALIC > 0 then
    Include(TextParams.Style, fsItalic);
  if fmt.dwEffects and CFE_STRIKEOUT > 0 then
    Include(TextParams.Style, fsStrikeOut);
  if fmt.dwEffects and CFE_UNDERLINE > 0 then
    Include(TextParams.Style, fsUnderline);
  //--
  SetSelection(AWinControl, SelStart, SelLength, True);
end;

class procedure TWin_WSCustomlzRichEdit.ActiveRichOle(const AWinControl: TWinControl);
begin
  //--

  //if (TCustomlzRichEdit(AWinControl).RichOle = nil) then Exit;

  TCustomlzRichEdit(AWinControl).RichOle := TRichOle.Create(AWinControl);

  RichEdit_SetOleCallback(TCustomlzRichEdit(AWinControl).Handle,
    TRichOle(TCustomlzRichEdit(AWinControl).RichOle).RichEditOleCallback as
    IRichEditOleCallback);

  //ShowMessage(IntToStr(SendMessage(TCustomlzRichEdit(AWinControl).Handle, EM_SETOLECALLBACK, 0, LongInt(TRichOle(TCustomlzRichEdit(AWinControl).RichOle).RichEditOleCallback as IRichEditOleCallback))));
  //--

  RichEdit_GetOleInterface(TCustomlzRichEdit(AWinControl).Handle,
    TRichOle(TCustomlzRichEdit(AWinControl).RichOle).RichEditOle);
  //ShowMessage(IntToStr(SendMessage(TCustomlzRichEdit(AWinControl).Handle, EM_GETOLEINTERFACE, 0, LongInt(@TRichOle(TCustomlzRichEdit(AWinControl).RichOle).RichEditOle))));

end;

class procedure TWin_WSCustomlzRichEdit.DestroyRichOle(const AWinControl: TWinControl);
begin
  if (TCustomlzRichEdit(AWinControl).RichOle = nil) then
    Exit;
  CloseObjects(AWinControl);
  TRichOle(TCustomlzRichEdit(AWinControl).RichOle).Free;
  TCustomlzRichEdit(AWinControl).RichOle := nil;
end;

class procedure TWin_WSCustomlzRichEdit.GetAlignment(const AWinControl: TWinControl;
  Position: integer; var Alignment: TRichEdit_Align);

var
  P: PARAFORMAT;
begin
  FillChar(P, SizeOf(P), 0);
  P.cbSize := SizeOf(PARAFORMAT);
  P.dwMask := PFM_ALIGNMENT;
  SendMessage(AWinControl.Handle, EM_GETPARAFORMAT, 0, longint(@P));
  Alignment := TRichEdit_Align(P.wAlignment - 1);
end;

class procedure TWin_WSCustomlzRichEdit.SetAlignment(const AWinControl: TWinControl;
  iSelStart, iSelLength: integer; Alignment: TRichEdit_Align);

var
  P: PARAFORMAT;
begin
  FillChar(P, SizeOf(P), 0);
  P.cbSize := SizeOf(PARAFORMAT);
  P.dwMask := PFM_ALIGNMENT;
  P.wAlignment := Ord(Alignment) + 1;
  SendMessage(AWinControl.Handle, EM_SETPARAFORMAT, 0, longint(@P));
end;

class procedure TWin_WSCustomlzRichEdit.SetNumbering(const AWinControl: TWinControl;
  N: boolean);
var
  P: PARAFORMAT;
begin
  FillChar(P, SizeOf(P), 0);
  P.cbSize := SizeOf(PARAFORMAT);
  P.dwMask := PFM_NUMBERING;

  if N then
    P.wNumbering := PFN_BULLET
  else
    P.wNumbering := 0;

  SendMessage(AWinControl.Handle, EM_SETPARAFORMAT, 0, longint(@P));
end;

class procedure TWin_WSCustomlzRichEdit.GetNumbering(const AWinControl: TWinControl;
  var N: boolean);
var
  P: PARAFORMAT;
begin
  N := False;

  FillChar(P, SizeOf(P), 0);
  P.cbSize := SizeOf(PARAFORMAT);
  P.dwMask := PFM_NUMBERING;

  SendMessage(AWinControl.Handle, EM_GETPARAFORMAT, 0, longint(@P));

  if (P.wNumbering > 0) then
    N := True;
end;

class procedure TWin_WSCustomlzRichEdit.SetOffSetIndent(const AWinControl: TWinControl;
  I: integer);
var
  P: PARAFORMAT;
begin

  FillChar(P, SizeOf(P), 0);
  P.cbSize := SizeOf(PARAFORMAT);
  P.dwMask := PFM_OFFSET;
  P.dxOffset := I * 15;

  SendMessage(AWinControl.Handle, EM_SETPARAFORMAT, 0, longint(@P));
end;

class procedure TWin_WSCustomlzRichEdit.GetOffSetIndent(const AWinControl: TWinControl;
  var I: integer);
var
  P: PARAFORMAT;
begin

  FillChar(P, SizeOf(P), 0);
  P.cbSize := SizeOf(PARAFORMAT);
  P.dwMask := PFM_OFFSET;

  SendMessage(AWinControl.Handle, EM_GETPARAFORMAT, 0, longint(@P));

  I := P.dxOffset div 15;
end;

class procedure TWin_WSCustomlzRichEdit.SetRightIndent(const AWinControl: TWinControl;
  iSelStart, iSelLength: integer; I: integer);

var
  P: PARAFORMAT;
begin

  FillChar(P, SizeOf(P), 0);
  P.cbSize := SizeOf(PARAFORMAT);
  P.dwMask := PFM_RIGHTINDENT;
  P.dxRightIndent := I * 15;

  SendMessage(AWinControl.Handle, EM_SETPARAFORMAT, 0, longint(@P));
end;

class procedure TWin_WSCustomlzRichEdit.GetRightIndent(const AWinControl: TWinControl;
  Position: integer; var I: integer);

var
  P: PARAFORMAT;
begin

  FillChar(P, SizeOf(P), 0);
  P.cbSize := SizeOf(PARAFORMAT);
  P.dwMask := PFM_RIGHTINDENT;

  SendMessage(AWinControl.Handle, EM_GETPARAFORMAT, 0, longint(@P));

  I := P.dxRightIndent div 15;
end;

class procedure TWin_WSCustomlzRichEdit.SetStartIndent(const AWinControl: TWinControl;
  iSelStart, iSelLength: integer; I: integer);

var
  P: PARAFORMAT;
begin

  FillChar(P, SizeOf(P), 0);
  P.cbSize := SizeOf(PARAFORMAT);
  P.dwMask := PFM_STARTINDENT;
  P.dxStartIndent := I * 15;

  SendMessage(AWinControl.Handle, EM_SETPARAFORMAT, 0, longint(@P));

end;

class procedure TWin_WSCustomlzRichEdit.GetStartIndent(const AWinControl: TWinControl;
  Position: integer; var I: integer);

var
  P: PARAFORMAT;
begin

  FillChar(P, SizeOf(P), 0);
  P.cbSize := SizeOf(PARAFORMAT);
  P.dwMask := PFM_STARTINDENT;

  SendMessage(AWinControl.Handle, EM_GETPARAFORMAT, 0, longint(@P));

  I := P.dxStartIndent div 15;

end;

class procedure TWin_WSCustomlzRichEdit.SetColor(const AWinControl: TWinControl);
 { var
    fmt: TCharFormat2; }
begin
{  FillChar(fmt, sizeof(fmt), 0);
  fmt.cbSize := sizeof(fmt);

    with fmt do
    begin
      dwMask := CFM_BACKCOLOR;
      if (AWinControl.Color = clWindow) or (AWinControl.Color = clDefault) then
        dwEffects := CFE_AUTOBACKCOLOR
      else
        crBackColor := ColorToRGB(AWinControl.Color);
    end;
      SendMessage(AWinControl.Handle, EM_SETCHARFORMAT, 0, LongInt(@fmt));}
  SendMessage(AWinControl.Handle, EM_SETBKGNDCOLOR, 0, ColorToRGB(AWinControl.Color));
end;

initialization

finalization
  if (RichEditLibrary_HWND <> 0) then
    FreeLibrary(RichEditLibrary_HWND);
end.

