program cgi1;

{$mode objfpc}{$H+}

uses
  LWSCGI,
  JDO,
  SysUtils,
  FPJSON,
  PQConnection;

const
  DB_SUCESS = '{ "success": true }';
  DB_ERROR = '{ "msg": "%s" }';

type

  { TCGI }

  TCGI = class(TLWSCGI)
  private
    db: TJDODataBase;
    q: TJDOQuery;
    sql: TJDOSQL;
    procedure CreateFieldDefs;
  protected
    procedure Init; override;
    procedure Finit; override;
    procedure Request; override;
    procedure GetPersons;
    procedure AddPerson;
    procedure EditPerson(const AID: Int64);
    procedure DeletePerson;
    procedure Success;
    procedure Error(const AMsg: string);
  end;

  procedure TCGI.CreateFieldDefs;
  begin
    q.Close;
    q.SQL.Text := 'select * from person where 1=2';
    q.Open;
    q.Close;
  end;

  procedure TCGI.Init;
  begin
    db := TJDODataBase.Create(nil, 'db.cfg');
    q := TJDOQuery.Create(db);
    sql := TJDOSQL.Create(q, q, 'person');

    // Necessary for the automatic SQL generation
    CreateFieldDefs;
  end;

  procedure TCGI.Finit;
  begin
    db.Free;
  end;

  procedure TCGI.Request;
  var
    P: string;
  begin
    P := GetNextPathInfo;
    if P = 'list' then
      GetPersons
    else
    if P = 'add' then
      AddPerson
    else
    if P = 'edit' then
      EditPerson(StrToInt64Def(GetNextPathInfo, -1))
    else
    if Pos('delete', P) <> 0 then
      DeletePerson
    else
      Error('Not found');
  end;

  procedure TCGI.GetPersons;
  var
    data: TJSONObject;
    page, rows: Integer;
  begin
    data := TJSONObject.Create;
    try
      db.Query.SQL.Text := 'select count(*) as items from person';
      db.Query.Open;
      data.Add('total', db.Query.Field('items').AsInteger);
      sql.Put('order by name limit :limit offset :offset', ptEnd);
      sql.Compose(jstSelect);
      rows := Fields['rows'].AsInteger;
      page := Fields['page'].AsInteger;
      q.Param('limit').AsInteger := rows;
      q.Param('offset').AsInteger := (page - 1) * rows;
      q.Open;
      data.Add('rows', q.GetJSONArray);
      q.Commit;
      Contents.Text := data.AsJSON;
    finally
      data.Free;
    end;
  end;

  procedure TCGI.AddPerson;
  begin
    sql.Compose(jstInsert, True);
    q.SetJSONObject(Fields);
    q.Commit;
    Success;
  end;

  procedure TCGI.EditPerson(const AID: Int64);
  begin
    Fields.Add('id', AID);
    sql.Compose(jstUpdate, True);
    q.SetJSONObject(Fields);
    q.Commit;
    Success;
  end;

  procedure TCGI.DeletePerson;
  begin
    sql.Compose(jstDelete, True);
    q.SetJSONObject(Fields);
    q.Commit;
    Success;
  end;

  procedure TCGI.Success;
  begin
    Contents.Text := DB_SUCESS;
  end;

  procedure TCGI.Error(const AMsg: string);
  begin
    Contents.Text := Format(DB_ERROR, [StringToJSONString(AMsg)]);
  end;

begin
  with TCGI.Create do
    try
      LengthRequired := False;
      Run;
    finally
      Free;
    end;
end.

