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

unit DestinoMVC;

{$I cheques.inc}

interface

uses
  CustomMVC, DestinoEditFrm, MainDM, DestinoViewFrm, Forms;

type

  { TDestinoModel }

  TDestinoModel = class(TCustomModel)
  public
    procedure Initialize; override;
  end;

  { TDestinoView }

  TDestinoView = class(TCustomView)
  public
    procedure Initialize; override;
    procedure ConfigureViewForm(const AViewForm: TForm); override;
  end;

  { TDestinoController }

  TDestinoController = class(TCustomController)
  end;

implementation

{ TDestinoModel }

procedure TDestinoModel.Initialize;
begin
  Query := MainDataModule.DestinoZQuery;
  TableName := 'destino';
  Report.Columns := 'Nome;Endereço;CPF;Telefone;Celular;E-mail';
  Report.Fields := 'nome;endereco;cpf;telefone;celular;email';
  Report.BrowserTitle := 'destino';
  Report.ReportTitle := 'Listagem - Destino';
  inherited;
end;

{ TDestinoView }

procedure TDestinoView.Initialize;
begin
  Controller := TDestinoController.Create;
  Model := TDestinoModel.Create;
  EditFormClass := TDestinoEditForm;
  ValidateControls(['NomeDBEdit']);
  inherited;
end;

procedure TDestinoView.ConfigureViewForm(const AViewForm: TForm);
begin
  AddSearchTypeComboBox;
  AddSearchTypeComboBox('Endereço', 'endereco');
  AddSearchTypeComboBox('CPF', 'cpf');
  AddSearchTypeComboBox('Telefone', 'telefone');
  AddSearchTypeComboBox('Celular', 'celular');
  AddSearchTypeComboBox('E-mail', 'email');
  inherited;
end;

initialization
  TDestinoView.RegisterViewFormClass(TDestinoViewForm);

end.

