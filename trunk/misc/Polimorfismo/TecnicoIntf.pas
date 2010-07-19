unit TecnicoIntf;

{$mode objfpc}{$H+}

interface

type

  { ITecnico }

  ITecnico = interface
    ['{17A454F4-0E80-461D-BC35-6F175DB1AFF7}']
    procedure SetNome(const AValue: string);
    procedure SetSalario(const AValue: currency);
    procedure Resultado;
    function GetNome: string;
    function GetSalario: currency;
    property Nome: string read GetNome;
    property Salario: currency read GetSalario;
  end;

implementation

end.

