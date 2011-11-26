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

unit Gtk2RTFTool;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls,Graphics, LCLType, LCLProc, IntfGraphics,
  GraphType, gtk2, glib2, gdk2, pango, Gtk2Proc, Gtk2Def, gdk2pixbuf, Gtk2Globals,
  Gtk2WSControls,
  RTFPars_lzRichEdit;

const BulletCode=$2022;

type

  TRTFPict = record
    PictType,
    W,
    H,
    WG,
    HG: integer;
    HEX: string;
  end;

TRSFontAttributes=record
  Charset: TFontCharset;
  Color: TColor;
  Name: TFontName;
  Pitch: TFontPitch;
  fProtected: Boolean;
  Size: Integer;
  Style: TFontStyles;
end;

TRSParaAttributes=record
  Alignment: TAlignment;
  FirstIndent: Integer;
  LeftIndent: Integer;
  RightIndent: Integer;
  Tab: Integer;
  TabCount: Integer;
end;

{ TRTFSave }

TRTFSave = class(TObject)
protected
  FTextView: TWinControl;
  FRTFout: TStringList;
  Ffonttbl: TStringList;
  Fcolortbl: TStringList;
  FFontAttributes: TRSFontAttributes;
private
  function AddFont(FontName: string): integer;
  function AddColor(Color: TColor): integer;
  function GetGTKTextBuffer(var TextBuffer: PGtkTextBuffer): boolean;
  function GetText(var S:String):boolean;
  function GetFontAttributes(const Position:Integer; var FontAttributes: TRSFontAttributes): boolean;
  function GetParaAttributes(const Position:Integer; var ParaAttributes: TRSParaAttributes): boolean;
  function Start:Boolean;
  function GetImage(BMP: TBitmap; Position:Integer):boolean;
public
  procedure SaveToStream(Stream: TStream);
  constructor Create(TextView: TWinControl);
  destructor Destroy; override;
end;


{ TRTFRead }

TRTFRead = class
private
  FRTFParser: TRTFParser;
  FTextView: TWinControl;
  RTFPict: TRTFPict;
  FIsPict: boolean;
  FGroups: integer;
  FSkipGroup: integer;
  //--
  FLastCharFontParams: Integer;
  FLastFontParams: TRSFontAttributes;
  FFontParams: TRSFontAttributes;
  //--
  FLastCharAlign: Integer;
  FLastAlign: TAlignment;
  FAlign: TAlignment;
  //--
  FLastCharLeftIndent: Integer;
  FLastLeftIndent: Integer;
  FLeftIndent: integer;

  FLastCharRightIndent:Integer;
  FLastRightIndent:Integer;
  FRightIndent: integer;

  FLastCharFirstIndent:Integer;
  FLastFirstIndent:Integer;
  FFirstIndent: integer;
  //--

  //--
  Buffer: PGtkTextBuffer;
private
  function GetGTKTextBuffer(var TextBuffer: PGtkTextBuffer): boolean;
  function GetText(var S:String):boolean;
  function GetLenText:Integer;
  procedure InsertPosLastChar(C:TUTF8Char);
  function GetRealTextBuf:String;
  procedure SetFormat(const iSelStart, iSelLength: integer; TextBuffer: PGtkTextBuffer; Tag: Pointer);
  procedure SetFirstIndent(Pos:Integer; Value: Longint; LPos:Integer=1);
  procedure SetLeftIndent(Pos:Integer; Value: Longint; LPos:Integer=1);
  procedure SetRightIndent(Pos:Integer; Value: Longint; LPos:Integer=1);
  procedure SetAlignment(Pos:Integer; Value: TAlignment; LPos:Integer=1);
  procedure SetTextAttributes(Pos:Integer; Value: TRSFontAttributes; LPos:Integer=1);
  procedure InsertImage(Image: TPicture);
  procedure AplATributs;
private
  procedure DoGroup;
  procedure DoWrite;
  procedure DoCtrl;
  //--
  procedure AplIndent;
  //--
  procedure DoSpecialChar;
  procedure DoParAttr;
  procedure DoCharAttr;
  procedure DoPictAttr;
  procedure DoBeginPict;
  procedure DoEndPict;
public
  procedure LoadFromStream(Stream: TStream);
  constructor Create(TextView: TWinControl);
  destructor Destroy; override;
end;


function PNGToRTF(PNG: TPortableNetworkGraphic): string;
function RTFToBMP(const S: string; DataType: integer; var Picture: TPicture;
  Width: integer = 0; Height: integer = 0): boolean;

implementation

function PNGToRTF(PNG: TPortableNetworkGraphic): string;
var
  MemoryStream: TMemoryStream;
  I, Len: integer;
  Buf: byte = $0;
begin
  Result := '{\pict\pngblip\picw' + IntToStr(PNG.Width * 15) +
    '\pich' + IntToStr(PNG.Height * 15) + '\picwgoal' +
    IntToStr(PNG.Width * 15) + '\pichgoal' + IntToStr(PNG.Height * 15) +
    UnicodeToUTF8($A);
  //--
  MemoryStream := TMemoryStream.Create;
  PNG.SaveToStream(MemoryStream);
  MemoryStream.Seek(0, soBeginning);
  Len := 0;
  //--
  for I := 0 to MemoryStream.Size do
  begin
    if Len = 39 then
    begin
      Result := Result + UnicodeToUTF8($A);
      Len := 0;
    end;
    MemoryStream.Read(Buf, 1);
    Result := Result + LowerCase(IntToHex(Buf, 2));
    Len := Len + 1;
  end;
  //--
  MemoryStream.Free;
  Result := Result + '}';
end;

function RTFToBMP(const S: string; DataType: integer; var Picture: TPicture;
  Width: integer; Height: integer): boolean;
var
    MStream: TMemoryStream;
    Pict: TPicture;
    I: integer = 1;
    B: byte = 0;
    L: integer;
    S2: string;
begin
    Result := False;
    MStream := TMemoryStream.Create;
    MStream.Seek(0, soBeginning);
    L := UTF8Length(S);
    while True do
    begin
      S2 := S[I] + S[I + 1];
      if (S2 <> '') then
        B := StrToInt('$' + trim(S2))
      else
        B := $0;
      MStream.Write(B, 1);
      I := I + 2;
      if (I > L) then
        Break;
    end;

    if DataType = 18 then
    begin
      MStream.Seek(0, soBeginning);
      if (Width = 0) and (Height = 0) then
        Picture.PNG.LoadFromStream(MStream)
      else
      begin
        Pict := TPicture.Create;
        Pict.PNG.LoadFromStream(MStream);
        //--
        Picture.PNG.Width := Width div 15;
        Picture.PNG.Height := Height div 15;
        Picture.PNG.Clear;
        Picture.PNG.Clear;
        //--
        Picture.PNG.Canvas.CopyRect(Rect(0, 0, Width div 15, Height div 15),
          Pict.PNG.Canvas,
          Rect(0, 0, Pict.PNG.Width, Pict.PNG.Height));
        Pict.Free;
      end;
      Result := True;
    end;

    MStream.Free;
end;

{ TRTFRead }

function TRTFRead.GetGTKTextBuffer(var TextBuffer: PGtkTextBuffer): boolean;
var
  AWidget: PGtkWidget;
begin
  Result:= False;
  //--
  AWidget := PGtkWidget(FTextView.Handle);
  AWidget := GetWidgetInfo(AWidget, False)^.CoreWidget;
  if not (Assigned(AWidget)) then
    Exit;
  //--
  TextBuffer := gtk_text_view_get_buffer(PGtkTextView(AWidget));
  if not (Assigned(TextBuffer)) then
    Exit;
  //--
  Result:= True;
end;

function TRTFRead.GetText(var S: String): boolean;
var
  iterStart, iterEnd: TGtkTextIter;
begin
  Result:= False;

  gtk_text_buffer_get_start_iter(Buffer, @iterStart);
  gtk_text_buffer_get_end_iter(Buffer, @iterEnd);
  S := gtk_text_buffer_get_slice(Buffer, @iterStart, @iterEnd, gboolean(False));

  Result:= True;
end;

function TRTFRead.GetLenText: Integer;
var
  Position: integer;
  iterStart: TGtkTextIter;
  Ch: TUTF8Char;
begin
  Result:= gtk_text_buffer_get_char_count(Buffer);
end;

procedure TRTFRead.InsertPosLastChar(C: TUTF8Char);
var
  Position: integer;
  iterStart: TGtkTextIter;
  Ch: TUTF8Char;
begin
  Ch := C;
  gtk_text_buffer_get_end_iter(Buffer, @iterStart);
  gtk_text_buffer_insert(Buffer, @iterStart, @Ch[1], Length(Ch));
end;

function TRTFRead.GetRealTextBuf: String;
begin
  Result:='';
  GetText(Result);
end;

procedure TRTFRead.SetFormat(const iSelStart, iSelLength: integer;
  TextBuffer: PGtkTextBuffer; Tag: Pointer);
var
  iterStart, iterEnd: TGtkTextIter;
begin
  gtk_text_buffer_get_iter_at_offset(TextBuffer, @iterStart, iSelStart);
  gtk_text_buffer_get_iter_at_offset(TextBuffer, @iterEnd, iSelStart + iSelLength);
  gtk_text_buffer_apply_tag(TextBuffer, tag, @iterStart, @iterEnd);
end;

procedure TRTFRead.SetFirstIndent(Pos: Integer; Value: Longint; LPos:Integer=1);
var
  Tag: Pointer = nil;
begin
  //--
  Tag := gtk_text_buffer_create_tag(buffer, nil, 'indent', [Value * 37,
    'indent-set', gboolean(gTRUE), nil]);

  SetFormat(Pos, LPos, Buffer, Tag);
end;

procedure TRTFRead.SetLeftIndent(Pos: Integer; Value: Longint; LPos:Integer=1);
var
  Tag: Pointer = nil;
begin
  //--

  Tag := gtk_text_buffer_create_tag(buffer, nil, 'left_margin', [Value * 37,
    'left_margin-set', gboolean(gTRUE), nil]);
  SetFormat(Pos, LPos, Buffer, Tag);
end;

procedure TRTFRead.SetRightIndent(Pos: Integer; Value: Longint; LPos:Integer=1);
var
  Tag: Pointer = nil;
begin
  //--

  Tag := gtk_text_buffer_create_tag(buffer, nil, 'right_margin', [Value *
    37, 'right_margin-set', gboolean(gTRUE), nil]);
  SetFormat(Pos, LPos, Buffer, Tag);
end;

procedure TRTFRead.SetAlignment(Pos: Integer; Value: TAlignment; LPos:Integer=1);
const
  GTKJustification: array [TAlignment] of integer = (GTK_JUSTIFY_LEFT, GTK_JUSTIFY_RIGHT, GTK_JUSTIFY_CENTER);
var
  Tag: Pointer = nil;
  StartLine, EndLine:Integer;
begin
  //--
    StartLine:=Pos;
    EndLine:= 1;
  //--

  Tag := gtk_text_buffer_create_tag(buffer, nil,
    'justification', [GTKJustification[Value], 'justification-set',
    gboolean(gTRUE), nil]);
  SetFormat(Pos, LPos, Buffer, Tag);
end;

procedure TRTFRead.SetTextAttributes(Pos: Integer; Value: TRSFontAttributes; LPos:Integer=1);
var
  FontFamily: string;
  FontColor: TGDKColor;
  Tag: Pointer = nil;
const
  PangoUnderline: array [boolean] of integer =
    (PANGO_UNDERLINE_NONE, PANGO_UNDERLINE_SINGLE);
  PangoBold: array [boolean] of integer = (PANGO_WEIGHT_NORMAL, PANGO_WEIGHT_BOLD);
  PangoItalic: array [boolean] of integer = (PANGO_STYLE_NORMAL, PANGO_STYLE_ITALIC);
begin

  FontColor := TColortoTGDKColor(Value.Color);
  //--
  FontFamily := Value.Name;
  if (FontFamily = '') then
    FontFamily := #0;
  //--

  Tag := gtk_text_buffer_create_tag(buffer, nil, 'family',
    [@FontFamily[1], 'family-set', gTRUE, 'size-points',
    double(Value.Size), 'foreground-gdk', @FontColor,
    'foreground-set', gboolean(gTRUE), 'underline',
    PangoUnderline[fsUnderline in Value.Style], 'underline-set',
    gboolean(gTRUE), 'weight', PangoBold[fsBold in Value.Style],
    'weight-set', gboolean(gTRUE), 'style',
    PangoItalic[fsItalic in Value.Style], 'style-set',
    gboolean(gTRUE), 'strikethrough', gboolean(fsStrikeOut in Value.Style),
    'strikethrough-set', gboolean(gTRUE), nil]);

  SetFormat(Pos, LPos, Buffer, Tag);
end;

procedure TRTFRead.InsertImage(Image: TPicture);
var
  iPosition: TGtkTextIter;
  GDIObj: PGDIObject = nil;
  pixbuf: PGDKPixBuf = nil;
  scaled: PGDKPixBuf = nil;
  pixmap: PGdkDrawable = nil;
  bitmap: PGdkBitmap = nil;
  iWidth, iHeight: integer;
begin

  //--
  gtk_text_buffer_get_end_iter(buffer, @iPosition);
  //--
  GDIObj := PGDIObject(Image.Bitmap.Handle);

  //--
  case GDIObj^.GDIBitmapType of
    gbBitmap:
    begin
      bitmap := GDIObj^.GDIBitmapObject;
      gdk_drawable_get_size(bitmap, @iWidth, @iHeight);
      pixbuf := CreatePixbufFromDrawable(bitmap, nil, False,
        0, 0, 0, 0, iWidth, iHeight);
    end;
    gbPixmap:
    begin
      pixmap := GDIObj^.GDIPixmapObject.Image;
      if pixmap <> nil then
      begin
        gdk_drawable_get_size(pixmap, @iWidth, @iHeight);
        bitmap := CreateGdkMaskBitmap(Image.Bitmap.Handle, 0);
        pixbuf := CreatePixbufFromImageAndMask(pixmap, 0, 0,
          iWidth, iHeight, nil, Bitmap);
      end;
    end;
    gbPixbuf:
    begin
      pixbuf := gdk_pixbuf_copy(GDIObj^.GDIPixbufObject);
    end;
  end;

  if (pixbuf <> nil) then
    gtk_text_buffer_insert_pixbuf(buffer, @iPosition, pixbuf);
end;

procedure TRTFRead.AplATributs;
var
  L:Integer;
begin
  L:= GetLenText;
  if (FLeftIndent <> FLastLeftIndent) then
    begin
      SetLeftIndent(FLastCharLeftIndent, FLastLeftIndent div 568, L - 1);
      FLastCharLeftIndent:= L-1;
      FLastLeftIndent:= FLeftIndent;
    end;

  if (FRightIndent <> FLastRightIndent) then
    begin
      SetRightIndent(FLastCharRightIndent, FLastRightIndent div 568, L - 1);
      FLastCharRightIndent:= L-1;
      FLastRightIndent:= FRightIndent;
    end;

  if (FFirstIndent <> FLastFirstIndent) then
    begin
      SetFirstIndent(FLastCharFirstIndent, FLastFirstIndent div 568, L - 1);
      FLastCharFirstIndent:= L-1;
      FLastFirstIndent:= FFirstIndent;
    end;

  if (FAlign <> FLastAlign) then
    begin
      SetAlignment(FLastCharAlign, FLastAlign, L - 1);
      FLastCharAlign:= L-1;
      FLastAlign:= FAlign;
    end;


  if (FFontParams.Name <> FLastFontParams.Name) or
     (FFontParams.Size <> FLastFontParams.Size) or
     (FFontParams.Color <> FLastFontParams.Color) or
     (FFontParams.Style <> FLastFontParams.Style) then
       begin
         SetTextAttributes(FLastCharFontParams, FLastFontParams, L - 1);
         FLastCharFontParams:= L - 1;

         FLastFontParams.Name:= FFontParams.Name;
         FLastFontParams.Size:= FFontParams.Size;
         FLastFontParams.Color:= FFontParams.Color;
         FLastFontParams.Style:= FFontParams.Style;
       end;
end;

procedure TRTFRead.DoGroup;
begin
  if (FRTFParser.RTFMajor = rtfBeginGroup) then
    FGroups := FGroups + 1
  else
    FGroups := FGroups - 1;
  if (FGroups < FSkipGroup) then
    FSkipGroup := -1;
end;

procedure TRTFRead.DoWrite;
var
  C: TUTF8char;
  L: integer;
begin
  C := UnicodeToUTF8(FRTFParser.RTFMajor);
  if FIsPict then
    RTFPict.HEX := RTFPict.HEX + C
  else
  begin
    if (FSkipGroup = -1) and (FRTFParser.RTFMajor = 183) then
    begin
      InsertPosLastChar(UnicodeToUTF8(BulletCode));
      FRTFParser.SkipGroup;
      AplIndent;
      C := chr($0);
    end;
    if (FSkipGroup = -1) and (C <> chr($0)) then
    begin
      InsertPosLastChar(C);
      L:= GetLenText;

      AplATributs;
    end;
  end;

end;

procedure TRTFRead.DoCtrl;
begin
  case FRTFParser.RTFMajor of
    rtfSpecialChar: DoSpecialChar;
    rtfParAttr: DoParAttr;
    rtfCharAttr: DoCharAttr;
    rtfPictAttr: DoPictAttr;
  end;
end;

procedure TRTFRead.AplIndent;
var
  I, L: integer;
  S: string;
begin
  S := GetRealTextBuf;
  L:= GetLenText;

  for I := L downto 0 do
  begin
    if (UTF8Copy(S, (I), 1) = UnicodeToUTF8($A)) or (I = 0) then
    begin
      if (FLeftIndent > 0) then
        SetLeftIndent(L - 1, FLeftIndent div 568);
      if (FRightIndent > 0) then
        SetRightIndent(L - 1, FRightIndent div 568);
      if (FFirstIndent > 0) then
        SetFirstIndent(L - 1, FFirstIndent div 568);
      SetAlignment(L - 1,  FAlign);
      Break;
    end;
  end;

end;

procedure TRTFRead.DoSpecialChar;
begin
  case FRTFParser.rtfMinor of
    rtfPar:
    begin
      if (FSkipGroup = -1) then
        InsertPosLastChar(#10);
    end;
    rtfTab:
    begin
      if (FSkipGroup = -1) then
        InsertPosLastChar(#9);
    end;
    rtfOptDest:
    begin
      if (FSkipGroup = -1) then
        FSkipGroup := FGroups;
    end;
  end;

end;

procedure TRTFRead.DoParAttr;
begin
  case FRTFParser.rtfMinor of
    rtfParDef:
    begin
      FAlign := taLeftJustify;
      FLeftIndent := 0;
      FRightIndent := 0;
      FFirstIndent:= 0;
    end;
    rtfQuadLeft:
    begin
      FAlign := taLeftJustify;
      AplIndent;
    end;
    rtfQuadRight:
    begin
      FAlign := taRightJustify;
      AplIndent;
    end;
    rtfQuadJust:
    begin
      FAlign := taLeftJustify;
      AplIndent;
    end;
    rtfQuadCenter:
    begin
      FAlign := taCenter;
      AplIndent;
    end;
    rtfFirstIndent:
    begin
      FFirstIndent:= FRTFParser.rtfParam;
      AplIndent;
    end;
    rtfLeftIndent:
    begin
      FLeftIndent := FRTFParser.rtfParam;
      AplIndent;
    end;
    rtfRightIndent:
    begin
      FRightIndent := FRTFParser.rtfParam;
      AplIndent;
    end;

  end;
end;

procedure TRTFRead.DoCharAttr;
var
  c: PRTFColor;
  f: PRTFFont;

  function Styles(S: TFontStyle): boolean;
  begin
    if (s in FFontParams.Style) then
      FFontParams.Style := FFontParams.Style - [S]
    else
      FFontParams.Style := FFontParams.Style + [S];

    Result := (S in FFontParams.Style);
  end;

begin
  case FRTFParser.rtfMinor of
    rtfBold:
    begin
      Styles(fsBold);
    end;
    rtfItalic:
    begin
      Styles(fsItalic);
    end;
    rtfStrikeThru:
    begin
      Styles(fsStrikeOut);
    end;
    rtfFontNum:
    begin
      f := FRTFParser.Fonts[FRTFParser.rtfParam];
      if (f = nil) then
        FFontParams.Name := 'Sans'
      else
        FFontParams.Name := f^.rtfFName;
    end;
    rtfFontSize:
    begin
      FFontParams.Size := FRTFParser.rtfParam div 2;
    end;
    rtfUnderline:
    begin
      Styles(fsUnderline);
    end;
    rtfNoUnderline:
    begin
      Styles(fsUnderline);
    end;
    rtfForeColor:
    begin
      C := FRTFParser.Colors[FRTFParser.rtfParam];
      if (C = nil) or (FRTFParser.rtfParam = 0) then
        FFontParams.Color := clWindowText
      else
        FFontParams.Color :=
          RGBToColor(C^.rtfCRed, C^.rtfCGreen, C^.rtfCBlue);
    end;
  end;
end;

procedure TRTFRead.DoPictAttr;
begin
  if (FRTFParser.rtfMajor = rtfPictAttr) and (FRTFParser.rtfMinor in
    [rtfMacQD .. rtfpngblip]) then
    case FRTFParser.rtfMinor of
      rtfPicWid: RTFPict.W := FRTFParser.rtfParam;
      rtfPicHt: RTFPict.H := FRTFParser.rtfParam;
      rtfPicGoalWid: RTFPict.WG := FRTFParser.rtfParam;
      rtfPicGoalHt: RTFPict.HG := FRTFParser.rtfParam;
      rtfpngblip: RTFPict.PictType := rtfpngblip;
    end;
end;

procedure TRTFRead.DoBeginPict;
begin
  RTFPict.HEX := '';
  RTFPict.H := 0;
  RTFPict.HG := 0;
  RTFPict.W := 0;
  RTFPict.WG := 0;
  RTFPict.PictType := -1;
  FIsPict := True;
end;

procedure TRTFRead.DoEndPict;
var
  Picture: TPicture;
  R: boolean = False;
  L:Integer;
begin
  FIsPict := False;
  Picture := TPicture.Create;

  if (RTFPict.WG = 0) and (RTFPict.HG = 0) or (RTFPict.WG = RTFPict.W) and
    (RTFPict.HG = RTFPict.H) then
    R := RTFToBMP(RTFPict.HEX, RTFPict.PictType, Picture)
  else
    R := RTFToBMP(RTFPict.HEX, RTFPict.PictType, Picture, RTFPict.WG, RTFPict.HG);

  if R then
  begin

    InsertImage(Picture);
    //--
    L:= GetLenText;
      if (FLeftIndent > 0) then
        SetLeftIndent(L - 1, FLeftIndent div 568);
      if (FRightIndent > 0) then
        SetRightIndent(L - 1, FRightIndent div 568);
      if (FFirstIndent > 0) then
        SetFirstIndent(L - 1, FFirstIndent div 568);
      SetAlignment(L - 1,  FAlign);
    SetTextAttributes(L - 1, FFontParams);
  end;

  Picture.Free;
end;

procedure TRTFRead.LoadFromStream(Stream: TStream);
begin
  //--
  FGroups := 0;
  FSkipGroup := -1;
  //--
  FRTFParser := TRTFParser.Create(Stream);
  FRTFParser.classcallbacks[rtfText] := @DoWrite;
  FRTFParser.classcallbacks[rtfcontrol] := @DoCtrl;
  FRTFParser.classcallbacks[rtfGroup] := @DoGroup;
  FRTFParser.OnRTFBeginPict := @DoBeginPict;
  FRTFParser.OnRTFEndPict := @DoEndPict;
  FRTFParser.StartReading;
  FRTFParser.Free;
  //--
  FLeftIndent:= -1;
  FRightIndent:= -1;
  FFirstIndent:= -1;

  if (FAlign= taLeftJustify) then
   FAlign:= taRightJustify
  else FAlign:= taLeftJustify;

  FFontParams.Name:='0';
  FFontParams.Size:=0;
  FFontParams.Style:=[];
  FFontParams.Color:=$0;
  AplATributs;

end;

constructor TRTFRead.Create(TextView: TWinControl);
begin
  inherited Create;
  FTextView := TextView;
  FIsPict := False;
  GetGTKTextBuffer(Buffer);
  //--
  FLastCharLeftIndent:=0;
  FLastLeftIndent:=0;

  FLastCharRightIndent:=0;
  FLastRightIndent:=0;

  FLastCharFirstIndent:=0;
  FLastFirstIndent:=0;
  //--
  FLastCharAlign:= 0;
  FLastAlign:= taLeftJustify;
  //--
  FLastCharFontParams:=0;
  FLastFontParams.Name:='';
  FLastFontParams.Size:=0;
  FLastFontParams.Color:=$0;
  FLastFontParams.Style:=[];
end;

destructor TRTFRead.Destroy;
begin
  inherited Destroy;
end;

{ TRTFSave }

function TRTFSave.AddFont(FontName: string): integer;
begin
  if Ffonttbl.Find(FontName, Result) then
    Exit;
  Result := Ffonttbl.Add(FontName);
end;

function TRTFSave.AddColor(Color: TColor): integer;
var
  R, G, B: byte;
  Par: string;
begin
  R := Red(Color);
  G := Green(Color);
  B := Blue(Color);
  Par := '\red' + IntToStr(R) + '\green' + IntToStr(G) + '\blue' + IntToStr(B);
  if FColortbl.Find(Par, Result) then
    Exit;
  Result := FColortbl.Add(Par);
end;

function TRTFSave.GetGTKTextBuffer(var TextBuffer: PGtkTextBuffer):boolean;
var
  AWidget: PGtkWidget;
begin
  Result:= False;
  //--
  AWidget := PGtkWidget(FTextView.Handle);
  AWidget := GetWidgetInfo(AWidget, False)^.CoreWidget;
  if not (Assigned(AWidget)) then
    Exit;
  //--
  TextBuffer := gtk_text_view_get_buffer(PGtkTextView(AWidget));
  if not (Assigned(TextBuffer)) then
    Exit;
  //--
  Result:= True;
end;

function TRTFSave.GetText(var S: String): boolean;
var
  iterStart, iterEnd: TGtkTextIter;
  Buffer: PGtkTextBuffer=nil;
begin
  Result:= False;
  if not (GetGTKTextBuffer(Buffer)) then
    Exit;

  gtk_text_buffer_get_start_iter(Buffer, @iterStart);
  gtk_text_buffer_get_end_iter(Buffer, @iterEnd);
  S := gtk_text_buffer_get_slice(Buffer, @iterStart, @iterEnd, gboolean(False));

  Result:= True;
end;

function TRTFSave.GetFontAttributes(const Position: Integer;
  var FontAttributes: TRSFontAttributes): boolean;
var
  Buffer: PGtkTextBuffer = nil;
  Attributes: PGtkTextAttributes;
  iPosition: TGtkTextIter;
begin
  Result:= False;
  //--
  if not (GetGTKTextBuffer(Buffer)) then
    Exit;

  //--
  Attributes := gtk_text_attributes_new;
  if not Assigned(Attributes) then
    Exit;
  //--
  gtk_text_buffer_get_iter_at_offset(buffer, @iPosition, Position);

  //--
  if (gtk_text_iter_get_attributes(@iPosition, Attributes)) then
  begin
    FontAttributes.Name := pango_font_description_get_family(Attributes^.font);
    FontAttributes.Size := pango_font_description_get_size(Attributes^.font);
    if not (pango_font_description_get_size_is_absolute(Attributes^.font)) then
      FontAttributes.Size := Round(FontAttributes.Size / PANGO_SCALE);
    FontAttributes.Color := TGDKColorToTColor(Attributes^.appearance.fg_color);
    //--
    FontAttributes.Style := [];
    //--
    if (Strikethrough(Attributes^.appearance) > 0) then
      Include(FontAttributes.Style, fsStrikeOut);
    if (underline(Attributes^.appearance) > 0) then
      Include(FontAttributes.Style, fsUnderline);
    //--
    if (pango_font_description_get_weight(Attributes^.font) = PANGO_WEIGHT_BOLD) then
      Include(FontAttributes.Style,fsBold);
    if (pango_font_description_get_style(Attributes^.font) = PANGO_STYLE_ITALIC) then
      Include(FontAttributes.Style,fsItalic);
    //--
    Result:= True;
  end;
  gtk_text_attributes_unref(Attributes);

end;

function TRTFSave.GetParaAttributes(const Position: Integer;
  var ParaAttributes: TRSParaAttributes): boolean;
var
  Buffer: PGtkTextBuffer = nil;
  Attributes: PGtkTextAttributes;
  iPosition: TGtkTextIter;
begin
  Result:= False;
  //--
  if not (GetGTKTextBuffer(Buffer)) then
    Exit;

  //--
  Attributes := gtk_text_attributes_new;
  if not Assigned(Attributes) then
    Exit;
  //--
  gtk_text_buffer_get_iter_at_offset(buffer, @iPosition, Position);

  //--
  if (gtk_text_iter_get_attributes(@iPosition, Attributes)) then
  begin
    case Attributes^.justification of
      GTK_JUSTIFY_LEFT: ParaAttributes.Alignment := taLeftJustify;
      GTK_JUSTIFY_RIGHT: ParaAttributes.Alignment := taRightJustify;
      GTK_JUSTIFY_CENTER: ParaAttributes.Alignment := taCenter;
    end;
    //--
    ParaAttributes.LeftIndent  := Attributes^.left_margin div 37;
    ParaAttributes.RightIndent := Attributes^.right_margin div 37;
    ParaAttributes.FirstIndent := Attributes^.indent div 37;
    //--

    Result:= True;
  end;
  gtk_text_attributes_unref(Attributes);
end;

function TRTFSave.Start: Boolean;
var
  S: String='';
  TextLen, I: Integer;
  IChar: Integer;
  CharLen: Integer;
  UChar: TUTF8Char;
  Line: String;
  LineCount: Integer=0;
  CodChar: Cardinal;
  NPara:Boolean=True;
  ParaAttributes: TRSParaAttributes;
  FontAttributes: TRSFontAttributes;
  Space: Boolean=False;
  Picture: TPicture;
begin
  Result:= False;
  //--Pega o texto no controle
  if not(GetText(S)) then Exit;
  //--
  FRTFout.Clear;
  Picture:= TPicture.Create;
  //--
  TextLen:= UTF8Length(S);
  //--
  FRTFout.Text:= '\pard';
  //--
  for IChar:=1 to  TextLen do
    begin
      UChar:= UTF8Copy(S, IChar, 1);
      CodChar:= UTF8CharacterToUnicode(@UChar[1], CharLen);
      //--
      //Novo Parágrafo
      if (CodChar=$A) then
        begin
          FRTFout[FRTFout.Count -1]:= FRTFout[FRTFout.Count -1] + '\par';
          FRTFout.Add('\pard');
          //--
          LineCount:= FRTFout.Count -1;
          //--
          NPara:= True;
        end;
      //---
      if (NPara) then
        begin
          //Resolve todas as questões do parágrafo
          //
          //-- Inicializa atributos de parágrafo
          ParaAttributes.LeftIndent:= 0;
          ParaAttributes.RightIndent:= 0;
          ParaAttributes.FirstIndent:= 0;
          ParaAttributes.Alignment:= taLeftJustify;

          //Pega as propriedades do parágrafo
          if (IChar > 1) then
            GetParaAttributes(IChar + 1, ParaAttributes)
          else
            GetParaAttributes(1, ParaAttributes);

          //Coloca o alinhamento
          case ParaAttributes.Alignment of
               taRightJustify: FRTFout[LineCount]:= FRTFout[LineCount] + '\qr';
               taCenter: FRTFout[LineCount]:= FRTFout[LineCount] + '\qc';
          end;

          //Parâmetros de identação
          if (ParaAttributes.LeftIndent > 0) then
          FRTFout[LineCount]:= FRTFout[LineCount] + '\li' + IntToStr(ParaAttributes.LeftIndent * 568);

          if (ParaAttributes.RightIndent > 0) then
          FRTFout[LineCount]:= FRTFout[LineCount] + '\ri' + IntToStr(ParaAttributes.RightIndent * 568);

          if (ParaAttributes.FirstIndent > 0) then
          FRTFout[LineCount]:= FRTFout[LineCount] + '\fi' + IntToStr(ParaAttributes.FirstIndent * 568);

          //Verifica se é um marcador
          if (TextLen > IChar) and (UTF8Copy(S, IChar + 1, 1) = UnicodeToUTF8(BulletCode)) or
             (IChar=1) and (UTF8Copy(S, 1, 1) = UnicodeToUTF8(BulletCode)) then
            begin
               //Insere o código para marcador em RTF
              FRTFout[LineCount]:= FRTFout[LineCount] + '{\pntext\f' + IntToStr(AddFont('Symbol')) + '\''B7\tab}{\*\pn\pnlvlblt\pnf' + IntToStr(AddFont('Symbol')) + '\pnindent0{\pntxtb\''B7}}';
            end;
           //--
          //NPara:= False;
        end;
      //--
      //Propriedades do Texto

      //--
      FontAttributes.Name:='Arial';
      FontAttributes.Size:=10;
      FontAttributes.Style:=[];
      FontAttributes.Color:=clWindowText;
      //--
      GetFontAttributes(IChar -1,  FontAttributes);
      //--
      if (FontAttributes.Name <> FFontAttributes.Name) or (NPara) then
        begin
          FRTFout[LineCount]:= FRTFout[LineCount] + '\f' + IntToStr(AddFont(FontAttributes.Name));
          FFontAttributes.Name := FontAttributes.Name;
          Space := True;
        end;
      if (FontAttributes.Size <> FFontAttributes.Size) or (NPara) then
        begin
          FRTFout[LineCount]:= FRTFout[LineCount] + '\fs' + IntToStr(FontAttributes.Size * 2);
          FFontAttributes.Size := FontAttributes.Size;
          Space := True;
        end;
       if (FontAttributes.Color <> FFontAttributes.Color) or (NPara) then
        begin
          FRTFout[LineCount]:= FRTFout[LineCount] + '\cf' + IntToStr(AddColor(FontAttributes.Color));
          FFontAttributes.Color := FontAttributes.Color;
          Space := True;
        end;
       //------
       if (fsBold in FontAttributes.Style) and not(fsBold in FFontAttributes.Style) then
         FRTFout[LineCount]:= FRTFout[LineCount] + '\b'
       else if (fsBold in FFontAttributes.Style) and not(fsBold in FontAttributes.Style) then
         FRTFout[LineCount]:= FRTFout[LineCount] + '\b0';
       //--
       if (fsItalic in FontAttributes.Style) and not(fsItalic in FFontAttributes.Style) then
         FRTFout[LineCount]:= FRTFout[LineCount] + '\i'
       else if (fsItalic in FFontAttributes.Style) and not(fsItalic in FontAttributes.Style) then
         FRTFout[LineCount]:= FRTFout[LineCount] + '\i0';
       //--
       if (fsUnderline in FontAttributes.Style) and not(fsUnderline in FFontAttributes.Style) then
         FRTFout[LineCount]:= FRTFout[LineCount] + '\ul'
       else if (fsUnderline in FFontAttributes.Style) and not(fsUnderline in FontAttributes.Style) then
         FRTFout[LineCount]:= FRTFout[LineCount] + '\ulnone';
       //--
       if FFontAttributes.Style <> FontAttributes.Style then Space:= true;
       FFontAttributes.Style := FontAttributes.Style;
       //-------
       if (CodChar= BulletCode) or (CodChar= $A) then
        begin
          UChar:='';
          CodChar:=$0;
        end;
        //---
       //Imagens
       if CodChar = $FFFC then
        begin
          Picture.Clear;
          GetImage(Picture.Bitmap, IChar -1);
          FRTFout[LineCount]:= FRTFout[LineCount] + PNGToRTF(Picture.PNG);
          UChar:= '';
          CodChar:=$0;
        end;
       //--
       //Tratamento de caracteres
       //TAB
       if CodChar = $9 then
       begin
         FRTFout[LineCount]:= FRTFout[LineCount] + '\tab';
          UChar:= '';
          CodChar:=$0;
         Space := True;
       end;
       //--
       //--Caracteres com código maior que 160
       if (CodChar > $A0) then
       begin
         FRTFout[LineCount]:= FRTFout[LineCount] + '\''' + UTF8LowerCase(IntToHex(CodChar, 2));
          UChar:= '';
          CodChar:=$0;
       end;
       //Simbolos especiais
       if (UChar = '\') or (UChar = '{') or (UChar = '}') then
         FRTFout[LineCount]:= FRTFout[LineCount] + '\';
       //--
       if Space then
        begin
          Space:= False;
          FRTFout[LineCount]:= FRTFout[LineCount] + ' ';
        end;
       //--

       FRTFout[LineCount]:= FRTFout[LineCount] + UChar;
    NPara:= False;
    end;

  //Finaliza paragrafo
  FRTFout[LineCount]:= FRTFout[LineCount] + '\par';
//-------
 //Finaliza a montágem do arquivo
 Line := '{\rtf1\ansi\deff0\adeflang1025{\fonttbl ';

  for I := 0 to (Ffonttbl.Count - 1) do
  begin
    Line := Line + '{\f' + IntToStr(I) + '\fswiss ' + Ffonttbl[I] + ';}';
  end;
  Line := Line + '}';

  Line := Line + UnicodeToUTF8($A);

  if (Fcolortbl.Count > 1) then
  begin
    Line := Line + '{\colortbl ';
    for I := 1 to (Fcolortbl.Count - 1) do
    begin
      Line := Line + ';' + Fcolortbl[I];
    end;
    Line := Line + ';}' + UnicodeToUTF8($A);
  end;

  Line := Line + '{\*\generator RTFTool 1.0;}\viewkind4';
  //--
  FRTFout.Insert(0, Line);
  FRTFout.Add('}');
  Picture.Free;
  Result:= True;
end;

function TRTFSave.GetImage(BMP: TBitmap; Position:Integer): boolean;
var
  Buffer: PGtkTextBuffer = nil;
  iPosition: TGtkTextIter;
  pixbuf: PGDKPixBuf = nil;
  BitmapData: TLazIntfImage = nil;
  Width, Height, rowstride, n_channels, i, j: integer;
  pixels, p: Pguchar;
  RawImageDescription: TRawImageDescription;
begin

  //--
  Result := False;
  //--
  if not (GetGTKTextBuffer(Buffer)) then
    Exit;

  //--
  gtk_text_buffer_get_iter_at_offset(buffer, @iPosition, Position);

  //--
  pixbuf := gtk_text_iter_get_pixbuf(@iPosition);

  //--
  if (pixbuf = nil) then
    Exit;

  n_channels := gdk_pixbuf_get_n_channels(pixbuf);
  Width := gdk_pixbuf_get_width(pixbuf);
  Height := gdk_pixbuf_get_height(pixbuf);
  rowstride := gdk_pixbuf_get_rowstride(pixbuf);
  pixels := gdk_pixbuf_get_pixels(pixbuf);

  BMP.Height := Height;
  BMP.Width := Width;
  BMP.PixelFormat := pf32bit;
  BMP.Transparent := True;
  //--
  BitmapData := BMP.CreateIntfImage;
  RawImageDescription := BitmapData.DataDescription;
  AddAlphaToDescription(RawImageDescription, 32);
  BitmapData.DataDescription := RawImageDescription;
  //--
  try
    for i := 0 to Width - 1 do
      for J := 0 to Height - 1 do
      begin
        p := pixels + j * rowstride + i * n_channels;
        PByteArray(BitmapData.PixelData)^[(((J * Width) + i) * 4)] := Ord((p + 2)^);
        PByteArray(BitmapData.PixelData)^[(((J * Width) + i) * 4) + 1] := Ord((p + 1)^);
        PByteArray(BitmapData.PixelData)^[(((J * Width) + i) * 4) + 2] := Ord((p + 0)^);
        PByteArray(BitmapData.PixelData)^[(((J * Width) + i) * 4) + 3] := Ord((P + 3)^);
      end;
    BMP.LoadFromIntfImage(BitmapData);
  finally
    BitmapData.Free;
  end;
  //--
  Result := True;
end;

procedure TRTFSave.SaveToStream(Stream: TStream);
begin
  Start;
  FRTFout.SaveToStream(Stream);
end;

constructor TRTFSave.Create(TextView: TWinControl);
begin
  inherited Create;
  Ffonttbl:= TStringList.Create;
  Fcolortbl:= TStringList.Create;
  FRTFout:= TStringList.Create;
  FTextView:= TextView;
end;

destructor TRTFSave.Destroy;
begin
  FRTFout.Free;
  Ffonttbl.Free;
  Fcolortbl.Free;
  inherited Destroy;
end;

end.

