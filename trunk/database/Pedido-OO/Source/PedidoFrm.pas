unit PedidoFrm;

{$I pedido.inc}

interface

uses
  SysUtils, sqldb, Controls, Dialogs, ExtCtrls, StdCtrls, ComCtrls,
  CustomEditFrm, MainDM;

type

  { TPedidoForm }

  TPedidoForm = class(TCustomEditForm)
    DataEdit: TLabeledEdit;
    EditarButton: TButton;
    ExcluirProdutoButton: TButton;
    IncluirProdutoButton: TButton;
    NumeroPedidoEdit: TLabeledEdit;
    ProdutoListView: TListView;
    ProdutosLabel: TLabel;
    TotalGeralEdit: TLabeledEdit;
    procedure DataEditExit(Sender: TObject);
    procedure EditarButtonClick(Sender: TObject);
    procedure ExcluirProdutoButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IncluirProdutoButtonClick(Sender: TObject);
  private
    FNumeroPedido: Integer;
    procedure ListViewOperation(AListViewOperation: TListViewOperation);
  protected
    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    procedure InternalCheckData; override;
    procedure InternalPopulateData; override;
  end;

implementation

{$R *.lfm}

uses
  PedidoProdutoFrm;

{ TPedidoForm }

procedure TPedidoForm.DataEditExit(Sender: TObject);
begin
  VerificaData(DataEdit);
end;

procedure TPedidoForm.EditarButtonClick(Sender: TObject);
begin
  ListViewOperation(opEdit);
end;

procedure TPedidoForm.ExcluirProdutoButtonClick(Sender: TObject);
begin
  ListViewOperation(opDelete);
end;

procedure TPedidoForm.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to Pred(ProdutoListView.Items.Count) do
    TObject(ProdutoListView.Items[I].Data).Free;
  inherited;
end;

procedure TPedidoForm.FormShow(Sender: TObject);
begin
  FNumeroPedido := SequenceNextValue('Seq_NumeroPedido');
  NumeroPedidoEdit.Text := Format('%10.10d', [FNumeroPedido]);
  DataEdit.Text := FormatDateTime('dd/mm/yyyy', Date);
end;

procedure TPedidoForm.IncluirProdutoButtonClick(Sender: TObject);
begin
  ListViewOperation(opAdd);
end;

procedure TPedidoForm.ListViewOperation(AListViewOperation: TListViewOperation);
var
  I: Integer;
  VItem: TListItem;
  VTotalGeral: currency;
  VPedidoProduto: TPedidoProduto;
begin
  case AListViewOperation of
    opAdd:
      try
        VPedidoProduto := TPedidoProduto.Create;
        if TPedidoProdutoForm.IncluiOuEditaProduto(VPedidoProduto) then
        begin
          VItem := ProdutoListView.Items.Add;
          VItem.Caption := VPedidoProduto.Descricao;
          VItem.SubItems.Add(VPedidoProduto.Unidade);
          VItem.SubItems.Add(FormattedCurrencyToStr(VPedidoProduto.Preco));
          VItem.SubItems.Add(IntToStr(VPedidoProduto.Quantidade));
          VItem.SubItems.Add(FormattedCurrencyToStr(
            VPedidoProduto.TotalProduto));
          VItem.Data := VPedidoProduto;
        end
        else
          VPedidoProduto.Free
      except
        VPedidoProduto.Free;
        raise;
      end;
    opEdit:
      if Assigned(ProdutoListView.Selected) and
        (ProdutoListView.SelCount = 1) then
      begin
        VPedidoProduto := TPedidoProduto(ProdutoListView.Selected.Data);
        if TPedidoProdutoForm.IncluiOuEditaProduto(VPedidoProduto) then
        begin
          VItem := ProdutoListView.Selected;
          VItem.Caption := VPedidoProduto.Descricao;
          VItem.SubItems[0] := VPedidoProduto.Unidade;
          VItem.SubItems[1] := FormattedCurrencyToStr(VPedidoProduto.Preco);
          VItem.SubItems[2] := IntToStr(VPedidoProduto.Quantidade);
          VItem.SubItems[3] :=
            FormattedCurrencyToStr(VPedidoProduto.TotalProduto);
        end;
      end;
    opDelete:
      if (ProdutoListView.SelCount > 0) and
        (MessageDlg('Deseja excluir registro(s)?', mtConfirmation,
        [mbYes, mbNo], 0) = mrYes) then
        for I := Pred(ProdutoListView.Items.Count) downto 0 do
        begin
          VItem := ProdutoListView.Items[I];
          if VItem.Selected then
          begin
            TObject(VItem.Data).Free;
            VItem.Delete;
          end;
        end;
  end;
  VTotalGeral := 0;
  TotalGeralEdit.Clear;
  for I := 0 to Pred(ProdutoListView.Items.Count) do
  begin
    VItem := ProdutoListView.Items[I];
    VTotalGeral := VTotalGeral + TPedidoProduto(VItem.Data).TotalProduto;
    TotalGeralEdit.Text := FormattedCurrencyToStr(VTotalGeral);
  end;
end;

procedure TPedidoForm.InternalCheckData;
begin
  AssertData(ProdutoListView.Items.Count <> 0,
    'É necessário ao menos um produto no pedido.', ProdutoListView);
  AssertData(DataEdit.Text <> '',
    'Data do pedido é obrigatória.', DataEdit);
end;

procedure TPedidoForm.InternalPopulateData;
var
  VItem: TListItem;
  I, VPedidoOid: Integer;
  VPedidoProduto: TPedidoProduto;
  VPedidoQuery, VPedidoItemQuery: TSQLQuery;
begin
  VPedidoQuery := TSQLQuery.Create(nil);
  try
    VPedidoQuery.DataBase := MainDataModule.MainPQConnection;
    VPedidoQuery.Transaction := MainDataModule.MainSQLTransaction;
    VPedidoQuery.SQL.Text :=
      'insert into Pedido (Oid, NumeroPedido, Data, TotalGeral) ' +
      'values (:Oid, :NumeroPedido, :Data, :TotalGeral)';
    VPedidoOid := PopulatePK(VPedidoQuery.Params.ParamByName('Oid'));
    VPedidoQuery.Params.ParamByName('NumeroPedido').AsInteger := FNumeroPedido;
    PopulateDate(VPedidoQuery.Params.ParamByName('Data'), DataEdit.Text);
    PopulateCurrency(VPedidoQuery.Params.ParamByName('TotalGeral'),
      TotalGeralEdit.Text);
    VPedidoQuery.ExecSQL;
    VPedidoItemQuery := TSQLQuery.Create(nil);
    try
      VPedidoItemQuery.DataBase := MainDataModule.MainPQConnection;
      VPedidoItemQuery.Transaction := MainDataModule.MainSQLTransaction;
      VPedidoItemQuery.SQL.Text :=
        'insert into PedidoItem (Oid, OidPedido, OidProduto, Preco, ' +
        'Quantidade, TotalProduto) values (:Oid, :OidPedido, :OidProduto, ' +
        ':Preco, :Quantidade, :TotalProduto)';
      for I := 0 to Pred(ProdutoListView.Items.Count) do
      begin
        PopulatePK(VPedidoItemQuery.Params.ParamByName('Oid'));
        VPedidoItemQuery.Params.ParamByName('OidPedido').AsInteger :=
          VPedidoOid;
        VItem := (ProdutoListView.Items[I]);
        VPedidoProduto := TPedidoProduto(VItem.Data);
        VPedidoItemQuery.Params.ParamByName('OidProduto').AsInteger :=
          VPedidoProduto.OidProduto;
        VPedidoItemQuery.Params.ParamByName('Preco').AsCurrency :=
          VPedidoProduto.Preco;
        VPedidoItemQuery.Params.ParamByName('Quantidade').AsInteger :=
          VPedidoProduto.Quantidade;
        VPedidoItemQuery.Params.ParamByName('TotalProduto').AsCurrency :=
          VPedidoProduto.TotalProduto;
        VPedidoItemQuery.ExecSQL;
      end;
    finally
      VPedidoItemQuery.Free;
    end;
  finally
    VPedidoQuery.Free;
  end;
end;

end.

