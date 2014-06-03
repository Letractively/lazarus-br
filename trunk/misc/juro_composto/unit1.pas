unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    btCalcular: TButton;
    edTotal: TEdit;
    edMeses: TEdit;
    edParcela: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure btCalcularClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  math;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  ActiveControl := edMeses;
end;

procedure TForm1.btCalcularClick(Sender: TObject);
//  M = C * (1 + i)t
//  M = Montante
//  C = Capital Inicial
//  i = Taxa de juros
//  t = Tempo

//  P = Valor da parcela
var
  i: Double;
  t: ShortInt;
  M, C, P: Currency;
begin
  C := 1000; // R$ 1.000,00 à vista
  i := 1; // 1%
  t := StrToIntDef(edMeses.Text, 0); // 5 meses
  M := C * Power(1 + (i / 100), t); // calcula montante
  P := M / t; // calcula parcela
  edParcela.Text := CurrToStrF(P, ffCurrency, 2);
  edTotal.Text := CurrToStrF(P * t, ffCurrency, 2);
end;

end.

