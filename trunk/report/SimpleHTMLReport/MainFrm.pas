unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, ExtCtrls, Buttons, DbCtrls, StdCtrls, DBGrids, Ipfilebroker;

type

  { TMainForm }

  TMainForm = class(TForm)
    MainIpFileDataProvider: TIpFileDataProvider;
    OpenInBrowserCheckBox: TCheckBox;
    StripedCheckBox: TCheckBox;
    CloseBitBtn: TBitBtn;
    ProgrammersDBGrid: TDBGrid;
    MainDBNavigator: TDBNavigator;
    HTMLMemo: TMemo;
    PrintBitBtn: TBitBtn;
    TopPanel: TPanel;
    ClientPanel: TPanel;
    BottomPanel: TPanel;
    procedure PrintBitBtnClick(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  MainDM, SimpleHTMLReport;

{ TMainForm }

procedure TMainForm.PrintBitBtnClick(Sender: TObject);
var
  VSimpleHTMLReport: TSimpleHTMLReport;
begin
  VSimpleHTMLReport := TSimpleHTMLReport.Create;
  try
    VSimpleHTMLReport.BrowserTitle := Caption;
    VSimpleHTMLReport.DataSet := MainDataModule.MainDbf;
    VSimpleHTMLReport.ReportTitle := 'Listing programmers';
    VSimpleHTMLReport.Striped := StripedCheckBox.Checked;
    VSimpleHTMLReport.OpenInBrowser := OpenInBrowserCheckBox.Checked;
    VSimpleHTMLReport.Execute;
    HTMLMemo.Text := VSimpleHTMLReport.Template;
  finally
    VSimpleHTMLReport.Free;
  end;
end;

end.

