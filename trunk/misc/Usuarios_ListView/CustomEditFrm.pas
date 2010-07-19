unit CustomEditFrm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, Controls, StdCtrls;

type

  { TCustomEditForm }

  TCustomEditForm = class(TForm)
    CancelarButton: TButton;
    SalvarButton: TButton;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure SalvarButtonClick(Sender: TObject);
  protected
    procedure AssertData(AExpression: Boolean; const AMsg: string;
      AWinControl: TWinControl);
    procedure InternalCheckData; virtual;
  end;

implementation

{$R *.lfm}

{ TCustomEditForm }

procedure TCustomEditForm.AssertData(AExpression: Boolean; const AMsg: string;
  AWinControl: TWinControl);
begin
  if not AExpression then
  begin
    AWinControl.SetFocus;
    raise Exception.Create(AMsg);
  end;
end;

procedure TCustomEditForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

procedure TCustomEditForm.InternalCheckData;
begin
end;

procedure TCustomEditForm.SalvarButtonClick(Sender: TObject);
begin
  InternalCheckData;
  ModalResult := mrOk;
end;

end.

