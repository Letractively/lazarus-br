(*
  Cheques 2.1, Controle pessoal de cheques.
  Copyright (C) 2010-2012 Everaldo - arcanjoebc@gmail.com

  See the file LGPL.2.1_modified.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

(*
  Powerfull contributors:
  Silvio Clecio - http://blog.silvioprog.com.br
  Joao Morais   - http://blog.joaomorais.com.br
  Luiz Americo  - http://lazarusroad.blogspot.com
*)

unit BancoMVC;

{$I cheques.inc}

interface

uses
  CustomMVC, BancoEditFrm, MainDM, BancoViewFrm, Forms;

type

  { TBancoModel }

  TBancoModel = class(TCustomModel)
  public
    procedure Initialize; override;
  end;

  { TBancoView }

  TBancoView = class(TCustomView)
  public
    procedure Initialize; override;
    procedure ConfigureViewForm(const AViewForm: TForm); override;
  end;

  { TBancoController }

  TBancoController = class(TCustomController)
  end;

implementation

{ TBancoModel }

procedure TBancoModel.Initialize;
begin
  Query := MainDataModule.BancoZQuery;
  TableName := 'banco';
  Report.Columns := 'Código;Nome;Agência';
  Report.Fields := 'codigo;nome;agencia';
  Report.BrowserTitle := 'Banco';
  Report.ReportTitle := 'Listagem - Banco';
  inherited;
end;

{ TBancoView }

procedure TBancoView.Initialize;
begin
  Controller := TBancoController.Create;
  Model := TBancoModel.Create;
  EditFormClass := TBancoEditForm;
  ValidateControls(['NomeDBEdit']);
  inherited;
end;

procedure TBancoView.ConfigureViewForm(const AViewForm: TForm);
begin
  AddSearchTypeComboBox('Código', 'codigo');
  AddSearchTypeComboBox;
  AddSearchTypeComboBox('Agência', 'agencia');
  inherited;
end;

initialization
  TBancoView.RegisterViewFormClass(TBancoViewForm);

end.

