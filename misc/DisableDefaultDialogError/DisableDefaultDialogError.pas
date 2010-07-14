unit DisableDefaultDialogError;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, LCLType;

type

  { TNewDialogType }

  TNewDialogType = (ndtError, ndtAsterick);

  { TDisableDefaultDialogError }

  TDisableDefaultDialogError = class
  private
    procedure OnExceptionHandler(Sender: TObject; E: Exception);
  public
    class procedure Register(const ANewDialogType: TNewDialogType = ndtError);
  end;

implementation

var
  _NewDialogType: TNewDialogType = ndtError;

{ TDisableDefaultDialogError }

class procedure TDisableDefaultDialogError.Register(
  const ANewDialogType: TNewDialogType = ndtError);
begin
  Application.Flags := Application.Flags + [AppNoExceptionMessages];
  _NewDialogType := ANewDialogType;
  Application.AddOnExceptionHandler(@OnExceptionHandler);
end;

procedure TDisableDefaultDialogError.OnExceptionHandler(Sender: TObject;
  E: Exception);

  procedure _MessageBox(const AFlags: LongInt);
  begin
    Application.MessageBox(PChar(E.Message), PChar(Application.Title), AFlags);
  end;

begin
  case _NewDialogType of
    ndtError: _MessageBox(MB_ICONERROR + MB_OK);
    ndtAsterick: _MessageBox(MB_ICONASTERICK + MB_OK);
  end;
end;

end.
