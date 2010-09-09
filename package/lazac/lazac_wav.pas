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
unit LazAC_Wav;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, lazac_ao, WavTypes, ao;

type

{ TWavProc }

TWavProc = class(TAOProc)
private
  function OnReadHeader:Boolean;
  function OnSeekTime(const Time:Double):Boolean;
  procedure OnResetAudio;
  procedure OnGetBuffer(var Buffer: PChar; var Size: DWord);
  procedure OnGetTotalTime(var Time:Double);
  procedure OnGetTime(var Time:Double);
public
  constructor Create; override;
  destructor Destroy; override;
end;


implementation

{ TWavProc }

function TWavProc.OnReadHeader: Boolean;
var
  CabWavPCM:TCAB_WAVE_PCM;
begin
Result:= False;
{Evento de reconhecimento e leitura de FileStream}
  CabWavPCM:= Init_CAB_WAVE_PCM;
  //Se o arquivo for menor ou igual a 44bytes finaliza
  if (FileStream.Size <=44) then Exit;
  //--
  FileStream.Seek(0, soBeginning); //Vai para o início do arquivo
  FileStream.Read(CabWavPCM, 44);  //Faz leitura dos 44bytes(Cabeçalho WAVE(PCM))
  //--Ferifica se é um cabeçalho válido
  if (UpCase(CabWavPCM.FILE_FORMAT_CK_ID) <> 'RIFF') or
     (UpCase(CabWavPCM.FILE_FORMAT_WAVEID) <> 'WAVE') or
     (Trim(CabWavPCM.FORMAT_CHUNK_ckID) <> 'fmt') or
     (CabWavPCM.FORMAT_CHUNK_wFormatTag <> WAVE_FORMAT_PCM) or
     (CabWavPCM.DATA_CHUNK_cksize <=0) then Exit;

  //--------------------------------------------------------------
  //Define a forma que AO deve abrir o dispositivo de reprodução
  Sample_Format.bits:=CabWavPCM.FORMAT_CHUNK_BitsPerSample;
  Sample_Format.channels:=CabWavPCM.FORMAT_CHUNK_nChannels;
  Sample_Format.rate:=CabWavPCM.FORMAT_CHUNK_nSamplesPerSec;
  Sample_Format.byte_format:= AO_FMT_LITTLE;
  //--

  FileInfo.Clear;//Limpa os dados de FileInfo
  FileInfo.Add('file=' + FileStream.FileName); //Adiciona em FileInfo o nome do arquivo
  //--
Result:= True;
end;

function TWavProc.OnSeekTime(const Time: Double): Boolean;
var
  BytesSec:Integer;
  OffSet:Int64;
begin
Result:=False;
  {Posiciona em um tempo no arquivo}
  //Se OffSet ficar errado ou buffer Size estiver
  //"Errado" o som em Windows pode ficar defeituoso

  if (FStatus=wStop) then Exit;
  BytesSec:= (Sample_Format.bits div 8 * Sample_Format.channels * Sample_Format.rate);
  OffSet:= (BytesSec * Trunc(Time)) + 44;
  if (OffSet >= FileStream.Size) then Exit;
  //--

  FileStream.Seek(OffSet, soBeginning);

end;

procedure TWavProc.OnResetAudio;
begin
  //Posiciona no início dos dados PCM
  FileStream.Seek(44, soBeginning);
end;

procedure TWavProc.OnGetBuffer(var Buffer: PChar; var Size: DWord);
var
  BufferSize:Integer;
begin
  {1s de reprodução}
  BufferSize:=(Sample_Format.bits div 8 * Sample_Format.channels * Sample_Format.rate);
  {1/4 de reprodução}
  BufferSize:= BufferSize div 4; //Se isso ficar "errado" causará erro no OnSeekTime
  //--                           //É uma relação entre buffer corrente e o buffer após
                                 //OnSeekTime, percebido o erro em Windows
                                 //e BufferSize valendo 1/10 de Segundo
                                 //Melhorou apos alterar para 1/4
  Buffer:= AllocMem(BufferSize * SizeOf(Char));
  //--
  if (FileStream.Position = FileStream.Size) then Exit;
  Size:= FileStream.Read(Buffer^, BufferSize);
  //--
end;

procedure TWavProc.OnGetTotalTime(var Time: Double);
var
  BytesSec:Integer;
begin
  //Calcula e retorna o tempo total de duração de áudio
  BytesSec:= (Sample_Format.bits div 8 * Sample_Format.channels * Sample_Format.rate);
  Time:= FileStream.Size / Int64(BytesSec);
end;

procedure TWavProc.OnGetTime(var Time: Double);
var
  BytesSec:Integer;
begin
  //Retorna o tempo corrente
  BytesSec:= (Sample_Format.bits div 8 * Sample_Format.channels * Sample_Format.rate);
  Time:= FileStream.Position / Int64(BytesSec);
end;

constructor TWavProc.Create;
begin
  inherited Create;
  OnReadHeaderEvent:= @OnReadHeader;
  OnGetTotalTimeEvent:= @OnGetTotalTime;
  OnGetTimeEvent:= @OnGetTime;
  OnGetBufferEvent:= @OnGetBuffer;
  OnResetAudioEvent:= @OnResetAudio;
  OnSeekTimeEvent:= @OnSeekTime;
end;

destructor TWavProc.Destroy;
begin
  inherited Destroy;
end;

end.

