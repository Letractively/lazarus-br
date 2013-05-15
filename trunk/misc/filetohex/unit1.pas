unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
const
  hexchar: array[0..15] of char = '0123456789ABCDEF';
var
  f: tfilestream;
  b: byte;
  sz: int64;
  s: string;
  p: pchar;
  buf: array of byte;
begin
  f := tfilestream.create('entrada.txt', fmopenread or fmsharedenywrite);
  try
    sz := f.size; // pego o tamanho real do arquivo
    setlength(buf, sz); // inicializo minha matriz de bytes no mesmo tamanho do arquivo
    f.read(pointer(buf)^, sz); // leio byte a byte do arquivo diretamente no endereço da minha matriz
    setlength(s, sz*2); // dimensiono a string no tamanho arquivo * 2, pois um "a" em hexa seria 61, "b" 62 e assim sucessivamente
    p := pchar(s); // pego o endereço da minha string, apontando esse pointer pra ela
    for b in buf do // dou um loop pegando byte a byte da minha matriz, que está com todos os bytes do aquivo que li
    begin
      p^ := hexchar[b shr 4]; // pego o dígito esquerdo do código do caractere
      inc(p); // pulo para a próxima posição disponível da minha string
      p^ := hexchar[b and $0f]; // pego o dígito direito do código do caractere
      inc(p); // pulo para a próxima posição disponível da minha string
      { então aqui para cada caractere eu incremento dois dígitos em minha string, ex: a = 61 }
    end;
    memo1.text := s;
    with tfilestream.create('saida-hex.txt', fmcreate) do
    try
      write(pointer(s)^, sz*2);
    finally
      free;
    end;
  finally
    f.free;
  end;
end;

end.

