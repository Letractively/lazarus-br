library FormDLL;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils, Forms, Interfaces, UPrincipal
  { you can add units after this };

{$R *.res}
{$ifdef Windows}
var
  FormThread: TFormThread;
{$endif}
procedure ShowForm;cdecl;
begin
{$ifdef Windows}
  if Assigned(Form1) then
    begin
      Form1.Close;
    end;
  FormThread:= TFormThread.Create(True);
  FormThread.Resume;
{$endif}

{$ifdef Unix}
if not(Assigned(Form1)) then
  Form1:=TForm1.Create(Application);
  Form1.Show;
{$endif}
end;

procedure FreeForm;cdecl;
begin
  Form1.Close;
  Form1.Free;
end;

Exports
  ShowForm, FreeForm;

begin
  Application.Initialize;
end.

