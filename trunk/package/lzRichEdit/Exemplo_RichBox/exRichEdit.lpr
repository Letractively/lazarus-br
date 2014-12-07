program exRichEdit;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  SysUtils, Forms, UPrincipal, ULocalizar, UParagrafo, USobre, lazrichedit,
  printer4lazarus, RTF2HTML, JvHtmlParser;

{$R *.res}

begin
  SetHeapTraceOutput(ExtractFilePath(ParamStr(0)) + 'heaptrclog.trc'); // Aqui
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmLocalizar, frmLocalizar);
  Application.CreateForm(TfrmParagrafo, frmParagrafo);
  Application.CreateForm(TfrmSobre, frmSobre);
  Application.Run;
end.

