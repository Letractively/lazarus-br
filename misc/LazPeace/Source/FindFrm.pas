unit FindFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls, Buttons, ActnList, Controls, SysUtils, Dialogs;

type

  { TFindForm }

  TFindForm = class(TForm)
    CloseAction: TAction;
    FindAction: TAction;
    FindActionList: TActionList;
    FindBitBtn: TBitBtn;
    FindEdit: TEdit;
    WordLabel: TLabel;
    procedure CloseActionExecute(Sender: TObject);
    procedure FindActionExecute(Sender: TObject);
  public
    class procedure Execute;
  end;

implementation

{$R *.lfm}

uses
  MainFrm;

{ TFindForm }

procedure TFindForm.FindActionExecute(Sender: TObject);
begin
  Close;
  ModalResult := mrOk;
end;

procedure TFindForm.CloseActionExecute(Sender: TObject);
begin
  Close;
  ModalResult := mrCancel;
end;

class procedure TFindForm.Execute;
const
  CPreSelect = 'select * from %s where lower(mensagem) like (''%%%s%%'');';
var
  VPreSelect: string;
begin
  with TFindForm.Create(nil) do
    try
      ShowModal;
      if ModalResult = mrOk then
      begin
        MainForm.MessageZReadOnlyQuery.Close;
        case MainForm.BookRadioGroup.ItemIndex of
          0: VPreSelect := Format(CPreSelect, ['minutos', FindEdit.Text]);
          1: VPreSelect := Format(CPreSelect, ['gotas', FindEdit.Text]);
        end;
        MainForm.MessageZReadOnlyQuery.SQL.Text := VPreSelect;
        MainForm.MessageZReadOnlyQuery.Open;
        if MainForm.MessageZReadOnlyQuery.RecordCount <= 0 then
          ShowMessage('Não foi possível encontrar a palavra "' +
            FindEdit.Text + '".')
        else
          if MainForm.ShiftCtrlF then
            ShowMessage('Use Shift+Ctrl+F para remover o filtro de localização.');
      end;
    finally
      Free;
    end;
end;

end.

