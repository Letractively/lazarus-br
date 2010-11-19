unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Graphics, Dialogs, StdCtrls, PrintersDlgs, Printers;

type
  { TMainForm }
  TMainForm = class(TForm)
    cmdDoPDF: TButton;
    cmdFreePrint: TButton;
    PrintDialog1: TPrintDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    procedure cmdDoPDFClick(Sender: TObject);
    procedure cmdFreePrintClick(Sender: TObject);
  end;

function fmt2str(const pVal: Integer): string; overload;
function fmt2str(const pVal: string): string; overload;
function fmt2str(const pVal: TRect): string; overload;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

const
  kx = 100;
  kfmt1 = '%-15s = %-30s';

function y(const pInit: Boolean = False; const pIndent: Integer = 100): Integer;
const
  _iy: Integer = 0;
  _ii: Integer = 100;
begin
  if (pInit = True) then
  begin
    _iy := 0;
    _ii := pIndent;
  end
  else
    Inc(_iy, _ii);
  Result := _iy;
end;

function fmt2str(const Pval: Integer): string; overload;
begin
  Result := IntToStr(pVal);
end;

function fmt2str(const Pval: string): string; overload;
begin
  Result := pVal;
end;

function fmt2str(const Pval: TRect): string; overload;
begin
  Result := Format('(%d : %d : %d : %d)', [pVal.Left, pVal.Top,
    pVal.Right, pVal.Bottom]);
end;

{ TMainForm }

procedure TMainForm.cmdFreePrintClick(Sender: TObject);
var
  i: Integer;
begin
  // In case of...
  Printer.Refresh;
  // Choosing PDF printer for test
  if (PrintDialog1.Execute = True) then
  begin
    // Try to setup different parameters
    // CRASH when paper size is changed !
    if (PrinterSetupDialog1.Execute = True) then
    begin
      Printer.Title := 'Free Print';
      Printer.Canvas.Font.Name := 'Courier New';
      Printer.Canvas.Font.Size := 14;
      i := Printer.Canvas.TextHeight('H');
      Printer.BeginDoc;
      // Draw a rectangle around the printable area
      Printer.Canvas.Pen.Width := 27;
      Printer.Canvas.Pen.Color := clRed;
      Printer.Canvas.Brush.Style := bsClear;
      Printer.Canvas.Rectangle(Printer.PaperSize.PaperRect.WorkRect);
      Printer.Canvas.TextOut(kx, y(True, i), Format(
        kfmt1, ['Printer name', Printer.Printers[Printer.PrinterIndex]]));
      Printer.Canvas.TextOut(kx, y, Format(
        kfmt1, ['Default Paper', Printer.PaperSize.DefaultPaperName]));
      Printer.Canvas.TextOut(kx, y, Format(
        kfmt1, ['Paper name', Printer.PaperSize.PaperName]));
      Printer.Canvas.TextOut(kx, y, Format(
        kfmt1, ['PhysicalRect', fmt2str(Printer.PaperSize.PaperRect.PhysicalRect)]));
      Printer.Canvas.TextOut(kx, y, Format(
        kfmt1, ['WorkRect', fmt2str(Printer.PaperSize.PaperRect.WorkRect)]));
      Printer.Canvas.TextOut(kx, y, Format(kfmt1, ['Xdpi', fmt2str(Printer.XDPI)]));
      Printer.Canvas.TextOut(kx, y, Format(kfmt1, ['Ydpi', fmt2str(Printer.YDPI)]));
      Printer.EndDoc;
      ShowMessage('If you can see this message, means all is ok !');
    end;
  end;
end;

procedure TMainForm.cmdDoPDFClick(Sender: TObject);
var
  i: Integer;
  p: Integer;
  s: string;
  l: TStringList;
begin
  l := TStringList.Create;
  // In case of...
  Printer.Refresh;
  // Checking printers to find a PDF printer
  p := -1;
  for i := 0 to Printer.Printers.Count - 1 do
  begin
    s := UpperCase(Printer.Printers.Strings[i]);
    if (Pos('PDF', s) <> 0) then
    begin
      p := i;
      BREAK;
    end;
  end;
  // No one ?
  if (p = -1) then
    EXIT;  // Ciao...
  // Sets the PDF printer
  Printer.PrinterIndex := p;
  // Getting default parameters before setting it
  l.Add('===================');
  l.Add('Defaults Parameters');
  l.Add('===================');
  l.Add(Format(kfmt1, ['Printer name', Printer.Printers[Printer.PrinterIndex]]));
  l.Add(Format(kfmt1, ['Default Paper', Printer.PaperSize.DefaultPaperName]));
  l.Add(Format(kfmt1, ['Paper name', Printer.PaperSize.PaperName]));
  l.Add(Format(kfmt1, ['Paper count', fmt2str(i)]));
  l.Add(Format(kfmt1, ['PhysicalRect',
    fmt2str(Printer.PaperSize.PaperRect.PhysicalRect)]));
  l.Add(Format(kfmt1, ['WorkRect', fmt2str(Printer.PaperSize.PaperRect.WorkRect)]));
  l.Add(Format(kfmt1, ['Xdpi', fmt2str(Printer.XDPI)]));
  l.Add(Format(kfmt1, ['Ydpi', fmt2str(Printer.YDPI)]));
  l.Add('');
  // Checking paper format to find A4
  for i := 0 to Printer.PaperSize.SupportedPapers.Count - 1 do
  begin
    s := UpperCase(Printer.PaperSize.SupportedPapers.Strings[i]);
    if (Pos('A4', s) <> 0) then
    begin
      Printer.PaperSize.PaperName := Printer.PaperSize.SupportedPapers.Strings[i];
      BREAK;
    end;
  end;
  // Now, getting currents parameters after setting
  l.Add('===================');
  l.Add('Currents Parameters');
  l.Add('===================');
  l.Add(Format(kfmt1, ['Printer name', Printer.Printers[Printer.PrinterIndex]]));
  l.Add(Format(kfmt1, ['Default Paper', Printer.PaperSize.DefaultPaperName]));
  l.Add(Format(kfmt1, ['Paper name', Printer.PaperSize.PaperName]));
  l.Add(Format(kfmt1, ['PhysicalRect',
    fmt2str(Printer.PaperSize.PaperRect.PhysicalRect)]));
  l.Add(Format(kfmt1, ['WorkRect', fmt2str(Printer.PaperSize.PaperRect.WorkRect)]));
  l.Add(Format(kfmt1, ['Xdpi', fmt2str(Printer.XDPI)]));
  l.Add(Format(kfmt1, ['Ydpi', fmt2str(Printer.YDPI)]));
  // Let's have a look on the result
  Printer.Title := 'Do PDF';
  Printer.Canvas.Font.Name := 'Courier New';
  Printer.Canvas.Font.Size := 14;
  i := Printer.Canvas.TextHeight('H');
  Printer.BeginDoc;
  // Draw a rectangle around the printable area
  Printer.Canvas.Pen.Width := 27;
  Printer.Canvas.Pen.Color := clRed;
  Printer.Canvas.Brush.Style := bsClear;
  Printer.Canvas.Rectangle(Printer.PaperSize.PaperRect.WorkRect);
  y(True, i);
  for i := 0 to l.Count - 1 do
  begin
    Printer.Canvas.TextOut(kx, y, l.Strings[i]);
  end;
  Printer.EndDoc;
  FreeAndNil(l);
  ShowMessage('If you can see this message, means all is ok !');
end;

end.

