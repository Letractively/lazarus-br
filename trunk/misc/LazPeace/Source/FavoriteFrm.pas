unit FavoriteFrm;

{$mode objfpc}{$H+}

interface

uses
  DB, Forms, DBGrids, Buttons, ExtCtrls, Dialogs, Controls;

type

  { TFavoriteForm }

  TFavoriteForm = class(TForm)
    DeleteBitBtn: TBitBtn;
    CloseBitBtn: TBitBtn;
    FavoriteDataSource: TDatasource;
    FavoriteDBGrid: TDBGrid;
    TopPanel: TPanel;
    procedure DeleteBitBtnClick(Sender: TObject);
  public
    class procedure Execute;
  end;

implementation

{$R *.lfm}

uses
  MainFrm;

{ TFavoriteForm }

procedure TFavoriteForm.DeleteBitBtnClick(Sender: TObject);
begin
  if (not FavoriteDataSource.DataSet.IsEmpty) and
    (MessageDlg('Excluir favorita', 'Deseja excluir favorita?',
      mtConfirmation, mbYesNo, 0) = mrYes) then
      FavoriteDataSource.DataSet.Delete;
end;

class procedure TFavoriteForm.Execute;
begin
  with TFavoriteForm.Create(nil) do
    try
      FavoriteDataSource.DataSet.Open;
      ShowModal;
      MainForm.ClearPopupFavorite;
      MainForm.LoadFavorite;
    finally
      FavoriteDataSource.DataSet.Close;
      Free;
    end;
end;

end.

