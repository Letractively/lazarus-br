unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, LResources, Forms, Dialogs, StdCtrls, Buttons;

type

  { TMainForm }

  TMainForm = class(TForm)
    CompareBitBtn: TBitBtn;
    ValueAEdit: TEdit;
    ValueBEdit: TEdit;
    ValueALabel: TLabel;
    ValueBLabel: TLabel;
    procedure CompareBitBtnClick(Sender: TObject);
    procedure ValueAEditChange(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

uses
  Math;

function FormatFloatNumbers(const AString: string): string;
var
  I: Integer;
begin
  Result := EmptyStr;
  for I := 1 to Length(AString) do
    if Pos(AString[I], '0123456789,.') > 0 then
      Result := Result + AString[I];
end;

{ TMainForm }

procedure TMainForm.CompareBitBtnClick(Sender: TObject);
const
  AResult: array[0..2] of string = ('A é menor que B.',
    'A é igual a B.', 'A é maior que B.');
begin
  case CompareValue(StrToFloatDef(ValueAEdit.Text, 0),
    StrToFloatDef(ValueBEdit.Text, 0)) of
  LessThanValue: ShowMessage(AResult[0]);
  EqualsValue: ShowMessage(AResult[1]);
  GreaterThanValue: ShowMessage(AResult[2]);
  end;
end;

procedure TMainForm.ValueAEditChange(Sender: TObject);
begin
  TCustomEdit(Sender).Text := FormatFloatNumbers(TCustomEdit(Sender).Text);
end;

initialization
  {$I MainFrm.lrs}

end.
