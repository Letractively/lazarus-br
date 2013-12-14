unit frm_Transactions;

{$mode objfpc}{$H+}

interface

uses
  Forms, Controls, Graphics, Dialogs, Buttons, ExtCtrls, DBCtrls, StdCtrls,
  DBGrids, ZConnection, ZDataset, DB, ZSqlUpdate, ZSqlMonitor;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnAutoCommit: TSpeedButton;
    btnCommit: TSpeedButton;
    BtnRollback: TSpeedButton;
    conTest: TZConnection;
    dbeName: TDBEdit;
    dbeRecNo: TDBEdit;
    dbgNamen: TDBGrid;
    dsNamen: TDatasource;
    lblName: TLabel;
    lblRecNo: TLabel;
    memMonitor: TMemo;
    monTest: TZSQLMonitor;
    navNamen: TDBNavigator;
    pnlFelder: TPanel;
    pnlGrid: TPanel;
    pnlMonitor: TPanel;
    pnlNavigator: TPanel;
    qryNamen: TZQuery;
    qryNamenName: TStringField;
    qryNamenRECNO: TLongintField;
    updNamen: TZUpdateSQL;
    procedure SetCommitRollback(bState: Boolean);
    procedure btnAutoCommitClick(Sender: TObject);
    procedure btnCommitClick(Sender: TObject);
    procedure BtnRollbackClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure monTestLogTrace(Sender: TObject; Event: TZLoggingEvent);
    procedure qryNamenAfterDelete(DataSet: TDataSet);
    procedure qryNamenAfterPost(DataSet: TDataSet);
    procedure qryNamenNewRecord(DataSet: TDataSet);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.SetCommitRollback(bState: Boolean);
begin
  // update button state
  btnCommit.Enabled := bState;
  btnRollback.Enabled := bState;
end;

procedure TForm1.qryNamenAfterDelete(DataSet: TDataSet);
begin
  // After deleting a record: update button states
  if not (conTest.AutoCommit) then
    SetCommitRollback(True);
end;

procedure TForm1.monTestLogTrace(Sender: TObject; Event: TZLoggingEvent);
begin
  // Show log entry in "monitor"
  memMonitor.Lines.Add(Event.Message);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Before closing the form it has to be looked for an open explicit transaction. If
  // it is found then the user is asked either to commit or to rollback transaction
  // before finally closing.
  if btnCommit.Enabled then
  begin
    if MessageDlg('Do you want to commit changes before closing?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      conTest.Commit
    else
      conTest.Rollback;
  end;
  CanClose := True;
end;

procedure TForm1.BtnRollbackClick(Sender: TObject);
begin
  // Rollback and update button states
  conTest.Rollback;
  SetCommitRollback(False);
  // refresh query resulset
  qryNamen.Refresh;
  // update AutoCommit button state
  btnAutoCommit.Down := conTest.AutoCommit;
  if conTest.AutoCommit then
    btnAutoCommit.Font.Color := clGreen;
  // Add message to "monitor"
  memMonitor.Lines.Add('EXPLICIT TRANSACTION ROLLED BACK.');
end;

procedure TForm1.btnCommitClick(Sender: TObject);
begin
  // Commit and update button states
  conTest.Commit;
  SetCommitRollback(False);
  // refresh query resultset
  qryNamen.Refresh;
  // update AutoCommit button state
  btnAutoCommit.Down := conTest.AutoCommit;
  if conTest.AutoCommit then
    btnAutoCommit.Font.Color := clGreen;
  // Add message to "monitor"
  memMonitor.Lines.Add('EXPLICIT TRANSACTION COMMITTED.');
end;

procedure TForm1.btnAutoCommitClick(Sender: TObject);
begin
  // If Autocommit is set to active while an explicit transaction is still open, the
  // user is asked either to commit or rollback this transaction.
  if btnAutoCommit.Down then
  begin
    if btnCommit.Enabled then
    begin
      // Ending explicit transaction by COMMITting
      if MessageDlg(
        'Sollen die Änderungen vor dem Wechsel inden AutoCommit-Modus committet werden?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        conTest.Commit;
        memMonitor.Lines.Add('EXPLICIT TRANSACTION COMMITTED.');
      end
      // Ending explicit transaction by ROLLBACKing
      else
      begin
        conTest.Rollback;
        memMonitor.Lines.Add('EXPLICIT TRANSACTION ROLLED BACK.');
      end;
      // refresh query resultset
      qryNamen.Refresh;
    end
    else
    begin
      btnAutoCommit.Font.Color := clGreen;
      memMonitor.Lines.Add('EXPLICIT TRANSACTION ENDED (NO ACTIONS)');
    end;
  end
  else
  begin
    // start explicit transaction
    conTest.StartTransaction;
    memMonitor.Lines.Add('EXPLICIT TRANSACTION STARTED.');
    btnAutoCommit.Font.Color := clBtnShadow;
  end;
  // update button states
  SetCommitRollback(False);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Determine codepage and dialect of the database
  conTest.Properties.Add('Codepage=ISO8859_1');
  conTest.Properties.Add('Dialect=3');
  // connect to database
  conTest.Connect;
  qryNamen.Open;
  // set stat of Commit-/Rollback-Buttons
  SetCommitRollback(False);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  // disctonnect from database
  conTest.Disconnect;
end;

procedure TForm1.qryNamenAfterPost(DataSet: TDataSet);
begin
  // After posting a change: update button states
  if not (conTest.AutoCommit) then
    SetCommitRollback(True);
end;

procedure TForm1.qryNamenNewRecord(DataSet: TDataSet);
begin
  // This is a very simple counter! Only for sample usage !!!
  // It doesn't recognize deleted records !!!
  qryNamenRecNo.AsInteger := qryNamen.RecordCount + 1;
end;

end.

