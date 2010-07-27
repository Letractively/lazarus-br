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

unit LazAC;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, WavProc, LResources;

type TLACStatus=WStatus;

type
  { TLazAC }

  TLazAC = class(TComponent)
private
  WavPCM: TWavPCM;
public
  function Status: TLACStatus;
  procedure Play;
  function Play(sWaveFile:String):Boolean;
  procedure Pause;
  procedure Stop;
  function Close:Boolean;
  function OpenWavFile(sWavFile:String):Boolean;
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
end;

procedure Register;
implementation

procedure Register;
begin
  RegisterComponents('Additional', [TLazAC]);
end;

{ TLazAC }

function TLazAC.Status: TLACStatus;
begin
  if csDesigning in ComponentState then Exit;
  if (WavPCM <> nil) then
    Result:= WavPCM.Status
  else
    Result:=WStop;
end;

procedure TLazAC.Play;
begin
  if csDesigning in ComponentState then Exit;
  if (WavPCM <> nil) then
    WavPCM.Play;
end;

function TLazAC.Play(sWaveFile: String): Boolean;
begin
  if csDesigning in ComponentState then Exit;
  if (WavPCM <> nil) then
    Result:=WavPCM.Play(sWaveFile)
  else
    Result:=False;
end;

procedure TLazAC.Pause;
begin
  if csDesigning in ComponentState then Exit;
  if (WavPCM <> nil) then
    WavPCM.Pause;
end;

procedure TLazAC.Stop;
begin
  if csDesigning in ComponentState then Exit;
  if (WavPCM <> nil) then
    WavPCM.Stop;
end;

function TLazAC.Close: Boolean;
begin
  if csDesigning in ComponentState then Exit;
  if (WavPCM <> nil) then
    Result:=WavPCM.Close
  else
    Result:=False;
end;

function TLazAC.OpenWavFile(sWavFile: String): Boolean;
begin
  if csDesigning in ComponentState then Exit;
  if (WavPCM <> nil) then
    Result:=WavPCM.OpenWavFile(sWavFile)
  else
    Result:=False;
end;

constructor TLazAC.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if csDesigning in ComponentState then Exit;
  WavPCM:= TWavPCM.Create;
end;

destructor TLazAC.Destroy;
begin
  if not(csDesigning in ComponentState) then
    begin
      WavPCM.Free;
    end;
  inherited Destroy;
end;


initialization
{$I lazac.res}
end.

