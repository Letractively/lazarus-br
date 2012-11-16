unit frmMain;

{$mode objfpc}{$H+}

interface

uses
  RFB, Classes, SysUtils, Forms, Dialogs, StdCtrls, ExtCtrls, FPJSON, LCLIntf;

type
  TfrMain = class(TForm)
    btQuery: TButton;
    edDocument: TEdit;
    imCaptcha: TImage;
    lbDocument: TLabel;
    edCaptcha: TEdit;
    lbCaptcha: TLabel;
    btGetCaptcha: TButton;
    procedure edCaptchaKeyPress(Sender: TObject; var Key: char);
    procedure edDocumentKeyPress(Sender: TObject; var Key: char);
    procedure btQueryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btGetCaptchaClick(Sender: TObject);
  private
    FGuid: string;
    FState: string;
    FCookie: string;
  end;

var
  frMain: TfrMain;

implementation

{$R *.lfm}

procedure TfrMain.btGetCaptchaClick(Sender: TObject);
var
  VImage: TStream = nil;
begin
  RFBPrepare(FGuid, FState, FCookie);
  try
    RFBGetCaptcha(VImage, FGuid);
    imCaptcha.Picture.Clear;
    imCaptcha.Picture.LoadFromStream(VImage);
  finally
    FreeAndNil(VImage);
  end;
end;

procedure TfrMain.edDocumentKeyPress(Sender: TObject; var Key: char);
begin
  edCaptchaKeyPress(Sender, Key);
  if Key in [' ', '.', '/', '-', 'a'..'z', 'A'..'Z'] then
    Key := #0;
end;

procedure TfrMain.btQueryClick(Sender: TObject);
var
  VJSON: TJSONObject = nil;
begin
  if Trim(edDocument.Text) = '' then
  begin
    ShowMessage(SEmptyDocumentError);
    edDocument.SetFocus;
    Exit;
  end;
  if Trim(edCaptcha.Text) = '' then
  begin
    ShowMessage(SEmptyCaptchaError);
    edCaptcha.SetFocus;
    Exit;
  end;
  try
    RFBQuery(VJSON, FCookie, FState, edCaptcha.Text, edDocument.Text);
    ShowMessageFmt('Nome: %s' + LineEnding + 'Situação: %s' + LineEnding +
      'Documento: %s', [VJSON['name'].AsString, VJSON['status'].AsString,
      VJSON['querieddocument'].AsString]);
    edDocument.Clear;
    btGetCaptcha.SetFocus;
    edCaptcha.Clear;
    imCaptcha.Picture.Clear;
  finally
    FreeAndNil(VJSON);
  end;
end;

procedure TfrMain.edCaptchaKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
  begin
    btQueryClick(Sender);
    Key := #0;
  end;
end;

procedure TfrMain.FormShow(Sender: TObject);
begin
  btGetCaptchaClick(Sender);
end;

end.

