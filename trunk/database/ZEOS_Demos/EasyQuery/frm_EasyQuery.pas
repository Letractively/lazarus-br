unit frm_EasyQuery;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls, DBGrids, DBCtrls;

type

  { TfrmEasyQuery }

  TfrmEasyQuery = class(TForm)
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBGrid1: TDBGrid;
    DBLookupComboBox1: TDBLookupComboBox;
    DBNavigator1: TDBNavigator;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  end;

var
  frmEasyQuery: TfrmEasyQuery;

implementation

{$R *.lfm}

{ TfrmEasyQuery }

uses
  dm_EasyQuery;

procedure TfrmEasyQuery.FormCreate(Sender: TObject);
begin
  // connecting to database
  dmEasyQuery.conEmployee.Connect;
  // opening the datasets
  dmEasyQuery.qryCustomer.Open;
  dmEasyQuery.roqryCountry.Open;
end;

procedure TfrmEasyQuery.FormDestroy(Sender: TObject);
begin
  // disconnecting from database
  dmEasyQuery.conEmployee.Disconnect;
end;

end.

