unit CustomQueryFrm;

{$I pedido.inc}

interface

uses
  ExtCtrls, StdCtrls, BaseFrm, MainDM;

type

  { TCustomQueryForm }

  TCustomQueryForm = class(TBaseForm)
    ButtonsPanel: TPanel;
    FecharButton: TButton;
    ClientPanel: TPanel;
    EditarButton: TButton;
    ExcluirButton: TButton;
    PesquisarButton: TButton;
    QueryPanel: TPanel;
    SeparatorPanel1: TPanel;
    procedure EditarButtonClick(Sender: TObject);
    procedure ExcluirButtonClick(Sender: TObject);
    procedure PesquisarButtonClick(Sender: TObject);
  protected
    procedure InternalCheckFind; virtual;
    procedure InternalShowData; virtual;
    procedure InternalPopulateData(AEditOperation: TEditOperation);
      reintroduce; virtual;
  end;

const
  CFindRecordOperation: array [0..2] of TFindRecordOperation = (opApproximate,
    opExact, opList);

implementation

{$R *.lfm}

{ TCustomQueryForm }

procedure TCustomQueryForm.PesquisarButtonClick(Sender: TObject);
begin
  InternalCheckFind;
  MainDataModule.OpenTransaction;
  try
    InternalShowData;
    MainDataModule.CommitTransaction;
  except
    MainDataModule.RollbackTransaction;
    raise;
  end;
end;

procedure TCustomQueryForm.EditarButtonClick(Sender: TObject);
begin
  MainDataModule.OpenTransaction;
  try
    InternalPopulateData(eoEdit);
    MainDataModule.CommitTransaction;
  except
    MainDataModule.RollbackTransaction;
    raise;
  end;
end;

procedure TCustomQueryForm.ExcluirButtonClick(Sender: TObject);
begin
  MainDataModule.OpenTransaction;
  try
    InternalPopulateData(eoDelete);
    MainDataModule.CommitTransaction;
  except
    MainDataModule.RollbackTransaction;
    raise;
  end;
end;

procedure TCustomQueryForm.InternalCheckFind;
begin
end;

procedure TCustomQueryForm.InternalShowData;
begin
end;

procedure TCustomQueryForm.InternalPopulateData(AEditOperation: TEditOperation);
begin
end;

end.

