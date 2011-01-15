unit UPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Menus, ExtCtrls, Buttons, lzRichEdit, lzRichEditTypes, LCLProc,
  LCLType, ColorBox, Process, ULocalizar, UParagrafo, USobre{$IFDEF LINUX}, UGetFontLinux{$ENDIF};

type

  { TForm1 }

  TForm1 = class(TForm)
    ColorButton1: TColorButton;
    CBFont: TComboBox;
    CBSize: TComboBox;
    FDlg: TFontDialog;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ImageList1: TImageList;
    lzRichEdit1: TlzRichEdit;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    Odlg: TOpenDialog;
    SDlg: TSaveDialog;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton2: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    ToolButton26: TToolButton;
    ToolButton27: TToolButton;
    ToolButton28: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure Button1Click(Sender: TObject);
    procedure CBFontSelect(Sender: TObject);
    procedure CBSizeChange(Sender: TObject);
    procedure ColorButton1ChangeBounds(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lzRichEdit1Change(Sender: TObject);
    procedure lzRichEdit1Click(Sender: TObject);
    procedure lzRichEdit1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem19Click(Sender: TObject);
    procedure MenuItem22Click(Sender: TObject);
    procedure MenuItem24Click(Sender: TObject);
    procedure MenuItem26Click(Sender: TObject);
    procedure MenuItem27Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure ToolButton17Click(Sender: TObject);
    procedure ToolButton18Click(Sender: TObject);
    procedure ToolButton19Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton21Click(Sender: TObject);
    procedure ToolButton22Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
  private
    { private declarations }

  protected
    { protected declarations }
    FFileName: string;
    FSetColor: boolean;
    FFontParams: TlzFontParams;
    FAlign_: TRichEdit_Align;
  protected
    { protected declarations }
    procedure SetFileName(S: string);
    procedure GetTextStatus;
  public
    { public declarations }
    property FileName: string read FFileName write SetFileName;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ToolButton13Click(Sender: TObject);
var
  S: TFileStream;
begin
  //-- Abrir
  Odlg.Title := 'Abrir...';
  Odlg.Filter := 'Rich Text (*.rtf)|*.rtf|Texto (*.txt)|*.txt';
  Odlg.Options := [ofEnableSizing, ofViewDetail, ofHideReadOnly];
  if Odlg.Execute then
  begin
    if not (FileExists(Odlg.FileName)) then
    begin
      MessageDlg('Erro ao Abrir', 'O arquivo especificado não existe.',
        mtError, [mbOK], 0);
      Exit;
    end;

    if UTF8LowerCase(ExtractFileExt(Odlg.FileName)) = '.rtf' then
      lzRichEdit1.PlainText := False
    else
      lzRichEdit1.PlainText := True;
    //--
    if not (FileIsReadOnly(Odlg.FileName)) then
      FileName := Odlg.FileName
    else
      FileName := '';
    //--
    S := TFileStream.Create(Odlg.FileName, fmOpenRead);
    lzRichEdit1.LoadFromStream(S);
    S.Free;
    //--
  end;
end;

procedure TForm1.ToolButton14Click(Sender: TObject);
var
  S: TFileStream;
begin
  if (FileName = '') then
  begin
    MenuItem7Click(Sender);
    Exit;
  end;
  //--
  S := TFileStream.Create(FileName, fmCreate);
  lzRichEdit1.SaveToStream(S);
  S.Free;
end;

procedure TForm1.ToolButton17Click(Sender: TObject);
begin
  frmLocalizar.Execute('', lzRichEdit1);
end;

procedure TForm1.ToolButton18Click(Sender: TObject);
begin
  lzRichEdit1.CutToClipboard;
end;

procedure TForm1.ToolButton19Click(Sender: TObject);
begin
  lzRichEdit1.CopyToClipboard;
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
var
  FontParams: TlzFontParams;
begin
  FontParams := DeflzFontParams;
  lzRichEdit1.GetTextAttributes(lzRichEdit1.SelStart, FontParams);
  //--
  if (fsBold in FontParams.Style) then
    FontParams.Style := FontParams.Style - [fsBold]
  else
    FontParams.Style := FontParams.Style + [fsBold];
  //--
  lzRichEdit1.SetTextAttributes(lzRichEdit1.SelStart, lzRichEdit1.SelLength, FontParams);
  //--
  GetTextStatus;
end;

procedure TForm1.ToolButton21Click(Sender: TObject);
begin
  lzRichEdit1.PasteFromClipboard;
end;

procedure TForm1.ToolButton22Click(Sender: TObject);
begin
  lzRichEdit1.Undo;
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
var
  FontParams: TlzFontParams;
begin
  FontParams := DeflzFontParams;
  lzRichEdit1.GetTextAttributes(lzRichEdit1.SelStart, FontParams);
  //--
  if (fsItalic in FontParams.Style) then
    FontParams.Style := FontParams.Style - [fsItalic]
  else
    FontParams.Style := FontParams.Style + [fsItalic];
  //--
  lzRichEdit1.SetTextAttributes(lzRichEdit1.SelStart, lzRichEdit1.SelLength, FontParams);
  //--
  GetTextStatus;
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
var
  FontParams: TlzFontParams;
begin
  FontParams := DeflzFontParams;
  lzRichEdit1.GetTextAttributes(lzRichEdit1.SelStart, FontParams);

  //--
  if (fsUnderline in FontParams.Style) then
    FontParams.Style := FontParams.Style - [fsUnderline]
  else
    FontParams.Style := FontParams.Style + [fsUnderline];
  //--
  lzRichEdit1.SetTextAttributes(lzRichEdit1.SelStart, lzRichEdit1.SelLength, FontParams);
  //--
  GetTextStatus;
end;

procedure TForm1.ToolButton6Click(Sender: TObject);
begin
  lzRichEdit1.SetAlignment(lzRichEdit1.SelStart, lzRichEdit1.SelLength, alLeft);
  GetTextStatus;
end;

procedure TForm1.ToolButton8Click(Sender: TObject);
begin
  lzRichEdit1.SetAlignment(lzRichEdit1.SelStart, lzRichEdit1.SelLength, alCenter);
  GetTextStatus;
end;

procedure TForm1.ToolButton9Click(Sender: TObject);
begin
  lzRichEdit1.SetAlignment(lzRichEdit1.SelStart, lzRichEdit1.SelLength, alRight);
  GetTextStatus;
end;

procedure TForm1.ToolButton12Click(Sender: TObject);
var
  NewProcess: TProcess;
begin
  //Chama um novo RichEdit
  NewProcess := TProcess.Create(nil);
  //--
  NewProcess.CommandLine := ParamStr(0);
  NewProcess.Options := [poNoConsole];
  NewProcess.Execute;
  NewProcess.Free;
  //--
end;

procedure TForm1.MenuItem7Click(Sender: TObject);
var
  S: TFileStream;
begin
  //--Salvar Como
  Sdlg.Title := 'Salvar Como';
  Sdlg.Filter := 'Rich Text (*.rtf)|*.rtf|Texto (*.txt)|*.txt';
  Sdlg.Options := [ofEnableSizing, ofViewDetail, ofHideReadOnly];

  if Sdlg.Execute then
  begin
    //--
    if ExtractFileExt(Sdlg.FileName) = '' then
    begin
      if (Sdlg.FilterIndex = 1) then
        Sdlg.FileName := Sdlg.FileName + '.rtf'
      else
        Sdlg.FileName := Sdlg.FileName + '.txt';
    end;
    //--
    if FileExists(Sdlg.FileName) then
    begin
      if (MessageDlg('Salvar Como', Sdlg.FileName + ' já existe. ' +
        #10 + 'deseja substituí-lo?', mtWarning, [mbYes, mbNo], 0) <> 6) then
        Exit;
      if (FileIsReadOnly(Sdlg.FileName)) then
      begin
        MessageDlg('Salvar Como', 'O arquivo ' + Sdlg.FileName +
          ' é somente leitura.',
          mtWarning, [mbOK], 0);
        MenuItem7Click(Sender);
        Exit;
      end;
    end;
    //--
    S := TFileStream.Create(Sdlg.FileName, fmCreate);
    if (UTF8LowerCase(ExtractFileExt(Sdlg.FileName)) = '.rtf') then
      lzRichEdit1.SaveToStream(S)
    else
      lzRichEdit1.Lines.SaveToStream(S);
    S.Free;
    //--
    FileName := Sdlg.FileName;
  end;
end;

procedure TForm1.ToolButton11Click(Sender: TObject);
begin

  lzRichEdit1.SetNumbering(not (lzRichEdit1.GetNumbering));
  if lzRichEdit1.GetNumbering then
    lzRichEdit1.SetOffSetIndent(lzRichEdit1.SelStart, lzRichEdit1.SelLength, 20)
  else
    lzRichEdit1.SetOffSetIndent(lzRichEdit1.SelStart, lzRichEdit1.SelLength, 0);

  GetTextStatus;
end;

procedure TForm1.lzRichEdit1Click(Sender: TObject);
begin
  GetTextStatus;
end;

procedure TForm1.ColorButton1ChangeBounds(Sender: TObject);
var
  FontParams: TlzFontParams;
begin
  if not (FSetColor) then
    Exit;
  FontParams := DeflzFontParams;
  lzRichEdit1.GetTextAttributes(lzRichEdit1.SelStart, FontParams);
  //--
  FontParams.Color := ColorButton1.ButtonColor;
  //--
  lzRichEdit1.SetTextAttributes(lzRichEdit1.SelStart, lzRichEdit1.SelLength, FontParams);
  //--
  GetTextStatus;

end;

procedure TForm1.CBFontSelect(Sender: TObject);
var
  FontParams: TlzFontParams;
begin
  FontParams := DeflzFontParams;
  lzRichEdit1.GetTextAttributes(lzRichEdit1.SelStart, FontParams);
  //--
  FontParams.Name := CBfont.Text;
  //--
  lzRichEdit1.SetTextAttributes(lzRichEdit1.SelStart, lzRichEdit1.SelLength, FontParams);
  //--
  GetTextStatus;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  FontParams: TlzFontParams;
begin
  FontParams := DeflzFontParams;
  lzRichEdit1.GetTextAttributes(lzRichEdit1.SelStart - 1, FontParams);
  ShowMessage(FontParams.Name);
end;

procedure TForm1.CBSizeChange(Sender: TObject);
var
  FontParams: TlzFontParams;
  FontSize: integer;
begin
  if TryStrToInt(CBSize.Text, FontSize) then
  begin
    FontParams := DeflzFontParams;
    lzRichEdit1.GetTextAttributes(lzRichEdit1.SelStart, FontParams);
    //--
    FontParams.Size := FontSize;
    //--
    lzRichEdit1.SetTextAttributes(lzRichEdit1.SelStart, lzRichEdit1.SelLength,
      FontParams);
    //--
  end
  else
    MessageDlg('Formatar', 'Número inválido', mtInformation, [mbOK], 0);

  GetTextStatus;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if MessageDlg('Salvar', 'Deseja Salvar o documento?', mtConfirmation,
    [mbYes, mbNo], 0) = 6 then
    ToolButton14Click(Sender);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FSetColor := True;
  {$IFDEF Linux}
  lzRichEdit1.NumberingParams.NChar := UnicodeToUTF8($B7);
  lzRichEdit1.NumberingParams.FontParams.Name := 'lzRichSymbol';
  lzRichEdit1.NumberingParams.FontParams.Size := 12;
  lzRichEdit1.NumberingParams.FontParams.Color := clBlack;
  lzRichEdit1.NumberingParams.FontParams.Style := [];
  ToolButton22.Enabled := False;
  MenuItem13.Enabled := False;
  {$ENDIF}
end;

procedure TForm1.FormShow(Sender: TObject);
var
  sFont: TFont;
  I, I2, I3: integer;
  {$IFDEF Linux}
  FontList: TStringList;
{$ENDIF}
begin
  {$IFDEF Windows}
  CBFont.Items.Assign(Screen.Fonts);
{$ENDIF}

{$IFDEF Linux}
  FontList := TStringList.Create;
  GetFontList(FontList);
  CBFont.Items.Assign(FontList);
  FontList.Free;
{$ENDIF}

  I2 := 1;
  I3 := 7;
  for I := 0 to 15 do
  begin
    if (I = 5) then
      I2 := 2;
    if (I = 13) then
      I2 := 8;
    if (I = 14) then
      I2 := 12;
    if (I = 15) then
      I2 := 24;

    I3 := I3 + I2;
    CBSize.Items.Add(IntToStr(I3));
  end;
  lzRichEdit1.SetFocus;
  GetTextStatus;
end;

procedure TForm1.lzRichEdit1Change(Sender: TObject);
begin
  {$IFDEF Linux}
  GetTextStatus;
  {$ENDIF}
end;

procedure TForm1.lzRichEdit1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  GetTextStatus;
end;

procedure TForm1.MenuItem11Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.MenuItem19Click(Sender: TObject);
begin
  lzRichEdit1.SelectAll;
end;

procedure TForm1.MenuItem22Click(Sender: TObject);
var
  P: TPicture;
  //I: integer;
  //S: string;
  //U: TUTF8Char;
begin
  //-- Inserir Imagem
  Odlg.Title := 'Abrir...';
  Odlg.Filter :=
    'Imagens (*.bmp;*.xpm;*.png;*.ico;*.jpg;*.jpeg)|*.bmp;*.xpm;*.png;*.ico;*.jpg;*.jpeg';
  Odlg.Options := [ofEnableSizing, ofViewDetail, ofHideReadOnly];

  if Odlg.Execute then
  begin
    P := TPicture.Create;
    P.LoadFromFile(Odlg.FileName);
      {$IFDEF Windows}
    P.Bitmap.SaveToClipboardFormat(2);
    lzRichEdit1.PasteFromClipboard;
      {$ENDIF}
      {$IFDEF Linux}
    lzRichEdit1.InsertImage(lzRichEdit1.SelStart, P);
      {$ENDIF}
    P.Free;
  end;
  //FFFC
end;

procedure TForm1.MenuItem24Click(Sender: TObject);
var
  FontParams: TlzFontParams;
begin
  FDlg.Title := 'Fonte';
  lzRichEdit1.GetTextAttributes(lzRichEdit1.SelStart, FontParams);
  //--
  FDlg.Font.Name := FontParams.Name;
  FDlg.Font.Size := FontParams.Size;
  FDlg.Font.Color := FontParams.Color;
  FDlg.Font.Style := FontParams.Style;

  if FDlg.Execute then
  begin
    lzRichEdit1.SetTextAttributes(lzRichEdit1.SelStart,
      lzRichEdit1.SelLength, FDlg.Font);
  end;
end;

procedure TForm1.MenuItem26Click(Sender: TObject);
begin
  frmParagrafo.Execute(lzRichEdit1);
end;

procedure TForm1.MenuItem27Click(Sender: TObject);
begin
  frmSobre.Show;
end;

procedure TForm1.SetFileName(S: string);
begin
  FFileName := S;
end;

procedure TForm1.GetTextStatus;
begin
  FFontParams := DeflzFontParams;
  lzRichEdit1.GetTextAttributes(lzRichEdit1.SelStart, FFontParams);
  //--
  CBFont.Caption := FFontParams.Name;
  CBSize.Text := IntToStr(FFontParams.Size);
  FSetColor := False;
  ColorButton1.ButtonColor := TColor(FFontParams.Color);
  FSetColor := True;
  ToolButton1.Down := (fsBold in FFontParams.Style);
  ToolButton2.Down := (fsItalic in FFontParams.Style);
  ToolButton3.Down := (fsUnderline in FFontParams.Style);
  //--
  lzRichEdit1.GetAlignment(lzRichEdit1.SelStart, FAlign_);

  ToolButton6.Down := (alLeft = FAlign_);
  ToolButton8.Down := (alCenter = FAlign_);
  ToolButton9.Down := (alRight = FAlign_);
  //--
  ToolButton11.Down := lzRichEdit1.GetNumbering;
  MenuItem25.Checked := lzRichEdit1.GetNumbering;
end;

end.

