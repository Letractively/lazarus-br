unit UPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

{$ifdef Windows}
Type
  { TFormThread }
  TFormThread = class(TThread)
  private
  protected
    procedure Execute; override;
  public
    Procedure ExceptionEvent(Sender : TObject; E : Exception);
    Constructor Create(CreateSuspended : boolean);
  end;
{$endif}

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    ToggleBox1: TToggleBox;
    procedure Button1Click(Sender: TObject);
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
      Form1:= TForm1.Create(Application);
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

constructor TFormThread.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;
{$endif}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMessage('LCL em Biblioteca')
end;

end.

