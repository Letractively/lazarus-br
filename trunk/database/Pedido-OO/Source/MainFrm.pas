unit MainFrm;

{$I pedido.inc}

interface

uses
  Forms, Menus;

type

  { TMainForm }

  TMainForm = class(TForm)
    ArquivosMenuGroup: TMenuItem;
    CadastroPedidoMenuItem: TMenuItem;
    CadastroProdutosMenuItem: TMenuItem;
    CadastroMenuGroup: TMenuItem;
    ConsultaPedidoMenuItem: TMenuItem;
    ConsultaProdutoMenuItem: TMenuItem;
    ConsultaMenuGroup: TMenuItem;
    MainMenu: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    SairMenuItem: TMenuItem;
    procedure CadastroPedidoMenuItemClick(Sender: TObject);
    procedure CadastroProdutosMenuItemClick(Sender: TObject);
    procedure ConsultaPedidoMenuItemClick(Sender: TObject);
    procedure ConsultaProdutoMenuItemClick(Sender: TObject);
    procedure SairMenuItemClick(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  ProdutoFrm, PedidoFrm, ProdutoQueryFrm, PedidoQueryFrm;

{ TMainForm }

procedure TMainForm.CadastroProdutosMenuItemClick(Sender: TObject);
begin
  TProdutoForm.Execute;
end;

procedure TMainForm.ConsultaPedidoMenuItemClick(Sender: TObject);
begin
  TPedidoQueryForm.Execute;
end;

procedure TMainForm.ConsultaProdutoMenuItemClick(Sender: TObject);
begin
  TProdutoQueryForm.Execute;
end;

procedure TMainForm.CadastroPedidoMenuItemClick(Sender: TObject);
begin
  TPedidoForm.Execute;
end;

procedure TMainForm.SairMenuItemClick(Sender: TObject);
begin
  Close;
end;

end.

