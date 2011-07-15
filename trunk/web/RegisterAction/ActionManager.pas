unit ActionManager;

{$mode objfpc}{$H+}

interface

uses
  fpWeb;

type

  { TFPWebActionClass }

  TFPWebActionClass = class of TFPWebAction;

  { TFPWebModuleClass }

  TFPWebModuleClass = class of TFPWebModule;

  { TActionManager }

  TActionManager = class
  public
    class procedure RegisterActions(var Module;
      const AActions: array of TFPWebActionClass);
  end;

implementation

{ TActionManager }

{$NOTES OFF}
class procedure TActionManager.RegisterActions(var Module;
  const AActions: array of TFPWebActionClass);
var
  I: Integer;
  VAction: TFPWebAction;
begin
  for I := 0 to High(AActions) do
    VAction := AActions[I].Create(TFPWebModule(Module).Actions);
end;
{$NOTES ON}

end.

