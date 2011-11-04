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
  Classes, SysUtils, LResources, StdCtrls, Controls, Graphics,
  WSlzRichEdit, lzRichEditTypes, LCLType, Dialogs, LCLProc;

type
  TlzFontParams = TFontParams;

const
  DeflzFontParams: TlzFontParams = (
    Name: 'Sans';
    Size: 10;
    Color: clWindowText;
    Style: []; );


type
  TlzRichEdit_Align = TRichEdit_Align;
  TNumberingStyle = (nsNone, nsBullet);
type
  TCustomlzRichEdit = class;

  { TTextAttributes }

  TTextAttributes = class(TPersistent)
   private
     FlzRichEdit: TCustomlzRichEdit;
     FFontParams: TlzFontParams;
   private
     procedure GetAttributes(var Format: TlzFontParams);
     function GetColor: TColor;
     procedure SetColor(Value: TColor);
     function GetName: TFontName;
     procedure SetName(Value: TFontName);
     function GetSize: Integer;
     procedure SetSize(Value: Integer);
     function GetStyle: TFontStyles;
     procedure SetStyle(Value: TFontStyles);
   public
     constructor Create(AOwner: TCustomlzRichEdit);
     procedure Assign(Source: TPersistent); override;
     property Color: TColor read GetColor write SetColor;
     property Name: TFontName read GetName write SetName;
     property Size: Integer read GetSize write SetSize;
     property Style: TFontStyles read GetStyle write SetStyle;
   end;


  { TParaAttributes }
TParaAttributes = class(TPersistent)
private
   FlzRichEdit: TCustomlzRichEdit;
private
    function GetAlignment: TlzRichEdit_Align;
    procedure SetAlignment(Value: TlzRichEdit_Align);
    function GetFirstIndent: LongInt;
    procedure SetFirstIndent(Value:LongInt);
    function GetLeftIndent:LongInt;
    procedure SetLeftIndent(Value:LongInt);
    function GetNumbering: TNumberingStyle;
    procedure SetNumbering(Value: TNumberingStyle);
    function GetRightIndent: LongInt;
    procedure SetRightIndent(Value:LongInt);
  public
    constructor Create(AOwner: TCustomlzRichEdit);
    procedure Assign(Source: TPersistent); override;
    property Alignment: TlzRichEdit_Align read GetAlignment write SetAlignment;
    property FirstIndent: LongInt read GetFirstIndent write SetFirstIndent;
    property LeftIndent: LongInt read GetLeftIndent write SetLeftIndent;
    property Numbering: TNumberingStyle read GetNumbering write SetNumbering;
    property RightIndent: Longint read GetRightIndent write SetRightIndent;
  end;

  { TCustomlzRichEdit }

  TCustomlzRichEdit = class(TCustomMemo)
  private
    FOle: Pointer;
  protected
    FPlainText: boolean;
    FActiveRichOle: boolean;
    FParagraph: TParaAttributes;
    FSelAttributes: TTextAttributes;
  protected
    class procedure WSRegisterClass; override;
  private
    procedure SetActiveRichOle(I: boolean);
  public
    NumberingParams: TNumberingParams;
  public
    property PlainText: boolean read FPlainText write FPlainText default False;
    property RichOle: Pointer read FOle write FOle default nil;
    property ActiveRichOle: boolean read FActiveRichOle write SetActiveRichOle default False;
    //--
    property SelAttributes: TTextAttributes read FSelAttributes;
    property Paragraph: TParaAttributes read FParagraph;
    //--
  public

    function GetPosStartCharLine:integer;
    function GetPosCharEndLine:integer;

    procedure SetSelection(StartPos, EndPos: integer; ScrollCaret: boolean);
    procedure SetTextAttributes(iSelStart, iSelLength: integer;
      const TextParams: TlzFontParams); virtual;

    procedure SetTextAttributes(iSelStart, iSelLength: integer;
      const iFont: TFont); virtual;
    procedure GetTextAttributes(Position: integer; var Params: TlzFontParams); virtual;

    procedure SetAlignment(iSelStart, iSelLength: integer; iAlignment: TlzRichEdit_Align);
    procedure GetAlignment(Position: integer; var iAlignment: TlzRichEdit_Align);
    procedure SetNumbering(N: boolean);
    function GetNumbering: boolean;
    function GetNumbering(Position: integer): boolean;
    procedure SetOffSetIndent(iSelStart, iSelLength: integer; I: integer);
    function GetOffSetIndent: integer;
    procedure SetIndent(iSelStart, iSelLength: integer; I: integer);
    procedure GetIndent(Position: integer; var I: integer);
    procedure SetRightMargin(iSelStart, iSelLength: integer; I: integer);
    procedure GetRightMargin(Position: integer; var I: integer);
    procedure SetLeftMargin(iSelStart, iSelLength: integer; I: integer);
    procedure GetLeftMargin(Position: integer; var I: integer);

    procedure SetFontColor(iSelStart, iSelLength: integer; iColor: TColor);
    procedure SetFontName(iSelStart, iSelLength: integer; iFontName: TFontName);
    procedure SetFontSize(iSelStart, iSelLength: integer; iSize: Integer);
    procedure SetFontStyle(iSelStart, iSelLength: integer; Style: TFontStyles);

    procedure InsertImage(Position: integer; Image: TPicture);
    function GetImage(Position: integer; var Image: TPicture): boolean;
    function GetRealTextBuf:String;
    procedure InsertPosLastChar(const UTF8Char: TUTF8Char);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    constructor Create(AOwner: TComponent); override;
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
{$I lzrichattribs.inc}
initialization
{$I lzrichedit.lrs}
end.

