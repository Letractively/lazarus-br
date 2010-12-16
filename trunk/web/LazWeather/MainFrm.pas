unit MainFrm; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, ExtCtrls, Buttons, StdCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    CityLabeledEdit: TLabeledEdit;
    ConsultBitBtn: TBitBtn;
    ConditionImage: TImage;
    ClientPanel: TPanel;
    TempLabel: TLabel;
    StateLabeledEdit: TLabeledEdit;
    procedure ConsultBitBtnClick(Sender: TObject);
  end;

const
  CURL = 'http://www.accuweather.com/%s/%s/%s/%s/quick-look.aspx';

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  LSHTTPSend, SynaCode, LCLProc;

{ TMainForm }

procedure TMainForm.ConsultBitBtnClick(Sender: TObject);
var
  S: string;
  VHTML: TStringList;
begin
  TempLabel.Caption := '';
  ConditionImage.Picture.Clear;
  VHTML := TStringList.Create;
  try
    if LSHTTPGetText(EncodeURL(Format(CURL, ['pt-br', 'br',
      StateLabeledEdit.Text, CityLabeledEdit.Text])), VHTML) then
    begin
      S := VHTML.GetText;
      TempLabel.Caption := GetPart(
        '<span id="ctl00_cphContent_lblCurrentTemp" style="display: block; ' +
        'font-weight: bold;font-size: 18px; line-height: 24px;">',
        '&deg;C</span>', S, True, False) + ' °C';
      try
        LSHTTPGetPicture(GetPart(
          '<img id="ctl00_cphContent_imgCurConCondition" class="fltLeft" src="',
          '"', S, True, False), ConditionImage.Picture);
      except
      end;
    end
    else
      ShowMessage('Não foi possível obter a previsão do tempo para "' +
        CityLabeledEdit.Text + ', ' + StateLabeledEdit.Text + '".');
  finally
    VHTML.Free;
  end;
end;

end.

