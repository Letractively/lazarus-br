unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, StdCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    GetButton: TButton;
    CEPEdit: TEdit;
    procedure GetButtonClick(Sender: TObject);
  end;

const
  CCEPTmpFileName = 'cep_tmp.html';
  CURL =
    'http://www.buscacep.correios.com.br/servicos/dnec/' +
    'consultaLogradouroAction.do?CEP=%s&Metodo=listaLogradouro&' +
    'TipoConsulta=cep&StartRow=1&EndRow=10';
  CErrorMsg = 'Não foi possível obter o CEP "%s". Por favor, tente novamente.';

var
  MainForm: TMainForm;
  CEPTmpFile: TFileName;

implementation

{$R *.lfm}

uses
  LSHTTPSend, LCLIntf;

{ TMainForm }

procedure TMainForm.GetButtonClick(Sender: TObject);
var
  VCEPs: TStrings;
begin
  VCEPs := TStringList.Create;
  try
    if LSHTTPGetText(Format(CURL, [CEPEdit.Text]), VCEPs) then
    begin
      VCEPs.SaveToFile(CEPTmpFile);
      OpenURL(CEPTmpFile);
    end
    else
      ShowMessage(Format(CErrorMsg, [CEPEdit.Text]));
  finally
    VCEPs.Free;
  end;
end;

initialization
  CEPTmpFile := GetTempDir + CCEPTmpFileName;

finalization
  DeleteFile(CEPTmpFile);

end.

