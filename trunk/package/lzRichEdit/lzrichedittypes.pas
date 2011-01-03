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

unit lzRichEditTypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, LCLType;

type
  TFontParams=Record
    Name    : TFontName;
    Size    : Integer;
    Color   : TColor;
    Style   : TFontStyles;
  end;

type
  TNumberingParams=Record
    NChar: TUTF8Char;
    FontParams: TFontParams;
  end;

const
  DefFontParams: TFontParams = (
    Name: 'Sans';
    Size: 10;
    Color: clWindowText;
    Style: []; );

type TRichEdit_Align = (alLeft, alRight, alCenter, alJustify);

procedure TFontToTFontParams(const Font:TFont; var rFontParams);
implementation

procedure TFontToTFontParams(const Font: TFont; var rFontParams);
var
  FontParams: TFontParams;
begin
  FontParams.Name:= Font.Name;
  FontParams.Size:= Font.Size;
  FontParams.Color:= Font.Color;
  FontParams.Style:= Font.Style;
  //-
  TFontParams(rFontParams):= FontParams;
end;

end.
