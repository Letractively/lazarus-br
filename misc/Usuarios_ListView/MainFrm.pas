unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, Controls, Dialogs, StdCtrls, ComCtrls, Menus, ActnList;

type
  { TListViewOperation }

  TListViewOperation = (opAdd, opEdit, opDelete);

  { TMainForm }

  TMainForm = class(TForm)
    InserirButton: TButton;
    UsuariosListaLabel: TLabel;
    EditarButton: TButton;
    ExcluirButton: TButton;
    SairButton: TButton;
    UsuarioListaListView: TListView;
    EditarPopupMenu: TPopupMenu;
    EditarActionList: TActionList;
    InserirAction: TAction;
    EditarAction: TAction;
    ExcluirAction: TAction;
    InserirMenuItem: TMenuItem;
    EditarMenuItem: TMenuItem;
    N1: TMenuItem;
    ExcluirMenuItem: TMenuItem;
    procedure EditarActionExecute(Sender: TObject);
    procedure ExcluirActionExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure InserirActionExecute(Sender: TObject);
    procedure SairButtonClick(Sender: TObject);
    procedure UsuarioListaListViewClick(Sender: TObject);
  private
    procedure ListViewOperation(AListViewOp: TListViewOperation);
    procedure EnabledActions(const AEnabled: Boolean = True);
  end;

  { TUsuario }

  TUsuario = class
    Nome, Email: string;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  UsuarioFrm;

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  UsuarioListaListView.GridLines := True;
end;

procedure TMainForm.SairButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.ListViewOperation(AListViewOp: TListViewOperation);
var
  I: Integer;
  VUsuario: TUsuario;
  VItem: TListItem;
begin
  case AListViewOp of
    opAdd:
      try
        VUsuario := TUsuario.Create;
        if TUsuarioForm.IncluiOuEditaUsuario(VUsuario) then
        begin
          VItem := UsuarioListaListView.Items.Add;
          VItem.Caption := VUsuario.Nome;
          VItem.SubItems.Add(VUsuario.Email);
          VItem.Data := VUsuario;
        end
        else
          VUsuario.Free;
      except
        VUsuario.Free;
        raise;
      end;
    opEdit:
      if Assigned(UsuarioListaListView.Selected) and
        (UsuarioListaListView.SelCount = 1) then
      begin
        VUsuario := TUsuario(UsuarioListaListView.Selected.Data);
        if TUsuarioForm.IncluiOuEditaUsuario(VUsuario) then
        begin
          VItem := UsuarioListaListView.Selected;
          VItem.Caption := VUsuario.Nome;
          VItem.SubItems[0] := VUsuario.Email;
        end;
      end;
    opDelete:
      if (UsuarioListaListView.SelCount > 0) and
        (MessageDlg('Deseja excluir registro(s)?', mtConfirmation,
        [mbYes, mbNo], 0) = mrYes) then
        for I := UsuarioListaListView.Items.Count - 1 downto 0 do
        begin
          VItem := UsuarioListaListView.Items[I];
          if VItem.Selected then
          begin
            TObject(VItem.Data).Free;
            VItem.Delete;
          end;
        end;
  end;
  if UsuarioListaListView.Items.Count < 1 then
    EnabledActions(False);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to Pred(UsuarioListaListView.Items.Count) do
    TObject(UsuarioListaListView.Items[I].Data).Free;
end;

procedure TMainForm.InserirActionExecute(Sender: TObject);
begin
  ListViewOperation(opAdd);
end;

procedure TMainForm.EditarActionExecute(Sender: TObject);
begin
  ListViewOperation(opEdit);
end;

procedure TMainForm.ExcluirActionExecute(Sender: TObject);
begin
  ListViewOperation(opDelete);
end;

procedure TMainForm.UsuarioListaListViewClick(Sender: TObject);
begin
  EnabledActions((UsuarioListaListView.Items.Count > 0) and
    (UsuarioListaListView.SelCount > 0));
end;

procedure TMainForm.EnabledActions(const AEnabled: Boolean = True);
begin
  EditarAction.Enabled := AEnabled;
  ExcluirAction.Enabled := AEnabled;
end;

end.

