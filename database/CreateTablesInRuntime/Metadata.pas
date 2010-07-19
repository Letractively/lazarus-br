unit Metadata;

{$I processor.inc}

interface

const
  C_SQLToMakeDataBase =
{$IFDEF TOPOSTGRESQL}
    'CREATE TABLE testprocessor (' + sLineBreak +
    ' oid serial NOT NULL,' + sLineBreak +
    ' fieldtest character varying(10),' + sLineBreak +
    ' CONSTRAINT pk_oidtestprocessor PRIMARY KEY (oid))';
{$ENDIF}
{$IFDEF TOSQLITE3}
    'CREATE TABLE [testprocessor] (' + sLineBreak +
    '[oid] INTEGER CONSTRAINT "pk_oidtestprocessor" NOT NULL PRIMARY KEY AUTOINCREMENT,' + sLineBreak +
    '[fieldtest] VARCHAR(10) NOT NULL)';
{$ENDIF}

implementation

end.

