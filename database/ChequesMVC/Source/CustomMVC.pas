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

unit CustomMVC;

{$I cheques.inc}

interface

uses
  DataMVCIntf, CustomViewFrm, CustomEditFrm, MainDM, ChequeUtils, ChequeConsts,
  ChequeClasses, ChequeExceptionHandle, Controls, StdCtrls, DBGrids, DB,
  SysUtils, ZDataset, Dialogs, Forms, Classes;

const
  CViewFormIdentifier = '_ViewForm';

type
  TControllerAction = (caInsert, caEdit, caDelete);
  TCustomEditFormClass = class of TCustomEditForm;
  TCustomViewFormClass = class of TCustomViewForm;

  { TCustomModel }

  TCustomModel = class(TInterfacedObject, IDataModel)
  private
    FAutoRefresh: Boolean;
    FDataObject: TDataObject;
    FOrderByField: string;
    FQuery: TZQuery;
    FReport: TReportDataObject;
    FSelectSQL: string;
    FTableName: string;
    function GetDataObject: TDataObject;
    function GetReport: TReportDataObject;
    procedure SetDataObject(const AValue: TDataObject);
    procedure SetReport(const AValue: TReportDataObject);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure Search; virtual;
    procedure Insert; virtual;
    procedure Delete; virtual;
    procedure Edit; virtual;
    procedure Save; virtual;
    procedure Cancel; virtual;
    property DataObject: TDataObject read GetDataObject write SetDataObject;
    property Report: TReportDataObject read GetReport write SetReport;
    property TableName: string read FTableName write FTableName;
    property OrderByField: string read FOrderByField write FOrderByField;
    property Query: TZQuery read FQuery write FQuery;
    property SelectSQL: string read FSelectSQL write FSelectSQL;
    property AutoRefresh: Boolean read FAutoRefresh write FAutoRefresh default False;
  end;

  { TCustomView }

  TCustomView = class(TInterfacedObject, IDataView)
  private
    FController: IDataController;
    FEditForm: TForm;
    FEditFormClass: TCustomEditFormClass;
    FModel: IDataModel;
    FViewForm: TForm;
    FValidateControls: array of string;
    function ValidateAllControls: Boolean;
    function GetController: IDataController;
    function GetModel: IDataModel;
    function GetViewForm: TForm;
    procedure SetController(const AValue: IDataController);
    procedure SetModel(const AValue: IDataModel);
    procedure SetViewForm(const AValue: TForm);
    procedure DoEditFormOnClose(Sender: TObject; var CanClose: Boolean);
    procedure DoPrint(Sender: TObject); virtual;
    procedure DoClose(Sender: TObject); virtual;
    procedure DoSearch(Sender: TObject); virtual;
    procedure DoDelete(Sender: TObject); virtual;
    procedure DoEdit(Sender: TObject); virtual;
    procedure DoInsert(Sender: TObject); virtual;
    procedure DoSearchEditEnter(Sender: TObject); virtual;
    procedure DoSearchEditExit(Sender: TObject); virtual;
    procedure DoSearchTypeComboBoxOnChange(Sender: TObject); virtual;
  public
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure ConfigureEditForm(const AEditForm: TForm); virtual;
    procedure AddSearchTypeComboBox(const AAddItem: string = 'Nome';
      const ASearchInField: string = 'nome';
      const ASearchFieldType: TFieldType = ftString);
    procedure ValidateControls(const AControls: array of string); virtual;
    class procedure RegisterViewFormClass(const AViewFormClass: TPersistentClass);
    procedure ConfigureViewForm(const AViewForm: TForm); virtual;
    class procedure Execute(AViewForm: TCustomViewForm = nil;
      const AAfterExecute: TNotifyEvent = nil);
    procedure Edit(var AController: IDataController;
      const AControllerAction: TControllerAction = caInsert);
    procedure OnSearch; virtual;
    function IsSearchType: Boolean;
    property Model: IDataModel read GetModel write SetModel;
    property Controller: IDataController read GetController write SetController;
    property ViewForm: TForm read GetViewForm write SetViewForm;
    property EditFormClass: TCustomEditFormClass
      read FEditFormClass write FEditFormClass;
  end;

  { TCustomController }

  TCustomController = class(TInterfacedObject, IDataController)
  private
    FModel: IDataModel;
    FView: IDataView;
    function GetModel: IDataModel;
    function GetView: IDataView;
    procedure SetModel(const AValue: IDataModel);
    procedure SetView(const AValue: IDataView);
  public
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure Search; virtual;
    procedure Insert; virtual;
    procedure Delete; virtual;
    procedure Edit; virtual;
    procedure Save; virtual;
    procedure Cancel; virtual;
    property Model: IDataModel read GetModel write SetModel;
    property View: IDataView read GetView write SetView;
  end;

implementation

{ TCustomModel }

constructor TCustomModel.Create;
begin
  inherited Create;
  FDataObject := TDataObject.Create;
  FReport := TReportDataObject.Create;
  FReport.OpenInBrowser := True;
  FReport.Striped := True;
  FSelectSQL := CGenericSelectSQL;
  FOrderByField := CDefaultOrderByField;
  FAutoRefresh := False;
end;

destructor TCustomModel.Destroy;
begin
  FReport.Free;
  FDataObject.Free;
  inherited Destroy;
end;

function TCustomModel.GetDataObject: TDataObject;
begin
  Result := FDataObject;
end;

function TCustomModel.GetReport: TReportDataObject;
begin
  Result := FReport;
end;

procedure TCustomModel.SetDataObject(const AValue: TDataObject);
begin
  FDataObject := AValue;
end;

procedure TCustomModel.SetReport(const AValue: TReportDataObject);
begin
  FReport := AValue;
end;

procedure TCustomModel.Initialize;
begin
  if not Assigned(FQuery) then
  begin
    TChequeExceptionHandle.ShowErrorMsg(CInvalidQueryIntance, False);
    Halt;
  end;
  FReport.DataSet := FQuery;
  FQuery.Close;
  FQuery.SQL.Text := FSelectSQL + ' ' + FTableName + ' ' + FOrderByField;
  FQuery.Open;
end;

procedure TCustomModel.Finalize;
begin
  FQuery.Close;
end;

procedure TCustomModel.Search;
begin
  FQuery.Close;
  FQuery.SQL.Text := FSelectSQL + ' ' + FTableName +
    FormatSearchFromDataObject(MainDataModule.MainZConnection, FDataObject);
  FQuery.Open;
end;

procedure TCustomModel.Insert;
begin
  FQuery.Append;
end;

procedure TCustomModel.Delete;
begin
  FQuery.Delete;
  FQuery.ApplyUpdates;
end;

procedure TCustomModel.Edit;
begin
  FQuery.Edit;
end;

procedure TCustomModel.Save;
var
  VOldRecNo: Integer;
begin
  try
    FQuery.Post;
    FQuery.ApplyUpdates;
    if FQuery.Modified and FAutoRefresh then
    begin
      VOldRecNo := FQuery.RecNo;
      FQuery.Refresh;
      FQuery.RecNo := VOldRecNo;
    end;
  except
    Cancel;
    raise;
  end;
end;

procedure TCustomModel.Cancel;
begin
  FQuery.CancelUpdates;
end;

{ TCustomView }

function TCustomView.GetModel: IDataModel;
begin
  Result := FModel;
end;

function TCustomView.GetViewForm: TForm;
begin
  Result := FViewForm;
end;

procedure TCustomView.DoEditFormOnClose(Sender: TObject; var CanClose: Boolean);
begin
  if TForm(Sender).ModalResult = mrOk then
    CanClose := ValidateAllControls;
end;

procedure TCustomView.ConfigureEditForm(const AEditForm: TForm);
var
  VEditForm: TCustomEditForm;
begin
  VEditForm := TCustomEditForm(AEditForm);
  VEditForm.OnCloseQuery := @DoEditFormOnClose;
  VEditForm.OKBitBtn.ModalResult := mrOk;
  VEditForm.OKBitBtn.Default := True;
  VEditForm.CancelBitBtn.ModalResult := mrCancel;
  VEditForm.CancelBitBtn.Cancel := True;
end;

procedure TCustomView.AddSearchTypeComboBox(const AAddItem: string;
  const ASearchInField: string; const ASearchFieldType: TFieldType);
var
  VViewForm: TCustomViewForm;
  VDataObject: TDataObject;
begin
  VViewForm := TCustomViewForm(FViewForm);
  VDataObject := TDataObject.Create;
  VDataObject.FieldName := ASearchInField;
  VDataObject.FieldType := ASearchFieldType;
  VViewForm.SearchTypeComboBox.AddItem(AAddItem, VDataObject);
end;

function TCustomView.ValidateAllControls: Boolean;
var
  I: Integer;
  VComponent: TComponent;
begin
  Result := True;
  for I := Low(FValidateControls) to High(FValidateControls) do
  begin
    VComponent := FEditForm.FindComponent(FValidateControls[I]);
    if (VComponent is TCustomCheckBox) and
      (TCustomCheckBox(VComponent).State = cbGrayed) then
    begin
      Result := False;
      TCustomCheckBox(VComponent).SetFocus;
      Break;
    end;
    if (VComponent is TCustomComboBox) and
      (TCustomComboBox(VComponent).Text = '') then
    begin
      Result := False;
      TCustomComboBox(VComponent).SetFocus;
      Break;
    end;
    if (VComponent is TCustomEdit) and (TCustomEdit(VComponent).Text = '') then
    begin
      Result := False;
      TCustomEdit(VComponent).SetFocus;
      Break;
    end;
  end;
  if not Result then
    TChequeExceptionHandle.ShowErrorMsg(CRequestFillField, False, edtAsterick);
end;

function TCustomView.GetController: IDataController;
begin
  Result := FController;
end;

procedure TCustomView.SetController(const AValue: IDataController);
begin
  FController := AValue;
end;

procedure TCustomView.SetModel(const AValue: IDataModel);
begin
  FModel := AValue;
end;

procedure TCustomView.DoPrint(Sender: TObject);
begin
  FModel.Report.Execute;
end;

procedure TCustomView.DoClose(Sender: TObject);
begin
  FViewForm.Close;
end;

procedure TCustomView.DoSearch(Sender: TObject);
begin
{$ifdef UsesMinimalSearch}
  if Length(TCustomViewForm(FViewForm).SearchEdit.Text) <= 2 then
    TChequeExceptionHandle.ShowErrorMsg(CRequestMinimalSearch, False, edtAsterick)
  else
{$endif}
  begin
    OnSearch;
    FController.Search;
    TCustomViewForm(FViewForm).SearchEdit.SetFocus;
  end;
end;

procedure TCustomView.DoDelete(Sender: TObject);
begin
  if MessageDlg(CQuestionCap, CDeleteConfirm, mtConfirmation,
    mbYesNo, 0) = mrYes then
    Edit(FController, caDelete);
end;

procedure TCustomView.DoEdit(Sender: TObject);
begin
  Edit(FController, caEdit);
end;

procedure TCustomView.DoInsert(Sender: TObject);
begin
  Edit(FController);
end;

procedure TCustomView.DoSearchEditEnter(Sender: TObject);
begin
  if TCustomEdit(Sender).Text = CDefaultSearchEditText then
    TCustomEdit(Sender).Clear;
end;

procedure TCustomView.DoSearchEditExit(Sender: TObject);
begin
  if TCustomEdit(Sender).Text = '' then
    TCustomEdit(Sender).Text := CDefaultSearchEditText;
end;

procedure TCustomView.DoSearchTypeComboBoxOnChange(Sender: TObject);
var
  VComboBox: TCustomComboBox;
  VDataObject: TDataObject;
begin
  VComboBox := TCustomViewForm(FViewForm).SearchTypeComboBox;
  VDataObject := TDataObject(VComboBox.Items.Objects[VComboBox.ItemIndex]);
  FModel.DataObject.FieldType := VDataObject.FieldType;
  FModel.DataObject.FieldName := VDataObject.FieldName;
end;

function TCustomView.IsSearchType: Boolean;
begin
  Result := TCustomViewForm(FViewForm).SearchTypeComboBox.Items.Count > 0;
end;

procedure TCustomView.Initialize;
begin
  FController.View := Self; // Add view ref.
  FController.Initialize;
end;

procedure TCustomView.Finalize;
var
  I: Integer;
  VItems: TStrings;
begin
  VItems := TCustomViewForm(FViewForm).SearchTypeComboBox.Items;
  for I := 0 to Pred(VItems.Count) do
    if Assigned(VItems.Objects[I]) then
      TObject(VItems.Objects[I]).Free;
  FController.View._Release; // Remove view ref.
  FController.Finalize;
end;

procedure TCustomView.ValidateControls(const AControls: array of string);
var
  I: Integer;
begin
  SetLength(FValidateControls, Length(AControls));
  for I := Low(AControls) to High(AControls) do
    FValidateControls[I] := AControls[I];
end;

procedure TCustomView.OnSearch;
begin
  if IsSearchType then
    DoSearchTypeComboBoxOnChange(Self)
  else
  begin
    FModel.DataObject.FieldType := ftString;
    FModel.DataObject.FieldName := 'nome';
  end;
  FModel.DataObject.Value := TCustomViewForm(FViewForm).SearchEdit.Text;
end;

procedure TCustomView.ConfigureViewForm(const AViewForm: TForm);
var
  VViewForm: TCustomViewForm;
begin
  { Configures several internal routines and properties. }

  VViewForm := TCustomViewForm(AViewForm);
  VViewForm.SessionProperties :=
    VViewForm.SessionProperties + CDefaultDBSessionProperties;
  VViewForm.ListDBGrid.ReadOnly := True;
  VViewForm.ListDBGrid.Options := VViewForm.ListDBGrid.Options + [dgRowSelect];
  VViewForm.PrintMenuItem.OnClick := @DoPrint;
  VViewForm.PrintBitBtn.OnClick := @DoPrint;
  VViewForm.CloseMenuItem.OnClick := @DoClose;
  VViewForm.CloseBitBtn.OnClick := @DoClose;
  VViewForm.SearchMenuItem.OnClick := @DoSearch;
  VViewForm.SearchBitBtn.OnClick := @DoSearch;
  VViewForm.InsertMenuItem.OnClick := @DoInsert;
  VViewForm.InsertBitBtn.OnClick := @DoInsert;
  VViewForm.EditMenuItem.OnClick := @DoEdit;
  VViewForm.EditBitBtn.OnClick := @DoEdit;
  VViewForm.DeleteMenuItem.OnClick := @DoDelete;
  VViewForm.DeleteBitBtn.OnClick := @DoDelete;
  VViewForm.ListDBGrid.OnDblClick := @DoEdit;
  VViewForm.SearchEdit.Text := CDefaultSearchEditText;
  VViewForm.SearchEdit.OnEnter := @DoSearchEditEnter;
  VViewForm.SearchEdit.OnExit := @DoSearchEditExit;
  if IsSearchType then
  begin
    VViewForm.SearchTypePanel.Visible := True;
    VViewForm.SearchTypeComboBox.Style := csDropDownList;
    VViewForm.SearchTypeComboBox.ItemIndex := 0;
    VViewForm.SearchTypeComboBox.OnChange := @DoSearchTypeComboBoxOnChange;
    DoSearchTypeComboBoxOnChange(Self);
  end;
end;

procedure TCustomView.SetViewForm(const AValue: TForm);
begin
  FViewForm := AValue;
end;

class procedure TCustomView.RegisterViewFormClass(
  const AViewFormClass: TPersistentClass);
begin
  RegisterClassAlias(AViewFormClass, Self.ClassName + CViewFormIdentifier);
end;

class procedure TCustomView.Execute(AViewForm: TCustomViewForm;
  const AAfterExecute: TNotifyEvent);
var
  VDataView: IDataView;
  VPersistentClass: TPersistentClass;
begin
  VPersistentClass := GetClass(Self.ClassName + CViewFormIdentifier);
  if Assigned(VPersistentClass) then
  begin
    VDataView := Self.Create;
    VDataView.ViewForm := TCustomViewFormClass(VPersistentClass).Create(nil);
    AViewForm := TCustomViewForm(VDataView.ViewForm);
    VDataView.Initialize;
    try
      VDataView.ConfigureViewForm(VDataView.ViewForm);
      VDataView.ViewForm.ShowModal;
      if Assigned(AAfterExecute) then
        AAfterExecute(AViewForm);
    finally
      VDataView.Finalize;
      VDataView.ViewForm.Free;
    end;
  end
  else
    TChequeExceptionHandle.ShowErrorMsg(Format(CViewFormRegError,
      [Self.ClassName]), False);
end;

procedure TCustomView.Edit(var AController: IDataController;
  const AControllerAction: TControllerAction);
begin
  if AControllerAction = caDelete then
    AController.Delete
  else
  begin
    FEditForm := EditFormClass.Create(nil);
    try
      ConfigureEditForm(FEditForm);
      case AControllerAction of
        caEdit: AController.Edit;
        caInsert: AController.Insert;
      end;
      if FEditForm.ShowModal = mrOk then
        AController.Save
      else
        AController.Cancel;
    finally
      FEditForm.Free;
    end;
  end;
end;

{ TCustomController }

function TCustomController.GetModel: IDataModel;
begin
  Result := FModel;
end;

function TCustomController.GetView: IDataView;
begin
  Result := FView;
end;

procedure TCustomController.SetModel(const AValue: IDataModel);
begin
  FModel := AValue;
end;

procedure TCustomController.SetView(const AValue: IDataView);
begin
  FView := AValue;
end;

procedure TCustomController.Initialize;
begin
  FModel := FView.Model;
  FModel.Initialize;
end;

procedure TCustomController.Finalize;
begin
  FModel.Finalize;
end;

procedure TCustomController.Search;
begin
  FModel.Search;
end;

procedure TCustomController.Insert;
begin
  FModel.Insert;
end;

procedure TCustomController.Delete;
begin
  FModel.Delete;
end;

procedure TCustomController.Edit;
begin
  FModel.Edit;
end;

procedure TCustomController.Save;
begin
  FModel.Save;
end;

procedure TCustomController.Cancel;
begin
  FModel.Cancel;
end;

end.

