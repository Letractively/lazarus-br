program cgi1;

{$mode objfpc}{$H+}

uses
  LWSCGI,
  LWSConsts,
  JDO,
  SysUtils,
  PQConnection;

type
  TCGI = class(TLWSCGI)
  private
    db: TJDODataBase;
    sql: TJDOSQL;
    procedure CreateFieldDefs;
  protected
    procedure Init; override;
    procedure Finit; override;
    procedure Respond; override;
    procedure Request; override;
  end;

  procedure TCGI.CreateFieldDefs;
  begin
    with db.Query do
    begin
      Close;
      SQL.Text := 'select * from person where 1=2';
      Open;
      Close;
    end;
  end;

  procedure TCGI.Init;
  begin
    db := TJDODataBase.Create(nil, 'db.cfg');
    sql := TJDOSQL.Create(db, db.Query, 'person');
    CreateFieldDefs;
  end;

  procedure TCGI.Finit;
  begin
    db.Free;
  end;

  procedure TCGI.Respond;
  begin
    Contents.Add('Copie os arquivos "form.html", "form.js" e "jquery-1.7.2.js"');
    Contents.Add('para sua pasta "public_html" e chame o exemplo pela URL');
    Contents.Add('"http://localhost/form.html"');
  end;

  procedure TCGI.Request;
  begin
    try
      // Gero o SQL para "insert".
      sql.Compose(jstInsert, True);
      // Persisto os dados JSON.
      db.Query.SetJSONObject(Fields);
      db.Query.Commit;
      Contents.Text := '{ "success": true }';
    except
      on E: Exception do
        Contents.Text := E.Message;
    end;
  end;

begin
  with TCGI.Create do
    try
      ContentType := LWS_HTTP_CONTENT_TYPE_APP_JSON;
      Run;
    finally
      Free;
    end;
end.

