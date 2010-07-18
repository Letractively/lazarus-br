unit Delegacao1MainFrm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, Dialogs, StdCtrls, CalcClass;

type

  { TMainForm }

  TMainForm = class(TForm)
    ValorContabilButton: TButton;
    ValorDescontoButton: TButton;
    procedure ValorContabilButtonClick(Sender: TObject);
    procedure ValorDescontoButtonClick(Sender: TObject);
  public
    procedure ExibeValor(const AMsg: string; const AValor: currency);
  end;

  { TMeuObjeto }

  TMeuObjeto = class
  public
    function GetSum(const ACalcFunc: TCalcFunc1): currency;
    function GetSumValorContabil: currency;
    function GetSumValorDesconto: currency;
    class function CalcValorContabil(const AValue: currency): currency;
    class function CalcValorDesconto(const AValue: currency): currency;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  DelegacaoConsts;

{ TMainForm }

procedure TMainForm.ValorContabilButtonClick(Sender: TObject);
begin
  ExibeValor(CMsgValorContabil, TMeuObjeto.CalcValorContabil(50));
end;

procedure TMainForm.ValorDescontoButtonClick(Sender: TObject);
begin
  ExibeValor(CMsgValorDesconto, TMeuObjeto.CalcValorDesconto(50));
end;

procedure TMainForm.ExibeValor(const AMsg: string; const AValor: currency);
begin
  ShowMessage(Format(AMsg, [CurrToStrF(AValor, ffCurrency, 2)]));
end;

{ TMeuObjeto }

class function TMeuObjeto.CalcValorContabil(const AValue: currency): currency;
begin
  Result := AValue + CValorContabil;
end;

class function TMeuObjeto.CalcValorDesconto(const AValue: currency): currency;
begin
  Result := AValue + CValorDesconto;
end;

function TMeuObjeto.GetSum(const ACalcFunc: TCalcFunc1): currency;
begin
  Result := 0;
  // Operações com Query e etc.
  Result := ACalcFunc(Result);
end;

function TMeuObjeto.GetSumValorContabil: currency;
begin
  Result := GetSum(@CalcValorContabil);
end;

function TMeuObjeto.GetSumValorDesconto: currency;
begin
  Result := GetSum(@CalcValorDesconto);
end;

end.

