unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms,
{$HINTS OFF}
  NewStdCtrls
{$HINTS ON};

type

  { TMainForm }

  TMainForm = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
  end; 

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

end.

