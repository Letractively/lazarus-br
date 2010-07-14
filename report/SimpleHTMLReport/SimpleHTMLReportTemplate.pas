unit SimpleHTMLReportTemplate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TSimpleHTMLReportTemplate }

  TSimpleHTMLReportTemplate = class
  private
    FBrowserTitle: string;
    FReportTitle: string;
    FReportTableHeaderCells: TStringList;
    FReportValueCells: TStringList;
    function GetTemplate: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddReportTableHeaderCell(const ACaption: string);
    procedure AddReportEvenBeginCells;
    procedure AddReportEvenValueCells(const ACaption: string);
    procedure AddReportEvenEndCells;
    procedure AddReportOddBeginCells;
    procedure AddReportOddValueCells(const ACaption: string);
    procedure AddReportOddEndCells;
    property BrowserTitle: string read FBrowserTitle write FBrowserTitle;
    property ReportTitle: string read FReportTitle write FReportTitle;
    property Template: string read GetTemplate;
  end;

const
  CCellwidth: SmallInt = 0;

implementation

{ TSimpleHTMLReportTemplate }

function TSimpleHTMLReportTemplate.GetTemplate: string;
begin
  Result :=
    '<?xml version="1.0" encoding="utf-8"?>' + sLineBreak +
    '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' + sLineBreak +
    '<html xmlns="http://www.w3.org/1999/xhtml">' + sLineBreak +
    '  <head>' + sLineBreak +
    '    <title>' + FBrowserTitle + '</title>' + sLineBreak +
    '    <meta http-equiv="Content-Type" content="utf-8" />' + sLineBreak +
    '    <style type="text/css">' + sLineBreak +
    '      body { font-family: verdana, helvetica, sans-serif; }' + sLineBreak +
    '      h2 { font-size: 130%; color: gray; }' + sLineBreak +
    '      th { text-align: center; }' + sLineBreak +
    '      .ReportOddDataRow { background-color: #dddddd; }' + sLineBreak +
    '      .ReportEvenDataRow { background-color: #eeeeee; }' + sLineBreak +
    '      .ReportTableHeaderCell { background-color: silver; color: white; font-size: 80%; }' + sLineBreak +
    '      .ReportTableValueCell { font-size: 80%; }' + sLineBreak +
    '    </style>' + sLineBreak +
    '  </head>' + sLineBreak +
    '  <body>' + sLineBreak +
    '    <h2>' + FReportTitle + '</h2>' + sLineBreak +
    '      <table>' + sLineBreak +
    '        <tr>' + sLineBreak +
               FReportTableHeaderCells.Text +
    '        </tr>' + sLineBreak +
               FReportValueCells.Text +
    '      </table>' + sLineBreak +
    '  </body>' + sLineBreak +
    '</html>';
end;

constructor TSimpleHTMLReportTemplate.Create;
begin
  FReportTableHeaderCells := TStringList.Create;
  FReportValueCells := TStringList.Create;
end;

destructor TSimpleHTMLReportTemplate.Destroy;
begin
  FReportTableHeaderCells.Free;
  FReportValueCells.Free;
  inherited Destroy;
end;

procedure TSimpleHTMLReportTemplate.AddReportTableHeaderCell(const ACaption: string);
begin
  FReportTableHeaderCells.Add(
    '          <th class="ReportTableHeaderCell" width="' + IntToStr(CCellwidth) + '%">' + ACaption + '</th>');
end;

procedure TSimpleHTMLReportTemplate.AddReportEvenBeginCells;
begin
  FReportValueCells.Add('        <tr class="ReportEvenDataRow">');
end;

procedure TSimpleHTMLReportTemplate.AddReportEvenValueCells(
  const ACaption: string);
begin
  FReportValueCells.Add('          <td class="ReportTableValueCell">' + ACaption + '</td>');
end;

procedure TSimpleHTMLReportTemplate.AddReportEvenEndCells;
begin
  FReportValueCells.Add('        </tr>');
end;

procedure TSimpleHTMLReportTemplate.AddReportOddBeginCells;
begin
  FReportValueCells.Add('        <tr class="ReportOddDataRow">');
end;

procedure TSimpleHTMLReportTemplate.AddReportOddValueCells(
  const ACaption: string);
begin
  FReportValueCells.Add('          <td class="ReportTableValueCell">' + ACaption + '</td>');
end;

procedure TSimpleHTMLReportTemplate.AddReportOddEndCells;
begin
  FReportValueCells.Add('        </tr>');
end;

end.

