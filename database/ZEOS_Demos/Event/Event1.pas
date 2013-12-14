unit Event1;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls;

type

  { TfrmEvents }

  TfrmEvents = class(TForm)
    btnClearEvents: TButton;
    btnCloseDatabase: TButton;
    btnGenerateEvent: TButton;
    btnOpenDatabase: TButton;
    btnRegisterEvents: TButton;
    ebEvent: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    lbReceived: TListBox;
    moRegister: TMemo;
    procedure btnClearEventsClick(Sender: TObject);
    procedure btnCloseDatabaseClick(Sender: TObject);
    procedure btnGenerateEventClick(Sender: TObject);
    procedure btnOpenDatabaseClick(Sender: TObject);
    procedure btnRegisterEventsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  end;

var
  frmEvents: TfrmEvents;

implementation

{$R *.lfm}

{ TfrmEvents }

uses
  Event2;

procedure TfrmEvents.btnOpenDatabaseClick(Sender: TObject);
begin
  // connect to database
  dmEvents.ZConnection1.Connect;

  // initialization
  GroupBox2.Enabled := True;
  GroupBox3.Enabled := True;
  GroupBox4.Enabled := True;
  Label1.Enabled := True;
  btnGenerateEvent.Enabled := True;
  btnRegisterEvents.Enabled := True;
  btnClearEvents.Enabled := True;
  btnCloseDatabase.Enabled := True;
  btnOpenDatabase.Enabled := False;
end;

procedure TfrmEvents.btnRegisterEventsClick(Sender: TObject);
begin
  with dmEvents.ZIBEventAlerter1 do
  begin
    // discard all registered events
    UnregisterEvents;

    // create new events ...
    Events.Assign(moRegister.Lines);

    // ... und register them
    RegisterEvents;
  end;
end;

procedure TfrmEvents.FormDestroy(Sender: TObject);
begin
  // discard registered events and disconnect from database
  dmEvents.ZIBEventAlerter1.UnregisterEvents;
  dmEvents.ZConnection1.Disconnect;
end;

procedure TfrmEvents.btnCloseDatabaseClick(Sender: TObject);
begin
  // discard registered events and disctonnect from database
  dmEvents.ZIBEventAlerter1.UnregisterEvents;
  dmEvents.ZConnection1.Disconnect;

  // clean up
  moRegister.Lines.Clear;
  ebEvent.Clear;
  GroupBox2.Enabled := False;
  GroupBox3.Enabled := False;
  GroupBox4.Enabled := False;
  Label1.Enabled := False;
  btnGenerateEvent.Enabled := False;
  btnRegisterEvents.Enabled := False;
  btnClearEvents.Enabled := False;
  btnCloseDatabase.Enabled := False;
  btnOpenDatabase.Enabled := True;
end;

procedure TfrmEvents.btnClearEventsClick(Sender: TObject);
begin
  // listbox that contains the received events
  lbReceived.Clear;
end;

procedure TfrmEvents.btnGenerateEventClick(Sender: TObject);
begin
  with dmEvents do
  begin
    // start an explicit transation
    ZConnection1.StartTransaction;

    // set parameters and execute the stored procedure that triggers
    // the given event
    ZStoredProc1.Params[0].Value := ebEvent.Text;
    ZStoredProc1.ExecSQL;

    // end explicit transaction
    ZConnection1.Commit;
  end;
end;

end.

