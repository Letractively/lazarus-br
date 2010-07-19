unit MainDM;

{$I pedido.inc}

interface

uses
  Classes, sqldb, pqconnection, Controls, SysUtils;

type

  { TMainDataModule }

  TMainDataModule = class(TDataModule)
    MainSQLTransaction: TSQLTransaction;
    MainPQConnection: TPQConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    FTransactionCount: Integer;
  public
    procedure CommitTransaction;
    procedure OpenTransaction;
    procedure RollbackTransaction;
  end;

  TEditOperation = (eoEdit, eoDelete);

  TFindRecordOperation = (opApproximate, opExact, opList);

  TListViewOperation = (opAdd, opEdit, opDelete);

  TProduto = class
    Oid: Integer;
    Descricao, Unidade: string;
    Preco: currency;
  end;

  TPedido = class
    Oid, NumeroPedido: Integer;
    Data: TDate;
    TotalGeral: currency;
  end;

  TPedidoProduto = class
    OidProduto, Quantidade: Integer;
    Descricao, Unidade: string;
    Preco, TotalProduto: currency;
  end;

var
  MainDataModule: TMainDataModule;

function CurrencyToDBStr(const ACurrency: currency): string;
function FormattedCurrencyToStr(const ACurrency: currency): string;
function DateToStrFrm(const ADate: TDate): string;
function SequenceNextValue(const ASequenceName: string = 'Seq_MainSequence'): Integer;
function FindRecords(const AShowFields, ATable, AField, ARecord: string;
  AFindRecordOperation: TFindRecordOperation; AOrderByRecord: Boolean = False): string;

implementation

{$R *.lfm}

function CurrencyToDBStr(const ACurrency: currency): string;
begin
  Result := StringReplace(CurrToStr(ACurrency), ',', '.', [rfReplaceAll]);
end;

function FormattedCurrencyToStr(const ACurrency: currency): string;
begin
  Result := FormatCurr(',0.00', ACurrency);
end;

function DateToStrFrm(const ADate: TDate): string;
begin
  Result := FormatDateTime('dd/mm/yyyy', ADate);
end;

function SequenceNextValue(const ASequenceName: string = 'Seq_MainSequence'): Integer;
var
  VQuery: TSQLQuery;
begin
  MainDataModule.OpenTransaction;
  try
    VQuery := TSQLQuery.Create(nil);
    try
      VQuery.DataBase := MainDataModule.MainPQConnection;
      VQuery.Transaction := MainDataModule.MainSQLTransaction;
      VQuery.SQL.Text := 'select nextval(' + QuotedStr(ASequenceName) + ');';
      VQuery.Open;
      Result := VQuery.FieldByName('nextval').AsInteger;
    finally
      VQuery.Free;
    end;
    MainDataModule.CommitTransaction;
  except
    MainDataModule.RollbackTransaction;
    raise;
  end;
end;

function FindRecords(const AShowFields, ATable, AField, ARecord: string;
  AFindRecordOperation: TFindRecordOperation; AOrderByRecord: Boolean = False): string;
const
  CSql = 'select %s from %s ';
  CSqlWhere = 'select %s from %s where %s ';
  CSqlOrderBy = ' order by Oid';
var
  S: string;
begin
  Result := EmptyStr;
  case AFindRecordOperation of
    opApproximate: S := Format(CSqlWhere, [AShowFields, ATable, AField]) +
        'like (' + QuotedStr(ARecord + '%') + ')';
    opExact: S := Format(CSqlWhere, [AShowFields, ATable, AField]) +
        ' = ' + QuotedStr(ARecord);
    opList: S := Format(CSql, [AShowFields, ATable]);
  end;
  if AOrderByRecord then
    S := S + CSqlOrderBy;
  Result := S;
end;

{ TMainDataModule }

procedure TMainDataModule.DataModuleCreate(Sender: TObject);
begin
  with MainPQConnection do
  begin
    DatabaseName := 'postgres';
    HostName := '127.0.0.1';
    Password := 'postgres';
    UserName := 'postgres';
    Params.Text := 'port=5432';
    Transaction := MainSQLTransaction;
    Open;
  end;
end;

procedure TMainDataModule.CommitTransaction;
begin
  if FTransactionCount > 1 then
    Dec(FTransactionCount)
  else
  if FTransactionCount = 1 then
  begin
    MainSQLTransaction.Commit;
    FTransactionCount := 0;
  end
  else
    raise Exception.Create('A transação não está aberta.');
end;

procedure TMainDataModule.OpenTransaction;
begin
  Inc(FTransactionCount);
  if FTransactionCount = 1 then
  begin
    if not MainPQConnection.Connected then
      MainPQConnection.Open;
    MainSQLTransaction.StartTransaction;
  end;
end;

procedure TMainDataModule.RollbackTransaction;
begin
  if FTransactionCount > 1 then
    Dec(FTransactionCount)
  else
  if FTransactionCount = 1 then
  begin
    MainSQLTransaction.Rollback;
    FTransactionCount := 0;
  end
  else
    raise Exception.Create('A transação não está aberta.');
end;

initialization
  ShortDateFormat := 'dd/MM/yyyy';
  CurrencyString := 'R$';
  CurrencyFormat := 0;
  NegCurrFormat := 14;
  ThousandSeparator := '.';
  DecimalSeparator := ',';
  CurrencyDecimals := 2;
  DateSeparator := '/';
  TimeSeparator := ':';
  TimeAMString := 'AM';
  TimePMString := 'PM';
  ShortTimeFormat := 'hh:mm:ss';

end.

