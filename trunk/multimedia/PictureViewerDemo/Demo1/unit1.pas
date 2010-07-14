unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  LResources, Forms, StdCtrls, ExtCtrls, EditBtn, FileCtrl;

type

  { TForm1 }

  TForm1 = class(TForm)
    DirectoryEdit1: TDirectoryEdit;
    Edit1: TEdit;
    FileListBox1: TFileListBox;
    Image1: TImage;
    procedure DirectoryEdit1Change(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

const
  {$ifdef linux}
  chBar = '/';
  {$else}
    {$ifdef win32}
  chBar = '\';
    {$endif}
  {$endif}

implementation

{ TForm1 }

procedure TForm1.FileListBox1Click(Sender: TObject);
begin
  if FileListBox1.ItemIndex > -1 then
  begin
    Edit1.Text := FileListBox1.Directory + chBar +
      FileListBox1.Items.Strings[FileListBox1.ItemIndex];
    Image1.Picture.LoadFromFile(Edit1.Text);
  end;
end;

procedure TForm1.DirectoryEdit1Change(Sender: TObject);
begin
  FileListBox1.Directory := DirectoryEdit1.Text;
end;

initialization
  {$I unit1.lrs}

end.

