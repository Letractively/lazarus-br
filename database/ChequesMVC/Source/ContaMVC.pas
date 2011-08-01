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

unit ContaMVC;

{$I cheques.inc}

interface

uses
  CustomMVC, ContaEditFrm, MainDM, ContaViewFrm;

type

  { TContaModel }

  TContaModel = class(TCustomModel)
  public
    procedure Initialize; override;
  end;

  { TContaView }

  TContaView = class(TCustomView)
  public
    procedure Initialize; override;
  end;

  { TContaController }

  TContaController = class(TCustomController)
  end;

implementation

{ TContaModel }

procedure TContaModel.Initialize;
begin
  Query := MainDataModule.ContaZQuery;
  TableName := 'conta';
  Report.Columns := 'Nome';
  Report.Fields := 'nome';
  Report.BrowserTitle := 'Conta';
  Report.ReportTitle := 'Listagem - Conta';
  inherited;
end;

{ TContaView }

procedure TContaView.Initialize;
begin
  Controller := TContaController.Create;
  Model := TContaModel.Create;
  EditFormClass := TContaEditForm;
  ValidateControls(['NomeDBEdit']);
  inherited;
end;

initialization
  TContaView.RegisterViewFormClass(TContaViewForm);

end.
