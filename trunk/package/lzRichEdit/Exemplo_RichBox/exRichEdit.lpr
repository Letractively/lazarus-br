program exRichEdit;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  SysUtils, Forms, UPrincipal, ULocalizar, UParagrafo, USobre, lazrichedit,
  RTF2HTML;

{$R *.res}

begin
  SetHeapTraceOutput(ExtractFilePath(ParamStr(0)) + 'heaptrclog.trc'); // Aqui
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmLocalizar, frmLocalizar);
  Application.CreateForm(TfrmParagrafo, frmParagrafo);
  Application.CreateForm(TfrmSobre, frmSobre);
  Application.Run;
end.
