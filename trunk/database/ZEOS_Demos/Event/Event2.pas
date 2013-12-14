unit Event2;

{$mode objfpc}{$H+}

interface

uses
  Classes, ZConnection, ZIBEventAlerter, ZDataset;

type

  { TdmEvents }

  TdmEvents = class(TDataModule)
    ZConnection1: TZConnection;
    ZIBEventAlerter1: TZIBEventAlerter;
    ZStoredProc1: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure ZIBEventAlerter1EventAlert(Sender: TObject; EventName: string;
      EventCount: LongInt; var CancelAlerts: Boolean);
  end;

var
  dmEvents: TdmEvents;

implementation

{$R *.lfm}

{ TdmEvents }

uses
  Event1;

procedure TdmEvents.DataModuleCreate(Sender: TObject);
begin
  // Assigning the event alerter to the database
  ZIBEventAlerter1.Connection := ZConnection1;
end;

procedure TdmEvents.ZIBEventAlerter1EventAlert(Sender: TObject;
  EventName: string; EventCount: LongInt; var CancelAlerts: Boolean);
begin
  // If a registered event was received then its name will
  // be added to the listbox.
  frmEvents.lbReceived.Items.Add(EventName);
end;

end.

