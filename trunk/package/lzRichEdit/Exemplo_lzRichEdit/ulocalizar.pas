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
  I, I2, N, LenText:Integer;
  S:String;
  B:Boolean=False;
begin
  LenText:= UTF8Length(TlzRichEdit(RichControl).Text);
  N:= 1;

  if (TlzRichEdit(RichControl).SelStart = 0) then NP:= 1;

  for I:= (TlzRichEdit(RichControl).SelStart + TlzRichEdit(RichControl).SelLength + NP) to LenText do
   begin
     S:= UTF8Copy(TlzRichEdit(RichControl).Text, I, UTF8Length(Edit1.Text));
     N:= 1;

     if not(Checkbox2.Checked) and (UTF8UpperCase(S)=UTF8UpperCase(Edit1.Text)) or
        (I = 0) and not(Checkbox2.Checked) and (UTF8UpperCase(S)=UTF8UpperCase(Edit1.Text)) then
       B:=True;
     if Checkbox2.Checked and (S=Edit1.Text) or
       (I = 0) and Checkbox2.Checked and (S=Edit1.Text) then
       B:=True;

     if B then
       begin
         for I2:= 0 to I do
           if (TlzRichEdit(RichControl).Text[I2]= #10) then Inc(N);
         NP:= N;
         TlzRichEdit(RichControl).SelStart:= I -1;
         TlzRichEdit(RichControl).SelLength:= UTF8Length(Edit1.Text);
         TlzRichEdit(RichControl).SetFocus;
         Exit;
       end;
   end;
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

