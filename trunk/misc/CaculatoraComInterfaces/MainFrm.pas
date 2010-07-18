unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, Dialogs, ExtCtrls, StdCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    CalcularButton: TButton;
    XEdit: TEdit;
    YEdit: TEdit;
    OperacaoRadioGroup: TRadioGroup;
    procedure CalcularButtonClick(Sender: TObject);
    procedure XEditKeyPress(Sender: TObject; var Key: Char);
  end;

  { ICalculadora }

  ICalculadora = interface
    ['{7DF87D72-3F74-4F1A-A86B-5FFED0F8CE01}']
    function GetResult: Double;
    procedure SetResult(Value: Double);
    procedure Calculate(X, Y: Double);
    property Result: Double read GetResult write SetResult;
  end;

  { TSoma }

  TSoma = class(TInterfacedObject, ICalculadora)
  private
    FResult: Double;
  protected
    function GetResult: Double;
    procedure SetResult(Value: Double);
    procedure Calculate(X, Y: Double);
  end;

  { TDivisao }

  TDivisao = class(TInterfacedObject, ICalculadora)
  private
    FResult: Double;
  protected
    function GetResult: Double;
    procedure SetResult(Value: Double);
    procedure Calculate(X, Y: Double);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.XEditKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13: Key := #0;
    '.': Key := ',';
  end;
  if not (Key in ['0'..'9', ',', #8]) then
    Key := #0;
end;

procedure TMainForm.CalcularButtonClick(Sender: TObject);
var
  X, Y: Double;
  Calc: ICalculadora;
begin
  if (XEdit.Text = '') or (YEdit.Text = '') then
    Exit;
  X := StrToFloat(XEdit.Text);
  Y := StrToFloat(YEdit.Text);
  case OperacaoRadioGroup.ItemIndex of
    0: Calc := TSoma.Create;
    1: Calc := TDivisao.Create;
  end;
  Calc.Calculate(X, Y);
  ShowMessage(FloatToStr(Calc.Result));
end;

{ TSoma }

function TSoma.GetResult: Double;
begin
  Result := FResult;
end;

procedure TSoma.SetResult(Value: Double);
begin
  FResult := Value;
end;

{ TDivisao }

function TDivisao.GetResult: Double;
begin
  Result := FResult;
end;

procedure TDivisao.SetResult(Value: Double);
begin
  FResult := Value;
end;

procedure TSoma.Calculate(X, Y: Double);
begin
  SetResult(X + Y);
end;

procedure TDivisao.Calculate(X, Y: Double);
begin
  if (Y = 0) then
  begin
    SetResult(0);
    raise Exception.Create('Divisao por zero.');
  end;
  SetResult(X / Y);
end;

end.

