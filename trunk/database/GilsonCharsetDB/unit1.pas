unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids, Buttons;

type

  { TForm1 }

  TForm1 = class(TForm)
    ComboBox1 : TComboBox;
    DBGrid1 : TDBGrid;
    SpeedButton1 : TSpeedButton;
    DataSource1 : TDataSource;
    cbUtf8 : TCheckBox;
    procedure cbUtf8Change(Sender : TObject);
    procedure SpeedButton1Click(Sender : TObject);
    procedure QueryAfterPost(DataSet : TDataSet);
  private
    FQuery : TSQLQuery;
    FCon   : TSQLConnection;
    FTr    : TSQLTransaction;
  public
    constructor Create(TheOwner : TComponent); override;
    property Query : TSQLQuery        read FQuery;
    property Con   : TSQLConnection   read FCon;
    property Tr    : TSQLTransaction  read FTr;
  private
  end;

var
  Form1 : TForm1;

implementation

uses uIBConnectionEncode, IniFiles;

{$R *.lfm}

{ TForm1 }

constructor TForm1.Create(TheOwner : TComponent);
begin
  inherited Create(TheOwner);
  FCon := TIBConnectionEncode.Create(Self);
  with TIniFile.Create('.\configs.ini') do
  try
    FCon.DatabaseName := ReadString('DB', 'DatabaseName', '.\db\teste.fb');
    FCon.UserName     := ReadString('DB', 'UserName', 'sysdba');
    FCon.Password     := ReadString('DB', 'Password', 'masterkey');
  finally
    Free;
  end;

  FTr    := TSQLTransaction.Create(Self);
  FTr.DataBase       := FCon;
  FTr.Params.Add('isc_tpb_autocommit');
  FTr.Params.Add('isc_tpb_read_committed');
  FTr.Params.Add('isc_tpb_nowait');
  FTr.Params.Add('isc_tpb_rec_version');

  FQuery := TSQLQuery.Create(Self);
  FQuery.DataBase     := FCon;
  FQuery.Transaction  := Tr;
  FQuery.AfterPost    := @QueryAfterPost;
  DataSource1.DataSet := Query;
end;

procedure TForm1.cbUtf8Change(Sender : TObject);
begin
  if FCon is TIBConnectionEncode then
  begin
    TIBConnectionEncode(FCon).ClientUTF8 := cbUtf8.Checked;
    if Query.Active then
    begin
      Query.Close;
      Query.Open;
    end;
  end;
end;

procedure TForm1.SpeedButton1Click(Sender : TObject);
begin
  Query.Close;
  Query.SQL.Text := ComboBox1.Text;
  Query.Open;
end;

procedure TForm1.QueryAfterPost(DataSet : TDataSet);
begin
  Query.ApplyUpdates;
end;

end.

