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

