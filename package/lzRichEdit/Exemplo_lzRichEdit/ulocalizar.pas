unit ULocalizar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  lzRichEdit, LCLProc;

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
  B:Boolean=False;
begin
  RText:= TlzRichEdit(RichControl).GetRealTextBuf;
  SWord:= Edit1.Text;

  if not(CheckBox2.Checked) then
    begin
      RText:=UTF8UpperCase(RText);
      SWord:=UTF8UpperCase(SWord);
    end;

  LenText:= UTF8Length(RText);
  LenWord:= UTF8Length(SWord);
  TlzRichEdit(RichControl).SelStart:= TlzRichEdit(RichControl).SelStart +
    TlzRichEdit(RichControl).SelLength;
  //--
  for I:= (TlzRichEdit(RichControl).SelStart + 1) to LenText do
    begin
      if (UTF8Copy(RText, I, LenWord) = SWord) then
        begin
          TlzRichEdit(RichControl).SelStart:= I - 1;
          TlzRichEdit(RichControl).SelLength:=UTF8Length(SWord);
          TlzRichEdit(RichControl).SetFocus;
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

