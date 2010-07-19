unit UsuarioFrm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Controls, MainFrm, CustomEditFrm, ExtCtrls;

type

  { TUsuarioForm }

  TUsuarioForm = class(TCustomEditForm)
    EmailEdit: TLabeledEdit;
    NomeEdit: TLabeledEdit;
  protected
    procedure InternalCheckData; override;
  public
    class function IncluiOuEditaUsuario(var AUsuario: TUsuario): Boolean;
  end;

implementation

{$R *.lfm}

{ TUsuarioForm }

class function TUsuarioForm.IncluiOuEditaUsuario(var AUsuario: TUsuario): Boolean;
var
  VUsuario: TUsuarioForm;
begin
  VUsuario := TUsuarioForm.Create(nil);
  try
    if (AUsuario.Nome <> EmptyStr) then
    begin
      VUsuario.NomeEdit.Text := AUsuario.Nome;
      VUsuario.EmailEdit.Text := AUsuario.Email;
    end;
    Result := VUsuario.ShowModal = mrOk;
    AUsuario.Nome := VUsuario.NomeEdit.Text;
    AUsuario.Email := VUsuario.EmailEdit.Text;
  finally
    VUsuario.Free;
  end;
end;

procedure TUsuarioForm.InternalCheckData;
begin
  AssertData(NomeEdit.Text <> EmptyStr,
    'Nome do usuario obrigatorio.', NomeEdit);
  AssertData(EmailEdit.Text <> EmptyStr,
    'E-mail do usuario obrigatorio.', EmailEdit);
end;

end.

