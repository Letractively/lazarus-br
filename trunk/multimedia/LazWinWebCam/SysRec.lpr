program SysRec;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, Forms, Recorder;

begin
  Application.Initialize;
  Application.CreateForm(TVideo, Video);
  Application.Run;
end.

