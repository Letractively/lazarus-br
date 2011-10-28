unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, Dialogs, Spin, StdCtrls, Grids, FPJSON;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ClassCountEdit: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LevelCountEdit: TSpinEdit;
    LevelIncrementEdit: TFloatSpinEdit;
    InitialValueEdit: TFloatSpinEdit;
    ClassIncrementEdit: TFloatSpinEdit;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
  private
    procedure ClearGrid;
    procedure LoadJSON(AGrid: TCustomStringGrid; AData: TJSONData);
  end;

var
  Form1: TForm1;

implementation

uses
  StrUtils;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  ClassArray, LevelArray: TJSONArray;
  InitialValue, LevelInc, ClassInc, CurValue: double;
  LevelCount, ClassCount, I, J: integer;
begin
  ClassArray := TJSONArray.Create;
  InitialValue := InitialValueEdit.Value;
  LevelInc := LevelIncrementEdit.Value;
  ClassInc := ClassIncrementEdit.Value;
  LevelCount := LevelCountEdit.Value;
  ClassCount := ClassCountEdit.Value;
  LevelArray := TJSONArray.Create;
  LevelArray.Add('');
  for J := 1 to LevelCount do
    LevelArray.Add('Nível ' + IntToStr(J));
  ClassArray.Add(LevelArray);
  for I := 1 to ClassCount do
  begin
    CurValue := InitialValue;
    LevelArray := TJSONArray.Create;
    LevelArray.Add('Classe ' + IntToRoman(I));
    for J := 1 to LevelCount do
    begin
      LevelArray.Add(FormatFloat('#,##0', CurValue));
      CurValue := CurValue * LevelInc;
    end;
    ClassArray.Add(LevelArray);
    InitialValue := InitialValue * ClassInc;
  end;
  LoadJSON(StringGrid1, ClassArray);
  ClassArray.Destroy;
end;

procedure TForm1.LoadJSON(AGrid: TCustomStringGrid; AData: TJSONData);
var
  I, J: integer;
  VIsObject: boolean;
  VJSONCols: TJSONObject;
  VJSONRows, VRecord: TJSONData;
begin
  VJSONRows := AData;
  if not Assigned(VJSONRows) then
  begin
    ShowMessage('Empty database.');
    Exit;
  end;
  if VJSONRows.JSONType <> jtArray then
  begin
    ShowMessageFmt('Expecting a "TJSONArray" got "%s".',
      [VJSONRows.ClassName]);
    Exit;
  end;
  if VJSONRows.Count < 1 then
  begin
    ShowMessage('Empty array.');
    Exit;
  end;
  VJSONCols := TJSONObject(VJSONRows.Items[0]);
  VIsObject := VJSONCols.JSONType = jtObject;
  if VIsObject and (VJSONCols.Count < 1) then
  begin
    ShowMessage('Empty object.');
    Exit;
  end;
  ClearGrid;
  AGrid.ColCount := AGrid.FixedCols + VJSONCols.Count;
  AGrid.RowCount := AGrid.FixedRows + VJSONRows.Count;
  for I := 0 to Pred(VJSONRows.Count) do
  begin
    VJSONCols := TJSONObject(VJSONRows.Items[I]);
    for J := 0 to Pred(VJSONCols.Count) do
    begin
      if (I = 0) and VIsObject then
        AGrid.Cols[AGrid.FixedCols + J].Text := VJSONCols.Names[J];
      VRecord := VJSONCols.Items[J];
      if VRecord.JSONType <> jtNull then
        AGrid.Cells[J + AGrid.FixedCols, I + AGrid.FixedRows] :=
          VRecord.AsString;
    end;
  end;
end;

procedure TForm1.ClearGrid;
var
  VOldFixedCols, VOldFixedRows: integer;
begin
  VOldFixedCols := StringGrid1.FixedCols;
  VOldFixedRows := StringGrid1.FixedRows;
  StringGrid1.RowCount := VOldFixedRows + 1;
  StringGrid1.ColCount := VOldFixedCols + 1;
  StringGrid1.ColWidths[0] := 12;
  StringGrid1.Clean;
end;

end.

