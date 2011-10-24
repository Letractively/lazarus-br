unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    ResultButton: TButton;
    ResultLabel: TLabel;
    procedure ResultButtonClick(Sender: TObject);
  end; 

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  LSHTTPSend;

{ TMainForm }

procedure TMainForm.ResultButtonClick(Sender: TObject);
begin
  ResultLabel.Caption := LSHTTPGetPart('<div class=''sorteio''><ul> ',
    ' </ul></div>', 'http://www1.caixa.gov.br/_newincludes/inc_loterias_caixa.asp');
end;

end.

