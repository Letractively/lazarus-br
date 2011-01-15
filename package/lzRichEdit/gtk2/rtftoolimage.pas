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
unit RTFToolImage;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, LCLProc;

function PNGToRTF(PNG: TPortableNetworkGraphic): string;
function BMPToRtf(BMP: TBitmap): string;
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

function BMPToRtf(BMP: TBitmap): string;
var
  NBitmap: TBitmap;
  MemoryStream: TMemoryStream;
  I, Len: integer;
  Buf: byte = $0;
  W, H: integer;
  CK: string;
begin
  NBitmap := TBitmap.Create;
  //--
  if ((BMP.Height * BMP.Width) >= 1) and ((BMP.Height * BMP.Width) <= 32) then
  begin
    W := 16;
    H := 16;
    CK := '40030000';
  end
  else if ((BMP.Height * BMP.Width) >= 33) and ((BMP.Height * BMP.Width) <= 64) then
  begin
    W := 32;
    H := 32;
    CK := '400c0000';
  end
  else if ((BMP.Height * BMP.Width) >= 65) and ((BMP.Height * BMP.Width) <= 4096) then
  begin
    W := 64;
    H := 64;
    CK := '40300000';
  end
  else if ((BMP.Height * BMP.Width) >= 4097) and ((BMP.Height * BMP.Width) <= 16384) then
  begin
    W := 128;
    H := 128;
    CK := '40c00000';
  end
  else if ((BMP.Height * BMP.Width) >= 16385) and ((BMP.Height * BMP.Width) <= 65536) then
  begin
    W := 256;
    H := 256;
    CK := '40000300';
  end
  else if ((BMP.Height * BMP.Width) >= 65537) and ((BMP.Height * BMP.Width) <= 262144) then
  begin
    W := 512;
    H := 512;
    CK := '40000c00';
  end
  else if ((BMP.Height * BMP.Width) > 262144) then
  begin
    W := 1024;
    H := 1024;
    CK := '40003000';
  end;
  //--
  NBitmap.Height := H;
  NBitmap.Width := W;
  NBitmap.Canvas.CopyRect(Rect(0, 0, H, W), BMP.Canvas,
    Rect(0, 0, BMP.Width, BMP.Height));

  Result := '{\object\objemb{\*\objclass Paint.Picture}\objw' +
    IntToStr(BMP.Width * 15) + '\objh' + IntToStr(BMP.Height * 15) +
    '{\*\objdata' + UnicodeToUTF8($A) + '01050000' + UnicodeToUTF8($A) +
    '02000000' + UnicodeToUTF8($A) + '07000000' +
    UnicodeToUTF8($A) + '50427275736800' + UnicodeToUTF8($A) +
    '00000000' + UnicodeToUTF8($A) + '00000000' +
    UnicodeToUTF8($A) + CK + UnicodeToUTF8($A);
  //--
  MemoryStream := TMemoryStream.Create;
  NBitmap.SaveToStream(MemoryStream);
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
  NBitmap.Free;
  MemoryStream.Free;
  Result := Result +
    '000000000000000000000000000000000000000000000000000000000000000000000000' +
    UnicodeToUTF8($A) +
    '000000000000000000000000000000000000000000000000000000000000000000000000' +
    UnicodeToUTF8($A) + '01050000' + UnicodeToUTF8($A) +
    '00000000' + UnicodeToUTF8($A) + '}}';
end;

function RTFToBMP(const S: string; DataType: integer; var Picture: TPicture;
  Width: integer = 0; Height: integer = 0): boolean;
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

end.

