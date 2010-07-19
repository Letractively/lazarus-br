unit ProdutoQueryFrm;

{$I pedido.inc}

interface

uses
  SysUtils, sqldb, Controls, Dialogs, ExtCtrls, StdCtrls, ComCtrls,
  CustomQueryFrm, MainDM, DB;

type

  { TProdutoQueryForm }

  TProdutoQueryForm = class(TCustomQueryForm)
    DescricaoEdit: TLabeledEdit;
    ProdutoListView: TListView;
    TipoPesquisaRadioGroup: TRadioGroup;
    procedure EditarButtonClick(Sender: TObject);
    procedure ExcluirButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PesquisarButtonClick(Sender: TObject);
    procedure TipoPesquisaRadioGroupClick(Sender: TObject);
  private
    procedure ListViewOperation(AListViewOperation: TListViewOperation);
    procedure ListViewClearData(var AListView: TListView);
  protected
    procedure CheckFind;
    procedure InternalShowData; override;
    procedure InternalPopulateData(AEditOperation: TEditOperation); override;
  end;

implementation

{$R *.lfm}

uses
  ProdutoFrm;

{ TProdutoQueryForm }

procedure TProdutoQueryForm.EditarButtonClick(Sender: TObject);
begin
  if TipoPesquisaRadioGroup.ItemIndex <> 2 then
    CheckFind;
  ProdutoFormIsEditing := True;
  inherited;
end;

procedure TProdutoQueryForm.ExcluirButtonClick(Sender: TObject);
begin
  if TipoPesquisaRadioGroup.ItemIndex <> 2 then
    CheckFind;
  inherited;
end;

procedure TProdutoQueryForm.FormDestroy(Sender: TObject);
begin
  inherited;
  ListViewClearData(ProdutoListView);
end;

procedure TProdutoQueryForm.FormShow(Sender: TObject);
begin
  inherited;
  (TipoPesquisaRadioGroup.Controls[0] as TRadioButton).SetFocus;
end;

procedure TProdutoQueryForm.PesquisarButtonClick(Sender: TObject);
begin
  if TipoPesquisaRadioGroup.ItemIndex <> 2 then
    CheckFind
  else if MessageDlg('Listar todos os registros pode ser um ' +
    'processo demorado, deseja prosseguir?', mtConfirmation,
    [mbYes, mbNo], 0) = mrNo then
    Exit;
  inherited;
end;

procedure TProdutoQueryForm.TipoPesquisaRadioGroupClick(Sender: TObject);
begin
  inherited;
  DescricaoEdit.Enabled := TipoPesquisaRadioGroup.ItemIndex <> 2;
end;

procedure TProdutoQueryForm.ListViewOperation(AListViewOperation: TListViewOperation);
var
  S: string;
  I: Integer;
  VItem: TListItem;
  VProduto: TProduto;
  VProdutoQuery: TSQLQuery;
begin
  VProdutoQuery := TSQLQuery.Create(nil);
  VProdutoQuery.DataBase := MainDataModule.MainPQConnection;
  VProdutoQuery.Transaction := MainDataModule.MainSQLTransaction;
  try
    case AListViewOperation of
      opEdit:
        if Assigned(ProdutoListView.Selected) and
          (ProdutoListView.SelCount = 1) then
        begin
          VProduto := TProduto(ProdutoListView.Selected.Data);
          ProdutoFormIsEditing := True;
          if TProdutoForm.EditaProduto(VProduto) then
          begin
            VProdutoQuery.SQL.Text :=
              Format('update Produto set ' +
              'Descricao = ''%s'', Unidade = ''%s'', Preco = %s ' +
              'where Oid = %d', [VProduto.Descricao, VProduto.Unidade,
              CurrencyToDBStr(VProduto.Preco), VProduto.Oid]);
            VProdutoQuery.ExecSQL;
            VItem := ProdutoListView.Selected;
            VItem.Caption := VProduto.Descricao;
            VItem.SubItems[0] := VProduto.Unidade;
            VItem.SubItems[1] := FormattedCurrencyToStr(VProduto.Preco);
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
              try
                VProdutoQuery.SQL.Text :=
                  Format('delete from Produto ' + 'where Oid = %d',
                  [TProduto(VItem.Data).Oid]);
                VProdutoQuery.ExecSQL;
                if VProdutoQuery.RowsAffected = 0 then
                  ShowMessage('Registro não existe.');
                TObject(VItem.Data).Free;
                VItem.Delete;
              except
                on E: EDatabaseError do
                begin
                  S := Copy(E.Message, 0, 24);
                  if S = 'violation of FOREIGN KEY' then
                    ShowMessage('Registro é referencia em outra tabela.');
                end
                else
                  raise;
              end;
          end;
    end;
  finally
    VProdutoQuery.Free;
  end;
end;

procedure TProdutoQueryForm.ListViewClearData(var AListView: TListView);
var
  I: Integer;
begin
  for I := 0 to Pred(AListView.Items.Count) do
    TObject(AListView.Items[I].Data).Free;
end;

procedure TProdutoQueryForm.CheckFind;
begin
  AssertData(DescricaoEdit.Text <> '', 'Informe um registro.',
    DescricaoEdit);
end;

procedure TProdutoQueryForm.InternalShowData;
var
  VListItem: TListItem;
  VProduto: TProduto;
  VProdutoQuery: TSQLQuery;
begin
  VProdutoQuery := TSQLQuery.Create(nil);
  try
    VProdutoQuery.DataBase := MainDataModule.MainPQConnection;
    VProdutoQuery.Transaction := MainDataModule.MainSQLTransaction;
    VProdutoQuery.SQL.Text := FindRecords('Oid, Descricao, Unidade, ' +
      'Preco', 'Produto', 'Descricao', DescricaoEdit.Text,
      CFindRecordOperation[TipoPesquisaRadioGroup.ItemIndex], True);
    VProdutoQuery.Open;
    VProdutoQuery.First;
    ListViewClearData(ProdutoListView);
    ProdutoListView.Clear;
    while not VProdutoQuery.EOF do
    begin
      VProduto := TProduto.Create;
      VListItem := ProdutoListView.Items.Add;
      VProduto.Oid := VProdutoQuery.FieldByName('Oid').AsInteger;
      VProduto.Descricao := VProdutoQuery.FieldByName('Descricao').AsString;
      VListItem.Caption := VProduto.Descricao;
      VProduto.Unidade := VProdutoQuery.FieldByName('Unidade').AsString;
      VListItem.SubItems.Add(VProduto.Unidade);
      VProduto.Preco := VProdutoQuery.FieldByName('Preco').AsCurrency;
      VListItem.SubItems.Add(FormattedCurrencyToStr(VProduto.Preco));
      VListItem.Data := VProduto;
      VProdutoQuery.Next;
    end;
    if ProdutoListView.Items.Count > 0 then
    begin
      ProdutoListView.SetFocus;
      ProdutoListView.ItemIndex := 0;
    end;
    VProdutoQuery.First;
  finally
    VProdutoQuery.Free;
  end;
end;

procedure TProdutoQueryForm.InternalPopulateData(AEditOperation: TEditOperation);
begin
  case AEditOperation of
    eoEdit: ListViewOperation(opEdit);
    eoDelete: ListViewOperation(opDelete);
  end;
end;

end.

