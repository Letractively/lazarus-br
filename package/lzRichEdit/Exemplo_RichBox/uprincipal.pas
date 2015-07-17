{
lzRichEdit

Copyright (C) 2010 Elson Junio elsonjunio@yahoo.com.br
                   Additions by Antônio Galvão

This is the file COPYING.modifiedLGPL, it applies to several units in the
Lazarus sources distributed by members of the Lazarus Development Team.
All files contains headers showing the appropriate license. See there if this
modification can be applied.

These files are distributed under the Library GNU General Public License
(see the file COPYING.LGPL) with the following modification:

As a special exception, the copyright holders of this library give you
permission to link this library with independent modules to produce an
executable, regardless of the license terms of these independent modules,
and to copy and distribute the resulting executable under terms of your choice,
provided that you also meet, for each linked independent module, the terms
and conditions of the license of that module. An independent module is a
module which is not derived from or based on this library. If you modify this
library, you may extend this exception to your version of the library, but
you are not obligated to do so. If you do not wish to do so, delete this
exception statement from your version.


If you didn't receive a copy of the file COPYING.LGPL, contact:
      Free Software Foundation, Inc.,
      675 Mass Ave
      Cambridge, MA  02139
      USA
}

{ Image conversion from WMF to PNG is made by Convert.exe from ImageMagick
  which is distribuited under the Apache 2.0 license.

  You can use Apache 2.0 licensed source code in your project as long as you
  include the copy of the license in your distribution and provide attribution
  in an applicable way in your distribution. }

unit UPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, UTF8Process, PrintersDlgs, Forms,
  Controls, Graphics, Dialogs, StdCtrls, ComCtrls, Menus, ExtCtrls, Buttons,
  LCLProc, LCLType, ColorBox, Process, ULocalizar, UParagrafo, USobre, RichBox
  {$IFDEF LINUX}, GTKTextImage, UGetFontLinux {$ENDIF} {$IFDEF WINDOWS},
  RichOleBox, RichOle, Windows {$ENDIF}, RTF2HTML, CLIPBRD, RegExpr;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnSend :TButton;
    cbForeColor: TColorButton;
    CBFont: TComboBox;
    CBSize: TComboBox;
    cbBackColor :TColorButton;
    FDlg: TFontDialog;
    FindDialog :TFindDialog;
    GroupBox1: TGroupBox;
    ImageList1: TImageList;
    lzRichEdit1: TlzRichEdit;
    lzRichEdit2 :TlzRichEdit;
    MainMenu: TMainMenu;
    MenuItem1 :TMenuItem;
    MenuItem5 :TMenuItem;
    miScrollLinePlus5 :TMenuItem;
    miScrollLineMinus5 :TMenuItem;
    miZoom100 :TMenuItem;
    miZoom300 :TMenuItem;
    miZoom500 :TMenuItem;
    miZoom150 :TMenuItem;
    miZoom10 :TMenuItem;
    MenuItem2 :TMenuItem;
    miZoom25 :TMenuItem;
    miZoom50 :TMenuItem;
    miZoom75 :TMenuItem;
    miZoom200 :TMenuItem;
    mi500 :TMenuItem;
    mi100 :TMenuItem;
    miScrollBy :TMenuItem;
    miPrint :TMenuItem;
    MenuItem3 :TMenuItem;
    miExport :TMenuItem;
    miFile: TMenuItem;
    miQuit: TMenuItem;
    miEdit: TMenuItem;
    miUndo: TMenuItem;
    MenuItem14: TMenuItem;
    miCut: TMenuItem;
    miCopy: TMenuItem;
    miPaste: TMenuItem;
    MenuItem18: TMenuItem;
    miSelectAll: TMenuItem;
    miNew: TMenuItem;
    MenuItem20: TMenuItem;
    miFind: TMenuItem;
    miImage: TMenuItem;
    miFormat: TMenuItem;
    miFont: TMenuItem;
    miBullets: TMenuItem;
    miParagraph: TMenuItem;
    miAbout: TMenuItem;
    miHelp: TMenuItem;
    miOpen: TMenuItem;
    MenuItem4: TMenuItem;
    miInsert: TMenuItem;
    miSave: TMenuItem;
    miSaveAs: TMenuItem;
    MenuItem8: TMenuItem;
    miRedo :TMenuItem;
    Odlg: TOpenDialog;
    PSDlg :TPageSetupDialog;
    SDlg: TSaveDialog;
    sbFormat :TSpeedButton;
    StatusBar :TStatusBar;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    tbBold: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    tbNew: TToolButton;
    tbOpen: TToolButton;
    tbSave: TToolButton;
    tbPrint: TToolButton;
    tbVisualizarImpressao: TToolButton;
    tbFind: TToolButton;
    tbCut: TToolButton;
    tbCopy: TToolButton;
    tbItalic: TToolButton;
    ToolButton20: TToolButton;
    tbPaste: TToolButton;
    tbUndo: TToolButton;
    ToolButton23: TToolButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    ToolButton26: TToolButton;
    ToolButton27: TToolButton;
    ToolButton28: TToolButton;
    ToolButton29: TToolButton;
    tbUnderline: TToolButton;
    tbExport: TToolButton;
    tbJustify :TToolButton;
    tbStrikeOut :TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure btnSendClick(Sender :TObject);
    procedure cbBackColorColorChanged(Sender :TObject);
    procedure CBFontSelect(Sender: TObject);
    procedure cbForeColorColorChanged(Sender :TObject);
    procedure CBSizeChange(Sender: TObject);
    procedure FindDialogClose(Sender :TObject);
    procedure FindDialogFind(Sender :TObject);
    procedure FindDialogShow(Sender :TObject);
    //procedure FindDlgFind(Sender :TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GroupBox1Click(Sender :TObject);
    procedure lzRichEdit1Change(Sender: TObject);
    procedure lzRichEdit1Click(Sender: TObject);
    procedure lzRichEdit1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure lzRichEdit1MouseDown(Sender :TObject; Button :TMouseButton;
      Shift :TShiftState; X, Y :Integer);
    procedure lzRichEdit1MouseMove(Sender :TObject; Shift :TShiftState; X,
      Y :Integer);
    procedure mi100Click(Sender :TObject);
    procedure mi500Click(Sender :TObject);
    procedure miExportClick(Sender :TObject);
    procedure miPrintClick(Sender :TObject);
    procedure miQuitClick(Sender: TObject);
    procedure miScrollLineMinus5Click(Sender :TObject);
    procedure miScrollLinePlus5Click(Sender :TObject);
    procedure miSelectAllClick(Sender: TObject);
    procedure miImageClick(Sender: TObject);
    procedure miFontClick(Sender: TObject);
    procedure miParagraphClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miZoom100Click(Sender :TObject);
    procedure miZoom10Click(Sender :TObject);
    procedure miZoom150Click(Sender :TObject);
    procedure miZoom200Click(Sender :TObject);
    procedure miZoom25Click(Sender :TObject);
    procedure miZoom300Click(Sender :TObject);
    procedure miZoom500Click(Sender :TObject);
    procedure miZoom50Click(Sender :TObject);
    procedure miZoom75Click(Sender :TObject);
    procedure sbFormatClick(Sender :TObject);
    procedure tbOpenClick(Sender: TObject);
    procedure tbSaveClick(Sender: TObject);
    procedure miSaveAsClick(Sender: TObject);
    procedure miRedoClick(Sender :TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure tbNewClick(Sender: TObject);
    procedure tbFindClick(Sender: TObject);
    procedure tbCutClick(Sender: TObject);
    procedure tbCopyClick(Sender: TObject);
    procedure tbBoldClick(Sender: TObject);
    procedure tbPasteClick(Sender: TObject);
    procedure tbUndoClick(Sender: TObject);
    procedure tbItalicClick(Sender: TObject);
    procedure tbExportClick(Sender: TObject);
    procedure tbJustifyClick(Sender :TObject);
    procedure tbStrikeOutClick(Sender :TObject);
    procedure tbUnderlineClick(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
  private
    { private declarations }
    FRegexObj: TRegExpr;
    FExecuted: boolean;
    FStream :tMemoryStream;
    FFirstChange :boolean;
    procedure ResetZoomMenuItems;
    procedure UnCheckAllZoomMenuItems;
  private
  {$IFDEF Windows}
    //Suporte a Objeto Ole
    procedure CreateOLEObjectInterface;
    procedure CloseOLEObjects;
  {$ENDIF}
  protected
    { protected declarations }
    FFileName: string;
    FSetColor: boolean;
    FPlainText :boolean;
  protected
    { protected declarations }
    procedure SetFileName(S: string);
    procedure GetTextStatus;
  public
    { public declarations }
    FTextEncoding :integer;
    property FileName: string read FFileName write SetFileName;
  public
    {$IFDEF Windows}
      RichEditOle: IRichEditOle;
      RichEditOleCallback: IRichEditOleCallback;
    {$ENDIF}
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.tbOpenClick(Sender: TObject);
var
  S: TMemoryStream;
  sl :tstringlist;
begin
  //-- Abrir
  Odlg.Title := 'Abrir...';
  Odlg.Filter := 'Rich Text (*' + lzRichEdit1.DefaultExtension {.rtf} + ')|*.rtf|Texto (*.txt)|*.txt';
  Odlg.Options := [ofEnableSizing, ofViewDetail, ofHideReadOnly];
  if Odlg.Execute then
  begin
    if not (FileExistsUTF8(Odlg.FileName)) then
    begin
      MessageDlg('Error on Open', 'Specified file does not exist.',
        mtError, [mbOK], 0);
      Exit;
    end;
    //--
    if not (FileIsReadOnly(Odlg.FileName)) then
      FileName := Odlg.FileName
    else
      FileName := '';
    //--
    lzRichEdit1.Clear;
    lzRichEdit1.LoadFromFile(Utf8ToAnsi(Odlg.FileName));

    { lzRichEdit1.PlainText retorna de LoadFromFile com o valor correto e
      esse valor é guardado em FPlainText para ser usado em Save. }

    FPlainText := lzRichEdit1.PlainText;

    { If you don't have problems with BOM chars, comment the 3 lines below. }
    if FPlainText then
      if Copy(lzRichEdit1.Text, 1, 3) = #239#187#191 then
        lzRichEdit1.Text := Copy(lzRichEdit1.Text, 4, Length(lzRichEdit1.Text) - 3);

    //--
  end;
  lzRichEdit1.Modified := False;
  FileName := Odlg.FileName;

  // Reset zoom
  ResetZoomMenuItems;
end;

procedure TfrmMain.tbSaveClick(Sender: TObject);
var
  S: TFileStream;
begin
  lzRichEdit1.PlainText := FPlainText;

  if (FileName = '') then
  begin
    miSaveAsClick(Sender);
    Exit;
  end;
  //--
  {
  S := TFileStream.Create(FileName, fmCreate);
  try
    lzRichEdit1.SaveToStream(S);
  finally
    S.Free;
  end;
  }

  lzRichEdit1.SaveToFile(FileName);

  lzRichEdit1.Modified := False;
end;

procedure TfrmMain.tbFindClick(Sender: TObject);
begin
  frmMain.ActiveControl := btnSend;
  FindDialog.Title := 'Find RegEx';
  FindDialog.Execute;
end;

procedure TfrmMain.tbCutClick(Sender: TObject);
begin
  lzRichEdit1.CutToClipboard;
end;

procedure TfrmMain.tbCopyClick(Sender: TObject);
begin
  lzRichEdit1.CopyToClipboard;
end;

procedure TfrmMain.tbBoldClick(Sender: TObject);
begin
  //(ActiveControl as TlzRichEdit)
  if (fsBold in lzRichEdit1.SelAttributes.Style) then
    lzRichEdit1.SelAttributes.Style := lzRichEdit1.SelAttributes.Style - [fsBold]
  else
    lzRichEdit1.SelAttributes.Style := lzRichEdit1.SelAttributes.Style + [fsBold];

  GetTextStatus;
end;

procedure TfrmMain.tbPasteClick(Sender: TObject);
begin
  lzRichEdit1.PasteFromClipboard;
end;

procedure TfrmMain.tbUndoClick(Sender: TObject);
begin
  lzRichEdit1.Undo;
end;

procedure TfrmMain.tbItalicClick(Sender: TObject);

begin
  if (fsItalic in lzRichEdit1.SelAttributes.Style) then
    lzRichEdit1.SelAttributes.Style := lzRichEdit1.SelAttributes.Style - [fsItalic]
  else
    lzRichEdit1.SelAttributes.Style := lzRichEdit1.SelAttributes.Style + [fsItalic];
  GetTextStatus;
end;

procedure TfrmMain.tbExportClick(Sender: TObject);
var
  Rtf2HTML:TRtf2HTML;
  S : TMemoryStream;
begin
  //--Salvar Como HTML
  Sdlg.Title := 'Salvar HTML';
  Sdlg.Filter := 'HTML (*.html)|*.html';
  Sdlg.Options := [ofEnableSizing, ofViewDetail, ofHideReadOnly];

  if Sdlg.Execute then
  begin
    //--
    if ExtractFileExt(Sdlg.FileName) = '' then
    begin
        Sdlg.FileName := Sdlg.FileName + '.html'
    end;
    //--
    if FileExists(Sdlg.FileName) then
    begin
      if (MessageDlg('Save HTML', Sdlg.FileName + ' already exists. ' +  LineEnding +
        ' Replace it?', mtWarning, [mbYes, mbNo], 0) <> 6) then
        Exit;
      if (FileIsReadOnly(Sdlg.FileName)) then
      begin
        MessageDlg('Save HTML', 'File ' + Sdlg.FileName +
          ' is read only.',
          mtWarning, [mbOK], 0);
        tbExportClick(Sender);
        Exit;
      end;
    end;
    //--
    S := TMemoryStream.Create;
    lzRichEdit1.SaveToStream(S);
    //--
    Rtf2HTML:= TRtf2HTML.Create;
    Rtf2HTML.SunFontSize:= 5;
    Rtf2HTML.Convert(S, ExtractFileDir(Sdlg.FileName), ExtractFileName(Sdlg.FileName));
    Rtf2HTML.Free;
  end;

end;

{$IFDEF WINDOWS}
function GetFileNameHandle(const FileName: String): HGLOBAL;
var pc: PChar;
begin
  Result := GlobalAlloc(GHND, Length(FileName)+1);
  pc := GlobalLock(Result);
  CharToOEM(PChar(FileName), pc);
  GlobalUnlock(Result);
end;
{$ENDIF}

function RICH_HTML(RICH: TlzRichEdit): string;
var
  I,J,MAX_ARRAY: integer;
  HTML: string;
  F,FO: array [0..5] of string;
  STR,LGT: integer;
  SIZE: integer;
  COR : string;
begin
  HTML := '';
  STR := RICH.SelStart;
  LGT := RICH.SelLength;
  MAX_ARRAY := 5;

  for J := 0 to MAX_ARRAY do
  begin
    F[J] := '';
    FO[J] := '';
  end;

  for I := 0 to length(RICH.text) do
  begin
    RICH.SelStart := I;
    RICH.SelLength := 1;

    for J := 0 to MAX_ARRAY do
      FO[J] := F[J];

    if (RICH.SelAttributes.Style - [fsItalic] - [fsUnderline] - [fsStrikeOut] = [fsBold]) then
      F[0] := '<b>'
    else
      F[0] := '</b>';

    if (RICH.SelAttributes.Style - [fsItalic] - [fsBold] - [fsStrikeOut] = [fsUnderline]) then
      F[1] := '<u>'
    else
      F[1] := '</u>';

    if (RICH.SelAttributes.Style - [fsUnderline] - [fsBold] - [fsStrikeOut] = [fsItalic]) then
      F[2] := '<i>'
    else
      F[2] := '</i>';

    if RICH.SelAttributes.size < 10 then
      SIZE := 1
    else if RICH.SelAttributes.size < 12 then
      SIZE := 2
    else if RICH.SelAttributes.size < 14 then
      SIZE := 3
    else if RICH.SelAttributes.size < 18 then
      SIZE := 4
    else if RICH.SelAttributes.size < 22 then
      SIZE := 5
    else if RICH.SelAttributes.size < 32 then
      SIZE := 6
    else
      SIZE := 7;
    COR := ColorToString(RICH.SelAttributes.Color);
    if (COR = 'clWindowText') or (COR = 'clBlack') then
      COR := '#000000'
    else if COR = 'clWite' then
      COR := '#FFFFFF'
    else if COR = 'clAqua' then
      COR := '#00FFFF'
    else if COR = 'clFuchsia' then
      COR := '#FF00FF'
    else if COR = 'clBlue' then
      COR := '#0000FF'
    else if COR = 'clYellow' then
      COR := '#FFFF00'
    else if COR = 'clLime' then
      COR := '#00FF00'
    else if COR = 'clRed' then
      COR := '#FF0000'
    else if COR = 'clSilver' then
      COR := '#C0C0C0'
    else if COR = 'clGray' then
      COR := '#808080'
    else if COR = 'clTeal' then
      COR := '#008080'
    else if COR = 'clPurple' then
      COR := '#800080'
    else if COR = 'clNavy' then
      COR := '#000080'
    else if COR = 'clOlive' then
      COR := '#808000'
    else if COR = 'clGreen' then
      COR := '#008000'
    else if COR = 'clMaroon' then
      COR := '#800000'
    else if copy(COR,1,1) = '$' then
      COR := '#'+copy(COR,length(COR)-1,2)
                +copy(COR,length(COR)-3,2)
                +copy(COR,length(COR)-5,2)
    else
      COR := '#000000';
    F[3] := '</font><font face="'+RICH.SelAttributes.Name+'" size='+inttostr(SIZE)+' color="'+COR+'">';

    if RICH.Paragraph.Alignment = traCenter then
      F[4] := '<center>'
    else
      F[4] := '</center>';

    if RICH.Paragraph.Alignment = traRight then
      F[5] := '<div align="right">'
    else
      F[5] := '</div>';

    for J := 0 to MAX_ARRAY do
      if FO[J] <> F[J] then
        HTML := HTML + F[J];

    if copy(RICH.text,I+1,1) = #13 then
      HTML := HTML + '<br>';

    HTML := HTML + copy(RICH.text,I+1,1);
  end;
  RICH.SelStart := STR;
  RICH.SelLength := LGT;

  result := HTML;
end;

procedure TfrmMain.tbJustifyClick(Sender :TObject);
begin
  lzRichEdit1.Paragraph.Alignment:= traJustify;
  GetTextStatus;
end;

procedure TfrmMain.tbStrikeOutClick(Sender :TObject);
begin
   if (fsStrikeOut in lzRichEdit1.SelAttributes.Style) then
    lzRichEdit1.SelAttributes.Style := lzRichEdit1.SelAttributes.Style - [fsStrikeOut]
  else
    lzRichEdit1.SelAttributes.Style := lzRichEdit1.SelAttributes.Style + [fsStrikeOut];

  GetTextStatus;
end;

procedure TfrmMain.tbUnderlineClick(Sender: TObject);
begin
   if (fsUnderline in lzRichEdit1.SelAttributes.Style) then
    lzRichEdit1.SelAttributes.Style := lzRichEdit1.SelAttributes.Style - [fsUnderline]
  else
    lzRichEdit1.SelAttributes.Style := lzRichEdit1.SelAttributes.Style + [fsUnderline];

  GetTextStatus;
end;

procedure TfrmMain.ToolButton6Click(Sender: TObject);
begin
  lzRichEdit1.Paragraph.Alignment:= traLeft;
  GetTextStatus;
end;

procedure TfrmMain.ToolButton8Click(Sender: TObject);
begin
  lzRichEdit1.Paragraph.Alignment:= traCenter;
  GetTextStatus;
end;

procedure TfrmMain.ToolButton9Click(Sender: TObject);
begin
  lzRichEdit1.Paragraph.Alignment:= traRight;
  GetTextStatus;
end;

{$IFDEF WINDOWS}
procedure TfrmMain.CreateOLEObjectInterface;
begin
  RichEditOleCallback := TRichEditOleCallback.Create(lzRichEdit1);

   if not RichEdit_GetOleInterface(lzRichEdit1.Handle, RichEditOle) then
     raise Exception.Create('Unable to get interface');
   if not RichEdit_SetOleCallback(lzRichEdit1.Handle, RichEditOlecallback) then
         raise Exception.Create('Unable to set callback');

end;

procedure TfrmMain.CloseOLEObjects;
var
I, ObjCount: Integer;
ReObject: TReObject;

begin

if not Assigned(RichEditOle) then Exit;
  FillChar(ReObject, SizeOf(ReObject), 0);
  ReObject.cbStruct := SizeOf(ReObject);
  ObjCount := RichEditOle.GetObjectCount;
  for I := 1 to RicheditOle.GetObjectCount do
    if RichEditOle.GetObject(I, ReObject, REO_GETOBJ_POLEOBJ) = S_OK then
      ReObject.poleobj.CLOSE(OLECLOSE_NOSAVE);

end;
{$ENDIF}
procedure TfrmMain.tbNewClick(Sender: TObject);
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

procedure TfrmMain.miSaveAsClick(Sender: TObject);
var
  S: TFileStream;
begin
  //--Salvar Como
  Sdlg.Title := 'Salvar Como';
  Sdlg.Filter := 'Rich Text (*' + lzRichEdit1.DefaultExtension {.rtf} + ')|*.rtf|Texto (*.txt)|*.txt';
  Sdlg.Options := [ofEnableSizing, ofViewDetail, ofHideReadOnly];

  if Sdlg.Execute then
  begin
    //--
    if ExtractFileExt(Sdlg.FileName) = '' then
      if (Sdlg.FilterIndex = 1) then
        Sdlg.FileName := Sdlg.FileName + lzRichEdit1.DefaultExtension  // '.rtf'
      else
        Sdlg.FileName := Sdlg.FileName + '.txt';

    { PlainText here. }
    if (Sdlg.FilterIndex = 1) then
      lzRichEdit1.PlainText := False
    else
      lzRichEdit1.PlainText := True;

    //--
    if FileExistsUTF8(Sdlg.FileName) then
    begin
      if (MessageDlg('Save As', Sdlg.FileName + ' already exists. ' +  LineEnding +
       'Replace it?', mtWarning, [mbYes, mbNo], 0) <> 6) then
        Exit;
      if (FileIsReadOnly(Sdlg.FileName)) then
      begin
        MessageDlg('Save As', 'File ' + Sdlg.FileName +
          ' is read only.',
          mtWarning, [mbOK], 0);
        miSaveAsClick(Sender);
        Exit;
      end;
    end;
    //--
    if not lzRichEdit1.PlainText then
      lzRichEdit1.SaveToFile(Sdlg.FileName)
    else
      lzRichEdit1.Lines.SaveToFile(Sdlg.FileName);
    //--
    FileName := Sdlg.FileName;

    { Opens saved file. }
    lzRichEdit1.Clear;
    lzRichEdit1.LoadFromFile(Utf8ToAnsi(FileName));

    FPlainText := lzRichEdit1.PlainText;

    // Reset zoom
    ResetZoomMenuItems;
  end;
end;

procedure TfrmMain.miRedoClick(Sender :TObject);
begin
  lzRichEdit1.Redo;
end;

procedure TfrmMain.ToolButton11Click(Sender: TObject);
begin

  if lzRichEdit1.Paragraph.Numbering = nsNone then
    begin
      lzRichEdit1.Paragraph.Numbering:= nsBullets;
    end
  else
    begin
      lzRichEdit1.Paragraph.Numbering:= nsNone;
    end;

  GetTextStatus;
end;

procedure TfrmMain.lzRichEdit1Click(Sender: TObject);
begin
  GetTextStatus;
end;

procedure TfrmMain.FindDialogClose(Sender :TObject);
begin
  FRegexObj.Free;
  FExecuted := False;
  BringToFront;
end;

procedure TfrmMain.FindDialogFind(Sender :TObject);
var
  FoundAt: Longint;
  StartPos, ToEnd: Integer;
  mySearchTypes : TSearchTypes;
  myFindOptions : TFindOptions;
  Backwards, b :boolean;
  p :Classes.TPoint;
  CurrentSearch :String;
  s :String;
begin
  mySearchTypes := [];
  with lzRichEdit1 do
  begin
    if frMatchCase in FindDialog.Options then
       mySearchTypes := mySearchTypes + [stMatchCase];
    if frWholeWord in FindDialog.Options then
       mySearchTypes := mySearchTypes + [stWholeWord];
    { Começa a busca depois da seleção atual se existe alguma.
      Senão começa no início do texto. }
    if SelLength <> 0 then
      StartPos := SelStart + SelLength
    else
      StartPos := 0;
    { ToEnd é o comprimento a partir de StartPos até o fim do texto. }
    ToEnd := Length(Text) - StartPos;

    FRegexObj.Expression := FindDialog.FindText;
    if not FExecuted then
    begin
      if not FRegexObj.Exec(lzRichEdit1.Text) then
      begin
        ShowMessage('Text not found');
        Exit;
      end;
      FRegexObj.Expression := FindDialog.FindText;
      FindDialog.Title  := 'Searching for "' + FRegexObj.Match[0] + '"';
      FExecuted := True;
    end
    else
    begin
      if FRegexObj.SubExprMatchCount > 0 then
      begin
        FRegexObj.ExecNext;
        s :=  FRegexObj.Match[0];
        if s <> '' then
          FindDialog.Title  := 'Searching for "' + s + '"';
      end;
    end;

    CurrentSearch := Copy(finddialog.title, 16, length(FRegexObj.Match[0]));
    FoundAt :=
      FindText(CurrentSearch {FindDialog.FindText}, StartPos, ToEnd, mySearchTypes, False );

    if FoundAt <> -1 then
    begin
      SetFocus;
      SelStart := FoundAt;
      SelLength := UTF8Length({FindDialog.FindText} CurrentSearch);

      FindDialog.Position := ClientToScreen(
                           Classes.Point(
                                         (lzRichEdit1.Left + lzRichEdit1.Width - FindDialog.Width) div 2,
                                         lzRichEdit1.CaretPoint.Y + lzRichEdit1.Font.Size + 20
                                         ));
    end
    else
    begin
      p.x := (lzRichEdit1.Left + lzRichEdit1.Width - FindDialog.Width) div 2;
      p.y := (lzRichEdit1.Top + lzRichEdit1.Height - FindDialog.height) div 2;
      FindDialog.Position := ClientToScreen(p);
      lzRichEdit1.SelStart := lzRichEdit1.SelStart + lzRichEdit1.SelLength;
      lzRichEdit1.SelLength := 0;
      FindDialog.CloseDialog;
      ShowMessage('Search complete');
    end;
  end;
end;

procedure TfrmMain.FindDialogShow(Sender :TObject);
begin
  FRegexObj := TRegExpr.Create;
end;

{
procedure TfrmMain.FindDlgFind(Sender :TObject);
var
  FoundAt: Longint;
  StartPos, ToEnd: Integer;
  mySearchTypes : TSearchTypes;
  myFindOptions : TFindOptions;
  Backwards, b :boolean;
  p :Classes.TPoint;
begin
  Backwards := not (frDown in FindDialog.Options);

  mySearchTypes := [];
  with lzRichEdit1 do
  begin
    if frMatchCase in FindDialog.Options then
       mySearchTypes := mySearchTypes + [stMatchCase];
    if frWholeWord in FindDialog.Options then
       mySearchTypes := mySearchTypes + [stWholeWord];
    { Começa a busca depois da seleção atual se existe alguma.
      Senão começa no início do texto. }
    if SelLength <> 0 then
      StartPos := SelStart + SelLength
    else
      StartPos := 0;
    { ToEnd é o comprimento a partir de StartPos até o fim do texto. }
    ToEnd := Length(Text) - StartPos;
    FoundAt :=
      FindText(FindDialog.FindText, StartPos, ToEnd, mySearchTypes, False );
    if FoundAt <> -1 then
    begin
      SetFocus;
      SelStart := FoundAt;
      SelLength := UTF8Length(FindDialog.FindText);

      FindDialog.Position := ClientToScreen(lzRichEdit1.CaretPoint);
    end
    else
    begin
      p.x := (lzRichEdit1.Left + lzRichEdit1.Width - FindDialog.Width) div 2;
      p.y := (lzRichEdit1.Top + lzRichEdit1.Height - FindDialog.height) div 2;
      FindDialog.Position := ClientToScreen(p);
      ShowMessage('Text not found');
    end;
  end;
end;
}

procedure TfrmMain.CBFontSelect(Sender: TObject);
begin
  lzRichEdit1.SelAttributes.Name := CBfont.Text;
  GetTextStatus;
end;

procedure TfrmMain.cbForeColorColorChanged(Sender :TObject);
begin
  lzRichEdit1.SelAttributes.Color := cbForeColor.ButtonColor;
  GetTextStatus;
end;

procedure TfrmMain.cbBackColorColorChanged(Sender :TObject);
begin
  lzRichEdit1.SelAttributes.BackColor := cbBackColor.ButtonColor;
  GetTextStatus;
end;

procedure TfrmMain.btnSendClick(Sender :TObject);
var
  str :TMemoryStream;
  i :Integer;
begin
  cbfont.SetFocus;
  str := TMemoryStream.Create;
  try
    lzRichEdit1.SelStart := lzRichEdit1.GetTextLen;
    lzRichEdit2.SelStart := 0;
    lzRichEdit2.SelLength := Length(lzRichEdit2.Text) + 2;
    lzRichEdit2.GetRTFSelection(str);
    str.Position := 0;
    lzRichEdit1.PutRTFSelection(str);
    lzRichEdit1.SetFocus;
    lzRichEdit1.SelStart := lzRichEdit1.GetTextLen;
    lzRichEdit1.ScrollToCaret;
  finally
    str.Free;
  end;
  lzRichEdit1.SelLength := 0;
  lzRichEdit2.Clear;
  lzrichedit2.setfocus;
end;

procedure TfrmMain.CBSizeChange(Sender: TObject);
var
  FontSize: integer;
begin
  if TryStrToInt(CBSize.Text, FontSize) then
  begin
    lzRichEdit1.SelAttributes.Size:= FontSize;
  end
  else
    MessageDlg('Format', 'Invalid number', mtInformation, [mbOK], 0);

  GetTextStatus;
end;

procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if lzRichEdit1.Modified and false then
    if MessageDlg('Save', 'Save document?', mtConfirmation,
      [mbYes, mbNo], 0) = 6
    then
      tbSaveClick(Sender);

    {$IFDEF Windows}
    //Limpa Objetos OLE
    CloseOLEObjects;
    {$ENDIF}
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FSetColor := True;
  {$IFDEF Linux}
    tbUndo.Enabled := False;
    miUndo.Enabled := False;
  {$ENDIF}
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  sFont: TFont;
  I, I2, I3: integer;
{$IFDEF Linux}
  FontList: TStringList;
{$ENDIF}
begin
{$IFDEF Windows}
  //Lista de Fontes no Windows
  CBFont.Items.Assign(Screen.Fonts);
  //Adiciona Suporte a Objetos OLE
  CreateOLEObjectInterface;
{$ENDIF}

{$IFDEF Linux}
  //Lista de fontes no Linux
  FontList := TStringList.Create;
  GetFontList(FontList);
  CBFont.Items.Assign(FontList);
  FontList.Free;
{$ENDIF}
CBFont.Items.Add('Sans');

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

  {Isto não está funcionando no Windows
  porque depois deste evento ocorre um
  evento OnChange do RichEdit ao iniciar.}
  // lzRichEdit1.Modified := False;

  miZoom100.Checked := True;

  if ParamStr(1) <> '' then
    lzRichEdit1.LoadFromFile(ParamStr(1));

  {$IFNDEF WINDOWS}
  tbJustify.Visible := False;
  {$ENDIF}
end;

procedure TfrmMain.GroupBox1Click(Sender :TObject);
begin
  //
end;

procedure TfrmMain.lzRichEdit1Change(Sender: TObject);
begin
  {$IFDEF Linux}
  GetTextStatus;
  {$ENDIF}

  {RichEdit initializes modified because
  it occurs an OnChange event when it is loaded.}
  if not FFirstChange then lzRichEdit1.Modified := False;
  FFirstChange := True;
end;

procedure TfrmMain.lzRichEdit1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  GetTextStatus;
end;

procedure TfrmMain.lzRichEdit1MouseDown(Sender :TObject; Button :TMouseButton;
  Shift :TShiftState; X, Y :Integer);
var
  p :TCaretCoordinates;
begin
  p := lzRichEdit1.CaretCoordinates;
  StatusBar.Panels[0].Text :=  IntToStr(p.Line + 1) +  ' : ' +  IntToStr(p.Column + 1);

  statusbar.Panels[1].Text := lzRichEdit1.GetWordAtPos(lzRichEdit1.SelStart);

  statusbar.Panels[3].text := 'First visible line :  ' +
                                      IntToStr(lzRichEdit1.GetFirsVisibleLine);
end;

procedure TfrmMain.lzRichEdit1MouseMove(Sender :TObject; Shift :TShiftState; X,
  Y :Integer);
begin
  statusbar.Panels[2].text := lzRichEdit1.GetWordAtPoint(X, Y);
end;

procedure ScrollRichEditBy(RichEdit :TlzRichEdit; AValue :integer);
var
  p :Classes.TPoint;
begin
  p := RichEdit.ScrollPoint;
  p.y := p.y + 100;
  RichEdit.ScrollPoint := p;
end;

procedure TfrmMain.mi100Click(Sender :TObject);
begin
  ScrollRichEditBy(lzRichEdit1, 100);
end;

procedure TfrmMain.mi500Click(Sender :TObject);
begin
  ScrollRichEditBy(lzRichEdit1, 500);
end;

procedure TfrmMain.miExportClick(Sender :TObject);
begin
  tbExportClick(Sender);
end;

procedure TfrmMain.miPrintClick(Sender :TObject);
var
  PrintMargins :TRect;
  i :Integer;
begin
  PrintMargins.Left := 2540;
  PrintMargins.Top := 3000;
  PrintMargins.Right := 2540;
  PrintMargins.Bottom := 3000;
  PSDlg.Margins := PrintMargins;

  if PSDlg.Execute then
  begin
    PrintMargins.Left := Round(PSDlg.Margins.Left / 4);
    PrintMargins.Top := Round(PSDlg.Margins.Top / 4);
    PrintMargins.Right := Round(PSDlg.Margins.Right / 4);
    PrintMargins.Bottom := Round(PSDlg.Margins.Bottom / 4);
    lzRichEdit1.Print(ExtractFileName(FileName), PrintMargins);
  end;
end;

procedure TfrmMain.miQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.miScrollLineMinus5Click(Sender :TObject);
begin
  lzRichEdit1.ScrollLine(-5);
end;

procedure TfrmMain.miScrollLinePlus5Click(Sender :TObject);
begin
  lzRichEdit1.ScrollLine(5);
end;

procedure TfrmMain.miSelectAllClick(Sender: TObject);
begin
  lzRichEdit1.SelectAll;
end;

procedure TfrmMain.miImageClick(Sender: TObject);
var
  p: TPicture;
begin
  //-- Inserir Imagem
  Odlg.Title := 'Abrir...';
  {$IFDEF WINDOWS}
  Odlg.Filter :=
    'Imagens (*.bmp;*.xpm;*.png;*.ico;*.jpg;*.jpeg)|*.bmp;*.xpm;*.png;*.ico;*.jpg;*.jpeg';
  {$ENDIF}
  {$IFDEF Linux}
  Odlg.Filter :=
    'Imagens (*.bmp;*.xpm;*.png)|*.bmp;*.xpm;*.png';
  {$ENDIF}

  Odlg.Options := [ofEnableSizing, ofViewDetail, ofHideReadOnly];

  if Odlg.Execute then
  begin
    p := TPicture.Create;
    p.LoadFromFile(Odlg.FileName);
      {$IFDEF Windows}
      p.Bitmap.SaveToClipboardFormat(2);
      lzRichEdit1.PasteFromClipboard;
      {$ENDIF}
      {$IFDEF Linux}
        InsertImage(lzRichEdit1, p, lzRichEdit1.SelStart);
      {$ENDIF}
    p.Free;
  end;

end;

procedure TfrmMain.miFontClick(Sender: TObject);
begin
  FDlg.Title := 'Fonte';
  //--
  FDlg.Font.Name := lzRichEdit1.SelAttributes.Name;
  FDlg.Font.Size := lzRichEdit1.SelAttributes.Size;
  FDlg.Font.Color := lzRichEdit1.SelAttributes.Color;
  FDlg.Font.Style := lzRichEdit1.SelAttributes.Style;

  if FDlg.Execute then
  begin
    lzRichEdit1.SelAttributes.Name:= FDlg.Font.Name;
    lzRichEdit1.SelAttributes.Size:= FDlg.Font.Size;
    lzRichEdit1.SelAttributes.Color:= FDlg.Font.Color;
    lzRichEdit1.SelAttributes.Style:= FDlg.Font.Style;
  end;
end;

procedure TfrmMain.miParagraphClick(Sender: TObject);
begin
  frmParagrafo.Execute(lzRichEdit1);
end;

procedure TfrmMain.miAboutClick(Sender: TObject);
begin
  frmSobre.Show;
end;

procedure TfrmMain.ResetZoomMenuItems;
begin
  UnCheckAllZoomMenuItems;
  miZoom100.Checked := True;
end;

procedure TfrmMain.UnCheckAllZoomMenuItems;
begin
  miZoom10.Checked := False;
  miZoom25.Checked := False;
  miZoom50.Checked := False;
  miZoom75.Checked := False;
  miZoom100.Checked := False;
  miZoom150.Checked := False;
  miZoom200.Checked := False;
  miZoom300.Checked := False;
  miZoom500.Checked := False;
end;

procedure TfrmMain.miZoom100Click(Sender :TObject);
var
  zp :TZoomPair;
begin
  zp.Numerator := 1;
  zp.Denominator := 1;
  lzRichEdit1.SetZoomState(zp);

  UnCheckAllZoomMenuItems;
  miZoom100.Checked := True;
end;

procedure TfrmMain.miZoom10Click(Sender :TObject);
var
  zp :TZoomPair;
begin
  zp.Numerator := 1;
  zp.Denominator := 10;
  lzRichEdit1.SetZoomState(zp);
  UnCheckAllZoomMenuItems;
  miZoom10.Checked := True;
end;

procedure TfrmMain.miZoom150Click(Sender :TObject);
var
  zp :TZoomPair;
begin
  zp.Numerator := 48;
  zp.Denominator := 32;
  lzRichEdit1.SetZoomState(zp);
  UnCheckAllZoomMenuItems;
  miZoom150.Checked := True;
end;

procedure TfrmMain.miZoom200Click(Sender :TObject);
var
  zp :TZoomPair;
begin
  zp.Numerator := 2;
  zp.Denominator := 1;
  lzRichEdit1.SetZoomState(zp);
  UnCheckAllZoomMenuItems;
  miZoom200.Checked := True;
end;

procedure TfrmMain.miZoom25Click(Sender :TObject);
var
  zp :TZoomPair;
begin
  zp.Numerator := 16;
  zp.Denominator := 64;
  lzRichEdit1.SetZoomState(zp);
  UnCheckAllZoomMenuItems;
  miZoom25.Checked := True;
end;

procedure TfrmMain.miZoom300Click(Sender :TObject);
var
  zp :TZoomPair;
begin
  zp.Numerator := 3;
  zp.Denominator := 1;
  lzRichEdit1.SetZoomState(zp);
  UnCheckAllZoomMenuItems;
  miZoom300.Checked := True;
end;

procedure TfrmMain.miZoom500Click(Sender :TObject);
var
  zp :TZoomPair;
begin
  zp.Numerator := 5;
  zp.Denominator := 1;
  lzRichEdit1.SetZoomState(zp);
  UnCheckAllZoomMenuItems;
  miZoom500.Checked := True;
end;

procedure TfrmMain.miZoom50Click(Sender :TObject);
var
  zp :TZoomPair;
begin
  zp.Numerator := 32;
  zp.Denominator := 64;
  lzRichEdit1.SetZoomState(zp);
  UnCheckAllZoomMenuItems;
  miZoom50.Checked := True;
end;

procedure TfrmMain.miZoom75Click(Sender :TObject);
var
  zp :TZoomPair;
begin
  zp.Numerator := 48;
  zp.Denominator := 64;
  lzRichEdit1.SetZoomState(zp);
  UnCheckAllZoomMenuItems;
  miZoom75.Checked := True;
end;

procedure TfrmMain.sbFormatClick(Sender :TObject);
begin
  lzRichEdit2.SelectAll;
  lzRichEdit2.SelAttributes.Style := [fsbold];
  lzRichEdit2.SelAttributes.Color := clRed;
end;

procedure TfrmMain.SetFileName(S: string);
begin
  FFileName := S;
end;

procedure TfrmMain.GetTextStatus;
begin
  //--
  CBFont.Caption := lzRichEdit1.SelAttributes.Name;
  CBSize.Text := IntToStr(lzRichEdit1.SelAttributes.Size);
  FSetColor := False;
  cbForeColor.ButtonColor := TColor(lzRichEdit1.SelAttributes.Color);
  cbBackColor.ButtonColor := TColor(lzRichEdit1.SelAttributes.BackColor);
  FSetColor := True;
  tbBold.Down := (fsBold in lzRichEdit1.SelAttributes.Style);
  tbItalic.Down := (fsItalic in lzRichEdit1.SelAttributes.Style);
  tbUnderline.Down := (fsUnderline in lzRichEdit1.SelAttributes.Style);
  //--
  ToolButton6.Down := (traLeft = lzRichEdit1.Paragraph.Alignment);
  ToolButton8.Down := (traCenter = lzRichEdit1.Paragraph.Alignment);
  ToolButton9.Down := (traRight = lzRichEdit1.Paragraph.Alignment);
  tbJustify.Down := (traJustify = lzRichEdit1.Paragraph.Alignment);
  //--
  ToolButton11.Down := (lzRichEdit1.Paragraph.Numbering=nsBullets);
  miBullets.Checked :=(lzRichEdit1.Paragraph.Numbering=nsBullets);
end;

end.

