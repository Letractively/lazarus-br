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

unit DataMVCIntf;

{$I cheques.inc}

interface

uses
  Forms, ChequeClasses;

type

  IDataController = interface;

  { IDataModel }

  IDataModel = interface(IInterface)
    ['{D6CF2635-164E-4CF9-BC0E-B751EE3533C7}']
    procedure Initialize;
    procedure Finalize;
    procedure Search;
    procedure Insert;
    procedure Delete;
    procedure Edit;
    procedure Save;
    procedure Cancel;
    function GetDataObject: TDataObject;
    procedure SetDataObject(const AValue: TDataObject);
    procedure SetReport(const AValue: TReportDataObject);
    function GetReport: TReportDataObject;
    property DataObject: TDataObject read GetDataObject write SetDataObject;
    property Report: TReportDataObject read GetReport write SetReport;
  end;

  { IDataView }

  IDataView = interface(IInterface)
    ['{CDFE811C-25CA-4A5F-82E4-1B658BCA88DE}']
    procedure Initialize;
    procedure Finalize;
    function GetModel: IDataModel;
    procedure SetModel(const AValue: IDataModel);
    function GetController: IDataController;
    procedure SetController(const AValue: IDataController);
    function GetViewForm: TForm;
    procedure SetViewForm(const AValue: TForm);
    procedure ConfigureViewForm(const AViewForm: TForm);
    property Model: IDataModel read GetModel write SetModel;
    property Controller: IDataController read GetController write SetController;
    property ViewForm: TForm read GetViewForm write SetViewForm;
  end;

  { IDataController }

  IDataController = interface(IInterface)
    ['{7DD58BBC-3DA7-4283-81C7-18A05BE74078}']
    procedure Initialize;
    procedure Finalize;
    procedure Search;
    procedure Insert;
    procedure Delete;
    procedure Edit;
    procedure Save;
    procedure Cancel;
    function GetModel: IDataModel;
    function GetView: IDataView;
    procedure SetModel(const AValue: IDataModel);
    procedure SetView(const AValue: IDataView);
    property Model: IDataModel read GetModel write SetModel;
    property View: IDataView read GetView write SetView;
  end;

implementation

end.

