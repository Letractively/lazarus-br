unit UPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  dynlibs;

const
  CLibName: string = 'FormDLL.' + SharedSuffix;
  CShowForm: string = 'ShowForm';
  CFreeForm: String = 'FreeForm';

type TShowForm = procedure ;cdecl;
type TFreeForm = procedure ;cdecl;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    LibHandle: TLibHandle;
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 
  ShowForm: TShowForm;
  FreeForm: TFreeForm;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowForm;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  FreeForm;
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

  ShowForm := TShowForm(GetProcedureAddress(LibHandle, CShowForm));
  if (ShowForm = nil) then
    begin
      FreeLibrary(LibHandle);
      raise Exception.Create('Shared procedure "' + CShowForm + '" not found.');
    end;

  FreeForm := TFreeForm(GetProcedureAddress(LibHandle, CFreeForm));
  if (FreeForm = nil) then
    begin
      FreeLibrary(LibHandle);
      raise Exception.Create('Shared procedure "' + CFreeForm + '" not found.');
    end;

end;

end.

