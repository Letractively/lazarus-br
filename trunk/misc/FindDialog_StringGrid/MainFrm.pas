unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, Dialogs, Grids, Menus;

type

  { TMainForm }

  TMainForm = class(TForm)
    FindDialog1: TFindDialog;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    StringGrid1: TStringGrid;
    procedure FindDialog1Find(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.MenuItem2Click(Sender: TObject);
begin
  FindDialog1.Execute;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FindDialog1.Options := [frDown, frHideWholeWord, frHideUpDown];
end;

procedure TMainForm.FindDialog1Find(Sender: TObject);
var
  VGridRect: TGridRect;
  VTargetText, VCellText: string;
  I, X, Y, VCurX, VCurY, VGridWidth, VGridHeight: Integer;
label
  LTheEnd;
begin
  VCurX := StringGrid1.Selection.Left + 1;
  VCurY := StringGrid1.Selection.Top;
  VGridWidth := StringGrid1.ColCount;
  VGridHeight := StringGrid1.RowCount;
  Y := VCurY;
  X := VCurX;
  if frMatchCase in FindDialog1.Options then
    VTargetText := FindDialog1.FindText
  else
    VTargetText := AnsiLowerCase(FindDialog1.FindText);
  while Y < VGridHeight do
  begin
    while X < VGridWidth do
    begin
      if frMatchCase in FindDialog1.Options then
        VCellText := StringGrid1.Cells[X, Y]
      else
        VCellText := AnsiLowerCase(StringGrid1.Cells[X, Y]);
      I := Pos(VTargetText, VCellText);
      if I > 0 then
      begin
        VGridRect.Left := X;
        VGridRect.Right := X;
        VGridRect.Top := Y;
        VGridRect.Bottom := Y;
        StringGrid1.Selection := VGridRect;
        goto LTheEnd;
      end;
      Inc(X);
    end;
    Inc(Y);
    X := StringGrid1.FixedCols;
  end;
  LTheEnd: ;
end;

end.

