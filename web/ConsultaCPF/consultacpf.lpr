program consultacpf;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, Forms, PrincipalFrm;

begin
  Application.Initialize;
  Application.CreateForm(TPrincipalForm, PrincipalForm);
  Application.Run;
end.

