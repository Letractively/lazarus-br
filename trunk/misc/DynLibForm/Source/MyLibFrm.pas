unit MyLibFrm;

{$mode objfpc}{$H+}

interface

uses
  LResources, Forms, StdCtrls, Buttons;

type

  { TMyLibForm }

  TMyLibForm = class(TForm)
    BitBtn1: TBitBtn;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Memo1: TMemo;
  end;

implementation

initialization
  {$I MyLibFrm.lrs}

end.
