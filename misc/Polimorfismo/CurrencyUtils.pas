unit CurrencyUtils;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

function CurrToStrFrmt(const AValue: currency): string;
function FormatStrToCurrStr(const AValue: string): string;
function FormatCurrStrToStr(const AValue: string): string;
function StrToCurrDef0(const AValue: string): currency;

implementation

function CurrToStrFrmt(const AValue: currency): string;
begin
  Result := CurrToStrF(AValue, ffCurrency, 2);
end;

function FormatStrToCurrStr(const AValue: string): string;
begin
  Result := CurrToStrFrmt(StrToCurrDef(AValue, 0));
end;

function FormatCurrStrToStr(const AValue: string): string;
begin
  Result := Copy(AValue, Succ(Length(CurrencyString)), Length(AValue) -
    Length(CurrencyString));
end;

function StrToCurrDef0(const AValue: string): currency;
begin
  Result := StrToCurrDef(FormatCurrStrToStr(AValue), 0);
end;

end.

