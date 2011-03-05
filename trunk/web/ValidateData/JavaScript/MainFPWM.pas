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
  protected
    function AssertData(const AExpression, AMsg, AControl: string): string;
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

function HTMLPage(const AHead, ABody: string): string;
begin
  Result :=
    '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">' + LineEnding +
    '<html>' + LineEnding + '<head>' + LineEnding + '<title>Validate data</title>' +
    LineEnding + AHead + LineEnding + '</head>' + LineEnding + '<body>' + LineEnding +
    ABody + LineEnding + '</body>' + LineEnding + '</html>';
end;

function HTMLLink(const ALink, ACaption: string): string;
begin
  Result := '<a href="' + ALink + '">' + ACaption + '</a>';
end;

function HTMLForm(const AInputElements: string; const AAction: string;
  const AMethod: string = 'get'; const AOnSubmit: string = ''): string;
begin
  if AOnSubmit <> '' then
    Result := '<form action="' + AAction + '" ' + 'method="' + AMethod +
      '" onsubmit="' + AOnSubmit + '">' + AInputElements + '</form>'
  else
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

function JavaScript(const AJavaScript: string): string;
begin
  Result :=
    '<script language="JavaScript" type="text/javascript">' + LineEnding +
      AJavaScript + LineEnding +
    '</script>';
end;

procedure TMainFPWebModule.indexRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
begin
  Handled := True;
  AResponse.Content := HTMLLogin;
end;

procedure TMainFPWebModule.testRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
begin
  Handled := True;
  AResponse.Content := HTMLPage('', 'Your user name is: ' +
    ARequest.ContentFields.Values['user']);
end;

function TMainFPWebModule.AssertData(const AExpression, AMsg, AControl: string
  ): string;
begin
  Result := JavaScript(
    'function assertdata(form)' + LineEnding +
    '{' + LineEnding +
    '  if (' + AExpression + ') {' + LineEnding +
    '    alert("' + AMsg + '");' + LineEnding +
    '    form.' + AControl + '.focus();' + LineEnding +
    '    return false;' + LineEnding +
    '  }' + LineEnding +
    '  return true;' + LineEnding +
    '}');
end;

function TMainFPWebModule.HTMLLogin: string;
begin
  Result := HTMLPage(AssertData('form.user.value == ""',
    'Please, enter your user name.', 'user'),
    HTMLForm(HTMLEdit('user', 'text', 'User name: ') +
    LineEnding + HTMLSubmit, CMainURL + 'test', 'post',
    'return assertdata(this)'));
end;

initialization
  RegisterHTTPModule('TMainFPWebModule', TMainFPWebModule);

end.

