unit AllRegisteredForms;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms;

procedure RegisterForm(AFormClass: array of TCustomFormClass);
function ShowForm(const AClassName: string; const AShowModal: Boolean = True): TForm;

implementation

procedure RegisterForm(AFormClass: array of TCustomFormClass);
var
  I: Integer;
begin
  for I := 0 to High(AFormClass) do
    RegisterClass(AFormClass[I]);
end;

function ShowForm(const AClassName: string; const AShowModal: Boolean): TForm;
begin
  Application.CreateForm(TComponentClass(FindClass(AClassName)), Result);
  if AShowModal then
    Result.ShowModal
  else
    Result.Show;
end;

end.

