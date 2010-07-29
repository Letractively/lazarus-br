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

unit ChequeExceptionHandle;

{$I cheques.inc}

interface

uses
  SysUtils, LCLProc, LCLType, Forms, ChequeConsts;

type

  { TErrorDialogType }

  TErrorDialogType = (edtError, edtAsterick);

  { TChequesExceptionHandle }

  TChequeExceptionHandle = class
  private
    procedure OnExceptionHandler(Sender: TObject; E: Exception);
  public
    class procedure Register(const ADialogType: TErrorDialogType = edtError);
    class procedure ShowErrorMsg(const AMsg: string; const AAbort: Boolean;
      const ADialogType: TErrorDialogType = edtError);
  end;

function ExistsSentenceInString(const ASentence, AString: string): Boolean;

implementation

var
  _DialogType: TErrorDialogType = edtError;

function ExistsSentenceInString(const ASentence, AString: string): Boolean;
begin
  Result := UTF8Pos(UTF8LowerCase(ASentence), UTF8LowerCase(AString)) <> 0;
end;

{ TChequesExceptionHandle }

procedure TChequeExceptionHandle.OnExceptionHandler(Sender: TObject; E: Exception);

  function _ValidateExceptionMsg(const AMsg: string;
    out AErrorDialogType: TErrorDialogType): string;
  const
    _CFKError = 'foreign key';
    _CFormateDateError = 'invalid date';
    _C0RecordsUpdatedError =
      '0 record(s) updated. Only one record should have been updated.';
  begin
    if ExistsSentenceInString(_CFKError, AMsg) then
    begin
      AErrorDialogType := edtError;
      Result := CFKError;
    end
    else
    if ExistsSentenceInString(_CFormateDateError, AMsg) then
    begin
      AErrorDialogType := edtAsterick;
      Result := CFormateDateError;
    end
    else
    if ExistsSentenceInString(_C0RecordsUpdatedError, AMsg) then
    begin
      AErrorDialogType := edtAsterick;
      Result := C0RecordsUpdatedError;
    end
    else
      Result := '';
  end;

var
  S: string;
  VErrorDialogType: TErrorDialogType;
begin
  S := _ValidateExceptionMsg(E.Message, VErrorDialogType);
  if S <> '' then
    ShowErrorMsg(S, False, VErrorDialogType)
  else
    case _DialogType of
      edtError: ShowErrorMsg(E.Message, False, edtError);
      edtAsterick: ShowErrorMsg(E.Message, False, edtAsterick);
    end;
end;

class procedure TChequeExceptionHandle.Register(const ADialogType: TErrorDialogType);
begin
  Application.Flags := Application.Flags + [AppNoExceptionMessages];
  _DialogType := ADialogType;
  Application.AddOnExceptionHandler(@OnExceptionHandler);
end;

class procedure TChequeExceptionHandle.ShowErrorMsg(const AMsg: string;
  const AAbort: Boolean; const ADialogType: TErrorDialogType);

  procedure _MessageBox(const AFlags: longint);
  begin
    Application.MessageBox(PChar(AMsg), PChar(Application.Title), AFlags);
  end;

begin
  case ADialogType of
    edtError: _MessageBox(MB_ICONERROR + MB_OK);
    edtAsterick: _MessageBox(MB_ICONASTERICK + MB_OK);
  end;
  if AAbort then
    Abort;
end;

initialization
  TChequeExceptionHandle.Register;

end.

