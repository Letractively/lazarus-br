unit MainDM;

{$mode objfpc}

interface

uses
  Classes, DB, dbf, LResources, SysUtils;

type

  { TMainDataModule }

  TMainDataModule = class(TDataModule)
    MainDbf: TDbf;
    MainDataSource: TDatasource;
    MainSdfDataSetCompiler: TStringField;
    MainSdfDataSetFirstName: TStringField;
    MainSdfDataSetIDE: TStringField;
    MainSdfDataSetLastName: TStringField;
    MainSdfDataSetOS: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  end;

var
  MainDataModule: TMainDataModule;

implementation

{ TMainDataModule }

procedure TMainDataModule.DataModuleCreate(Sender: TObject);
begin
  MainDbf.FilePath := ExtractFilePath(ParamStr(0));
  MainDbf.TableName := 'programmers.dbf';
  MainDbf.Close;
  if not FileExists(MainDbf.FilePath + MainDbf.TableName) then
  begin
    MainDbf.FieldDefs.Clear;
    MainDbf.FieldDefs.Add('FirstName', ftString, 10, False);
    MainDbf.FieldDefs.Add('LastName', ftString, 10, False);
    MainDbf.FieldDefs.Add('IDE', ftString, 15, False);
    MainDbf.FieldDefs.Add('Compiler', ftString, 10, False);
    MainDbf.FieldDefs.Add('OS', ftString, 15, False);
    MainDbf.CreateTable;
  end;
  MainDbf.Open;
end;

initialization
  {$I MainDM.lrs}

end.

