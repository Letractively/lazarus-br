library libmyform;

{$mode objfpc}{$H+}

uses
  Interfaces,
  Forms,
  MyLibFrm;

  procedure ShowMyLibForm; cdecl; export;
  begin
    Application.Initialize;
    with TMyLibForm.Create(Application) do
      try
        ShowModal;
      finally
        Free;
      end;
  end;

exports
  ShowMyLibForm
{$ifdef windows}
  Name 'ShowMyLibForm'
{$endif}
  ;

begin
end.

