unit UParagrafo;

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
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  RichBox;

type

  { TfrmParagrafo }

  TfrmParagrafo = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
    RichControl:TWinControl;
    SStart, SLen: Integer;
  public
    { public declarations }
    procedure Execute(aRichControl: TWinControl);
  end; 

var
  frmParagrafo: TfrmParagrafo;

implementation

{$R *.lfm}

{ TfrmParagrafo }

procedure TfrmParagrafo.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if not (key in ['0'..'9',#8]) then
  key := #0;
end;

procedure TfrmParagrafo.Button1Click(Sender: TObject);
begin
  if Edit1.Text = '' then Edit1.Text:='0';
  if Edit2.Text = '' then Edit2.Text:='0';
  if Edit3.Text = '' then Edit3.Text:='0';

  TRichBox(RichControl).SelStart:= SStart;
  TRichBox(RichControl).SelLength:= SLen;

  if ComboBox1.Text = '' then ComboBox1.ItemIndex:= 2;
  //--
  {$IFDEF Windows}
  TRichBox(RichControl).Paragraph.LeftIndent:= StrToInt(Edit1.Text) +
                                               StrToInt(Edit3.Text);
  TRichBox(RichControl).Paragraph.FirstIndent:= StrToInt(Edit3.Text) * -1;
  {$ENDIF}

  {$IFDEF Linux}
  TRichBox(RichControl).Paragraph.LeftIndent:= StrToInt(Edit1.Text);
  TRichBox(RichControl).Paragraph.FirstIndent:= StrToInt(Edit3.Text);
  {$ENDIF}

  TRichBox(RichControl).Paragraph.RightIndent:= StrToInt(Edit2.Text);

  //--
  case ComboBox1.ItemIndex of
    2: TRichBox(RichControl).Paragraph.Alignment :={$IFNDEF WINDOWS}taLeftJustify{$ELSE}traLeft{$ENDIF};
    1: TRichBox(RichControl).Paragraph.Alignment:= {$IFNDEF WINDOWS}taRightJustify{$ELSE}traRight{$ENDIF};
    0: TRichBox(RichControl).Paragraph.Alignment:= {$IFNDEF WINDOWS}taCenter{$ELSE}traCenter{$ENDIF};
    3: TRichBox(RichControl).Paragraph.Alignment:= {$IFNDEF WINDOWS}taLeftJustify{$ELSE}traJustify{$ENDIF};
  end;
  Close;
end;

procedure TfrmParagrafo.Button2Click(Sender: TObject);
begin
  Close;
end;


procedure TfrmParagrafo.Execute(aRichControl: TWinControl);
begin
  RichControl:= aRichControl;
  Show;
  SStart:= TRichBox(RichControl).SelStart;
  Slen:= TRichBox(RichControl).SelLength;
  {$IFDEF WINDOWS}
  Edit1.Text:= IntToStr(TRichBox(RichControl).Paragraph.LeftIndent -
               (TRichBox(RichControl).Paragraph.FirstIndent * -1));
  Edit3.Text:= IntToStr(TRichBox(RichControl).Paragraph.FirstIndent * -1);
  {$ENDIF}

  {$IFDEF Linux}
  Edit1.Text:= IntToStr(TRichBox(RichControl).Paragraph.LeftIndent);
  Edit3.Text:= IntToStr(TRichBox(RichControl).Paragraph.FirstIndent);
  {$ENDIF}

  Edit2.Text:= IntToStr(TRichBox(RichControl).Paragraph.RightIndent);

  case TRichBox(RichControl).Paragraph.Alignment of
    {$IFNDEF WINDOWS}taLeftJustify{$ELSE}traLeft{$ENDIF}:
      ComboBox1.ItemIndex:= 2;
    {$IFNDEF WINDOWS}taCenter{$ELSE}traCenter{$ENDIF}:
      ComboBox1.ItemIndex:= 0;
    {$IFNDEF WINDOWS}taRightJustify{$ELSE}traRight{$ENDIF}:
      ComboBox1.ItemIndex:= 1;
    {$IFDEF WINDOWS}traJustify: ComboBox1.ItemIndex:= 3;{$ENDIF}
  end;
  TRichBox(RichControl).Refresh;
  TRichBox(RichControl).SelStart:= SStart;
  TRichBox(RichControl).SelLength:= SLen;
end;

end.
