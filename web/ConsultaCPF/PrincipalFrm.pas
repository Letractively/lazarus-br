unit PrincipalFrm;

{$mode objfpc}{$H+}

interface

uses
  HttpUtils, RUtils, HttpSend, SynaUtil, Classes, SysUtils, Forms, Dialogs,
  StdCtrls, ExtCtrls, FPJSON, LCLIntf;

type
  TPrincipalForm = class(TForm)
    ConsultarButton: TButton;
    CPFEdit: TEdit;
    CaptchaImage: TImage;
    CPFLabel: TLabel;
    CaptchaEdit: TEdit;
    CaptchaLabel: TLabel;
    ObterCaptchaButton: TButton;
    procedure CaptchaEditKeyPress(Sender: TObject; var Key: char);
    procedure CPFEditKeyPress(Sender: TObject; var Key: char);
    procedure ConsultarButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ObterCaptchaButtonClick(Sender: TObject);
  private
    FGuid: string;
    FState: string;
    FCookie: string;
  public
    procedure Prepara;
    procedure ObtemCaptcha;
    procedure Consultar;
  end;

const
  URL_DOMINIO = 'http://api.silvioprog.com.br/cpf.brook/';
  URL_PREPARA = URL_DOMINIO + 'prepara';
  URL_CAPTCHA = URL_DOMINIO + 'captcha/%s';
  URL_CONSULTA = URL_DOMINIO + 'consulta/%s';
  FORMULARIO = 'cookie=%s&state=%s&captcha=%s';

resourcestring
  SErroPrepara = 'Não foi possível obter dados iniciais.';
  SErroCaptcha = 'Não foi possível obter o Captcha.';
  SErroConsulta = 'Não foi possível consultar os dados do CPF "%s".';
  SErroCPFVazio = 'Por favor, informe um CPF.';
  SErroCaptchaVazio =
    'Por favor, informa os caracteres exibidos na imagem.' + LineEnding +
    'Caso não esteja vendo os caractes, clique em "Obter nova imagem".';

var
  PrincipalForm: TPrincipalForm;

implementation

{$R *.lfm}

procedure TPrincipalForm.ObterCaptchaButtonClick(Sender: TObject);
begin
  Prepara;
  ObtemCaptcha;
end;

procedure TPrincipalForm.CPFEditKeyPress(Sender: TObject; var Key: char);
begin
  CaptchaEditKeyPress(Sender, Key);
  if Key in [' ', '.', '/', '-', 'a'..'z', 'A'..'Z'] then
    Key := #0;
end;

procedure TPrincipalForm.ConsultarButtonClick(Sender: TObject);
begin
  Consultar;
end;

procedure TPrincipalForm.CaptchaEditKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
  begin
    Consultar;
    Key := #0;
  end;
end;

procedure TPrincipalForm.FormShow(Sender: TObject);
begin
  Prepara;
  ObtemCaptcha;
end;

procedure TPrincipalForm.Prepara;
var
  VHttp: THttpSend;
  VJSON: TJSONObject = nil;
begin
  VHttp := THttpSend.Create;
  try
    if HttpRequest(VHttp, 'GET', URL_PREPARA) then
    begin
      GetJSONObject(VHttp.Document, VJSON);
      FGuid := VJSON['guid'].AsString;
      FState := VJSON['state'].AsString;
      FCookie := VJSON['cookie'].AsString;
    end
    else
      ShowMessage(SErroPrepara);
  finally
    FreeAndNil(VJSON);
    VHttp.Free;
  end;
end;

procedure TPrincipalForm.ObtemCaptcha;
var
  VHttp: THttpSend;
  VImage: TMemoryStream;
  VJSON: TJSONObject = nil;
begin
  VHttp := THttpSend.Create;
  VImage := TMemoryStream.Create;
  try
    CaptchaImage.Picture.Clear;
    if HttpRequest(VHttp, 'GET', Format(URL_CAPTCHA, [FGuid])) then
    begin
      GetJSONObject(VHttp.Document, VJSON);
      Base64ToStream(VJSON['image'].AsString, VImage);
      VImage.Position := 0;
      CaptchaImage.Picture.LoadFromStream(VImage);
    end
    else
      ShowMessage(SErroCaptcha);
  finally
    VImage.Free;
    FreeAndNil(VJSON);
    VHttp.Free;
  end;
end;

procedure TPrincipalForm.Consultar;
var
  VHttp: THttpSend;
  VJSON: TJSONObject = nil;
begin
  if Trim(CPFEdit.Text) = '' then
  begin
    ShowMessage(SErroCPFVazio);
    CPFEdit.SetFocus;
    Exit;
  end;
  if Trim(CaptchaEdit.Text) = '' then
  begin
    ShowMessage(SErroCaptchaVazio);
    CaptchaEdit.SetFocus;
    Exit;
  end;
  VHttp := THttpSend.Create;
  try
    WriteStrToStream(VHttp.Document,
      Format(FORMULARIO, [FCookie, FState, CaptchaEdit.Text]));
    VHttp.MimeType := 'application/x-www-form-urlencoded';
    if HttpRequest(VHttp, 'POST', Format(URL_CONSULTA, [CPFEdit.Text])) then
    begin
      GetJSONObject(VHttp.Document, VJSON);
      ShowMessageFmt('Nome: %s' + LineEnding + 'Situação: %s',
        [VJSON['name'].AsString, VJSON['status'].AsString]);
    end
    else
      ShowMessage(Format(SErroConsulta, [CPFEdit.Text]));
  finally
    CPFEdit.Clear;
    CaptchaEdit.Clear;
    CaptchaImage.Picture.Clear;
    FreeAndNil(VJSON);
    VHttp.Free;
  end;
end;

end.

