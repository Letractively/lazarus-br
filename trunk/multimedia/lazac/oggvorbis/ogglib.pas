{Adaptada para LazAC por Elson Junio elsonjunio@yahoo.com.br}

{
  Translation of the ogg headers for FreePascal
  Copyright (C) 2006 by Ivo Steinmann
}

(********************************************************************
 *                                                                  *
 * THIS FILE IS PART OF THE OggVorbis SOFTWARE CODEC SOURCE CODE.   *
 * USE, DISTRIBUTION AND REPRODUCTION OF THIS LIBRARY SOURCE IS     *
 * GOVERNED BY A BSD-STYLE SOURCE LICENSE INCLUDED WITH THIS SOURCE *
 * IN 'COPYING'. PLEASE READ THESE TERMS BEFORE DISTRIBUTING.       *
 *                                                                  *
 * THE OggVorbis SOURCE CODE IS (C) COPYRIGHT 1994-2002             *
 * by the Xiph.Org Foundation http://www.xiph.org/                  *
 *                                                                  *
 ********************************************************************)

unit Ogglib;

{$mode objfpc}

interface

uses
    Classes, SysUtils, ctypes, dynlibs;

const
{$IF Defined(WINDOWS)}
  ogglib_ = 'ogglib.dll';
{$ELSEIF Defined(UNIX)}
  ogglib_ = 'libogg.so';
{$ENDIF}


(***********************************************************************)
(* Header : os_types.h                                                 *)
(***********************************************************************)
type
  ogg_int64_t    = cint64;              pogg_int64_t    = ^ogg_int64_t;
  ogg_int32_t    = cint32;              pogg_int32_t    = ^ogg_int32_t;
  ogg_uint32_t   = cuint32;             pogg_uint32_t   = ^ogg_uint32_t;
  ogg_int16_t    = cint16;              pogg_int16_t    = ^ogg_int16_t;
  ogg_uint16_t   = cuint16;             pogg_uint16_t   = ^ogg_uint16_t;


(***********************************************************************)
(* Header : ogg.h                                                      *)
(***********************************************************************)
type
  poggpack_buffer = ^oggpack_buffer;
  oggpack_buffer = record
    endbyte         : clong;
    endbit          : cint;
    buffer          : pcuchar;
    ptr             : pcuchar;
    storage         : clong;
  end;

{ ogg_page is used to encapsulate the data in one Ogg bitstream page }

  pogg_page = ^ogg_page;
  ogg_page = record
    header          : pcuchar;
    header_len      : clong;
    body            : pcuchar;
    body_len        : clong;
  end;

{ ogg_stream_state contains the current encode/decode state of a logical Ogg bitstream }

  pogg_stream_state = ^ogg_stream_state;
  ogg_stream_state = record
    body_data       : pcuchar;                 { bytes from packet bodies }
    body_storage    : clong;                           { storage elements allocated }
    body_fill       : clong;                           { elements stored; fill mark }
    body_returned   : clong;                           { elements of fill returned }

    lacing_vals     : pcint;                            { The values that will go to the segment table }
    granule_vals    : pogg_int64_t;                    { granulepos values for headers. Not compact this way, but it is simple coupled to the lacing fifo }

    lacing_storage  : clong;
    lacing_fill     : clong;
    lacing_packet   : clong;
    lacing_returned : clong;

    header          : array[0..281] of cuchar; { working space for header encode }
    header_fill     : cint;

    e_o_s           : cint;                            { set when we have buffered the last packet in the logical bitstream }
    b_o_s           : cint;                            { set after we've written the initial page of a logical bitstream }

    serialno        : clong;
    pageno          : clong;
    packetno        : ogg_int64_t;                    { sequence number for decode; the framing knows where there's a hole in the data,
                                                        but we need coupling so that the codec (which is in a seperate abstraction layer) also knows about the gap }
    granulepos      : ogg_int64_t;
  end;

{ ogg_packet is used to encapsulate the data and metadata belonging to a single raw Ogg/Vorbis packet }

  pogg_packet = ^ogg_packet;
  ogg_packet = record
    packet          : pcuchar;
    bytes           : clong;
    b_o_s           : clong;
    e_o_s           : clong;

    granulepos      : ogg_int64_t;
    packetno        : ogg_int64_t;             { sequence number for decode; the framing knows where there's a hole in the data,
                                                 but we need coupling so that the codec (which is in a seperate abstraction layer) also knows about the gap }
  end;

  ogg_sync_state = record
    data            : pcuchar;
    storage         : cint;
    fill            : cint;
    returned        : cint;

    unsynced        : cint;
    headerbytes     : cint;
    bodybytes       : cint;
  end;

type EOggError = class(Exception);
{ Ogg BITSTREAM PRIMITIVES: bitstream }

Toggpack_writeinit = procedure (var b: oggpack_buffer); cdecl;
Toggpack_writetrunc = procedure (var b: oggpack_buffer; bits: clong);cdecl;
Toggpack_writealign = procedure (var b: oggpack_buffer); cdecl;
Toggpack_writecopy = procedure (var b: oggpack_buffer; source: pointer; bits: clong); cdecl;
Toggpack_reset = procedure (var b: oggpack_buffer); cdecl;
Toggpack_writeclear = procedure (var b: oggpack_buffer); cdecl;
Toggpack_readinit = procedure (var b: oggpack_buffer; buf: pointer; bytes: cint); cdecl;
Toggpack_write = procedure (var b: oggpack_buffer; value: culong; bits: cint); cdecl;
Toggpack_look = function  (var b: oggpack_buffer; bits: cint): clong; cdecl;
Toggpack_look1 = function  (var b: oggpack_buffer): clong; cdecl;
Toggpack_adv = procedure (var b: oggpack_buffer; bits: cint); cdecl;
Toggpack_adv1 = procedure (var b: oggpack_buffer); cdecl;
oggpack_read = function  (var b: oggpack_buffer; bits: cint): clong; cdecl;
Toggpack_read1 = function  (var b: oggpack_buffer): clong; cdecl;
Toggpack_bytes = function  (var b: oggpack_buffer): clong; cdecl;
Toggpack_bits = function  (var b: oggpack_buffer): clong; cdecl;
Toggpack_get_buffer = function  (var b: oggpack_buffer): pointer; cdecl;

ToggpackB_writeinit = procedure (var b: oggpack_buffer); cdecl;
ToggpackB_writetrunc = procedure (var b: oggpack_buffer; bits: clong); cdecl;
ToggpackB_writealign = procedure (var b: oggpack_buffer); cdecl;
ToggpackB_writecopy = procedure (var b: oggpack_buffer; source: pointer; bits: clong); cdecl;
ToggpackB_reset = procedure (var b: oggpack_buffer); cdecl;
ToggpackB_writeclear = procedure (var b: oggpack_buffer); cdecl;
ToggpackB_readinit = procedure (var b: oggpack_buffer; buf: pointer; bytes: cint); cdecl;
ToggpackB_write = procedure (var b: oggpack_buffer; value: culong; bits: cint); cdecl;
ToggpackB_look = function  (var b: oggpack_buffer; bits: cint): clong; cdecl;
ToggpackB_look1 = function  (var b: oggpack_buffer): clong; cdecl;
ToggpackB_adv = procedure (var b: oggpack_buffer; bits: cint); cdecl;
ToggpackB_adv1 = procedure (var b: oggpack_buffer); cdecl;
ToggpackB_read = function  (var b: oggpack_buffer; bits: cint): clong; cdecl;
ToggpackB_read1 = function  (var b: oggpack_buffer): clong; cdecl;
ToggpackB_bytes = function  (var b: oggpack_buffer): clong; cdecl;
ToggpackB_bits = function  (var b: oggpack_buffer): clong; cdecl;
ToggpackB_get_buffer = function  (var b: oggpack_buffer): pointer; cdecl;

{ ogglib BITSTREAM PRIMITIVES: encoding }

Togg_stream_packetin = function  (var os: ogg_stream_state; var op: ogg_packet): cint; cdecl;
Togg_stream_pageout = function  (var os: ogg_stream_state; var op: ogg_page): cint; cdecl;
Togg_stream_flush = function  (var os: ogg_stream_state; var op: ogg_page): cint; cdecl;

{ ogglib BITSTREAM PRIMITIVES: decoding }

Togg_sync_init = function  (var oy: ogg_sync_state): cint; cdecl;
Togg_sync_clear = function  (var oy: ogg_sync_state): cint; cdecl;
Togg_sync_reset = function  (var oy: ogg_sync_state): cint; cdecl;
Togg_sync_destroy = function  (var oy: ogg_sync_state): cint; cdecl;

Togg_sync_buffer = function  (var oy: ogg_sync_state; size: clong): pointer; cdecl;
Togg_sync_wrote = function  (var oy: ogg_sync_state; bytes: clong): cint; cdecl;
Togg_sync_pageseek = function  (var oy: ogg_sync_state; var og: ogg_page): pointer; cdecl;
Togg_sync_pageout = function  (var oy: ogg_sync_state; var og: ogg_page): cint; cdecl;
Togg_stream_pagein = function  (var os: ogg_stream_state; var og: ogg_page): cint; cdecl;
Togg_stream_packetout = function  (var os: ogg_stream_state; var op: ogg_packet): cint; cdecl;
Togg_stream_packetpeek = function  (var os: ogg_stream_state; var op: ogg_packet): cint; cdecl;

{ ogglib BITSTREAM PRIMITIVES: general }

Togg_stream_init = function  (var os: ogg_stream_state; serialno: cint): cint; cdecl;
Togg_stream_clear = function  (var os: ogg_stream_state): cint; cdecl;
Togg_stream_reset = function  (var os: ogg_stream_state): cint; cdecl;
Togg_stream_reset_serialno = function  (var os: ogg_stream_state; serialno: cint): cint; cdecl;
Togg_stream_destroy = function  (var os: ogg_stream_state): cint; cdecl;
Togg_stream_eos = function  (var os: ogg_stream_state): cint; cdecl;

Togg_page_checksum_set = procedure (var og: ogg_page); cdecl;

Togg_page_version = function  (var og: ogg_page): cint; cdecl;
Togg_page_continued = function  (var og: ogg_page): cint; cdecl;
Togg_page_bos = function  (var og: ogg_page): cint; cdecl;
Togg_page_eos = function  (var og: ogg_page): cint; cdecl;
Togg_page_granulepos = function  (var og: ogg_page): ogg_int64_t; cdecl;
Togg_page_serialno = function  (var og: ogg_page): cint; cdecl;
Togg_page_pageno = function  (var og: ogg_page): clong; cdecl;
Togg_page_packets = function  (var og: ogg_page): cint; cdecl;

Togg_packet_clear = procedure (var op: ogg_packet); cdecl;


var

oggpack_writeinit : Toggpack_writeinit;
oggpack_writetrunc : Toggpack_writetrunc;
oggpack_writealign : Toggpack_writealign;
oggpack_writecopy : Toggpack_writecopy;
oggpack_reset : Toggpack_reset;
oggpack_writeclear : Toggpack_writeclear;
oggpack_readinit : Toggpack_readinit;
oggpack_write : Toggpack_write;
oggpack_look : Toggpack_look;
oggpack_look1 : Toggpack_look1;
oggpack_adv : Toggpack_adv;
oggpack_adv1 : Toggpack_adv1;
ggpack_read : oggpack_read;
oggpack_read1 : Toggpack_read1;
oggpack_bytes : Toggpack_bytes;
oggpack_bits : Toggpack_bits;
oggpack_get_buffer : Toggpack_get_buffer;

oggpackB_writeinit : ToggpackB_writeinit;
oggpackB_writetrunc : ToggpackB_writetrunc;
oggpackB_writealign : ToggpackB_writealign;
oggpackB_writecopy : ToggpackB_writecopy;
oggpackB_reset : ToggpackB_reset;
oggpackB_writeclear : ToggpackB_writeclear;
oggpackB_readinit : ToggpackB_readinit;
oggpackB_write : ToggpackB_write;
oggpackB_look : ToggpackB_look;
oggpackB_look1 : ToggpackB_look1;
oggpackB_adv : ToggpackB_adv;
oggpackB_adv1 : ToggpackB_adv1;
oggpackB_read : ToggpackB_read;
oggpackB_read1 : ToggpackB_read1;
oggpackB_bytes : ToggpackB_bytes;
oggpackB_bits : ToggpackB_bits;
oggpackB_get_buffer : ToggpackB_get_buffer;

{ ogglib BITSTREAM PRIMITIVES: encoding }

ogg_stream_packetin : Togg_stream_packetin;
ogg_stream_pageout : Togg_stream_pageout;
ogg_stream_flush : Togg_stream_flush;

{ ogglib BITSTREAM PRIMITIVES: decoding }

ogg_sync_init : Togg_sync_init;
ogg_sync_clear : Togg_sync_clear;
ogg_sync_reset : Togg_sync_reset;
ogg_sync_destroy : Togg_sync_destroy;

ogg_sync_buffer : Togg_sync_buffer;
ogg_sync_wrote : Togg_sync_wrote;
ogg_sync_pageseek : Togg_sync_pageseek;
ogg_sync_pageout : Togg_sync_pageout;
ogg_stream_pagein : Togg_stream_pagein;
ogg_stream_packetout : Togg_stream_packetout;
ogg_stream_packetpeek : Togg_stream_packetpeek;

{ ogglib BITSTREAM PRIMITIVES: general }

ogg_stream_init : Togg_stream_init;
ogg_stream_clear : Togg_stream_clear;
ogg_stream_reset : Togg_stream_reset;
ogg_stream_reset_serialno : Togg_stream_reset_serialno;
ogg_stream_destroy : Togg_stream_destroy;
ogg_stream_eos : Togg_stream_eos;

ogg_page_checksum_set : Togg_page_checksum_set;

ogg_page_version : Togg_page_version;
ogg_page_continued : Togg_page_continued;
ogg_page_bos : Togg_page_bos;
ogg_page_eos : Togg_page_eos;
ogg_page_granulepos : Togg_page_granulepos;
ogg_page_serialno : Togg_page_serialno;
ogg_page_pageno : Togg_page_pageno;
ogg_page_packets : Togg_page_packets;

ogg_packet_clear : Togg_packet_clear;


procedure InitHandleOgg;

var
handleogglib: TLibHandle=0;
ogginitalized:boolean=False;
implementation
procedure InitHandleOgg;
begin
  if ogginitalized then Exit;


  handleogglib:=LoadLibrary(ogglib_);
  if (handleogglib = 0) then
    raise EOggError.Create(ogglib_ + ' not found.');
  //--

  oggpack_writeinit := Toggpack_writeinit(GetProcAddress(handleogglib,'oggpack_writeinit'));
  oggpack_writetrunc := Toggpack_writetrunc(GetProcAddress(handleogglib,'oggpack_writetrunc'));
  oggpack_writealign := Toggpack_writealign(GetProcAddress(handleogglib,'oggpack_writealign'));
  oggpack_writecopy := Toggpack_writecopy(GetProcAddress(handleogglib,'oggpack_writecopy'));
  oggpack_reset := Toggpack_reset(GetProcAddress(handleogglib,'oggpack_reset'));
  oggpack_writeclear := Toggpack_writeclear(GetProcAddress(handleogglib,'oggpack_writeclear'));
  oggpack_readinit := Toggpack_readinit(GetProcAddress(handleogglib,'oggpack_readinit'));
  oggpack_write := Toggpack_write(GetProcAddress(handleogglib,'oggpack_write'));
  oggpack_look := Toggpack_look(GetProcAddress(handleogglib,'oggpack_look'));
  oggpack_look1 := Toggpack_look1(GetProcAddress(handleogglib,'oggpack_look1'));
  oggpack_adv := Toggpack_adv(GetProcAddress(handleogglib,'oggpack_adv'));
  oggpack_adv1 := Toggpack_adv1(GetProcAddress(handleogglib,'oggpack_adv1'));
  ggpack_read := oggpack_read(GetProcAddress(handleogglib,'ggpack_read'));
  oggpack_read1 := Toggpack_read1(GetProcAddress(handleogglib,'oggpack_read1'));
  oggpack_bytes := Toggpack_bytes(GetProcAddress(handleogglib,'oggpack_bytes'));
  oggpack_bits := Toggpack_bits(GetProcAddress(handleogglib,'oggpack_bits'));
  oggpack_get_buffer := Toggpack_get_buffer(GetProcAddress(handleogglib,'oggpack_get_buffer'));
  oggpackB_writeinit := ToggpackB_writeinit(GetProcAddress(handleogglib,'oggpackB_writeinit'));
  oggpackB_writetrunc := ToggpackB_writetrunc(GetProcAddress(handleogglib,'oggpackB_writetrunc'));
  oggpackB_writealign := ToggpackB_writealign(GetProcAddress(handleogglib,'oggpackB_writealign'));
  oggpackB_writecopy := ToggpackB_writecopy(GetProcAddress(handleogglib,'oggpackB_writecopy'));
  oggpackB_reset := ToggpackB_reset(GetProcAddress(handleogglib,'oggpackB_reset'));
  oggpackB_writeclear := ToggpackB_writeclear(GetProcAddress(handleogglib,'oggpackB_writeclear'));
  oggpackB_readinit := ToggpackB_readinit(GetProcAddress(handleogglib,'oggpackB_readinit'));
  oggpackB_write := ToggpackB_write(GetProcAddress(handleogglib,'oggpackB_write'));
  oggpackB_look := ToggpackB_look(GetProcAddress(handleogglib,'oggpackB_look'));
  oggpackB_look1 := ToggpackB_look1(GetProcAddress(handleogglib,'oggpackB_look1'));
  oggpackB_adv := ToggpackB_adv(GetProcAddress(handleogglib,'oggpackB_adv'));
  oggpackB_adv1 := ToggpackB_adv1(GetProcAddress(handleogglib,'oggpackB_adv1'));
  oggpackB_read := ToggpackB_read(GetProcAddress(handleogglib,'oggpackB_read'));
  oggpackB_read1 := ToggpackB_read1(GetProcAddress(handleogglib,'oggpackB_read1'));
  oggpackB_bytes := ToggpackB_bytes(GetProcAddress(handleogglib,'oggpackB_bytes'));
  oggpackB_bits := ToggpackB_bits(GetProcAddress(handleogglib,'oggpackB_bits'));
  oggpackB_get_buffer := ToggpackB_get_buffer(GetProcAddress(handleogglib,'oggpackB_get_buffer'));
  ogg_stream_packetin := Togg_stream_packetin(GetProcAddress(handleogglib,'ogg_stream_packetin'));
  ogg_stream_pageout := Togg_stream_pageout(GetProcAddress(handleogglib,'ogg_stream_pageout'));
  ogg_stream_flush := Togg_stream_flush(GetProcAddress(handleogglib,'ogg_stream_flush'));
  ogg_sync_init := Togg_sync_init(GetProcAddress(handleogglib,'ogg_sync_init'));
  ogg_sync_clear := Togg_sync_clear(GetProcAddress(handleogglib,'ogg_sync_clear'));
  ogg_sync_reset := Togg_sync_reset(GetProcAddress(handleogglib,'ogg_sync_reset'));
  ogg_sync_destroy := Togg_sync_destroy(GetProcAddress(handleogglib,'ogg_sync_destroy'));
  ogg_sync_buffer := Togg_sync_buffer(GetProcAddress(handleogglib,'ogg_sync_buffer'));
  ogg_sync_wrote := Togg_sync_wrote(GetProcAddress(handleogglib,'ogg_sync_wrote'));
  ogg_sync_pageseek := Togg_sync_pageseek(GetProcAddress(handleogglib,'ogg_sync_pageseek'));
  ogg_sync_pageout := Togg_sync_pageout(GetProcAddress(handleogglib,'ogg_sync_pageout'));
  ogg_stream_pagein := Togg_stream_pagein(GetProcAddress(handleogglib,'ogg_stream_pagein'));
  ogg_stream_packetout := Togg_stream_packetout(GetProcAddress(handleogglib,'ogg_stream_packetout'));
  ogg_stream_packetpeek := Togg_stream_packetpeek(GetProcAddress(handleogglib,'ogg_stream_packetpeek'));
  ogg_stream_init := Togg_stream_init(GetProcAddress(handleogglib,'ogg_stream_init'));
  ogg_stream_clear := Togg_stream_clear(GetProcAddress(handleogglib,'ogg_stream_clear'));
  ogg_stream_reset := Togg_stream_reset(GetProcAddress(handleogglib,'ogg_stream_reset'));
  ogg_stream_reset_serialno := Togg_stream_reset_serialno(GetProcAddress(handleogglib,'ogg_stream_reset_serialno'));
  ogg_stream_destroy := Togg_stream_destroy(GetProcAddress(handleogglib,'ogg_stream_destroy'));
  ogg_stream_eos := Togg_stream_eos(GetProcAddress(handleogglib,'ogg_stream_eos'));
  ogg_page_checksum_set := Togg_page_checksum_set(GetProcAddress(handleogglib,'ogg_page_checksum_set'));
  ogg_page_version := Togg_page_version(GetProcAddress(handleogglib,'ogg_page_version'));
  ogg_page_continued := Togg_page_continued(GetProcAddress(handleogglib,'ogg_page_continued'));
  ogg_page_bos := Togg_page_bos(GetProcAddress(handleogglib,'ogg_page_bos'));
  ogg_page_eos := Togg_page_eos(GetProcAddress(handleogglib,'ogg_page_eos'));
  ogg_page_granulepos := Togg_page_granulepos(GetProcAddress(handleogglib,'ogg_page_granulepos'));
  ogg_page_serialno := Togg_page_serialno(GetProcAddress(handleogglib,'ogg_page_serialno'));
  ogg_page_pageno := Togg_page_pageno(GetProcAddress(handleogglib,'ogg_page_pageno'));
  ogg_page_packets := Togg_page_packets(GetProcAddress(handleogglib,'ogg_page_packets'));
  ogg_packet_clear := Togg_packet_clear(GetProcAddress(handleogglib,'ogg_packet_clear'));

  ogginitalized:=True;

end;

finalization
  if (handleogglib <> 0) then FreeLibrary(handleogglib);

end.
