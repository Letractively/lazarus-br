unit MainFPWM;

{$mode objfpc}{$H+}

interface

uses
  HTTPDefs, fpHTTP, fpWeb;

type

  { TMainFPWebModule }

  TMainFPWebModule = class(TFPWebModule)
    procedure indexRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
    procedure testRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
  public
    function HTMLLogin: string;
  end;

const
  CMainURL = 'http://localhost/cgi-bin/demo.cgi/';
  HTMLLineEnding = '<br />';

var
  MainFPWebModule: TMainFPWebModule;

implementation

{$R *.lfm}

{ TMainFPWebModule }

function HTMLBody(const ABody: string): string;
begin
  Result :=
    '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2//EN">' + LineEnding +
    '<html>' + LineEnding + '<head>' + LineEnding + '<title>Validate data</title>' +
    LineEnding + '</head>' + LineEnding + '<body>' + LineEnding +
    ABody + LineEnding + '</body>' + LineEnding + '</html>';
end;

function HTMLLink(const ALink, ACaption: string): string;
begin
  Result := '<a href="' + ALink + '">' + ACaption + '</a>';
end;

function HTMLForm(const AInputElements: string; const AAction: string;
  const AMethod: string = 'get'): string;
begin
  Result := '<form action="' + AAction + '" ' + 'method="' + AMethod +
    '">' + AInputElements + '</form>';
end;

function HTMLInput(const AName: string; const AType: string = 'text';
  const AValue: string = ''; const ACaption: string = ''): string;
var
  VName: string = '';
begin
  if AName <> '' then
    VName := '" name="' + AName;
  Result := ACaption + '<input type="' + AType + VName + '" value="' + AValue + '">';
end;

function HTMLEdit(const AName: string; const AType: string = 'text';
  const ACaption: string = ''; const AValue: string = ''): string;
begin
  Result := HTMLInput(AName, AType, AValue, ACaption);
end;

function HTMLSubmit(const AValue: string = 'Submit'): string;
begin
  Result := HTMLInput('name', 'submit', AValue);
end;

procedure TMainFPWebModule.indexRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
begin
  Handled := True;
  AResponse.Content := HTMLLogin;
end;

procedure TMainFPWebModule.testRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  VUser: string;
begin
  Handled := True;
  VUser := ARequest.ContentFields.Values['user'];
  if VUser <> '' then
    AResponse.Content := HTMLBody('Your user name is: ' + VUser)
  else
    AResponse.Content := HTMLLogin + 'Please, enter your user name.';
end;

function TMainFPWebModule.HTMLLogin: string;
begin
  Result := HTMLBody(HTMLForm(HTMLEdit('user', 'text', 'User name: ') +
    LineEnding + HTMLSubmit, CMainURL + 'test', 'post'));
end;

initialization
  RegisterHTTPModule('TMainFPWebModule', TMainFPWebModule);

end.

