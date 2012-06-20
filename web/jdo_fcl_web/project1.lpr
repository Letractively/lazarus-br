program project1;

{$mode objfpc}{$H+}

uses
  Classes,
  SysUtils,
  HTTPDefs,
  CustCGI,
  CustWeb,
  PQConnection,
  JSONParser,
  FPJSON,
  JDO;

type
  TCGI = class(TCGIHandler)
  private
    db: TJDODataBase;
    sql: TJDOSQL;
    procedure CreateFieldDefs;
  public
    constructor Create(AOwner: TComponent); override;
    procedure HandleRequest(ARequest: TRequest; AResponse: TResponse); override;
  end;

  TCGIApp = class(TCustomCGIApplication)
  public
    function InitializeWebHandler: TWebHandler; override;
  end;

  function TCGIApp.InitializeWebHandler: TWebHandler;
  begin
    Result := TCGI.Create(Self);
  end;

  procedure TCGI.CreateFieldDefs;
  begin
    db.Query.Close;
    db.Query.SQL.Text := 'select * from person where 1=2';
    db.Query.Open;
    db.Query.Close;
  end;

  constructor TCGI.Create(AOwner: TComponent);
  begin
    inherited Create(AOwner);
    db := TJDODataBase.Create(Self, 'db.cfg');
    sql := TJDOSQL.Create(Self, db.Query, 'person');
    // Necessário para a geração automática de SQL.
    CreateFieldDefs;
  end;

  procedure TCGI.HandleRequest(ARequest: TRequest; AResponse: TResponse);
  var
    o: TJSONObject;
    p: TJSONParser;
  begin
    // Aqui eu informo o content-type de saída.
    AResponse.ContentType := 'application/json';
    p := TJSONParser.Create(ARequest.Content);
    try
      try
        (* Faço o parse do meu form HTML. Lembrando que o registro que vem
          do form é, por exemplo: { "nome": "CHIMBICA" } *)
        o := p.Parse as TJSONObject;
        // Aqui gero o SQL para insert.
        sql.Compose(jstInsert, True);
        // Persisto os dados JSON.
        db.Query.SetJSONObject(o);
        db.Query.Commit;
        AResponse.Content := '{ "success": true }';
      except
        on E: Exception do
          AResponse.Content := E.Message;
      end;
    finally
      p.Free;
    end;
  end;

begin
  with TCGIApp.Create(nil) do
    try
      Initialize;
      Run;
    finally
      Free;
    end;
end.

