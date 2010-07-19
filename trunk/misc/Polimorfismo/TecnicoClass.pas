unit TecnicoClass;

{$mode objfpc}{$H+}

interface

uses
  Dialogs, SysUtils, TecnicoIntf;

type

  { TTecnicoVeterano }

  TTecnicoVeterano = class(TInterfacedObject, ITecnico)
  private
    FNome: string;
    FSalario: currency;
    procedure SetNome(const Value: string);
    procedure SetSalario(const Value: currency);
    function GetNome: string;
    function GetSalario: currency;
  published
    property Nome: string read GetNome write SetNome;
    property Salario: currency read GetSalario write SetSalario;
  public
    procedure Resultado;
  end;

  { TTecnicoAprendiz }

  TTecnicoAprendiz = class(TInterfacedObject, ITecnico)
  private
    FSalario: currency;
    FNome: string;
    procedure SetNome(const Value: string);
    procedure SetSalario(const Value: currency);
    function GetNome: string;
    function GetSalario: currency;
  published
    property Nome: string read GetNome write SetNome;
    property Salario: currency read GetSalario write SetSalario;
  public
    procedure Resultado;
  end;

implementation

uses
  CurrencyUtils, TecnicoConsts;

procedure ShowResultado(const ATecnicoNome: string; const ATecnicoSalario: currency);
begin
  ShowMessage(Format(CMsgResultado, [ATecnicoNome, CurrToStrFrmt(ATecnicoSalario)]));
end;

{ TTecnicoVeterano }

function TTecnicoVeterano.GetNome: string;
begin
  Result := FNome;
end;

function TTecnicoVeterano.GetSalario: currency;
begin
  Result := FSalario;
end;

procedure TTecnicoVeterano.Resultado;
begin
  ShowResultado(FNome, FSalario);
end;

procedure TTecnicoVeterano.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TTecnicoVeterano.SetSalario(const Value: currency);
begin
  FSalario := Value * 1.8;
end;

{ TTecnicoAprendiz }

function TTecnicoAprendiz.GetNome: string;
begin
  Result := FNome;
end;

function TTecnicoAprendiz.GetSalario: currency;
begin
  Result := FSalario;
end;

procedure TTecnicoAprendiz.Resultado;
begin
  ShowResultado(FNome, FSalario);
end;

procedure TTecnicoAprendiz.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TTecnicoAprendiz.SetSalario(const Value: currency);
begin
  FSalario := Value * 1.1;
end;

end.

