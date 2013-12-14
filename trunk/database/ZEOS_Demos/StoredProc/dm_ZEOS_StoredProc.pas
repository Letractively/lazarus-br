unit dm_ZEOS_StoredProc;

{$mode objfpc}{$H+}

interface

uses
  Classes, ZConnection, ZStoredProcedure, DB, ZDataset, ZSqlUpdate;

type

  { TdmStoredProc }

  TdmStoredProc = class(TDataModule)
    conEmployee: TZConnection;
    dsDepartment: TDatasource;
    dsDepBudget: TDatasource;
    dsEmployee: TDatasource;
    dsEmployeeProjects: TDatasource;
    dsProject: TDatasource;
    qryEmployeeProjects: TZQuery;
    qryEmployeeProjectsEMP_NO: TSmallintField;
    qryEmployeeProjectsNAME: TStringField;
    qryEmployeeProjectsPROJ_ID: TStringField;
    qryEmployeeProjectsPROJ_NAME: TStringField;
    qryROCheckEmployeeProject: TZReadOnlyQuery;
    qryROCheckEmployeeProjectCOUNT: TLongintField;
    qryRODepartment: TZReadOnlyQuery;
    qryRODepartmentDEPARTMENT: TStringField;
    qryRODepartmentDEPT_NO: TStringField;
    qryROEmployee: TZReadOnlyQuery;
    qryROEmployeeEMP_NO: TSmallintField;
    qryROEmployeeNAME: TStringField;
    qryROProject: TZReadOnlyQuery;
    qryROProjectPROJ_ID: TStringField;
    qryROProjectPROJ_NAME: TStringField;
    spAddEmployeeProject: TZReadOnlyQuery;
    spDepBudget: TZStoredProc;
    spDepBudgetTOT: TFloatField;
    updEmployeeProject: TZUpdateSQL;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure dsDepartmentDataChange(Sender: TObject; Field: TField);
  end;

var
  dmStoredProc: TdmStoredProc;

implementation

{$R *.lfm}

{ TdmStoredProc }

procedure TdmStoredProc.dsDepartmentDataChange(Sender: TObject; Field: TField);
begin
  // If the current dataset in department DataSource changes (e. g. by navigating)
  // then the stored procedure that determines the department's budget has to be
  // executed again using the new (current) department number.
  with spDepBudget do
  begin
    Close;
    Params[1].Value := qryRODepartmentDEPT_NO.Value;
    Open;
  end;
end;

procedure TdmStoredProc.DataModuleCreate(Sender: TObject);
begin
  // connecting to database and open all DataSets
  conEmployee.Connect;
  spDepBudget.Open;
  qryRODepartment.Open;
  qryROEmployee.Open;
  qryROProject.Open;
  qryEmployeeProjects.Open;
end;

procedure TdmStoredProc.DataModuleDestroy(Sender: TObject);
begin
  // disconnecting vom database
  conEmployee.Disconnect;
end;

end.

