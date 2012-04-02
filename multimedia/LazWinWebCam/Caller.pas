unit Caller;

{$mode objfpc}{$H+}

interface

uses
  Windows, Forms, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    bRecord: TButton;
    bStop: TButton;
    procedure Form1Create(Sender: TObject);
    procedure Form1Destroy(Sender: TObject);
    procedure bRecordClick(Sender: TObject);
    procedure bStopClick(Sender: TObject);
  private
  public
    procedure Hook;
    procedure Unhook;
  end;

  TMWndProc = Windows.WNDPROC;

var
  Form1: TForm1;
  WM_TSRECORD, WM_TSSTOP: UInt;
  OldProc: TMWndProc;

function MsgProc(Handle: HWnd; Msg: UInt; WParam: Windows.WParam;
  LParam: Windows.LParam): LResult; stdcall;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.bRecordClick(Sender: TObject);
begin
  BroadcastSystemMessage(BSF_POSTMESSAGE, PDWORD(BSM_ALLCOMPONENTS), WM_TSRECORD, 0, 0);
  //  SendMessage(HWND_BROADCAST, WM_TSRECORD, 0, 0);
end;

procedure TForm1.bStopClick(Sender: TObject);
begin
  BroadcastSystemMessage(BSF_POSTMESSAGE, PDWORD(BSM_ALLCOMPONENTS), WM_TSSTOP, 0, 0);
end;

procedure TForm1.Hook;
begin
  OldProc := TMWndProc(Windows.GetWindowLong(Handle, GWL_WNDPROC));
  Windows.SetWindowLong(Handle, GWL_WNDPROC, longint(@MsgProc));
end;

procedure TForm1.Unhook;
begin
  if Assigned(OldProc) then
    Windows.SetWindowLong(Form1.Handle, GWL_WNDPROC, longint(OldProc));
  OldProc := nil;
end;

function MsgProc(Handle: HWnd; Msg: UInt; WParam: Windows.WParam;
  LParam: Windows.LParam): LResult; stdcall;
begin
  if Msg = WM_TSRECORD then
    Form1.Caption := 'Record'
  else if Msg = WM_TSSTOP then
    Form1.Caption := 'Stop'
  else
    Result := Windows.CallWindowProc(OldProc, Handle, Msg, WParam, LParam);
end;

procedure TForm1.Form1Create(Sender: TObject);
begin
  WM_TSRECORD := RegisterWindowMessage('TSRecord');
  WM_TSSTOP := RegisterWindowMessage('TSStop');
  Hook;
end;

procedure TForm1.Form1Destroy(Sender: TObject);
begin
  Unhook;
end;

end.

