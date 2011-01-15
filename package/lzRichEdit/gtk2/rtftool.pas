{
lzRichEdit

Copyright (C) 2011 Elson Junio elsonjunio@yahoo.com.br

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
unit RTFTool;

{$mode objfpc}{$H+}
{$DEFINE SAVEPNG}
//{$DEFINE SAVEBMP}
interface

uses
  Classes, SysUtils, lzRichEdit, lzRichEditTypes, LCLProc, LCLType, Controls,
  Graphics, RTFToolImage, RTFPars_lzRichEdit;

type

  TRTFPict = record
    PictType,
    W,
    H,
    WG,
    HG: integer;
    HEX: string;
  end;

  { TRTFSave }

  TRTFSave = class
  private
    FText: string;
    FlzRichEdit: TWinControl;
    FParagAlign: TRichEdit_Align;
    FFontParams: TFontParams;
    FParagNumber: boolean;
    Ffonttbl: TStringList;
    Fcolortbl: TStringList;
    Fli, Fri: integer;
  public
    function AddFont(FontName: string): integer;
    function AddColor(Color: TColor): integer;
    function TagParagraph(iChar: integer): string;
    procedure SaveToStream(Stream: TStream);
    constructor Create(ilzRichEdit: TWinControl);
    destructor Destroy; override;
  end;

  { TRTFRead }

  TRTFRead = class
  private
    FRTFParser: TRTFParser;
    FlzRichEdit: TWinControl;
    RTFPict: TRTFPict;
    FIsPict: boolean;
    FGroups: integer;
    FSkipGroup: integer;
    FFontParams: TFontParams;
    FAlign: TRichEdit_Align;
    FLeftIndent: integer;
    FRightIndent: integer;
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
    constructor Create(ilzRichEdit: TWinControl);
    destructor Destroy; override;
  end;

implementation

{ RTFSave }

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

function TRTFSave.TagParagraph(iChar: integer): string;
var
  sAlign: TRichEdit_Align;
  SR: integer = 0;
  SL: integer = 0;
begin
  Result := '';
  //--
  TCustomlzRichEdit(FlzRichEdit).GetAlignment(iChar, sAlign);
  TCustomlzRichEdit(FlzRichEdit).GetStartIndent(iChar, SL);
  TCustomlzRichEdit(FlzRichEdit).GetRightIndent(iChar, SR);
  if (TCustomlzRichEdit(FlzRichEdit).GetNumbering(iChar) <> FParagNumber) or
    (sAlign <> FParagAlign) or (iChar = 0) or (SL <> Fli) or (SR <> Fri) then
  begin
    Result := '\pard';
    if TCustomlzRichEdit(FlzRichEdit).GetNumbering(iChar) then
    begin
      Result := Result + '{\pntext\f' + IntToStr(AddFont('Symbol')) +
        '\''B7\tab}{\*\pn\pnlvlblt\pnf' + IntToStr(AddFont('Symbol')) +
        '\pnindent0{\pntxtb\''B7}}';
    end;
    FParagNumber := TCustomlzRichEdit(FlzRichEdit).GetNumbering(iChar);
    //--
    TCustomlzRichEdit(FlzRichEdit).GetAlignment(iChar, sAlign);
    case sAlign of
      lzRichEditTypes.alRight: Result := Result + '\qr';
      lzRichEditTypes.alCenter: Result := Result + '\qc';
    end;
    FParagAlign := sAlign;
    //--
    TCustomlzRichEdit(FlzRichEdit).GetStartIndent(iChar, SL);
    if (SL > 0) then
      Result := Result + '\li' + IntToStr(SL * 568);
    Fli := SL;
    //--
    TCustomlzRichEdit(FlzRichEdit).GetRightIndent(iChar, SR);
    if (SR > 0) then
      Result := Result + '\ri' + IntToStr(SR * 568);
    Fri := SR;
    //--
    Exit;
  end;
  //--
  if TCustomlzRichEdit(FlzRichEdit).GetNumbering(iChar) then
  begin
    Result := Result + '{\pntext\f' + IntToStr(AddFont('Symbol')) + '\''B7\tab}';
  end;
  FParagNumber := TCustomlzRichEdit(FlzRichEdit).GetNumbering(iChar);
  //--
  if (IChar = 1) and (Result = '') then
    Result := '\pard';

end;

procedure TRTFSave.SaveToStream(Stream: TStream);
var
  I, Len: integer;
  CH: TUTF8Char = '';
  oText: string = '';
  Space: boolean = False;
  FontParams: TFontParams;
  Cab: string;
  StringList: TStringList;
  Picture: TPicture;
begin
  if TCustomlzRichEdit(FlzRichEdit).PlainText then
  begin
    TCustomlzRichEdit(FlzRichEdit).Lines.SaveToStream(Stream);
    Exit;
  end;
  //--
  FText := TCustomlzRichEdit(FlzRichEdit).Text;
  //--
  AddFont('Sans');
  AddColor(clWindowText);
  //--
  for I := 1 to UTF8Length(FText) do
  begin
    CH := UTF8Copy(FText, I, 1);
    //-- Paragraph
    if (I = 1) or (UTF8CharacterToUnicode(@CH[1], Len) = $A) then
    begin
      if (I = 1) and (UTF8CharacterToUnicode(@CH[1], Len) = $A) then
        oText := oText + '\pard\par' + UnicodeToUTF8($A);
      if (I > 1) then
        oText := oText + '\par' + UnicodeToUTF8($A);
      if (I = 1) and (UTF8CharacterToUnicode(@CH[1], Len) <> $A) then
        oText := oText + TagParagraph(I - 1)
      else
        oText := oText + TagParagraph(I);
      Space := True;
    end;
    //--
    //--Image-------------------------------------------------------------------
    if (UTF8CharacterToUnicode(@CH[1], Len) = $FFFC) then
    begin
      Picture := TPicture.Create;
        {$IFDEF SAVEPNG}
      if (TCustomlzRichEdit(FlzRichEdit).GetImage(I - 1, Picture)) then
        oText := oText + PNGToRTF(Picture.PNG);
        {$ENDIF}
        {$IFDEF SAVEBMP}
      if (TCustomlzRichEdit(FlzRichEdit).GetImage(I - 1, Picture)) then
        oText := oText + BMPToRTF(Picture.Bitmap);
        {$ENDIF}
      CH := '000000';
      CH := '';
      Picture.Free;
    end;
    //--
    if not (UTF8CharacterToUnicode(@CH[1], Len) = $A) and
      (CH <> TCustomlzRichEdit(FlzRichEdit).NumberingParams.NChar) then
    begin
      FontParams := DefFontParams;
      TCustomlzRichEdit(FlzRichEdit).GetTextAttributes(I - 1, FontParams);
      //--
      if (FontParams.Name <> FFontParams.Name) then
      begin
        oText := oText + '\f' + IntToStr(AddFont(FontParams.Name));
        FFontParams.Name := FontParams.Name;
        Space := True;
      end;
      //--
      if (FontParams.Size <> FFontParams.Size) then
      begin
        oText := oText + '\fs' + IntToStr(FontParams.Size * 2);
        FFontParams.Size := FontParams.Size;
        Space := True;
      end;
      //--
      if (FontParams.Color <> FFontParams.Color) then
      begin
        oText := oText + '\cf' + IntToStr(AddColor(FontParams.Color));
        FFontParams.Color := FontParams.Color;
        Space := True;
      end;
      //--
      if (FontParams.Style <> FFontParams.Style) then
      begin
        //--
        if (fsBold in FontParams.Style) and not
          (fsBold in FFontParams.Style) then
          oText := oText + '\b'
        else if (fsBold in FFontParams.Style) and not
          (fsBold in FontParams.Style) then
          oText := oText + '\b0';
        //--
        if (fsItalic in FontParams.Style) and not
          (fsItalic in FFontParams.Style) then
          oText := oText + '\i'
        else if (fsItalic in FFontParams.Style) and not
          (fsItalic in FontParams.Style) then
          oText := oText + '\i0';
        //--
        if (fsUnderline in FontParams.Style) and not
          (fsUnderline in FFontParams.Style) then
          oText := oText + '\ul'
        else if (fsUnderline in FFontParams.Style) and not
          (fsUnderline in FontParams.Style) then
          oText := oText + '\ulnone';
        //--
        FFontParams.Style := FontParams.Style;
        Space := True;
      end;
      //--
      if UTF8CharacterToUnicode(@CH[1], Len) = $9 then
      begin
        oText := oText + '\tab';
        CH := '';
        Space := True;
      end;
      if Space then
      begin
        oText := oText + ' ';
        Space := False;
      end;
      //--
      if (UTF8CharacterToUnicode(@CH[1], Len) > $A0) then
      begin
        oText := oText + '\''' + UTF8LowerCase(
          IntToHex(UTF8CharacterToUnicode(@CH[1], Len), 2));
        CH := '';
      end;
      //--
      if (CH = '\') or (CH = '{') or (CH = '}') then
        oText := oText + '\';
      //--
      oText := oText + CH;
    end;
  end;
  //--
  oText := oText + '\par';
  //--
  Cab := '{\rtf1\ansi\deff0\adeflang1025{\fonttbl ';

  for I := 0 to (Ffonttbl.Count - 1) do
  begin
    Cab := Cab + '{\f' + IntToStr(I) + '\fswiss ' + Ffonttbl[I] + ';}';
  end;
  Cab := Cab + '}';

  Cab := Cab + UnicodeToUTF8($A);

  if (Fcolortbl.Count > 1) then
  begin
    Cab := Cab + '{\colortbl ';
    for I := 1 to (Fcolortbl.Count - 1) do
    begin
      Cab := Cab + ';' + Fcolortbl[I];
    end;
    Cab := Cab + ';}' + UnicodeToUTF8($A);
  end;

  Cab := Cab + '{\*\generator RTFTool 1.0;}\viewkind4';
  //--
  oText := Cab + oText + UnicodeToUTF8($A) + '}';
  //--
  StringList := TStringList.Create;
  StringList.Text := oText;
  StringList.SaveToStream(Stream);
  StringList.Free;
end;

constructor TRTFSave.Create(ilzRichEdit: TWinControl);
begin
  inherited Create;
  FParagNumber := False;
  Ffonttbl := TStringList.Create;
  Fcolortbl := TStringList.Create;
  Fli := 0;
  Fri := 0;
  FParagAlign := lzRichEditTypes.alJustify;
  FFontParams.Name := '';
  FFontParams.Color := $0;
  FFontParams.Size := 0;
  FFontParams.Style := [];

  if Assigned(ilzRichEdit) then
    FlzRichEdit := ilzRichEdit
  else
    FlzRichEdit := nil;
end;

destructor TRTFSave.Destroy;
begin
  Ffonttbl.Free;
  Fcolortbl.Free;
  inherited Destroy;
end;

{ TRTFRead }

procedure TRTFRead.DoGroup;
begin
  if (FRTFParser.RTFMajor = rtfBeginGroup) then
    FGroups := FGroups + 1
  else
    FGroups := FGroups - 1;
  if (FGroups < FSkipGroup) then
    FSkipGroup := -1;

  {WriteLn('------------DoGroup---' +
           IntToStr(FRTFParser.RTFMajor) +
           '--FGroups:' + IntToStr(FGroups) +
           '---FSkipGroup:' + IntToStr(FSkipGroup));}

end;

procedure TRTFRead.DoWrite;
var
  C: char;
  //CH:TUTF8Char;
  //I:Integer;
  L: integer;
begin
  C := chr(FRTFParser.RTFMajor);
  if FIsPict then
    RTFPict.HEX := RTFPict.HEX + C
  else
  begin
    if (FSkipGroup = -1) and (FRTFParser.RTFMajor = 183) or
      (FSkipGroup = -1) and
      (C = TCustomlzRichEdit(FlzRichEdit).NumberingParams.NChar) then
    begin
      TCustomlzRichEdit(FlzRichEdit).SetNumbering(True);
      FRTFParser.SkipGroup;
      AplIndent;
      C := chr($0);
    end;
    if (FSkipGroup = -1) and (C <> chr($0)) then
    begin
      TCustomlzRichEdit(FlzRichEdit).InsertPosLastChar(C);
      L := UTF8Length(TCustomlzRichEdit(FlzRichEdit).Text);
      if (FLeftIndent > 0) then
        TCustomlzRichEdit(FlzRichEdit).SetStartIndent(L - 1, 1, FLeftIndent div 568);
      if (FRightIndent > 0) then
        TCustomlzRichEdit(FlzRichEdit).SetRightIndent(L - 1, 1, FRightIndent div 568);
      TCustomlzRichEdit(FlzRichEdit).SetAlignment(L - 1, 1, FAlign);
      TCustomlzRichEdit(FlzRichEdit).SetTextAttributes(L - 1, 1, FFontParams);
    end;
  end;


  //--
  {WriteLn('--DoWrite--');
  WriteLn('--C--' + C);
  WriteLn('FRTFParser.RTFMajor' + IntToStr(FRTFParser.RTFMajor));
  WriteLn('FRTFParser.rtfMinor' + IntToStr(FRTFParser.rtfMinor));
  WriteLn('FRTFParser.rtfClass' + IntToStr(FRTFParser.rtfClass));
  WriteLn('FRTFParser.rtfParam' + IntToStr(FRTFParser.rtfParam));
  WriteLn('FSkipGroup:' + IntToStr(FSkipGroup));}
end;

procedure TRTFRead.DoCtrl;
begin
  //--
  case FRTFParser.RTFMajor of
    rtfSpecialChar: DoSpecialChar;
    rtfParAttr: DoParAttr;
    rtfCharAttr: DoCharAttr;
    rtfPictAttr: DoPictAttr;
  end;
  //--
end;

procedure TRTFRead.AplIndent;
var
  I, L: integer;
  S: string;
begin
  S := TCustomlzRichEdit(FlzRichEdit).Text;
  L := UTF8Length(S);

  for I := L downto 0 do
  begin
    if (UTF8Copy(S, (I), 1) = UnicodeToUTF8($A)) or (I = 0) then
    begin
      //WriteLn('DoWrite: I:' + IntToStr(I) + ' FLeftIndent:' + IntToStr(FLeftIndent) + ' UTF8Length:' + IntToStr(L));
      if (FLeftIndent > 0) then
        TCustomlzRichEdit(FlzRichEdit).SetStartIndent(I, L - I, FLeftIndent div 568);
      if (FRightIndent > 0) then
        TCustomlzRichEdit(FlzRichEdit).SetRightIndent(I, L - I, FRightIndent div 568);
      TCustomlzRichEdit(FlzRichEdit).SetAlignment(I, L - I, FAlign);
      Break;
    end;
  end;
end;

procedure TRTFRead.DoSpecialChar;
begin
  //WriteLn('--DoSpecialChar--');
  case FRTFParser.rtfMinor of
    //rtfCurHeadPage          :WriteLn('rtfCurHeadPage');
    //rtfCurFNote             :WriteLn('rtfCurFNote');
    //rtfCurHeadPict          :WriteLn('rtfCurHeadPict');
    //rtfCurHeadDate          :WriteLn('rtfCurHeadDate');
    //rtfCurHeadTime          :WriteLn('rtfCurHeadTime');
    //rtfFormula              :WriteLn('rtfFormula');
    //rtfNoBrkSpace           :WriteLn('rtfNoBrkSpace');
    //rtfNoReqHyphen          :WriteLn('rtfNoReqHyphen');
    //rtfNoBrkHyphen          :WriteLn('rtfNoBrkHyphen');
    //rtfPage                 :WriteLn('rtfPage');
    //rtfLine                 :WriteLn('rtfLine');
    rtfPar:
    begin
      if (FSkipGroup = -1) then
        TCustomlzRichEdit(
          FlzRichEdit).InsertPosLastChar(#10);
      //WriteLn('rtfPar');
    end;
    //rtfSect                 :WriteLn('rtfSect');
    rtfTab:
    begin
      if (FSkipGroup = -1) then
        TCustomlzRichEdit(
          FlzRichEdit).InsertPosLastChar(#9);
      //WriteLn('rtfTab');
    end;
    //rtfCell                 :WriteLn('rtfCell');
    //rtfRow                  :WriteLn('rtfRow');
    //rtfCurAnnot             :WriteLn('rtfCurAnnot');
    //rtfAnnotation           :WriteLn('rtfAnnotation');
    //rtfAnnotID              :WriteLn('rtfAnnotID');
    //rtfCurAnnotRef          :WriteLn('rtfCurAnnotRef');
    //rtfFNoteSep             :WriteLn('rtfFNoteSep');
    //rtfFNoteCont            :WriteLn('rtfFNoteCont');
    //rtfColumn               :WriteLn('rtfColumn');
    rtfOptDest:
    begin
      if (FSkipGroup = -1) then
        FSkipGroup := FGroups;
      //WriteLn('rtfOptDest');
    end;
    //rtfIIntVersion          :WriteLn('rtfIIntVersion');
    //rtfICreateTime          :WriteLn('rtfICreateTime');
    //rtfIRevisionTime        :WriteLn('rtfIRevisionTime');
    //rtfIPrintTime           :WriteLn('rtfIPrintTime');
    //rtfIBackupTime          :WriteLn('rtfIBackupTime');
    //rtfIEditTime            :WriteLn('rtfIEditTime');
    //rtfIYear                :WriteLn('rtfIYear');
    //rtfIMonth               :WriteLn('rtfIMonth');
    //rtfIDay                 :WriteLn('rtfIDay');
    //rtfIHour                :WriteLn('rtfIHour');
    //rtfIMinute              :WriteLn('rtfIMinute');
    //rtfINPages              :WriteLn('rtfINPages');
    //rtfINWords              :WriteLn('rtfINWords');
    //rtfINChars              :WriteLn('rtfINChars');
    //rtfIIntID               :WriteLn('rtfIIntID');
  end;
  //WriteLn('');
end;

procedure TRTFRead.DoParAttr;
begin
  //  WriteLn('--DoParAttr--');
  case FRTFParser.rtfMinor of
    rtfParDef:
    begin
      //FFontParams:= DefFontParams;
      FAlign := lzRichEditTypes.alLeft;
      FLeftIndent := 0;
      FRightIndent := 0;
      //WriteLn('rtfParDef');
    end;
    //rtfStyleNum             :WriteLn('rtfStyleNum');
    rtfQuadLeft:
    begin
      FAlign := lzRichEditTypes.alLeft;
      //WriteLn('rtfQuadLeft');
      AplIndent;
    end;
    rtfQuadRight:
    begin
      FAlign := lzRichEditTypes.alRight;
      //WriteLn('rtfQuadRight');
      AplIndent;
    end;
    rtfQuadJust:
    begin
      FAlign := lzRichEditTypes.alJustify;
      //WriteLn('rtfQuadJust');
      AplIndent;
    end;
    rtfQuadCenter:
    begin
      FAlign := lzRichEditTypes.alCenter;
      //WriteLn('rtfQuadCenter');
      AplIndent;
    end;
    //rtfFirstIndent          :WriteLn('rtfFirstIndent');
    rtfLeftIndent:
    begin
      FLeftIndent := FRTFParser.rtfParam;
      //WriteLn('rtfLeftIndent');
      AplIndent;
    end;
    rtfRightIndent:
    begin
      FRightIndent := FRTFParser.rtfParam;
      //WriteLn('rtfRightIndent');
      AplIndent;
    end;
    //rtfSpaceBefore          :WriteLn('rtfSpaceBefore');
    //rtfSpaceAfter           :WriteLn('rtfSpaceAfter');
    //rtfSpaceBetween         :WriteLn('rtfSpaceBetween');
    //rtfInTable              :WriteLn('rtfInTable');
    //rtfKeep                 :WriteLn('rtfKeep');
    //rtfKeepNext             :WriteLn('rtfKeepNext');
    //rtfSideBySide           :WriteLn('rtfSideBySide');
    //rtfPBBefore             :WriteLn('rtfPBBefore');
    //rtfNoLineNum            :WriteLn('rtfNoLineNum');
    //rtfTabPos               :WriteLn('rtfTabPos');
    //rtfTabRight             :WriteLn('rtfTabRight');
    //rtfTabCenter            :WriteLn('rtfTabCenter');
    //rtfTabDecimal           :WriteLn('rtfTabDecimal');
    //rtfTabBar               :WriteLn('rtfTabBar');
    //rtfBorderTop            :WriteLn('rtfBorderTop');
    //rtfBorderBottom         :WriteLn('rtfBorderBottom');
    //rtfBorderLeft           :WriteLn('rtfBorderLeft');
    //rtfBorderRight          :WriteLn('rtfBorderRight');
    //rtfBorderBox            :WriteLn('rtfBorderBox');
    //rtfBorderBar            :WriteLn('rtfBorderBar');
    //rtfBorderBetween        :WriteLn('rtfBorderBetween');
    //rtfBorderSingle         :WriteLn('rtfBorderSingle');
    //rtfBorderThick          :WriteLn('rtfBorderThick');
    //rtfBorderShadow         :WriteLn('rtfBorderShadow');
    //rtfBorderDouble         :WriteLn('rtfBorderDouble');
    //rtfBorderDot            :WriteLn('rtfBorderDot');
    //rtfBorderHair           :WriteLn('rtfBorderHair');
    //rtfBorderSpace          :WriteLn('rtfBorderSpace');
    //rtfLeaderDot            :WriteLn('rtfLeaderDot');
    //rtfLeaderHyphen         :WriteLn('rtfLeaderHyphen');
    //rtfLeaderUnder          :WriteLn('rtfLeaderUnder');
    //rtfLeaderThick          :WriteLn('rtfLeaderThick');
  end;
  //WriteLn('');
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
  //WriteLn('--DoCharAttr--');
  case FRTFParser.rtfMinor of
    //rtfPlain                :WriteLn('rtfPlain');
    rtfBold:
    begin
      Styles(fsBold);
      //WriteLn('rtfBold');
    end;
    rtfItalic:
    begin
      //WriteLn('rtfItalic');
      Styles(fsItalic);
    end;
    rtfStrikeThru:
    begin
      Styles(fsStrikeOut);
      //WriteLn('rtfStrikeThru');
    end;
    //rtfOutline              :WriteLn('rtfOutline');
    //rtfShadow               :WriteLn('rtfShadow');
    //rtfSmallCaps            :WriteLn('rtfSmallCaps');
    //rtfAllCaps              :WriteLn('rtfAllCaps');
    //rtfInvisible            :WriteLn('rtfInvisible');
    rtfFontNum:
    begin
      f := FRTFParser.Fonts[FRTFParser.rtfParam];
      if (f = nil) then
        FFontParams.Name := 'Sans'
      else
        FFontParams.Name := f^.rtfFName;
      //WriteLn('rtfFontNum');
    end;
    rtfFontSize:
    begin
      FFontParams.Size := FRTFParser.rtfParam div 2;
      //WriteLn('rtfFontSize');
    end;
    //rtfExpand               :WriteLn('rtfExpand');
    rtfUnderline:
    begin
      Styles(fsUnderline);
      //WriteLn('rtfUnderline');
    end;
    //rtfWUnderline           :WriteLn('rtfWUnderline');
    //rtfDUnderline           :WriteLn('rtfDUnderline');
    //rtfDbUnderline          :WriteLn('rtfDbUnderline');
    rtfNoUnderline:
    begin
      Styles(fsUnderline);
      //WriteLn('rtfNoUnderline');
    end;
    //rtfSuperScript          :WriteLn('rtfSuperScript');
    //rtfSubScript            :WriteLn('rtfSubScript');
    //rtfRevised              :WriteLn('rtfRevised');
    rtfForeColor:
    begin
      C := FRTFParser.Colors[FRTFParser.rtfParam];
      if (C = nil) or (FRTFParser.rtfParam = 0) then
        FFontParams.Color := clWindowText
      else
        FFontParams.Color :=
          RGBToColor(C^.rtfCRed, C^.rtfCGreen, C^.rtfCBlue);
      //WriteLn('rtfForeColor')
    end;
    //rtfBackColor            :WriteLn('rtfBackColor');
    //rtfGray                 :WriteLn('rtfGray');
  end;
  //WriteLn('');
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
  //  WriteLn('------------DoBeginPict');
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
  //  WriteLn('------------DoEndPict');
  FIsPict := False;
  Picture := TPicture.Create;

  if (RTFPict.WG = 0) and (RTFPict.HG = 0) or (RTFPict.WG = RTFPict.W) and
    (RTFPict.HG = RTFPict.H) then
    R := RTFToBMP(RTFPict.HEX, RTFPict.PictType, Picture)
  else
    R := RTFToBMP(RTFPict.HEX, RTFPict.PictType, Picture, RTFPict.WG, RTFPict.HG);

  if R then
  begin
    //WriteLn('Pos:' + IntToStr(UTF8Length(TCustomlzRichEdit(FlzRichEdit).Text)));
    TCustomlzRichEdit(FlzRichEdit).InsertImage(
      UTF8Length(TCustomlzRichEdit(FlzRichEdit).Text), Picture);
    //--
    L := UTF8Length(TCustomlzRichEdit(FlzRichEdit).Text);
    if (FLeftIndent > 0) then
      TCustomlzRichEdit(FlzRichEdit).SetStartIndent(L - 1, 1, FLeftIndent div 568);
    if (FRightIndent > 0) then
      TCustomlzRichEdit(FlzRichEdit).SetRightIndent(L - 1, 1, FRightIndent div 568);
    TCustomlzRichEdit(FlzRichEdit).SetAlignment(L - 1, 1, FAlign);
    TCustomlzRichEdit(FlzRichEdit).SetTextAttributes(L - 1, 1, FFontParams);
  end;

  Picture.Free;

end;

procedure TRTFRead.LoadFromStream(Stream: TStream);
begin
  if TCustomlzRichEdit(FlzRichEdit).PlainText then
  begin
    TCustomlzRichEdit(FlzRichEdit).LoadFromStream(Stream);
    Exit;
  end;
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
end;

constructor TRTFRead.Create(ilzRichEdit: TWinControl);
begin
  inherited Create;
  FlzRichEdit := ilzRichEdit;
  FIsPict := False;
end;

destructor TRTFRead.Destroy;
begin
  inherited Destroy;
end;

end.

