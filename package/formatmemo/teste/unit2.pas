unit Unit2; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ColorBox, FMemo, FMemo_Type, LCLProc;

type

  { TFormatar }

  TFormatar = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ColorBox1: TColorBox;
    ColorBox2: TColorBox;
    FMemo1: TFMemo;
    FDialog: TFontDialog;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    RadioButton1: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton12: TRadioButton;
    RadioButton13: TRadioButton;
    RadioButton14: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ColorBox1Select(Sender: TObject);
    procedure ColorBox2Select(Sender: TObject);
    procedure RadioButton12Change(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton6Change(Sender: TObject);
    function Execute:Boolean;
  private
    { private declarations }
  protected
    FOk:Boolean;
    FFontDesc: TFontDesc;
    procedure SetFontDesc(SFontDesc: TFontDesc);
  public
    { public declarations }
    property FontDesc:TFontDesc read FFontDesc write SetFontDesc;
  end;

var
  Formatar: TFormatar;
implementation

{$R *.lfm}

{ TFormatar }

procedure TFormatar.Button1Click(Sender: TObject);
const
  FStyle:array [Boolean] of TFontPStyle = (fpNormal, fpItalic);
begin
  if FDialog.Execute then
    begin
      FFontDesc.Name:=  FDialog.Font.Name;
      FFontDesc.Size:=  FDialog.Font.Size;
      FFontDesc.Strikethrough:= (fsStrikeOut in FDialog.Font.Style);
      FFontDesc.Style:= FStyle[fsItalic in FDialog.Font.Style];
      if (fsBold in FDialog.Font.Style) then
        begin
          RadioButton9.Checked:=True;
        end;
      FMemo1.SetFormat(FFontDesc, 0, UTF8Length(FMemo1.Text));
      Button1.Caption:= UTF8Copy(FDialog.Font.Name, 1, 10);
    end;
end;

procedure TFormatar.Button2Click(Sender: TObject);
begin
  FOk:=True;
  Close;
end;

procedure TFormatar.Button3Click(Sender: TObject);
begin
  FOk:=False;
  Close;
end;

procedure TFormatar.ColorBox1Select(Sender: TObject);
var
  Pix:TPixmap;
begin
  Pix:=TPixmap.Create;
  Pix.Height:=2;
  Pix.Width:=2;
  Pix.Canvas.Brush.Color:=ColorBox1.Selected;
  Pix.Canvas.Clear;
  Pix.Canvas.Clear;

  //--
  FFontDesc.FontColor:=Pix.Canvas.Pixels[1, 1];
  Pix.Free;

  //--
  FMemo1.SetFormat(FFontDesc, 0, UTF8Length(FMemo1.Text));
end;

procedure TFormatar.ColorBox2Select(Sender: TObject);
var
  Pix:TPixmap;
begin
  Pix:=TPixmap.Create;
  Pix.Height:=2;
  Pix.Width:=2;
  Pix.Canvas.Brush.Color:=ColorBox2.Selected;
  Pix.Canvas.Clear;
  Pix.Canvas.Clear;
  //--
  FFontDesc.BackColor:=Pix.Canvas.Pixels[1, 1];
  Pix.Free;
  //--
  FMemo1.SetFormat(FFontDesc, 0, UTF8Length(FMemo1.Text));

end;

procedure TFormatar.RadioButton12Change(Sender: TObject);
begin
  case TRadioButton(Sender).Tag of
    0: FFontDesc.Justify:= fjLeft;
    1: FFontDesc.Justify:= fjCenter;
    2: FFontDesc.Justify:= fjRight;
  end;

  FMemo1.SetFormat(FFontDesc, 0, UTF8Length(FMemo1.Text));
end;

procedure TFormatar.RadioButton1Change(Sender: TObject);
begin
  case TRadioButton(Sender).Tag of
    0: FFontDesc.Underline:= fuNone;
    1: FFontDesc.Underline:= fuSingle;
    2: FFontDesc.Underline:= fuDouble;
    3: FFontDesc.Underline:= fuLow;
    4: FFontDesc.Underline:= fuError;
  end;

  FMemo1.SetFormat(FFontDesc, 0, UTF8Length(FMemo1.Text));
end;

procedure TFormatar.RadioButton6Change(Sender: TObject);
begin
  case TRadioButton(Sender).Tag of
    0: FFontDesc.Weight:= fwUltralight;
    1: FFontDesc.Weight:= fwLight;
    2: FFontDesc.Weight:= fwNormal;
    3: FFontDesc.Weight:= fwBold;
    4: FFontDesc.Weight:= fwUtrabold;
    5: FFontDesc.Weight:= fwHeavy;
  end;

  FMemo1.SetFormat(FFontDesc, 0, UTF8Length(FMemo1.Text));
end;

function TFormatar.Execute: Boolean;
begin
  FOk:=False;
  ShowModal;
  Result:=FOk;
end;

procedure TFormatar.SetFontDesc(SFontDesc: TFontDesc);
begin
  FFontDesc.Name:=SFontDesc.Name;
  FFontDesc.Size:=SFontDesc.Size;
  FFontDesc.FontColor:=SFontDesc.FontColor;
  FFontDesc.BackColor:=SFontDesc.BackColor;
  FFontDesc.Strikethrough:=SFontDesc.Strikethrough;
  FFontDesc.Underline:=SFontDesc.Underline;
  FFontDesc.Weight:=SFontDesc.Weight;
  FFontDesc.Justify:=SFontDesc.Justify;
  FFontDesc.Style:=SFontDesc.Style;

  if (UTF8Length(FMemo1.Text)<=1) then FMemo1.Text:='GTK+ library';
  FMemo1.SetFormat(FFontDesc, 0, UTF8Length(FMemo1.Text));

  //--
  FDialog.Font.Style:=[];
  //--
  FDialog.Font.Name:= FontDesc.Name;
  FDialog.Font.Size:= FontDesc.Size;
  if (FontDesc.Strikethrough) then  FDialog.Font.Style:= FDialog.Font.Style + [fsStrikeOut];
  if (FontDesc.Style <> fpNormal) then FDialog.Font.Style:= FDialog.Font.Style + [fsItalic];
  //--
    case FontDesc.Weight of
     fwUltralight: RadioButton6.Checked:=True;
     fwLight     : RadioButton7.Checked:=True;
     fwNormal    : RadioButton8.Checked:=True;
     fwBold      : RadioButton9.Checked:=True;
     fwUtrabold  : RadioButton10.Checked:=True;
     fwHeavy     : RadioButton11.Checked:=True;
  end;

  //--
   case FontDesc.Underline of
    fuNone        :RadioButton1.Checked:=True;
    fuSingle      :RadioButton2.Checked:=True;
    fuDouble      :RadioButton3.Checked:=True;
    fuLow         :RadioButton4.Checked:=True;
    fuError       :RadioButton5.Checked:=True;
  end;

   case FontDesc.Justify of
    fjLeft        :RadioButton12.Checked:=True;
    fjCenter      :RadioButton13.Checked:=True;
    fjRight       :RadioButton14.Checked:=True;
  end;

  //--
  ColorBox2.Selected:=FontDesc.BackColor;
  //--
  ColorBox1.Selected:=FontDesc.FontColor;
  //--
  ColorBox1Select(nil);
  ColorBox2Select(nil);
  Button1.Caption:= UTF8Copy(FontDesc.Name, 1, 10);
  //--
  FMemo1.SetFormat(FFontDesc, 0, UTF8Length(FMemo1.Text));
end;

end.

