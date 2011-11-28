unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, Grids;

type

  { TMainForm }

  TMainForm = class(TForm)
    DateStringGrid: TStringGrid;
    procedure FormCreate(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var
  VDays: array[0..6] of string;
  I, VCol, VRow, VNumDays, VDay: Integer;
begin
  VDays[0] := 'Sun';
  VDays[1] := 'Mon';
  VDays[2] := 'Tue';
  VDays[3] := 'Wed';
  VDays[4] := 'Thu';
  VDays[5] := 'Fri';
  VDays[6] := 'Sat';
  for I := 0 to 6 do
    DateStringGrid.Cells[I, 0] := VDays[I];
  VNumDays := MonthDays[IsLeapYear(2003), 2];
  ShortDateFormat := 'dd/mm/yyyy';
  VDay := DayOfWeek(StrToDate('01/02/2003'));
  VRow := 1;
  VCol := VDay - 1;
  for I := 1 to VNumDays do
  begin
    DateStringGrid.Cells[VCol, VRow] := IntToStr(I);
    Inc(VCol);
    if VCol > 6 then
    begin
      VCol := 0;
      Inc(VRow);
    end;
  end;
end;

end.

