unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, ExtCtrls, Buttons, IpHtml, Ipfilebroker;

type

  { TMainForm }

  TMainForm = class(TForm)
    FindBitBtn: TBitBtn;
    ResultIpFileDataProvider: TIpFileDataProvider;
    ResultIpHtmlPanel: TIpHtmlPanel;
    FindEdit: TLabeledEdit;
    ResultPanel: TPanel;
    FindPanel: TPanel;
    procedure FindBitBtnClick(Sender: TObject);
    procedure FindEditKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
  end;

const
  CURL = 'http://www.ibge.gov.br/home/geociencias/areaterritorial/area.php?nome=%s';
  CBeginTag = '<table class="v11k" border=1 cellspacing="0" cellpadding="4" bordercolor="#ffe2c6">';
  CEndTag = '</table>';
  CErrorString = 'Não foi encontrada nenhuma ocorrência da palavra procurada.';
  CHTML = '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">' + LineEnding +
          '<html>' + LineEnding +
          '<head>' + LineEnding +
          '<title></title>' + LineEnding +
          '</head>' + LineEnding +
          '<body>' + LineEnding +
            '%s' + LineEnding +
          '</body>' + LineEnding +
          '</html>';
  CResultFileName: string = 'result.html';

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  LSHTTPSend, synacode;

{ TMainForm }

procedure TMainForm.FindBitBtnClick(Sender: TObject);
var
  VResult: string;
  VHTML: TStringList;
begin
  VResult := LSHTTPGetPart(CBeginTag, CEndTag, Format(CURL, [EncodeURL(FindEdit.Text)]));
  VHTML := TStringList.Create;
  try
    if VResult <> '' then
      VHTML.Text := Format(CHTML, ['<table border=1>' + VResult + CEndTag])
    else
      VHTML.Text := Format(CHTML, [Utf8ToAnsi(CErrorString)]);
    VHTML.SaveToFile(CResultFileName);
    ResultIpHtmlPanel.OpenURL(ExpandLocalHtmlFileName(CResultFileName));
  finally
    VHTML.Free;
    DeleteFile(CResultFileName);
  end;
end;

procedure TMainForm.FindEditKeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in ['a'..'z', 'A'..'Z', '0'..'9', #8, #32]) then
    Key := #0;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  CResultFileName := ExtractFilePath(ParamStr(0)) + CResultFileName;
end;

end.

