unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, StdCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    GetButton: TButton;
    WordEdit: TEdit;
    procedure GetButtonClick(Sender: TObject);
  end;

const
  CPriberamTmpFileName = 'priberam_tmp.html';
  CURL = 'http://www.priberam.pt/dlpo/default.aspx?pal=%s';
  CErrorMsg = 'Não foi possível obter a definição de "%s". ' +
    'Por favor, tente novamente.';

var
  MainForm: TMainForm;
  ProberamTmpFile: TFileName;

implementation

{$R *.lfm}

uses
  LSHTTPSend, SynaCode, LCLIntf;

{ TMainForm }

procedure TMainForm.GetButtonClick(Sender: TObject);
var
  VDefines: TStrings;
begin
  VDefines := TStringList.Create;
  try
    if LSHTTPGetText(Format(CURL, [EncodeURL(WordEdit.Text)]), VDefines) then
    begin
      VDefines.SaveToFile(ProberamTmpFile);
      OpenURL(ProberamTmpFile);
    end
    else
      ShowMessage(Format(CErrorMsg, [WordEdit.Text]));
  finally
    VDefines.Free;
  end;
end;

initialization
  ProberamTmpFile := GetTempDir + CPriberamTmpFileName;

finalization
  DeleteFile(ProberamTmpFile);

end.

