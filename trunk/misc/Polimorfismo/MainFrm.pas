unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls, ExtCtrls, Buttons;

type

  { TMainForm }

  TMainForm = class(TForm)
    CalcularSalarioBitBtn: TBitBtn;
    SalarioEdit: TEdit;
    SairBitBtn: TBitBtn;
    NomeTecnicoEdit: TEdit;
    NomeTecnicoLabel: TLabel;
    SalarioLabel: TLabel;
    TipoRadioGroup: TRadioGroup;
    procedure CalcularSalarioBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SalarioEditEnter(Sender: TObject);
    procedure SalarioEditExit(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  MainUtils, CurrencyUtils, TecnicoConsts, TecnicoIntf, TecnicoClass;

{ TMainForm }

procedure TMainForm.CalcularSalarioBitBtnClick(Sender: TObject);
var
  VTecnico: ITecnico;
begin
  if OneStrIsEmpty([NomeTecnicoEdit.Text, SalarioEdit.Text]) then
    Exit;
  case TipoRadioGroup.ItemIndex of
    0:
    begin
      VTecnico := TTecnicoAprendiz.Create;
      VTecnico.SetNome(NomeTecnicoEdit.Text);
      VTecnico.SetSalario(StrToCurrDef0(SalarioEdit.Text));
      VTecnico.Resultado;
    end;
    1:
    begin
      VTecnico := TTecnicoVeterano.Create;
      VTecnico.SetNome(NomeTecnicoEdit.Text);
      VTecnico.SetSalario(StrToCurrDef0(SalarioEdit.Text));
      VTecnico.Resultado;
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  NomeTecnicoEdit.Text := CDefaultTecnico;
  SalarioEdit.Text := CurrToStrFrmt(CDefaultSalario);
end;

procedure TMainForm.SalarioEditEnter(Sender: TObject);
begin
  TCustomEdit(Sender).Text := FormatCurrStrToStr(TCustomEdit(Sender).Text);
end;

procedure TMainForm.SalarioEditExit(Sender: TObject);
begin
  TCustomEdit(Sender).Text := FormatStrToCurrStr(TCustomEdit(Sender).Text);
end;

end.

