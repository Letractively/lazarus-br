(*
  Cheques 2.1, Controle pessoal de cheques.
  Copyright (C) 2010-2012 Everaldo - arcanjoebc@gmail.com

  See the file LGPL.2.1_modified.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

(*
  Powerfull contributors:
  Silvio Clecio - http://blog.silvioprog.com.br
  Joao Morais   - http://blog.joaomorais.com.br
  Luiz Americo  - http://lazarusroad.blogspot.com
*)

unit ReportTemplate;

{$I cheques.inc}

interface

uses
  Classes, SysUtils, ChequeConsts;

type

  { TReportTemplate }

  TReportTemplate = class
  private
    FBrowserTitle: string;
    FReportTitle: string;
    FReportTableHeaderCells: TStringList;
    FReportValueCells: TStringList;
    FZoom: Integer;
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
    property Zoom: Integer read FZoom write FZoom;
  end;

const
  CCellwidth: SmallInt = 0;

implementation

{ TReportTemplate }

function TReportTemplate.GetTemplate: string;
const
  CReportTableValueCellFontSize = 110;
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
    '      .ReportTableHeaderCell { background-color: silver; color: white; font-size: ' + IntToStr(CReportTableValueCellFontSize + FZoom + 30) + '%; }' + sLineBreak +
    '      .ReportTableValueCell { font-size: ' + IntToStr(CReportTableValueCellFontSize + FZoom) + '%; }' + sLineBreak +
    '    </style>' + sLineBreak +
    '  </head>' + sLineBreak +
    '  <body>' + sLineBreak +
    '    <img src="' + CDocPath + 'about.png">' + sLineBreak +
    '    <h2>' + FReportTitle + '</h2><hr>' + sLineBreak +
    '      <table>' + sLineBreak +
    '        <tr>' + sLineBreak +
               FReportTableHeaderCells.Text +
    '        </tr>' + sLineBreak +
               FReportValueCells.Text +
    '      </table>' + sLineBreak +
    '    <hr>' +
    '  </body>' + sLineBreak +
    '</html>';
end;

constructor TReportTemplate.Create;
begin
  FReportTableHeaderCells := TStringList.Create;
  FReportValueCells := TStringList.Create;
  FZoom := 0;
end;

destructor TReportTemplate.Destroy;
begin
  FReportTableHeaderCells.Free;
  FReportValueCells.Free;
  inherited Destroy;
end;

procedure TReportTemplate.AddReportTableHeaderCell(const ACaption: string);
begin
  FReportTableHeaderCells.Add(
    '          <th class="ReportTableHeaderCell" width="' + IntToStr(CCellwidth) + '%">' + ACaption + '</th>');
end;

procedure TReportTemplate.AddReportEvenBeginCells;
begin
  FReportValueCells.Add('        <tr class="ReportEvenDataRow">');
end;

procedure TReportTemplate.AddReportEvenValueCells(const ACaption: string);
begin
  FReportValueCells.Add('          <td class="ReportTableValueCell">' + ACaption + '</td>');
end;

procedure TReportTemplate.AddReportEvenEndCells;
begin
  FReportValueCells.Add('        </tr>');
end;

procedure TReportTemplate.AddReportOddBeginCells;
begin
  FReportValueCells.Add('        <tr class="ReportOddDataRow">');
end;

procedure TReportTemplate.AddReportOddValueCells(const ACaption: string);
begin
  FReportValueCells.Add('          <td class="ReportTableValueCell">' + ACaption + '</td>');
end;

procedure TReportTemplate.AddReportOddEndCells;
begin
  FReportValueCells.Add('        </tr>');
end;

end.

