(*
  Cheques 2.1, Controle pessoal de cheques.
  Copyright (C) 2010-2012 Everaldo - arcanjoebc@gmail.com

  See the file LGPL.2.1_modified.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

(*
  Powerfull contributors:
  Silvio Clecio - http://blog.silvioprog.com.br
  Joao Morais   - http://blog.joaomorais.com.br
  Luiz Americo  - http://lazarusroad.blogspot.com
*)

unit ChequeClasses;

{$I cheques.inc}

interface

uses
  DB, SysUtils, Classes, LCLIntf, ChequeConsts, ChequeExceptionHandle,
  ReportTemplate;

type

  { TCurrentProtocol }

  TCurrentProtocol = (cpPostgreSQL, cpSQLite, cpFirebird, cpUnknow);

  { TDataObject }

  TDataObject = class
  private
    FFieldName: string;
    FFieldType: TFieldType;
    FFKKey: string;
    FFKSearchField: string;
    FFKTable: string;
    FValue: Variant;
  public
    constructor Create;
    property FieldName: string read FFieldName write FFieldName;
    property Value: Variant read FValue write FValue;
    property FieldType: TFieldType read FFieldType write FFieldType default ftString;
    property FKTable: string read FFKTable write FFKTable;
    property FKSearchField: string read FFKSearchField write FFKSearchField;
    property FKKey: string read FFKKey write FFKKey;
  end;

  { TReportDataObject }

  TReportDataObject = class
  private
    FBrowserTitle: string;
    FColumns: string;
    FDataSet: TDataSet;
    FFields: string;
    FOpenInBrowser: Boolean;
    FReportTitle: string;
    FStriped: Boolean;
    FTemplate: string;
    FZoom: Integer;
    class function DeleteTempFile: Boolean;
  public
    constructor Create;
    procedure Execute;
    property DataSet: TDataSet read FDataSet write FDataSet;
    property BrowserTitle: string read FBrowserTitle write FBrowserTitle;
    property ReportTitle: string read FReportTitle write FReportTitle;
    property Template: string read FTemplate write FTemplate;
    property Striped: Boolean read FStriped write FStriped;
    property OpenInBrowser: Boolean
      read FOpenInBrowser write FOpenInBrowser default False;
    property Zoom: Integer read FZoom write FZoom;
    property Columns: string read FColumns write FColumns;
    property Fields: string read FFields write FFields;
  end;

implementation

var
  _HTMLTemp: string = '';

{ TDataObject }

constructor TDataObject.Create;
begin
  FFieldName := '';
  FFieldType := ftUnknown;
  FFKTable := '';
  FKSearchField := '';
  FFKKey := '';
end;

{ TReportDataObject }

class function TReportDataObject.DeleteTempFile: Boolean;
begin
  Result := DeleteFile(_HTMLTemp);
end;

constructor TReportDataObject.Create;
begin
  inherited Create;
  FStriped := True;
  FOpenInBrowser := False;
  FZoom := 0;
end;

procedure TReportDataObject.Execute;

  function _ExtractString(Content: string; Strings: TStrings): Integer;
  begin
    Result := ExtractStrings([';', ','], [' '], PChar(Content), Strings);
  end;

  procedure _ErrorMsg(const AMsg: string);
  begin
    TChequeExceptionHandle.ShowErrorMsg(AMsg, False, edtError);
  end;

var
  I, J, VOldRecNo: Integer;
  VFileStream: TFileStream;
  VReportTemplate: TReportTemplate;
  VColumns, VFields: TStringList;
  VFieldType: TFieldType;
  VField: TField;
  VFieldResult: string;
begin
  VReportTemplate := TReportTemplate.Create;
  VColumns := TStringList.Create;
  VFields := TStringList.Create;
  _ExtractString(FColumns, VColumns);
  _ExtractString(FFields, VFields);
  if VColumns.Count < 1 then
    _ErrorMsg('Quantidade de colunas inferior a 1.');
  if VFields.Count < 1 then
    _ErrorMsg('Quantidade de campos inferior a 1.');
  if VColumns.Count <> VFields.Count then
    _ErrorMsg('Quantidade de colunas diferente da quantidade de campos.');
  VReportTemplate.BrowserTitle := FBrowserTitle;
  VReportTemplate.ReportTitle := FReportTitle;
  VReportTemplate.Zoom := FZoom;
  try
    for I := 0 to Pred(VColumns.Count) do
      VReportTemplate.AddReportTableHeaderCell(VColumns.Strings[I]);
    VOldRecNo := FDataSet.RecNo;
    FDataSet.DisableControls;
    FDataSet.First;
    for I := 0 to Pred(FDataSet.RecordCount) do
    begin
      VReportTemplate.AddReportEvenBeginCells;
      for J := 0 to Pred(VColumns.Count) do
      begin
        VFieldType := FDataSet.FieldByName(VFields.Strings[J]).DataType;
        VField := FDataSet.FieldByName(VFields.Strings[J]);
        VFieldResult := VField.DisplayText;
        case VFieldType of
          ftBoolean:
            if VField.AsBoolean then
              VFieldResult := CSim
            else
              VFieldResult := CNao;
        end;
        VReportTemplate.AddReportEvenValueCells(VFieldResult);
      end;
      VReportTemplate.AddReportEvenEndCells;
      FDataSet.Next;
    end;
    FTemplate := VReportTemplate.Template;
  finally
    FDataSet.RecNo := VOldRecNo;
    FDataSet.EnableControls;
    VColumns.Free;
    VFields.Free;
    VReportTemplate.Free;
  end;
  if FOpenInBrowser then
  begin
    VFileStream := TFileStream.Create(_HTMLTemp, fmCreate);
    try
      VFileStream.Write(Pointer(FTemplate)^, Length(FTemplate));
      OpenURL(_HTMLTemp);
    finally
      VFileStream.Free;
    end;
  end;
end;

initialization
  TReportDataObject.DeleteTempFile;
{$ifdef unix}
  _HTMLTemp := '/tmp/' + CHTMLTempFileName;
{$else}
  _HTMLTemp := ExtractFilePath(ParamStr(0)) + CHTMLTempFileName;
{$endif}

finalization
  TReportDataObject.DeleteTempFile;

end.

