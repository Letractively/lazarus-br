{=====================================\
|   -:- programmer ObjectPascal -:-   |
|    http://blog.silvioprog.com.br/   |
|=====================================|
|        -:- PressObjects -:-         |
|     http://br.pressobjects.org/     |
|=====================================|
|            -:- Sure -:-             |
|http://sourceforge.net/projects/sure/|
|=====================================|
|      -:- Free Pascal/Lazraus -:-    |
|    http://lazarus.freepascal.org/   |
|=====================================|
|            -:- ZeosLib -:-          |
|       http://zeos.firmos.at/        |
|=====================================|
|             -:- ACBr -:-            |
| http://acbr.sourceforge.net/drupal/ |
\=====================================}

program demo;

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
  Interfaces, Forms, MainFrm, MainDM;

begin
{$ifdef heaptrc}
{$ifdef unix}
  DeleteFile(ExtractFilePath(ParamStr(0)) + 'heaptrc.trc');
  SetHeapTraceOutput(ExtractFilePath(ParamStr(0)) + 'heaptrc.trc');
{$endif}
{$endif}
  Application.Initialize;
  Application.CreateForm(TMainDataModule, MainDataModule);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

