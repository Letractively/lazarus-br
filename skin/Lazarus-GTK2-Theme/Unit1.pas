unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls, ComCtrls, Menus, Buttons;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    ListBox1: TListBox;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    ProgressBar1: TProgressBar;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
  end;

var
  Form1: TForm1; 

implementation

{$R *.lfm}

uses
  gtk2, sysutils;

{ TForm1 }


procedure TForm1.FormCreate(Sender: TObject);
begin
  SetCurrentDir(GetCurrentDir + PathDelim + 'Dogmastik' + PathDelim + 'gtk-2.0');
  gtk_rc_parse(PChar('gtkrc'));
  gtk_rc_reparse_all;
end;

end.

