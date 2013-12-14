program events;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, Forms, Event1, Event2;

begin
  Application.Initialize;
  Application.CreateForm(TfrmEvents, frmEvents);
  Application.CreateForm(TdmEvents, dmEvents);
  Application.Run;
end.
