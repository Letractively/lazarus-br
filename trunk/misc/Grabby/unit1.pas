unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, StdCtrls, ExtCtrls,
  LCLIntf, LCLType, XMLPropStorage, Menus, Unit2, LCLProc, LazHelpHTML, Clipbrd,
  UTF8Process;

type

  { TFrmMain }

  TFrmMain = class(TForm)
    BtnGrab: TButton;
    BtnOptions: TButton;
    BtnQuit: TButton;
    LblWebsite: TLabel;
    MnuOptions: TMenuItem;
    MnuQuit: TMenuItem;
    MnuGrab: TMenuItem;
    MnuOpen: TMenuItem;
    PopupMnu: TPopupMenu;
    timer1: ttimer;
    TrayIcon: TTrayIcon;
    XMLPropStorage1: TXMLPropStorage;
    procedure BtnGrabClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure imggrabmousedown(Sender: TObject; button: tmousebutton;
      shift: tshiftstate; x, y: Integer);
    procedure imggrabmousemove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure imggrabmouseup(Sender: TObject; button: tmousebutton;
      shift: tshiftstate; x, y: Integer);
    procedure formcreate(Sender: TObject);
    procedure LblWebsiteClick(Sender: TObject);
    procedure mnugrabclick(Sender: TObject);
    procedure mnuopenclick(Sender: TObject);
    procedure mnuoptionsclick(Sender: TObject);
    procedure mnuquitclick(Sender: TObject);
    procedure timer1timer(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
    FrmGrab: TForm;
    ImgGrab: TImage;
    MyBitmap: TBitmap;
    X1, Y1, X2, Y2: Integer;
    Mousehasbeendown: Integer;
    R, G, B: Integer;
    filetype: string;
    stateoptions: string;
    option: string;
    frmstate: Integer;
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.lfm}

{ TFrmMain }

procedure TFrmMain.formcreate(Sender: TObject);
begin
  //LabelWebsite
  LblWebsite.Caption := LblWebsite.Caption + FormatDateTime('yyyy', TDateTime(now));

  XMLPropStorage1.Restore;

  FrmMain.Left := XMLPropStorage1.ReadInteger('WinPosX', 200);
  FrmMain.Top := XMLPropStorage1.ReadInteger('WinPosY', 200);

  frmstate := XMLPropStorage1.ReadInteger('WinState', 1);

  if frmstate = 0 then
    FrmMain.Visible := False;

end;

procedure TFrmMain.LblWebsiteClick(Sender: TObject);
var
  v: THTMLBrowserHelpViewer;
  BrowserPath, BrowserParams: string;
  p: LongInt;
  URL: string;
  BrowserProcess: TProcessUTF8;
begin
  v := THTMLBrowserHelpViewer.Create(nil);
  try
    v.FindDefaultBrowser(BrowserPath, BrowserParams);
    debugln(['Path=', BrowserPath, ' Params=', BrowserParams]);

    URL := 'http://fabienwang.com/projects/grabby';
    p := System.Pos('%s', BrowserParams);
    System.Delete(BrowserParams, p, 2);
    System.Insert(URL, BrowserParams, p);

    // start browser
    BrowserProcess := TProcessUTF8.Create(nil);
    try
      BrowserProcess.CommandLine := BrowserPath + ' ' + BrowserParams;
      BrowserProcess.Execute;
    finally
      BrowserProcess.Free;
    end;
  finally
    v.Free;
  end;
end;

procedure tfrmmain.mnugrabclick(Sender: TObject);
begin
  BtnGrabClick(self);
end;

procedure tfrmmain.mnuopenclick(Sender: TObject);
begin
  FrmMain.Visible := True;
  FrmOptions.frmstate := 1;
end;

procedure tfrmmain.mnuoptionsclick(Sender: TObject);
begin
  FrmOptions.ShowModal();
end;

procedure tfrmmain.mnuquitclick(Sender: TObject);
begin
  if FileExistsUTF8('config.xml') = True then
    DeleteFileUTF8('config.xml');

  XMLPropStorage1.WriteInteger('WinPosX', FrmMain.Left);
  XMLPropStorage1.WriteInteger('WinPosY', FrmMain.Top);
  XMLPropStorage1.WriteInteger('WinState', FrmOptions.frmstate);

  XMLPropStorage1.WriteString('Option', FrmOptions.option);

  XMLPropStorage1.WriteString('Filetype', FrmOptions.filetype);

  XMLPropStorage1.WriteString('Directory', FrmOptions.TxtDirectory.Text);
  XMLPropStorage1.WriteString('Filename', FrmOptions.TxtFilename.Text);
  XMLPropStorage1.WriteInteger('Number', FrmOptions.SpinNumber.Value);

  XMLPropStorage1.WriteInteger('Quality', FrmOptions.TBQuality.Position);

  XMLPropStorage1.Save;

  FileSetAttrUTF8('config.xml', faHidden);

  TrayIcon.Hide;
  Application.Terminate;
end;

procedure tfrmmain.timer1timer(Sender: TObject);
begin
  if frmstate = 0 then
    FrmMain.Visible := False;
  Timer1.Enabled := False;
end;

procedure TFrmMain.BtnGrabClick(Sender: TObject);
var
  ScreenDC: HDC;
  x, y: Integer;
begin
  //Directory empty? let choose one
  if (FrmOptions.RBAutosave.Checked = True) or
    (FrmOptions.RBAutosaveOpen.Checked = True) then
  begin
    if FrmOptions.TxtDirectory.Text = '' then
    begin
      Application.MessageBox(
        'Please choose a directory first. Click on "Options"',
        'Error', MB_ICONEXCLAMATION);
      Exit;
    end;
  end;

  MyBitmap := TBitmap.Create;
  ScreenDC := GetDC(0);
  MyBitmap.LoadFromDevice(ScreenDC);
  ReleaseDC(0, ScreenDC);

  MyBitmap.GetSize(x, y);
  MyBitmap.SetSize(x, y);
  FrmGrab := TForm.Create(self);
  FrmGrab.BorderStyle := bsNone;
  FrmGrab.FormStyle := fsStayOnTop;
  FrmGrab.Top := 0;
  FrmGrab.Left := 0;
  FrmGrab.Width := Screen.Width;
  FrmGrab.Height := Screen.Height;
  FrmGrab.Cursor := crNone;

  ImgGrab := TImage.Create(FrmGrab);
  ImgGrab.Picture.Bitmap := MyBitmap;

  ImgGrab.Parent := FrmGrab;

  ImgGrab.Left := 0;
  ImgGrab.Top := 0;
  ImgGrab.Width := Screen.Width;
  ImgGrab.Height := Screen.Height;

  X2 := Mouse.CursorPos.x;
  Y2 := Mouse.CursorPos.y;

  ImgGrab.Cursor := crCross;

  Mousehasbeendown := 0;

  ImgGrab.OnMouseMove := @imggrabmousemove;

  ImgGrab.OnMouseDown := @imggrabmousedown;

  ImgGrab.OnMouseUp := @imggrabmouseup;

  FrmGrab.ShowModal();
  FrmGrab.Free;

  if FrmOptions.frmstate = 1 then
    FrmMain.Show;
end;

procedure TFrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caHide;
  FrmOptions.frmstate := 0;
end;

procedure TFrmMain.imggrabmousedown(Sender: TObject; button: tmousebutton;
  shift: tshiftstate; x, y: Integer);
begin
  X1 := x;
  Y1 := y;
  Mousehasbeendown := 1;
end;

procedure TFrmMain.imggrabmousemove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  X2 := X;
  Y2 := Y;

  FrmGrab.Canvas.Draw(0, 0, MyBitmap);
  FrmGrab.Canvas.Pen.Color := clRed;

  if Mousehasbeendown = 1 then
  begin
    if X1 > X2 then
    begin
      if Y1 > Y2 then
      begin
        FrmGrab.Canvas.DrawFocusRect(Rect(X2, Y2, X1, Y1));
      end
      else
      begin
        FrmGrab.Canvas.DrawFocusRect(Rect(X2, Y1, X1, Y2));
      end;
    end
    else
    if Y1 > Y2 then
    begin
      FrmGrab.Canvas.DrawFocusRect(Rect(X1, Y2, X2, Y1));
    end
    else
    begin
      FrmGrab.Canvas.DrawFocusRect(Rect(X1, Y1, X2, Y2));
    end;
  end;

end;

procedure TFrmMain.imggrabmouseup(Sender: TObject; button: tmousebutton;
  shift: tshiftstate; x, y: Integer);
var
  newbitmap: TBitmap;
  datejour: string;
  timejour: string;
  filename: string;
  filenameold: string;
  filepath: string;
  usenumber: Boolean;
  bWidth, bHeight: Integer;
  sWidth, sHeight: Integer;
  jpegimage: TJPEGImage;
  pngimage: TPortableNetworkGraphic;

  v: THTMLBrowserHelpViewer;
  BrowserPath, BrowserParams: string;
  p: LongInt;
  URL: string;
  BrowserProcess: TProcessUTF8;
begin
  FrmGrab.Visible := False;
  FrmGrab.Hide;

  newbitmap := TBitmap.Create;

  if X1 < X2 then
    bWidth := X2 - X1 + 1
  else
    bWidth := X1 - X2 + 1;

  if Y1 < Y2 then
    bHeight := Y2 - Y1 + 1
  else
    bHeight := Y1 - Y2 + 1;

  MyBitmap.GetSize(sWidth, sHeight);

  if bWidth > sWidth then
    bWidth := sWidth;
  if bHeight > sHeight then
    bHeight := sHeight;

  newbitmap.SetSize(bWidth, bHeight);

  if X1 > X2 then
  begin
    if Y1 > Y2 then
    begin
      newbitmap.Canvas.CopyRect(Rect(0, 0, bWidth, bHeight), MyBitmap.Canvas,
        Rect(X2 - 1, Y2 - 1, X1, Y1));
    end
    else
    begin
      newbitmap.Canvas.CopyRect(Rect(0, 0, bWidth, bHeight), MyBitmap.Canvas,
        Rect(X2 - 1, Y1 - 1, X1, Y2));
    end;
  end
  else
  if Y1 > Y2 then
  begin
    newbitmap.Canvas.CopyRect(Rect(0, 0, bWidth, bHeight), MyBitmap.Canvas,
      Rect(X1 - 1, Y2 - 1, X2, Y1));
  end
  else
  begin
    newbitmap.Canvas.CopyRect(Rect(0, 0, bWidth, bHeight), MyBitmap.Canvas,
      Rect(X1 - 1, Y1 - 1, X2, Y2));
  end;

  if FrmOptions.RBClipboard.Checked = True then
  begin
    //Save to clipboard
    Clipboard.Assign(newbitmap);
  end
  else
  begin
    //Prepare variables
    datejour := FormatDateTime('yyyymmdd', TDateTime(now));
    timejour := FormatDateTime('hhnn', TDateTime(now));

    //Prepare filename
    filename := FrmOptions.TxtFilename.Text;
    filename := StringReplace(filename, '#date#', datejour, [rfReplaceAll]);
    filename := StringReplace(filename, '#time#', timejour, [rfReplaceAll]);
    filenameold := filename;
    usenumber := True;
    filename := StringReplace(filename, '#number#',
      IntToStr(FrmOptions.SpinNumber.Value), [rfReplaceAll]);
    if filename = filenameold then
      usenumber := False;

    //Full filename
    filepath := FrmOptions.TxtDirectory.Text + DirectorySeparator +
      filename + FrmOptions.filetype;

    //Save to a file
    if (FrmOptions.RBAutosave.Checked = True) or
      (FrmOptions.RBAutosaveOpen.Checked = True) then
    begin
      if FrmOptions.filetype = '.jpg' then
      begin
        jpegimage := TJPEGImage.Create;
        jpegimage.Assign(newbitmap);
        jpegimage.CompressionQuality := TJPEGQualityRange(FrmOptions.TBQuality.Position);
        jpegimage.SaveToFile(filepath);
      end
      else if FrmOptions.filetype = '.bmp' then
      begin
        newbitmap.SaveToFile(filepath);
      end
      else if FrmOptions.filetype = '.png' then
      begin
        pngimage := TPortableNetworkGraphic.Create;
        pngimage.Assign(newbitmap);
        pngimage.SaveToFile(filepath);
      end;
      //increase number
      if usenumber = True then
      begin
        FrmOptions.SpinNumber.Value := FrmOptions.SpinNumber.Value + 1;
      end;
      //Open file?
      if FrmOptions.RBAutosaveOpen.Checked = True then
      begin
        BrowserProcess := TProcessUTF8.Create(nil);
        try
          {$ifdef LINUX}
          BrowserPath := '/usr/bin/xdg-open';
          BrowserParams := filepath;
          {$endif}
          {$ifdef WINDOWS}
          BrowserPath := 'rundll32.exe';
          BrowserParams := 'shimgvw.dll,ImageView_Fullscreen ' + filepath;
          {$endif}
          BrowserProcess.CommandLine := BrowserPath + ' ' + BrowserParams;
          BrowserProcess.Execute;
        finally
          BrowserProcess.Free;
        end;
      end;
    end;

  end;
  FrmGrab.Close;
  MyBitmap.Free;
end;

end.

