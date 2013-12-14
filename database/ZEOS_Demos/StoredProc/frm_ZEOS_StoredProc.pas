unit frm_ZEOS_StoredProc;

{$mode objfpc}{$H+}

interface

uses
  Forms, Dialogs, ComCtrls, StdCtrls, DBGrids, DBCtrls;

type

  { TfrmSrotedProc }

  TfrmSrotedProc = class(TForm)
    btnAddEmpProj: TButton;
    dbeBudget: TDBEdit;
    dbgDepartments: TDBGrid;
    dbgEmployeeProject: TDBGrid;
    dbgMitarbeiter: TDBGrid;
    dbgProjekte: TDBGrid;
    lblBudget: TLabel;
    lblDepartment: TLabel;
    lblMitarbeiter: TLabel;
    lblProjekte: TLabel;
    pcStoredProc: TPageControl;
    tsSPWithoutResultset: TTabSheet;
    tsSPWithResultset: TTabSheet;
    procedure btnAddEmpProjClick(Sender: TObject);
    procedure dbeBudgetEnter(Sender: TObject);
  end;

var
  frmSrotedProc: TfrmSrotedProc;

implementation

{$R *.lfm}

uses
  dm_ZEOS_StoredProc;

{ TfrmSrotedProc }

procedure TfrmSrotedProc.btnAddEmpProjClick(Sender: TObject);
begin
  // Adding a new project member using a sotred procedure
  with dmStoredProc do
  begin
    // check if the employee is already member of the project
    qryROCheckEmployeeProject.Close;
    qryROCheckEmployeeProject.ParamByName('emp_no').Value :=
      qryROEmployeeEMP_NO.Value;
    qryROCheckEmployeeProject.ParamByName('proj_id').Value :=
      qryROProjectPROJ_ID.Value;
    qryROCheckEmployeeProject.Open;

    // Employee is not member of this group, yet: Adding membership using
    // stored procedure:
    if qryROCheckEmployeeProjectCOUNT.Value = 0 then
    begin
      spAddEmployeeProject.ParamByName('emp_no').Value :=
        qryROEmployeeEMP_NO.Value;
      spAddEmployeeProject.ParamByName('proj_id').Value :=
        qryROProjectPROJ_ID.Value;
      spAddEmployeeProject.ExecSQL;
      qryEmployeeProjects.Refresh;
    end

    // Employee is already member of the project: Show message
    else
      MessageDlg(qryROEmployeeNAME.Value + ' is already member of project ' +
        qryROProjectPROJ_NAME.Value + '!', mtWarning, [mbOK], 0);
    qryROCheckEmployeeProject.Close;
  end;
end;

procedure TfrmSrotedProc.dbeBudgetEnter(Sender: TObject);
begin
  dbgDepartments.SetFocus;
end;

end.

