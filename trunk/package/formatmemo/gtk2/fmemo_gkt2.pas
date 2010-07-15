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
unit FMemo_GKT2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, StdCtrls, LCLType, Controls, FMemo_Type,
  gtk2, glib2, gdk2, pango, Gtk2Proc, Gtk2Def, gdk2pixbuf, GraphType,
  IntfGraphics;

type
  { TCustomFMemo }
  TCustomFMemo = class(TCustomMemo)
private

public
  procedure SetFormat(var FontDesc: TFontDesc);
  procedure SetFormat(var FontDesc: TFontDesc; sStart, sLenght:Integer);
  function GetFormat(var FontDesc: TFontDesc):Boolean;
  procedure InsertImage(Position:Integer; Image:TPicture; ResizeWidth, ResizeHeight:Integer);
  function GetImage(var Image:TPicture):boolean;
end;

function WGGetBuffer(const AWinControl: TWinControl; var Buffer: PGtkTextBuffer
  ): Boolean;

procedure WGSetTextFormat(const AWinControl: TWinControl; SelStart,
  SelLen: Integer; const FontDesc: TFontDesc);

function WGGetTextFormat(const AWinControl: TWinControl; Position:Integer;
  var FontDesc: TFontDesc): Boolean;

Procedure WGInsertImage(const AWinControl: TWinControl; Position:Integer;
  Image:TPicture; ResizeWidth, ResizeHeight:Integer);

function WGGetImage(const AWinControl: TWinControl; Position:Integer;
  var Image:TPicture):boolean;

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
  Buffer:= gtk_text_view_get_buffer (PGtkTextView(AWidget));
  if not(Assigned(Buffer)) then Exit;

  //--
Result:=True;
end;

procedure WGSetTextFormat(const AWinControl: TWinControl; SelStart,
  SelLen: Integer; const FontDesc: TFontDesc);

procedure Apply(Tag:Pointer; Buffer :PGtkTextBuffer);
var
  iterStart, iterEnd:TGtkTextIter;
begin
  gtk_text_buffer_get_iter_at_offset (buffer, @iterStart, SelStart);
  gtk_text_buffer_get_iter_at_offset (buffer, @iterEnd, SelStart+SelLen);
  gtk_text_buffer_apply_tag(buffer, tag, @iterStart, @iterEnd);
end;

var
    Buffer      :PGtkTextBuffer=nil;
    Tag         :Pointer=nil;
    FontColor   :TGDKColor;
    BackColor   :TGDKColor;
    FontFamily  :string;
begin

    if not(WGGetBuffer(AWinControl, Buffer)) then Exit;

    //--
    FontColor:= TColortoTGDKColor(FontDesc.FontColor);
    BackColor:= TColortoTGDKColor(FontDesc.BackColor);

    //--
    FontFamily:= FontDesc.Name;
    if (FontFamily = '') then FontFamily:= #0;

    //--
    Tag:= gtk_text_buffer_create_tag (buffer, nil,'family', [@FontFamily[1],
        'family-set'       , gTRUE,
        'size-points'      , Double(FontDesc.Size),
        'foreground-gdk'   , @FontColor,
        'foreground-set'   , gboolean(gTRUE),
        'background-gdk'   , @BackColor,
        'background-set'   , gboolean(gTRUE),
        'underline'        , FontDesc.Underline,
        'underline-set'    , gboolean(gTRUE),
        'weight'           , FontDesc.Weight,
        'weight-set'       , gboolean(gTRUE),
        'style'            , FontDesc.Style,
        'style-set'        , gboolean(gTRUE),
        'strikethrough'    , gboolean(Integer(FontDesc.Strikethrough)),
        'strikethrough-set', gboolean(gTRUE),
        'justification'    , FontDesc.Justify,
        'justification-set', gboolean(gTRUE),
        nil]);
    Apply(Tag, Buffer);

end;

function WGGetTextFormat(const AWinControl: TWinControl; Position:Integer;
  var FontDesc: TFontDesc): Boolean;
var
  Buffer      : PGtkTextBuffer=nil;
  Attributes : PGtkTextAttributes;
  iPosition   : TGtkTextIter;
begin
Result:=False;
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
      FontDesc.Name:= pango_font_description_get_family(Attributes^.font);

      //--
      FontDesc.Size := pango_font_description_get_size(Attributes^.font);
      if not(pango_font_description_get_size_is_absolute(Attributes^.font)) then
      FontDesc.Size := Round(FontDesc.Size / PANGO_SCALE);

      //--
      FontDesc.FontColor:=TGDKColorToTColor(Attributes^.appearance.fg_color);

      //--
      FontDesc.BackColor:=TGDKColorToTColor(Attributes^.appearance.bg_color);

      //--
      if (Strikethrough(Attributes^.appearance)>0) then FontDesc.Strikethrough:=True;

      //--
      case underline(Attributes^.appearance) of
           PANGO_UNDERLINE_NONE    :FontDesc.Underline:=fuNone;
           PANGO_UNDERLINE_SINGLE  :FontDesc.Underline:=fuSingle;
           PANGO_UNDERLINE_DOUBLE  :FontDesc.Underline:=fuDouble;
           PANGO_UNDERLINE_LOW     :FontDesc.Underline:=fuLow;
           4                       :FontDesc.Underline:=fuError;
      end;

      //--
      case pango_font_description_get_weight(Attributes^.font) of
           PANGO_WEIGHT_ULTRALIGHT :FontDesc.Weight:=fwUltralight;
           PANGO_WEIGHT_LIGHT      :FontDesc.Weight:=fwLight;
           PANGO_WEIGHT_NORMAL     :FontDesc.Weight:=fwNormal;
           PANGO_WEIGHT_BOLD       :FontDesc.Weight:=fwBold;
           PANGO_WEIGHT_ULTRABOLD  :FontDesc.Weight:=fwUtrabold;
           PANGO_WEIGHT_HEAVY      :FontDesc.Weight:=fwHeavy;
      end;

      //--
      case Attributes^.justification of
           GTK_JUSTIFY_LEFT        :FontDesc.Justify:=fjLeft;
           GTK_JUSTIFY_RIGHT       :FontDesc.Justify:=fjRight;
           GTK_JUSTIFY_CENTER      :FontDesc.Justify:=fjCenter;
           GTK_JUSTIFY_FILL        :FontDesc.Justify:=fjFill;
      end;

      //--
      case pango_font_description_get_style(Attributes^.font) of
           PANGO_STYLE_NORMAL       :FontDesc.Style:=fpNormal;
           PANGO_STYLE_OBLIQUE      :FontDesc.Style:=fpOblique;
           PANGO_STYLE_ITALIC       :FontDesc.Style:=fpItalic;
      end;

      //--
      gtk_text_attributes_unref(Attributes);
      Result:=True;
    end
  else
    begin
      gtk_text_attributes_unref(Attributes);
    end;
end;

procedure WGInsertImage(const AWinControl: TWinControl; Position: Integer;
  Image: TPicture; ResizeWidth, ResizeHeight:Integer);
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

      if (pixbuf<>nil) then gtk_text_buffer_insert_pixbuf (buffer, @iPosition, pixbuf);
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

{ TCustomFMemo }

procedure TCustomFMemo.SetFormat(var FontDesc: TFontDesc);
begin
    WGSetTextFormat(Self, Self.SelStart, Self.SelLength, FontDesc);
end;

procedure TCustomFMemo.SetFormat(var FontDesc: TFontDesc; sStart, sLenght:Integer);
begin
    WGSetTextFormat(Self, sStart, sLenght, FontDesc);
end;

function TCustomFMemo.GetFormat(var FontDesc: TFontDesc): Boolean;
begin
  //--
  FontDesc.Name:= 'default';
  FontDesc.Size:= 11;
  FontDesc.FontColor:= clWindowText;
  FontDesc.BackColor:= clWindow;
  FontDesc.Strikethrough:= False;
  FontDesc.Underline:= fuNone;
  FontDesc.Weight:= fwNormal;
  FontDesc.Justify:= fjLeft;
  FontDesc.Style:= fpNormal;

  //--
  Result:= WGGetTextFormat(Self, Self.SelStart, FontDesc);

end;

procedure TCustomFMemo.InsertImage(Position: Integer; Image: TPicture;
  ResizeWidth, ResizeHeight: Integer);
begin
  WGInsertImage(Self, Position, Image, ResizeWidth, ResizeHeight);
end;

function TCustomFMemo.GetImage(var Image: TPicture): boolean;
begin
 Result:= WGGetImage(Self, Self.SelStart, Image);

end;

end.

