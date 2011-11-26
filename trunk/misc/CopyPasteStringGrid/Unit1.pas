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
    if (Key = VK_C) or (Key = VK_X) then  begin
      FSelectedTextOrig.Clear;
      FOrig := StringGrid1.Selection;
      I:=0;
      for VRow := FOrig.Top to FOrig.Bottom do
        for VCol := FOrig.Left to FOrig.Right do   begin
          FSelectedTextOrig.Add(StringGrid1.Cells[VCol, VRow]); //Importante no caso de "cut"
          Inc(I);
          if Key = VK_X then
             StringGrid1.Cells[VCol, VRow] := '';
        end;
    end;
    if Key = VK_V then  begin
      I := 0;
      FDest := StringGrid1.Selection;
      FSelectedTextDest.Clear;
      for VRow := FDest.Top to FDest.Top + Abs(FOrig.Top - FOrig.Bottom) do
        for VCol := FDest.Left to FDest.Left + Abs(FOrig.Left - FOrig.Right)do  begin
          FSelectedTextDest.Add(StringGrid1.Cells[VCol, VRow]);
          StringGrid1.Cells[VCol, VRow] := FSelectedTextOrig[I];
          Inc(I);
        end;
    end;
    if Key = VK_Z then  begin
      I := 0;
      if FSelectedTextDest.Count>0 then  begin
        for VRow := FDest.Top to FDest.Top + Abs(FOrig.Top - FOrig.Bottom) do
          for VCol := FDest.Left to FDest.Left + Abs(FOrig.Left - FOrig.Right)do  begin
            StringGrid1.Cells[VCol, VRow] := FSelectedTextDest[I];
            Inc(I);
          end;
        FSelectedTextDest.Clear;
      end;
      I:=0;
      if FSelectedTextOrig.Count>0 then begin
        for VRow := FOrig.Top to FOrig.Bottom do
          for VCol := FOrig.Left to FOrig.Right do   begin
            StringGrid1.Cells[VCol, VRow] := FSelectedTextOrig[I];
            Inc(I);
          end;
      end;
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

