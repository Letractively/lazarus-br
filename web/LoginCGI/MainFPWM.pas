unit MainFPWM;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, HTTPDefs, fpHTTP, fpWeb;

type

  { TMainFPWebModule }

  TMainFPWebModule = class(TFPWebModule)
    Procedure TFPWebActions0Request(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; Var Handled: Boolean);
    Procedure TFPWebActions1Request(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; Var Handled: Boolean);
  public
    function Header(const AStyle: string; const ATitle: string = '';
      const ABody: string = ''): string;
    function LoginContent(const APath: string = ''): string;
  end;

const
  CCustomHeader = {$I customheader.inc}
  CLoginContent = {$I logincontent.inc}

implementation

{$R *.lfm}

{ TMainFPWebModule }

Procedure TMainFPWebModule.TFPWebActions0Request(Sender: TObject;
  ARequest: TRequest; AResponse: TResponse; Var Handled: Boolean);
begin
  AResponse.Content := Header('/css/login.css', 'Login page', LoginContent);
  Handled := True;
end;

Procedure TMainFPWebModule.TFPWebActions1Request(Sender: TObject;
  ARequest: TRequest; AResponse: TResponse; Var Handled: Boolean);
var
  VLoginResult: string;
begin
  VLoginResult := '<h1>Login successfully! :)</h1><br />' + sLineBreak +
    'E-mail: ' + ARequest.ContentFields.Values['login'] + '<br />' + sLineBreak +
    'Password: ' + ARequest.ContentFields.Values['password']  + '<br />' + sLineBreak +
    'Remember me: ' + ARequest.ContentFields.Values['remember_me'];
  AResponse.Content := Header('/css/logged.css', 'Logged', VLoginResult);
  Handled := True;
end;

function TMainFPWebModule.Header(const AStyle: string; const ATitle: string;
  const ABody: string): string;
begin
  Result := Format(CCustomHeader, [ATitle, AStyle, ABody]);
end;

function TMainFPWebModule.LoginContent(const APath: string): string;
begin
  if APath = '' then
    Result := Format(CLoginContent, [ExtractFileName(ParamStr(0))])
  else
    Result := Format(CLoginContent, [APath]);
end;

initialization
  RegisterHTTPModule('TMainFPWebModule', TMainFPWebModule);

end.

