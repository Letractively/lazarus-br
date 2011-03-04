unit MainFPWM;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, ZConnection, ZDataset, HTTPDefs, fpHTTP, fpWeb, ZDbcIntfs;

type

  { TMainFPWebModule }

  TMainFPWebModule = class(TFPWebModule)
    MainZConnection: TZConnection;
    TestZQuery: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure indexRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
  end;

const
  CMainURL = 'http://localhost/cgi-bin/demo.cgi/';
  HTMLLineEnding = '<br />';

var
  MainFPWebModule: TMainFPWebModule;
  LogMsg: string = '';

implementation

{$R *.lfm}

{ TMainFPWebModule }

function HTMLBody(const ABody: string): string;
begin
  Result :=
    '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2//EN">' + LineEnding +
    '<html>' + LineEnding + '<head>' + LineEnding +
    '<title>Safe transaction</title>' + LineEnding + '</head>' +
    LineEnding + '<body>' + LineEnding + ABody + LineEnding +
    '</body>' + LineEnding + '</html>';
end;

function HTMLLink(const ALink, ACaption: string): string;
begin
  Result := '<a href="' + ALink + '">' + ACaption + '</a>';
end;

procedure TMainFPWebModule.DataModuleCreate(Sender: TObject);
var
  VAttempts: Byte;
begin
  with MainZConnection do
  begin
    Database := 'postgres';
    HostName := '127.0.0.1';
    Password := 'postgres';
    User := 'postgres';
    Port := 5432;
    Protocol := 'postgresql-8';
    TransactIsolationLevel := tiReadCommitted;
    for VAttempts := 0 to 2 do
    begin
      try
        Connect;
        if Connected then
          Break;
      except
        on E: Exception do
          LogMsg := E.Message + ' ' + HTMLLineEnding + HTMLLineEnding +
            HTMLLink(CMainURL, 'Try again') + '.';
      end;
      Sleep(2000);
    end;
  end;
end;

procedure TMainFPWebModule.indexRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
begin
  Handled := True;
  if not MainZConnection.Connected then
    AResponse.Content := LogMsg
  else
    AResponse.Content := HTMLBody('Successfully connected! :)');
end;

initialization
  RegisterHTTPModule('TMainFPWebModule', TMainFPWebModule);

end.

