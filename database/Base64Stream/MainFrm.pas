unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, DB, Forms, ExtCtrls, DBCtrls, StdCtrls, ZConnection, ZDataset;

type

  { TMainForm }

  TMainForm = class(TForm)
    ImportButton: TButton;
    ExportButton: TButton;
    ClearButton: TButton;
    TestDataSource: TDatasource;
    MainDBNavigator: TDBNavigator;
    TestImage: TImage;
    ImageScrollBox: TScrollBox;
    MainZConnection: TZConnection;
    TestZQuery: TZQuery;
    procedure ClearButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImportButtonClick(Sender: TObject);
    procedure ExportButtonClick(Sender: TObject);
    procedure TestDataSourceDataChange(Sender: TObject; Field: TField);
    procedure TestZQueryAfterDelete(DataSet: TDataSet);
  private
    FFileName: TFileName;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  LSDialogs, Base64Picture;

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  MainZConnection.Connect;
  if MainZConnection.Connected then
    TestZQuery.Open;
end;

procedure TMainForm.ClearButtonClick(Sender: TObject);
begin
  if TestZQuery.State in dsEditModes then
  begin
    TestImage.Picture.Clear;
    TestZQuery.FieldByName('image').Clear;
  end;
end;

procedure TMainForm.ImportButtonClick(Sender: TObject);
begin
  FFileName := LSOpenDialog(odtPicture, '', '', -1, False, True);
  TestImage.Picture.LoadFromFile(FFileName);
  if TestZQuery.State = dsBrowse then
    TestZQuery.Append
  else
    TestZQuery.Edit;
  TestZQuery.FieldByName('image').AsString :=
    PictureToBase64(TestImage.Picture);
end;

procedure TMainForm.ExportButtonClick(Sender: TObject);
begin
  if Assigned(TestImage.Picture.Graphic) and
    (not TestImage.Picture.Graphic.Empty) then
  begin
    FFileName := 'Sample.' + GetFileExtFromPicture(TestImage.Picture);
    LSSaveDialog(FFileName, sdtPicture, '', '', -1, True, True);
    TestImage.Picture.SaveToFile(FFileName, ExtractFileExt(FFileName));
  end;
end;

procedure TMainForm.TestDataSourceDataChange(Sender: TObject; Field: TField);
begin
  if not TestZQuery.FieldByName('image').IsNull then
    Base64ToPicture(TestZQuery.FieldByName('image').AsString,
      TestImage.Picture);
end;

procedure TMainForm.TestZQueryAfterDelete(DataSet: TDataSet);
begin
  TestImage.Picture.Clear;
  TestImage.SetBounds(0, 0, 90, 90);
end;

end.

