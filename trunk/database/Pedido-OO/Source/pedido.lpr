program pedido;

{$I pedido.inc}

uses
{$IFDEF HEAPTRC}
  heaptrc,
{$IFDEF UNIX}
  SysUtils,
{$ENDIF}
{$ENDIF}
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, Forms, MainFrm, MainDM;

begin
{$IFDEF HEAPTRC}
{$IFDEF UNIX}
  DeleteFile(ExtractFilePath(ParamStr(0)) + 'PEDIDO.TRC');
  SetHeapTraceOutput(ExtractFilePath(ParamStr(0)) + 'PEDIDO.TRC');
{$ENDIF}
{$ENDIF}
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TMainDataModule, MainDataModule);
  Application.Run;
end.

