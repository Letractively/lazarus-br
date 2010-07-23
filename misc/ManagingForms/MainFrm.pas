unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    OpenForm1Button: TButton;
    procedure OpenForm1ButtonClick(Sender: TObject);
  end; 

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  AllRegisteredForms, Unit1, Unit2;

{ TMainForm }

procedure TMainForm.OpenForm1ButtonClick(Sender: TObject);
begin
  ShowForm('TForm1');
end;

initialization
  RegisterForm([TForm1, TForm2]);

end.

