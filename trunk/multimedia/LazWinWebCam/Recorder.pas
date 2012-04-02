{
  Video Capturing and Processing Application

  Author: Bogdan Razvan Adrian
  The application itself can be used under Lazarus modified LGPL or MPL

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}

unit Recorder;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, SysUtils, Forms, Controls, Graphics, StdCtrls, ExtCtrls,
  Clipbrd, VFW;

type

  { TVideo }

  TVideo = class(TForm)
    bSource: TButton;
    bFormat: TButton;
    bReconnect: TButton;
    bQuality: TButton;
    bRecord: TButton;
    bShot: TButton;
    iSnapshot: TImage;
    pControl: TPanel;
    pCapture: TPanel;
    stCapture: TStaticText;
    procedure bShotClick(Sender: TObject);
    procedure VideoCreate(Sender: TObject);
    procedure VideoDestroy(Sender: TObject);
    procedure VideoShow(Sender: TObject);
    procedure bConnectClick(Sender: TObject);
    procedure bFormatClick(Sender: TObject);
    procedure bQualityClick(Sender: TObject);
    procedure bRecordClick(Sender: TObject);
    procedure bSourceClick(Sender: TObject);
    procedure pCaptureResize(Sender: TObject);
  public
    FCapHandle: THandle;             // Capture window handle
    FCreated: Boolean;             // Window created
    FConnected: Boolean;             // Driver connected
    FDriverCaps: TCapDriverCaps;      // Driver capabilities
    FLiveVideo: Boolean;             // Live Video enabled
    FRecording: Boolean;             // Recording video
    FFileName: string;              // AVI file name
    procedure CapCreate;              // Create capture window
    procedure CapConnect;             // Connect/Reconnect window + driver
    procedure CapEnableViewer;        // Start Live Video (Preview or Overlay)
    procedure CapDisableViewer;       // Stop Live Video
    procedure CapRecord;              // Start recording
    procedure CapStop;                // Stop recording
    procedure CapGrabFrame(Destination: TBitmap); // Get one live frame
    procedure CapDisconnect;          // Disconnect driver
    procedure CapDestroy;             // Destroy capture window
    procedure Hook;                   // Set hook on form to trap system msgs
    procedure Unhook;                 // Clear the hook
  end;

  TMWndProc = Windows.WNDPROC;

var
  Video: TVideo;
  WM_TSRECORD, WM_TSSTOP: UInt;
  OldProc: TMWndProc;

function MsgProc(Handle: HWnd; Msg: UInt; WParam: Windows.WParam;
  LParam: Windows.LParam): LResult; stdcall;

implementation

{$R *.lfm}

procedure TVideo.CapCreate;
begin
  CapDestroy; // Destroy if necessary
  with pCapture do
    FCapHandle := capCreateCaptureWindow('Video Window', WS_CHILDWINDOW or
      WS_VISIBLE or WS_CLIPCHILDREN or WS_CLIPSIBLINGS
      {or WS_OVERLAPPED or WS_SIZEBOX}
      , 5, 5, Width - 10, Height - 10, Handle, 0);

  if FCapHandle <> 0 then
    FCreated := True
  else
  begin
    FCreated := False;
    stCapture.Caption := 'ERROR creating capture window !!!';
  end;
end;

procedure TVideo.CapConnect;
begin
  if FCreated then
  begin
    CapDisconnect;                           // Disconnect if necessary
    if capDriverConnect(FCapHandle, 0) then  // Connect the Capture Driver
    begin
      FConnected := True;
      capDriverGetCaps(FCapHandle, @FDriverCaps, SizeOf(TCapDriverCaps));
      if FDriverCaps.fHasOverlay then
        stCapture.Caption := 'Driver connected, accepts overlay'
      else
        stCapture.Caption := 'Driver connected, software rendering';
    end
    else
    begin
      FConnected := False;
      stCapture.Caption := 'ERROR connecting capture driver !!!';
    end;
  end;
end;

procedure TVideo.CapEnableViewer;
begin
  FLiveVideo := False;
  if FConnected then
  begin
    capPreviewScale(FCapHandle, True);     // Allow stretching
    if FDriverCaps.fHasOverlay then        // Driver accepts overlay
    begin
      capPreviewRate(FCapHandle, 0);       // Overlay framerate is auto
      if capOverlay(FCapHandle, True) then // Try to display Hardware
      begin
        FLiveVideo := True;
        stCapture.Caption := 'Video Capture - Overlay (Hardware)';
      end;
    end
    else                                   // Driver doesn't accept overlay
    begin
      capPreviewRate(FCapHandle, 33);      // Preview framerate in ms/frame
      if capPreview(FCapHandle, True) then // Try to display Software
      begin
        FLiveVideo := True;
        stCapture.Caption := 'Video Capture - Preview (Software)';
      end;
    end;
    if FLiveVideo = False then
      stCapture.Caption := 'ERROR configuring capture driver !!!';
  end;
end;

procedure TVideo.CapDisableViewer;
begin
  if FLiveVideo then
  begin
    if FDriverCaps.fHasOverlay then
      capOverlay(FCapHandle, False)
    else
      capPreview(FCapHandle, False);
    FLiveVideo := False;
  end;
end;

procedure TVideo.CapRecord;
begin
  CapStop;
  CapDisableViewer;
  FFileName := ExtractFilePath(Application.ExeName) +
    FormatDateTime('"Clip "[dd mm yyyy hh mm ss]".avi"', Now);
  stCapture.Caption := 'Recording ' + FFileName;
  bRecord.Caption := 'S&top';
  capFileSetCaptureFile(FCapHandle, PChar(FFileName));
  capCaptureSequence(FCapHandle);
  capFileSaveAs(FCapHandle, PChar(FFileName));
  FRecording := True;
end;

procedure TVideo.CapStop;
begin
  if FRecording then
  begin
    capCaptureStop(FCapHandle);
    FRecording := False;
    RenameFile(FFileName, ChangeFileExt(FFileName,
      FormatDateTime(' - [dd mm yyyy hh mm ss]".avi"', Now)));
    CapEnableViewer;
    stCapture.Caption := 'Recording stopped';
    bRecord.Caption := '&Record';
  end;
end;

procedure TVideo.CapGrabFrame(Destination: TBitmap);
begin
  capGrabFrameNoStop(FCapHandle);        // Copy the current frame to a buffer
  capEditCopy(FCapHandle);               // Copy from buffer to the clipboard
  if Clipboard.HasFormat(CF_Bitmap) then // Load the frame/image from clipboard
    Destination.LoadFromClipboardFormat(CF_Bitmap);
end;

procedure TVideo.CapDisconnect;
begin
  if FConnected then
  begin
    capDriverDisconnect(FCapHandle);
    FConnected := False;
  end;
end;

procedure TVideo.CapDestroy;
begin
  if FCreated then
  begin
    DestroyWindow(FCapHandle);
    FCreated := False;
  end;
end;

procedure TVideo.Hook;
begin
  OldProc := TMWndProc(Windows.GetWindowLong(Handle, GWL_WNDPROC));
  Windows.SetWindowLong(Handle, GWL_WNDPROC, longint(@MsgProc));
end;

procedure TVideo.Unhook;
begin
  if Assigned(OldProc) then
    Windows.SetWindowLong(Handle, GWL_WNDPROC, longint(OldProc));
  OldProc := nil;
end;

function MsgProc(Handle: HWnd; Msg: UInt; WParam: Windows.WParam;
  LParam: Windows.LParam): LResult; stdcall;
begin
  with Video do
  begin
    if Msg = WM_TSRECORD then
      CapRecord
    else if Msg = WM_TSSTOP then
      CapStop
    else
      Result := Windows.CallWindowProc(OldProc, Handle, Msg, WParam, LParam);
  end;
end;

{ TVideo }

procedure TVideo.VideoCreate(Sender: TObject);
begin
  WM_TSRECORD := RegisterWindowMessage('TSRecord');
  WM_TSSTOP := RegisterWindowMessage('TSStop');
  if LowerCase(ParamStr(1)) = 'hide' then
  begin
    Visible := False;
    Hide;
    ShowWindow(Handle, SW_HIDE);

    // For some reason Lazarus always shows the main form after creating it trick it
    BorderStyle := bsNone;
    Width := 0;
    Height := 0;
  end;
  CapCreate;
  CapConnect;
  CapEnableViewer;
  FFileName := 'Clip.avi';
  Hook;
end;

procedure TVideo.bShotClick(Sender: TObject);
var
  VFielName: string;
begin
  VFielName := ExtractFilePath(ParamStr(0)) + 'snapshot.jpg';
  CapDisableViewer;
  iSnapshot.Picture.Clear;
  iSnapshot.Canvas.CopyRect(pCapture.ClientRect, pCapture.Canvas,
    pCapture.ClientRect);
  iSnapshot.Picture.Jpeg.SaveToFile(VFielName);
  ShellExecute(Handle, 'open', PChar(VFielName), nil, nil, 0);
end;

procedure TVideo.VideoDestroy(Sender: TObject);
begin
  UnHook;
  CapDisableViewer;
  CapDisconnect;
  CapDestroy;
end;

procedure TVideo.VideoShow(Sender: TObject);
begin
  //  ShowWindow(Handle, SW_HIDE);
end;

procedure TVideo.bConnectClick(Sender: TObject);
begin
  CapConnect;
  CapEnableViewer;
end;

procedure TVideo.bFormatClick(Sender: TObject);
begin
  capDlgVideoFormat(FCapHandle);
end;

procedure TVideo.bQualityClick(Sender: TObject);
begin
  capDlgVideoCompression(FCapHandle);
end;

procedure TVideo.bRecordClick(Sender: TObject);
begin
  if FRecording then
    CapStop
  else
    CapRecord;
end;

procedure TVideo.bSourceClick(Sender: TObject);
begin
  capDlgVideoSource(FCapHandle);
end;

procedure TVideo.pCaptureResize(Sender: TObject);
begin
  with Video.pCapture do
    if FCreated then  // Adjust coordinates
      MoveWindow(FCapHandle, 5, 5, Width - 10, Height - 10, False);
end;

end.

