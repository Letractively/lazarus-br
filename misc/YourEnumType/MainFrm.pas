unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
  end;

  TYourEnumType = (One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten);

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  TypInfo;

{ TMainForm }

procedure TMainForm.Button1Click(Sender: TObject);
var
  I: Integer;
begin
  ListBox1.Clear;
  for I := Ord(Low(TYourEnumType)) to Ord(High(TYourEnumType)) do
    ListBox1.Items.Add(GetEnumName(TypeInfo(TYourEnumType), I));
end;

end.

