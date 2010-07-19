unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, Controls, Menus, ActnList, StdActns, ComCtrls, ExtCtrls,
  ExtDlgs;

type

  { TMainForm }

  TMainForm = class(TForm)
    AboutAction: TAction;
    OpenAction: TAction;
    MainActionList: TActionList;
    ExitAction: TFileExit;
    MainImage: TImage;
    MainImageList: TImageList;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    N1: TMenuItem;
    HelpMenuItem: TMenuItem;
    MainOpenPictureDialog: TOpenPictureDialog;
    MainScrollBox: TScrollBox;
    AboutManuItem: TMenuItem;
    ExitMenuItem: TMenuItem;
    OpenMenuItem: TMenuItem;
    MainStatusBar: TStatusBar;
    procedure AboutActionExecute(Sender: TObject);
    procedure OpenActionExecute(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
    procedure FormShow(Sender: TObject);
  public
    procedure LoadPicture(const AFileName: string);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

uses
  AboutFrm;

procedure TMainForm.LoadPicture(const AFileName: string);
begin
  MainImage.Picture.Clear;
  MainImage.Picture.LoadFromFile(AFileName);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  WindowState := wsMaximized;
end;

procedure TMainForm.OpenActionExecute(Sender: TObject);
begin
  if MainOpenPictureDialog.Execute then
    LoadPicture(MainOpenPictureDialog.FileName);
end;

procedure TMainForm.AboutActionExecute(Sender: TObject);
begin
  TAboutForm.Execute;
end;

procedure TMainForm.FormDropFiles(Sender: TObject; const FileNames: array of string);
begin
  LoadPicture(FileNames[0]);
end;

end.

