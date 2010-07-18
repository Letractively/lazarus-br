program kamouflage;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, unEngine, SysUtils, unglobal;

var
  ParamsNo               : integer;

procedure ShowHelp;
begin
  WriteLn('');
  WriteLn('USAGE: kamouflage [command] [parameter 1] <[parameter 2]> <[parameter 3]>  <switch>');
  writeln('COMMANDS ');
  writeln('         -c   Camouflages a desired file inside JPG or other image file');
  writeln('             Param 1: Source Image File');
  writeln('             Param 2: Source file to camouflage');
  writeln('             Param 3: Destination imag file that will contain camouflage image and a file that it protects');
  WriteLn('');
  writeln('         -d   Decamouflages a desired file that is inside image file');
  writeln('             Param 1: Source Camouflaged image file');
  writeln('             Param 2: [optional] destination file path where to decamouflage');
  writeln('             Param 3: [optional] SWITCH');
  WriteLn('');
  writeln('         -v  Show version number');
  WriteLn('');
  writeln('SWITCHES ');
  writeln('         -o   Allows owerwrite of destination decamouflaged (extracted file), if it exists');
  WriteLn('');
  WriteLn('COMMAND ALIASES');
  WriteLn('             Commands are not case-sensitive. You may or may not use "-" ');
  writeLn('             in front ( -c = c = --c), but you cannot');
  WriteLn('             use spaces between dash and letter. Following commands are the same');
  WriteLn('             C, c, -c, --c, -camouflage, camouflage');
  WriteLn('             D, d, -d, --d, -decamouflage, decamouflage');
  WriteLn('             O, o, -o, --o, -overwrite, overwrite');
  WriteLn('             V, v, -v, --v, -version, version');
  WriteLn('');
  halt;
end;

procedure ShowError(AErrorCode: byte);
begin
  WriteLn('');
  case AErrorCode of
    1: WriteLn('Error: wrong number of parameters');
    2: WriteLn('Error: Command "C" (camouflage), must be followed by 3 parameters');
    3: WriteLn('Error: Command "C" (camouflage), must be followed by 1, 2 or 3 parameters');
    ERR_IMG_NOT_EXISTS: WriteLn('Error: Source image does not exists');
    ERR_SRC_FILE_NOT_EXISTS: WriteLn('Error: Source file does not exists');
    ERR_DEST_FILE_EXISTS: WriteLn('Error: Destination file exists and Kamouflage was ran without overwrite switch');
    ERR_FILE_CORRUPTED: WriteLn('Error: Camouflaged file is corrupted');
  end;
  WriteLn('To invoke help, type "kamouflage" or "kamouflage --help" (without quotes)');
  halt;
end;

function CleanParam(AParam: string): string;
var
  where                  : integer;
begin
  while pos('-', AParam) > 0 do
  begin
    where := pos('-', AParam);
    Delete(AParam, where, 1);
  end;
  result := AParam;
end;

procedure ParseParams;
var
  command                : string;
  res                    : byte;
  ShowOpCompleted        : boolean;
begin
  ShowOpCompleted := true;
  if ParamsNo = 0 then ShowHelp
  else if not (ParamsNo in [1, 2, 3, 4, 5]) then ShowError(1);
  command := UpperCase(CleanParam(ParamStr(1)));
  if (command = 'V') or (command = 'VERSION') then
  begin
    WriteLn('');
    WriteLn('Kamouflage - Program that camouflage files inside other files or images');
    WriteLn('Coded by Emil Beli, published by Varnus Technologies under GNU/GPL license');
    WriteLn('http://www.varnus.com');
    WriteLn('Version ' + PROGRAM_VERSION_STR);
    ShowOpCompleted := false;
  end
  else if (command = 'C') or (command = 'CAMOUFLAGE') then
  begin
    if ParamsNo <> 4 then ShowError(2);
    res := DoKamuflage(ParamStr(2), ParamStr(3), ParamStr(4));
  end
  else if (command = 'D') or (command = 'DECAMOUFLAGE') then
  begin
    if not (ParamsNo in [2, 3, 4]) then ShowError(3);
    case ParamsNo of
      2: res := DoDeKamuflage(ParamStr(2));
      3:
        begin
          if SameText(CleanParam(ParamStr(3)), 'o') or SameText(CleanParam(ParamStr(3)), 'overwrite') then
          begin
            GLOBAL_OverWrite := true;
            res := DoDeKamuflage(ParamStr(2));
          end else
            res := DoDeKamuflage(ParamStr(2), ParamStr(3));
        end;
      4:
        begin
          GLOBAL_OverWrite := true;
          res := DoDeKamuflage(ParamStr(2), ParamStr(3));
        end;
    end;
  end;
  if ShowOpCompleted then
    if res > 0 then ShowError(res) else WriteLn('Operation completed');
end;

begin
  GLOBAL_OverWrite := false; ParamsNo := Paramcount; ParseParams;
end.


