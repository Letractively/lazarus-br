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

unit ChequeMVC;

{$I cheques.inc}

interface

uses
  CustomMVC, ChequeEditFrm, MainDM, ChequeViewFrm, Forms, DB;

type

  { TChequeModel }

  TChequeModel = class(TCustomModel)
  public
    procedure Initialize; override;
    procedure Save; override;
  end;

  { TChequeView }

  TChequeView = class(TCustomView)
  public
    procedure Initialize; override;
    procedure ShowDestinoView(Sender: TObject);
    procedure ShowMesView(Sender: TObject);
    procedure ShowBancoView(Sender: TObject);
    procedure ShowContaView(Sender: TObject);
    procedure ConfigureEditForm(const AEditForm: TForm); override;
  end;

  { TChequeController }

  TChequeController = class(TCustomController)
  end;

implementation

uses
  DestinoMVC, MesMVC, BancoMVC, ContaMVC;

{ TChequeModel }

procedure TChequeModel.Initialize;
begin
  Query := MainDataModule.ChequeZQuery;
  TableName := 'cheque';
  SelectSQL :=
    'select (select nome from banco where oid = oidbanco) as banco, oidbanco, ' +
    '(select nome from conta where oid = oidconta) as conta, oidconta, ' +
    '(select nome from destino where oid = oiddestino) as destino, ' +
    'oiddestino, numero, vencimento, ' +
    '(select nome from mes where oid = oidmes) as mes, oidmes, valor, pago ' +
    'from cheque';
  Report.Columns := 'Número;Pago;Valor;Vencimento;Mês;Destino;Banco;Conta';
  Report.Fields := 'numero;pago;valor;vencimento;mes;destino;banco;conta';
  Report.BrowserTitle := 'Cheque';
  Report.ReportTitle := 'Listagem - Cheque';
  inherited;
end;

procedure TChequeModel.Save;
begin
  AutoRefresh := True;
  inherited;
end;

{ TChequeView }

procedure TChequeView.Initialize;
begin
  Controller := TChequeController.Create;
  Model := TChequeModel.Create;
  EditFormClass := TChequeEditForm;
  ValidateControls(['PagoDBCheckBox', 'ValorDBEdit', 'VencimentoDBEdit',
    'DestinoDBLookupComboBox', 'MesDBLookupComboBox', 'BancoDBLookupComboBox',
    'ContaDBLookupComboBox']);
  AddSearchTypeComboBox('Número', 'numero', ftString);
  AddSearchTypeComboBox('Mês', 'oidmes', ftInteger);
  AddSearchTypeComboBox('Conta', 'oidconta', ftInteger);
  AddSearchTypeComboBox('Banco', 'oidbanco', ftInteger);
  AddSearchTypeComboBox('Destino', 'oiddestino', ftInteger);
  AddSearchTypeComboBox('Vencimento', 'vencimento', ftDate);
  AddSearchTypeComboBox('Valor', 'valor', ftCurrency);
  AddSearchTypeComboBox('Pago', 'pago', ftBoolean);
  inherited;
end;

procedure TChequeView.ShowDestinoView(Sender: TObject);
begin
  TDestinoView.Execute;
end;

procedure TChequeView.ShowMesView(Sender: TObject);
begin
  TMesView.Execute;
end;

procedure TChequeView.ShowBancoView(Sender: TObject);
begin
  TBancoView.Execute;
end;

procedure TChequeView.ShowContaView(Sender: TObject);
begin
  TContaView.Execute;
end;

procedure TChequeView.ConfigureEditForm(const AEditForm: TForm);
begin
  TChequeEditForm(AEditForm).DestinoSpeedButton.OnClick := @ShowDestinoView;
  TChequeEditForm(AEditForm).MesSpeedButton.OnClick := @ShowMesView;
  TChequeEditForm(AEditForm).BancoSpeedButton.OnClick := @ShowBancoView;
  TChequeEditForm(AEditForm).ContaSpeedButton.OnClick := @ShowContaView;
  inherited;
end;

initialization
  TChequeView.RegisterViewFormClass(TChequeViewForm);

end.

