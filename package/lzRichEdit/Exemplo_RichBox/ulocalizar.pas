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
unit ULocalizar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  RichBox, LCLProc;

type

  { TfrmLocalizar }

  TfrmLocalizar = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
    RichControl: TWinControl;
  protected
    procedure sFindNext;
  public
    { public declarations }
    procedure Execute(Const sText:String; aRichControl: TWinControl);
  end; 

var
  frmLocalizar: TfrmLocalizar;
  NP:Integer;
implementation

{$R *.lfm}

{ TfrmLocalizar }

procedure TfrmLocalizar.Button1Click(Sender: TObject);
begin
  sFindNext;
end;

procedure TfrmLocalizar.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmLocalizar.sFindNext;
var
  I, LenText, LenWord:Integer;
  SWord, RText:String;
  iPosIni :Integer;
begin
  RText:= TRichBox(RichControl).Text;
  SWord:= Edit1.Text;

  if not(CheckBox2.Checked) then
    begin
      RText := UTF8UpperCase(RText);
      SWord := UTF8UpperCase(SWord);
    end;

  LenText := UTF8Length(RText);
  LenWord := UTF8Length(SWord);
  TRichBox(RichControl).SelStart:= TRichBox(RichControl).SelStart +
    TRichBox(RichControl).SelLength;
  //--
  for I:= (TRichBox(RichControl).SelStart + 1) to LenText do
    begin
      if (UTF8Copy(RText, I, LenWord) = SWord) then
        begin
          TRichBox(RichControl).SelStart:= I - 1;
          TRichBox(RichControl).SelLength := UTF8Length(SWord);
          TRichBox(RichControl).SetFocus;
          Exit;
        end;
    end;
  //--
  MessageDlg('Localizar', 'Fim da pesquisa.', mtConfirmation, [mbOk], 0);
end;

procedure TfrmLocalizar.Execute(const sText: String; aRichControl: TWinControl);
begin
  RichControl:=aRichControl;
  Edit1.Text:= sText;
  NP:= 0;
  Show;
end;

end.

