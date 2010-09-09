library FormDLL;

{$mode objfpc}{$H+}

uses
  Classes, SysUtils, Forms, Interfaces, UPrincipal, Controls
  { you can add units after this };

{$R *.res}
{$ifdef Windows}
var
  FormThread: TFormThread;
{$endif}
procedure ShowForm(Parent:TWinControl);cdecl;
begin
{$ifdef Windows}
  if Assigned(Form1) then
    begin
      Form1.Close;
    end;
  FormThread:= TFormThread.Create(True, Parent);
  FormThread.Resume;
{$endif}

{$ifdef Unix}
if not(Assigned(Form1)) then
  Form1:= TForm1.Create(Parent);
  Form1.Top:=0;
  Form1.Left:=0;
  Form1.Align:=alClient;
  Form1.ParentWindow:= Parent.Handle;
  Form1.Show;
{$endif}
end;

procedure FreeForm;cdecl;
begin
  if not(Assigned(Form1)) then Exit;
  Form1.Close;
  Form1.Free;
end;

Exports
  ShowForm, FreeForm;

begin
  Application.Initialize;
end.
