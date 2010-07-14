unit SimpleHTMLReportFrm;

{$mode objfpc}{$H+}

interface

uses
  LResources, Forms, Menus, IpHtml;

type

  { TSimpleHTMLReportForm }

  TSimpleHTMLReportForm = class(TForm)
    CloseMenuItem: TMenuItem;
    N1: TMenuItem;
    PrintMenuItem: TMenuItem;
    FileMenuItem: TMenuItem;
    ReportMainMenu: TMainMenu;
    ReportIpHtmlPanel: TIpHtmlPanel;
    procedure CloseMenuItemClick(Sender: TObject);
  private
    procedure PrintMenuItemClick(Sender: TObject);
  public
    function ShowModal: Integer; override;
  end;

implementation

{ TSimpleHTMLReportForm }

procedure TSimpleHTMLReportForm.PrintMenuItemClick(Sender: TObject);
begin
  ReportIpHtmlPanel.PrintPreview;
end;

function TSimpleHTMLReportForm.ShowModal: Integer;
begin
  PrintMenuItem.OnClick := @PrintMenuItemClick;
  Result := inherited ShowModal;
end;

procedure TSimpleHTMLReportForm.CloseMenuItemClick(Sender: TObject);
begin
  Close;
end;

initialization
  {$I SimpleHTMLReportFrm.lrs}

end.

