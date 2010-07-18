unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, Dialogs, Buttons;

type

  { TMainForm }

  TMainForm = class(TForm)
    ExecutarBitBtn: TBitBtn;
    procedure ExecutarBitBtnClick(Sender: TObject);
  private
    procedure ExecuteMethod(Sender: TObject; const AMethodName: string);
  published
    procedure MeuMetodo;
  end;

  { TExecute }

  TExecute = procedure of object;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

procedure TMainForm.ExecuteMethod(Sender: TObject; const AMethodName: string);
var
  VMethod: TMethod;
  VExecute: TExecute;
begin
  VMethod.Data := Pointer(Sender);
  VMethod.Code := Sender.MethodAddress(AMethodName);
  if Assigned(VMethod.Code) then
  begin
    VExecute := TExecute(VMethod);
    VExecute;
  end;
end;

procedure TMainForm.MeuMetodo;
begin
  ShowMessage('Meu método foi executado com êxito!');
end;

procedure TMainForm.ExecutarBitBtnClick(Sender: TObject);
begin
  ExecuteMethod(Self, 'MeuMetodo');
end;

end.

