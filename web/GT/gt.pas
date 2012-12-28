unit GT;

{$mode objfpc}{$H+}

interface

uses
  BrookAction, HTTPDefs, SysUtils, HttpUtils, RUtils;

type
  TTest = class(TBrookAction)
  public
    procedure Get; override;
    procedure Post; override;
  end;

const
  _URL =
    'http://translate.google.com.br/translate_a/t?client=t&text=%s&hl=pt-BR&' +
    'sl=pt&tl=en&ie=UTF-8&oe=UTF-8&multires=1&prev=btn&ssel=4&tsel=6&sc=1';
  _FORM = {$i form.inc}

implementation

procedure TTest.Get;
begin
  Write(_FORM);
end;

procedure TTest.Post;

  function ProcessaSaida(const s: string): string;
  begin
    Result := StringReplace(s, ',,', ',', [rfReplaceAll]);
  end;

var
  S: string;
begin
  S := ProcessaSaida(HttpGetText(Format(_URL, [Fields['word'].AsString])));
  S := ProcessaSaida(S);
  Write(S);
end;

initialization
  TTest.Register('*');

end.
