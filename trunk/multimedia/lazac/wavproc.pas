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

unit WavProc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ao, WavTypes{$IFDEF Windows}, dateutils{$ENDIF};

type EWavPCMError = class(Exception);
type WStatus=(wPlay, wStop, wPause);
//--

    { TWavThread }

    TWavThread = class(TThread)
    private
       FOwner: TObject;
    protected
      procedure Execute; override;
    public
      Constructor Create(CreateSuspended : boolean; TheOwner: TObject);
    end;

type

{ TWavPCM }

TWavPCM = class
  private
    FWavFileStream:TFileStream;
    FDevice: Pao_Device;
    FisPrepared: Boolean;
    FBufferSize:DWord;
    FStatus: WStatus;
    WavThread: TWavThread;
    procedure WavThreadFinalize(Sender: TObject);
  public
    property BufferSize: DWord read FBufferSize;
    property Device:Pao_Device read FDevice;
    property isPrepared: Boolean read FisPrepared;
    property Status: WStatus read FStatus;
    property WavFile:TFileStream read FWavFileStream;
    //--
    procedure Play;
    function Play(sWaveFile:String):Boolean;
    procedure Pause;
    procedure Stop;
    function Close:Boolean;
    //--
    function OpenWavFile(sWavFile:String):Boolean;
    constructor Create;
    destructor Destroy; override;
  end;


implementation

{ TWavPCM }

procedure TWavPCM.WavThreadFinalize(Sender: TObject);
begin
  if not(isPrepared) then
    begin
      if (FWavFileStream <> nil) then
        begin
          FWavFileStream.Free;
          FWavFileStream:=nil;
          ao_close(FDevice);
          ao_shutdown;
        end;
    end
  else if (FWavFileStream <> nil) then
      FWavFileStream.Seek(44, soBeginning);
  FStatus:=wStop;
end;

Procedure TWavPCM.Play;
begin
  if not(FisPrepared) or (FStatus=wPlay) then Exit;
  if (FStatus=wStop) then
    begin
      WavThread:= TWavThread.Create(True, Self);
      WavThread.OnTerminate:=@WavThreadFinalize;
      FStatus:=wPlay;
      WavThread.Resume;
    end;
FStatus:=wPlay;
end;

function TWavPCM.Play(sWaveFile: String): Boolean;
begin
Result:= False;
  if FisPrepared then Close;
  if not(OpenWavFile(sWaveFile)) then Exit;
  Play();
  if (Status <> wPlay) then Exit;
Result:=True;
end;

Procedure TWavPCM.Pause;
begin
  if (FStatus= wPlay) then
    FStatus:=wPause;
end;

Procedure TWavPCM.Stop;
begin
  if (FStatus = wStop) then Exit;
  WavThread.Terminate;
end;

function TWavPCM.Close: Boolean;
begin
Result:= False;
  if not(FisPrepared) then Exit;

  if (FStatus = WPlay) or (FStatus = WPause) then
    begin
      WavThread.Terminate;
    end
  else
    begin
      FWavFileStream.Free;
      FWavFileStream:=nil;
      ao_close(FDevice);
      ao_shutdown;
    end;
  FisPrepared:= False;
Result:= True;
end;

function TWavPCM.OpenWavFile(sWavFile: String): Boolean;
var
  FMTSample: ao_sample_format;
  CabWavPCM:TCAB_WAVE_PCM;
  DefaultDriver: longint;
begin
Result:=False;
{É preciso fechar o arquivo primeiro}
if (FisPrepared) then Exit;
//--
FisPrepared:=False;
//--
  //--
  FWavFileStream:=TFileStream.Create(sWavFile, fmOpenRead);
  //--
  if FWavFileStream.Size <= 44 then
    begin
      FWavFileStream.Free;
      FWavFileStream:=nil;
      Exit;
    end;
  //--
  FWavFileStream.Seek(0, soBeginning);
  FWavFileStream.Read(CabWavPCM, 44);
  //--
  if (UpCase(CabWavPCM.FILE_FORMAT_CK_ID) <> 'RIFF') or
     (UpCase(CabWavPCM.FILE_FORMAT_WAVEID) <> 'WAVE') or
     (Trim(CabWavPCM.FORMAT_CHUNK_ckID) <> 'fmt') or
     (CabWavPCM.FORMAT_CHUNK_wFormatTag <> WAVE_FORMAT_PCM) or
     (CabWavPCM.DATA_CHUNK_cksize <=0) then Exit;
  //--
  FMTSample.bits:=CabWavPCM.FORMAT_CHUNK_BitsPerSample;
  FMTSample.channels:=CabWavPCM.FORMAT_CHUNK_nChannels;
  FMTSample.rate:=CabWavPCM.FORMAT_CHUNK_nSamplesPerSec;
  FMTSample.byte_format:= AO_FMT_LITTLE;
  //--
  ao_initialize;
  //--
  DefaultDriver:= ao_default_driver_id();
  //--
  FDevice:= ao_open_live(DefaultDriver, @FMTSample, nil);
  //--
  if (FDevice=nil) then
     raise EWavPCMError.Create('No AO-device opened');
  {1s de reprodução}
  FBufferSize:=(FMTSample.bits div 8 * FMTSample.channels * FMTSample.rate);
  {1/4 de reprodução}
  FBufferSize:= FBufferSize div 4;

Result:=True;
FisPrepared:=True;
end;

constructor TWavPCM.Create;
begin
FWavFileStream:=nil;
FisPrepared:= False;
FStatus:= WStop;
WavThread:= nil;
end;

destructor TWavPCM.Destroy;
begin
  Close;
  inherited Destroy;
end;

{ TWavThread }

procedure TWavThread.Execute;
var
  BufferSize:DWord;
  Buffer:PChar;
  {$IFDEF Windows}
  ms:TDateTime;
  {$ENDIF}
begin
  if not(TWavPCM(FOwner).isPrepared) then
    Exit;
  //--
  BufferSize:= TWavPCM(FOwner).BufferSize;
  Buffer:= AllocMem(BufferSize * SizeOf(Char));
  //--
  While (TWavPCM(FOwner).WavFile.Position < TWavPCM(FOwner).WavFile.Size) and
         not(Terminated) and (TWavPCM(FOwner).Status <> wStop) do
    begin
      if (TWavPCM(FOwner).Status = wPlay) then
        begin
          {$IFDEF Windows}
            //--
            //Tentativa de eliminar um delay (Pause/Stop) no Windows
            //--
            ms:= Now + EncodeTime(0,0,0,250);
            while ms > now do ;
          {$ENDIF}
          //--
          TWavPCM(FOwner).WavFile.Read(Buffer^, BufferSize);
          ao_play(TWavPCM(FOwner).Device, Buffer, BufferSize);
        end;
     end;
    //--
    Freemem(Buffer);
    //--
end;

constructor TWavThread.Create(CreateSuspended: boolean; TheOwner: TObject);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
  FOwner:=TheOwner;
end;

end.

