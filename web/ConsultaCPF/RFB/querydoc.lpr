program querydoc;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, Forms, frmmain;

begin
  Application.Initialize;
  Application.CreateForm(TfrMain, frMain);
  Application.Run;
end.

