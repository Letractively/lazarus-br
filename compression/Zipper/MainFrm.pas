unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, Buttons, ExtCtrls, ComCtrls, Zipper;

type

  { TMainForm }

  TMainForm = class(TForm)
    FileOpenDialog: TOpenDialog;
    CompressBitBtn: TBitBtn;
    CompressProgressBar: TProgressBar;
    FolderSelectDirectoryDialog: TSelectDirectoryDialog;
    UncompressBitBtnBitBtn: TBitBtn;
    TopPanel: TPanel;
    procedure CompressBitBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UncompressBitBtnBitBtnClick(Sender: TObject);
  public
    FZip: TZipper;
    FUnZip: TUnZipper;
    procedure OutputMsg;
    procedure OnCompressProgress(Sender: TObject; const Pct: Double);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FZip := TZipper.Create;
  FUnZip := TUnZipper.Create;
  FZip.OnProgress := @OnCompressProgress;
  FUnZip.OnProgress := FZip.OnProgress;
end;

procedure TMainForm.CompressBitBtnClick(Sender: TObject);
var
  VFileStream: TFileStream;
begin
  if FileOpenDialog.Execute then
  begin
    OutputMsg;
    if FolderSelectDirectoryDialog.Execute then
    begin
      VFileStream := TFileStream.Create(FileOpenDialog.FileName, fmOpenRead);
      try
        CompressProgressBar.Position := 0;
        FZip.FileName := FolderSelectDirectoryDialog.FileName + PathDelim +
          ExtractFileName(ChangeFileExt(FileOpenDialog.FileName, '.zip'));
        FZip.Entries.AddFileEntry(VFileStream, ExtractFileName(FileOpenDialog.FileName));
        FZip.ZipAllFiles;
      finally
        FZip.Entries[0].Stream.Free;
      end;
    end;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FZip.Free;
  FUnZip.Free;
end;

procedure TMainForm.UncompressBitBtnBitBtnClick(Sender: TObject);
begin
  if FileOpenDialog.Execute then
  begin
    OutputMsg;
    if FolderSelectDirectoryDialog.Execute then
    begin
      CompressProgressBar.Position := 0;
      FUnZip.FileName := FileOpenDialog.FileName;
      FUnZip.OutputPath := FolderSelectDirectoryDialog.FileName;
      FUnZip.UnZipAllFiles;
    end;
  end;
end;

procedure TMainForm.OutputMsg;
begin
  ShowMessage('Select output folder ...');
end;

procedure TMainForm.OnCompressProgress(Sender: TObject; const Pct: Double);
begin
  CompressProgressBar.Position := Round(Pct);
end;

end.

