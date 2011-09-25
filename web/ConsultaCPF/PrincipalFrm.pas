unit PrincipalFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, StdCtrls, ExtCtrls;

type

  { TPrincipalForm }

  TPrincipalForm = class(TForm)
    ConsultarButton: TButton;
    CPFEdit: TEdit;
    CaptchaImage: TImage;
    CPFLabel: TLabel;
    CaptchaEdit: TEdit;
    CaptchaLabel: TLabel;
    NomePessoaFisicaLabel: TLabel;
    ObterCaptchaButton: TButton;
    procedure CaptchaEditKeyPress(Sender: TObject; var Key: char);
    procedure CPFEditKeyPress(Sender: TObject; var Key: char);
    procedure ConsultarButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ObterCaptchaButtonClick(Sender: TObject);
  private
    FCookieCaptcha: string;
    FCookieConsultaPublica: string;
  public
    procedure ObtemCaptcha;
    procedure ConsultaPublica;
    procedure ConsultaPublicaExibir;
  end;

const
  CURLDominio = 'http://www.receita.fazenda.gov.br/';
  CURLConsultaPublica = CURLDominio +
    'aplicacoes/atcta/cpf/ConsultaPublica.asp';
  CURLCaptcha = CURLDominio +
    'scripts/srf/intercepta/captcha.aspx?opt=image&v=%d';
  CFormulario = 'txtCPF=%s&idLetra=%s&Enviar=Consultar';
  CTagInicio = 'Nome da Pessoa Física:';
  CTagFim = '</span>';

resourcestring
  SErroConsultaPublica =
    'Não foi possível obter dados iniciais do site da Receita Federal.';
  SErroConsultaPublicaExibir =
    'Não foi possível consultar os dados do CPF "%s".';
  SErroCaptcha = 'Não foi possível obter o Captcha.';
  SAvisoCPFVazio = 'Por favor, informe um CPF.';
  SAvisoCaptchaVazio =
    'Por favor, informa os caracteres exibidos na imagem.' + LineEnding +
    'Caso não esteja vendo os caractes, clique em "Obter nova imagem".';

var
  PrincipalForm: TPrincipalForm;

implementation

{$R *.lfm}

uses
  LSHTTPSend, LSUtils, HTTPSend, LCLProc;

{ TPrincipalForm }

procedure TPrincipalForm.ObterCaptchaButtonClick(Sender: TObject);
begin
  ObtemCaptcha;
  ConsultaPublica;
end;

procedure TPrincipalForm.CPFEditKeyPress(Sender: TObject; var Key: char);
begin
  CaptchaEditKeyPress(Sender, Key);
  if Key in [' ', '.', '/', '-', 'a'..'z', 'A'..'Z'] then
    Key := #0;
end;

procedure TPrincipalForm.ConsultarButtonClick(Sender: TObject);
begin
  ConsultaPublicaExibir;
end;

procedure TPrincipalForm.CaptchaEditKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
  begin
    ConsultaPublicaExibir;
    Key := #0;
  end;
end;

procedure TPrincipalForm.FormShow(Sender: TObject);
begin
  ObtemCaptcha;
  ConsultaPublica;
end;

procedure TPrincipalForm.ObtemCaptcha;
var
  VManequim: string = '';
  VHTTPSend: THTTPSend;
begin
  VHTTPSend := THTTPSend.Create;
  try
    if LSHTTPGetPictureEx(VHTTPSend, CURLCaptcha, CaptchaImage.Picture,
      VManequim, VManequim) then
      FCookieCaptcha := Trim(VHTTPSend.Cookies.Text)
    else
      ShowMessage(SErroCaptcha);
  finally
    VHTTPSend.Free;
  end;
end;

procedure TPrincipalForm.ConsultaPublica;
var
  VHTTPSend: THTTPSend;
  VManequim: TStringList;
begin
  VHTTPSend := THTTPSend.Create;
  VManequim := TStringList.Create;
  try
    if not LSHTTPGetTextEx(VHTTPSend, CURLConsultaPublica, VManequim) then
      ShowMessage(SErroConsultaPublica)
    else
      FCookieConsultaPublica := Trim(VHTTPSend.Cookies.Text);
  finally
    VManequim.Free;
    VHTTPSend.Free;
  end;
end;

procedure TPrincipalForm.ConsultaPublicaExibir;
var
  VCookies: TStrings;
  VStream: TMemoryStream;
  VNomePessoaFisica: string = '';
begin
  if Trim(CPFEdit.Text) = '' then
  begin
    ShowMessage(SAvisoCPFVazio);
    CPFEdit.SetFocus;
    Exit;
  end;
  if Trim(CaptchaEdit.Text) = '' then
  begin
    ShowMessage(SAvisoCaptchaVazio);
    CaptchaEdit.SetFocus;
    Exit;
  end;
  VCookies := TStringList.Create;
  VStream := TMemoryStream.Create;
  try
    VCookies.Add(FCookieConsultaPublica);
    VCookies.Add(FCookieCaptcha);
    if LSHTTPPostURL(CURLConsultaPublica, Format(CFormulario,
      [CPFEdit.Text, CaptchaEdit.Text]), VCookies, VStream) then
    begin
      VNomePessoaFisica := LSDeleteLineBreaks(LSStreamToStr(VStream));
      NomePessoaFisicaLabel.Caption := 'Nome da pessoa física: ' +
        Trim(GetPart(Utf8ToAnsi(CTagInicio), CTagFim, VNomePessoaFisica,
        True, False));
    end
    else
      ShowMessage(Format(SErroConsultaPublicaExibir, [CPFEdit.Text]));
  finally
    CPFEdit.Clear;
    CaptchaEdit.Clear;
    CaptchaImage.Picture.Clear;
    VCookies.Free;
    VStream.Free;
  end;
end;

end.

