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

unit MesMVC;

{$I cheques.inc}

interface

uses
  CustomMVC, MesEditFrm, MainDM, MesViewFrm;

type

  { TMesModel }

  TMesModel = class(TCustomModel)
  public
    procedure Initialize; override;
  end;

  { TMesView }

  TMesView = class(TCustomView)
  public
    procedure Initialize; override;
  end;

  { TMesController }

  TMesController = class(TCustomController)
  end;

implementation

{ TMesModel }

procedure TMesModel.Initialize;
begin
  Query := MainDataModule.MesZQuery;
  TableName := 'mes';
  Report.Columns := 'Nome';
  Report.Fields := 'nome';
  Report.BrowserTitle := 'Mês';
  Report.ReportTitle := 'Listagem - Mês';
  inherited;
end;

{ TMesView }

procedure TMesView.Initialize;
begin
  Controller := TMesController.Create;
  Model := TMesModel.Create;
  EditFormClass := TMesEditForm;
  ValidateControls(['NomeDBEdit']);
  inherited;
end;

initialization
  TMesView.RegisterViewFormClass(TMesViewForm);

end.

