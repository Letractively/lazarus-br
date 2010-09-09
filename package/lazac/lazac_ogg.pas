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
unit LazAC_Ogg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Lazac_ao, Vorbislib, AuxVorbisFile, ctypes, ao;

type

{ TOggProc }

TOggProc = class(TAOProc)
private
  function OnReadHeader:Boolean;
  function OnSeekTime(const Time:Double):Boolean;
  procedure OnResetAudio;
  procedure OnGetBuffer(var Buffer: PChar; var Size: DWord);
  procedure OnGetTotalTime(var Time:Double);
  procedure OnGetTime(var Time:Double);
protected
  Section:Integer;
public
  OggFile: OggVorbis_File;
  VorbisInfo: Vorbis_Info;
  VorbisComment: Vorbis_Comment;
  constructor Create; override;
  destructor Destroy; override;
end;

implementation

{ TOggProc }

function TOggProc.OnReadHeader: Boolean;
var
  Ret:cInt;
  I:Integer;
  comment: PChar;
begin
{Evento de reconhecimento e leitura de FileStream}

Result:= False;
  // ov_open_callbacks da VorbisFile, isso vincula as funções de callback
  //que dará condições da biblioteca trabalhar com o filestream
  Ret:= ov_open_callbacks(FileStream, OggFile, nil, 0, Fov_callbacks);
  if (Ret < 0) then Exit; //Se tiver erro sai
  //--
  //Recebe informações do arquivo OGG
  VorbisInfo:= ov_info(OggFile, -1)^;
  VorbisComment:=ov_comment(OggFile, -1)^;

  //--------------------------------------------------------------
  //Define a forma que AO deve abrir o dispositivo de reprodução
  Sample_Format.bits:=16;
  Sample_Format.channels:=VorbisInfo.channels;
  Sample_Format.rate:=VorbisInfo.rate;
  Sample_Format.byte_format:= AO_FMT_LITTLE;
  //--
  FileInfo.Clear; //Limpa os dados de FileInfo
  FileInfo.Add('file=' + FileStream.FileName);//Adiciona em FileInfo o nome do arquivo
  for I:= 0 to VorbisComment.comments do
    begin
    //Adciona em FileInfo os comentário do arquivo
    comment:= PChar(VorbisComment.user_comments[I]);
    FileInfo.Add(comment);
    end;
  //--
Result:= True;
end;

function TOggProc.OnSeekTime(const Time: Double): Boolean;
begin
Result:=True;
  {Posiciona em um tempo no arquivo}

  if (FStatus=wStop) then Exit;
  //--
  if (Time < 1) then
    ov_pcm_seek(OggFile, 1)
  else
    ov_time_seek(OggFile, Time);
  //--
end;

procedure TOggProc.OnResetAudio;
begin
  Section:=0;
  {posiciona o início dos dados PCM}
  ov_pcm_seek(OggFile, 1);
end;

procedure TOggProc.OnGetBuffer(var Buffer: PChar; var Size: DWord);
var
  BufferSize:Integer;
begin
  {Faz a leitura do Buffer
  o tamanho 4096 é muito usada
  mas a biblioteca pode retonar o buffer em tamanho
  diferente do informado}
  BufferSize:= 4096;
  //Aloca o buffer no tamanho 4096
  Buffer:= AllocMem(BufferSize);
  //Recebe os dados de OggFile em Buffer no tamanho de BufferSize,
  //0 para little endian, 2 para receber 16-bit/samples, 1 para Signed data
  //ao pé da letra Dados Assinados, ponteiro para bitstream

  Size:= ov_read(OggFile, Buffer, BufferSize, cbool(0), 2, cbool(1), @Section);
end;

procedure TOggProc.OnGetTotalTime(var Time: Double);
begin
  {retorna o tempo total}
  Time:=0;
  Time:= ov_time_total(OggFile, -1);
end;

procedure TOggProc.OnGetTime(var Time: Double);
begin
  {retorna o tempo corrente}
  Time:=0;
  Time:= ov_time_tell(OggFile);
end;

constructor TOggProc.Create;
begin
  InitHandleVorbisFile;//inicialisa a biblioteca VorbisFile
  inherited Create;
  Section:=0;
  //Vincula eventos à procedimentos
  OnReadHeaderEvent:= @OnReadHeader;
  OnGetTotalTimeEvent:= @OnGetTotalTime;
  OnGetTimeEvent:= @OnGetTime;
  OnGetBufferEvent:= @OnGetBuffer;
  OnResetAudioEvent:= @OnResetAudio;
  OnSeekTimeEvent:= @OnSeekTime;
end;

destructor TOggProc.Destroy;
begin
  ov_clear(OggFile);
  inherited Destroy;
end;

end.

