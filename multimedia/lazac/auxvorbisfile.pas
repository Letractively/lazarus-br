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
unit AuxVorbisFile;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ctypes, Vorbislib, ogglib;

const
  SEEK_SET = 0;
  SEEK_CUR = 1;
  SEEK_END = 2;


function call_read_func(ptr: pointer; size, nmemb: csize_t; datasource: pointer): csize_t; cdecl;
function call_seek_func(datasource: pointer; offset: ogg_int64_t; whence: cint): cint; cdecl;
function call_close_func(datasource: pointer): cint; cdecl;
function call_tell_func(datasource: pointer): clong; cdecl;
var
  fov_callbacks: ov_callbacks;
implementation

function call_read_func(ptr: pointer; size, nmemb: csize_t; datasource: pointer
  ): csize_t; cdecl;
begin

  if (size = 0) or (nmemb = 0) then
  begin
    result := 0;
    exit;
  end;

  try
    result := Int64(TFileStream(datasource).Read(ptr^, size * nmemb)) div Int64(size);
  except
    result := 0;
  end;

end;

function call_seek_func(datasource: pointer; offset: ogg_int64_t; whence: cint
  ): cint; cdecl;
begin
  //--
  try
    case whence of
      SEEK_CUR: TFileStream(datasource).Seek(offset, soFromCurrent);
      SEEK_END: TFileStream(datasource).Seek(offset, soFromEnd);
      SEEK_SET: TFileStream(datasource).Seek(offset, soFromBeginning);
    end;
    result := 0;
  except
    result := -1;
  end;

end;

function call_close_func(datasource: pointer): cint; cdecl;
begin
  try
    //TFileStream(datasource).Free;
    result := 0;
  except
    result := -1;
  end;
end;

function call_tell_func(datasource: pointer): clong; cdecl;
begin
  result := -1;
  try
    result := TFileStream(datasource).Position;
  except
    Exit;
  end;
end;

initialization
  fov_callbacks.read := @call_read_func;
  fov_callbacks.seek := @call_seek_func;
  fov_callbacks.close:= @call_close_func;
  fov_callbacks.tell := @call_tell_func;

end.

