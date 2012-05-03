program cgi1;

{$mode objfpc}{$H+}

uses
  LWSCGI,
  LWSConsts,
  LWSJDO,
  SysUtils,
  PQConnection;

resourcestring
  SCouldNotInsert = 'ERROR: Could not insert.';

type

  { TCGI }

  TCGI = class(TLWSCGI)
  private
    FDB: TLWSJDODataBase;
    FQuery: TLWSJDOQuery;
  protected
    procedure Init; override;
    procedure Finit; override;
    procedure Respond; override;
    procedure Request; override;
  end;

  procedure TCGI.Init;
  begin
    FDB := TLWSJDODataBase.Create('db.cfg');
    FQuery := TLWSJDOQuery.Create(FDB, 'person');
  end;

  procedure TCGI.Finit;
  begin
    FDB.Free;
    FQuery.Free;
  end;

  procedure TCGI.Respond;
  begin
    Contents.Add('Copie os arquivos "form.html", "form.js" e "jquery-1.7.2.js"');
    Contents.Add('para sua pasta "public_html" e chame o exemplo pela URL');
    Contents.Add('"http://localhost/form.html"');
  end;

  procedure TCGI.Request;
  begin
    FDB.StartTrans;
    try
      // Informo os campos para a query processar o registro.
      FQuery.AddField('name', ftStr);
      // Tento persistir o JSON, em casso de sucesso retorno um JSON genérico para o ajax, caso dê erro ...
      if FQuery.Insert(Fields) then
        Contents.Text := '{ "error": null }'
      else
        // ... abro uma exceção, que é necessária para o ajax mostrar a mensagem na tela.
        raise Exception.Create(SCouldNotInsert);
      FDB.Commit;
    except
      FDB.Rollback;
      raise;
    end;
    Contents.Text := Fields.AsJSON;
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

