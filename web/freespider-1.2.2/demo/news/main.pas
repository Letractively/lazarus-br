unit main; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, IBConnection, FileUtil, SpiderCGI, SpiderUtils,
  SpiderAction, SpiderForm, SpiderTable, db;

const
{$IFDEF UNIX}
  ExePath = '/cgi-bin/news';
{$ENDIF}

{$IFDEF WINDOWS}
  ExePath = '/cgi-bin/news.exe';
{$ENDIF}

type


  { TDataModule1 }

  TDataModule1 = class(TDataModule)
    IBConnection1: TIBConnection;
    saAdd: TSpiderAction;
    saDetail: TSpiderAction;
    SpiderCGI1: TSpiderCGI;
    sfAdd: TSpiderForm;
    sfSearch: TSpiderForm;
    stNews: TSpiderTable;
    SQLQuery1: TSQLQuery;
    sqNews: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure saAddRequest(Sender: TObject; Request: TSpiderRequest;
      var Response: TSpiderResponse);
    procedure saDetailRequest(Sender: TObject; Request: TSpiderRequest;
      var Response: TSpiderResponse);
    procedure SpiderCGI1Request(Sender: TObject; Request: TSpiderRequest;
      var Response: TSpiderResponse);
    procedure stNewsDrawDataCell(Sender: TObject; DataSet: TDataSet; ColCount,
      RowCount: Integer; var CellData, BgColor, ExtraParams: string);
  end; 

var
  DataModule1: TDataModule1; 

implementation

{$R *.lfm}

{ TDataModule1 }

procedure TDataModule1.SpiderCGI1Request(Sender: TObject;
  Request: TSpiderRequest; var Response: TSpiderResponse);
var
  SearchText: string;
begin
  SearchText:= Trim(Request.Form('search'));
  sfSearch.Action:= ExePath;
  sfSearch.AddText('Search');
  Response.Add('<html><header><title>News Center</title></header>');
  Response.Add('<body>');
  Response.Add('<h3>News center</h3>');
  Response.Add('<table width=100%><tr><td>');
  Response.Add('<a href="' + ExePath +'">Refresh</a></td><td>');

  // Search form
  sfSearch.AddInput(itText, 'search', SearchText, '', False);
  sfSearch.AddInput(itSubmit, '', 'Search', '', False);
  Response.Add(sfSearch.Contents);
  Response.Add('</td></tr></table>');
  Response.Add('<a href="' + ExePath + '/add">Add</a>');

  // News table
  if SearchText <> '' then  // Specify search criteria
    sqNews.SQL.Text:= 'select ID, NewsTime, Title, UserName, Readers from News where Lower(Title) like ''%' +
      LowerCase(SearchText) + '%'' or Lower(Text) like ''%' + LowerCase(SearchText) + '%'' order by ID desc'
  else // All data
    sqNews.SQL.Text:= 'select ID, NewsTime, Title, UserName, Readers from News ' +
                      'order by ID desc';
  sqNews.Open;
  sqNews.FieldByName('NewsTime').DisplayLabel:= 'Time';
  sqNews.FieldByName('Title').DisplayLabel:= 'Title';
  sqNews.FieldByName('Readers').DisplayLabel:= 'Viewed';
  sqNews.FieldByName('UserName').DisplayLabel:= 'By';
  Response.Add(stNews.Contents);
  sqNews.Close;
  Response.Add('<hr>');
  Response.Add('<font color=gray>Written by Motaz Abdel Azeem <a href="http://motaz.freevar.com">');
  Response.Add('motaz.freevar.com</a></font>');
  Response.Add('</body></html>');
end;

procedure TDataModule1.stNewsDrawDataCell(Sender: TObject; DataSet: TDataSet;
  ColCount, RowCount: Integer; var CellData, BgColor, ExtraParams: string);
begin
  if ColCount = 2 then
    CellData:= '<a href="' + ExePath + '/detail?id=' + DataSet.FieldByName('ID').AsString + '">' +
      CellData + '</a>';
end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  SpiderCGI1.Execute;
end;

procedure TDataModule1.saAddRequest(Sender: TObject; Request: TSpiderRequest;
  var Response: TSpiderResponse);
var
  UserName: string;
begin
  if Request.Form('submit') = '' then  // View form
  begin
    sfAdd.Action:= ExePath + '/add';
    sfAdd.AddText('Title');
    sfAdd.AddInput(itText, 'title', '', 'size=50');

    UserName:= Request.Cookies.Values['username'];
    sfAdd.AddText('User');
    sfAdd.AddInput(itText, 'user', UserName);

    sfAdd.AddText('Text');
    sfAdd.AddInput(itTextArea, 'text', '', 'rows=20, cols=60');

    sfAdd.AddInput(itSubmit, 'submit', 'Submit');

    Response.Add(sfAdd.Contents);
  end
  else // Check fields
  if (Trim(Request.Form('title')) = '') or (Trim(Request.Form('user')) = '') or
     (Trim(Request.Form('text')) = '') then
       Response.Add('You should fill all fields. Press browser''s back button to return to page')
  else
  begin  // Add new record
    SQLQuery1.SQL.Text:= 'insert into news (Title, Text, UserName, NewsTime, Category, Readers, UserAddress) ' +
      ' values (:Title, :Text, :UserName, CURRENT_TIMESTAMP, 0, 0, :UserAddress)';
    SQLQuery1.Params.ParamByName('Title').AsString:= Request.Form('title');
    SQLQuery1.Params.ParamByName('UserName').AsString:= Request.Form('user');
    SQLQuery1.Params.ParamByName('Text').AsString:= Request.Form('text');
    SQLQuery1.Params.ParamByName('UserAddress').AsString:= Request.RemoteAddress;
    SQLQuery1.ExecSQL;
    SQLTransaction1.Commit; // Save changes in database

    // Save username in cookies
    Response.SetCookie('username', Request.Form('user'), '/');

    Response.Add('A new record has been added<br/>');
    Response.Add('Click <a href="' + ExePath + '">here</a> to go to main news page');
  end;
end;

procedure TDataModule1.saDetailRequest(Sender: TObject;
  Request: TSpiderRequest; var Response: TSpiderResponse);
var
  NewsText: string;
  ID: Integer;
begin
  ID:= StrToInt(Request.Query('ID'));
  if ID < 0 then
  begin
    Randomize;
    ID:= Random(Abs(ID)) + 1;
  end;
  SQLQuery1.SQL.Text:= 'select * from news where ID = :ID';
  SQLQuery1.Params.ParamByName('ID').AsInteger:= ID;
  SQLQuery1.Open;

  with SQLQuery1 do
  begin
    Response.Add('<h3>' + FieldByName('Title').AsString + '</h3>');
    Response.Add('Time: ' + FieldByName('NewsTime').AsString + '<br/><br/>');
    NewsText:= FieldByName('Text').AsString;
    NewsText:= StringReplace(NewsText, #10, '<br/>', [rfReplaceAll]);
    Response.Add(NewsText + '<br/><br/>');
    Response.Add('By: <b>' + FieldByName('UserName').AsString + '<br/><br/>');
  end;
  SQLQuery1.Close;
  Response.Add('<a href="' + ExePath + '">Main</a>');

  // Increase readers count
  SQLQuery1.SQL.Text:= 'update News set Readers = Readers + 1 where ID = :ID';
  SQLQuery1.Params.ParamByName('ID').AsInteger:= ID;
  SQLQuery1.ExecSQL;
  SQLTransaction1.Commit;
end;

end.

