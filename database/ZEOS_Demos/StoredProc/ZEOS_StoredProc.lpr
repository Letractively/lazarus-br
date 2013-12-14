program ZEOS_StoredProc;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, Forms, frm_ZEOS_StoredProc, dm_ZEOS_StoredProc;

begin
  Application.Initialize;
  Application.CreateForm(TdmStoredProc, dmStoredProc);
  Application.CreateForm(TfrmSrotedProc, frmSrotedProc);
  Application.Run;
end.
