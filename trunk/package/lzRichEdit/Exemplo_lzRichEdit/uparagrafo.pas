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
var
  Align_: TRichEdit_Align;
begin
  if Edit1.Text = '' then Edit1.Text:='0';
  if Edit2.Text = '' then Edit2.Text:='0';
  if Edit3.Text = '' then Edit3.Text:='0';

  if ComboBox1.Text = '' then ComboBox1.ItemIndex:= 2;
  //--
  //TlzRichEdit(RichControl).SetLeftMargin(SStart, SLen, StrToInt(Edit1.Text));
  //TlzRichEdit(RichControl).SetRightMargin(SStart, SLen, StrToInt(Edit2.Text));
  //TlzRichEdit(RichControl).SetIndent(SStart, SLen, StrToInt(Edit3.Text));
  {$IFDEF Windows}
  TlzRichEdit(RichControl).Paragraph.LeftIndent:= StrToInt(Edit3.Text) + StrToInt(Edit1.Text);
  {$ENDIF}

  {$IFDEF Linux}
  TlzRichEdit(RichControl).Paragraph.LeftIndent:= StrToInt(Edit1.Text);
  {$ENDIF}

  TlzRichEdit(RichControl).Paragraph.RightIndent:= StrToInt(Edit2.Text);
  TlzRichEdit(RichControl).Paragraph.FirstIndent:= StrToInt(Edit3.Text);

  //--
  case ComboBox1.ItemIndex of
    2: Align_:= taLeft;
    1: Align_:= taRight;
    0: Align_:= taCenter;
  end;
  //TlzRichEdit(RichControl).SetAlignment(SStart, SLen, Align_);
  TlzRichEdit(RichControl).Paragraph.Alignment:= Align_;
  Close;
end;

procedure TfrmParagrafo.Button2Click(Sender: TObject);
begin
  Close;
end;


procedure TfrmParagrafo.Execute(aRichControl: TWinControl);
//var
  //Align_: TRichEdit_Align;
  //L, R, I:Integer;
begin
  RichControl:= aRichControl;
  Show;
  SStart:= TlzRichEdit(RichControl).SelStart;
  Slen:= TlzRichEdit(RichControl).SelLength;
  //Edit1.Text:= IntToStr(TlzRichEdit(RichControl).GetStartIndent);
  //Edit2.Text:= IntToStr(TlzRichEdit(RichControl).GetRightIndent);
  //TlzRichEdit(RichControl).GetLeftMargin(TlzRichEdit(RichControl).SelStart, L);
  //TlzRichEdit(RichControl).GetRightMargin(TlzRichEdit(RichControl).SelStart, R);
  //TlzRichEdit(RichControl).GetIndent(TlzRichEdit(RichControl).SelStart, I);
  //Edit1.Text:= IntToStr(L);
  //Edit2.Text:= IntToStr(R);
  //Edit3.Text:= IntToStr(I);
  {$IFDEF WINDOWS}
  Edit1.Text:= IntToStr(TlzRichEdit(RichControl).Paragraph.LeftIndent -
                        TlzRichEdit(RichControl).Paragraph.FirstIndent);
  {$ENDIF}
  {$IFDEF Linux}
  Edit1.Text:= IntToStr(TlzRichEdit(RichControl).Paragraph.LeftIndent);
  {$ENDIF}

  Edit2.Text:= IntToStr(TlzRichEdit(RichControl).Paragraph.RightIndent);
  Edit3.Text:= IntToStr(TlzRichEdit(RichControl).Paragraph.FirstIndent);

  //TlzRichEdit(RichControl).GetAlignment(TlzRichEdit(RichControl).SelStart ,Align_);

  case TlzRichEdit(RichControl).Paragraph.Alignment of
    taLeft: ComboBox1.ItemIndex:= 2;
    taCenter: ComboBox1.ItemIndex:= 0;
    taRight: ComboBox1.ItemIndex:= 1;
  end;
  TlzRichEdit(RichControl).Refresh;
  TlzRichEdit(RichControl).SelStart:= SStart;
  TlzRichEdit(RichControl).SelLength:= SLen;
end;

end.
