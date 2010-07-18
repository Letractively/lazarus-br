unit Delegacao2MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, ExtCtrls, StdCtrls, CalcClass;

type

  { TMainForm }

  TMainForm = class(TForm)
    CalcularButton: TButton;
    FuncaoRadioGroup: TRadioGroup;
    procedure CalcularButtonClick(Sender: TObject);
  public
    FCalcFunc: TCalcFunc2;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  CalcUtils;

{ TMainForm }

procedure TMainForm.CalcularButtonClick(Sender: TObject);
begin
  case FuncaoRadioGroup.ItemIndex of
    0: FCalcFunc := @Calculate1;
    1: FCalcFunc := @Calculate2;
  end;
  FCalcFunc(5, 10);
end;

end.
