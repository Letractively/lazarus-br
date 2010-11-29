(*
  Base64Picture unit
  Copyright (C) 2010-2012 Silvio Clecio.

  http://silvioprog.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit Base64Picture;

{$mode objfpc}{$H+}

interface

uses
  LSUtils, Classes, Graphics;

procedure Base64ToPicture(const ABase64Str: string; APicture: TPicture);
function PictureToBase64(const APicture: TPicture): string;
function GetFileExtFromPicture(const APicture: TPicture): ShortString;

implementation

procedure Base64ToPicture(const ABase64Str: string; APicture: TPicture);
var
  VMemoryStream: TMemoryStream;
begin
  VMemoryStream := TMemoryStream.Create;
  try
    LSBase64StrToStream(ABase64Str, TStream(VMemoryStream));
    APicture.LoadFromStream(VMemoryStream);
  finally
    VMemoryStream.Free;
  end;
end;

function PictureToBase64(const APicture: TPicture): string;
var
  VMemoryStream: TMemoryStream;
begin
  VMemoryStream := TMemoryStream.Create;
  try
    APicture.SaveToStream(VMemoryStream);
    Result := LSStreamToBase64Str(TStream(VMemoryStream));
  finally
    VMemoryStream.Free;
  end;
end;

function GetFileExtFromPicture(const APicture: TPicture): ShortString;
var
  I: Integer;
begin
  Result := APicture.Graphic.GetFileExtensions;
  I := Pos(';', Result);
  if I > 0 then
    Delete(Result, I, MaxInt);
end;

end.

