unit RFB;

{$mode objfpc}{$H+}

interface

uses
  HttpUtils, RUtils, HttpSend, SynaUtil, FPJSON, Classes, SysUtils;

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

procedure RFBPrepare(out AGuid, AState, ACookie: string);
procedure RFBGetCaptcha(out AImage: TStream; const AGuid: string);
procedure RFBQuery(out AJSON: TJSONObject; const ACookie, AState, ACaptcha,
  ADocument: string);

implementation

procedure RFBPrepare(out AGuid, AState, ACookie: string);
var
  VHttp: THttpSend;
  VJSON: TJSONObject = nil;
begin
  VHttp := THttpSend.Create;
  try
    if HttpRequest(VHttp, 'GET', API_PREPARE_URL) then
    begin
      GetJSONObject(VHttp.Document, VJSON);
      AGuid := VJSON['guid'].AsString;
      AState := VJSON['state'].AsString;
      ACookie := VJSON['cookie'].AsString;
    end
    else
      raise Exception.Create(SAPIPrepareError);
  finally
    FreeAndNil(VJSON);
    VHttp.Free;
  end;
end;

procedure RFBGetCaptcha(out AImage: TStream; const AGuid: string);
var
  VHttp: THttpSend;
  VJSON: TJSONObject = nil;
begin
  VHttp := THttpSend.Create;
  AImage := TMemoryStream.Create;
  try
    if HttpRequest(VHttp, 'GET', Format(API_CAPTCHA_URL, [AGuid])) then
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

procedure RFBQuery(out AJSON: TJSONObject; const ACookie, AState, ACaptcha,
  ADocument: string);
var
  VHttp: THttpSend;
begin
  VHttp := THttpSend.Create;
  try
    WriteStrToStream(VHttp.Document,
      Format(API_QUERY_FORM, [ACookie, AState, ACaptcha]));
    VHttp.MimeType := 'application/x-www-form-urlencoded';
    if HttpRequest(VHttp, 'POST', Format(API_QUERY_URL, [ADocument])) then
      GetJSONObject(VHttp.Document, AJSON)
    else
      raise Exception.CreateFmt(SAPIQueryError, [ADocument]);
  finally
    VHttp.Free;
  end;
end;

end.

