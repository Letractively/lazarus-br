(*
  Unit CEPLivre 1.0, Consultar CEP online gratuitamente.
  Copyright (C) 2010-2012 Silvio Clecio - admin@silvioprog.com.br

  http://blog.silvioprog.com.br

  See the file LGPL.2.1_modified.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

(*
  Powerfull contributors
  . Daniel Simões de Almeida
  . Kingbizugo
*)

unit CEPLivre;

{$mode objfpc}{$H+}

interface

uses
  HTTPSend, SynaCode, Classes, SysUtils, mysdfdata;

const
  CURLConsultaPorCEP =
    'http://ceplivre.pc2consultoria.com/index.php?module=cep&cep=%s&formato=csv';
  CURLConsultaPorLogradouro =
    'http://ceplivre.pc2consultoria.com/index.php?module=cep&logradouro=%s&cidade=%s&formato=csv';

type

  TTipoConsulta = (tcCEP, tcLogradouro);

  { TCEPLivre }

  TCEPLivre = class(TCustomSdfDataSet)
  private
    FOnSucesso: TNotifyEvent;
    FProxyHost: string;
    FProxyPass: string;
    FProxyPort: string;
    FProxyUser: string;
    FUTF8: Boolean;
  public
    property Delimiter;
    property FirstLineAsSchema;
  public
    constructor Create(AOwner: TComponent); override;
    function HTTPGetString(const AURL: string; const AResponse: TStrings;
      out AResultCode: Integer): Boolean;
    function Consultar(out ACodigoRespostaHTTP: Integer;
      const ACEP: ShortString = ''; const ACidade: ShortString = '';
      const ALogradouro: ShortString = '';
      const ATipoConsulta: TTipoConsulta = tcCEP): Boolean;
  published
    property ProxyHost: string read FProxyHost write FProxyHost;
    property ProxyPort: string read FProxyPort write FProxyPort;
    property ProxyUser: string read FProxyUser write FProxyUser;
    property ProxyPass: string read FProxyPass write FProxyPass;
    property UTF8: Boolean read FUTF8 write FUTF8 default True;
    property OnSucesso: TNotifyEvent read FOnSucesso write FOnSucesso;
  end;

implementation

{ TCEPLivre }

constructor TCEPLivre.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FileMustExist := True;
  FirstLineAsSchema := True;
  FUTF8 := True;
end;

function TCEPLivre.HTTPGetString(const AURL: string; const AResponse: TStrings;
  out AResultCode: Integer): Boolean;
var
  VHTTPSend: THTTPSend;
begin
  VHTTPSend := THTTPSend.Create;
  try
    VHTTPSend.ProxyHost := FProxyHost;
    VHTTPSend.ProxyPass := FProxyPass;
    VHTTPSend.ProxyPort := FProxyPort;
    VHTTPSend.ProxyUser := FProxyUser;
    Result := VHTTPSend.HTTPMethod('GET', AURL) and (VHTTPSend.ResultCode = 200);
    AResultCode := VHTTPSend.ResultCode;
    if Result then
      AResponse.LoadFromStream(VHTTPSend.Document);
  finally
    VHTTPSend.Free;
  end;
end;

function TCEPLivre.Consultar(out ACodigoRespostaHTTP: Integer;
  const ACEP: ShortString; const ACidade: ShortString;
  const ALogradouro: ShortString; const ATipoConsulta: TTipoConsulta): Boolean;
var
  I: Integer;
  VHTTPResult: TStringList;
  VMemoryStream: TMemoryStream;
begin
  VHTTPResult := TStringList.Create;
  VMemoryStream := TMemoryStream.Create;
  try
    if ATipoConsulta = tcCEP then
      Result := HTTPGetString(Format(CURLConsultaPorCEP, [ACEP]), VHTTPResult,
        ACodigoRespostaHTTP)
    else
      Result := HTTPGetString(Format(CURLConsultaPorLogradouro,
        [EncodeURL(ALogradouro), EncodeURL(ACidade)]), VHTTPResult,
        ACodigoRespostaHTTP);
    if Result then
    begin
      if FUTF8 then
        for I := 0 to Pred(VHTTPResult.Count) do
          VHTTPResult.Strings[I] := AnsiToUtf8(VHTTPResult.Strings[I]);
      VHTTPResult.SaveToStream(VMemoryStream);
      LoadFromStream(VMemoryStream);
      if Assigned(FOnSucesso) then
        FOnSucesso(Self);
    end;
  finally
    VHTTPResult.Free;
    VMemoryStream.Free;
  end;
end;

end.

