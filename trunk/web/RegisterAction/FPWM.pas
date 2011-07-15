unit FPWM;

{$mode objfpc}{$H+}

interface

uses
  fpHTTP, fpWeb;

type

  { TMainFPWebModule }

  TMainFPWebModule = class(TFPWebModule)
    procedure DataModuleCreate(Sender: TObject);
  end;

implementation

{$R *.lfm}

uses
  ActionManager, SomeAction;

{ TMainFPWebModule }

procedure TMainFPWebModule.DataModuleCreate(Sender: TObject);
begin
  TActionManager.RegisterActions(Self, [TSomeAction]);
end;

initialization
  RegisterHTTPModule('TMainFPWebModule', TMainFPWebModule);

end.

