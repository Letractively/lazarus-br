unit SomeAction;

{$mode objfpc}{$H+}

interface

uses
  Classes, fpWeb, HTTPDefs;

type

  { TSomeAction }

  TSomeAction = class(TFPWebAction)
  public
    procedure DoHandleRequest(ARequest: TRequest; AResponse: TResponse;
      var Handled: Boolean); override;
    constructor Create(ACollection: TCollection); override;
  end;

implementation

{ TSomeAction }

procedure TSomeAction.DoHandleRequest(ARequest: TRequest; AResponse: TResponse;
  var Handled: Boolean);
begin
  Handled := True;
  AResponse.Content :=
    '<!DOCTYPE html>' + LineEnding +
    '<head>' + LineEnding +
    '<title>Test</title>' + LineEnding +
    '<meta charset="UTF-8">' + LineEnding +
    '</head>' + LineEnding +
    '<body>' + LineEnding +
    '<h2>Hello! :)</h2>' + LineEnding +
    '</body>' + LineEnding +
    '</html>';
  inherited DoHandleRequest(ARequest, AResponse, Handled);
end;

constructor TSomeAction.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  Default := True;
end;

end.

