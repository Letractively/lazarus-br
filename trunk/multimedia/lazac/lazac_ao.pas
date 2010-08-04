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
unit LazAC_AO;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ao;

type WStatus=(wPlay, wStop, wPause);
type EAOProcError = class(Exception);

type TReadHeaderEvent=function(): Boolean of object;
type TGetBufferEvent=procedure (var Buffer: PChar; var Size: DWord) of object;
type TGetTotalTimeEvent=procedure (var Time: Double) of object;
type TGetTimeEvent=procedure (var Time: Double) of object;
type TSeekTimeEvent=function (const Time: Double): Boolean of object;
type TResetAudioEvent=procedure of object;
type TOpenAOThreadEvent=function():Boolean of Object;

type


{ TPlayThread }

TPlayThread = class(TThread)
private
  FSize:Integer;
  FBuffer:PChar;
  FOwner: TObject;
  FOpenAOThreadEvent: TOpenAOThreadEvent;
  procedure GetBuffer;
  procedure OpenAO;
protected
  procedure Execute; override;
public
  property OpenAOThreadEvent: TOpenAOThreadEvent read FOpenAOThreadEvent write FOpenAOThreadEvent;
  constructor Create(CreateSuspended : boolean; TheOwner: TObject);
end;


{ TAOProc }

TAOProc = class
private
  FGetBufferEvent: TGetBufferEvent;
  FGetTotalTimeEvent: TGetTotalTimeEvent;
  FGetTimeEvent: TGetTimeEvent;
  FReadHeaderEvent: TReadHeaderEvent;
  FResetAudioEvent: TResetAudioEvent;
  FSeekTimeEvent: TSeekTimeEvent;
  procedure PlayThreadFinalize(Sender: TObject);
  function OpenAOThread: Boolean;
protected
  PlayThread: TPlayThread;
  FileStream: TFileStream;
  isPrepared: Boolean;
  FStatus: WStatus;
  DefaultDriver: longint;
  FileName:String;
  FileInfo:TStringList;
public
  Sample_Format: ao_sample_format;
  Device: Pao_Device;
  //--
  property OnGetBufferEvent: TGetBufferEvent read FGetBufferEvent write FGetBufferEvent;
  property OnGetTotalTimeEvent: TGetTotalTimeEvent read FGetTotalTimeEvent write FGetTotalTimeEvent;
  property OnGetTimeEvent: TGetTimeEvent read FGetTimeEvent write FGetTimeEvent;
  property OnReadHeaderEvent: TReadHeaderEvent read FReadHeaderEvent write FReadHeaderEvent;
  property OnResetAudioEvent: TResetAudioEvent read FResetAudioEvent write FResetAudioEvent;
  property OnSeekTimeEvent: TSeekTimeEvent read FSeekTimeEvent write FSeekTimeEvent;
  property Status:WStatus read FStatus;
  property Comments: TStringList read FileInfo;
  //--
  procedure Play;
  procedure Pause;
  procedure Stop;
  function Close:Boolean;
  procedure GetBuffer(var Buffer: PChar; var Size: Integer);
  procedure GetTotalTime(var Time: Double);
  procedure GetTime(var Time: Double);
  function SeekTime(const Time: Double): Boolean;
  function OpenFile(sFile:String):Boolean;
  constructor Create; virtual;
  destructor Destroy; override;
end;

var
  I:Integer=0;
implementation

{ TAOProc }

procedure TAOProc.PlayThreadFinalize(Sender: TObject);
begin
  if not(isPrepared) then
    begin
      if (FileStream <> nil) then
        begin
          FileStream.Free;
          FileStream:=nil;
          ao_close(Device);
          ao_shutdown;
        end;
    end
  else
    begin
      if (FileStream <> nil) and Assigned(FResetAudioEvent) then
        FResetAudioEvent();
      FStatus:=wStop;
      ao_close(Device);
      ao_shutdown;
    end;
end;

function TAOProc.OpenAOThread: Boolean;
begin
  Result:=False;

  ao_initialize;
  DefaultDriver:= ao_default_driver_id();
  if (DefaultDriver < 0) then
    raise EAOProcError.Create('No default driver was returned by AO.');

  Device:= ao_open_live(DefaultDriver, @Sample_Format, nil);
  if (Device = nil)then
    raise EAOProcError.Create('No device was returned by AO.');
  //--
 Result:=True;
end;

procedure TAOProc.Play;
begin
  if not(isPrepared) or (FStatus=wPlay) then Exit;
  //-----
  if (FStatus=wStop) then
    begin
      PlayThread:= TPlayThread.Create(True, Self);
      {$IFDEF WINDOWS}
      PlayThread.Priority:=tpHigher;
      {$ENDIF}
      PlayThread.OnTerminate:=@PlayThreadFinalize;
      PlayThread.OpenAOThreadEvent:=@OpenAOThread;
      FStatus:=wPlay;
      PlayThread.Resume;
    end;
FStatus:=wPlay;
end;

procedure TAOProc.Pause;
begin
  if (FStatus= wPlay) then
  FStatus:=wPause;
end;

procedure TAOProc.Stop;
begin
  if (FStatus = wStop) then Exit;
  PlayThread.Terminate;
end;

function TAOProc.Close: Boolean;
begin
Result:= False;
  if not(isPrepared) then Exit;
  if (FStatus<>wStop) then
    begin
      isPrepared:=False;
      PlayThread.Terminate;
    end
  else if (FileStream <> nil) then
    begin
      FileStream.Free;
      FileStream:=nil;
    end;
Result:= True;
end;

procedure TAOProc.GetBuffer(var Buffer: PChar; var Size: Integer);
begin
  if Assigned(FGetBufferEvent) then FGetBufferEvent(Buffer, Size);
end;

procedure TAOProc.GetTotalTime(var Time: Double);
begin
  Time:= 0;
  if Assigned(FGetTotalTimeEvent) then FGetTotalTimeEvent(Time);
end;

procedure TAOProc.GetTime(var Time: Double);
begin
  Time:= 0;
  if Assigned(FGetTimeEvent) then FGetTimeEvent(Time);
end;

function TAOProc.SeekTime(const Time: Double): Boolean;
begin
  Result:=False;
  if Assigned(FSeekTimeEvent) then Result:= FSeekTimeEvent(Time);
end;

function TAOProc.OpenFile(sFile: String): Boolean;
begin
Result:=False;
  if isPrepared then Exit;

  FStatus:=wStop;
  if not(FileExists(sFile)) then Exit;
  if (FileStream <> nil) then FileStream.Free;
  FileStream:=TFileStream.Create(SFile ,fmOpenRead);
  //--
  if Assigned(FReadHeaderEvent) then
    begin
      if not(FReadHeaderEvent()) then
        begin
          FileStream.Free;
          FileStream:= nil;
          Exit;
        end;
    end
  else
     begin
       FileStream.Free;
       FileStream:= nil;
       Exit;
     end;
//--------
  FileName:= sFile;
  isPrepared:= True;
Result:= True;
end;

constructor TAOProc.Create;
begin
  InitHandleAO;
  Device:=nil;
  PlayThread:= nil;
  FStatus:= wStop;
  isPrepared:= False;
  FileInfo:=TStringList.Create;
end;

destructor TAOProc.Destroy;
begin
  if (FStatus<>wStop) then
    begin
      PlayThread.OnTerminate:=nil;
      PlayThread.Terminate;
      Sleep(300);
      ao_close(Device);
      ao_shutdown;
    end;
      //--
  if (FileStream <> nil) then
    begin
      FileStream.Free;
      FileStream:=nil;
    end;
  //--
  FileInfo.Free;
  inherited Destroy;
end;


{ TWavThread }

procedure TPlayThread.Execute;
procedure FreeBuffer;
begin
    if (FBuffer <> nil) then
    begin
      FreeMem(FBuffer);
      FBuffer:=nil;
    end;
end;

var
  Owner:TAOProc;
{$IFDEF WINDOWS}
  Sec:Integer;
  CalcSleep:Integer=0;
  BufferRead:Int64=0;
{$ENDIF}
begin
  Owner:=TAOProc(FOwner);
  if not(Owner.isPrepared) then Exit;
  Synchronize(@OpenAO);

  While (Owner.isPrepared) and (Owner.Status<>wStop) and not(Terminated) and
        (Owner.FileStream <> nil) do
    begin
      FSize:=0;
      if (Owner.Status=wPlay) then
        begin
            Synchronize(@GetBuffer);
            if (FSize > 0) then
              begin
                if Terminated or (Owner.Status = wStop) then
                  begin
                    FreeBuffer;
                    Exit;
                  end;
{$IFDEF WINDOWS}
                    Inc(BufferRead, FSize);
                    Sec:=(Owner.Sample_Format.bits div 8 * Owner.Sample_Format.channels * Owner.Sample_Format.rate);

                    if ((BufferRead) > (Int64(Sec) div 2)) then
                      begin
                        Inc(CalcSleep, ((FSize * 1000) div Sec) div Owner.Sample_Format.channels);
                        if (CalcSleep > 100) then
                          begin
                            Sleep(CalcSleep);
                            CalcSleep:=0;
                          end;
                      end;
{$ENDIF}
                ao_play(Owner.Device, FBuffer, FSize);
                FreeBuffer;
              end
            else
              Break;
        end;
    if (Owner.Status=wPause) then Sleep(500);
    end;
    FreeBuffer;
end;

procedure TPlayThread.GetBuffer;
begin
  TAOProc(FOwner).GetBuffer(FBuffer, FSize);
end;

procedure TPlayThread.OpenAO;
var
  Ret:Boolean;
begin
  if Assigned(FOpenAOThreadEvent) then Ret:= FOpenAOThreadEvent();
  if not(Ret) then Terminate;
end;

constructor TPlayThread.Create(CreateSuspended: boolean; TheOwner: TObject);
begin
  FreeOnTerminate:= True;
  inherited Create(CreateSuspended);
  FOwner:=TheOwner;
  FSize:=0;
end;

end.

