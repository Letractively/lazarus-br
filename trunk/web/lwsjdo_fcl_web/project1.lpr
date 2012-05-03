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
  LWSJDO;

resourcestring
  SCouldNotInsert = 'ERROR: Could not insert.';

type

  { TCGI }

  TCGI = class(TCGIHandler)
  private
    FDB: TLWSJDODataBase;
    FQuery: TLWSJDOQuery;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure HandleRequest(ARequest: TRequest; AResponse: TResponse); override;
  end;

  { TCGIApp }

  TCGIApp = class(TCustomCGIApplication)
  public
    function InitializeWebHandler: TWebHandler; override;
  end;

  { TCGIApp }

  function TCGIApp.InitializeWebHandler: TWebHandler;
  begin
    Result := TCGI.Create(Self);
  end;

  { TCGI }

  constructor TCGI.Create(AOwner: TComponent);
  begin
    inherited Create(AOwner);
    FDB := TLWSJDODataBase.Create('db.cfg');
    FQuery := TLWSJDOQuery.Create(FDB, 'person');
  end;

  destructor TCGI.Destroy;
  begin
    FDB.Free;
    FQuery.Free;
    inherited Destroy;
  end;

  procedure TCGI.HandleRequest(ARequest: TRequest; AResponse: TResponse);
  var
    J: TJSONObject;
    P: TJSONParser;
  begin
    // Aqui eu informo o content-type de saída.
    AResponse.ContentType := 'application/json';
    P := TJSONParser.Create(ARequest.Content);
    try
      FDB.StartTrans;
      try
        (* Faço o parse do meu form HTML. Lembrando que o registro que vem
          do form é, por exemplo: { "nome": "CHIMBICA" } *)
        J := P.Parse as TJSONObject;
        // Informo os campos para a query processar o registro.
        FQuery.AddField('name', ftStr);
        // Tento persistir o JSON, em casso de sucesso retorno um JSON genérico para o ajax, caso dê erro ...
        if FQuery.Insert(J) then
          AResponse.Content := '{ "error": null }'
        else
          // ... abro uma exceção, que é necessária para o ajax mostrar a mensagem na tela.
          raise Exception.Create(SCouldNotInsert);
        FDB.Commit;
      except
        FDB.Rollback;
        raise;
      end;
    finally
      J.Free;
      P.Free;
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

