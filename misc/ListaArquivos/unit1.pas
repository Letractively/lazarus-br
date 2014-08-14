unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, StdCtrls, dateutils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

// http://stackoverflow.com/questions/6546105/how-to-search-a-file-through-all-the-subdirectories-in-delphi
procedure FindFiles(AFiles: TStrings; const ADirectory, AMask: string);
var
  VFolder: string;
  I, VLast: Integer;
  VSearchRec: TSearchRec;
  VFolders: array of string;
  d: TDateTime;
begin
  SetLength(VFolders, 1);
  VFolders[0] := ADirectory;
  I := 0;
  while I < Length(VFolders) do
  begin
    VFolder := IncludeTrailingBackslash(VFolders[I]);
    Inc(I);
    // collect child folders first
    if FindFirst(VFolder + '*.*', faDirectory, VSearchRec) = 0 then
    begin
      repeat
        if not ((VSearchRec.Name = '.') or (VSearchRec.Name = '..')) then
        begin
          VLast := Length(VFolders);
          SetLength(VFolders, Succ(VLast));
          VFolders[VLast] := VFolder + VSearchRec.Name;
        end;
      until FindNext(VSearchRec) <> 0;
      FindClose(VSearchRec);
    end;
    // collect files next
    if FindFirst(VFolder + AMask, faAnyFile - faDirectory, VSearchRec) = 0 then
    begin
      AFiles.BeginUpdate;
      try
        repeat
          if not ((VSearchRec.Attr and faDirectory) = faDirectory) then
            AFiles.Add(VFolder + VSearchRec.Name);
        until FindNext(VSearchRec) <> 0;
      finally
        AFiles.EndUpdate;
      end;
      FindClose(VSearchRec);
    end;
  end;
end;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  ListBox1.Clear;
  FindFiles(ListBox1.Items, 'C:\lazarus\components', '*.xml');
end;

end.

