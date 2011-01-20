unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, StdCtrls, ExtCtrls, ComCtrls, LCLProc,
  HTTPSend;

type

  { TMainForm }

  TMainForm = class(TForm)
    PauseButton: TButton;
    CancelButton: TButton;
    DownloadProgressBar: TProgressBar;
    LogMemo: TMemo;
    ClientPanel: TPanel;
    TopPanel: TPanel;
    DownloadTimer: TTimer;
    StartButton: TButton;
    procedure CancelButtonClick(Sender: TObject);
    procedure DownloadTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PauseButtonClick(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
  private
    FFirstRequest: Boolean;
    FCanDownload: Boolean;
    FHTTPSend: THTTPSend;
    FFileStream: TFileStream;
    FHost: string;
    FFileName: string;
    FTotalDownloadSize: Int64;
  public
    procedure AddToLog(const AInfo: string);
    procedure Download;
    procedure OnMonitor(ASender: TObject; AWriting: Boolean;
      const ABuffer: Pointer; ALength: Integer);
  end;

const
  CURL = 'http://lazsolutions.googlecode.com/files/lssendmail_1.6_win32_all.exe';
//  CURL = 'http://localhost/test.txt'; // Put test.bin in your htdocs folder.
  CKBBySec = 50 * 1024; // Use High(Int64) to download direct.
  CHTTPError = 'Unable to get the "%s". :(';

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FFirstRequest := True;
  FCanDownload := True;
  FHTTPSend := THTTPSend.Create;
  FHTTPSend.Sock.OnMonitor := @OnMonitor;
end;

procedure TMainForm.DownloadTimerTimer(Sender: TObject);
begin
  Download;
end;

procedure TMainForm.CancelButtonClick(Sender: TObject);
begin
  if DownloadTimer.Enabled then
  begin
    DownloadTimer.Enabled := False;
    LogMemo.Text := 'Download cancelled. x(';
  end;
  if FileExistsUTF8(FFileName) then
  begin
    DeleteFileUTF8(FFileName);
    DownloadProgressBar.Position := 0;
    LogMemo.Text := 'File "' + FFileName + '" deleted. x(';
  end;
end;

procedure TMainForm.Download;

  function _FormatHTTPError(const S: string): string;
  begin
    Result := Format(CHTTPError, [S]);
  end;

var
  S: string;
  VFileSize, VContentLength: Int64;
  VOldNameValueSeparator: Char;
begin
  if not FCanDownload then
    Exit;
  try
    FCanDownload := False;
    FHTTPSend.Clear;
    VOldNameValueSeparator := FHTTPSend.Headers.NameValueSeparator;
    FHTTPSend.Headers.NameValueSeparator := ':';
    if FFirstRequest then
    begin
      FHTTPSend.RangeEnd := 1;
      Application.ProcessMessages;
      if FHTTPSend.HTTPMethod('GET', CURL) then
      begin
        if FHTTPSend.ResultCode = 200 then
        begin
          DownloadTimer.Enabled := False;
          FFileStream := TFileStream.Create(FFileName, fmCreate);
          try
            FFileStream.CopyFrom(FHTTPSend.Document, FHTTPSend.Document.Size);
            AddToLog('Total download size: ' + IntToStr(FHTTPSend.Document.Size));
            AddToLog('Download "' + CURL + '" complete and saved in "' +
              FFileName + '". :)');
            DownloadProgressBar.Max := 100;
            DownloadProgressBar.Position := 100;
          finally
            FFileStream.Free;
          end;
          Exit;
        end;
        if FHTTPSend.ResultCode = 206 then
        begin
          FFirstRequest := False;
          AddToLog('Host: ' + FHost);
          AddToLog('File name: ' + FFileName);
          S := FHTTPSend.Headers.Values['content-range'];
          FTotalDownloadSize := StrToInt64Def(GetPart('/', '', S, False, False), 0);
          FCanDownload := True;
        end
        else
        begin
          AddToLog(_FormatHTTPError(CURL));
          Exit;
        end;
      end
      else
      begin
        AddToLog(_FormatHTTPError(CURL));
        Exit;
      end;
    end
    else
    begin
      if FileExistsUTF8(FFileName) then
        FFileStream := TFileStream.Create(FFileName, fmOpenReadWrite)
      else
        FFileStream := TFileStream.Create(FFileName, fmCreate);
      try
        VFileSize := FFileStream.Size;
        if VFileSize >= FTotalDownloadSize then
        begin
          DownloadTimer.Enabled := False;
          AddToLog('Download "' + CURL + '" complete and saved in "' +
            FFileName + '". :)');
          Exit;
        end
        else
        begin
          FFileStream.Position := VFileSize;
          FHTTPSend.RangeStart := VFileSize;
          if VFileSize + CKBBySec < FTotalDownloadSize then
            FHTTPSend.RangeEnd := VFileSize + CKBBySec;
          Application.ProcessMessages;
          if FHTTPSend.HTTPMethod('GET', CURL) then
          begin
            if FHTTPSend.ResultCode = 200 then
            begin
              DownloadTimer.Enabled := False;
              FFileStream.CopyFrom(FHTTPSend.Document, FHTTPSend.Document.Size);
              AddToLog('Total download size: ' + IntToStr(FHTTPSend.Document.Size));
              AddToLog('Download "' + CURL + '" complete and saved in "' +
                FFileName + '". :)');
              DownloadProgressBar.Max := 100;
              DownloadProgressBar.Position := 100;
              Exit;
            end;
            if FHTTPSend.ResultCode = 206 then
            begin
              VContentLength := VFileSize;
              VContentLength +=
                StrToInt64Def(FHTTPSend.Headers.Values['content-length'], 0);
              FFileStream.CopyFrom(FHTTPSend.Document, FHTTPSend.RangeEnd);
              AddToLog('Downloaded: ' + IntToStr(VContentLength));
              DownloadProgressBar.Max := FTotalDownloadSize;
              DownloadProgressBar.Position := VContentLength;
              FCanDownload := True;
              Exit;
            end
            else
            begin
              DownloadTimer.Enabled := False;
              AddToLog(_FormatHTTPError(CURL) + FHTTPSend.Headers.Text);
              Exit;
            end;
          end
          else
          begin
            DownloadTimer.Enabled := False;
            AddToLog(_FormatHTTPError(CURL));
            Exit;
          end;
        end;
      finally
        FFileStream.Free;
      end;
    end;
  finally
    FHTTPSend.Headers.NameValueSeparator := VOldNameValueSeparator;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FHTTPSend.Free;
end;

procedure TMainForm.PauseButtonClick(Sender: TObject);
const
  CPauseStatus: array[Boolean] of ShortString = ('Paused', 'Pause');
  CPauseLogStatus: array[Boolean] of ShortString = ('Paused...', 'Resume...');
begin
  DownloadTimer.Enabled := not DownloadTimer.Enabled;
  PauseButton.Caption := CPauseStatus[DownloadTimer.Enabled];
  AddToLog(CPauseLogStatus[DownloadTimer.Enabled]);
end;

procedure TMainForm.StartButtonClick(Sender: TObject);
begin
  FFirstRequest := True;
  FCanDownload := True;
  LogMemo.Clear;
  DownloadTimer.OnTimer(Self);
  DownloadTimer.Enabled := True;
end;

procedure TMainForm.AddToLog(const AInfo: string);
begin
  LogMemo.Lines.Add(AInfo);
end;

procedure TMainForm.OnMonitor(ASender: TObject; AWriting: Boolean;
  const ABuffer: Pointer; ALength: Integer);
var
  S: string;
begin
  if AWriting and FFirstRequest then
  begin
    FHost := Trim(FHTTPSend.Headers.Values['host']);
    S := FHTTPSend.Headers.Text;
    S := GetPart('get ', ' http', S, True, False);
    FFileName := ExtractFilePath(ParamStrUTF8(0)) + ExtractFileName(S);
  end;
end;

end.

