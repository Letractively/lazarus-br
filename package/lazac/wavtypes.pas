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

unit WAVTypes;

{$mode objfpc}{$H+}

interface

//Formatos de Wave
const
  WAVE_FORMAT_PCM=              $0001;//Este é o formato que trabalhamos
  WAVE_FORMAT_IEEE_FLOAT=       $0003;
  WAVE_FORMAT_ALAW=             $0006;
  WAVE_FORMAT_MULAW=            $0007;
  WAVE_FORMAT_EXTENSIBLE=       $FFFE;

//Formato do cabeçalho Wave codificado em PCM
Type
  TCabWavePCM=Record
    FILE_FORMAT_CK_ID:                  array [0..3] of Char;//'R','I','F','F'
    FILE_FORMAT_cksize:                 DWORD;
    FILE_FORMAT_WAVEID:                 array [0..3] of CHAR;// 'W','A','V','E'
    FORMAT_CHUNK_ckID:			array [0..3] of CHAR;// 'f','m','t',' '
    FORMAT_CHUNK_cksize:                DWORD;
    FORMAT_CHUNK_wFormatTag:		WORD;
    FORMAT_CHUNK_nChannels:		WORD;
    FORMAT_CHUNK_nSamplesPerSec:	DWORD;
    FORMAT_CHUNK_nAvgBytesPerSec:	DWORD;
    FORMAT_CHUNK_nBlockAlign:		WORD;
    FORMAT_CHUNK_BitsPerSample:		WORD;
    DATA_CHUNK_ckID:                    array [0..3] of CHAR;//'d','a','t','a'
    DATA_CHUNK_cksize:                  DWORD;
  end;
type
  TCAB_WAVE_PCM=  TCabWavePCM;

function Init_CAB_WAVE_PCM:TCAB_WAVE_PCM;


implementation

function Init_CAB_WAVE_PCM: TCAB_WAVE_PCM;
begin
  with Result do
    begin
      FILE_FORMAT_CK_ID:= PChar('');
      FILE_FORMAT_cksize:= 0;
      FILE_FORMAT_WAVEID:= PChar('');
      FORMAT_CHUNK_ckID:= PChar('');
      FORMAT_CHUNK_cksize:= 0;
      FORMAT_CHUNK_wFormatTag:= 0;
      FORMAT_CHUNK_nChannels:= 0;
      FORMAT_CHUNK_nSamplesPerSec:= 0;
      FORMAT_CHUNK_nAvgBytesPerSec:= 0;
      FORMAT_CHUNK_nBlockAlign:= 0;
      FORMAT_CHUNK_BitsPerSample:= 0;
      DATA_CHUNK_ckID:= PChar('');
      DATA_CHUNK_cksize:= 0;
    end;
end;

end.

