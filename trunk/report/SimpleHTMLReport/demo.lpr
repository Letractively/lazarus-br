program demo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, Forms, MainFrm, MainDM;

begin
  Application.Initialize;
  Application.CreateForm(TMainDataModule, MainDataModule);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

