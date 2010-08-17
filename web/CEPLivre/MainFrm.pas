(*
  Unit CEPLivre 1.0, Consultar CEP online gratuitamente.
  Copyright (C) 2010-2012 Silvio Clecio - admin@silvioprog.com.br

  http://blog.silvioprog.com.br

  See the file LGPL.2.1_modified.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, ComCtrls, StdCtrls, ExtCtrls, MaskEdit, CEPLivre, DB, Dialogs,
  DBGrids, Buttons;

type

  { TMainForm }

  TMainForm = class(TForm)
    ConsultarButton: TButton;
    CEPEdit: TMaskEdit;
    CEPLabel: TLabel;
    CEPPageControl: TPageControl;
    CEPTabSheet: TTabSheet;
    CidadeEdit: TEdit;
    CEPDataCource: TDatasource;
    CEPDBGrid: TDBGrid;
    LogoImage: TImage;
    SobreSpeedButton: TSpeedButton;
    StatusPanel: TPanel;
    TipoConsultaComboBox: TComboBox;
    TipoConsultaLabel: TLabel;
    CidadeLabel: TLabel;
    LogradouroEdit: TEdit;
    LogradouroLabel: TLabel;
    ConsultaPanel: TPanel;
    procedure CEPEditChange(Sender: TObject);
    procedure CEPEditKeyPress(Sender: TObject; var Key: Char);
    procedure ConsultarButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LogradouroEditChange(Sender: TObject);
    procedure SobreSpeedButtonClick(Sender: TObject);
  private
    FCEPLivre: TCEPLivre;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CEPLivre: TCEPLivre read FCEPLivre write FCEPLivre;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCEPLivre := TCEPLivre.Create(nil);
  CEPDataCource.DataSet := FCEPLivre.DataSet;
end;

destructor TMainForm.Destroy;
begin
  FCEPLivre.Free;
  inherited Destroy;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  CEPEdit.SetFocus;
end;

procedure TMainForm.LogradouroEditChange(Sender: TObject);
begin
  TipoConsultaComboBox.ItemIndex := 1;
  CEPEdit.Clear;
end;

procedure TMainForm.SobreSpeedButtonClick(Sender: TObject);
begin
  MessageDlg('O CEP Livre é um projeto mantido pela (PC)² Consultoria ' +
    'em Software Livre. Trata-se de um serviço gratuíto de consulta a ' +
    'CEPs brasileiros, que pode ser integrado a ferramentas on-line e, ' +
    'futuramente, embarcado também em sistemas offline.' + sLineBreak + sLineBreak +
    'Para utilizá-lo não é necessário registro prévio ou pagamento de ' +
    'mensalidade. Leia o FAQ do projeto para conhecê-lo melhor.' + sLineBreak + sLineBreak +
    'O CEP Livre é um projeto gratuito ao usuário final. Para mantê-lo ' +
    'ativo, contribua conosco.' + sLineBreak + sLineBreak + sLineBreak +
    '© 2009 (PC)² Consultoria em Software Livre - <http://ceplivre.pc2consultoria.com>',
    mtInformation, [mbOK], 0);
end;

procedure TMainForm.ConsultarButtonClick(Sender: TObject);
var
  B: Boolean;
begin
  StatusPanel.Show;
  try
    Application.ProcessMessages;
    if TipoConsultaComboBox.ItemIndex = 0 then
      B := FCEPLivre.Consultar(CEPEdit.Text)
    else
      B := FCEPLivre.Consultar('', CidadeEdit.Text, LogradouroEdit.Text, tcLogradouro);
    if not B then
      MessageDlg('ERRO: Não foi possível obter os dados do servidor de CEPs.',
        mtError, [mbClose], 0);
  finally
    StatusPanel.Hide;
  end;
end;

procedure TMainForm.CEPEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    ConsultarButton.Click;
  end;
  if not (Key in ['0'..'9', 'a'..'z', #8, #32]) then
    Key := #0;
end;

procedure TMainForm.CEPEditChange(Sender: TObject);
begin
  TipoConsultaComboBox.ItemIndex := 0;
  LogradouroEdit.Clear;
  CidadeEdit.Clear;
end;

end.

