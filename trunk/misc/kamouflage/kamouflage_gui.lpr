program kamouflage_gui;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, Forms, unkamguiform;

begin
  Application.Title:='Kamouflage GUI';
  Application.Initialize;
  Application.CreateForm(TfrmKamguiform, frmKamguiform);
  Application.Run;
end.

