unit Unit1;

{$mode objfpc}{$H+}
{$DEFINE CGIDEBUG}

interface

uses
  HTTPDefs, fpHTTP, fpWeb, dbugintf;

type

  { TFPWebModule1 }

  TFPWebModule1 = class(TFPWebModule)
    procedure indexRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
  end;

implementation

{$R *.lfm}

{ TFPWebModule1 }

procedure TFPWebModule1.indexRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
begin
  SendMethodEnter('indexRequest');
  Handled := True;
  AResponse.Content := 'Test';
end;

initialization
  SetDebuggingEnabled(True);
  RegisterHTTPModule('TFPWebModule1', TFPWebModule1);

end.

