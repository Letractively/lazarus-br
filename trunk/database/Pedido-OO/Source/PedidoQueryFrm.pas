unit PedidoQueryFrm;

{$I pedido.inc}

interface

uses
  SysUtils, sqldb, StdCtrls, ExtCtrls, ComCtrls, MainDM, CustomQueryFrm;

type

  { TPedidoQueryForm }

  TPedidoQueryForm = class(TCustomQueryForm)
    SugerirButton: TButton;
    PedidoListView: TListView;
    TipoPesquisaGroupBox: TGroupBox;
    DeEdit: TLabeledEdit;
    AteEdit: TLabeledEdit;
    procedure DeEditExit(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SugerirButtonClick(Sender: TObject);
  private
    procedure ListViewClearData(var AListView: TListView);
  protected
    procedure InternalCheckFind; override;
    procedure InternalShowData; override;
  end;

implementation

{$R *.lfm}

uses
  DateUtils;

{ TPedidoQueryForm }

procedure TPedidoQueryForm.InternalShowData;
const
  CDateDBFrmt = 'dd.mm.yyyy';
  CSql = 'select Oid, NumeroPedido, Data, TotalGeral from Pedido ' +
    'where Data between ''%s'' and ''%s'' order by Oid';
var
  VListItem: TListItem;
  VPedido: TPedido;
  VPedidoQuery: TSQLQuery;
begin
  VPedidoQuery := TSQLQuery.Create(nil);
  try
    VPedidoQuery.DataBase := MainDataModule.MainPQConnection;
    VPedidoQuery.Transaction := MainDataModule.MainSQLTransaction;
    VPedidoQuery.SQL.Text :=
      Format(CSql, [FormatDateTime(CDateDBFrmt, StrToDate(DeEdit.Text)),
      FormatDateTime(CDateDBFrmt, StrToDate(AteEdit.Text))]);
    VPedidoQuery.Open;
    VPedidoQuery.First;
    ListViewClearData(PedidoListView);
    PedidoListView.Clear;
    while not VPedidoQuery.EOF do
    begin
      VPedido := TPedido.Create;
      VListItem := PedidoListView.Items.Add;
      VPedido.Oid := VPedidoQuery.FieldByName('Oid').AsInteger;
      VPedido.NumeroPedido := VPedidoQuery.FieldByName('NumeroPedido').AsInteger;
      VListItem.Caption := Format('%10.10d', [VPedido.NumeroPedido]);
      VPedido.Data := VPedidoQuery.FieldByName('Data').AsDateTime;
      VListItem.SubItems.Add(DateToStrFrm(VPedido.Data));
      VPedido.TotalGeral := VPedidoQuery.FieldByName('TotalGeral').AsCurrency;
      VListItem.SubItems.Add(FormattedCurrencyToStr(VPedido.TotalGeral));
      VListItem.Data := VPedido;
      VPedidoQuery.Next;
    end;
    if PedidoListView.Items.Count > 0 then
    begin
      PedidoListView.SetFocus;
      PedidoListView.ItemIndex := 0;
    end;
    VPedidoQuery.First;
  finally
    VPedidoQuery.Free;
  end;
end;

procedure TPedidoQueryForm.FormShow(Sender: TObject);
begin
  inherited;
  EditarButton.Visible := False;
  ExcluirButton.Visible := False;
end;

procedure TPedidoQueryForm.SugerirButtonClick(Sender: TObject);
begin
  AteEdit.Text := DateToStrFrm(Date);
  DeEdit.Text := DateToStrFrm(IncDay(Date, -15));
end;

procedure TPedidoQueryForm.ListViewClearData(var AListView: TListView);
var
  I: Integer;
begin
  for I := 0 to Pred(AListView.Items.Count) do
    TObject(AListView.Items[I].Data).Free;
end;

procedure TPedidoQueryForm.InternalCheckFind;
begin
  AssertData(DeEdit.Text <> '', 'Informe a data inicial.', DeEdit);
  AssertData(AteEdit.Text <> '', 'Informe a data final.', AteEdit);
end;

procedure TPedidoQueryForm.FormDestroy(Sender: TObject);
begin
  ListViewClearData(PedidoListView);
  inherited;
end;

procedure TPedidoQueryForm.DeEditExit(Sender: TObject);
begin
  VerificaData(TCustomEdit(Sender));
end;

end.

