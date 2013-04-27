program project1;

{$mode objfpc}{$H+}
{$DEFINE USE_DYNAMIC_BASS}

uses
  lazdynamic_bass,
  SysUtils,
  Classes;

  procedure Error(msg: string);
  begin
    WriteLn(msg + #13#10 + '(Error code: ' + IntToStr(BASS_ErrorGetCode()) + ')');
  end;

var
  f, fn: PChar;
  i, strc: Integer;
  mp3s: TStringList;
  strs: array[0..128] of HSTREAM;
begin
  mp3s := TStringList.Create;
  try
{$IFDEF WIN32}
    Load_BASSDLL('bass.dll');
{$ELSE}
    Load_BASSDLL(GetCurrentDir + '/libbass.so');
{$ENDIF}

    // stream count
    strc := 0;

    // check the correct BASS was loaded
    if Hi(BASS_GetVersion()) <> BASSVERSION then
    begin
      WriteLn('An incorrect version of BASS.DLL was loaded.');
      Halt;
    end;

    WriteLn('Using BASS library version: ', BASSVERSIONTEXT);

    // Initialize audio - default device, 44100hz, stereo, 16 bits
    if not BASS_Init(-1, 44100, 0, 0, nil) then
      Error('Error initializing audio.');

    fn := 'blew.mp3';
    f := PChar(fn);
    strs[strc] := BASS_StreamCreateFile(False, f, 0, 0, 0);
    if strs[strc] <> 0 then
    begin
      mp3s.Add(fn);
      Inc(strc);
    end
    else
      Error('Error creating stream.');

    // Play the stream (continuing from current position)
    for i := 0 to Pred(mp3s.Count) do
      if not BASS_ChannelPlay(strs[i], False) then
        Error('Error playing stream.');

    // To stop current stream just use: BASS_ChannelStop(strs[i])
    // or to restart, just use BASS_ChannelPlay(strs[i], True)

    WriteLn('Playing: ', fn);
    ReadLn;
  finally
    mp3s.Free;

    // Free stream
    if strc > 0 then
      for i := 0 to Pred(strc) do
        BASS_StreamFree(strs[i]);

    // Close BASS
    BASS_Free();

    // release the bass library
    Unload_BASSDLL();
  end;
end.
