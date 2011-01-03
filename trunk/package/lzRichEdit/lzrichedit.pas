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

unit lzRichEdit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, StdCtrls, Controls, Graphics, WSlzRichEdit, lzRichEditTypes;

type TlzFontParams = TFontParams;

const
  DeflzFontParams: TlzFontParams = (
    Name: 'Sans';
    Size: 10;
    Color: clWindowText;
    Style: []; );


type TlzRichEdit_Align = TRichEdit_Align;

type

{ TCustomlzRichEdit }

TCustomlzRichEdit = class(TCustomMemo)
private
  FOle:Pointer;
protected
  FPlainText:Boolean;
  FActiveRichOle:Boolean;
protected
  class procedure WSRegisterClass; override;
  function RealGetText:TCaption; override;
  procedure RealSetText(const Value: TCaption); override;
private
  Procedure SetActiveRichOle(I:Boolean);
public
  NumberingParams: TNumberingParams;
public
  property PlainText:Boolean read FPlainText write FPlainText default False;
  property RichOle:Pointer read FOle write FOle default nil;
  property ActiveRichOle: Boolean read FActiveRichOle write SetActiveRichOle default False;
public
  procedure SetSelection(StartPos, EndPos: Integer; ScrollCaret: Boolean);
  procedure SetTextAttributes(iSelStart, iSelLength: Integer; const TextParams: TlzFontParams); virtual;
  procedure SetTextAttributes(iSelStart, iSelLength: Integer; const iFont: TFont); virtual;
  procedure GetTextAttributes(Position: Integer; var Params: TlzFontParams); virtual;
  procedure SetAlignment(iSelStart, iSelLength: Integer; iAlignment:TlzRichEdit_Align);
  procedure GetAlignment(Position: Integer; var iAlignment:TlzRichEdit_Align);
  procedure SetNumbering(N:Boolean);
  function GetNumbering:Boolean;
  procedure SetOffSetIndent(iSelStart, iSelLength: Integer; I:Integer);
  function GetOffSetIndent:Integer;
  procedure SetRightIndent(iSelStart, iSelLength: Integer; I:Integer);
  procedure GetRightIndent (Position: Integer; var I:Integer);
  procedure SetStartIndent(iSelStart, iSelLength: Integer; I:Integer);
  procedure GetStartIndent(Position: Integer; var I:Integer);
  procedure InsertImage(Position: Integer; Image: TPicture);
  function GetImage(Position: Integer; var Image: TPicture):Boolean;
  procedure SaveToStream(Stream: TStream);
  procedure LoadFromStream(Stream: TStream);
  destructor Destroy; override;
end;


  TlzRichEdit = class(TCustomlzRichEdit)
  published
    property Align;
    property Alignment;
    property Anchors;
    property ActiveRichOle;
    property BidiMode;
    property BorderSpacing;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property Lines;
    property MaxLength;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditingDone;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDrag;
    property OnUTF8KeyPress;
    property ParentBidiMode;
    property ParentColor;
    property ParentFont;
    property PopupMenu;
    property ParentShowHint;
    property ReadOnly;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property WantReturns;
    property WantTabs;
    property WordWrap;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Common Controls', [TlzRichEdit]);
end;


{$I lzrichedit.inc}

initialization
{$I lzrichedit.lrs}
end.
