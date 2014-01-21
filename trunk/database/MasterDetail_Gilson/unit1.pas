unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, sqldb, db, sqlite3conn, Forms, DBGrids, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1 : TButton;
    DataSource1 : TDataSource;
    DataSource2 : TDataSource;
    DBGrid1 : TDBGrid;
    DBGrid2 : TDBGrid;
    SQLite3Connection1 : TSQLite3Connection;
    SQLQuery1 : TSQLQuery;
    SQLQuery2 : TSQLQuery;
    SQLTransaction1 : TSQLTransaction;
    procedure Button1Click(Sender : TObject);
  private
    procedure CreateDB();
  public
    { public declarations }
  end;

var
  Form1 : TForm1;

implementation

uses math;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender : TObject);
begin
  if not FileExists(SQLite3Connection1.DatabaseName) then
    CreateDB();

  SQLite3Connection1.Open;
  SQLQuery1.Open;
  SQLQuery2.Open;
end;

procedure TForm1.CreateDB;
var
  qrN, qrI : TSQLQuery;

  procedure InsereNota(aIdNota : Integer; const aDt : TDate; aNum, QtdItens  : Integer);

    procedure InsereItens(const aVlTots : array of Currency);

      procedure _Insere(aIdItem : Integer; const aTot : Currency);
      var
        vQtde : Currency;
      begin
        vQtde := (Random(99) + 1) / 10;
        qrI.ParamByName('ID_ITEM').AsInteger    := aIdItem;
        qrI.ParamByName('ID_produto').AsInteger := Random(10000);
        qrI.ParamByName('quant').AsCurrency     := vQtde;
        qrI.ParamByName('VlrUnit').AsCurrency   := RoundTo(aTot / vQtde, -2);
        qrI.ExecSQL;
      end;

    var
      i : Integer;
    begin
      qrI.ParamByName('ID_NOTA').AsInteger      := aIdNota;
      for i := Low(aVlTots) to  High(aVlTots) do
         _Insere(i, aVlTots[i]);
    end;

    function GetTotal(const aVlTots : array of Currency) : Currency;
    var
      c : Currency;
    begin
      Result := 0;
      for c in aVlTots do
        Result += c;
    end;

  var
    vVlTots : array of Currency;
    i : Integer;
  begin
    SetLength(vVlTots, QtdItens);
    for i := 0 to QtdItens - 1 do
      vVlTots[i] := Random(10000) / 100 + 7;

    qrN.ParamByName('ID').AsInteger        := aIdNota;
    qrN.ParamByName('Emissao').AsDate      := aDt;
    qrN.ParamByName('Numero').AsInteger    := aNum;
    qrN.ParamByName('VlrTotal').AsCurrency := GetTotal(vVlTots);
    qrN.ExecSQL;
    InsereItens(vVlTots);
  end;

begin
  Randomize();
  SQLTransaction1.Active := False;
  SQLTransaction1.StartTransaction;
  try
    qrN := TSQLQuery.Create(nil);
    try
      qrI := TSQLQuery.Create(qrN);
      qrN.DataBase     := SQLite3Connection1;
      qrN.Transaction  := SQLTransaction1;
      qrI.DataBase     := SQLite3Connection1;
      qrI.Transaction  := SQLTransaction1;

      qrN.SQL.Text := 'CREATE TABLE Notas(ID int not null primary key, Emissao Date, Numero	int, Cliente int, '
                      + 'VlrTotal numeric(9, 2))';
      qrN.ExecSQL();

      qrN.SQL.Text := 'CREATE TABLE NOTAS_ITENS(ID_NOTA	int not null, ID_ITEM	smallint not null, '
                      + 'ID_produto	int, quant numeric(9, 2), VlrUnit numeric(9, 2), '
                      + 'constraint pk_NOTAS_ITENS primary key (ID_NOTA, ID_ITEM))';
      qrN.ExecSQL();

      qrN.SQL.Text := 'insert into NOTAS (ID, Emissao, Numero, VlrTotal) values (:ID, :Emissao, :Numero, :VlrTotal)';
      qrI.SQL.Text := 'insert into NOTAS_ITENS (ID_NOTA, ID_ITEM, ID_produto, quant, VlrUnit) '
                                    + ' values (:ID_NOTA, :ID_ITEM, :ID_produto, :quant, :VlrUnit)';

      InsereNota(1, EncodeDate(2011, 7, 14), 10001, 8);
      InsereNota(2, Date - 14, 10007, 4);
      InsereNota(5, Date - 25, 50990, 7);
      InsereNota(17, Date - 152, 9159, 15);
    finally
      qrN.Free;
    end;
    SQLTransaction1.Commit;
  except
    SQLTransaction1.Rollback;
    raise;
  end;
end;

end.

