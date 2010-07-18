unit unEngine;

{$MODE objfpc}{$H+}

interface

uses
  Classes, SysUtils, unglobal;

type

  TInfoRecord = packed record
    VerificationByte1        : byte;
    FileStart                : cardinal;
    FileSize                 : cardinal;
    VerificationByte2        : byte;
    UncompressedSize         : integer;
    VerificationByte3        : byte;
    OriginalFileName         : string[113];
  end;

var
  GLOBAL_OverWrite       : boolean;


function DoKamuflage(AJpegFile, ASourceFile, ADestinationFile: string): byte;
function DoDeKamuflage(ASourceFile: string; ADestinationPath: string = ''): byte;
function IsCamouflaged(ASourceFile:string):boolean;

implementation

function IsCamouflaged(ASourceFile:string):boolean;
var
   fs  : TFileStream;
   rec : TInfoRecord;
begin
  result := false;
  rec.VerificationByte1 := 0; //just to avoid initialization warning
  if not FileExists(ASourceFile) then exit;
  fs := TFileStream.Create(ASourceFile,fmOpenRead);
  try
     fs.Position := fs.Size - 128;
     fs.Read(rec, 128);
     if ((rec.VerificationByte1 = 104) and  (rec.VerificationByte2 = 75) and (rec.VerificationByte3 = 9)) then result := true;
  finally
    fs.free;
  end;
end;


function DoKamuflage(AJpegFile, ASourceFile, ADestinationFile: string): byte;
var
  rec                    : TInfoRecord;
  Target                 : TFileStream;
  Source                 : TFileStream;
  Ms                     : TMemoryStream;
begin
  Result := 0;

  if not FileExists(AJpegFile) then
  begin
    result := ERR_IMG_NOT_EXISTS;
    exit;
  end;
  if not FileExists(ASourceFile) then
  begin
    result := ERR_SRC_FILE_NOT_EXISTS;
    exit;
  end;

  ms := TMemoryStream.create;
  Target := TFileStream.Create(ADestinationFile, fmCreate);
  Source := TFileStream.create(ASourceFile, fmOpenRead);
  try
    rec.OriginalFileName := ExtractFileName(ASourceFile);
    rec.UncompressedSize := Cardinal(Source.size);
    rec.VerificationByte1 := 104;
    rec.VerificationByte2 := 75;
    rec.VerificationByte3 := 9;
    // copy image
    ms.LoadFromFile(AJpegFile);
    ms.Position := 0;
    Target.CopyFrom(ms, ms.size);
    rec.FileStart := Cardinal(ms.size);
    ms.clear;
    Source.Position := 0;
    Target.CopyFrom(Source,Source.size);
    if (Target.size - rec.FileStart) < 0 then
    begin
     result := ERR_FILE_CORRUPTED;
     exit;
    end;
    rec.FileSize := Cardinal(Target.size - rec.FileStart);
    Target.WriteBuffer(rec, 128);
  finally
    if Assigned(Target) then Target.Free;
    if Assigned(Source) then Source.Free;
    if Assigned(ms) then ms.Free;
    if ((result = ERR_FILE_CORRUPTED) and FileExists(ADestinationFile)) then DeleteFile(ADestinationFile);
  end;
end;

function DoDeKamuflage(ASourceFile: string; ADestinationPath: string = ''): byte;
var
  rec             : TInfoRecord;
  Source, Target  : TFileStream;
  DestFn          : string;
begin
  rec.VerificationByte1 := 0; //just to avoid initialization warning
  if not FileExists(ASourceFile) then
  begin
    result := ERR_SRC_FILE_NOT_EXISTS;
    exit;
  end;

  if not IsCamouflaged(ASourceFile) then
  begin
    result := ERR_NOT_CAMOUFLAGED;
    exit;
  end;
  
  source := TFileStream.Create(ASourceFile, fmOpenRead);
  try
    Source.Position := Source.Size - 128;
    source.Read(rec, 128);

    if ADestinationPath = '' then DestFn := rec.OriginalFileName else DestFn := IncludeTrailingPathDelimiter(ADestinationPath) + rec.OriginalFileName;
    Target := TFileStream.Create(DestFn,fmCreate);
    try
      try
        source.Position := rec.FileStart;
        Target.CopyFrom(source, rec.FileSize);
      except
        result := ERR_FILE_CORRUPTED;
        exit;
      end;
    finally
      target.free;
    end;
  finally
    source.free;
  end;
end;

initialization
  GLOBAL_OverWrite := false;

end.

