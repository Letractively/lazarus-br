program project1;

{$mode objfpc}{$H+}

uses
  sqldb, pqconnection, sysutils, md5;

const
  SQL_CREATE_ROLE =
    'create role test login encrypted password ''md5%s''' +
    '  superuser noinherit createdb createrole' +
    '  valid until ''infinity'';';

  SQL_CREATE_TABLE =                          
    'create table %s(' +
    '  id serial not null primary key,' +
    '  field character varying(50));';

var
  db: TPQConnection;
  t: TSQLTransaction;
  q: TSQLQuery;
  role, dbname, tbname, pws: string;
begin
  db := TPQConnection.Create(nil);
  t := TSQLTransaction.Create(db);
  q := TSQLQuery.Create(db);
  try
    t.DataBase := db;
    q.DataBase := db;

    role := 'test';
    dbname := 'test';
    tbname := 'test';
    pws := 'test';

    db.DatabaseName := 'template1';
    db.UserName := 'postgres';
    db.Password := 'postgres';

    t.StartTransaction;
    try
      WriteLn('Creating role "', role, '" ...');
      db.ExecuteDirect(Format(SQL_CREATE_ROLE, [MD5Print(MD5String(pws + pws))]));
      t.Commit;
      WriteLn('Role "', role, '" created.');

      WriteLn('Creating database "', dbname, '" ...');
      db.Close;
      db.DatabaseName := dbname;
      db.Password := pws;
      db.UserName := role;
      db.CreateDB;
      WriteLn('Database "', dbname, '" created.');

      WriteLn('Creating table "', tbname, '" ...');
      q.SQL.Text := Format(SQL_CREATE_TABLE, [tbname]);
      q.ExecSQL;
      t.Commit;
      WriteLn('Table "', tbname, '" created.');

      WriteLn('Done!');
      WriteLn;

{$IFDEF MSWINDOWS}
      ExecuteProcess('cmd', ' /c pause');
{$ENDIF}
    except
      t.Rollback;
      raise;
    end;
  finally
    db.Free;
  end;
end.

