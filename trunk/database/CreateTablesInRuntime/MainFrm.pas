unit MainFrm;

{$I processor.inc}

interface

uses
  DB, Forms, DBCtrls, DBGrids, ZDataset, ZConnection, ZDbcIntfs, Metadata;

type

  { TMainForm }

  TMainForm = class(TForm)
    TestDataSource: TDatasource;
    MainDBGrid: TDBGrid;
    MainDBNavigator: TDBNavigator;
    MainZConnection: TZConnection;
    TestZQuery: TZQuery;
    TestZQueryfieldtest: TStringField;
    TestZQueryoid: TLongintField;
    procedure FormCreate(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{$IFDEF TOSQLITE3}
uses
  SysUtils;

{$ENDIF}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
{$IFDEF TOPOSTGRESQL}
  MainZConnection.Database := 'postgres';
  MainZConnection.HostName := 'localhost';
  MainZConnection.Password := 'postgres';
  MainZConnection.Port := 5432;
  MainZConnection.Protocol := 'postgresql-8';
  MainZConnection.TransactIsolationLevel := tiReadCommitted;
  MainZConnection.User := 'postgres';
  MainZConnection.Connect;
  MainZConnection.ExecuteDirect(C_SQLToMakeDataBase);
{$ENDIF}
{$IFDEF TOSQLITE3}
  MainZConnection.Database := ExtractFilePath(ParamStr(0)) + 'data.db3';
  MainZConnection.Protocol := 'sqlite-3';
  MainZConnection.TransactIsolationLevel := tiNone;
  MainZConnection.Connect;
  MainZConnection.ExecuteDirect(C_SQLToMakeDataBase);
{$ENDIF}
  if MainZConnection.Connected then
    TestZQuery.Open;
end;

end.

