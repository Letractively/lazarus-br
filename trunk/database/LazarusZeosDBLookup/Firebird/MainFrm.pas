unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  LResources, Forms, DBCtrls, ComCtrls, StdCtrls, DBGrids, DB,
  ZDataset, ZConnection, SysUtils, ZDbcIntfs, Controls;

type

  { TMainForm }

  TMainForm = class(TForm)
    ProdutoDBLookupComboBox: TDBLookupComboBox;
    PedidosDataSource: TDatasource;
    PedidosZQueryID: TLongintField;
    PedidosZQueryNOMEPRODUTO: TStringField;
    PedidosZQueryVALOR: TFloatField;
    ProdutosDataSource: TDatasource;
    MainDBNavigator: TDBNavigator;
    ProdutoEdit: TDBEdit;
    ProdutosZQueryID: TLongintField;
    ProdutosZQueryNOME: TStringField;
    ProdutosZQueryVALOR: TFloatField;
    ValorEdit: TDBEdit;
    PedidosDBGrid: TDBGrid;
    ProdutoLabel: TLabel;
    ValorLabel: TLabel;
    MainPageControl: TPageControl;
    PedidosTabSheet: TTabSheet;
    ProdutosTabSheet: TTabSheet;
    MainZConnection: TZConnection;
    ProdutosZQuery: TZQuery;
    PedidosZQuery: TZQuery;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MainPageControlPageChanged(Sender: TObject);
    procedure PedidosDBGridSelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure PedidosZQueryNOMEPRODUTOValidate(Sender: TField);
  end;

const
  CDefaultExpression = 'gen_id(G_MAIN, 1) as GenValue from rdb$database';

var
  MainForm: TMainForm;

implementation

{ TMainForm }

procedure TMainForm.FormShow(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to Pred(ComponentCount) do
    if Components[I] is TCustomEdit then
      TCustomEdit(Components[I]).CharCase := ecUppercase;
  ProdutosZQueryID.DefaultExpression := CDefaultExpression;
  PedidosZQueryID.DefaultExpression := CDefaultExpression;
  MainPageControlPageChanged(Self);
end;

procedure TMainForm.MainPageControlPageChanged(Sender: TObject);
begin
  if MainZConnection.Connected then
  begin
    ProdutosZQuery.Close;
    PedidosZQuery.Close;
    MainDBNavigator.DataSource := nil;
    case MainPageControl.TabIndex of
      0:
      begin
        MainDBNavigator.DataSource := ProdutosDataSource;
        ProdutosZQuery.Open;
      end;
      1:
      begin
        MainDBNavigator.DataSource := PedidosDataSource;
        ProdutosZQuery.Open;
        PedidosZQuery.Active := not ProdutosZQuery.IsEmpty;
      end;
    end;
  end;
end;

procedure TMainForm.PedidosDBGridSelectEditor(Sender: TObject;
  Column: TColumn; var Editor: TWinControl);
begin
  if (Column.Field.FieldName = ProdutoDBLookupComboBox.DataField) then
  begin
    ProdutoDBLookupComboBox.Left := Editor.Left;
    ProdutoDBLookupComboBox.Width := Editor.Width;
    ProdutoDBLookupComboBox.Top := Editor.Top;
    Editor := ProdutoDBLookupComboBox;
  end;
end;

procedure TMainForm.PedidosZQueryNOMEPRODUTOValidate(Sender: TField);
begin
  PedidosZQueryVALOR.AsCurrency := ProdutosZQueryVALOR.AsCurrency;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  MainZConnection.Disconnect;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  with MainZConnection do
  begin
    Database := ExtractFilePath(ParamStr(0)) + 'data.fdb';
    HostName := '127.0.0.1';
    Password := 'masterkey';
    Protocol := 'firebird-2.1';
    User := 'SYSDBA';
    SQLHourGlass := True;
    TransactIsolationLevel := tiReadCommitted;
    Connect;
  end;
end;

initialization
  {$I MainFrm.lrs}
  CurrencyFormat := 2;
  CurrencyString := 'R$';
  DecimalSeparator := ',';
  ThousandSeparator := '.';

end.

