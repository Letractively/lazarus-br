{FMemo
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

{**Only for GTK**}
unit FMemo_Type;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics{$IFDEF LINUX}, pango, gtk2{$ENDIF};

{$IFDEF LINUX}
type
  TFontUnderline=(fuNone             = PANGO_UNDERLINE_NONE,
                  fuSingle           = PANGO_UNDERLINE_SINGLE,
                  fuDouble           = PANGO_UNDERLINE_DOUBLE,
                  fuLow              = PANGO_UNDERLINE_LOW,
                  fuError            = 4);

type
  TFontWeight=(fwUltralight          = PANGO_WEIGHT_ULTRALIGHT,
               fwLight               = PANGO_WEIGHT_LIGHT,
               fwNormal              = PANGO_WEIGHT_NORMAL,
               fwBold                = PANGO_WEIGHT_BOLD,
               fwUtrabold            = PANGO_WEIGHT_ULTRABOLD,
               fwHeavy               = PANGO_WEIGHT_HEAVY);

type
  TFontJustify=(fjLeft               = GTK_JUSTIFY_LEFT,
                fjRight              = GTK_JUSTIFY_RIGHT,
                fjCenter             = GTK_JUSTIFY_CENTER,
                fjFill               = GTK_JUSTIFY_FILL);

type
  TFontPStyle=( fpNormal             = PANGO_STYLE_NORMAL,
                fpOblique            = PANGO_STYLE_OBLIQUE,
                fpItalic             = PANGO_STYLE_ITALIC);
//--
type TUnderline = TFontUnderline;
type TWeight    = TFontWeight;
type TJustify   = TFontJustify;
type TPStyle    = TFontPStyle;
//--
type
    TFontDesctype=Record
    Name     : String[250];
    Size     : Integer;
    FontColor: TColor;
    BackColor: TColor;
    Strikethrough: Boolean;
    Underline: TUnderline;
    Weight   : TWeight;
    Justify  : TJustify;
    Style    : TPStyle;
    end;

type TFontDesc=TFontDesctype;
//--
{$ENDIF}
implementation

end.

