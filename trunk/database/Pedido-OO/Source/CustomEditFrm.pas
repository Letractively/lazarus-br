unit CustomEditFrm;

{$I pedido.inc}

interface

uses
  Controls, ExtCtrls, StdCtrls, MainDM, BaseFrm;

type

  { TCustomEditForm }

  TCustomEditForm = class(TBaseForm)
    ButtonsPanel: TPanel;
    CancelarButton: TButton;
    ClientPanel: TPanel;
    SalvarButton: TButton;
    SeparatorPanel: TPanel;
    procedure SalvarButtonClick(Sender: TObject);
  end;

implementation

{$R *.lfm}

{ TCustomEditForm }

procedure TCustomEditForm.SalvarButtonClick(Sender: TObject);
begin
  InternalCheckData;
  MainDataModule.OpenTransaction;
  try
    InternalPopulateData;
    MainDataModule.CommitTransaction;
  except
    MainDataModule.RollbackTransaction;
    raise;
  end;
  ModalResult := mrOk;
end;

end.

