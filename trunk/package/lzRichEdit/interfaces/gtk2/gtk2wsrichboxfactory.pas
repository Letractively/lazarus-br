unit Gtk2WSRichBoxFactory;

{$mode objfpc}{$H+}

interface

uses
  RichBox, Gtk2WSRichBox, WSLCLClasses;

function RegisterCustomRichBox: Boolean;

implementation

function RegisterCustomRichBox: Boolean; alias : 'WSRegisterCustomRichBox';
begin
  Result := True;
  RegisterWSComponent(TCustomRichBox, TGtk2WSCustomRichBox);
end;
end.

