unit UPrincipal;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF Windows}
  Windows,
  InterfaceBase,
  win32int,
  {$ENDIF Windows}
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

{$ifdef Windows}
Type
  { TFormThread }
  TFormThread = class(TThread)
  private
    FParent:TWinControl;
  protected
    procedure Execute; override;
  public
    Procedure ExceptionEvent(Sender : TObject; E : Exception);
    Constructor Create(CreateSuspended : boolean; Parent:TWinControl);
  end;
{$endif}

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    ToggleBox1: TToggleBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

{$R *.lfm}

{$ifdef Windows}
{ TFormThread }
procedure TFormThread.Execute;
begin
  try
    Application.CaptureExceptions:=True;
    Application.OnException:= @Self.ExceptionEvent;
    IsMultiThread:=false;
    if not(Assigned(Form1)) then
      begin
        Form1:= TForm1.Create(FParent);
        Form1.Top:=0;
        Form1.Left:=0;
        Form1.Align:=alClient;
        Form1.ParentWindow:= FParent.Handle;
        Form1.BorderStyle:=bsNone;
      end;
    Form1.ShowModal;
  Except
  on E: Exception do
    ShowMessage(ClassName + ' Execute ' + E.Message);
  end;
end;

procedure TFormThread.ExceptionEvent(Sender: TObject; E: Exception);
begin
  ShowMessage(ClassName + ' Execute' + E.Message);
  Form1.Free;
end;

constructor TFormThread.Create(CreateSuspended: boolean; Parent: TWinControl);
begin
  FParent:= Parent;
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;
{$endif}

{ TForm1 }

procedure TForm1.FormPaint(Sender: TObject);
begin
 {$IFDEF Windows}
 ShowWindow(TWin32WidgetSet(WidgetSet).AppHandle,SW_HIDE);
 {$ENDIF Windows}
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMessage('LCL em Biblioteca');
end;

end.
