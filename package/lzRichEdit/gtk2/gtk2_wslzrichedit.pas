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

unit GTK2_WSlzRichEdit;

{$mode objfpc}{$H+}

interface

uses
Classes, SysUtils, LCLType, LCLProc, Controls, Graphics, GraphType, IntfGraphics,
InterfaceBase,
gtk2, glib2, gdk2, pango, Gtk2Proc, Gtk2Def, gdk2pixbuf, Gtk2Globals,
GTK2WinApiWindow, Gtk2WSControls,
WSlzRichEdit, lzRichEditTypes, lzRichEdit;

type

  { TGTK2_WSCustomlzRichEdit }

  TGTK2_WSCustomlzRichEdit = class(TWSCustomlzRichEdit)
    class function CreateHandle(const AWinControl: TWinControl; const AParams: TCreateParams): TLCLIntfHandle; override;
    class procedure SaveToStream(const AWinControl: TWinControl;
      var Stream: TStream); override;
    class procedure LoadFromStream(const AWinControl: TWinControl;
      const Stream: TStream); override;
    //--
    class procedure SetTextAttributes(const AWinControl: TWinControl; iSelStart, iSelLength: Integer; const TextParams: TFontParams); override;
    class procedure GetTextAttributes(const AWinControl: TWinControl; Position: Integer; var TextParams: TFontParams); override;
    class procedure GetAlignment(const AWinControl: TWinControl; Position: Integer; var Alignment:TRichEdit_Align); override;
    class procedure SetAlignment(const AWinControl: TWinControl; iSelStart, iSelLength: Integer; Alignment:TRichEdit_Align); override;
    class procedure SetNumbering(const AWinControl: TWinControl; N:Boolean); override;
    class procedure GetNumbering(const AWinControl: TWinControl; var N:Boolean); override;
    class procedure SetRightIndent(const AWinControl: TWinControl; iSelStart, iSelLength: Integer; I:Integer); override;
    class procedure GetRightIndent(const AWinControl: TWinControl; Position: Integer; var I:Integer); override;
    class procedure SetStartIndent(const AWinControl: TWinControl; iSelStart, iSelLength: Integer; I:Integer); override;
    class procedure GetStartIndent(const AWinControl: TWinControl; Position: Integer; var I:Integer); override;
    class procedure InsertImage(const AWinControl: TWinControl; Position: Integer; Image: TPicture); override;
    class function GetImage(const AWinControl: TWinControl; Position: Integer; var Image: TPicture):Boolean; override;
    class function GetRealTextBuf(const AWinControl: TWinControl):String; override;
  end;

  function WGGetBuffer(const AWinControl: TWinControl; var Buffer: PGtkTextBuffer
    ): Boolean;
  procedure WGSetFormat(const AWinControl: TWinControl; iSelStart, iSelLength: Integer; Buffer:PGtkTextBuffer; Tag:Pointer);
  procedure WGGetFormat(const AWinControl: TWinControl; Position: Integer; var TextParams: TFontParams; var Alignment: TRichEdit_Align;
    var Left_margin:Integer; var Right_margin:Integer; var indent:Integer);
  procedure WGInsertImage(const AWinControl: TWinControl; Position: Integer;
    Image: TPicture; ResizeWidth, ResizeHeight:Integer);
  function WGGetImage(const AWinControl: TWinControl; Position: Integer;
    var Image: TPicture): boolean;
  function WGGetRealTextBuf(const AWinControl: TWinControl):String;
  function WGGetStartLine(const AWinControl: TWinControl; Position: Integer):Integer;
  function WGGetEndLine(const AWinControl: TWinControl; Position: Integer):Integer;
implementation

function WGGetBuffer(const AWinControl: TWinControl; var Buffer: PGtkTextBuffer
  ): Boolean;
var
  AWidget     :PGtkWidget;
begin
Result:=False;
  //--
  AWidget:= PGtkWidget(AWinControl.Handle);
  AWidget:= GetWidgetInfo(AWidget, False)^.CoreWidget;
  if not(Assigned(AWidget)) then Exit;
  //--
  Buffer:= gtk_text_view_get_buffer(PGtkTextView(AWidget));
  if not(Assigned(Buffer)) then Exit;
  //--
Result:=True;
end;

procedure WGSetFormat(const AWinControl: TWinControl; iSelStart, iSelLength: Integer; Buffer:PGtkTextBuffer; Tag:Pointer);
var
    iterStart, iterEnd:TGtkTextIter;
begin
  gtk_text_buffer_get_iter_at_offset(buffer, @iterStart, iSelStart);
  gtk_text_buffer_get_iter_at_offset(buffer, @iterEnd, iSelStart+iSelLength);
  gtk_text_buffer_apply_tag(buffer, tag, @iterStart, @iterEnd);
end;

procedure WGGetFormat(const AWinControl: TWinControl;
  Position: Integer; var TextParams: TFontParams; var Alignment: TRichEdit_Align;
  var Left_margin:Integer; var Right_margin:Integer; var indent:Integer);
var
  Buffer      : PGtkTextBuffer=nil;
  Attributes : PGtkTextAttributes;
  iPosition   : TGtkTextIter;
begin
  //--
  if not(WGGetBuffer(AWinControl, Buffer)) then Exit;

  //--
  Attributes:=gtk_text_attributes_new;
  if not Assigned(Attributes) then Exit;

  //--
  gtk_text_buffer_get_iter_at_offset(buffer, @iPosition, Position);

  //--
  if (gtk_text_iter_get_attributes(@iPosition, Attributes)) then
    begin
      //--
      TextParams.Name:= pango_font_description_get_family(Attributes^.font);
      //--
      TextParams.Size := pango_font_description_get_size(Attributes^.font);
      if not(pango_font_description_get_size_is_absolute(Attributes^.font)) then
      TextParams.Size := Round(TextParams.Size / PANGO_SCALE);
       //--
      TextParams.Color:=TGDKColorToTColor(Attributes^.appearance.fg_color);
      //--
      TextParams.Style:= [];
      if (Strikethrough(Attributes^.appearance) > 0) then TextParams.Style:= TextParams.Style + [fsStrikeOut];
      if (underline(Attributes^.appearance) > 0) then TextParams.Style:= TextParams.Style + [fsUnderline];
      //--
      if (pango_font_description_get_weight(Attributes^.font) = PANGO_WEIGHT_BOLD) then TextParams.Style:= TextParams.Style + [fsBold];
      if (pango_font_description_get_style(Attributes^.font) = PANGO_STYLE_ITALIC) then TextParams.Style:= TextParams.Style + [fsItalic];
      //--
      case Attributes^.justification of
           GTK_JUSTIFY_LEFT        :Alignment:=alLeft;
           GTK_JUSTIFY_RIGHT       :Alignment:=alRight;
           GTK_JUSTIFY_CENTER      :Alignment:=alCenter;
           GTK_JUSTIFY_FILL        :Alignment:=alJustify;
      end;
     end;
    Left_margin:= Attributes^.left_margin;
    Right_margin:= Attributes^.right_margin;

    gtk_text_attributes_unref(Attributes);

    if (Integer(Alignment) > 3)  then Alignment:= alLeft;
    if  TextParams.Name = '' then TextParams.Name:= 'Sans';
    if  (TextParams.Size > 100) or (TextParams.Size <= 1) then TextParams.Size:= 10;

end;

procedure WGInsertImage(const AWinControl: TWinControl; Position: Integer;
  Image: TPicture; ResizeWidth, ResizeHeight: Integer);
var
  Buffer       : PGtkTextBuffer=nil;
  iPosition    : TGtkTextIter;
  GDIObj       : PGDIObject=nil;
  pixbuf       : PGDKPixBuf=nil;
  scaled       : PGDKPixBuf=nil;
  pixmap       : PGdkDrawable=nil;
  bitmap       : PGdkBitmap=nil;
  Width, Height: integer;
begin

    if not(WGGetBuffer(AWinControl, Buffer)) then Exit;

    //--
    gtk_text_buffer_get_iter_at_offset(buffer, @iPosition, Position);

    //--
    GDIObj := PGDIObject(Image.Bitmap.Handle);

    //--
    case GDIObj^.GDIBitmapType of
          gbBitmap:
            begin
              bitmap := GDIObj^.GDIBitmapObject;
              gdk_drawable_get_size(bitmap, @Width, @Height);
              pixbuf := CreatePixbufFromDrawable(bitmap, nil, False, 0, 0, 0, 0, Width, Height);
            end;
          gbPixmap:
            begin
              pixmap := GDIObj^.GDIPixmapObject.Image;
              if pixmap <> nil then
              begin
                gdk_drawable_get_size(pixmap, @Width, @Height);
                bitmap := CreateGdkMaskBitmap(Image.Bitmap.Handle, 0);
                pixbuf := CreatePixbufFromImageAndMask(pixmap, 0, 0, Width, Height, nil, Bitmap);
              end;
            end;
          gbPixbuf:
            begin
              pixbuf := gdk_pixbuf_copy(GDIObj^.GDIPixbufObject);
            end;
        end;

      if (ResizeWidth > 1) and (ResizeHeight > 1) then
       begin
         scaled:= gdk_pixbuf_scale_simple (pixbuf, ResizeWidth, ResizeHeight, GDK_INTERP_HYPER);
         g_object_unref(pixbuf);
         pixbuf:= scaled;
       end;

      if (pixbuf<>nil) then gtk_text_buffer_insert_pixbuf(buffer, @iPosition, pixbuf);

end;

function WGGetImage(const AWinControl: TWinControl; Position: Integer;
  var Image: TPicture): boolean;
var
  Buffer       : PGtkTextBuffer=nil;
  iPosition    : TGtkTextIter;
  pixbuf       : PGDKPixBuf=nil;
  BitmapData   : TLazIntfImage=nil;
  Width, Height, rowstride, n_channels, i, j : Integer;
  pixels, p : Pguchar;
begin

//--
Result:=False;
    //--
    if not(WGGetBuffer(AWinControl, Buffer)) then Exit;

    //--
    gtk_text_buffer_get_iter_at_offset(buffer, @iPosition, Position);

    //--
    pixbuf := gtk_text_iter_get_pixbuf(@iPosition);

    //--
    if (pixbuf=nil) then Exit;

    n_channels:= gdk_pixbuf_get_n_channels(pixbuf);
    width := gdk_pixbuf_get_width(pixbuf);
    height := gdk_pixbuf_get_height(pixbuf);
    rowstride := gdk_pixbuf_get_rowstride(pixbuf);
    pixels := gdk_pixbuf_get_pixels(pixbuf);
    Image.Bitmap.Height:=height;
    Image.Bitmap.Width:=width;
    Image.Bitmap.PixelFormat := pf32bit;

    BitmapData:= Image.Bitmap.CreateIntfImage;

    try
    for i := 0 to Width-1 do
      for J := 0 to Height-1 do
      begin
        p := pixels + j * rowstride + i * n_channels;
        PByteArray(BitmapData.PixelData)^[(((J*Width)+i)*4)] := Ord((p+2)^);
        PByteArray(BitmapData.PixelData)^[(((J*Width)+i)*4)+1] := Ord((p+1)^);
        PByteArray(BitmapData.PixelData)^[(((J*Width)+i)*4)+2] := Ord(p^);
        PByteArray(BitmapData.PixelData)^[(((J*Width)+i)*4)+3] := 0;
      end;
    Image.Bitmap.LoadFromIntfImage(BitmapData);
    finally
    BitmapData.Free;
    end;
//--
Result:=True;
end;

function WGGetRealTextBuf(const AWinControl: TWinControl): String;
var
  iterStart, iterEnd:TGtkTextIter;
  Buffer: PGtkTextBuffer;
begin
    Result:= '';
    if not(WGGetBuffer(AWinControl, Buffer)) then Exit;

    gtk_text_buffer_get_start_iter(Buffer, @iterStart);
    gtk_text_buffer_get_end_iter(Buffer, @iterEnd);
    Result:= gtk_text_buffer_get_slice(Buffer, @iterStart, @iterEnd, gboolean(False));
end;

function WGGetStartLine(const AWinControl: TWinControl; Position: Integer
  ): Integer;
var
  S:String;
  CH:TUTF8Char;
  I, I2:Integer;
begin
  S:=WGGetRealTextBuf(AWinControl);
  for I:= Position downto 0 do
    begin
      CH:= UTF8Copy(S, I, 1);
      if (UTF8CharacterToUnicode(@CH[1], I2) = $A) or (I = 0)then
        begin
          Result:= I;
          Exit;
        end;
     end;
  Result:= Position;
end;

function WGGetEndLine(const AWinControl: TWinControl; Position: Integer
  ): Integer;
var
  S: String;
  CH: TUTF8Char;
  I, I2: Integer;
  Len: Integer;
begin
  S:=WGGetRealTextBuf(AWinControl);
  Len:= UTF8Length(S);
  for I:=Position to  Len do
    begin
      CH:= UTF8Copy(S, I, 1);
      if (UTF8CharacterToUnicode(@CH[1], I2) = $A) or (I = Len)then
        begin
          Result:= I;
          Exit;
        end;
     end;
  Result:= Position;
end;

class function TGTK2_WSCustomlzRichEdit.CreateHandle(
  const AWinControl: TWinControl; const AParams: TCreateParams
  ): TLCLIntfHandle;
var
  Widget,
  TempWidget: PGtkWidget;
  WidgetInfo: PWidgetInfo;
begin
  Widget := gtk_scrolled_window_new(nil, nil);
  Result := TLCLIntfHandle(PtrUInt(Widget));
  if Result = 0 then Exit;

  WidgetInfo := CreateWidgetInfo(Pointer(Result), AWinControl, AParams);

  TempWidget := gtk_text_view_new();
  gtk_container_add(PGtkContainer(Widget), TempWidget);

  GTK_WIDGET_UNSET_FLAGS(PGtkScrolledWindow(Widget)^.hscrollbar, GTK_CAN_FOCUS);
  GTK_WIDGET_UNSET_FLAGS(PGtkScrolledWindow(Widget)^.vscrollbar, GTK_CAN_FOCUS);
  gtk_scrolled_window_set_policy(PGtkScrolledWindow(Widget),
                                     GTK_POLICY_AUTOMATIC,
                                     GTK_POLICY_AUTOMATIC);
  gtk_scrolled_window_set_shadow_type(PGtkScrolledWindow(Widget),
    BorderStyleShadowMap[TCustomControl(AWinControl).BorderStyle]);

  SetMainWidget(Widget, TempWidget);
  GetWidgetInfo(Widget, True)^.CoreWidget := TempWidget;

  gtk_text_view_set_editable(PGtkTextView(TempWidget), True);

  gtk_text_view_set_wrap_mode(PGtkTextView(TempWidget), GTK_WRAP_WORD);

  gtk_text_view_set_accepts_tab(PGtkTextView(TempWidget), True);

  gtk_widget_show_all(Widget);

  Set_RC_Name(AWinControl, Widget);

  TGtk2WSWinControl.SetCallbacks(PGtkObject(Widget), TComponent(WidgetInfo^.LCLObject));
end;

class procedure TGTK2_WSCustomlzRichEdit.SaveToStream(
  const AWinControl: TWinControl; var Stream: TStream);
begin

end;

class procedure TGTK2_WSCustomlzRichEdit.LoadFromStream(
  const AWinControl: TWinControl; const Stream: TStream);
begin

end;

class procedure TGTK2_WSCustomlzRichEdit.SetTextAttributes(
  const AWinControl: TWinControl; iSelStart, iSelLength: Integer;
  const TextParams: TFontParams);
var
  FontFamily  :string;
  FontColor   :TGDKColor;
  Tag         :Pointer=nil;
  Buffer      :PGtkTextBuffer=nil;
const
  PangoUnderline : array [Boolean] of Integer = (PANGO_UNDERLINE_NONE, PANGO_UNDERLINE_SINGLE);
  PangoBold      : array [Boolean] of Integer = (PANGO_WEIGHT_NORMAL, PANGO_WEIGHT_BOLD);
  PangoItalic    : array [Boolean] of Integer = (PANGO_STYLE_NORMAL, PANGO_STYLE_ITALIC);
begin

   FontColor:= TColortoTGDKColor(TextParams.Color);
  //--
  FontFamily:= TextParams.Name;
  if (FontFamily = '') then FontFamily:= #0;
  //--
  if not(WGGetBuffer(AWinControl, Buffer)) then Exit;
  Tag:= gtk_text_buffer_create_tag(buffer, nil,'family', [@FontFamily[1],
    'family-set'       , gTRUE,
    'size-points'      , Double(TextParams.Size),
    'foreground-gdk'   , @FontColor,
    'foreground-set'   , gboolean(gTRUE),
    'underline'        , PangoUnderline[fsUnderline in TextParams.Style],
    'underline-set'    , gboolean(gTRUE),
    'weight'           , PangoBold[fsBold in TextParams.Style],
    'weight-set'       , gboolean(gTRUE),
    'style'            , PangoItalic[fsItalic in TextParams.Style],
    'style-set'        , gboolean(gTRUE),
    'strikethrough'    , gboolean(fsStrikeOut in TextParams.Style),
    'strikethrough-set', gboolean(gTRUE),
    nil]);

  WGSetFormat(AWinControl, iSelStart, iSelLength, Buffer, Tag);
end;

class procedure TGTK2_WSCustomlzRichEdit.GetTextAttributes(
  const AWinControl: TWinControl; Position: Integer; var TextParams: TFontParams);
var
  iAlignment: TRichEdit_Align;
  Left_m, Right_m:Integer;
  indent:Integer;
begin
  WGGetFormat(AWinControl, Position, TextParams, iAlignment, Left_m, Right_m, indent);
end;

class procedure TGTK2_WSCustomlzRichEdit.GetAlignment(
  const AWinControl: TWinControl; Position: Integer; var Alignment: TRichEdit_Align);
var
  iTextParams: TFontParams;
  Left_m, Right_m:Integer;
  indent: Integer;
begin
  WGGetFormat(AWinControl, Position, iTextParams, Alignment, Left_m, Right_m, indent);
end;

class procedure TGTK2_WSCustomlzRichEdit.SetAlignment(
  const AWinControl: TWinControl; iSelStart, iSelLength: Integer; Alignment: TRichEdit_Align);
const
  GTKJustification: array [TRichEdit_Align] of Integer = (GTK_JUSTIFY_LEFT, GTK_JUSTIFY_RIGHT, GTK_JUSTIFY_CENTER, GTK_JUSTIFY_FILL);
var
  Tag:Pointer=nil;
  Buffer      :PGtkTextBuffer=nil;
begin
 //--
 if not(WGGetBuffer(AWinControl, Buffer)) then Exit;
 Tag:= gtk_text_buffer_create_tag(buffer, nil, 'justification',[GTKJustification[Alignment],
    'justification-set', gboolean(gTRUE),
   nil]);
 WGSetFormat(AWinControl, iSelStart, iSelLength, Buffer, Tag);
end;

class procedure TGTK2_WSCustomlzRichEdit.SetNumbering(
  const AWinControl: TWinControl; N: Boolean);
var
  I:Integer;
  iterStart, iterEnd:TGtkTextIter;
  Buffer      :PGtkTextBuffer=nil;
  Ch: TUTF8Char;
  N2:Boolean=False;
begin
 I:= WGGetStartLine(AWinControl, TCustomlzRichEdit(AWinControl).SelStart);

 if not(WGGetBuffer(AWinControl, Buffer)) then Exit;
 GetNumbering(AWinControl, N2);
 if not(N) and N2 then
   begin
     gtk_text_buffer_get_iter_at_offset(Buffer, @iterStart, I);
     gtk_text_buffer_get_iter_at_offset(Buffer, @iterEnd, I + 1);
     gtk_text_buffer_Delete(Buffer, @iterStart, @iterEnd);
   end
 else
   begin
     Ch:= TCustomlzRichEdit(AWinControl).NumberingParams.NChar;
     gtk_text_buffer_get_iter_at_offset(Buffer, @iterStart, I);
     gtk_text_buffer_insert(Buffer, @iterStart, @Ch[1], Length(Ch));
     //--
     SetTextAttributes(AWinControl, I, 1, TCustomlzRichEdit(AWinControl).NumberingParams.FontParams);
   end;
end;

class procedure TGTK2_WSCustomlzRichEdit.GetNumbering(
  const AWinControl: TWinControl; var N: Boolean);
var
  I:Integer;
  iterStart, iterEnd:TGtkTextIter;
  Buffer      :PGtkTextBuffer=nil;
  Ch: TUTF8Char;
  TextParams: TFontParams;
begin
 N:= False;
 I:= WGGetStartLine(AWinControl, TCustomlzRichEdit(AWinControl).SelStart);
 GetTextAttributes(AWinControl, I, TextParams);

 if (UTF8Copy(WGGetRealTextBuf(AWinControl), I +1, 1)= TCustomlzRichEdit(AWinControl).NumberingParams.NChar) and
    (TextParams.Name = TCustomlzRichEdit(AWinControl).NumberingParams.FontParams.Name) then
 N:= True;
end;

class procedure TGTK2_WSCustomlzRichEdit.SetRightIndent(
  const AWinControl: TWinControl; iSelStart, iSelLength: Integer; I:Integer);
var
  Tag:Pointer=nil;
  Buffer      :PGtkTextBuffer=nil;
begin
 //--
 if not(WGGetBuffer(AWinControl, Buffer)) then Exit;
 Tag:= gtk_text_buffer_create_tag(buffer, nil, 'right_margin',[I,
    'right_margin-set', gboolean(gTRUE),
   nil]);
 WGSetFormat(AWinControl, iSelStart, iSelLength, Buffer, Tag);
end;

class procedure TGTK2_WSCustomlzRichEdit.GetRightIndent(
  const AWinControl: TWinControl; Position: Integer; var I:Integer);
var
  iTextParams: TFontParams;
  iAlignment: TRichEdit_Align;
  Left_m:Integer;
  indent: Integer;
begin
  WGGetFormat(AWinControl, Position, iTextParams, iAlignment, Left_m, I, indent);
end;

class procedure TGTK2_WSCustomlzRichEdit.SetStartIndent(
  const AWinControl: TWinControl; iSelStart, iSelLength: Integer; I:Integer);
var
  Tag:Pointer=nil;
  Buffer      :PGtkTextBuffer=nil;
begin
 //--
 if not(WGGetBuffer(AWinControl, Buffer)) then Exit;
 Tag:= gtk_text_buffer_create_tag(buffer, nil, 'left_margin',[I,
    'left_margin-set', gboolean(gTRUE),
   nil]);
 WGSetFormat(AWinControl, iSelStart, iSelLength, Buffer, Tag);
end;

class procedure TGTK2_WSCustomlzRichEdit.GetStartIndent(
  const AWinControl: TWinControl; Position: Integer; var I:Integer);
var
  iTextParams: TFontParams;
  iAlignment: TRichEdit_Align;
  Right_m:Integer;
  indent: Integer;
begin
  WGGetFormat(AWinControl, Position, iTextParams, iAlignment, I, Right_m, indent);
end;

class procedure TGTK2_WSCustomlzRichEdit.InsertImage(
  const AWinControl: TWinControl; Position: Integer; Image: TPicture);
begin
  WGInsertImage(AWinControl, Position, Image, 0, 0);
end;

class function TGTK2_WSCustomlzRichEdit.GetImage(
  const AWinControl: TWinControl; Position: Integer; var Image: TPicture):Boolean;
begin
  Result:= WGGetImage(AWinControl, Position, Image);
end;

class function TGTK2_WSCustomlzRichEdit.GetRealTextBuf(
  const AWinControl: TWinControl): String;
begin
  Result:=WGGetRealTextBuf(AWinControl);
end;

end.

