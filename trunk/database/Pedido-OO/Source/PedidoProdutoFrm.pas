unit PedidoProdutoFrm;

{$I pedido.inc}

interface

uses
  SysUtils, sqldb, Controls, ExtCtrls, StdCtrls, CustomEditFrm,
  MainDM;

type

  { TPedidoProdutoForm }

  TPedidoProdutoForm = class(TCustomEditForm)
    DescricaoComboBox: TComboBox;
    DescricaoLabel: TLabel;
    PrecoEdit: TLabeledEdit;
    QuantidadeEdit: TLabeledEdit;
    procedure DescricaoComboBoxCloseUp(Sender: TObject);
    procedure DescricaoComboBoxDropDown(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PrecoEditExit(Sender: TObject);
  private
    FUnidade: string;
  protected
    procedure InternalCheckData; override;
  public
    class function IncluiOuEditaProduto(
      var APedidoProduto: TPedidoProduto): Boolean;
  end;

implementation

{$R *.lfm}

{ TPedidoProdutoForm }

procedure TPedidoProdutoForm.DescricaoComboBoxDropDown(Sender: TObject);
begin
  PopulateComboBox(DescricaoComboBox, 'Produto', 'Oid', 'Descricao');
end;

procedure TPedidoProdutoForm.FormShow(Sender: TObject);
begin
  if DescricaoComboBox.CanFocus then
    DescricaoComboBox.SetFocus;
end;

procedure TPedidoProdutoForm.DescricaoComboBoxCloseUp(Sender: TObject);
var
  VQuery: TSQLQuery;
begin
  if DescricaoComboBox.ItemIndex >= 0 then
  begin
    MainDataModule.OpenTransaction;
    try
      VQuery := TSQLQuery.Create(nil);
      try
        VQuery.DataBase := MainDataModule.MainPQConnection;
        VQuery.Transaction := MainDataModule.MainSQLTransaction;
        VQuery.SQL.Text := 'select Oid, Descricao, Unidade, Preco ' +
          'from Produto where Oid = :Oid';
        FindReference(VQuery.Params.ParamByName('Oid'), DescricaoComboBox);
        VQuery.Open;
        FUnidade := VQuery.FieldByName('Unidade').AsString;
        PrecoEdit.Text := FormattedCurrencyToStr(VQuery.FieldByName(
          'Preco').AsCurrency);
      finally
        VQuery.Free;
      end;
      MainDataModule.CommitTransaction;
      QuantidadeEdit.SetFocus;
    except
      MainDataModule.RollbackTransaction;
      raise;
    end;
  end;
end;

procedure TPedidoProdutoForm.PrecoEditExit(Sender: TObject);
begin
  VerificaValor(TCustomEdit(PrecoEdit));
end;

procedure TPedidoProdutoForm.InternalCheckData;
begin
  AssertData(DescricaoComboBox.Text <> '',
    'Descrição do produto é obrigatório.', DescricaoComboBox);
  AssertData(PrecoEdit.Text <> '',
    'Preço do produto é obrigatório.', PrecoEdit);
  AssertData(QuantidadeEdit.Text <> '',
    'Unidade do produto é obrigatório.', QuantidadeEdit);
end;

class function TPedidoProdutoForm.IncluiOuEditaProduto(
  var APedidoProduto: TPedidoProduto): Boolean;
var
  VProduto: TPedidoProdutoForm;
begin
  VProduto := TPedidoProdutoForm.Create(nil);
  try
    if (APedidoProduto.Descricao <> EmptyStr) then
    begin
      VProduto.DescricaoComboBoxDropDown(VProduto);
      VProduto.DescricaoComboBox.ItemIndex :=
        VProduto.DescricaoComboBox.Items.IndexOf(APedidoProduto.Descricao);
      VProduto.FUnidade := APedidoProduto.Unidade;
      VProduto.PrecoEdit.Text := CurrToStr(APedidoProduto.Preco);
      VProduto.QuantidadeEdit.Text := IntToStr(APedidoProduto.Quantidade);
    end;
    Result := VProduto.ShowModal = mrOk;
    if Result then
    begin
      APedidoProduto.Descricao := VProduto.DescricaoComboBox.Text;
      APedidoProduto.Unidade := VProduto.FUnidade;
      APedidoProduto.Preco := StrToCurr(VProduto.PrecoEdit.Text);
      APedidoProduto.Quantidade := StrToInt(VProduto.QuantidadeEdit.Text);
    end;
    APedidoProduto.TotalProduto :=
      APedidoProduto.Quantidade * APedidoProduto.Preco;
    if VProduto.DescricaoComboBox.ItemIndex >= 0 then
      APedidoProduto.OidProduto :=
        integer(VProduto.DescricaoComboBox.Items.Objects[
        VProduto.DescricaoComboBox.ItemIndex]);
  finally
    VProduto.Free;
  end;
end;

end.

