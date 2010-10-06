unit SimpleHTMLReport;

{$mode objfpc}{$H+}

interface

uses
  DB, Classes, Forms, OSPrinters;

type

  { TSimpleHTMLReport }

  TSimpleHTMLReport = class
  private
    FBrowserTitle: string;
    FDataSet: TDataSet;
    FOpenInBrowser: Boolean;
    FReportTitle: string;
    FStriped: Boolean;
    FTemplate: string;
    class function DeleteTempFile: Boolean;
  public
    constructor Create;
    procedure Execute(const AWindowState: TWindowState = wsMaximized);
    property DataSet: TDataSet read FDataSet write FDataSet;
    property BrowserTitle: string read FBrowserTitle write FBrowserTitle;
    property ReportTitle: string read FReportTitle write FReportTitle;
    property Template: string read FTemplate write FTemplate;
    property Striped: Boolean read FStriped write FStriped;
    property OpenInBrowser: Boolean
      read FOpenInBrowser write FOpenInBrowser default False;
  end;

function OpenURL(AURL: string): Boolean;

implementation

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF UNIX}
  UTF8Process,
{$ENDIF}
  SimpleHTMLReportTemplate, SimpleHTMLReportFrm, FileUtil, SysUtils;

var
  _HTMLTemp: string = '';

{ TSimpleHTMLReport }

class function TSimpleHTMLReport.DeleteTempFile: Boolean;
begin
  Result := DeleteFile(_HTMLTemp);
end;

constructor TSimpleHTMLReport.Create;
begin
  FStriped := True;
  FOpenInBrowser := False;
end;

procedure TSimpleHTMLReport.Execute(
  const AWindowState: TWindowState = wsMaximized);
var
  I, J, K, VOldRecNo: Integer;
  VFileStream: TFileStream;
  VSimpleHTMLReportForm: TSimpleHTMLReportForm;
  VSimpleHTMLReportTemplate: TSimpleHTMLReportTemplate;
begin
  VSimpleHTMLReportForm := TSimpleHTMLReportForm.Create(nil);
  VSimpleHTMLReportTemplate := TSimpleHTMLReportTemplate.Create;
  try
    VSimpleHTMLReportTemplate.BrowserTitle := FBrowserTitle;
    VSimpleHTMLReportTemplate.ReportTitle := FReportTitle;
    for I := 0 to Pred(FDataSet.FieldCount) do
      VSimpleHTMLReportTemplate.AddReportTableHeaderCell(
        FDataSet.Fields[I].DisplayLabel);
    try
      VOldRecNo := FDataSet.RecNo;
      FDataSet.DisableControls;
      FDataSet.First;
      for I := 0 to Pred(FDataSet.RecordCount) do
      begin
        if FStriped then
        begin
          if boolean(FDataSet.RecNo mod 2) then
          begin
            VSimpleHTMLReportTemplate.AddReportEvenBeginCells;
            for J := 0 to Pred(FDataSet.FieldCount) do
              VSimpleHTMLReportTemplate.AddReportEvenValueCells(
                FDataSet.Fields[J].AsString);
            VSimpleHTMLReportTemplate.AddReportEvenEndCells;
          end
          else
          begin
            VSimpleHTMLReportTemplate.AddReportOddBeginCells;
            for J := 0 to Pred(FDataSet.FieldCount) do
              VSimpleHTMLReportTemplate.AddReportOddValueCells(
                FDataSet.Fields[J].AsString);
            VSimpleHTMLReportTemplate.AddReportOddEndCells;
          end;
        end
        else
        begin
          VSimpleHTMLReportTemplate.AddReportEvenBeginCells;
          for K := 0 to Pred(FDataSet.FieldCount) do
            VSimpleHTMLReportTemplate.AddReportEvenValueCells(
              FDataSet.Fields[K].AsString);
          VSimpleHTMLReportTemplate.AddReportEvenEndCells;
        end;
        FDataSet.Next;
      end;
    finally
      FDataSet.RecNo := VOldRecNo;
      FDataSet.EnableControls;
    end;
    FTemplate := VSimpleHTMLReportTemplate.Template;
    VFileStream := TFileStream.Create(_HTMLTemp, fmCreate);
    try
      VFileStream.Write(Pointer(FTemplate)^, Length(FTemplate));
    finally
      VFileStream.Free;
    end;
    if FOpenInBrowser then
      OpenURL(_HTMLTemp)
    else
    begin
      VSimpleHTMLReportForm.Caption := FBrowserTitle;
      VSimpleHTMLReportForm.Position := poDesktopCenter;
      VSimpleHTMLReportForm.WindowState := AWindowState;
      VSimpleHTMLReportForm.ReportIpHtmlPanel.AllowTextSelect := False;
      VSimpleHTMLReportForm.ReportIpHtmlPanel.OpenURL(_HTMLTemp);
      VSimpleHTMLReportForm.ShowModal;
      TSimpleHTMLReport.DeleteTempFile;
    end;
  finally
    VSimpleHTMLReportForm.Free;
    VSimpleHTMLReportTemplate.Free;
  end;
end;

(*
  Function implemented in LCLInft Unit of the Lazarus version >= 0.9.29
*)
function FindDefaultBrowser(out ABrowser, AParams: string): Boolean;

  function Find(const ShortFilename: string; out ABrowser: string): Boolean; inline;
  begin
    ABrowser := SearchFileInPath(ShortFilename + GetExeExt, '',
      GetEnvironmentVariableUTF8('PATH'), PathSeparator,
      [sffDontSearchInBasePath]);
    Result := ABrowser <> '';
  end;

begin
  {$IFDEF MSWindows}
  Find('rundll32', ABrowser);
  AParams := 'url.dll,FileProtocolHandler %s';
  {$ELSE}
    {$IFDEF DARWIN}
  // open command launches url in the appropriate browser under Mac OS X
  Find('open', ABrowser);
  AParams := '%s';
    {$ELSE}
  ABrowser := '';
    {$ENDIF}
  {$ENDIF}
  if ABrowser = '' then
  begin
    AParams := '%s';
    // Then search in path. Prefer open source ;)
    if Find('xdg-open', ABrowser)  // Portland OSDL/FreeDesktop standard on Linux
      or Find('htmlview', ABrowser)  // some redhat systems
      or Find('firefox', ABrowser) or Find('mozilla', ABrowser) or
      Find('galeon', ABrowser) or Find('konqueror', ABrowser) or
      Find('safari', ABrowser) or Find('netscape', ABrowser) or
      Find('opera', ABrowser) or Find('iexplore', ABrowser) then
    ;// some windows systems
  end;
  Result := ABrowser <> '';
end;

(*
  Function implemented in LCLInft Unit of the Lazarus version >= 0.9.29
*)
{$IFDEF Windows}
function OpenURL(AURL: string): Boolean;
var
{$IFDEF WinCE}
  Info: SHELLEXECUTEINFO;
{$ELSE}
  ws: WideString;
  ans: ansistring;
{$ENDIF}
begin
  Result := False;
  if AURL = '' then
    Exit;

  {$IFDEF WinCE}
  FillChar(Info, SizeOf(Info), 0);
  Info.cbSize := SizeOf(Info);
  Info.fMask := SEE_MASK_FLAG_NO_UI;
  Info.lpVerb := 'open';
  Info.lpFile := PWideChar(UTF8Decode(AURL));
  Result := ShellExecuteEx(@Info);
  {$ELSE}
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    ws := UTF8Decode(AURL);
    Result := ShellExecuteW(0, 'open', PWideChar(ws), nil, nil, 0) > 32;
  end
  else
  begin
    ans := Utf8ToAnsi(AURL); // utf8 must be converted to Windows Ansi-codepage
    Result := ShellExecute(0, 'open', PAnsiChar(ans), nil, nil, 0) > 32;
  end;
  {$ENDIF}
end;
{$ELSE}
{$IFDEF DARWIN}
function OpenURL(AURL: string): Boolean;
var
  cf: CFStringRef;
  url: CFURLRef;
  w: WideString;
begin
  if AURL = '' then
    Exit(False);
  cf := CFStringCreateWithCString(kCFAllocatorDefault, @AURL[1], kCFStringEncodingUTF8);
  if not Assigned(cf) then
    Exit(False);
  url := CFURLCreateWithString(nil, cf, nil);
  Result := LSOpenCFURLRef(url, nil) = 0;
  CFRelease(url);
  CFRelease(cf);
end;
{$ELSE}
function OpenURL(AURL: string): Boolean;
var
  ABrowser, AParams: string;
  BrowserProcess: TProcessUTF8;
begin
  Result := FindDefaultBrowser(ABrowser, AParams) and FileExistsUTF8(ABrowser) and
    FileIsExecutable(ABrowser);
  if not Result then
    Exit;

  // run
  BrowserProcess := TProcessUTF8.Create(nil);
  try
    BrowserProcess.CommandLine := ABrowser + ' ' + Format(AParams, [AURL]);
    BrowserProcess.Execute;
  finally
    BrowserProcess.Free;
  end;
end;
{$ENDIF}
{$ENDIF}

initialization
  TSimpleHTMLReport.DeleteTempFile;
  _HTMLTemp := GetTempDir + 'shtmlr.html';

finalization
  TSimpleHTMLReport.DeleteTempFile;

end.

