unit MainUtils;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

function OneStrIsEmpty(const AValue: array of string): Boolean;

implementation

function OneStrIsEmpty(const AValue: array of string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to High(AValue) do
    if Trim(AValue[I]) = EmptyStr then
    begin
      Result := True;
      Break;
    end;
end;

end.

