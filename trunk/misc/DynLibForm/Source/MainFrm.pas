unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, LResources, Forms, StdCtrls, dynlibs;

type

  { TMainForm }

  TMainForm = class(TForm)
    ShowMyLibFormButton: TButton;
    procedure ShowMyLibFormButtonClick(Sender: TObject);
  end;

{$J+}
const
  CLibName: string = 'libmyform.' + SharedSuffix;
  CProcName: string = 'ShowMyLibForm';
{$J-}

var
  MainForm: TMainForm;

implementation

type
  TShowMyLibForm = procedure; cdecl;

function ShowMyLibForm: Boolean;
var
  S: string;
  VLibHandle: TLibHandle;
  VShowMyLibForm: TShowMyLibForm;
begin
  S := ExtractFilePath(ParamStr(0)) + CLibName;
  if FileExists(S) then
    VLibHandle := LoadLibrary(S)
  else
    VLibHandle := LoadLibrary(CLibName);
  if VLibHandle = NilHandle then
    raise Exception.Create('File "' + CLibName + '" not found.');
  try
    VShowMyLibForm := TShowMyLibForm(GetProcedureAddress(VLibHandle, CProcName));
    if Assigned(VShowMyLibForm) then
    begin
      Result := True;
      VShowMyLibForm;
    end
    else
    begin
      Result := False;
      raise Exception.Create('Process "' + CProcName + '" not exists in "' + CLibName + '".');
    end;
  finally
    if VLibHandle <> NilHandle then
      UnloadLibrary(VLibHandle);
  end;
end;

{ TMainForm }

procedure TMainForm.ShowMyLibFormButtonClick(Sender: TObject);
begin
  if not ShowMyLibForm then
    raise Exception.Create('Error in "libmyform.' + SharedSuffix + '".');
end;

initialization
  {$I MainFrm.lrs}

end.

