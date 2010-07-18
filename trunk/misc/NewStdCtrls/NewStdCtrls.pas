unit NewStdCtrls;

{$mode objfpc}{$H+}

interface

uses
  StdCtrls, Graphics;

type
{$HINTS OFF}
  TEdit = class(StdCtrls.TEdit)
  protected
    procedure DoEnter; override;
    procedure DoExit; override;
  end;
{$HINTS ON}

implementation

procedure TEdit.DoEnter;
begin
  Color := clYellow;
  inherited DoEnter;
end;

procedure TEdit.DoExit;
begin
  inherited DoExit;
  Color := clWindow;
end;

end.
