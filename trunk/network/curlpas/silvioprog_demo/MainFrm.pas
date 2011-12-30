unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, Dialogs, StdCtrls, SysUtils;

type

  { TMainForm }

  TMainForm = class(TForm)
    GetButton: TButton;
    procedure GetButtonClick(Sender: TObject);
  end;

const
  CURL = 'http://curl.haxx.se/';
  CFileName = 'curl.html';

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  LazcURL, LCLIntf;

{ TMainForm }

procedure TMainForm.GetButtonClick(Sender: TObject);
var
  VCurl: TCurl;
  VFileName: TFileName;
begin
  VCurl := TCurl.Create(nil);
  try
    VFileName := ExtractFilePath(ParamStr(0)) + CFileName;
    VCurl.URL := CURL;
    VCurl.OutputFile := VFileName;
    if VCurl.Perform then
      OpenURL(VFileName)
    else
      ShowMessage(VCurl.ErrorString);
  finally
    VCurl.Free;
  end;
end;

end.

