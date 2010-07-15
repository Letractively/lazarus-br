program teste;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, formatmemo, Unit2, Unit3
  { you can add units after this };

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormatar, Formatar);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.

