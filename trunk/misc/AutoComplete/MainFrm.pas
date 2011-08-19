unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls, Classes, Contnrs, StrUtils;

type

  { TMainForm }

  TMainForm = class(TForm)
    ComboBox1: TComboBox;
    Label1: TLabel;
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  public
    FComboLists: TList;
    procedure FilterComboBox(AComboBox: TComboBox);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.ComboBox1Change(Sender: TObject);
begin
  if Sender is TComboBox then
    FilterComboBox(TComboBox(Sender));
end;

procedure TMainForm.ComboBox1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  VCompleted: Boolean = False;
begin
  if Sender is TComboBox then
  begin
    if TComboBox(Sender).ItemIndex > -1 then
      VCompleted := TComboBox(Sender).Text =
        TComboBox(Sender).Items[TComboBox(Sender).ItemIndex];
    TComboBox(Sender).DroppedDown := not VCompleted;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FComboLists := TObjectList.Create(True);
  ComboBox1.AutoComplete := False;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FComboLists.Free;
end;

procedure TMainForm.FilterComboBox(AComboBox: TComboBox);

  function Origin: TStrings;
  begin
    if AComboBox.Tag = 0 then
    begin
      AComboBox.Sorted := True;
      Result := TStringList.Create;
      Result.Assign(AComboBox.Items);
      FComboLists.Add(Result);
      AComboBox.Tag := integer(Result);
    end
    else
      Result := TStrings(AComboBox.Tag);
  end;

var
  I: Integer;
  VFilter: TStrings;
begin
  VFilter := TStringList.Create;
  try
    for I := 0 to Pred(Origin.Count) do
      if AnsiStartsText(AComboBox.Text, Origin[I]) then
        VFilter.Add(Origin[I]);
    AComboBox.Items.Assign(VFilter);
    AComboBox.SelStart := Length(AComboBox.Text);
  finally
    VFilter.Free;
  end;
end;

end.

