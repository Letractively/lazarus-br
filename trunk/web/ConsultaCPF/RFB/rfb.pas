unit RFB;

{$mode objfpc}{$H+}

interface

uses
  HttpUtils, RUtils, HttpSend, SynaUtil, FPJSON, Classes, SysUtils;

type
  TRFB = class(TObject)
  private
    FCaptcha: string;
    FDocument: string;
    FGuid: string;
    FPersonName: string;
    FPersonStatus: string;
    FQueriedDocument: string;
    FState: string;
    FCookie: string;
  public
    procedure Prepare;
    procedure GetCaptcha(out AImage: TStream);
    procedure Query;
    property Document: string read FDocument write FDocument;
    property Captcha: string read FCaptcha write FCaptcha;
    property PersonName: string read FPersonName;
    property PersonStatus: string read FPersonStatus;
    property QueriedDocument: string read FQueriedDocument;
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

implementation

procedure TRFB.Prepare;
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
      raise Exception.Create(SAPIPrepareError);
  finally
    FreeAndNil(VJSON);
    VHttp.Free;
  end;
end;

procedure TRFB.GetCaptcha(out AImage: TStream);
var
  VHttp: THttpSend;
  VJSON: TJSONObject = nil;
begin
  VHttp := THttpSend.Create;
  AImage := TMemoryStream.Create;
  try
    if HttpRequest(VHttp, 'GET', Format(API_CAPTCHA_URL, [FGuid])) then
    begin
      GetJSONObject(VHttp.Document, VJSON);
      Base64ToStream(VJSON['image'].AsString, AImage);
      AImage.Position := 0;
    end
    else
      raise Exception.Create(SAPICaptchaError);
  finally
    FreeAndNil(VJSON);
    VHttp.Free;
  end;
end;

procedure TRFB.Query;
var
  VHttp: THttpSend;
  VJSON: TJSONObject = nil;
begin
  VHttp := THttpSend.Create;
  try
    WriteStrToStream(VHttp.Document,
      Format(API_QUERY_FORM, [FCookie, FState, FCaptcha]));
    VHttp.MimeType := 'application/x-www-form-urlencoded';
    if HttpRequest(VHttp, 'POST', Format(API_QUERY_URL, [FDocument])) then
    begin
      GetJSONObject(VHttp.Document, VJSON);
      FPersonName := VJSON['name'].AsString;
      FPersonStatus := VJSON['status'].AsString;
      FQueriedDocument := VJSON['querieddocument'].AsString;
    end
    else
      raise Exception.CreateFmt(SAPIQueryError, [FDocument]);
  finally
    FreeAndNil(VJSON);
    VHttp.Free;
  end;
end;

end.

