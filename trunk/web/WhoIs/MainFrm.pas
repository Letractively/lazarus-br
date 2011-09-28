unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, StdCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    InfoLabel: TLabel;
    WWWLabel: TLabel;
    WhoIsButton: TButton;
    URLEdit: TEdit;
    procedure WhoIsButtonClick(Sender: TObject);
  end;

const
  CURLRegistro = 'http://registro.br/cgi-bin/nicbr/whois?qr=%s';

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  LSHTTPSend, LCLIntf, HTTPSend;

{ TMainForm }

procedure TMainForm.WhoIsButtonClick(Sender: TObject);
var
  VFile: string;
  VDummy: TStringList = nil;
  VHTTPSend: THTTPSend;
begin
  VHTTPSend := THTTPSend.Create;
  try
    VFile := GetTempDir + 'whois.html';
    LSHTTPGetTextEx(VHTTPSend, Format(CURLRegistro, [URLEdit.Text]), VDummy);
    VHTTPSend.Document.SaveToFile(VFile);
    OpenDocument(VFile);
  finally
    VHTTPSend.Free;
  end;
end;

end.

