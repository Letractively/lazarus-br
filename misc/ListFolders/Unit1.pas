unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  FileUtil, Forms, Dialogs, ShellCtrls, StdCtrls, Controls, Classes;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ImageList1: TImageList;
    ListBox1: TListBox;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure ListBox1MeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);
  end;

var
  Form1: TForm1; 

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  with TSelectDirectoryDialog.Create(nil) do
  try
    if Execute then
    begin
      ListBox1.Items.BeginUpdate;
      TCustomShellTreeView.GetFilesInDir(FileName, AllDirectoryEntriesMask, [otFolders],
        ListBox1.Items);
      ListBox1.Items.EndUpdate;
    end;
  finally
    Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ListBox1.Style := lbOwnerDrawVariable;
end;

procedure TForm1.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
var
  CenterText: Integer;
begin
  ListBox1.Canvas.FillRect(ARect);
  ImageList1.Draw(ListBox1.Canvas, ARect.Left + 4, ARect.Top + 4, 0);
  CenterText := (ARect.Bottom - ARect.Top - ListBox1.Canvas.TextHeight(Text)) div 2;
  ListBox1.Canvas.TextOut(ARect.Left + ImageList1.Width + 8 , ARect.Top + CenterText,
    ListBox1.Items.Strings[index]);
end;

procedure TForm1.ListBox1MeasureItem(Control: TWinControl; Index: Integer;
  var AHeight: Integer);
begin
  AHeight := ImageList1.Height + 4;
end;

end.
