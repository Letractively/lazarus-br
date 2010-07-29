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

unit MainDM;

{$I cheques.inc}

interface

uses
  Classes, SysUtils, DB, FileUtil, ZConnection, ZDataset, ZDbcIntfs,
  ChequeConsts;

type

  { TMainDataModule }

  TMainDataModule = class(TDataModule)
    BancoZQueryagencia: TStringField;
    BancoZQuerycodigo: TStringField;
    BancoZQuerynome: TStringField;
    BancoZQueryoid: TLongintField;
    ChequeZQuerybanco: TStringField;
    ChequeZQueryconta: TStringField;
    ChequeZQuerydestino: TStringField;
    ChequeZQuerymes: TStringField;
    ChequeZQuerynumero: TStringField;
    ChequeZQueryoidbanco: TLongintField;
    ChequeZQueryoidconta: TLongintField;
    ChequeZQueryoiddestino: TLongintField;
    ChequeZQueryoidmes: TLongintField;
    ChequeZQuerypago: TBooleanField;
    ChequeZQueryvalor: TFloatField;
    ChequeZQueryvencimento: TDateField;
    ContaDataSource: TDatasource;
    ContaZQuerynome: TStringField;
    ContaZQueryoid: TLongintField;
    BancoDataSource: TDatasource;
    ChequeDataSource: TDatasource;
    DestinoDataSource: TDatasource;
    DestinoZQuerycelular: TStringField;
    DestinoZQuerycpf: TStringField;
    DestinoZQueryemail: TStringField;
    DestinoZQueryendereco: TStringField;
    DestinoZQuerynome: TStringField;
    DestinoZQueryoid: TLongintField;
    DestinoZQuerytelefone: TStringField;
    MesDataSource: TDatasource;
    MainZConnection: TZConnection;
    ContaZQuery: TZQuery;
    BancoZQuery: TZQuery;
    ChequeZQuery: TZQuery;
    MesZQuery: TZQuery;
    DestinoZQuery: TZQuery;
    MesZQuerynome: TStringField;
    MesZQueryoid: TLongintField;
    procedure DataModuleCreate(Sender: TObject);
  end;

var
  MainDataModule: TMainDataModule;

implementation

{$R *.lfm}

{ TMainDataModule }

procedure TMainDataModule.DataModuleCreate(Sender: TObject);
var
  VConfigFile: TStringList;
begin
  { Load configs and connect do DB. }

  VConfigFile := TStringList.Create;
  try
    VConfigFile.LoadFromFile(ExtractFilePath(ParamStrUTF8(0)) + CDBConfigFileName);
    with MainZConnection do
    begin
      if Connected then
        Disconnect;
      Database := VConfigFile.Values[C_database];
      HostName := VConfigFile.Values[C_hostname];
      Password := VConfigFile.Values[C_password];
      Port := StrToIntDef(VConfigFile.Values[C_port], 0);
      Protocol := VConfigFile.Values[C_protocol];
      User := VConfigFile.Values[C_user];
      SQLHourGlass := True;
      if Protocol = CSQLite3Protocol then
        TransactIsolationLevel := tiNone
      else
        TransactIsolationLevel := tiReadCommitted;
      Connect;
    end;
  finally
    VConfigFile.Free;
  end;
end;

end.

