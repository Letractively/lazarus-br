{Adaptada para LazAC por Elson Junio elsonjunio@yahoo.com.br}

{
  Translation of the vorbis headers for FreePascal
  Copyright (C) 2006 by Ivo Steinmann
}

(********************************************************************
 *                                                                  *
 * THIS FILE IS PART OF THE OggVorbis SOFTWARE CODEC SOURCE CODE.   *
 * USE, DISTRIBUTION AND REPRODUCTION OF THIS LIBRARY SOURCE IS     *
 * GOVERNED BY A BSD-STYLE SOURCE LICENSE INCLUDED WITH THIS SOURCE *
 * IN 'COPYING'. PLEASE READ THESE TERMS BEFORE DISTRIBUTING.       *
 *                                                                  *
 * THE OggVorbis SOURCE CODE IS (C) COPYRIGHT 1994-2001             *
 * by the XIPHOPHORUS Company http://www.xiph.org/                  *
 *                                                                  *
 ********************************************************************)

unit Vorbislib;

{$mode objfpc}
{$MINENUMSIZE 4}
{$PACKRECORDS C}

interface

uses
  Classes, SysUtils, ctypes, ogglib, dynlibs;

const
{$IF Defined(WINDOWS)}
  vorbislib_     = 'libvorbis.dll';
  vorbisfilelib = 'libvorbisfile.dll';
  vorbisenclib  = 'libvorbisenc.dll';
{$ELSEIF Defined(UNIX)}
  vorbislib_     = 'libvorbis.so';
  vorbisfilelib = 'libvorbisfile.so';
  vorbisenclib  = 'libvorbisenc.so';
{$ENDIF}

(***********************************************************************)
(* Header : codec.h                                                    *)
(***********************************************************************)

type
  ppcfloat = ^pcfloat;

  pvorbis_info = ^vorbis_info;
  vorbis_info = record
    version         : cint;
    channels        : cint;
    rate            : clong;

  { The below bitrate declarations are *hints*.
     Combinations of the three values carry the following implications:

     all three set to the same value:
       implies a fixed rate bitstream
     only nominal set:
       implies a VBR stream that averages the nominal bitrate.  No hard
       upper/lower limit
     upper and or lower set:
       implies a VBR bitstream that obeys the bitrate limits. nominal
       may also be set to give a nominal rate.
     none set:
       the coder does not care to speculate.
  }

    bitrate_upper   : clong;
    bitrate_nominal : clong;
    bitrate_lower   : clong;
    bitrate_window  : clong;
    codec_setup     : pointer;
  end;

{ vorbis_dsp_state buffers the current vorbis audio analysis/synthesis state.  The DSP state belongs to a specific logical bitstream }

  pvorbis_dsp_state = ^vorbis_dsp_state;
  vorbis_dsp_state = record
    analysisp       : cint;
    vi              : pvorbis_info;

    pcm             : ppcfloat;
    pcmret          : ppcfloat;
    pcm_storage     : cint;
    pcm_current     : cint;
    pcm_returned    : cint;

    preextrapolate  : cint;
    eofflag         : cint;

    lW              : clong;
    W               : clong;
    nW              : clong;
    centerW         : clong;

    granulepos      : ogg_int64_t;
    sequence        : ogg_int64_t;

    glue_bits       : ogg_int64_t;
    time_bits       : ogg_int64_t;
    floor_bits      : ogg_int64_t;
    res_bits        : ogg_int64_t;

    backend_state   : pointer;
  end;

{ vorbis_block is a single block of data to be processed as part of
  the analysis/synthesis stream; it belongs to a specific logical
  bitstream, but is independant from other vorbis_blocks belonging to
  that logical bitstream. }

  palloc_chain = ^alloc_chain;
  alloc_chain = record
    ptr             : pointer;
    next            : palloc_chain;
  end;

  pvorbis_block = ^vorbis_block;
  vorbis_block = record
  { necessary stream state for linking to the framing abstraction }
    pcm             : ppcfloat;            { this is a pointer into local storage }
    opb             : oggpack_buffer;

    lW              : clong;
    W               : clong;
    nW              : clong;
    pcmend          : cint;
    mode            : cint;

    eofflag         : cint;
    granulepos      : ogg_int64_t;
    sequence        : ogg_int64_t;
    vd              : pvorbis_dsp_state; { For read-only access of configuration }

  { local storage to avoid remallocing; it's up to the mapping to structure it }
    localstore      : pointer;
    localtop        : clong;
    localalloc      : clong;
    totaluse        : clong;
    reap            : palloc_chain;

  { bitmetrics for the frame }
    glue_bits       : clong;
    time_bits       : clong;
    floor_bits      : clong;
    res_bits        : clong;

    internal        : pointer;
  end;

{ vorbis_info contains all the setup information specific to the
  specific compression/decompression mode in progress (eg,
  psychoacoustic settings, channel setup, options, codebook
  etc). vorbis_info and substructures are in backends.h. }

{ the comments are not part of vorbis_info so that vorbis_info can be static storage }

  pvorbis_comment = ^vorbis_comment;
  vorbis_comment = record
  { unlimited user comment fields.  libvorbis writes 'libvorbis' whatever vendor is set to in encode }
    user_comments   : ^pcchar;
    comment_lengths : pcint;
    comments        : cint;
    vendor          : pcchar;
  end;


{ libvorbis encodes in two abstraction layers; first we perform DSP
  and produce a packet (see docs/analysis.txt).  The packet is then
  coded into a framed OggSquish bitstream by the second layer (see
  docs/framing.txt).  Decode is the reverse process; we sync/frame
  the bitstream and extract individual packets, then decode the
  packet back into PCM audio.

  The extra framing/packetizing is used in streaming formats, such as
  files.  Over the net (such as with UDP), the framing and
  packetization aren't necessary as they're provided by the transport
  and the streaming layer is not used }

{ Vorbis PRIMITIVES: general }

Tvorbis_info_init = procedure (var vi: vorbis_info); cdecl;
Tvorbis_info_clear = procedure (var vi: vorbis_info); cdecl;
Tvorbis_info_blocksize = function  (var vi: vorbis_info; zo: cint): cint; cdecl;
Tvorbis_comment_init = procedure (var vc: vorbis_comment); cdecl;
Tvorbis_comment_add = procedure (var vc: vorbis_comment; comment: pchar); cdecl;
Tvorbis_comment_add_tag = procedure (var vc: vorbis_comment; tag: pchar; contents: pchar); cdecl;
Tvorbis_comment_query = function  (var vc: vorbis_comment; tag: pchar; count: cint): pchar; cdecl;
Tvorbis_comment_query_count = function  (var vc: vorbis_comment; tag: pchar): cint; cdecl;
Tvorbis_comment_clear = procedure (var vc: vorbis_comment); cdecl;

Tvorbis_block_init = function  (var v: vorbis_dsp_state; var vb: vorbis_block): cint; cdecl;
Tvorbis_block_clear = function  (var vb: vorbis_block): cint; cdecl;
Tvorbis_dsp_clear = procedure (var v: vorbis_dsp_state); cdecl;
Tvorbis_granule_time = function  (var v: vorbis_dsp_state; granulepos: ogg_int64_t): cdouble; cdecl;

{ vorbislib PRIMITIVES: analysis/DSP layer }

Tvorbis_analysis_init = function  (var v: vorbis_dsp_state; var vi: vorbis_info): cint; cdecl;
Tvorbis_commentheader_out = function  (var vc: vorbis_comment; var op: ogg_packet): cint; cdecl;
Tvorbis_analysis_headerout = function  (var v:vorbis_dsp_state; var vc: vorbis_comment; var op: ogg_packet; var op_comm: ogg_packet; var op_code: ogg_packet): cint; cdecl;
Tvorbis_analysis_buffer = function  (var v: vorbis_dsp_state; vals: cint): ppcfloat; cdecl;
Tvorbis_analysis_wrote = function  (var v: vorbis_dsp_state; vals: cint): cint; cdecl;
Tvorbis_analysis_blockout = function  (var v: vorbis_dsp_state; var vb: vorbis_block): cint; cdecl;
Tvorbis_analysis = function  (var vb: vorbis_block; var op: ogg_packet): cint; cdecl;

Tvorbis_bitrate_addblock = function  (var vb: vorbis_block): cint; cdecl;
Tvorbis_bitrate_flushpacket = function  (var vd: vorbis_dsp_state; var op: ogg_packet): cint; cdecl;

{ vorbislib PRIMITIVES: synthesis layer }

Tvorbis_synthesis_headerin = function  (var vi: vorbis_info; var vc: vorbis_comment; var op: ogg_packet): cint; cdecl;

Tvorbis_synthesis_init = function  (var v: vorbis_dsp_state; var vi: vorbis_info): cint; cdecl;
Tvorbis_synthesis_restart = function  (var v: vorbis_dsp_state): cint; cdecl;
Tvorbis_synthesis = function  (var vb: vorbis_block; var op: ogg_packet): cint; cdecl;
Tvorbis_synthesis_trackonly = function  (var vb: vorbis_block; var op: ogg_packet): cint; cdecl;
Tvorbis_synthesis_blockin = function  (var v: vorbis_dsp_state; var vb: vorbis_block): cint; cdecl;
Tvorbis_synthesis_pcmout = function  (var v: vorbis_dsp_state; var pcm: ppcfloat): cint; cdecl;
Tvorbis_synthesis_lapout = function  (var v: vorbis_dsp_state; var pcm: ppcfloat): cint; cdecl;
Tvorbis_synthesis_read = function  (var v: vorbis_dsp_state; samples: cint): cint; cdecl;
Tvorbis_packet_blocksize = function  (var vi: vorbis_info; var op: ogg_packet): clong; cdecl;

Tvorbis_synthesis_halfrate = function  (var v: vorbis_info; flag: cint): cint; cdecl;
Tvorbis_synthesis_halfrate_p = function  (var v: vorbis_info): cint; cdecl;

{ vorbislib ERRORS and return codes }
Const
  OV_FALSE          = -1;
  OV_EOF            = -2;
  OV_HOLE           = -3;

  OV_EREAD          = -128;
  OV_EFAULT         = -129;
  OV_EIMPL          = -130;
  OV_EINVAL         = -131;
  OV_ENOTVORBIS     = -132;
  OV_EBADHEADER     = -133;
  OV_EVERSION       = -134;
  OV_ENOTAUDIO      = -135;
  OV_EBADPACKET     = -136;
  OV_EBADLINK       = -137;
  OV_ENOSEEK        = -138;


(***********************************************************************)
(* Header : vorbisfile.h                                               *)
(***********************************************************************)

type

{* The function prototypes for the callbacks are basically the same as for

 * the stdio functions fread, fseek, fclose, ftell.
 * The one difference is that the FILE * arguments have been replaced with
 * a void * - this is to be used as a pointer to whatever internal data these
 * functions might need. In the stdio case, it's just a FILE * cast to a void *
 *
 * If you use other functions, check the docs for these functions and return
 * the right values. For seek_func(), you *MUST* return -1 if the stream is
 * unseekable
 *}

  read_func  = function(ptr: pointer; size, nmemb: csize_t; datasource: pointer): csize_t; cdecl;
  seek_func  = function(datasource: pointer; offset: ogg_int64_t; whence: cint): cint; cdecl;
  close_func = function(datasource: pointer): cint; cdecl;
  tell_func  = function(datasource: pointer): clong; cdecl;

  pov_callbacks = ^ov_callbacks;
  ov_callbacks = record
    read            : read_func;
    seek            : seek_func;
    close           : close_func;
    tell            : tell_func;
  end;

const
  NOTOPEN           = 0;
  PARTOPEN          = 1;
  OPENED            = 2;
  STREAMSET         = 3;
  INITSET           = 4;

type
  POggVorbis_File = ^OggVorbis_File;
  OggVorbis_File = record
    datasource      : pointer; { pointer to a FILE *, etc. }
    seekable        : cint;
    offset          : ogg_int64_t;
    end_            : ogg_int64_t;
    oy              : ogg_sync_state;

  { If the FILE handle isn't seekable (eg, a pipe), only the current stream appears }
    links           : cint;
    offsets         : pogg_int64_t;
    dataoffsets     : pogg_int64_t;
    serialnos       : pclong;
    pcmlengths      : pogg_int64_t; { overloaded to maintain binary compatability; x2 size, stores both beginning and end values }
    vi              : pvorbis_info;
    vc              : pvorbis_comment;

  { Decoding working state local storage }
    pcm_offset      : ogg_int64_t;
    ready_state     : cint;
    current_serialno: clong;
    current_link    : cint;

    bittrack        : cdouble;
    samptrack       : cdouble;

    os              : ogg_stream_state; { take physical pages, weld into a logical stream of packets }
    vd              : vorbis_dsp_state; { central working state for the packet->PCM decoder }
    vb              : vorbis_block;     { local working space for packet->PCM decode }

    callbacks       : ov_callbacks;
  end;


Tov_clear = function (var vf: OggVorbis_File): cint; cdecl;
Tov_open = function (f: pointer; var vf: OggVorbis_File; initial: pointer; ibytes: clong): cint; cdecl;
Tov_open_callbacks = function (datasource: pointer; var vf: OggVorbis_File; initial: pointer; ibytes: clong; callbacks: ov_callbacks): cint; cdecl;

Tov_test = function (f: pointer; var vf: OggVorbis_File; initial: pointer; ibytes: clong): cint; cdecl;
Tov_test_callbacks = function (datasource: pointer; var vf: OggVorbis_File; initial: pointer; ibytes: clong; callbacks: ov_callbacks): cint; cdecl;
Tov_test_open = function (var vf: OggVorbis_File): cint; cdecl;

Tov_bitrate = function (var vf: OggVorbis_File; i: cint): clong; cdecl;
Tov_bitrate_instant = function (var vf: OggVorbis_File): clong; cdecl;
Tov_streams = function (var vf: OggVorbis_File): clong; cdecl;
Tov_seekable = function (var vf: OggVorbis_File): clong; cdecl;
Tov_serialnumber = function (var vf: OggVorbis_File; i: cint): clong; cdecl;

Tov_raw_total = function (var vf: OggVorbis_File; i: cint): ogg_int64_t; cdecl;
Tov_pcm_total = function (var vf: OggVorbis_File; i: cint): ogg_int64_t; cdecl;
Tov_time_total = function (var vf: OggVorbis_File; i: cint): cdouble; cdecl;

Tov_raw_seek = function (var vf: OggVorbis_File; pos: ogg_int64_t): cint; cdecl;
Tov_pcm_seek = function (var vf: OggVorbis_File; pos: ogg_int64_t): cint; cdecl;
Tov_pcm_seek_page = function (var vf: OggVorbis_File; pos: ogg_int64_t): cint; cdecl;
Tov_time_seek = function (var vf: OggVorbis_File; pos: cdouble): cint; cdecl;
Tov_time_seek_page = function (var vf: OggVorbis_File; pos: cdouble): cint; cdecl;

Tov_raw_seek_lap = function (var vf: OggVorbis_File; pos: ogg_int64_t): cint; cdecl;
Tov_pcm_seek_lap = function (var vf: OggVorbis_File; pos: ogg_int64_t): cint; cdecl;
Tov_pcm_seek_page_lap = function (var vf: OggVorbis_File; pos: ogg_int64_t): cint; cdecl;
Tov_time_seek_lap = function (var vf: OggVorbis_File; pos: cdouble): cint; cdecl;
Tov_time_seek_page_lap = function (var vf: OggVorbis_File; pos: cdouble): cint; cdecl;

Tov_raw_tell = function (var vf: OggVorbis_File): ogg_int64_t; cdecl;
Tov_pcm_tell = function (var vf: OggVorbis_File): ogg_int64_t; cdecl;
Tov_time_tell = function (var vf: OggVorbis_File): cdouble; cdecl;

Tov_info = function (var vf: OggVorbis_File; link: cint): pvorbis_info; cdecl;
Tov_comment = function (var vf: OggVorbis_File; link: cint): pvorbis_comment; cdecl;

Tov_read_float = function (var vf: OggVorbis_File; var pcm_channels: ppcfloat; samples: cint; bitstream: pcint): clong; cdecl;
Tov_read = function (var vf: OggVorbis_File; buffer: pointer; length: cint; bigendianp: cbool; word: cint; sgned: cbool; bitstream: pcint): clong; cdecl;
Tov_crosslap = function (var vf1: OggVorbis_File; var vf2: OggVorbis_File): cint; cdecl;

Tov_halfrate = function (var vf: OggVorbis_File; flag: cint): cint; cdecl;
Tov_halfrate_p = function (var vf: OggVorbis_File): cint; cdecl;


{
  Developer of the A52 helpers for FreePascal
  Copyright (C) 2006 by Ivo Steinmann
}

function ov_read_ext(var vf: OggVorbis_File; buffer: pointer; length: cint; bigendianp: cbool; word: cint; sgned: cbool): clong;


(***********************************************************************)
(* Header : vorbisenc.h                                                *)
(***********************************************************************)

const
  OV_ECTL_RATEMANAGE_GET       = $10;

  OV_ECTL_RATEMANAGE_SET       = $11;
  OV_ECTL_RATEMANAGE_AVG       = $12;
  OV_ECTL_RATEMANAGE_HARD      = $13;

  OV_ECTL_LOWPASS_GET          = $20;
  OV_ECTL_LOWPASS_SET          = $21;

  OV_ECTL_IBLOCK_GET           = $30;
  OV_ECTL_IBLOCK_SET           = $31;

type
  povectl_ratemanage_arg = ^ovectl_ratemanage_arg;
  ovectl_ratemanage_arg = record
    management_active        : cint;

    bitrate_hard_min         : clong;
    bitrate_hard_max         : clong;
    bitrate_hard_window      : cdouble;

    bitrate_av_lo            : clong;
    bitrate_av_hi            : clong;
    bitrate_av_window        : cdouble;
    bitrate_av_window_center : cdouble;
  end;

Tvorbis_encode_init = function (var vi: vorbis_info; channels, rate, max_bitrate, nominal_bitrate, min_bitrate: clong): cint; cdecl;
Tvorbis_encode_setup_managed = function (var vi: vorbis_info; channels, rate, max_bitrate, nominal_bitrate, min_bitrate: clong): cint; cdecl;
Tvorbis_encode_setup_vbr = function (var vi: vorbis_info; channels, rate: clong; quality: cfloat): cint; cdecl;
(* quality level from 0. (lo) to 1. (hi) *)
Tvorbis_encode_init_vbr = function (var vi: vorbis_info; channels, rate: clong; base_quality: cfloat): cint; cdecl;
Tvorbis_encode_setup_init = function (var vi: vorbis_info): cint; cdecl;
Tvorbis_encode_ctl = function (var vi: vorbis_info; number: cint; arg: pointer): cint; cdecl;



type EVorbisError = class(Exception);

var
{ Vorbis PRIMITIVES: general }

vorbis_info_init : Tvorbis_info_init;
vorbis_info_clear : Tvorbis_info_clear;
vorbis_info_blocksize :Tvorbis_info_blocksize;
vorbis_comment_init : Tvorbis_comment_init;
vorbis_comment_add : Tvorbis_comment_add;
vorbis_comment_add_tag : Tvorbis_comment_add_tag;
vorbis_comment_query : Tvorbis_comment_query;
vorbis_comment_query_count : Tvorbis_comment_query_count;
vorbis_comment_clear : Tvorbis_comment_clear;

vorbis_block_init : Tvorbis_block_init;
vorbis_block_clear : Tvorbis_block_clear;
vorbis_dsp_clear : Tvorbis_dsp_clear;
vorbis_granule_time : Tvorbis_granule_time;

{ vorbislib PRIMITIVES: analysis/DSP layer }

vorbis_analysis_init : Tvorbis_analysis_init;
vorbis_commentheader_out : Tvorbis_commentheader_out;
vorbis_analysis_headerout : Tvorbis_analysis_headerout;
vorbis_analysis_buffer : Tvorbis_analysis_buffer;
vorbis_analysis_wrote : Tvorbis_analysis_wrote;
vorbis_analysis_blockout : Tvorbis_analysis_blockout;
vorbis_analysis : Tvorbis_analysis;

vorbis_bitrate_addblock : Tvorbis_bitrate_addblock;
vorbis_bitrate_flushpacket : Tvorbis_bitrate_flushpacket;

{ vorbislib PRIMITIVES: synthesis layer }

vorbis_synthesis_headerin : Tvorbis_synthesis_headerin;

vorbis_synthesis_init : Tvorbis_synthesis_init;
vorbis_synthesis_restart : Tvorbis_synthesis_restart;
vorbis_synthesis : Tvorbis_synthesis;
vorbis_synthesis_trackonly : Tvorbis_synthesis_trackonly;
vorbis_synthesis_blockin : Tvorbis_synthesis_blockin;
vorbis_synthesis_pcmout : Tvorbis_synthesis_pcmout;
vorbis_synthesis_lapout : Tvorbis_synthesis_lapout;
vorbis_synthesis_read : Tvorbis_synthesis_read;
vorbis_packet_blocksize : Tvorbis_packet_blocksize;

vorbis_synthesis_halfrate : Tvorbis_synthesis_halfrate;
vorbis_synthesis_halfrate_p : Tvorbis_synthesis_halfrate_p;
//--
ov_clear : Tov_clear;
ov_open : Tov_open;
ov_open_callbacks : Tov_open_callbacks;

ov_test : Tov_test;
ov_test_callbacks : Tov_test_callbacks;
ov_test_open : Tov_test_open;

ov_bitrate : Tov_bitrate;
ov_bitrate_instant : Tov_bitrate_instant;
ov_streams : Tov_streams;
ov_seekable : Tov_seekable;
ov_serialnumber : Tov_serialnumber;

ov_raw_total : Tov_raw_total;
ov_pcm_total : Tov_pcm_total;
ov_time_total : Tov_time_total;

ov_raw_seek : Tov_raw_seek;
ov_pcm_seek : Tov_pcm_seek;
ov_pcm_seek_page : Tov_pcm_seek_page;
ov_time_seek : Tov_time_seek;
ov_time_seek_page : Tov_time_seek_page;

ov_raw_seek_lap : Tov_raw_seek_lap;
ov_pcm_seek_lap : Tov_pcm_seek_lap;
ov_pcm_seek_page_lap : Tov_pcm_seek_page_lap;
ov_time_seek_lap : Tov_time_seek_lap;
ov_time_seek_page_lap : Tov_time_seek_page_lap;

ov_raw_tell : Tov_raw_tell;
ov_pcm_tell : Tov_pcm_tell;
ov_time_tell : Tov_time_tell;

ov_info : Tov_info;
ov_comment : Tov_comment;

ov_read_float : Tov_read_float;
ov_read : Tov_read;
ov_crosslap : Tov_crosslap;

ov_halfrate : Tov_halfrate;
ov_halfrate_p : Tov_halfrate_p;

vorbis_encode_init : Tvorbis_encode_init;
vorbis_encode_setup_managed : Tvorbis_encode_setup_managed;
vorbis_encode_setup_vbr : Tvorbis_encode_setup_vbr;
(* quality level from 0. (lo) to 1. (hi) *)
vorbis_encode_init_vbr : Tvorbis_encode_init_vbr;
vorbis_encode_setup_init : Tvorbis_encode_setup_init;
vorbis_encode_ctl : Tvorbis_encode_ctl;

procedure InitHandleVorbis;
procedure InitHandleVorbisFile;
procedure InitHandleVorbisEnc;
var
vorbisinitalized:boolean=False;
vorbisfileinitalized:boolean=False;
vorbisencinitalized:boolean=False;

handlevorbislib: TLibHandle=0;
handlevorbisfilelib: TLibHandle=0;
handlevorbisenclib: TLibHandle=0;

implementation

function ov_read_ext(var vf: OggVorbis_File; buffer: pointer; length: cint; bigendianp: cbool; word: cint; sgned: cbool): clong;
var
  ofs: cint;
  Num: cint;
  Res: cint;
begin
  // check blocksize here!
  {if length mod 4 <> 0 then
    Exit(0);}

  ofs := 0;
  num := length;

  while num > 0 do
  begin
    res := ov_read(vf, pointer(ptruint(buffer) + ofs), num, bigendianp, word, sgned, nil);
    if res < 0 then
      Exit(res);

    if res = 0 then
      Break;

    ofs := ofs + res;
    num := num - res;
  end;

  Result := ofs;
end;

procedure InitHandleVorbis;
begin
if vorbisinitalized then Exit;

handlevorbislib:=LoadLibrary(vorbislib_);
 if (handlevorbislib = 0) then
   raise EVorbisError.Create(vorbislib_ + ' not found.');
 //--
vorbis_info_init := Tvorbis_info_init(GetProcAddress(handlevorbislib,'vorbis_info_init'));
vorbis_info_clear := Tvorbis_info_clear(GetProcAddress(handlevorbislib,'vorbis_info_clear'));
vorbis_info_blocksize := Tvorbis_info_blocksize(GetProcAddress(handlevorbislib,'vorbis_info_blocksize'));
vorbis_comment_init := Tvorbis_comment_init(GetProcAddress(handlevorbislib,'vorbis_comment_init'));
vorbis_comment_add := Tvorbis_comment_add(GetProcAddress(handlevorbislib,'vorbis_comment_add'));
vorbis_comment_add_tag := Tvorbis_comment_add_tag(GetProcAddress(handlevorbislib,'vorbis_comment_add_tag'));
vorbis_comment_query := Tvorbis_comment_query(GetProcAddress(handlevorbislib,'vorbis_comment_query'));
vorbis_comment_query_count := Tvorbis_comment_query_count(GetProcAddress(handlevorbislib,'vorbis_comment_query_count'));
vorbis_comment_clear := Tvorbis_comment_clear(GetProcAddress(handlevorbislib,'vorbis_comment_clear'));
vorbis_block_init := Tvorbis_block_init(GetProcAddress(handlevorbislib,'vorbis_block_init'));
vorbis_block_clear := Tvorbis_block_clear(GetProcAddress(handlevorbislib,'vorbis_block_clear'));
vorbis_dsp_clear := Tvorbis_dsp_clear(GetProcAddress(handlevorbislib,'vorbis_dsp_clear'));
vorbis_granule_time := Tvorbis_granule_time(GetProcAddress(handlevorbislib,'vorbis_granule_time'));
vorbis_analysis_init := Tvorbis_analysis_init(GetProcAddress(handlevorbislib,'vorbis_analysis_init'));
vorbis_commentheader_out := Tvorbis_commentheader_out(GetProcAddress(handlevorbislib,'vorbis_commentheader_out'));
vorbis_analysis_headerout := Tvorbis_analysis_headerout(GetProcAddress(handlevorbislib,'vorbis_analysis_headerout'));
vorbis_analysis_buffer := Tvorbis_analysis_buffer(GetProcAddress(handlevorbislib,'vorbis_analysis_buffer'));
vorbis_analysis_wrote := Tvorbis_analysis_wrote(GetProcAddress(handlevorbislib,'vorbis_analysis_wrote'));
vorbis_analysis_blockout := Tvorbis_analysis_blockout(GetProcAddress(handlevorbislib,'vorbis_analysis_blockout'));
vorbis_analysis := Tvorbis_analysis(GetProcAddress(handlevorbislib,'vorbis_analysis'));
vorbis_bitrate_addblock := Tvorbis_bitrate_addblock(GetProcAddress(handlevorbislib,'vorbis_bitrate_addblock'));
vorbis_bitrate_flushpacket := Tvorbis_bitrate_flushpacket(GetProcAddress(handlevorbislib,'vorbis_bitrate_flushpacket'));
vorbis_synthesis_headerin := Tvorbis_synthesis_headerin(GetProcAddress(handlevorbislib,'vorbis_synthesis_headerin'));
vorbis_synthesis_init := Tvorbis_synthesis_init(GetProcAddress(handlevorbislib,'vorbis_synthesis_init'));
vorbis_synthesis_restart := Tvorbis_synthesis_restart(GetProcAddress(handlevorbislib,'vorbis_synthesis_restart'));
vorbis_synthesis := Tvorbis_synthesis(GetProcAddress(handlevorbislib,'vorbis_synthesis'));
vorbis_synthesis_trackonly := Tvorbis_synthesis_trackonly(GetProcAddress(handlevorbislib,'vorbis_synthesis_trackonly'));
vorbis_synthesis_blockin := Tvorbis_synthesis_blockin(GetProcAddress(handlevorbislib,'vorbis_synthesis_blockin'));
vorbis_synthesis_pcmout := Tvorbis_synthesis_pcmout(GetProcAddress(handlevorbislib,'vorbis_synthesis_pcmout'));
vorbis_synthesis_lapout := Tvorbis_synthesis_lapout(GetProcAddress(handlevorbislib,'vorbis_synthesis_lapout'));
vorbis_synthesis_read := Tvorbis_synthesis_read(GetProcAddress(handlevorbislib,'vorbis_synthesis_read'));
vorbis_packet_blocksize := Tvorbis_packet_blocksize(GetProcAddress(handlevorbislib,'vorbis_packet_blocksize'));
vorbis_synthesis_halfrate := Tvorbis_synthesis_halfrate(GetProcAddress(handlevorbislib,'vorbis_synthesis_halfrate'));
vorbis_synthesis_halfrate_p := Tvorbis_synthesis_halfrate_p(GetProcAddress(handlevorbislib,'vorbis_synthesis_halfrate_p'));

vorbisinitalized:= True;
end;

procedure InitHandleVorbisFile;
begin
if vorbisfileinitalized then Exit;
//--

handlevorbisfilelib:=LoadLibrary(vorbisfilelib);
if (handlevorbisfilelib = 0) then
  raise EVorbisError.Create(vorbisfilelib + ' not found.');
//--

ov_clear := Tov_clear(GetProcAddress(handlevorbisfilelib,'ov_clear'));
ov_open := Tov_open(GetProcAddress(handlevorbisfilelib,'ov_open'));
ov_open_callbacks := Tov_open_callbacks(GetProcAddress(handlevorbisfilelib,'ov_open_callbacks'));

ov_test := Tov_test(GetProcAddress(handlevorbisfilelib,'ov_test'));
ov_test_callbacks := Tov_test_callbacks(GetProcAddress(handlevorbisfilelib,'ov_test_callbacks'));
ov_test_open := Tov_test_open(GetProcAddress(handlevorbisfilelib,'ov_test_open'));

ov_bitrate := Tov_bitrate(GetProcAddress(handlevorbisfilelib,'ov_bitrate'));
ov_bitrate_instant := Tov_bitrate_instant(GetProcAddress(handlevorbisfilelib,'ov_bitrate_instant'));
ov_streams := Tov_streams(GetProcAddress(handlevorbisfilelib,'ov_streams'));
ov_seekable := Tov_seekable(GetProcAddress(handlevorbisfilelib,'ov_seekable'));
ov_serialnumber := Tov_serialnumber(GetProcAddress(handlevorbisfilelib,'ov_serialnumber'));

ov_raw_total := Tov_raw_total(GetProcAddress(handlevorbisfilelib,'ov_raw_total'));
ov_pcm_total := Tov_pcm_total(GetProcAddress(handlevorbisfilelib,'ov_pcm_total'));
ov_time_total := Tov_time_total(GetProcAddress(handlevorbisfilelib,'ov_time_total'));

ov_raw_seek := Tov_raw_seek(GetProcAddress(handlevorbisfilelib,'ov_raw_seek'));
ov_pcm_seek := Tov_pcm_seek(GetProcAddress(handlevorbisfilelib,'ov_pcm_seek'));
ov_pcm_seek_page := Tov_pcm_seek_page(GetProcAddress(handlevorbisfilelib,'ov_pcm_seek_page'));
ov_time_seek := Tov_time_seek(GetProcAddress(handlevorbisfilelib,'ov_time_seek'));
ov_time_seek_page := Tov_time_seek_page(GetProcAddress(handlevorbisfilelib,'ov_time_seek_page'));

ov_raw_seek_lap := Tov_raw_seek_lap(GetProcAddress(handlevorbisfilelib,'ov_raw_seek_lap'));
ov_pcm_seek_lap := Tov_pcm_seek_lap(GetProcAddress(handlevorbisfilelib,'ov_pcm_seek_lap'));
ov_pcm_seek_page_lap := Tov_pcm_seek_page_lap(GetProcAddress(handlevorbisfilelib,'ov_pcm_seek_page_lap'));
ov_time_seek_lap := Tov_time_seek_lap(GetProcAddress(handlevorbisfilelib,'ov_time_seek_lap'));
ov_time_seek_page_lap := Tov_time_seek_page_lap(GetProcAddress(handlevorbisfilelib,'ov_time_seek_page_lap'));

ov_raw_tell := Tov_raw_tell(GetProcAddress(handlevorbisfilelib,'ov_raw_tell'));
ov_pcm_tell := Tov_pcm_tell(GetProcAddress(handlevorbisfilelib,'ov_pcm_tell'));
ov_time_tell := Tov_time_tell(GetProcAddress(handlevorbisfilelib,'ov_time_tell'));

ov_info := Tov_info(GetProcAddress(handlevorbisfilelib,'ov_info'));
ov_comment := Tov_comment(GetProcAddress(handlevorbisfilelib,'ov_comment'));

ov_read_float := Tov_read_float(GetProcAddress(handlevorbisfilelib,'ov_read_float'));
ov_read := Tov_read(GetProcAddress(handlevorbisfilelib,'ov_read'));
ov_crosslap := Tov_crosslap(GetProcAddress(handlevorbisfilelib,'ov_crosslap'));

ov_halfrate := Tov_halfrate(GetProcAddress(handlevorbisfilelib,'ov_halfrate'));
ov_halfrate_p := Tov_halfrate_p(GetProcAddress(handlevorbisfilelib,'ov_halfrate_p'));
//--

vorbisfileinitalized:= True;
end;

procedure InitHandleVorbisEnc;
begin
if vorbisencinitalized then Exit;

handlevorbisenclib:=LoadLibrary(vorbisenclib);
if (handlevorbisenclib = 0) then
  raise EVorbisError.Create(vorbisenclib + ' not found.');
//--

vorbis_encode_init := Tvorbis_encode_init(GetProcAddress(handlevorbisenclib,'vorbis_encode_init'));
vorbis_encode_setup_managed := Tvorbis_encode_setup_managed(GetProcAddress(handlevorbisenclib,'vorbis_encode_setup_managed'));
vorbis_encode_setup_vbr := Tvorbis_encode_setup_vbr(GetProcAddress(handlevorbisenclib,'vorbis_encode_setup_vbr'));
(* quality level from 0. (lo) to 1. (hi) *)
vorbis_encode_init_vbr := Tvorbis_encode_init_vbr(GetProcAddress(handlevorbisenclib,'vorbis_encode_init_vbr'));
vorbis_encode_setup_init := Tvorbis_encode_setup_init(GetProcAddress(handlevorbisenclib,'vorbis_encode_setup_init'));
vorbis_encode_ctl := Tvorbis_encode_ctl(GetProcAddress(handlevorbisenclib,'vorbis_encode_ctl'));

vorbisencinitalized:= True;
end;

finalization

  if (handlevorbislib <> 0) then FreeLibrary(handlevorbislib);
  if (handlevorbisfilelib <> 0) then FreeLibrary(handlevorbisfilelib);
  if (handlevorbisenclib <> 0) then FreeLibrary(handlevorbisenclib);

end.

