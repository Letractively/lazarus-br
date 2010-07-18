// program is published under GNU/GPL license
//
// author: Emil Beli, ebeli@varnus.com
//
unit unkamguiform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs,unengine, ExtCtrls, StdCtrls,
  Buttons, unGlobal;

type

  { TfrmKamguiform }

  TfrmKamguiform = class(TForm)
    BitBtn1: TBitBtn;
    btnBrowseDecmflgPath: TButton;
    btnBrowseCmflgImg1: TButton;
    btnBrowseCmflgFile: TButton;
    btnBrowseFtc: TButton;
    btnBrowseCmflgImg: TButton;
    btnExecCamouflage: TButton;
    btnExecCamouflage1: TButton;
    edtFtc: TEdit;
    edtImgCmflg: TEdit;
    edtDestCmflg: TEdit;
    edtSourceCmflg: TEdit;
    edtDestDecamouflage: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    OpenDialogImages: TOpenDialog;
    OpenDialogAllFiles: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    procedure BitBtn1Click(Sender: TObject);
    procedure btnBrowseCmflgFileClick(Sender: TObject);
    procedure btnBrowseCmflgImg1Click(Sender: TObject);
    procedure btnBrowseCmflgImgClick(Sender: TObject);
    procedure btnBrowseDecmflgPathClick(Sender: TObject);
    procedure btnBrowseFtcClick(Sender: TObject);
    procedure btnExecCamouflage1Click(Sender: TObject);
    procedure btnExecCamouflageClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FSettingsFile, FSettingsPath :string;
    FSettingsList:TStringList;
  public
    { public declarations }
  end; 

var
  frmKamguiform: TfrmKamguiform;

implementation

{$R *.lfm}

{ TfrmKamguiform }

procedure RaiseResult(ARes:byte);
begin
   if ARes = ERR_IMG_NOT_EXISTS then raise Exception.Create('Image file not exists');
   if ARes = ERR_SRC_FILE_NOT_EXISTS then raise Exception.Create('Source file not exists');
   if ARes = ERR_DEST_FILE_EXISTS then raise Exception.Create('Destination file not exists');
   if ARes = ERR_NOT_CAMOUFLAGED then raise Exception.Create('Source file is not valid camouflaged file, or corrupted');
   if ARes = ERR_FILE_CORRUPTED then raise Exception.Create('File corrupted: Could not decompress the file');
end;
      
procedure TfrmKamguiform.BitBtn1Click(Sender: TObject);
begin
  FSettingsList.Clear;
  FSettingsList.Add('CAMOUFLAGE_IMAGE=' + edtImgCmflg.text);
  FSettingsList.Add('CAMOUFLAGE_RESULT=' + edtDestCmflg.text);
  FSettingsList.Add('PATH_TO_EXTRACT=' + edtDestDecamouflage.text);
  close;
end;

procedure TfrmKamguiform.btnBrowseCmflgFileClick(Sender: TObject);
begin
 OpenDialogImages.execute;
 if OpenDialogImages.FileName <> '' then  edtSourceCmflg.text := OpenDialogImages.FileName;
end;

procedure TfrmKamguiform.btnBrowseCmflgImg1Click(Sender: TObject);
begin
 OpenDialogImages.execute;
 if OpenDialogImages.FileName <> '' then  edtDestCmflg.text := OpenDialogImages.FileName;
 if ((edtImgCmflg.text <> '') and (edtDestCmflg.text <> '')) then
  if not SameText(ExtractFileExt(edtImgCmflg.text),ExtractFileExt(edtDestCmflg.text)) then
     MessageDlg('Different file types','Extensions of Image to camouflage and resulting camouflaged file are different.'+#13#10+
     'Both files should be of a same type',mtWarning,[mbOK],0);
 
end;

procedure TfrmKamguiform.btnBrowseCmflgImgClick(Sender: TObject);
begin
  OpenDialogImages.execute;
  if OpenDialogImages.FileName <> '' then  edtImgCmflg.text := OpenDialogImages.FileName;
   if ((edtImgCmflg.text <> '') and (edtDestCmflg.text <> '')) then
  if not SameText(ExtractFileExt(edtImgCmflg.text),ExtractFileExt(edtDestCmflg.text)) then
     MessageDlg('Different file types','Extensions of Image to camouflage and resulting camouflaged file are different.'+#13#10+
     'Both files should be of a same type',mtWarning,[mbOK],0);
end;

procedure TfrmKamguiform.btnBrowseDecmflgPathClick(Sender: TObject);
begin
  SelectDirectoryDialog1.Execute;
  if SelectDirectoryDialog1.FileName <> '' then  edtDestDecamouflage.text :=  SelectDirectoryDialog1.FileName;
end;

procedure TfrmKamguiform.btnBrowseFtcClick(Sender: TObject);
begin
  OpenDialogAllFiles.execute;
  if OpenDialogAllFiles.FileName <> '' then  edtFtc.text := OpenDialogAllFiles.FileName;
end;

procedure TfrmKamguiform.btnExecCamouflage1Click(Sender: TObject);
var
  res : byte;
begin
  if not FileExists(edtSourceCmflg.text) then raise Exception.Create('Selected Camouflaged file does not exists');
  if ((edtDestDecamouflage.text <> '')  and (not DirectoryExists(edtDestDecamouflage.text))) then
     raise Exception.Create('Decamouflage directory does not exists');
  Screen.Cursor := crHourGlass;
  try
    btnExecCamouflage1.Enabled := false;
    res := DoDeKamuflage(edtSourceCmflg.text,edtDestDecamouflage.text);
    if res <> 0 then RaiseResult(res);
  finally
   Screen.Cursor := crDefault;
   btnExecCamouflage1.Enabled := true;
  end;
end;

procedure TfrmKamguiform.btnExecCamouflageClick(Sender: TObject);
var
  res : byte;
begin
  if not FileExists(edtFtc.text) then raise Exception.Create('File to camouflage must be selected');
  if not FileExists(edtImgCmflg.text) then raise Exception.Create('Image for camouflaging must be selected');
  if edtDestCmflg.text = '' then raise Exception.Create('Resulting camouflaged file must be selected');
  if not DirectoryExists(ExtractFilePath(edtDestCmflg.text)) then raise Exception.Create('Directory for resulting camouflaged file does not exists');
  Screen.Cursor := crHourGlass;
  try
    btnExecCamouflage.Enabled := false;
    res := DoKamuflage(edtImgCmflg.text,edtFtc.text,edtDestCmflg.text);
    if res > 0 then RaiseResult(res);
  finally
   Screen.Cursor := crDefault;
   btnExecCamouflage.Enabled := true;
  end;
end;

procedure TfrmKamguiform.FormCreate(Sender: TObject);
var
  DelimSearch, DelimReplace:string;
  gde:integer;
begin
 {$IFDEF Win32}
   FSettingsPath := IncludeTrailingPathDelimiter(GetEnvironmentVariable('APPDATA'))+'.varnus\';
   DelimSearch:='\\';
   DelimReplace:='\';
 {$ELSE}
   FSettingsPath := IncludeTrailingPathDelimiter(GetEnvironmentVariable('HOME'))+'.varnus/';
   DelimSearch:='//';
   DelimReplace:='/';
 {$ENDIF}
 FSettingsFile := FSettingsPath+'kamouflage.conf';
 //necessary due to bug in GetEnvironmentVariable or in evaluator
 while Pos(DelimSearch,FSettingsFile) > 0 do
 begin
   gde := Pos(DelimSearch,FSettingsFile);
   delete(FSettingsFile,gde,2);
   insert(DelimReplace,FSettingsFile,gde);
 end;
 
 FSettingsList := TStringList.create;
 if FileExists(FSettingsFile) then
 begin
   FSettingsList.LoadFromFile(FSettingsFile);
   edtImgCmflg.text := FSettingsList.Values['CAMOUFLAGE_IMAGE'];
   edtDestCmflg.text := FSettingsList.Values['CAMOUFLAGE_RESULT'];
   edtDestDecamouflage.text := FSettingsList.Values['PATH_TO_EXTRACT'];
 end;
 frmKamguiform.Caption := frmKamguiform.Caption+' '+PROGRAM_VERSION_STR;
end;

procedure TfrmKamguiform.FormDestroy(Sender: TObject);
begin
  if not DirectoryExists(FSettingsPath) then ForceDirectories(FSettingsPath);

  FSettingsList.SaveToFile(FSettingsFile);
  if assigned(FSettingsList) then FSettingsList.free;
end;

procedure TfrmKamguiform.FormShow(Sender: TObject);
begin
  edtDestDecamouflage.text := ExtractFilePath(Application.Exename);
end;

end.
