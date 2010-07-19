unit main;

{$mode objfpc}{$H+}


interface


uses
  Classes, SysUtils, SpiderCGI, SpiderUtils, SpiderTable, SpiderAction, memds,
  SpiderForm, SpiderPage;

const
{$IFDEF UNIX}
  ExePath = '/cgi-bin/spidersample';
{$ENDIF}

{$IFDEF WINDOWS}
  ExePath = '/cgi-bin/spidersample.exe';
{$ENDIF}

type

  { TDataModule1 }

  TDataModule1 = class(TDataModule)
    MemDataset1: TMemDataset;
    saManualTable: TSpiderAction;
    saDatasettable: TSpiderAction;
    saPage: TSpiderAction;
    saupload: TSpiderAction;
    saHello: TSpiderAction;
    SpiderCGI1: TSpiderCGI;
    SpiderForm1: TSpiderForm;
    sfUpload: TSpiderForm;
    SpiderPage1: TSpiderPage;
    SpiderTable1: TSpiderTable;
    SpiderTable2: TSpiderTable;
    procedure DataModuleCreate(Sender: TObject);
    procedure saDatasettableRequest(Sender: TObject; Request: TSpiderRequest;
      var Response: TSpiderResponse);
    procedure saHelloRequest(Sender: TObject; Request: TSpiderRequest;
      var Response: TSpiderResponse);
    procedure saManualTableRequest(Sender: TObject; Request: TSpiderRequest;
      var Response: TSpiderResponse);
    procedure saPageRequest(Sender: TObject; Request: TSpiderRequest;
      var Response: TSpiderResponse);
    procedure sauploadRequest(Sender: TObject; Request: TSpiderRequest;
      var Response: TSpiderResponse);
    procedure SpiderCGI1Request(Sender: TObject; Request: TSpiderRequest;
      var Response: TSpiderResponse);
    procedure SpiderPage1Tag(Sender: TObject; ATag: string;
      var TagReplacement: string);
  end; 


var
  DataModule1: TDataModule1; 

implementation

{$R *.lfm}



{ TDataModule1 }

procedure TDataModule1.SpiderCGI1Request(Sender: TObject;
  Request: TSpiderRequest; var Response: TSpiderResponse);
begin
  Response.Add('<html><title>Free Spider Web Application Sample</title><body>');
  Response.Add('<h2>Free Spider <font color=blue>Sample</font></h2>');

  Response.Add('<P STYLE="background: #b3b3b3">');
  Response.Add('<font size="-2">');
  Response.Add('Current server time is: <b>' + DateTimeToStr(Now) + '</b><br/>');
  Response.Add('Your browser is: <font color=blue>' + Request.UserAgent + '</font><br/>');
  Response.Add('Your IP address is: <font color=blue>' + Request.RemoteAddress + '</font><br/>');

  Response.Add('</font></p>');

  Response.Add('<hr>');

  // Main module
  Response.Add('<a href="' + ExePath + '/hello">Hello World (SpiderAction)</a><br/>');
  Response.Add('<a href="' + ExePath + '/manualtable">Manual Table (SpiderTable)</a><br/>');
  Response.Add('<a href="' + ExePath + '/datasettable">Dataset Table (SpiderTable)(SpiderForm)</a><br/>');
  Response.Add('<a href="' + ExePath + '/page">Page Template(SpiderPage)</a><br/>');
  Response.Add('<a href="' + ExePath + '/upload">Upload/Download file(SpiderForm/Multipart decoder)</a><br/>');


  // Mod2
  Response.Add('<hr>');
  Response.Add('<a href="' + ExePath + '/color">Colour Table (Smart Module Loading design, action exist in Mod2)</a><br/>');
  Response.Add('<a href="' + ExePath + '/mod2ac2">Action2 in Mod2 (Smart Module Loading design, action exist in Mod2)</a><br/>');

  // Mod3
  Response.Add('<hr>');
  Response.Add('<a href="' + ExePath + '/mod3ac1">Module 3 Action 1 (Smart Module Loading design, action exist in Mod3)</a><br/>');
  Response.Add('<a href="' + ExePath + '/cookies">Cookies reader / Writer (Smart Module Loading design, action exist in Mod3)</a><br/>');

  Response.Add('<hr><i><font size="-4" color=gray>By Motaz Abdel Azeem 2009</font></i>');
  Response.Add('</body></html>');
end;

procedure TDataModule1.SpiderPage1Tag(Sender: TObject; ATag: string;
  var TagReplacement: string);
begin
  if ATag = 'time' then
    TagReplacement:= DateTimeToStr(Now)
  else
  if ATag = 'table' then
  begin
    if FileExists('sub.dat') then
      MemDataset1.LoadFromFile('sub.dat');
    MemDataset1.Open;
    MemDataset1.FieldByName('SubName').DisplayLabel:= 'Name';
    MemDataset1.FieldByName('Address').Visible:= False;
    TagReplacement:= SpiderTable2.Contents;
  end
  else
  if ATag = 'home' then
    TagReplacement:= '<a href="./">Main</a>'
  else
  if ATag = 'month' then
    TagReplacement:= FormatDateTime('mmm', Now)
  else
  if ATag = 'year' then
    TagReplacement:= FormatDateTime('yyyy', Now);
end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  SpiderCGI1.AddDataModule('TdmMod2', ['/color', '/mod2ac2']);
  SpiderCGI1.AddDataModule('TdmMod3', ['/mod3ac1', '/cookies']);

  SpiderCGI1.Execute;
end;

procedure TDataModule1.saDatasettableRequest(Sender: TObject;
  Request: TSpiderRequest; var Response: TSpiderResponse);
begin

  SpiderForm1.Action:= ExePath + '/datasettable';
  SpiderForm1.AddText('Enter Subscriber ID: ');
  SpiderForm1.AddInput(itText, 'id', '');

  SpiderForm1.AddText('Enter Subscriber Name: ');
  SpiderForm1.AddInput(itText, 'subname', '');

  SpiderForm1.AddText('Address: ');
  SpiderForm1.AddInput(itText, 'address', '');

  SpiderForm1.AddText('Telephone Number: ');
  SpiderForm1.AddInput(itText, 'telephone', '');

  SpiderForm1.AddInput(itSubmit, 'add', 'Add');


  Response.Add(SpiderForm1.Contents);

  if FileExists('sub.dat') then
    MemDataset1.LoadFromFile('sub.dat');

  MemDataset1.Open;

  if Request.ContentFields.IndexOfName('add') <> -1 then
  begin
    Response.Content.Add('Saving data..');
    MemDataset1.Append;
    MemDataset1.FieldByName('ID').AsString:= Request.Form('id');
    MemDataset1.FieldByName('SubName').AsString:= Request.Form('subname');
    MemDataset1.FieldByName('Address').AsString:= Request.Form('address');
    MemDataset1.FieldByName('Telephone').AsString:= Request.Form('telephone');
    MemDataset1.Post;
    MemDataset1.SaveToFile('sub.dat');
  end;
  Response.Add(SpiderTable2.Contents);
  Response.Add('<hr><a href="./">Main</a>');

end;

procedure TDataModule1.saHelloRequest(Sender: TObject; Request: TSpiderRequest;
  var Response: TSpiderResponse);
begin
  Response.Add('<font color=green>Hello world</font> from FreeSpider Package for Lazarus<br/>');
  Response.Add('The best way for Web development in <b>FreePascal/Lazarus</b>');
end;

procedure TDataModule1.saManualTableRequest(Sender: TObject;
  Request: TSpiderRequest; var Response: TSpiderResponse);
begin

  Response.Add('<html><head><title>Manual Table</title>');
  Response.Add('<style type="text/css">');
  Response.Add('SpiderTable1.cssClass = "myCssClassForTable" ; ' +
    'CSSHeaderTableClass (' +
    'cssClass = "myCssClassForHeader"; ' +
    'array of CSSCellTableClass = CSSCellTableClass("Telephone Number"); ) ' +

    'CSSRowTableClass (' +
    'cssClass = "myCssClassForRow";' +
    'array of CSSCellTableClass ; ) ' +

    'CSSCellTableClass ( ' +
    'cssClass = "myCssClassForCell"; text = "01754341";  ))');
   Response.Add('</style>');


  Response.Add('</head><body>');

  SpiderTable1.ColumnCount:= 3;
  SpiderTable1.TableExtraParams:= 'class="myCssClassForTable"';
  SpiderTable1.HeaderExtraParams:= 'class="myCssClassForHeader"';

  SpiderTable1.SetHeader(['ID', 'Name', 'Telephone Number']);
  SpiderTable1.AddRow(['1', 'Mohammed', '01223311']);
  SpiderTable1.AddRow('#FFEEDD', 'class="myCssClassForCell"', ['2', 'Ahmed', '01754341']);
  SpiderTable1.AddRow('#FFDDEE', ['3', 'Omer', '045667890']);
  Response.Add(SpiderTable1.Contents);

  Response.Add('<br/><br/>This is the code of adding this table:<br/><br/>');


  Response.Add('<font face="Courier New" color=blue size="-2">');
  Response.Add('<P STYLE="background: #b3b3b3">');
  Response.Add('SpiderTable1.SetHeader([''ID'', ''Name'', ''Telephone Number'']);<br/>');
  Response.Add('SpiderTable1.AddRow('''', [''1'', ''Mohammed'', ''01223311'']);<br/>');
  Response.Add('SpiderTable1.AddRow(''#FFEEDD'', [''2'', ''Ahmed'', ''01754341'']);<br/>');
  Response.Add('SpiderTable1.AddRow(''#FFDDEE'', [''3'', ''Omer'', ''045667890'']);<br/>');
  Response.Add('Response.Content.Add(SpiderTable1.Contents);<br/>');
  Response.Add('</font></p>');
  Response.Add('<hr><a href="' + ExePath + '">Home</a></body></html>');

end;

procedure TDataModule1.saPageRequest(Sender: TObject; Request: TSpiderRequest;
  var Response: TSpiderResponse);
begin
  Response.Content.Add(SpiderPage1.Contents);
end;

procedure TDataModule1.sauploadRequest(Sender: TObject;
  Request: TSpiderRequest; var Response: TSpiderResponse);
begin

  if (Request.ContentFields.IndexOfName('upload') <> -1) and // Download uploaded file
     (Request.FilesCount = 1) then
  begin
    Response.ContentType:= Request.ContentFiles[0].ContentType;
    Response.CustomHeader.Add('Content-Disposition: filename="' + Request.ContentFiles[0].FileName + '"');
    Response.Add(Request.ContentFiles[0].FileContent);
    Response.SetCookie('LastUploadedFile', Request.ContentFiles[0].FileName, '/');

  end
  else // View upload form
  begin

    Response.Add('<h2>File Upload sample</h2>');
    Response.Add('Please select a file to be uploaded to the server<br/>');
    Response.Add('This file will be downloaded after the upload is successed<br/><br/>');
    Response.Add('<font color=gray>An automatic multipart encoded page will be detected from FreeSpider package ');
    Response.Add(' and will be decoded automatically</font><br/><br/>');

    sfUpload.Action:= ExePath + '/upload';
    sfUpload.AddInput(itFile, 'upload');
    sfUpload.AddInput(itSubmit, 'upload', 'Upload');
    Response.Add(sfUpload.Contents);
    Response.Add('<hr><a href="' + ExePath + '">Home</a>');
  end;
end;

initialization
  DataModule1:= TDataModule1.Create(nil);

end.

