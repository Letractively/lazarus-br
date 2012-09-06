unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  imapsend;

procedure TForm1.Button1Click(Sender: TObject);
var
  imap: TImapSend;
  n: integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  imap := TImapSend.Create;
  imap.UserName := 'test@host.com';
  imap.Password := 'password';
  imap.TargetHost := 'imap.host.com.br';
  if imap.Login then
  begin
    Memo1.Clear;
    // get the folder list into ListBox1
    if ListBox1.Items.Count = 0 then
    begin
      imap.List('', ListBox1.Items);
      ListBox1.ItemIndex := 0;
    end;
    // select the Inbox
    if imap.SelectFolder(ListBox1.GetSelectedText) then
    begin
      // loop through the items
      for n := 1 to imap.SelectedCount do
      begin
        // get each message's header
        if imap.FetchHeader(n, sl) then
        begin
          // and append them to a TMemo
          Memo1.Lines.AddStrings(sl);
          Memo1.Lines.Append('');
        end;
      end;
      imap.CloseFolder;
    end;
    imap.Logout;
  end;
  imap.Free;
  sl.Free;
end;

end.

