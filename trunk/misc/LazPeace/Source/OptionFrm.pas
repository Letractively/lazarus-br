unit OptionFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, Controls, StdCtrls, ComCtrls, Buttons, ActnList, ExtCtrls, SysUtils;

type

  { TOptionForm }

  TOptionForm = class(TForm)
    CancelAction: TAction;
    CancelBitBtn: TBitBtn;
    PrintAsTXTCheckBox: TCheckBox;
    SendMsgToEmailCheckBox: TCheckBox;
    FromEdit: TEdit;
    FromLabel: TLabel;
    EmailGroupBox: TGroupBox;
    SMTPConnectionGroupBox: TGroupBox;
    HostEdit: TEdit;
    HostLabel: TLabel;
    PasswordEdit: TEdit;
    PasswordLabel: TLabel;
    PortEdit: TEdit;
    PortLabel: TLabel;
    SSLCheckBox: TCheckBox;
    TLSCheckBox: TCheckBox;
    OKAction: TAction;
    OKBitBtn: TBitBtn;
    OptionActionList: TActionList;
    OptionPageControl: TPageControl;
    BottomPanel: TPanel;
    RandomMessageCheckBox: TCheckBox;
    ShiftCtrlFCheckBox: TCheckBox;
    StartInGotasLuzCheckBox: TCheckBox;
    StartWithOSCheckBox: TCheckBox;
    ConfigurationTabSheet: TTabSheet;
    SMTPTabSheet: TTabSheet;
    TimerMessageBeginLabe: TLabel;
    TimerMessageEdit: TEdit;
    TimerMessageEndLabe: TLabel;
    TimerMessageUpDown: TUpDown;
    ToEdit: TEdit;
    ToLabel: TLabel;
    UserEdit: TEdit;
    UserLabel: TLabel;
    procedure CancelActionExecute(Sender: TObject);
    procedure OKActionExecute(Sender: TObject);
    procedure TimerMessageEditChange(Sender: TObject);
  public
    class procedure Execute;
  end;

implementation

{$R *.lfm}

uses
  MainFrm;

{ TOptionForm }

procedure TOptionForm.OKActionExecute(Sender: TObject);
begin
  Close;
  ModalResult := mrOk;
end;

procedure TOptionForm.TimerMessageEditChange(Sender: TObject);
begin
  SendMsgToEmailCheckBox.Enabled := TimerMessageUpDown.Position > 29;
end;

procedure TOptionForm.CancelActionExecute(Sender: TObject);
begin
  Close;
  ModalResult := mrCancel;
end;

class procedure TOptionForm.Execute;
begin
  with TOptionForm.Create(nil) do
    try
      MainForm.LoadOption;
      ShiftCtrlFCheckBox.Checked := MainForm.ShiftCtrlF;
      StartWithOSCheckBox.Checked := MainForm.StartWithOS;
      RandomMessageCheckBox.Checked := MainForm.RandomMessage;
      StartInGotasLuzCheckBox.Checked := MainForm.StartInGotasLuz;
      TimerMessageUpDown.Position := MainForm.TimerMessageInterval;
      UserEdit.Text := MainForm.SMTPUser;
      PasswordEdit.Text := MainForm.SMTPPassword;
      HostEdit.Text := MainForm.SMTPHost;
      PortEdit.Text := IntToStr(MainForm.SMTPPort);
      SSLCheckBox.Checked := MainForm.SMTPSSL;
      TLSCheckBox.Checked := MainForm.SMTPTLS;
      FromEdit.Text := MainForm.FromMail;
      ToEdit.Text := MainForm.ToMail;
      SendMsgToEmailCheckBox.Checked := MainForm.SendMsgToEmail;
      PrintAsTXTCheckBox.Checked := MainForm.PrintAsTXT;
      if ShowModal = mrOk then
      begin
        MainForm.ShiftCtrlF := ShiftCtrlFCheckBox.Checked;
        MainForm.StartWithOS := StartWithOSCheckBox.Checked;
        MainForm.RandomMessage := RandomMessageCheckBox.Checked;
        MainForm.StartInGotasLuz := StartInGotasLuzCheckBox.Checked;
        MainForm.TimerMessageInterval := TimerMessageUpDown.Position;
        MainForm.SMTPUser := UserEdit.Text;
        MainForm.SMTPPassword := PasswordEdit.Text;
        MainForm.SMTPHost := HostEdit.Text;
        MainForm.SMTPPort := StrToIntDef(PortEdit.Text, 465);
        MainForm.SMTPSSL := SSLCheckBox.Checked;
        MainForm.SMTPTLS := TLSCheckBox.Checked;
        MainForm.FromMail := FromEdit.Text;
        MainForm.ToMail := ToEdit.Text;
        MainForm.SendMsgToEmail := SendMsgToEmailCheckBox.Checked;
        MainForm.PrintAsTXT := PrintAsTXTCheckBox.Checked;
        MainForm.SaveOption;
        MainForm.LoadOption;
      end;
    finally
      Free;
    end;
end;

end.

