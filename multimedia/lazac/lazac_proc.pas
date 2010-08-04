{LazAC

Copyright (C) 2010 Elson Junio elsonjunio@yahoo.com.br

This library is free software; you can redistribute it and/or modify it
under the terms of the GNU Library General Public License as published by
the Free Software Foundation; either version 2 of the License, or (at your
option) any later version with the following modification:

As a special exception, the copyright holders of this library give you
permission to link this library with independent modules to produce an
executable, regardless of the license terms of these independent modules,and
to copy and distribute the resulting executable under terms of your choice,
provided that you also meet, for each linked independent module, the terms
and conditions of the license of that module. An independent module is a
module which is not derived from or based on this library. If you modify
this library, you may extend this exception to your version of the library,
but you are not obligated to do so. If you do not wish to do so, delete this
exception statement from your version.

This library is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
for more details.

You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
}
unit LazAC_Proc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazAC_AO, LazAC_Wav, LazAC_Ogg, LCLProc, LazAC_type;

type

{ TLazACCustom }

TLazACCustom = class(TComponent)
private
  FInfos:TStringList;
  AOProc: TAOProc;
  procedure DestroyAOProc;
  function GetStatus:acStatus;
public
  property Status:acStatus read GetStatus;
  property Comments: TStringList read FInfos;
  //--
  procedure Play;
  function Play(sFile: String): Boolean;
  procedure Pause;
  procedure Stop;
  function GetTotalTime:Double;
  function GetTime:Double;
  function OpenFile(sFile:String):Boolean;
  function Close:Boolean;
  function SeekTime(const Time: Double):Boolean;
  constructor Create(AOwner: TComponent);override;
  destructor Destroy; override;
end;


implementation

{ TLazACCustom }

procedure TLazACCustom.DestroyAOProc;
begin
  if (AOProc = nil) then Exit;
  AOProc.Free;
  AOProc:= nil;
end;

function TLazACCustom.GetStatus: acStatus;
begin
  Result:=acStatus(wStop);
  if (AOProc= nil) then Exit;
  Result:= acStatus(AOProc.Status);
end;

procedure TLazACCustom.Play;
begin
  if (AOProc= nil) then Exit;
  AOProc.Play;
end;

function TLazACCustom.Play(sFile: String): Boolean;
begin
Result:= False;
  if OpenFile(sFile) then
    begin
      Self.Play;
      Result:= True;
    end;
end;

procedure TLazACCustom.Pause;
begin
  if (AOProc= nil) then Exit;
  AOProc.Pause;
end;

procedure TLazACCustom.Stop;
begin
  if (AOProc= nil) then Exit;
  AOProc.Stop;
end;

function TLazACCustom.GetTotalTime: Double;
begin
  Result:= 0;
  if (AOProc= nil) then Exit;
  AOProc.GetTotalTime(Result);
end;

function TLazACCustom.GetTime: Double;
begin
  Result:= 0;
  if (AOProc= nil) then Exit;
  AOProc.GetTime(Result);
end;

function TLazACCustom.OpenFile(sFile: String): Boolean;
var
  Ext:String;
begin
Result:= False;
  if not(FileExists(sFile)) then Exit;
  Ext:= UTF8UpperCase(UTF8Copy(sFile, UTF8Length(sFile) - 3, 4));
  if (AOProc<>nil) then DestroyAOProc;
  //--
  if (Ext='.OGG') then AOProc:= TOggProc.Create;
  if (Ext='.WAV') then AOProc:= TWavProc.Create;
  //--
  if (AOProc= nil) then Exit;
  //--
  if not(AOProc.OpenFile(sFile)) then
    begin
      DestroyAOProc;
      Exit;
    end;
  //--
  FInfos.Text := AOProc.Comments.Text;
Result:=True;
end;

function TLazACCustom.Close: Boolean;
begin
Result:=False;
  if (AOProc= nil) then Exit;
  Result:= AOProc.Close;
  DestroyAOProc;
end;

function TLazACCustom.SeekTime(const Time: Double): Boolean;
begin
  Result:=False;
    if (AOProc= nil) then Exit;
    Result:= AOProc.SeekTime(Time);
end;

constructor TLazACCustom.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if csDesigning in ComponentState then Exit;
  AOProc:= nil;
  FInfos:= TStringList.Create;
end;

destructor TLazACCustom.Destroy;
begin
  if not(csDesigning in ComponentState) then
    begin
      DestroyAOProc;
      FInfos.Destroy;
    end;
  inherited Destroy;
end;

end.

