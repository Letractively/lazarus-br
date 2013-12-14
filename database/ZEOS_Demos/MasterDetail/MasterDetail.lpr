program MasterDetail;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, Forms, frm_MasterDetail, dm_MasterDetail;

begin
  Application.Initialize;
  Application.CreateForm(TdmMasterDetail, dmMasterDetail);
  Application.CreateForm(TfrmMasterDetail, frmMasterDetail);
  Application.Run;
end.
