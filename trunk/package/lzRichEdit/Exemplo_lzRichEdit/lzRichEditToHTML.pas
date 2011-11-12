unit lzRichEditToHTML;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,lzRichEdit, Graphics, lzRichEditTypes, LCLType, LCLProc, Controls, RTFTool;

procedure RichEditToHTML(ARichEdit: TlzRichEdit; var AHTMLStrings: String);

implementation

procedure RichEditToHTML(ARichEdit: TlzRichEdit; var AHTMLStrings: String);
var
  HTMLStrings:TStringList;
  Text:String;
  HTMLPar:String;
  I:Integer;
  LengthText: Integer;
  Align: TRichEdit_Align;
  NChar: TUTF8Char;
  FontParams: TlzFontParams;
  Font:Boolean;
  Bold:Boolean=False;
  Italic:Boolean=False;
  Underline:Boolean=False;

function RtfFontSizeToHtmlFontSize(FontSize: Integer): Integer;
  begin
    case FontSize of
      0 .. 6 : Result := 0;
      7 .. 8 : Result := 1;
      9 ..10 : Result := 2;
      11..12 : Result := 3;
      13..14 : Result := 4;
      15..18 : Result := 5;
      19..24 : Result := 6;
    else
      Result := 7;
    end;
  end;

function TColorToWebColor(const AColor: TColor): string;
var
  LHexColor: string;
begin
  LHexColor := IntToHex(ColorToRGB(AColor), 6);
  Result := '#' + Copy(LHexColor, 5, 2) + Copy(LHexColor, 3, 2) + Copy(LHexColor, 1, 2);
end;


procedure InitParagrafo;
const AAlign:array [TRichEdit_Align] of String = ('<P ALIGN=LEFT>', '<P ALIGN=RIGHT>', '<P ALIGN=CENTER>', '<P ALIGN=JUSTIFY>');
begin
  Align:= taLeft;
  ARichEdit.GetAlignment(I, Align);
  HTMLPar:= AAlign[Align];
  if ARichEdit.GetNumbering(I) then HTMLPar:= HTMLPar + '<UL Type=disc compact><LI>';
end;

procedure FimParagrafo;
begin
  if ARichEdit.GetNumbering(I -1) then HTMLPar:= HTMLPar + '</LI></UL>';

  if Underline then
   begin
     Underline:= False;
     HTMLPar:= HTMLPar + '</U>'
   end;

  if Italic then
   begin
     Italic:= False;
     HTMLPar:= HTMLPar + '</I>'
   end;

  if Bold then
   begin
     Bold:= False;
     HTMLPar:= HTMLPar + '</B>'
   end;

  if Font then
  begin
    Font:= False;
    FontParams:= DefFontParams;
    HTMLPar:= HTMLPar + '</FONT>';
  end;

 HTMLPar:= HTMLPar + '</P>';
end;

procedure FontChar;
var
  AFontParams: TlzFontParams;
begin
  AFontParams:= DefFontParams;
  ARichEdit.GetTextAttributes(I -1, AFontParams);
  if (AFontParams.Name <> FontParams.Name) or
     (AFontParams.Size <> FontParams.Size) or
     (AFontParams.Color <> FontParams.Color) then
    begin
      if Font then HTMLPar:= HTMLPar + '</FONT>';

      HTMLPar:= HTMLPar + '<FONT face="' + AFontParams.Name + '" ' +
      'color="' + TColorToWebColor(AFontParams.Color) + '"' +
      'size=' + IntToStr(RtfFontSizeToHtmlFontSize(AFontParams.Size)) + '>';
      //--
      Font:= True;
      //--
      FontParams.Name:= AFontParams.Name;
      FontParams.Size:= AFontParams.Size;
      FontParams.Color:=AFontParams.Color;
      //--
    end;

  if (fsBold in AFontParams.Style) and not(Bold) then
    begin
      HTMLPar:= HTMLPar + '<B>';
      Bold:= True;
    end
  else if not(fsBold in AFontParams.Style) and (Bold) then
    begin
      HTMLPar:= HTMLPar + '</B>';
      Bold:= False;
    end;

  if (fsItalic in AFontParams.Style) and not(Italic) then
    begin
      HTMLPar:= HTMLPar + '<I>';
      Italic:= True;
    end
  else if not(fsItalic in AFontParams.Style) and (Italic) then
    begin
      HTMLPar:= HTMLPar + '</I>';
      Italic:= False;
    end;

  if (fsUnderline in AFontParams.Style) and not(Underline) then
    begin
      HTMLPar:= HTMLPar + '<U>';
      Underline:= True;
    end
  else if not(fsUnderline in AFontParams.Style) and (Underline) then
    begin
      HTMLPar:= HTMLPar + '</U>';
      Underline:= False;
    end;

  FontParams.Style:=AFontParams.Style;
end;

begin
  HTMLStrings:= TStringList.Create;
  Text:= ARichEdit.Text;
  HTMLPar:= '';
  LengthText:= UTF8Length(Text);
  NChar:= ARichEdit.NumberingParams.NChar;
  FontParams:= DeflzFontParams;
  Font:= False;

  HTMLStrings.Add('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">');
  HTMLStrings.Add('<HTML><HEAD><META http-equiv=Content-Type content="text/html; charset=utf-8"></HEAD><BODY>');


  for I:= 1 to LengthText -1 do
  begin
    ARichEdit.SelStart:= I;
    ARichEdit.SelLength:= 1;

    if (I=1) then InitParagrafo;
    if (UTF8Copy(Text, I, 1) = #10) then
      begin
        FimParagrafo;
        HTMLStrings.Add(HTMLPar);
        if ((I + 1) < LengthText) then InitParagrafo;
       end;
    if (UTF8Copy(Text, I, 1) <> #10) and (UTF8Copy(Text, I, 1) <> NChar) then
      begin
        FontChar;
        HTMLPar := HTMLPar + UTF8Copy(Text, I, 1);
      end;
  end;
  HTMLStrings.Add('</BODY></HTML>');
  AHTMLStrings:= HTMLStrings.Text;
end;

end.

