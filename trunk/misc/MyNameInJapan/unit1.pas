unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

const
  StrJapan: array['a'..'z'] of string = ('ka', 'tu', 'mi', 'te', 'ku', 'lu',
    'ji', 'ri', 'ki', 'zu', 'me', 'ta', 'rin', 'to', 'mo', 'no', 'ke', 'shi',
    'ari', 'chi', 'do', 'ru', 'na', 'mei', 'fu', 'ra');

function MyNameInJapan(S: string): string;
var
  C: Char;
begin
  Result := '';
  S := LowerCase(S);
  for C in S do
    Result += StrJapan[C];
end;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  Edit2.Text := MyNameInJapan(Edit1.Text);
  Edit1.SetFocus;
end;

end.

