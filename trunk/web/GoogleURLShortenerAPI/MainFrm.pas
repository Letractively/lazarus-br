unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, StdCtrls, LSGrids;

type

  { TMainForm }

  TMainForm = class(TForm)
    LSStringGrid1: TLSStringGrid;
    ShortenButton: TButton;
    LongURLEdit: TEdit;
    LongURLLabel: TLabel;
    procedure ShortenButtonClick(Sender: TObject);
  end;

const
  CURL = 'https://www.googleapis.com/urlshortener/v1/url';
  ClongUrlJSON = '{"longUrl": "%s"}';
  CErrorMsg = 'Não foi possível encurtar a URL "%s".';
  CResultJSON = '[%s]';

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  LSHTTPSend;

{ TMainForm }

procedure TMainForm.ShortenButtonClick(Sender: TObject);
var
  VResult: TStringStream;
begin
  VResult := TStringStream.Create('');
  try
    if LSHTTPPostJSONURL(CURL, Format(ClongUrlJSON, [LongURLEdit.Text]),
      TStream(VResult)) then
      LSStringGrid1.LoadFromJSONString(Format(CResultJSON,
        [VResult.DataString]))
    else
      ShowMessage(Format(CErrorMsg, [LongURLEdit.Text]));
  finally
    VResult.Free;
  end;
end;

end.

