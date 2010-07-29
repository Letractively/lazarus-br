(*
  Cheques 2.1, Controle pessoal de cheques.
  Copyright (C) 2010-2012 Everaldo - arcanjoebc@gmail.com

  See the file LGPL.2.1_modified.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

(*
  Powerfull contributors:
  Silvio Clecio - http://blog.silvioprog.com.br
  Joao Morais   - http://blog.joaomorais.com.br
  Luiz Americo  - http://lazarusroad.blogspot.com
*)

unit ChequeUtils;

{$I cheques.inc}

interface

uses
  ChequeConsts, ChequeClasses, ChequeExceptionHandle, DB, ZConnection, StrUtils,
  SysUtils;

function FormatSearchFromDataObject(const AZConnection: TZConnection;
  const ADataObject: TDataObject = nil;
  const AOrderBy: string = CDefaultOrderByField): string;
function GetCurrentProtocol(const AZConnection: TZConnection): TCurrentProtocol;

implementation

function FormatSearchFromDataObject(const AZConnection: TZConnection;
  const ADataObject: TDataObject = nil;
  const AOrderBy: string = CDefaultOrderByField): string;
var
  VCurrentProtocol: TCurrentProtocol;

  function _PreFormat(const AFieldName: string; const AValue: Variant): string;
  begin
    case ADataObject.FieldType of
      ftBoolean:
      begin
        if VCurrentProtocol = cpSQLite then
          Result := Format(CLikeBoolean,
            [AFieldName, StringsReplace(LowerCase(AValue),
            ['sim', 'nao', 'não', 's', 'n'], ['y', 'y', 'n', 'y', 'n'],
            [rfReplaceAll])])
        else
        if VCurrentProtocol = cpPostgreSQL then
          Result := Format(CLikeBooleanPg,
            [AFieldName, StringsReplace(LowerCase(AValue),
            ['sim', 'nao', 'não', 's', 'n'], ['t', 'f', 'f', 't', 'f'],
            [rfReplaceAll])])
        else
          Result := Format(CLikeBoolean,
            [AFieldName, StringsReplace(LowerCase(AValue),
            ['sim', 'nao', 'não', 's', 'n'], ['t', 'f', 'f', 't', 'f'],
            [rfReplaceAll])]);
      end;
      ftString, ftMemo: Result :=
          Format(CLikeString, [AFieldName, LowerCase(AValue)]);
      ftSmallint, ftInteger, ftFloat, ftCurrency: Result :=
          Format(CLikeNumber, [AFieldName, StringsReplace(AValue,
          [CDecimalSeparator], [CThousandSeparator], [rfReplaceAll])]);
      ftDate, ftTime, ftDateTime:
      begin
        if VCurrentProtocol = cpSQLite then
          Result := Format(CLikeDate,
            [AFieldName, FormatDateTime(CSQLiteDateFrmt, AValue)])
        else
        if VCurrentProtocol = cpFirebird then
          Result := Format(CLikeDate,
            [AFieldName, FormatDateTime(CFirebirdDateFrmt, AValue)])
        else
          Result := Format(CLikeDate,
            [AFieldName, FormatDateTime(CPgDateFrmt, AValue)]);
      end;
    end;
  end;

begin
{ Format search query conforms data type. }

  VCurrentProtocol := GetCurrentProtocol(AZConnection);
  if (ADataObject.Value = '') or (ADataObject.Value = CDefaultSearchEditText) then
    TChequeExceptionHandle.ShowErrorMsg(
      CRequestSearchValue, True, edtAsterick);
  if (ADataObject.FKSearchField <> '') and (ADataObject.FKTable <> '') and
    (ADataObject.FKKey <> '') then
  begin
    if VCurrentProtocol = cpFirebird then
      Result := Format(CFKSQLFirebird, [ADataObject.FieldName,
        ADataObject.FKKey, ADataObject.FKTable,
        _PreFormat(ADataObject.FKSearchField, ADataObject.Value)])
    else
      Result := Format(CFKSQLPgSQLite, [ADataObject.FieldName,
        ADataObject.FKKey, ADataObject.FKTable,
        _PreFormat(ADataObject.FKSearchField, ADataObject.Value), ADataObject.FKKey]);
  end
  else
    Result := _PreFormat(ADataObject.FieldName, ADataObject.Value);
  Result := Result + AOrderBy;
end;

function GetCurrentProtocol(const AZConnection: TZConnection): TCurrentProtocol;

  function _LowerCaseProtocol: string;
  begin
    Result := LowerCase(AZConnection.Protocol);
  end;

begin
  if Pos(CPgProtocol, _LowerCaseProtocol) <> 0 then
    Result := cpPostgreSQL
  else
  if Pos(CSQLiteProtocol, _LowerCaseProtocol) <> 0 then
    Result := cpSQLite
  else
  if Pos(CFirebirdProtocol, _LowerCaseProtocol) <> 0 then
    Result := cpFirebird
  else
    Result := cpUnknow;
end;

initialization
  CurrencyString := CCurrencyString;
  CurrencyFormat := CCurrencyFormat;
  CurrencyDecimals := CCurrencyDecimals;
  NegCurrFormat := CNegCurrFormat;
  ThousandSeparator := CThousandSeparator;
  DecimalSeparator := CDecimalSeparator;
  TimeSeparator := CTimeSeparator;
  TimeAMString := CTimeAMString;
  TimePMString := CTimePMString;
  DateSeparator := CDateSeparator;
  ShortTimeFormat := CShortTimeFormat;
  ShortDateFormat := CShortDateFormat;

end.

