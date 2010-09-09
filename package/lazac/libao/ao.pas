{
/*
 *
 *  ao.h
 *
 *	Original Copyright (C) Aaron Holtzman - May 1999
 *      Modifications Copyright (C) Stan Seibert - July 2000, July 2001
 *      More Modifications Copyright (C) Jack Moffitt - October 2000
 *
 *  This file is part of libao, a cross-platform audio outputlibrary.  See
 *  README for a history of this source code.
 *
 *  libao is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2, or (at your option)
 *  any later version.
 *
 *  libao is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with GNU Make; see the file COPYING.  If not, write to
 *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */
}
{Traduzido por Elson Junio(elsonjunio@yahoo.com.br) de ao.h}


unit ao;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils,{$IFDEF LINUX}Libc,{$ENDIF} dynlibs, ctypes, os_types;

const
  {$IFDEF Linux}
  libao='libao.so';
  {$ENDIF}
  {$IFDEF WINDOWS}
  libao='libao.dll';
  {$ENDIF}
  { Constants }
  AO_TYPE_LIVE   = 1;
  AO_TYPE_FILE   = 2;

  AO_ENODRIVER   = 1;
  AO_ENOTFILE    = 2;
  AO_ENOTLIVE    = 3;
  AO_EBADOPTION  = 4;
  AO_EOPENDEVICE = 5;
  AO_EOPENFILE   = 6;
  AO_EFILEEXISTS = 7;

  AO_EFAIL       = 100;

  AO_FMT_LITTLE  = 1;
  AO_FMT_BIG     = 2;
  AO_FMT_NATIVE  = 4;

  { Structures }
{$IFDEF Windows}
type
    PIOFile=^_IO_File;
    _IO_File=Pointer;
{$ENDIF}
type
  Pao_functions = ^ao_functions;
  Pao_sample_format = ^ao_sample_format;
  PPao_info= ^Pao_info;
  Pao_info= ^ao_info;
  Pao_device = ^ao_device;
  PPao_option= ^Pao_option;
  Pao_option= ^ao_option;

    ao_info = packed record
        _type : longint;
        name : PChar;
        short_name : PChar;
        author : PChar;
        comment : PChar;
        preferred_byte_format : longint;
        priority : longint;
        options : PPChar;
        option_count : longint;
      end;

    ao_device = packed record
        _type : longint;
        driver_id : longint;
        funcs : Pao_functions;
        _file : PIOFile;
        client_byte_format : longint;
        machine_byte_format : longint;
        driver_byte_format : longint;
        swap_buffer : PChar;
        swap_buffer_size : longint;
        internal : pointer;
      end;

    ao_sample_format = packed record
        bits : longint;
        rate : longint;
        channels : longint;
        byte_format : longint;
      end;

    ao_functions = packed record
        test : function :longint;cdecl;
        driver_info : function :Pao_info;
        device_init : function (device:Pao_device):longint;
        set_option : function (device:Pao_device; key:pchar; value:pchar):longint;
        open : function (device:Pao_device; format:pao_sample_format):longint;
        play : function (device:Pao_device; output_samples:pchar; num_bytes:cuint32):longint;
        close : function (device:Pao_device):longint;
        device_clear : procedure (device:Pao_device);
        file_extension : function :PChar;
      end;

    ao_option = packed record
        key : PChar;
        value : PChar;
        next : Pao_option;
      end;


{ Functions }

{ library setup/teardown  }
Tao_initialize = procedure;cdecl;
Tao_shutdown = procedure;cdecl;

{ device setup/playback/teardown  }
Tao_append_option = function (options:PPao_option; key:PChar; value:PChar):longint;cdecl;
Tao_free_options = procedure (options:Pao_option);cdecl;
Tao_open_live = function (driver_id:longint; format:Pao_sample_format; option:Pao_option):Pao_device;cdecl;
Tao_open_file = function (driver_id:longint; filename:PChar; overwrite:longint; format:pao_sample_format; option:Pao_option):Pao_device;cdecl;
Tao_play = function (device:Pao_device; output_samples:Pchar; num_bytes:uint_32):longint;cdecl;
Tao_close = function (device:Pao_device):longint;cdecl;

{ driver information  }
Tao_driver_id = function (short_name:PChar):longint;cdecl;
Tao_default_driver_id = function:longint;cdecl;
Tao_driver_info = function (driver_id:longint):Pao_info;cdecl;
Tao_driver_info_list = function (driver_count:Plongint):PPao_info;cdecl;
Tao_file_extension = function (driver_id:longint):PChar;cdecl;
{ miscellaneous  }
Tao_is_big_endian = function :longint;cdecl;


var

  ao_initialize : Tao_initialize;
  ao_shutdown : Tao_shutdown;
  ao_append_option : Tao_append_option;
  ao_free_options : Tao_free_options;
  ao_open_live : Tao_open_live;
  ao_open_file : Tao_open_file;
  ao_play : Tao_play;
  ao_close : Tao_close;
  ao_driver_id : Tao_driver_id;
  ao_default_driver_id : Tao_default_driver_id;
  ao_driver_info : Tao_driver_info;
  ao_driver_info_list : Tao_driver_info_list;
  ao_file_extension : Tao_file_extension;
  ao_is_big_endian : Tao_is_big_endian;

type EAOError = class(Exception);
procedure InitHandleAO;
var
  aoinitalized:boolean=False;
  handlelibao:THandle;

implementation

procedure InitHandleAO;
begin
    if aoinitalized then Exit;

    handlelibao := LoadLibrary(libao);
    if (handlelibao = 0) then
      raise EAOError.Create(libao + ' not found.');

      ao_initialize :=Tao_initialize(GetProcAddress(handlelibao,'ao_initialize'));
      ao_shutdown := Tao_shutdown(GetProcAddress(handlelibao,'ao_shutdown'));
      ao_append_option := Tao_append_option(GetProcAddress(handlelibao,'ao_append_option'));
      ao_free_options := Tao_free_options(GetProcAddress(handlelibao,'ao_free_options'));
      ao_open_live := Tao_open_live(GetProcAddress(handlelibao,'ao_open_live'));
      ao_open_file := Tao_open_file(GetProcAddress(handlelibao,'ao_open_file'));
      ao_play := Tao_play(GetProcAddress(handlelibao,'ao_play'));
      ao_close := Tao_close(GetProcAddress(handlelibao,'ao_close'));
      ao_driver_id := Tao_driver_id(GetProcAddress(handlelibao,'ao_driver_id'));
      ao_default_driver_id := Tao_default_driver_id(GetProcAddress(handlelibao,'ao_default_driver_id'));
      ao_driver_info :=Tao_driver_info(GetProcAddress(handlelibao,'ao_driver_info'));
      ao_driver_info_list := Tao_driver_info_list(GetProcAddress(handlelibao,'ao_driver_info_list'));
      ao_file_extension := Tao_file_extension(GetProcAddress(handlelibao,'ao_file_extension'));
      ao_is_big_endian := Tao_is_big_endian(GetProcAddress(handlelibao,'ao_is_big_endian'));

      aoinitalized:=True;
end;


finalization

  if (handlelibao <> 0) then FreeLibrary(handlelibao);
end.

