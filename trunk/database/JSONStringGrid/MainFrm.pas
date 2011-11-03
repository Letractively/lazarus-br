unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, StdCtrls, Grids, FPJSON, JSONParser;

type

  { TMainForm }

  TMainForm = class(TForm)
    OpenButton: TButton;
    DataStringGrid: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
  private
    procedure ClearGrid(const AFixedCols: Integer = 1;
      const AFixedRows: Integer = 1);
    procedure LoadJSON(var AGrid: TCustomStringGrid; const AFileName: TFileName;
      const AShowValidationMessages: Boolean = True;
      const AFixedCols: Integer = 1; const AFixedRows: Integer = 1;
      const AAutoSizeColumns: Boolean = True);
  end;

resourcestring
  SJSONEmptyDatabase = 'Empty database.';
  SJSONEmptyArray = 'Empty array.';
  SJSONEmptyObject = 'Empty object.';
  SJSONIsntArray = 'Expecting a "TJSONArray" got "%s".';

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ClearGrid;
  DataStringGrid.Options := DataStringGrid.Options + [goColSizing];
end;

procedure TMainForm.OpenButtonClick(Sender: TObject);
begin
  with TOpenDialog.Create(nil) do
    try
      Filter := 'JSON files (*.json)|*.json|All files (*.*)|*.*';
      if Execute then
        LoadJSON(DataStringGrid, FileName);
    finally
      Free;
    end;
end;

procedure TMainForm.ClearGrid(const AFixedCols: Integer;
  const AFixedRows: Integer);
var
  VOldFixedCols, VOldFixedRows: Integer;
begin
  VOldFixedCols := DataStringGrid.FixedCols;
  VOldFixedRows := DataStringGrid.FixedRows;
  DataStringGrid.ColCount := VOldFixedCols + AFixedCols;
  DataStringGrid.RowCount := VOldFixedRows + AFixedRows;
  DataStringGrid.FixedCols := AFixedCols;
  DataStringGrid.FixedRows := AFixedRows;
  DataStringGrid.ColWidths[0] := 12;
  DataStringGrid.Clean;
end;

procedure TMainForm.LoadJSON(var AGrid: TCustomStringGrid;
  const AFileName: TFileName; const AShowValidationMessages: Boolean;
  const AFixedCols: Integer; const AFixedRows: Integer;
  const AAutoSizeColumns: Boolean);
var
  VIsObject: Boolean;
  VJSONCols: TJSONObject;
  VJSONParser: TJSONParser;
  VFileStream: TFileStream;
  VJSONRows, VRecord: TJSONData;
  I, J, VFixedCols, VFixedRows: Integer;
begin
  VFileStream := TFileStream.Create(AFileName, fmOpenRead);
  VJSONParser := TJSONParser.Create(VFileStream);
  try
    ClearGrid(AFixedCols, AFixedRows);
    VJSONRows := VJSONParser.Parse;
    if not Assigned(VJSONRows) then
    begin
      if AShowValidationMessages then
        ShowMessage(SJSONEmptyDatabase);
      Exit;
    end;
    if VJSONRows.JSONType <> jtArray then
    begin
      if AShowValidationMessages then
        ShowMessageFmt(SJSONIsntArray, [VJSONRows.ClassName]);
      Exit;
    end;
    if VJSONRows.Count < 1 then
    begin
      if AShowValidationMessages then
        ShowMessage(SJSONEmptyArray);
      Exit;
    end;
    VJSONCols := TJSONObject(VJSONRows.Items[0]);
    VIsObject := VJSONCols.JSONType = jtObject;
    if VIsObject and (VJSONCols.Count < 1) then
    begin
      if AShowValidationMessages then
        ShowMessage(SJSONEmptyObject);
      Exit;
    end;
    VFixedCols := AGrid.FixedCols;
    VFixedRows := AGrid.FixedRows;
    AGrid.ColCount := VFixedCols + VJSONCols.Count;
    AGrid.RowCount := VFixedRows + VJSONRows.Count;
    for I := 0 to Pred(VJSONRows.Count) do
    begin
      VJSONCols := TJSONObject(VJSONRows.Items[I]);
      for J := 0 to Pred(VJSONCols.Count) do
      begin
        if (I = 0) and VIsObject then
          AGrid.Cols[VFixedCols + J].Text := VJSONCols.Names[J];
        VRecord := VJSONCols.Items[J];
        case VRecord.JSONType of
          jtUnknown: AGrid.Cells[J + VFixedCols, I + VFixedRows] := '<Unknown>';
          jtNumber: AGrid.Cells[J + VFixedCols, I + VFixedRows] :=
            FloatToStr(VRecord.AsFloat);
          jtString: AGrid.Cells[J + VFixedCols, I + VFixedRows] :=
            VRecord.AsString;
          jtBoolean: AGrid.Cells[J + VFixedCols, I + VFixedRows] :=
            BoolToStr(VRecord.AsBoolean, True);
          jtNull: AGrid.Cells[J + VFixedCols, I + VFixedRows] := '<Null>';
          jtArray: AGrid.Cells[J + VFixedCols, I + VFixedRows] := '<Array>';
          jtObject: AGrid.Cells[J + VFixedCols, I + VFixedRows] := '<Object>';
        end;
      end;
    end;
    if AAutoSizeColumns then
      for I := 1 to Pred(AGrid.ColCount) do
        AGrid.AutoSizeColumn(I);
  finally
    VJSONRows.Free;
    VJSONParser.Free;
    VFileStream.Free;
  end;
end;

end.

