unit frmMain;

{$mode objfpc}{$H+}

interface

uses
  HttpUtils, RUtils, HttpSend, SynaUtil, Classes, SysUtils, Forms, Dialogs,
  StdCtrls, ExtCtrls, FPJSON, LCLIntf;

type
  TfrMain = class(TForm)
    btQuery: TButton;
    edDocument: TEdit;
    imCaptcha: TImage;
    lbDocument: TLabel;
    edCaptcha: TEdit;
    lbCaptcha: TLabel;
    btGetCaptcha: TButton;
    procedure edCaptchaKeyPress(Sender: TObject; var Key: char);
    procedure edDocumentKeyPress(Sender: TObject; var Key: char);
    procedure btQueryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btGetCaptchaClick(Sender: TObject);
  private
    FGuid: string;
    FState: string;
    FCookie: string;
  public
    procedure Prepare;
    procedure GetCaptcha;
    procedure Query;
  end;

const
  API_DOMAIN_URL = 'http://api.silvioprog.com.br/rfb.brook/cpf/';
  API_PREPARE_URL = API_DOMAIN_URL + 'prepare';
  API_CAPTCHA_URL = API_DOMAIN_URL + 'captcha/%s';
  API_QUERY_URL = API_DOMAIN_URL + 'query/%s';
  API_QUERY_FORM = 'cookie=%s&state=%s&captcha=%s';

var
  SAPIPrepareError: string = 'Não foi possível obter dados iniciais.';
  SAPICaptchaError: string = 'Não foi possível obter Captcha.';
  SAPIQueryError: string = 'Não foi possível obter dados para o documento "%s".';
  SEmptyDocumentError: string = 'Por favor, informe o número do documento.';
  SEmptyCaptchaError: string =
    'Por favor, informe corretamente os caracteres exibidos na imagem ao lado.' +
    LineEnding + 'Caso não esteja vendo os caractes, clique em "Obter nova imagem".';

var
  frMain: TfrMain;

implementation

{$R *.lfm}

procedure TfrMain.btGetCaptchaClick(Sender: TObject);
begin
  Prepare;
  GetCaptcha;
end;

procedure TfrMain.edDocumentKeyPress(Sender: TObject; var Key: char);
begin
  edCaptchaKeyPress(Sender, Key);
  if Key in [' ', '.', '/', '-', 'a'..'z', 'A'..'Z'] then
    Key := #0;
end;

procedure TfrMain.btQueryClick(Sender: TObject);
begin
  Query;
end;

procedure TfrMain.edCaptchaKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
  begin
    Query;
    Key := #0;
  end;
end;

procedure TfrMain.FormShow(Sender: TObject);
begin
  Prepare;
  GetCaptcha;
end;

procedure TfrMain.Prepare;
var
  VHttp: THttpSend;
  VJSON: TJSONObject = nil;
begin
  VHttp := THttpSend.Create;
  try
    if HttpRequest(VHttp, 'GET', API_PREPARE_URL) then
    begin
      GetJSONObject(VHttp.Document, VJSON);
      FGuid := VJSON['guid'].AsString;
      FState := VJSON['state'].AsString;
      FCookie := VJSON['cookie'].AsString;
    end
    else
      ShowMessage(SAPIPrepareError);
  finally
    FreeAndNil(VJSON);
    VHttp.Free;
  end;
end;

procedure TfrMain.GetCaptcha;
var
  VHttp: THttpSend;
  VImage: TMemoryStream;
  VJSON: TJSONObject = nil;
begin
  VHttp := THttpSend.Create;
  VImage := TMemoryStream.Create;
  try
    imCaptcha.Picture.Clear;
    if HttpRequest(VHttp, 'GET', Format(API_CAPTCHA_URL, [FGuid])) then
    begin
      GetJSONObject(VHttp.Document, VJSON);
      Base64ToStream(VJSON['image'].AsString, VImage);
      VImage.Position := 0;
      imCaptcha.Picture.LoadFromStream(VImage);
    end
    else
      ShowMessage(SAPICaptchaError);
  finally
    VImage.Free;
    FreeAndNil(VJSON);
    VHttp.Free;
  end;
end;

procedure TfrMain.Query;
var
  VHttp: THttpSend;
  VJSON: TJSONObject = nil;
begin
  if Trim(edDocument.Text) = '' then
  begin
    ShowMessage(SEmptyDocumentError);
    edDocument.SetFocus;
    Exit;
  end;
  if Trim(edCaptcha.Text) = '' then
  begin
    ShowMessage(SEmptyCaptchaError);
    edCaptcha.SetFocus;
    Exit;
  end;
  VHttp := THttpSend.Create;
  try
    WriteStrToStream(VHttp.Document,
      Format(API_QUERY_FORM, [FCookie, FState, edCaptcha.Text]));
    VHttp.MimeType := 'application/x-www-form-urlencoded';
    if HttpRequest(VHttp, 'POST', Format(API_QUERY_URL, [edDocument.Text])) then
    begin
      GetJSONObject(VHttp.Document, VJSON);
      ShowMessageFmt('Nome: %s' + LineEnding + 'Situação: %s' + LineEnding +
        'Documento: %s', [VJSON['name'].AsString, VJSON['status'].AsString,
        VJSON['querieddocument'].AsString]);
    end
    else
      ShowMessage(Format(SAPIQueryError, [edDocument.Text]));
  finally
    edDocument.Clear;
    edCaptcha.Clear;
    imCaptcha.Picture.Clear;
    FreeAndNil(VJSON);
    VHttp.Free;
  end;
end;

end.

