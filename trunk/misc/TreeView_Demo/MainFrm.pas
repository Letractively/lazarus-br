unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, ComCtrls, Buttons, ExtCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    LoadButton: TBitBtn;
    ButtonPanel: TPanel;
    MainTreeView: TTreeView;
    procedure LoadButtonClick(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.LoadButtonClick(Sender: TObject);
begin
  MainTreeView.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Data.dat');
  MainTreeView.FullExpand;
end;

end.

