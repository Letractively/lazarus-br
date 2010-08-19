unit Unit1; 
(*
  Notas do autor: esse 'artigo', 'curiosidade', ou até mesmo 'tutorial', foi
  escrito com a ideia de mostrar operações de Bitwise, não muito conhecidas,
  porem utilizadas dia após dia, os experts vão entender muito rapido, e até
  mesmo, achar essa curiosidade algo 'bobo', por outro lado, os fims reais
  desse pequeno artigo é mostrar uma curiosidade, como já foi falado, no
  proprio titulo desta CURIOSIDADE (novamente, é apenas uma curiosidade!).

  Autor: Bizugo/Biz/MegaNo0body/BMega/VariosOutrosApelidos = kingbizugo@gmail.com
*)



{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, CheckLst, Spin, StrUtils;

type

  { T32BoolPerInt }

  T32BoolPerInt = class
    private
      Data: cardinal;
      function GetBit(Index: integer): boolean;
      procedure SetBit(Index: integer; const AValue: boolean);
    public
      constructor Create;
      property BooleanBit[Index: integer]: boolean read GetBit write SetBit; default;
      property Flags: cardinal read Data write Data;
  end;


  { TForm1 }

  TForm1 = class(TForm)
    btnTrue: TButton;
    btnFalse: TButton;
    chklstBits: TCheckListBox;
    Label1: TLabel;
    seChangeBit: TSpinEdit;
    procedure btnFalseClick(Sender: TObject);
    procedure btnTrueClick(Sender: TObject);
    procedure chklstBitsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Valores: T32BoolPerInt;
    procedure MostrarValores;
  end;

var
  Form1: TForm1;

const
  Error_31BoolPerIntInvalidIndex: string = 'Index invalido! Usar apenas index entre 1 e 32!';

implementation

{ T32BoolPerInt }

function T32BoolPerInt.GetBit(Index: integer): boolean;
var Flag: cardinal;
begin
  if (Index >= 1) and (Index <= 32) then
  begin
    Flag := (1 shl Pred(Index));
    Result := ((Data and Flag) = Flag);
  end else
    raise Exception.Create(Error_31BoolPerIntInvalidIndex);
end;

procedure T32BoolPerInt.SetBit(Index: integer; const AValue: boolean);
var Flag: cardinal;
begin
  if (Index >= 1) and (Index <= 32) then
  begin
    Flag := (1 shl Pred(Index));
    if AValue then
      Data := Data or Flag
    else
      Data := Data and (not Flag);
  end else
    raise Exception.Create(Error_31BoolPerIntInvalidIndex);
end;

constructor T32BoolPerInt.Create;
begin
  Data := 0;
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Valores := T32BoolPerInt.Create;
  MostrarValores;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Valores.Free;
end;

procedure TForm1.MostrarValores;
var I: integer;
begin
  chklstBits.Items.BeginUpdate;
  try
    chklstBits.Items.Clear;
    for I := 1 to 32 do
    begin
      chklstBits.Items.Add('Item: '+IntToStr(I));
      chklstBits.Checked[I-1] := Valores[I];
    end;
    chklstBits.Items.Add('Flags: '+IntToStr(Valores.Flags));
  finally
    chklstBits.Items.EndUpdate;
  end;
end;

procedure TForm1.btnFalseClick(Sender: TObject);
begin
  Valores[seChangeBit.Value] := False;
  MostrarValores;
end;

procedure TForm1.btnTrueClick(Sender: TObject);
begin
  Valores[seChangeBit.Value] := True;
  MostrarValores;
end;

procedure TForm1.chklstBitsClick(Sender: TObject);
begin
  if (chklstBits.ItemIndex >= 0) and (chklstBits.ItemIndex <= 32) then
    seChangeBit.Value := chklstBits.ItemIndex + 1;
end;

initialization
  {$I unit1.lrs}

end.

