unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Grids, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
  private
    FSelectedText: TStrings;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.StringGrid1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  VSelection: TGridRect;
  I, VCol, VRow: Integer;
begin
  if ssCtrl in Shift then
  begin
    if Key = VK_C then
    begin
      FSelectedText.Clear;
      VSelection := StringGrid1.Selection;
      for VRow := VSelection.Top to VSelection.Bottom do
        for VCol := VSelection.Left to VSelection.Right do
        begin
          FSelectedText.Add(StringGrid1.Cells[VCol, VRow]);
//            StringGrid1.Cells[VCol, VRow] := ''; Caso queira opção "Cut", descomente esta linha.
        end;
    end;
    if Key = VK_V then
    begin
      I := 0;
      VSelection := StringGrid1.Selection;
      for VRow := VSelection.Top to VSelection.Bottom do
        for VCol := VSelection.Left to VSelection.Right do
        begin
          StringGrid1.Cells[VCol, VRow] := FSelectedText[I];
          Inc(I);
        end;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FSelectedText := TStringList.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FSelectedText.Free;
end;

end.

