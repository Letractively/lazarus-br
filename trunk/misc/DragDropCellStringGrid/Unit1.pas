unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Controls, Grids;

type

  { TForm1 }

  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure StringGrid1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  end;

var
  Form1: TForm1;
  SourceCol, SourceRow: Integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  StringGrid1.DragMode := dmManual;
end;

procedure TForm1.StringGrid1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  VDestCol, VDestRow: Integer;
begin
  StringGrid1.MouseToCell(X, Y, VDestCol, VDestRow);
  StringGrid1.Cells[VDestCol, VDestRow] := StringGrid1.Cells[SourceCol, SourceRow];
  if (SourceCol <> VDestCol) or (SourceRow <> VDestRow) then
    StringGrid1.Cells[SourceCol, SourceRow] := '';
end;

procedure TForm1.StringGrid1DragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  VCurrentCol, VCurrentRow: Integer;
begin
  StringGrid1.MouseToCell(X, Y, VCurrentCol, VCurrentRow);
  Accept := (Sender = Source) and (VCurrentCol > 0) and (VCurrentRow > 0);
end;

procedure TForm1.StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  StringGrid1.MouseToCell(X, Y, SourceCol, SourceRow);
  if (SourceCol > 0) and (SourceRow > 0) then
    StringGrid1.BeginDrag(False, 4);
end;

end.

