unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls, Controls, Dialogs;

type

  { TForm1 }

  TForm1 = class(TForm)
    OpenForm2Button: TButton;
    procedure OpenForm2ButtonClick(Sender: TObject);
  end; 

implementation

{$R *.lfm}

uses
  AllRegisteredForms;

{ TForm1 }

procedure TForm1.OpenForm2ButtonClick(Sender: TObject);
begin
  case ShowForm('TForm2').ModalResult of
    mrOK: ShowMessage('OK clicked.');
    mrCancel: ShowMessage('Cancel clicked.');
  else
    ShowMessage('No button clicked.');
  end;
end;

end.

