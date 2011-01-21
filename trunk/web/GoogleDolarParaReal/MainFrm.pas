unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, Dialogs, StdCtrls, ExtCtrls, LCLIntf;

type

  { TMainForm }

  TMainForm = class(TForm)
    ConvertButton: TButton;
    NoticeLabel: TLabel;
    LogoImage: TImage;
    USDLabeledEdit: TLabeledEdit;
    EqualLabel: TLabel;
    BRLLabeledEdit: TLabeledEdit;
    ConvertPanel: TPanel;
    procedure ConvertButtonClick(Sender: TObject);
    procedure NoticeLabelClick(Sender: TObject);
  end; 

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  LSHTTPSend;

{ TMainForm }

procedure TMainForm.ConvertButtonClick(Sender: TObject);
var
  S: ShortString;
begin
  S := LSHTTPGetPart('<span class=bld>', ' BRL</span>',
    'http://www.google.com/finance/converter?a=' + USDLabeledEdit.Text +
    '&from=USD&to=BRL');
  if S <> '' then
    BRLLabeledEdit.Text := S
  else
    ShowMessage('Não foi possível fazer a conversão, tente novamente.');
end;

procedure TMainForm.NoticeLabelClick(Sender: TObject);
begin
  OpenURL('http://www.google.com.br/intl/pt-BR/help/currency_disclaimer.html');
end;

end.

