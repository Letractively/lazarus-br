unit Ffactwin;

{ This application shows how to display Paradox style memo and graphic
 fields in a form. Table1's DatabaseName property should point to the
 Delphi sample database. Table1's TableName property should be set to
 the BIOLIFE table. }

{$mode objfpc}{$H+}

interface

uses
  Forms, ExtCtrls, DBCtrls, DBGrids, Buttons, StdCtrls, ZConnection, ZDataset,
  DB;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    conDemos: TZConnection;
    DBGrid1: TDBGrid;
    DBImage1: TDBImage;
    DBLabel1: TDBText;
    DBLabel2: TDBText;
    DBMemo1: TDBMemo;
    dsBiolife: TDatasource;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    tblBiolife: TZTable;
    tblBiolifeCATEGORY: TStringField;
    tblBiolifeCOMMON_NAME: TStringField;
    tblBiolifeGRAPHIC: TBlobField;
    tblBiolifeLENGTHCM: TFloatField;
    tblBiolifeLENGTH_IN: TFloatField;
    tblBiolifeNOTES: TMemoField;
    tblBiolifeSPECIESNAME: TStringField;
    tblBiolifeSPECIESNO: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  // connecting to database, opening table
  conDemos.Connect;
  tblBiolife.Open;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  // disconnect from database
  conDemos.Disconnect;
end;

end.

