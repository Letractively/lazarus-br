program project1;

{$mode objfpc}{$H+}

uses
  sdl,
  sdl_mixer;

var
  audio_rate: integer;
  audio_format: Uint16;
  audio_channels: integer;
  audio_buffers: integer;
  loops: integer;
  wav: word;
  wave: PMix_Music;
  baudioopen, bool: boolean;
  song, error: string;
begin
  SDL_INIT(SDL_INIT_AUDIO);
  if baudioopen = True then
  begin
    writeln('Error! SDL Audio could not be initialized.');
    sdl_quit;
    readln;
    exit;
  end
  else
  begin
    writeln('stage 1- initialization');
    writeln(mix_geterror);
    readln;
    baudioopen := False;
    audio_rate := 22050;
    audio_format := AUDIO_S16SYS;
    audio_channels := MIX_DEFAULT_CHANNELS;
    audio_buffers := 4096;
    mix_openaudio(audio_rate, audio_format, audio_channels, audio_buffers);
    writeln('stage 2- set song file');
    song := 'testb.wav';
    wave := mix_loadmus('testb.wav' {normally var song});
    error := Mix_GetError;
    writeln(error);
    if wave = nil then
    begin
      writeln('Couldn''t load ', song, '.');
      sdl_quit;
      readln;
      exit;
    end;
    writeln('stage 3- play song');
    writeln(mix_geterror);
    repeat
      loops := 1;
      mix_playmusic(wave, loops);
    until bool = True;
    if wave <> nil then
    begin
      mix_freemusic(wave);
      wave := nil;
    end;
    if baudioopen then
    begin
      baudioopen := False;
      mix_closeAudio;
    end;
    writeln('stage 4- quit');
    sdl_quit;
  end;
end.
