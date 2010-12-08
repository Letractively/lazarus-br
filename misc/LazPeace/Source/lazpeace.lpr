program lazpeace;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, Forms, MainFrm, LSForms, LSUtils;

{$R *.res}

begin
  LSGlobalAddAtom(CLazPeaceAppAtom);
  LSRunOnce;
  Application.Title := 'LazPeace 1.0';
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

