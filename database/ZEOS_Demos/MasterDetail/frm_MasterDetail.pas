unit frm_MasterDetail;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls, DBGrids, DBCtrls;

type

  { TfrmMasterDetail }

  TfrmMasterDetail = class(TForm)
    dbgCustomer: TDBGrid;
    dbgOrders: TDBGrid;
    gbxCustomer: TGroupBox;
    gbxOrders: TGroupBox;
    navMasterDetail: TDBNavigator;
    rbTZQuery: TRadioButton;
    rbTZTable: TRadioButton;
    procedure dbgCustomerEnter(Sender: TObject);
    procedure dbgOrdersEnter(Sender: TObject);
    procedure rbTZQueryClick(Sender: TObject);
    procedure rbTZTableClick(Sender: TObject);
  end;

var
  frmMasterDetail: TfrmMasterDetail;

implementation

{$R *.lfm}

uses
  dm_MasterDetail;

{ TfrmMasterDetail }

procedure TfrmMasterDetail.rbTZQueryClick(Sender: TObject);
begin
  // - closing tables and opening queries
  // - assigning DataSources
  with dmMasterDetail do
  begin
    tblCustomer.Close;
    tblOrders.Close;
    qryCustomer.Open;
    qryOrders.Open;
    dbgCustomer.DataSource := dsCustomerQuery;
    dbgOrders.DataSource := dsOrdersQuery;
  end;
  dbgCustomer.OnEnter(Self);
end;

procedure TfrmMasterDetail.dbgCustomerEnter(Sender: TObject);
begin
  // assigning the DataSource of the navigator to the currently entered DBGrid
  navMasterDetail.DataSource := dbgCustomer.DataSource;
end;

procedure TfrmMasterDetail.dbgOrdersEnter(Sender: TObject);
begin
  // assigning the DataSource of the navigator to the currently entered DBGrid
  navMasterDetail.DataSource := dbgOrders.DataSource;
end;

procedure TfrmMasterDetail.rbTZTableClick(Sender: TObject);
begin
  // - closing queries and opening tables
  // - assigning DataSources
  with dmMasterDetail do
  begin
    qryCustomer.Close;
    qryOrders.Close;
    tblCustomer.Open;
    tblOrders.Open;
    dbgCustomer.DataSource := dsCustomerTable;
    dbgOrders.DataSource := dsOrdersTable;
  end;
  dbgCustomer.OnEnter(Self);
end;

end.

