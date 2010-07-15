unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    CryptButton: TButton;
    DeCryptButton: TButton;
    CryptEdit: TEdit;
    CryptedEdit: TEdit;
    DeCryptEdit: TEdit;
    MD5RadioButton: TRadioButton;
    SHA1RadioButton: TRadioButton;
    procedure CryptButtonClick(Sender: TObject);
    procedure DeCryptButtonClick(Sender: TObject);
    procedure MD5RadioButtonChange(Sender: TObject);
  end;

  TCryptType = (ctCrypt, ctDeCrypt);

  const
    CCryptKey = 'your key';

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  DCPrc6, DCPcrypt2, DCPmd5, DCPsha1;

function Crypt(const AString: string; const AHashType: TDCP_hashclass;
  const AKey: string = CCryptKey; const ACryptType: TCryptType = ctCrypt): string;
var
  VDCP_rc6: TDCP_rc6;
begin
  VDCP_rc6 := TDCP_rc6.Create(nil);
  try
    if AHashType = TDCP_md5 then
      VDCP_rc6.InitStr(CCryptKey, TDCP_md5)
    else
      VDCP_rc6.InitStr(CCryptKey, TDCP_sha1);
    if ACryptType = ctCrypt then
      Result := VDCP_rc6.EncryptString(AString)
    else
      Result := VDCP_rc6.DecryptString(AString);
  finally
    VDCP_rc6.Burn;
    VDCP_rc6.Free;
  end;
end;

{ TMainForm }

procedure TMainForm.CryptButtonClick(Sender: TObject);
begin
  if MD5RadioButton.Checked then
    CryptedEdit.Text := Crypt(CryptEdit.Text, TDCP_md5)
  else
    CryptedEdit.Text := Crypt(CryptEdit.Text, TDCP_sha1);
end;

procedure TMainForm.DeCryptButtonClick(Sender: TObject);
begin
  if MD5RadioButton.Checked then
    DeCryptEdit.Text := Crypt(CryptedEdit.Text, TDCP_md5, CCryptKey, ctDeCrypt)
  else
    DeCryptEdit.Text := Crypt(CryptedEdit.Text, TDCP_sha1, CCryptKey, ctDeCrypt);
end;

procedure TMainForm.MD5RadioButtonChange(Sender: TObject);
begin
  CryptEdit.Text := 'My text';
  CryptedEdit.Clear;
  DeCryptEdit.Clear;
end;

end.

