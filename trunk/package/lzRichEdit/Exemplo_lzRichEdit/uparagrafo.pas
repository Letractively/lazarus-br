unit UParagrafo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  lzRichEdit, lzRichEditTypes;

type

  { TfrmParagrafo }

  TfrmParagrafo = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
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
var
  Align_: TRichEdit_Align;
begin
  if Edit1.Text = '' then Edit1.Text:='0';
  if Edit2.Text = '' then Edit2.Text:='0';
  if ComboBox1.Text = '' then ComboBox1.ItemIndex:= 2;
  //--
  TlzRichEdit(RichControl).SetStartIndent(SStart, SLen, StrToInt(Edit1.Text));
  TlzRichEdit(RichControl).SetRightIndent(SStart, SLen, StrToInt(Edit2.Text));
  //--
  case ComboBox1.ItemIndex of
    2: Align_:= alLeft;
    1: Align_:= alRight;
    0: Align_:= alCenter;
  end;
  TlzRichEdit(RichControl).SetAlignment(SStart, SLen, Align_);
  Close;
end;

procedure TfrmParagrafo.Button2Click(Sender: TObject);
begin
  Close;
end;


procedure TfrmParagrafo.Execute(aRichControl: TWinControl);
var
  Align_: TRichEdit_Align;
  L, R:Integer;
begin
  RichControl:= aRichControl;
  Show;
  SStart:= TlzRichEdit(RichControl).SelStart;
  Slen:= TlzRichEdit(RichControl).SelLength;
  //Edit1.Text:= IntToStr(TlzRichEdit(RichControl).GetStartIndent);
  //Edit2.Text:= IntToStr(TlzRichEdit(RichControl).GetRightIndent);
  TlzRichEdit(RichControl).GetStartIndent(TlzRichEdit(RichControl).SelStart, L);
  TlzRichEdit(RichControl).GetRightIndent(TlzRichEdit(RichControl).SelStart, R);
  Edit1.Text:= IntToStr(L);
  Edit2.Text:= IntToStr(R);

  TlzRichEdit(RichControl).GetAlignment(TlzRichEdit(RichControl).SelStart ,Align_);

  case Align_ of
    alLeft: ComboBox1.ItemIndex:= 2;
    alCenter: ComboBox1.ItemIndex:= 0;
    alRight: ComboBox1.ItemIndex:= 1;
  end;
  TlzRichEdit(RichControl).Refresh;
  TlzRichEdit(RichControl).SelStart:= SStart;
  TlzRichEdit(RichControl).SelLength:= SLen;
end;

end.
