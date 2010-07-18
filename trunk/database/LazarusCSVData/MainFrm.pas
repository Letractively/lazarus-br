unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, ExtCtrls, StdCtrls, DBCtrls, DBGrids, DB, SdfData, SysUtils;

type

  { TMainForm }

  TMainForm = class(TForm)
    DataSource: TDatasource;
    LogoImage: TImage;
    NomeDBEdit: TDBEdit;
    EmailDBEdit: TDBEdit;
    FoneDBEdit: TDBEdit;
    DBGrid: TDBGrid;
    DBNavigator: TDBNavigator;
    NomeLabel: TLabel;
    EmailLabel: TLabel;
    FoneLabel: TLabel;
    CSVDataSet: TSdfDataSet;
    CSVDataSetEmail: TStringField;
    CSVDataSetFone: TStringField;
    CSVDataSetNome: TStringField;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

procedure TMainForm.FormShow(Sender: TObject);
begin
  CSVDataSet.FileName := ExtractFilePath(ParamStr(0)) + 'Data.csv';
  CSVDataSet.Open;
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    SelectNext(ActiveControl, True, True);
    Key := #0;
  end;
end;

end.

