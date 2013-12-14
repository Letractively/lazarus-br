unit dm_MasterDetail;

{$mode objfpc}{$H+}

interface

uses
  Classes, ZConnection, ZDataset, DB, ZSqlUpdate;

type

  { TdmMasterDetail }

  TdmMasterDetail = class(TDataModule)
    conDBDemos: TZConnection;
    dsCustomerQuery: TDatasource;
    dsCustomerTable: TDatasource;
    dsOrdersQuery: TDatasource;
    dsOrdersTable: TDatasource;
    qryCustomer: TZQuery;
    qryCustomerADDR1: TStringField;
    qryCustomerCITY: TStringField;
    qryCustomerCOMPANY: TStringField;
    qryCustomerCOUNTRY: TStringField;
    qryCustomerCUSTNO: TFloatField;
    qryCustomerSTATE: TStringField;
    qryCustomerZIP: TStringField;
    qryOrders: TZQuery;
    qryOrdersAMOUNTPAID: TFloatField;
    qryOrdersCUSTNO: TFloatField;
    qryOrdersEMPNO: TLongintField;
    qryOrdersFREIGHT: TFloatField;
    qryOrdersITEMSTOTAL: TFloatField;
    qryOrdersORDERNO: TFloatField;
    qryOrdersSALEDATE: TDateTimeField;
    tblCustomer: TZTable;
    tblCustomerADDR1: TStringField;
    tblCustomerADDR2: TStringField;
    tblCustomerCITY: TStringField;
    tblCustomerCOMPANY: TStringField;
    tblCustomerCONTACT: TStringField;
    tblCustomerCOUNTRY: TStringField;
    tblCustomerCUSTNO: TFloatField;
    tblCustomerFAX: TStringField;
    tblCustomerLASTINVOICEDATE: TDateTimeField;
    tblCustomerPHONE: TStringField;
    tblCustomerSTATE: TStringField;
    tblCustomerTAXRATE: TFloatField;
    tblCustomerZIP: TStringField;
    tblOrders: TZTable;
    tblOrdersAMOUNTPAID: TFloatField;
    tblOrdersCUSTNO: TFloatField;
    tblOrdersEMPNO: TLongintField;
    tblOrdersFREIGHT: TFloatField;
    tblOrdersITEMSTOTAL: TFloatField;
    tblOrdersORDERNO: TFloatField;
    tblOrdersPAYMENTMETHOD: TStringField;
    tblOrdersPO: TStringField;
    tblOrdersSALEDATE: TDateTimeField;
    tblOrdersSHIPDATE: TDateTimeField;
    tblOrdersSHIPTOADDR1: TStringField;
    tblOrdersSHIPTOADDR2: TStringField;
    tblOrdersSHIPTOCITY: TStringField;
    tblOrdersSHIPTOCONTACT: TStringField;
    tblOrdersSHIPTOCOUNTRY: TStringField;
    tblOrdersSHIPTOPHONE: TStringField;
    tblOrdersSHIPTOSTATE: TStringField;
    tblOrdersSHIPTOZIP: TStringField;
    tblOrdersSHIPVIA: TStringField;
    tblOrdersTAXRATE: TFloatField;
    tblOrdersTERMS: TStringField;
    updCustomer: TZUpdateSQL;
    updOrders: TZUpdateSQL;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure dsOrdersQueryStateChange(Sender: TObject);
    procedure dsOrdersTableStateChange(Sender: TObject);
    procedure qryOrdersNewRecord(DataSet: TDataSet);
    procedure tblOrdersNewRecord(DataSet: TDataSet);
  end;

var
  dmMasterDetail: TdmMasterDetail;

implementation

{$R *.lfm}

{ TdmMasterDetail }

procedure TdmMasterDetail.qryOrdersNewRecord(DataSet: TDataSet);
begin
  // server sided filters:
  // preparing key fields (primary key and foreign key)
  qryOrdersCUSTNO.Value := qryCustomerCUSTNO.Value;
  qryOrdersEMPNO.Value := 9999;
end;

procedure TdmMasterDetail.tblOrdersNewRecord(DataSet: TDataSet);
begin
  // client sided filters:
  // preparing key fields (foreign keys only! primary keys will be prepared,
  // automatically because of client sided filtering)
  tblOrdersEMPNO.Value := 9999;
end;

procedure TdmMasterDetail.dsOrdersQueryStateChange(Sender: TObject);
begin
  // for both kinds of m/d connection (!!!):
  // locking key fields (primary key and foreign key) if a new record is added to
  // prevent them from being changed.
  qryOrdersCUSTNO.ReadOnly := (dsOrdersQuery.State = dsInsert);
  qryOrdersEMPNO.ReadOnly := (dsOrdersQuery.State = dsInsert);
end;

procedure TdmMasterDetail.DataModuleCreate(Sender: TObject);
begin
  // connecting to database and opening queries
  conDBDemos.Connect;
  qryCustomer.Open;
  qryOrders.Open;
end;

procedure TdmMasterDetail.DataModuleDestroy(Sender: TObject);
begin
  // disconnecting from database and implicit closing of all open DataSets
  conDBDemos.Disconnect;
end;

procedure TdmMasterDetail.dsOrdersTableStateChange(Sender: TObject);
begin
  // for both kinds of m/d connection (!!!):
  // locking key fields (primary key and foreign key) if a new record is added to
  // prevent them from being changed.
  qryOrdersCUSTNO.ReadOnly := (dsOrdersQuery.State = dsInsert);
  qryOrdersEMPNO.ReadOnly := (dsOrdersQuery.State = dsInsert);
end;

end.

