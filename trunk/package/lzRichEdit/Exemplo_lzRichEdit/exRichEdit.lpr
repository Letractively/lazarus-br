program exRichEdit;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  SysUtils, Forms, lazrichedit, UPrincipal, ULocalizar, UParagrafo, USobre,
  UGetFontLinux, lzRichEditToHTML;

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
