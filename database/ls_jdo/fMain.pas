unit fMain;

{$mode objfpc}{$H+}

interface

uses
  Forms, ExtCtrls, StdCtrls, LSGrids, JDO, FPJSON, Dialogs, Controls,
  PQConnection;

type
  TfrmMain = class(TForm)
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnRefresh: TButton;
    grid: TLSStringGrid;
    client: TPanel;
    bottom: TPanel;
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure gridDblClick(Sender: TObject);
  public
    db: TJDODataBase;
    sql: TJDOSQL;
    procedure refreshGrid;
    procedure operation(const op: TJDOStatementType; data: TJSONData);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

uses
  fPerson;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  db := TJDODataBase.Create(Self, 'db.cfg');
  sql := TJDOSQL.Create(Self, db.Query, 'person');
  sql.OrderBy := 'name';
  refreshGrid;
end;

procedure TfrmMain.gridDblClick(Sender: TObject);
begin
  btnEdit.Click;
end;

procedure TfrmMain.btnAddClick(Sender: TObject);
var
  o: TJSONObject;
begin
  o := TJSONObject.Create(['name', ES]);
  try
    if TfrmPerson.Execute(o) then
    begin
      operation(jstInsert, o);
      refreshGrid;
      grid.Select(2, o['name'].AsString);
    end;
  finally
    o.Free;
  end;
end;

procedure TfrmMain.btnEditClick(Sender: TObject);
var
  o: TJSONObject;
begin
  o := grid.SelectedRow;
  if TfrmPerson.Execute(o) then
  begin
    operation(jstUpdate, o);
    refreshGrid;
    grid.Select(2, o['name'].AsString);
  end;
end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
var
  a: TJSONArray;
begin
  if MessageDlg('Delete person(s)?', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    a := grid.SelectedRows;
    operation(jstDelete, a);
    grid.SetBookmark;
    refreshGrid;
    grid.GetBookmark;
  end;
end;

procedure TfrmMain.btnRefreshClick(Sender: TObject);
begin
  refreshGrid;
end;

procedure TfrmMain.refreshGrid;
var
  b: Boolean;
begin
  operation(jstSelect, nil);
  b := db.Query.RecordCount > 0;
  btnEdit.Enabled := b;
  btnDelete.Enabled := b;
end;

procedure TfrmMain.operation(const op: TJDOStatementType; data: TJSONData);
begin
  case op of
    jstSelect:
      begin
        sql.Compose(jstSelect);
        grid.LoadFromJSONString(db.Query.JSON, False, False);
      end;
    jstInsert:
      begin
        sql.Compose(jstInsert, True);
        db.Query.SetJSONObject(data as TJSONObject);
      end;
    jstUpdate:
      begin
        sql.Compose(jstUpdate, True);
        db.Query.SetJSONObject(data as TJSONObject);
      end;
    jstDelete:
      begin
        sql.Compose(jstDelete, True);
        db.Query.SetJSONArray(data as TJSONArray);
      end;
  end;
  db.Query.Commit;
end;

end.

