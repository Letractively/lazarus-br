unit BaseFrm;

{$I pedido.inc}

interface

uses
  SysUtils, Forms, Controls, StdCtrls, DB, sqldb, MainDM, LCLType;

type

  { TBaseForm }

  TBaseForm = class(TForm)
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
  protected
    procedure AssertData(AExpression: Boolean; const AMsg: string;
      AWinControl: TWinControl);
    procedure VerificaValor(var AEdit: TCustomEdit);
    procedure VerificaData(var AEdit: TCustomEdit);
    procedure InternalCheckData; virtual;
    procedure InternalPopulateData; virtual;
    procedure PopulateCurrency(AParam: TParam; const AValue: string);
    procedure PopulateDate(AParam: TParam; const AValue: string);
    procedure PopulateComboBox(ACombo: TComboBox; const ATableName,
      AOidFieldName, AStringFieldName: string);
    procedure FindReference(AParam: TParam; ACombo: TComboBox);
    function PopulatePK(AQueryParam: TParam;
      const ASequence: string = 'Seq_MainSequence'): Integer;
  public
    class procedure Execute;
  end;

implementation

{$R *.lfm}

{ TBaseForm }

procedure TBaseForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

procedure TBaseForm.FormShow(Sender: TObject);
var
  I, I2: Integer;
  VComboBox: TCustomComboBox;
begin
  for I := 0 to Pred(ComponentCount) do
  begin
    if (Components[I] is TCustomEdit) then
      TCustomEdit(Components[I]).CharCase := ecUpperCase;
    if (Components[I] is TCustomComboBox) then
    begin
      VComboBox := TCustomComboBox(Components[I]);
      VComboBox.CharCase := ecUpperCase;
      if Assigned(VComboBox) then
        for I2 := 0 to Pred(VComboBox.Items.Count) do
          VComboBox.Items[I2] := UpperCase(VComboBox.Items[I2]);
    end;
  end;
end;

procedure TBaseForm.FormUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
begin
  if UTF8Key = #27 then
    Close;
end;

procedure TBaseForm.AssertData(AExpression: Boolean; const AMsg: string;
  AWinControl: TWinControl);
begin
  if not AExpression then
  begin
    AWinControl.SetFocus;
    raise Exception.Create(AMsg);
  end;
end;

procedure TBaseForm.VerificaValor(var AEdit: TCustomEdit);
begin
  if AEdit.Text <> EmptyStr then
    AEdit.Text := FormattedCurrencyToStr(StrToCurr(AEdit.Text));
end;

procedure TBaseForm.VerificaData(var AEdit: TCustomEdit);
begin
  try
    if AEdit.Text <> EmptyStr then
      AEdit.Text := FormatDateTime('dd/mm/yyyy', StrToDate(AEdit.Text));
  except
    AEdit.SetFocus;
    raise;
  end;
end;

procedure TBaseForm.InternalCheckData;
begin
end;

procedure TBaseForm.InternalPopulateData;
begin
end;

procedure TBaseForm.PopulateCurrency(AParam: TParam; const AValue: string);
begin
  if AValue <> EmptyStr then
    AParam.AsCurrency := StrToCurr(AValue)
  else
    AParam.Value := Null;
end;

procedure TBaseForm.PopulateDate(AParam: TParam; const AValue: string);
begin
  if AValue <> EmptyStr then
    AParam.AsDate := StrToDate(AValue)
  else
    AParam.Value := Null;
end;

procedure TBaseForm.PopulateComboBox(ACombo: TComboBox; const ATableName,
  AOidFieldName, AStringFieldName: string);
var
  VQuery: TSQLQuery;
begin
  ACombo.Items.Clear;
  MainDataModule.OpenTransaction;
  try
    VQuery := TSQLQuery.Create(nil);
    try
      VQuery.DataBase := MainDataModule.MainPQConnection;
      VQuery.Transaction := MainDataModule.MainSQLTransaction;
      VQuery.SQL.Text := Format('select %s, %s from %s',
       [AOidFieldName, AStringFieldName, ATableName]);
      VQuery.Open;
      while not VQuery.Eof do
      begin
        { TODO : Criar um objeto que aponte para o ID
          ao invés de usar cast forçado }
        ACombo.Items.AddObject(VQuery.FieldByName(
          AStringFieldName).AsString,
        TObject(VQuery.FieldByName(AOidFieldName).AsInteger));
        VQuery.Next;
      end;
    finally
      VQuery.Free;
    end;
    MainDataModule.CommitTransaction;
  except
    MainDataModule.RollbackTransaction;
    raise;
  end;
end;

procedure TBaseForm.FindReference(AParam: TParam; ACombo: TComboBox);
begin
  if ACombo.ItemIndex >= 0 then
    AParam.AsInteger := Integer(ACombo.Items.Objects[ACombo.ItemIndex])
  else
    AParam.Value := Null;
end;

function TBaseForm.PopulatePK(AQueryParam: TParam;
  const ASequence: string = 'Seq_MainSequence'): Integer;
begin
  Result := SequenceNextValue(ASequence);
  AQueryParam.AsInteger := Result;
end;

class procedure TBaseForm.Execute;
begin
  Create(nil).ShowModal;
end;

end.
