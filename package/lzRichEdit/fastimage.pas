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
unit FastImage;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, GraphType, IntfGraphics,
  Dialogs, LCLType;


type
  TFastPixel = record
    R, G, B, A:Byte;
  end;

type

{ TFastImage }

TFastImage = class(TObject)
  protected
    FRawImage:TRawImage;
  protected
    function GetWidth:Cardinal;
    function GetHeight:Cardinal;
    procedure SetColor(AX,AY:Cardinal; const AColor: TFastPixel);
    function GetColor(AX, AY: Cardinal): TFastPixel;
  public
    procedure SetSize(AWidth, AHeight:Cardinal);
    procedure SaveToFile(AFileName:String);
    procedure FastImageToPicture(P:TPicture);
  public
    property Width:Cardinal read GetWidth;
    property Height:Cardinal read GetHeight;
    property Color[AX,AY:Cardinal]:TFastPixel read GetColor write SetColor;
  public
    constructor Create;
    destructor Destroy; override;
  end;

function RGBAToFastPixel(R, G, B, A:Byte): TFastPixel;

implementation

function RGBAToFastPixel(R, G, B, A: Byte): TFastPixel;
begin
  Result.R:= R;
  Result.G:= G;
  Result.B:= B;
  Result.A:= A;
end;

{ TFastImage }

function TFastImage.GetWidth: Cardinal;
begin
  Result:= FRawImage.Description.Width;
end;

function TFastImage.GetHeight: Cardinal;
begin
  Result:= FRawImage.Description.Height;
end;

procedure TFastImage.SetColor(AX, AY: Cardinal; const AColor: TFastPixel);
var
  P:Cardinal;
  //TRawImagePosition
begin
  if (AX > Width) or
     (AY > Height) then
  Exit;
  {
  0000|0000|0000|
  0000|0000|0000|
  0000|0000|0000|
  0000|0000|0000|
  ***************
  Width = 3
  Height = 4
  ***************
  X = 3 ►
  Y = 3 ▼
  ***************
  (((Y-1) * W) + (X-1)) * 4
  (((3-1) * 3) + (3-1)) * 4
  ((  2   * 3) +   2  ) * 4
  (       6    +    2 ) * 4
               8        * 4
                        32 Byte
  }
  P:= (((AY -1) * Width) + (AX -1)) * 4;

  PByteArray(FRawImage.Data)^[P + 0]:= AColor.B; //B
  PByteArray(FRawImage.Data)^[P + 1]:= AColor.G; //G
  PByteArray(FRawImage.Data)^[P + 2]:= AColor.R; //R
  PByteArray(FRawImage.Data)^[P + 3]:= AColor.A; //A
  //--
end;

function TFastImage.GetColor(AX, AY: Cardinal): TFastPixel;
var
  P:Cardinal;
  //TRawImagePosition
begin
  if (AX > Width) or
     (AY > Height) then
  Exit;
  {
  0000|0000|0000|
  0000|0000|0000|
  0000|0000|0000|
  0000|0000|0000|
  ***************
  Width = 3
  Height = 4
  ***************
  X = 3 ►
  Y = 3 ▼
  ***************
  (((Y-1) * W) + (X-1)) * 4
  (((3-1) * 3) + (3-1)) * 4
  ((  2   * 3) +   2  ) * 4
  (       6    +    2 ) * 4
               8        * 4
                        32 Byte
  }
  P:= (((AY -1) * Width) + (AX -1)) * 4;

  Result.B:= PByteArray(FRawImage.Data)^[P + 0]; //B
  Result.G:= PByteArray(FRawImage.Data)^[P + 1]; //G
  Result.R:= PByteArray(FRawImage.Data)^[P + 2]; //R
  Result.A:= PByteArray(FRawImage.Data)^[P + 3]; //A
  //--
end;

procedure TFastImage.SetSize(AWidth, AHeight: Cardinal);
begin
  if (Width = AWidth) and (Height = AHeight) or
   (AWidth <= 0) or (AHeight <= 0) then
    Exit;

  FRawImage.Description.Width:= AWidth;
  FRawImage.Description.Height:= AHeight;
  FRawImage.Description.Init_BPP32_B8G8R8A8_BIO_TTB(AWidth, AHeight);
  FRawImage.CreateData(True);
end;

procedure TFastImage.SaveToFile(AFileName: String);
var
  //AImage: TLazIntfImage;
  A:TPicture;
  //tarinfimage : TLazIntfImage;
  //hdl,mask:HBitmap;
begin
  if (Width <= 0) or (Height <= 0) then Exit;

  A:= TPicture.Create;
  A.Bitmap.LoadFromRawImage(FRawImage, False);
  A.SaveToFile(AFileName);
  A.Free;
end;

procedure TFastImage.FastImageToPicture(P:TPicture);
begin
  P.Bitmap.LoadFromRawImage(FRawImage, False);
end;

constructor TFastImage.Create;
begin
  FRawImage.Init;
  //--
  FRawImage.Description.Init_BPP32_B8G8R8A8_BIO_TTB(0,0);
  //--
  FRawImage.CreateData(True);
  //--
end;

destructor TFastImage.Destroy;
begin
  FRawImage.FreeData;
  inherited Destroy;
end;

end.

