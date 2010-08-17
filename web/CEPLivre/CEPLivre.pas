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

unit CEPLivre;

{$mode objfpc}{$H+}

interface

uses
  HTTPSend, SynaCode, SdfData, Classes, SysUtils;

const
  CURLConsultaPorCEP =
    'http://ceplivre.pc2consultoria.com/index.php?module=cep&cep=%s&formato=csv';
  CURLConsultaPorLogradouro =
    'http://ceplivre.pc2consultoria.com/index.php?module=cep&logradouro=%s&cidade=%s&formato=csv';

type

  TTipoConsulta = (tcCEP, tcLogradouro);

  { TCEPLivre }

  TCEPLivre = class(TComponent)
  private
    FDataSet: TSdfDataSet;
    FHTTP: THTTPSend;
    FProxyHost: string;
    FProxyPass: string;
    FProxyPort: string;
    FProxyUser: string;
    FUTF8: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    function Consultar(const ACEP: ShortString = '';
      const ACidade: ShortString = ''; const ALogradouro: ShortString = '';
      const ATipoConsulta: TTipoConsulta = tcCEP): Boolean;
    property ProxyHost: string read FProxyHost write FProxyHost;
    property ProxyPort: string read FProxyPort write FProxyPort;
    property ProxyUser: string read FProxyUser write FProxyUser;
    property ProxyPass: string read FProxyPass write FProxyPass;
    property HTTP: THTTPSend read FHTTP write FHTTP;
    property DataSet: TSdfDataSet read FDataSet write FDataSet;
    property UTF8: Boolean read FUTF8 write FUTF8 default True;
  end;

implementation

{ TCEPLivre }

constructor TCEPLivre.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHTTP := THTTPSend.Create;
  FDataSet := TSdfDataSet.Create(nil);
  FHTTP.ProxyHost := FProxyHost;
  FHTTP.ProxyPass := FProxyPass;
  FHTTP.ProxyPort := FProxyPort;
  FHTTP.ProxyUser := FProxyUser;
  FDataSet.FileMustExist := True;
  FDataSet.FirstLineAsSchema := True;
  FUTF8 := True;
end;

destructor TCEPLivre.Destroy;
begin
  FHTTP.Free;
  FDataSet.Free;
  inherited Destroy;
end;

function TCEPLivre.Consultar(const ACEP: ShortString; const ACidade: ShortString;
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
      Result := HttpGetText(Format(CURLConsultaPorCEP, [ACEP]), VHTTPResult)
    else
      Result := HttpGetText(Format(CURLConsultaPorLogradouro,
        [EncodeURL(ALogradouro), EncodeURL(ACidade)]), VHTTPResult);
    if Result then
    begin
      if FUTF8 then
        for I := 0 to Pred(VHTTPResult.Count) do
          VHTTPResult.Strings[I] := AnsiToUtf8(VHTTPResult.Strings[I]);
      VHTTPResult.SaveToStream(VMemoryStream);
      FDataSet.LoadFromStream(VMemoryStream);
    end;
  finally
    VHTTPResult.Free;
    VMemoryStream.Free;
  end;
end;

end.

