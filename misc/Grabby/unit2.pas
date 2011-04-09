unit Unit2;

{$mode objfpc}

interface

uses
  Forms, SysUtils, StdCtrls, ComCtrls, EditBtn, Spin, XMLPropStorage, FileUtil,
  Dialogs;

type

  { TFrmOptions }

  TFrmOptions = class(TForm)
    btnhelp: TButton;
    BtnOK: TButton;
    cbofiletype: tcombobox;
    label1: tlabel;
    label2: tlabel;
    label5: tlabel;
    label7: tlabel;
    lbldirectory: tlabel;
    lblquality: tlabel;
    rbautosave: tradiobutton;
    RBAutosaveOpen: TRadioButton;
    rbclipboard: tradiobutton;
    spinnumber: tspinedit;
    tbquality: ttrackbar;
    txtdirectory: tdirectoryedit;
    txtfilename: tedit;
    xmlpropstorage1: txmlpropstorage;
    procedure btnhelpclick(Sender: TObject);
    procedure btnokclick(Sender: TObject);
    procedure cbofiletypechange(Sender: TObject);
    procedure formcreate(Sender: TObject);
    procedure rbautosavechange(Sender: TObject);
    procedure RBAutosaveOpenChange(Sender: TObject);
    procedure rbclipboardchange(Sender: TObject);
    procedure tbqualitychange(Sender: TObject);
  public
    filetype: string;
    stateoptions: string;
    option: string;
    frmstate: Integer;
  end;

var
  FrmOptions: TFrmOptions;

implementation

{$R *.lfm}

{ TFrmOptions }

procedure tfrmoptions.cbofiletypechange(Sender: TObject);
begin
  if CboFiletype.Text = 'JPEG File' then
  begin
    TBQuality.Enabled := True;
    filetype := '.jpg';
  end
  else if CboFiletype.Text = 'BMP File' then
  begin
    TBQuality.Enabled := False;
    filetype := '.bmp';
  end
  else if CboFiletype.Text = 'PNG File' then
  begin
    TBQuality.Enabled := False;
    filetype := '.png';
  end;
end;

procedure tfrmoptions.formcreate(Sender: TObject);
begin
  XMLPropStorage1.Restore;

  filetype := XMLPropStorage1.ReadString('Filetype', '.jpg');
  option := XMLPropStorage1.ReadString('Option', 'clip');
  frmstate := XMLPropStorage1.ReadInteger('WinState', 1);

  if option = 'clip' then
    RBClipboard.Checked := True
  else
  if option = 'file' then
    RBAutosave.Checked := True
  else
    RBAutosaveOpen.Checked := True;

  if filetype = '.jpg' then
    CboFiletype.Text := 'JPEG File'
  else if filetype = '.bmp' then
    CboFiletype.Text := 'BMP File'
  else if filetype = '.png' then
    CboFiletype.Text := 'PNG File';
  CboFiletypeChange(self);

  if DirectoryExistsUTF8(XMLPropStorage1.ReadString('Directory', '')) = True then
    TxtDirectory.Text := XMLPropStorage1.ReadString('Directory', '');
  TxtFilename.Text := XMLPropStorage1.ReadString('Filename', 'grab_#date#_#number#');
  SpinNumber.Value := XMLPropStorage1.ReadInteger('Number', 1);
  TBQuality.Position := XMLPropStorage1.ReadInteger('Quality', 90);
  TBQualityChange(self);
end;

procedure tfrmoptions.btnhelpclick(Sender: TObject);
begin
  ShowMessage('You can currently use the following variables:' +
    #13#10 + '#date# will be replaced by the current date in the format aaaammjj' +
    #13#10 + '#time# will be replaced by the current time in hhmmss' +
    #13#10 + '#number# will be replaced by the value of the current number,' +
    #13#10 + ' and automatically increased at each image');
end;

procedure tfrmoptions.btnokclick(Sender: TObject);
begin
  FrmOptions.Hide;
end;

procedure tfrmoptions.rbautosavechange(Sender: TObject);
begin
  if RBAutosave.Checked = True then
    option := 'file';
end;

procedure TFrmOptions.RBAutosaveOpenChange(Sender: TObject);
begin
  if RBAutosaveOpen.Checked = True then
    option := 'fileopen';
end;

procedure tfrmoptions.rbclipboardchange(Sender: TObject);
begin
  if RBClipboard.Checked = True then
    option := 'clip';
end;

procedure tfrmoptions.tbqualitychange(Sender: TObject);
begin
  LblQuality.Caption := IntToStr(TBQuality.Position) + '%';
end;

end.

