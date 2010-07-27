{
 *
 *  plugin.h - function declarations for libao plugins
 *
 *      Copyright (C) Stan Seibert - June 2001
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
  }
unit plugin;
interface
uses ao, os_types;


  function ao_plugin_test:longint;cdecl; external libao name 'ao_plugin_test';
  function ao_plugin_driver_info:Pao_info;cdecl; external libao name 'ao_plugin_driver_info';
  function ao_plugin_device_init(device:pao_device):longint;cdecl; external libao name 'ao_plugin_device_init';
  function ao_plugin_set_option(device:pao_device; key:pchar; value:pchar):longint;cdecl; external libao name 'ao_plugin_set_option';
  function ao_plugin_open(device:pao_device; format:pao_sample_format):longint;cdecl; external libao name 'ao_plugin_open';
  function ao_plugin_play(device:pao_device; output_samples:pchar; num_bytes:uint_32):longint;cdecl; external libao name 'ao_plugin_play';
  function ao_plugin_close(device:pao_device):longint;cdecl; external libao name 'ao_plugin_close';
  procedure ao_plugin_device_clear(device:pao_device);cdecl; external libao name 'ao_plugin_device_clear';
  function ao_plugin_file_extension:PChar;cdecl; external libao name 'ao_plugin_file_extension';


implementation


end.
