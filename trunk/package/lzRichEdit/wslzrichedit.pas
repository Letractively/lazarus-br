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

unit WSlzRichEdit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, WSStdCtrls, lzRichEditTypes, Graphics;

type

{ TWSCustomlzRichEdit }

TWSCustomlzRichEdit = class(TWSCustomMemo)
  class procedure SaveToStream (const AWinControl: TWinControl; var Stream: TStream); virtual;
  class procedure LoadFromStream (const AWinControl: TWinControl; const Stream: TStream); virtual;
  class procedure LoadFromStreamInSelStart(const AWinControl: TWinControl;
    const Stream: TStream); virtual;
  class procedure CloseObjects(const AWinControl: TWinControl); virtual;
  class procedure SetSelection(const AWinControl: TWinControl; StartPos, EndPos: Integer; ScrollCaret: Boolean); virtual;
  class procedure SetTextAttributes(const AWinControl: TWinControl; iSelStart, iSelLength: Integer; const TextParams: TFontParams); virtual;
  class procedure GetTextAttributes(const AWinControl: TWinControl; Position: Integer; var TextParams: TFontParams); virtual;
  class procedure ActiveRichOle(const AWinControl: TWinControl); virtual;
  class procedure DestroyRichOle(const AWinControl: TWinControl); virtual;
  class procedure GetAlignment(const AWinControl: TWinControl; Position: Integer; var Alignment:TRichEdit_Align); virtual;
  class procedure SetAlignment(const AWinControl: TWinControl; iSelStart, iSelLength: Integer; Alignment:TRichEdit_Align); virtual;
  class procedure SetNumbering(const AWinControl: TWinControl; N:Boolean); virtual;
  class procedure GetNumbering(const AWinControl: TWinControl; var N:Boolean); virtual;
  class procedure SetOffSetIndent(const AWinControl: TWinControl; I:Integer); virtual;
  class procedure GetOffSetIndent(const AWinControl: TWinControl; var I:Integer); virtual;
  class procedure SetRightIndent(const AWinControl: TWinControl; iSelStart, iSelLength: Integer; I:Integer); virtual;
  class procedure GetRightIndent(const AWinControl: TWinControl; Position: Integer; var I:Integer); virtual;
  class procedure SetStartIndent(const AWinControl: TWinControl; iSelStart, iSelLength: Integer; I:Integer); virtual;
  class procedure GetStartIndent(const AWinControl: TWinControl; Position: Integer; var I:Integer); virtual;
  class procedure InsertImage(const AWinControl: TWinControl; Position: Integer; Image: TPicture); virtual;
  class function GetImage(const AWinControl: TWinControl; Position: Integer; var Image: TPicture):Boolean; virtual;
  class function GetRealTextBuf(const AWinControl: TWinControl):String; virtual;

end;
TWSCustomlzRichEditClass = class of TWSCustomlzRichEdit;

function WSRegisterCustomlzRichEdit: Boolean; external name 'WSRegisterCustomlzRichEdit';


implementation

{ TWSCustomlzRichEdit }

class procedure TWSCustomlzRichEdit.SaveToStream(
  const AWinControl: TWinControl; var Stream: TStream);
begin

end;

class procedure TWSCustomlzRichEdit.LoadFromStream(
  const AWinControl: TWinControl; const Stream: TStream);
begin

end;

class procedure TWSCustomlzRichEdit.LoadFromStreamInSelStart(
  const AWinControl: TWinControl; const Stream: TStream);
begin

end;

class procedure TWSCustomlzRichEdit.CloseObjects(const AWinControl: TWinControl
  );
begin

end;

class procedure TWSCustomlzRichEdit.SetSelection(const AWinControl: TWinControl; StartPos, EndPos: Integer;
  ScrollCaret: Boolean);
begin

end;

class procedure TWSCustomlzRichEdit.SetTextAttributes(const AWinControl: TWinControl; iSelStart,
  iSelLength: Integer; const TextParams: TFontParams);
begin

end;

class procedure TWSCustomlzRichEdit.GetTextAttributes(
  const AWinControl: TWinControl; Position: Integer; var TextParams: TFontParams);
begin

end;

class procedure TWSCustomlzRichEdit.ActiveRichOle(const AWinControl: TWinControl
  );
begin

end;

class procedure TWSCustomlzRichEdit.DestroyRichOle(
  const AWinControl: TWinControl);
begin

end;

class procedure TWSCustomlzRichEdit.GetAlignment(
  const AWinControl: TWinControl; Position: Integer; var Alignment: TRichEdit_Align);
begin

end;

class procedure TWSCustomlzRichEdit.SetAlignment(
  const AWinControl: TWinControl; iSelStart, iSelLength: Integer; Alignment: TRichEdit_Align);
begin

end;

class procedure TWSCustomlzRichEdit.SetNumbering(
  const AWinControl: TWinControl; N: Boolean);
begin

end;

class procedure TWSCustomlzRichEdit.GetNumbering(
  const AWinControl: TWinControl; var N: Boolean);
begin

end;

class procedure TWSCustomlzRichEdit.SetOffSetIndent(
  const AWinControl: TWinControl; I: Integer);
begin

end;

class procedure TWSCustomlzRichEdit.GetOffSetIndent(
  const AWinControl: TWinControl; var I: Integer);
begin

end;

class procedure TWSCustomlzRichEdit.SetRightIndent(
  const AWinControl: TWinControl; iSelStart, iSelLength: Integer; I: Integer);
begin

end;

class procedure TWSCustomlzRichEdit.GetRightIndent(
  const AWinControl: TWinControl; Position: Integer; var I: Integer);
begin

end;

class procedure TWSCustomlzRichEdit.SetStartIndent(
  const AWinControl: TWinControl; iSelStart, iSelLength: Integer; I: Integer);
begin

end;

class procedure TWSCustomlzRichEdit.GetStartIndent(
  const AWinControl: TWinControl; Position: Integer; var I: Integer);
begin

end;

class procedure TWSCustomlzRichEdit.InsertImage(const AWinControl: TWinControl;
  Position: Integer; Image: TPicture);
begin

end;

class function TWSCustomlzRichEdit.GetImage(const AWinControl: TWinControl;
  Position: Integer; var Image: TPicture): Boolean;
begin

end;

class function TWSCustomlzRichEdit.GetRealTextBuf(const AWinControl: TWinControl
  ): String;
begin

end;

end.
