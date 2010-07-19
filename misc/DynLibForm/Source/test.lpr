program test;

{$mode objfpc}{$H+}
{.$define heaptrc}

uses
{$ifdef heaptrc}
  heaptrc,
{$ifdef unix}
  SysUtils,
{$endif}
{$endif}
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, Forms, MainFrm;

begin
{$ifdef heaptrc}
{$ifdef unix}
  DeleteFile(ExtractFilePath(ParamStr(0)) + 'heaptrc.trc');
  SetHeapTraceOutput(ExtractFilePath(ParamStr(0)) + 'heaptrc.trc');
{$endif}
{$endif}
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

