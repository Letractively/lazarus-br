unit MainFPWM;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, HTTPDefs, fpHTTP, fpWeb;

type

  { TMainFPWebModule }

  TMainFPWebModule = class(TFPWebModule)
    procedure indexRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
  end;

implementation

{$R *.lfm}


{ TMainFPWebModule }

procedure TMainFPWebModule.indexRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  VFileStream: TFileStream;
begin
  VFileStream := TFileStream.Create(UTF8ToSys('image.png'), fmOpenRead);
  try
    AResponse.ContentType := 'image/png';
    AResponse.ContentStream := VFileStream;
    AResponse.SendContent;
    Handled := True;
  finally
    VFileStream.Free;
  end;
end;

initialization
  RegisterHTTPModule('TMainFPWebModule', TMainFPWebModule);

end.

