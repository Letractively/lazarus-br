library Lib;

{$mode objfpc}{$H+}

uses
  Classes, Interfaces, stdctrls, Controls, UPrincipal, Forms;

{$R *.res}

procedure CreateControl(Parent:TWinControl);cdecl;
begin
  Application.Initialize;
  Box:=TBox.Create(Parent);
  Box.Align:=alClient;
  Box.ParentWindow:= Parent.Handle;
end;

procedure FreeControl; cdecl;
begin
  if Assigned(Box) then Box.Free;
end;


exports
  CreateControl, FreeControl;
begin

end.

