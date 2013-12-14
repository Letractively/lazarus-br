unit dm_EasyQuery;

{$mode objfpc}{$H+}

interface

uses
  Classes, ZConnection, ZDataset, DB, ZSqlUpdate;

type

  { TdmEasyQuery }

  TdmEasyQuery = class(TDataModule)
    conEmployee: TZConnection;
    dsCountry: TDatasource;
    dsCustomer: TDatasource;
    qryCustomer: TZQuery;
    qryCustomerADDRESS_LINE1: TStringField;
    qryCustomerADDRESS_LINE2: TStringField;
    qryCustomerCITY: TStringField;
    qryCustomerCONTACT_FIRST: TStringField;
    qryCustomerCONTACT_LAST: TStringField;
    qryCustomerCOUNTRY: TStringField;
    qryCustomerCUSTOMER: TStringField;
    qryCustomerCUST_NO: TLongintField;
    qryCustomerON_HOLD: TStringField;
    qryCustomerPHONE_NO: TStringField;
    qryCustomerPOSTAL_CODE: TStringField;
    qryCustomerSTATE_PROVINCE: TStringField;
    roqryCountry: TZReadOnlyQuery;
    roqryCountryCOUNTRY: TStringField;
    updCustomer: TZUpdateSQL;
    procedure qryCustomerAfterPost(DataSet: TDataSet);
  end;

var
  dmEasyQuery: TdmEasyQuery;

implementation

{$R *.lfm}

{ TdmEasyQuery }

procedure TdmEasyQuery.qryCustomerAfterPost(DataSet: TDataSet);
begin
  // to sort the shown customers after an update or creation of
  // a record again:
  qryCustomer.Refresh;
end;

end.

