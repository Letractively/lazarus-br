unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function GetValue: integer;
const
  Value: integer = 0;
begin
  Inc(Value);
  Result := Value;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Caption := IntToStr(GetValue);
end;

end.
