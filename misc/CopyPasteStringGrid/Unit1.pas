unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Grids, LCLType, LCLProc ;

type

  { TForm1 }

  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
  private
    FSelectedTextOrig,FSelectedTextDest: TStrings;
    FOrig,FDest: TGridRect;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.StringGrid1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var

  I, VCol, VRow: Integer;
begin
  if ssCtrl in Shift then begin
    if Key = VK_C then  begin
      FSelectedTextOrig.Clear;
      FOrig := StringGrid1.Selection;
      I:=0;
     // WriteLn('Origem Left: ',SOrig.Left, '   Right: ',SOrig.Right);
      for VRow := FOrig.Top to FOrig.Bottom do
        for VCol := FOrig.Left to FOrig.Right do   begin
          FSelectedTextOrig.Add(StringGrid1.Cells[VCol, VRow]); //Importante no caso de "cut"
          Inc(I);
          //StringGrid1.Cells[VCol, VRow] := ''; //Caso queira opção "Cut", descomente esta linha.
        end;
    end;
    if Key = VK_V then  begin
      I := 0;
      FDest := StringGrid1.Selection;
      FSelectedTextDest.Clear;
     // WriteLn('Destino  Left: ',SDest.Left, '   Right: ',SDest.Right);
     // WriteLn('Origem   Left: ',SOrig.Left, '   Right: ',SOrig.Right ,'  ',SOrig.Left-Sorig.Right);
      for VRow := FDest.Top to FDest.Top + Abs(FOrig.Top - FOrig.Bottom) do
        for VCol := FDest.Left to FDest.Left + Abs(FOrig.Left - FOrig.Right)do  begin
          FSelectedTextDest.Add(StringGrid1.Cells[VCol, VRow]);
          StringGrid1.Cells[VCol, VRow] := FSelectedTextDest[I];
          Inc(I);
        end;
    end;
    if Key = VK_Z then  begin
      I := 0;
      if FSelectedTextDest.Count>0 then
        for VRow := FDest.Top to FDest.Top + Abs(FOrig.Top - FOrig.Bottom) do
          for VCol := FDest.Left to FDest.Left + Abs(FOrig.Left - FOrig.Right)do  begin
            StringGrid1.Cells[VCol, VRow] := FSelectedTextDest[I];
            Inc(I);
          end;
      FSelectedTextDest.Free;
      I:=0;
      if FSelectedTextOrig.Count>0 then
        for VRow := FOrig.Top to FOrig.Bottom do
          for VCol := FOrig.Left to FOrig.Right do   begin
            StringGrid1.Cells[VCol, VRow] := FSelectedTextOrig[I];
            Inc(I);
          end;
      FSelectedTextOrig.Free;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FSelectedTextOrig  := TStringList.Create;
  FSelectedTextDest  := TStringList.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FSelectedTextOrig.Free;
  FSelectedTextDest.Free;
end;

end.

