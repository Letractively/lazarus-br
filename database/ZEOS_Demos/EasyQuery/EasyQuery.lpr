program EasyQuery;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, Forms, frm_EasyQuery, dm_EasyQuery;

begin
  Application.Initialize;
  Application.CreateForm(TdmEasyQuery, dmEasyQuery);
  Application.CreateForm(TfrmEasyQuery, frmEasyQuery);
  Application.Run;
end.

