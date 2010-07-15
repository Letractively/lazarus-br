unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, FMemo, FMemo_Type, Unit2, Unit3;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    FMemo1: TFMemo;
    ODialog: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  sFontDesc: TFontDesc;
begin

  FMemo1.GetFormat(sFontDesc);
  Formatar.FontDesc:=sFontDesc;
  if Formatar.Execute then
    begin
      sFontDesc:=Formatar.FontDesc;
      FMemo1.SetFormat(sFontDesc);
    end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  FontDesc: TFontDesc;
begin
  if FMemo1.GetFormat(FontDesc) then
    begin
      FMemo1.Append(FontDesc.Name);
      FMemo1.Append(IntToStr(FontDesc.Size));
      FMemo1.Append(IntToStr(FontDesc.FontColor));
      FMemo1.Append(IntToStr(FontDesc.BackColor));
      FMemo1.Append(IntToStr(Integer(FontDesc.Strikethrough)));
      FMemo1.Append(IntToStr(Integer(FontDesc.Underline)));
      FMemo1.Append(IntToStr(Integer(FontDesc.Weight)));
      FMemo1.Append(IntToStr(Integer(FontDesc.Justify)));
      FMemo1.Append(IntToStr(Integer(FontDesc.Style)));
    end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Pic:TPicture;
begin
  Pic:=TPicture.Create;
  if ODialog.Execute then
    begin
      Pic.LoadFromFile(ODialog.FileName);
      FMemo1.InsertImage(FMemo1.SelStart, Pic, 0, 0);
    end;
  Pic.Free;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  Pic:TPicture;
begin
  Pic:=TPicture.Create;

  if FMemo1.GetImage(Pic) then
    begin
      Form2.Image1.Picture.Assign(Pic);
      Form2.Show;
    end;
  Pic.Free;
end;

end.

