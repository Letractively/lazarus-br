unit Win32WSRichBoxFactory;

{$mode objfpc}{$H+}

interface

uses
  RichBox, Win32WSRichBox, WSLCLClasses;

function RegisterCustomRichBox: Boolean;

implementation

function RegisterCustomRichBox: Boolean; alias : 'WSRegisterCustomRichBox';
begin
  Result := True;
  RegisterWSComponent(TCustomRichBox, TWin32WSCustomRichBox);
end;

end.

