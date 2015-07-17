{
lzRichEdit

Copyright (C) 2010 Elson Junio elsonjunio@yahoo.com.br
                   Additions by Antônio Galvão

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

unit RichBox;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, StdCtrls, Graphics, LCLType, LCLProc,
  Printers;

type

TNumberingStyle = (nsNone, nsBullets);

TRichEditAlignment = (traLeft, traRight, traCenter, traJustify);

TMargins = TRect;

TSearchType = (stWholeWord, stMatchCase);
TSearchTypes = set of TSearchType;

TCaretCoordinates = record
  Column,
  Line :integer;
end;

TZoomFactor = 1..64;

TZoomPair = record
  Numerator,
  Denominator :TZoomFactor;
end;

TCustomRichBox = class;

{ TTextAttributes }

TTextAttributes = class(TPersistent)
 private
   FRichBox: TCustomRichBox;
 private
   function GetColor: TColor;
   procedure SetColor(Value: TColor);
   function GetBackColor :TColor;
   procedure SetBackColor(Value: TColor);
   function GetName: TFontName;
   procedure SetName(Value: TFontName);
   function GetSize: Integer;
   procedure SetSize(Value: Integer);
   function GetStyle: TFontStyles;
   procedure SetStyle(Value: TFontStyles);
   function GetCharset: TFontCharset;
   procedure SetCharset(Value: TFontCharset);
   function GetPitch: TFontPitch;
   procedure SetPitch(Value: TFontPitch);
   function GetProtected: Boolean;
   procedure SetProtected(Value: Boolean);
 public
   constructor Create(AOwner: TCustomRichBox);
   procedure Assign(Source: TPersistent); override;
   property Charset: TFontCharset read GetCharset write SetCharset;
   property BackColor: TColor read GetBackColor write SetBackColor;
   property Color: TColor read GetColor write SetColor;
   property Name: TFontName read GetName write SetName;
   property Pitch: TFontPitch read GetPitch write SetPitch;
   property Protect: Boolean read GetProtected write SetProtected;
   property Size: Integer read GetSize write SetSize;
   property Style: TFontStyles read GetStyle write SetStyle;
 end;

{ TParaAttributes }
TParaAttributes = class(TPersistent)
private
  FRichBox: TCustomRichBox;
private
  function GetAlignment: {$IFNDEF WINDOWS}TAlignment{$ELSE}
    TRichEditAlignment{$ENDIF};                           // modified
  procedure SetAlignment(Value: {$IFNDEF WINDOWS}TAlignment{$ELSE}
    TRichEditAlignment{$ENDIF} );                         // modified
  function GetFirstIndent: LongInt;
  procedure SetFirstIndent(Value:LongInt);
  function GetLeftIndent:LongInt;
  procedure SetLeftIndent(Value:LongInt);
  function GetNumbering: TNumberingStyle;
  procedure SetNumbering(Value: TNumberingStyle);
  function GetRightIndent: LongInt;
  procedure SetRightIndent(Value:LongInt);
  function GetTab(Index: Byte): Longint;
  procedure SetTab(Index: Byte; Value: Longint);
  function GetTabCount: Integer;
  procedure SetTabCount(Value: Integer);
public
  constructor Create(AOwner: TCustomRichBox);
  procedure Assign(Source: TPersistent); override;
  property Alignment: {$IFNDEF WINDOWS}TAlignment{$ELSE} TRichEditAlignment
   {$ENDIF} read GetAlignment write SetAlignment;                   // modified
  property FirstIndent: Longint read GetFirstIndent write SetFirstIndent;
  property LeftIndent: Longint read GetLeftIndent write SetLeftIndent;
  property Numbering: TNumberingStyle read GetNumbering write SetNumbering;
  property RightIndent: Longint read GetRightIndent write SetRightIndent;
  property Tab[Index: Byte]: Longint read GetTab write SetTab;
  property TabCount: Integer read GetTabCount write SetTabCount;
end;

{ TCustomRichBox }
TCustomRichBox = class(TCustomMemo)
  private
    FBackgroundColor :TColor;
    FDefaultExtension :string;
    FSelAttributes: TTextAttributes;
    FParagraph: TParaAttributes;
    FPlainText: Boolean;
    function GetCaretCoordinates :TCaretCoordinates;
    function GetCaretPoint :Classes.TPoint;
    function GetScrollPoint :Classes.TPoint;
    function GetSelText :String;
    procedure SetColor(AValue : TColor);
    procedure SetScrollPoint(AValue :Classes.TPoint);
    procedure SetSelText(AValue :String);
  protected
    class procedure WSRegisterClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FindText(const SearchStr: string; StartPos, Length: Integer;
      Options: TSearchTypes; Backwards :boolean): Integer;
    function GetFirsVisibleLine :integer;
    function GetRealTextBuf: String;
    function GetRealtextSel: String;
    procedure GetRTFSelection(intoStream :TStream);
    function GetWordAtPoint(X, Y :integer) :string;
    function GetWordAtPos(Pos :integer): string;
    function GetZoomState :TZoomPair;
    procedure Loaded; override;
    procedure LoadFromFile(AFileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure Print(const DocumentTitle: string; Margins :TMargins);
    procedure PutRTFSelection(sourceStream: TStream);
    procedure Redo;
    procedure SaveToFile(AFileName: string);
    procedure SaveToStream(Stream: TStream);
    procedure ScrollLine(Delta :integer);
    procedure ScrollToCaret;
    procedure SetZoomState(AValue :TZoomPair);
  public
    property CaretCoordinates :TCaretCoordinates read GetCaretCoordinates;
    property CaretPoint :Classes.TPoint read GetCaretPoint;
    property Color :TColor read FBackgroundColor write SetColor;
    property Paragraph : TParaAttributes read FParagraph;
    property PlainText :Boolean read FPlainText write FPlainText default False;
    property ScrollPoint :Classes.TPoint read GetScrollPoint write SetScrollPoint;
    property SelAttributes :TTextAttributes read FSelAttributes;
    property SelText: String read GetSelText write SetSelText;
  published
    property DefaultExtension :string read FDefaultExtension
      write FDefaultExtension;
  end;

{ TCustomRichBox }
TRichBox = class(TCustomRichBox)
published
  property Align;
  property Alignment;
  property Anchors;
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

TlzRichEdit = class(TRichBox)
end;
procedure Register;

implementation
uses
  WSRichBox;

procedure Register;
begin
  RegisterComponents('Common Controls', [TlzRichEdit]);
end;

{$I tparaattributes.inc}
{$I ttextattributes.inc}
{$I tcustomrichbox.inc}
initialization
{$I lzrichedit.lrs}
end.

