unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, StdCtrls, ExtCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    FlipButton: TButton;
    NormalMemo: TMemo;
    FlipMemo: TMemo;
    NormalSplitter: TSplitter;
    FlipSplitter: TSplitter;
    procedure FlipButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NormalMemoEnter(Sender: TObject);
    procedure NormalMemoExit(Sender: TObject);
  end;

const
  CEmptyText = 'Put your text here...';

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

function FlipText(AText: string): string;
var
  I: Integer;
begin
  AText := LowerCase(AText);
  for I := 1 to Length(AText) do
  begin
    case AText[I] of
      'a': Result := 'ɐ' + Result;
      'b': Result := 'q' + Result;
      'c': Result := 'ɔ' + Result;
      'd': Result := 'p' + Result;
      'e': Result := 'ǝ' + Result;
      'f': Result := 'ɟ' + Result;
      'g': Result := 'b' + Result;
      'h': Result := 'ɥ' + Result;
      'i': Result := 'ı' + Result;
      'j': Result := 'ɾ' + Result;
      'k': Result := 'ʞ' + Result;
      'l': Result := 'ן' + Result;
      'm': Result := 'ɯ' + Result;
      'n': Result := 'u' + Result;
      'p': Result := 'd' + Result;
      'q': Result := 'b' + Result;
      'r': Result := 'ɹ' + Result;
      't': Result := 'ʇ' + Result;
      'u': Result := 'n' + Result;
      'v': Result := 'ʌ' + Result;
      'w': Result := 'ʍ' + Result;
      'y': Result := 'ʎ' + Result;
      '.': Result := '˙' + Result;
      ',': Result := '''' + Result;
      '''': Result := ',' + Result;
      '"': Result := ',,' + Result;
      ';': Result := '؛' + Result;
      '!': Result := '¡' + Result;
      #161: Result := '!' + Result;
      '?': Result := '¿' + Result;
      #191: Result := '?' + Result;
      '[': Result := ']' + Result;
      ']': Result := '[' + Result;
      '(': Result := ')' + Result;
      ')': Result := '(' + Result;
      '{': Result := '}' + Result;
      '}': Result := '{' + Result;
      '<': Result := '>' + Result;
      '>': Result := '<' + Result;
      '_': Result := '‾' + Result;
    else
      Result := AText[I] + Result;
    end;
  end;
end;

{ TMainForm }

procedure TMainForm.FlipButtonClick(Sender: TObject);
begin
  FlipMemo.Text := FlipText(NormalMemo.Text);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  NormalMemo.Text := CEmptyText;
end;

procedure TMainForm.NormalMemoEnter(Sender: TObject);
begin
  if Trim(NormalMemo.Text) = CEmptyText then
    NormalMemo.Clear;
end;

procedure TMainForm.NormalMemoExit(Sender: TObject);
begin
  if NormalMemo.Lines.Count < 1 then
    NormalMemo.Text := CEmptyText;
end;

end.

