unit UPrincipal; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  dynlibs;

const
  CLibName: string = 'Lib.' + SharedSuffix;
  CCreateControl: string = 'CreateControl';
  CFreeControl: string = 'FreeControl';

type TCreateControl = procedure(Parent:TWinControl); cdecl;
type TFreeControl = procedure; cdecl;
type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    LibHandle: TLibHandle;
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 
  CreateControl: TCreateControl;
  FreeControl: TFreeControl;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  CreateControl(Form1);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  FreeControl;
  if LibHandle <> NilHandle then FreeLibrary(LibHandle);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  S: string;
begin
  S := ExtractFilePath(ParamStr(0)) + CLibName;

  if FileExists(S) then
    LibHandle := LoadLibrary(S)
  else
    LibHandle := LoadLibrary(CLibName);

  if LibHandle = NilHandle then
    raise Exception.Create('File "' + CLibName + '" not found.');

  CreateControl := TCreateControl(GetProcedureAddress(LibHandle, CCreateControl));

  if (CreateControl = nil) then
    begin
      FreeLibrary(LibHandle);
      raise Exception.Create('Shared procedure "' + CCreateControl + '" not found.');
    end;

    FreeControl := TFreeControl(GetProcedureAddress(LibHandle, CFreeControl));

  if (FreeControl = nil) then
    begin
      FreeLibrary(LibHandle);
      raise Exception.Create('Shared procedure "' + CFreeControl + '" not found.');
    end;

end;

end.

