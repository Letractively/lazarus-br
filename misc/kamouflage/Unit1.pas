unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TInfoRecord = packed record
    FileStart: integer;
    FileSize: integer;
    UncompressedSize:integer;
    OriginalFileName: string[116];
  end;

  PInfoRecord = ^TInfoRecord;
var
  Form1                  : TForm1;

function DoKamuflage(AJpegFile, ASourceFile, ADestinationFile: string): byte;
function DoDeKamuflage(ASourceFile: string; ADestinationPath: string = ''): byte;

implementation

{$R *.dfm}

procedure Compress(InStream, OutStream: TStream);
begin
  OutStream.CopyFrom(InStream, InStream.size);
end;

procedure Decompress(InStream, OutStream: TStream; UncompressedCount: integer);
begin
  OutStream.CopyFrom(InStream, InStream.size);
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
    result := 1; //ERR_IMG_NOT_EXISTS;
    exit;
  end;
  if not FileExists(ASourceFile) then
  begin
    result := 2; //ERR_SRC_FILE_NOT_EXISTS;
    exit;
  end;

  ms := TMemoryStream.create;
  Target := TFileStream.Create(ADestinationFile, fmCreate);
  Source := TFileStream.create(ASourceFile, fmOpenRead);
  try
    rec.OriginalFileName := ExtractFileName(ASourceFile);
    rec.UncompressedSize := Source.size;
    // copy image
    ms.LoadFromFile(AJpegFile);
    ms.Position := 0;
    Target.CopyFrom(ms, ms.size);
    rec.FileStart := ms.size;
    ms.clear;

    Source.Position := 0;
    Compress(Source, Target);
    rec.FileSize := Target.size - rec.FileStart;
    Target.WriteBuffer(rec, 128);

  finally
    if Assigned(Target) then Target.Free;
    if Assigned(Source) then Source.Free;
    if Assigned(ms) then ms.Free;
  end;
end;

function DoDeKamuflage(ASourceFile: string; ADestinationPath: string = ''): byte;
var
  rec                    : TInfoRecord;
  pRec                   : PInfoRecord;
  Source, Target, temp   : TFileStream;
  DestFn:string;
begin
  source := TFileStream.Create(ASourceFile, fmOpenRead);
  try
    Source.Position := Source.Size - 128;
    source.Read(rec, 128);

    temp := TFileStream.create('$tmp.dat', fmCreate);
    if ADestinationPath = '' then  DestFn:=rec.OriginalFileName else DestFn:=IncludeTrailingPathDelimiter(ADestinationPath)+rec.OriginalFileName;
    target := TFileStream.create(DestFn, fmCreate);
    try
      source.Position := rec.FileStart;
      temp.CopyFrom(source, rec.FileSize);
      temp.Position := 0;
      Decompress(temp, Target,rec.UncompressedSize);
    finally
      target.free;
      temp.free;
      DeleteFile('$tmp.dat');
    end;
  finally
    source.free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  screen.cursor := crHourGlass;
  try
  DoKamuflage('d:\test.jpg', 'd:\delphi7.zip', 'd:\zzz_Test.jpg');
  finally
  screen.cursor := crDefault;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  DoDeKamuflage('d:\zzz_Test.jpg', 'C:\');
end;

end.

