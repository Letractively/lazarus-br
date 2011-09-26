unit PrincipalFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, StdCtrls, ExtCtrls;

type

  { TPrincipalForm }

  TPrincipalForm = class(TForm)
    ConsultarButton: TButton;
    CNPJEdit: TEdit;
    CaptchaImage: TImage;
    CNPJLabel: TLabel;
    CaptchaEdit: TEdit;
    CaptchaLabel: TLabel;
    NomeEmpresarialLabel: TLabel;
    ObterCaptchaButton: TButton;
    procedure CaptchaEditKeyPress(Sender: TObject; var Key: char);
    procedure CNPJEditKeyPress(Sender: TObject; var Key: char);
    procedure ConsultarButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ObterCaptchaButtonClick(Sender: TObject);
  private
    FCookieCaptcha: string;
    FCookieSolicitacao: string;
  public
    procedure ObtemCaptcha;
    procedure Solicitacao;
    procedure Valida;
  end;

const
  CURLDominio = 'http://www.receita.fazenda.gov.br/';
  CURLSolicitacao = CURLDominio +
    'pessoajuridica/cnpj/cnpjreva/cnpjreva_solicitacao2.asp';
  CURLValida = CURLDominio + 'PessoaJuridica/CNPJ/cnpjreva/valida.asp';
  CURLCaptcha = CURLDominio +
    'scripts/srf/intercepta/captcha.aspx?opt=image&v=%d';
  CFormulario =
    'origem=comprovante&cnpj=%s&idLetra=%s&idSom=&submit1=Consultar&search_type=cnpj';
  CTagInicio =
    'NOME EMPRESARIAL  		</font>    		<br>    		<font face="Arial" style="font-size: 8pt">  		<b>';
  CTagFim = '</b>';

resourcestring
  SErroSolicitacao =
    'Não foi possível obter dados iniciais do site da Receita Federal.';
  SErroValida =
    'Não foi possível consultar os dados do CNPJ "%s".';
  SErroCaptcha = 'Não foi possível obter o Captcha.';
  SAvisoCNPJVazio = 'Por favor, informe um CNPJ.';
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
  Solicitacao;
end;

procedure TPrincipalForm.CNPJEditKeyPress(Sender: TObject; var Key: char);
begin
  CaptchaEditKeyPress(Sender, Key);
  if Key in [' ', '.', '/', '-', 'a'..'z', 'A'..'Z'] then
    Key := #0;
end;

procedure TPrincipalForm.ConsultarButtonClick(Sender: TObject);
begin
  Valida;
end;

procedure TPrincipalForm.CaptchaEditKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
  begin
    Valida;
    Key := #0;
  end;
end;

procedure TPrincipalForm.FormShow(Sender: TObject);
begin
  ObtemCaptcha;
  Solicitacao;
end;

procedure TPrincipalForm.ObtemCaptcha;
var
  VManequim: string = '';
  VHTTPSend: THTTPSend;
begin
  VHTTPSend := THTTPSend.Create;
  try
    if LSHTTPGetPictureEx(VHTTPSend, Format(CURLCaptcha, [LSGetTime]),
      CaptchaImage.Picture, VManequim, VManequim) then
      FCookieCaptcha := Trim(VHTTPSend.Cookies.Text)
    else
      ShowMessage(SErroCaptcha);
  finally
    VHTTPSend.Free;
  end;
end;

procedure TPrincipalForm.Solicitacao;
var
  VHTTPSend: THTTPSend;
  VManequim: TStringList;
begin
  VHTTPSend := THTTPSend.Create;
  VManequim := TStringList.Create;
  try
    if not LSHTTPGetTextEx(VHTTPSend, CURLSolicitacao, VManequim) then
      ShowMessage(SErroSolicitacao)
    else
      FCookieSolicitacao := Trim(VHTTPSend.Cookies.Text);
  finally
    VManequim.Free;
    VHTTPSend.Free;
  end;
end;

procedure TPrincipalForm.Valida;
var
  VCookies: TStrings;
  VStream: TMemoryStream;
  VNomeEmpresarial: string = '';
begin
  if Trim(CNPJEdit.Text) = '' then
  begin
    ShowMessage(SAvisoCNPJVazio);
    CNPJEdit.SetFocus;
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
    VCookies.Add(FCookieSolicitacao);
    VCookies.Add(FCookieCaptcha);
    if LSHTTPPostURL(CURLValida, Format(CFormulario,
      [CNPJEdit.Text, CaptchaEdit.Text]), VCookies, VStream) then
    begin
      VNomeEmpresarial := LSDeleteLineBreaks(LSStreamToStr(VStream));
      NomeEmpresarialLabel.Caption := 'Nome empresarial: ' +
        GetPart(CTagInicio, CTagFim, VNomeEmpresarial, True, False);
    end
    else
      ShowMessage(Format(SErroValida, [CNPJEdit.Text]));
  finally
    CNPJEdit.Clear;
    CaptchaEdit.Clear;
    CaptchaImage.Picture.Clear;
    VCookies.Free;
    VStream.Free;
  end;
end;

end.

