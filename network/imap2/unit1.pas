unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  imapsend, ssl_openssl, mimemess, mimepart;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  imap: TIMAPSend;
  i, j, cnt, spcnt: integer;
  FolderList: TStringList;
  MimeMess: TMimeMess;
  MimePart: TMimePart;
  s: string;
begin
  imap := TIMAPSend.Create;
  FolderList := TStringList.Create;
  MimeMess := TMimeMess.Create;
  try
    imap.TargetHost := 'smtp.host.com';
    imap.UserName := 'email@host.com';
    imap.Password := 'password';
    if imap.Login then
    begin
      //get all folders
      imap.List('', FolderList);
      for i := 0 to FolderList.Count - 1 do
      begin
        // are there any unread messages?
        cnt := imap.StatusFolder(FolderList[i], 'UNSEEN');
        if cnt > 0 then
        begin
          imap.SelectROFolder(FolderList[i]);
          // get last SelectedRecent messages
          for j := imap.SelectedCount - imap.SelectedRecent to imap.SelectedCount do
          begin
            imap.FetchMess(j, MimeMess.Lines);
            // deocde header and body
            MimeMess.DecodeMessage;
            Memo1.Lines.Add('--------------------------------------------------');
            Memo1.Lines.Add(MimeMess.Header.From);
            Memo1.Lines.Add(MimeMess.Header.Subject);
            // is this multipart
            spcnt := MimeMess.MessagePart.GetSubPartCount();
            if spcnt > 0 then
              //get all parts
              for cnt := 0 to spcnt - 1 do
              begin
                MimePart := MimeMess.MessagePart.GetSubPart(cnt);
                MimePart.DecodePart;
                Memo1.Lines.Add('-----------------------');
                Memo1.Lines.Append(MimePart.Primary + ' ; ' + MimePart.Secondary);
                Memo1.Lines.Add('-----------------------');
                setlength(s, MimePart.DecodedLines.Size);
                MimePart.DecodedLines.Read(s[1], length(s));
                Memo1.Lines.Add(s);
              end
            else
              //print body
              Memo1.Lines.AddStrings(MimeMess.MessagePart.Lines);
          end;
        end;
      end;
    end;
  finally
    MimeMess.Free;
    FolderList.Free;
    imap.Free;
  end;
end;

end.

