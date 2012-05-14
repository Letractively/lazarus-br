unit fMain;

{$mode objfpc}{$H+}

interface

uses
  Forms, ExtCtrls, StdCtrls, LSGrids, JDO, JDOConsts, FPJSON, Dialogs,
  Controls, PQConnection, Classes;

type

  { TfrmMain }

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
    procedure FormDestroy(Sender: TObject);
    procedure gridDblClick(Sender: TObject);
  public
    db: TJDODataBase;
    q: TJDOQuery;
    procedure operation(json: TJSONData; const operation: TJDOSQLOperation);
    procedure notify(const notifyType: TJDOQueryNotifyTypes);
    procedure refreshGrid;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

uses
  fPerson;

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  db := TJDODataBase.Create('db.cfg');
  q := TJDOQuickQuery.Create(db, 'person');
  q.OnNotify := @notify;
  refreshGrid;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  DB.Free;
end;

procedure TfrmMain.gridDblClick(Sender: TObject);
begin
  btnEdit.Click;
end;

procedure TfrmMain.btnAddClick(Sender: TObject);
var
  json: TJSONObject;
begin
  json := TJSONObject.Create(['name', ES]);
  if TfrmPerson.Execute(json) then
  begin
    operation(json, soInsert);
    refreshGrid;
    grid.SelectLastRow;
  end;
end;

procedure TfrmMain.btnEditClick(Sender: TObject);
var
  json: TJSONObject;
begin
  json := grid.SelectedRow.Clone as TJSONObject;
  if TfrmPerson.Execute(json) then
  begin
    operation(json, soUpdate);
    grid.SetBookmark;
    refreshGrid;
    grid.GetBookmark;
  end;
end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
var
  json: TJSONArray;
begin
  if MessageDlg('Delete person(s)?', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    json := grid.SelectedRows.Clone as TJSONArray;
    grid.SetBookmark;
    operation(json, soDelete);
    refreshGrid;
    grid.GetBookmark;
  end;
end;

procedure TfrmMain.btnRefreshClick(Sender: TObject);
begin
  refreshGrid;
end;

procedure TfrmMain.operation(json: TJSONData; const operation: TJDOSQLOperation);
begin
  q.Fields.Clear;
  case operation of
    soSelect: q.Open;
    soInsert:
    begin
      q.AddField('name', ftStr);
      q.Insert(json as TJSONObject);
    end;
    soUpdate:
    begin
      q.AddField('id', ftInt);
      q.AddField('name', ftStr);
      q.Update(json as TJSONObject);
    end;
    soDelete:
    begin
      q.AddField('id', ftInt);
      q.Delete(json as TJSONArray);
    end;
  end;
end;

procedure TfrmMain.refreshGrid;
begin
  operation(nil, soSelect);
  grid.LoadFromJSONString(q.AsJSON, False, False);
end;

{$HINTS OFF}
procedure TfrmMain.notify(const notifyType: TJDOQueryNotifyTypes);
var
  B: Boolean;
begin
  B := q.Count > 0;
  btnEdit.Enabled := B;
  btnDelete.Enabled := B;
end;
{$HINTS ON}

end.

