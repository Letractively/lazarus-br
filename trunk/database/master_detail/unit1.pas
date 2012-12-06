unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  pqconnection, sqldb, db, Forms, DBGrids, DbCtrls, StdCtrls, Classes;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBNavigator1: TDBNavigator;
    DBNavigator2: TDBNavigator;
    PQConnection1: TPQConnection;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  SQLQuery1.Open;
  SQLQuery2.Open;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  SQLQuery2.ApplyUpdates(0);
  SQLQuery1.ApplyUpdates(0);
  SQLTransaction1.CommitRetaining;
end;

end.

