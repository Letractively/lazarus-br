unit ProdutoFrm;

{$I pedido.inc}

interface

uses
  SysUtils, sqldb, Controls, ExtCtrls, StdCtrls, CustomEditFrm, MainDM;

type

  { TProdutoForm }

  TProdutoForm = class(TCustomEditForm)
    DescricaoEdit: TLabeledEdit;
    PrecoEdit: TLabeledEdit;
    UnidadeComboBox: TComboBox;
    UnidadeLabel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure PrecoEditExit(Sender: TObject);
  protected
    procedure InternalCheckData; override;
    procedure InternalPopulateData; override;
  public
    class function EditaProduto(var AProduto: TProduto): Boolean;
  end;

var
  ProdutoFormIsEditing: Boolean = False;

implementation

{$R *.lfm}

{ TProdutoForm }

procedure TProdutoForm.PrecoEditExit(Sender: TObject);
begin
  VerificaValor(TCustomEdit(PrecoEdit));
end;

procedure TProdutoForm.FormShow(Sender: TObject);
begin
  inherited;
  DescricaoEdit.SetFocus;
end;

procedure TProdutoForm.InternalCheckData;
begin
  AssertData(DescricaoEdit.Text <> '',
    'Descrição do produto é obrigatório.', DescricaoEdit);
  AssertData(UnidadeComboBox.Text <> '',
    'Unidade do produto é obrigatório.', UnidadeComboBox);
  AssertData(PrecoEdit.Text <> '',
    'Preço do produto é obrigatório.', PrecoEdit);
end;

procedure TProdutoForm.InternalPopulateData;
var
  VProdutoQuery: TSQLQuery;
begin
  if ProdutoFormIsEditing then
    Exit;
  VProdutoQuery := TSQLQuery.Create(nil);
  try
    VProdutoQuery.DataBase := MainDataModule.MainPQConnection;
    VProdutoQuery.Transaction := MainDataModule.MainSQLTransaction;
    VProdutoQuery.SQL.Text := 'insert into Produto (Oid, Descricao, Unidade, ' +
      'Preco) values (:Oid, :Descricao, :Unidade, :Preco)';
    PopulatePK(VProdutoQuery.Params.ParamByName('Oid'));
    VProdutoQuery.Params.ParamByName('Descricao').AsString := DescricaoEdit.Text;
    VProdutoQuery.Params.ParamByName('Unidade').AsString := UnidadeComboBox.Text;
    PopulateCurrency(VProdutoQuery.Params.ParamByName('Preco'), PrecoEdit.Text);
    VProdutoQuery.ExecSQL;
  finally
    VProdutoQuery.Free;
  end;
end;

class function TProdutoForm.EditaProduto(var AProduto: TProduto): Boolean;
var
  VProduto: TProdutoForm;
begin
  VProduto := TProdutoForm.Create(nil);
  try
    if (AProduto.Descricao <> EmptyStr) then
    begin
      VProduto.DescricaoEdit.Text := AProduto.Descricao;
      VProduto.UnidadeComboBox.ItemIndex :=
        VProduto.UnidadeComboBox.Items.IndexOf(AProduto.Unidade);
      VProduto.PrecoEdit.Text := FormattedCurrencyToStr(AProduto.Preco);
    end;
    Result := VProduto.ShowModal = mrOk;
    if Result then
    begin
      AProduto.Descricao := VProduto.DescricaoEdit.Text;
      AProduto.Unidade := VProduto.UnidadeComboBox.Text;
      AProduto.Preco := StrToCurr(VProduto.PrecoEdit.Text);
    end;
  finally
    VProduto.Free;
  end;
end;

end.

