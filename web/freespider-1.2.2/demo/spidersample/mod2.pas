unit mod2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SpiderAction, SpiderUtils, SpiderTable;

type

  { TdmMod2 }

  TdmMod2 = class(TDataModule)
    SpiderAction1: TSpiderAction;
    SpiderAction2: TSpiderAction;
    SpiderTable1: TSpiderTable;
    procedure SpiderAction1Request(Sender: TObject; Request: TSpiderRequest;
      var Response: TSpiderResponse);
    procedure SpiderAction2Request(Sender: TObject; Request: TSpiderRequest;
      var Response: TSpiderResponse);
  end; 

var
  dmMod2: TdmMod2;

implementation

{$R *.lfm}

{ TdmMod2 }

procedure TdmMod2.SpiderAction1Request(Sender: TObject;
  Request: TSpiderRequest; var Response: TSpiderResponse);
begin
  Response.Add('<h2>Colour Table</h2>');
  Response.Add('<font color=gray size=2>This response is from a SpiderAction in Mod2 Module. This module and it''s ');
  Response.Add('components will be loaded into memory only when at least one action link ');
  Response.Add('<i>that belong to this module</i> has been clicked, otherwise this module will never be loaded ');
  Response.Add('into memory to reduce memory consumption and faster loading for this web application and then ');
  Response.Add('<font color=purple>faster response time</font>. This method in FreeSpider tool is called <font color=purple>');
  Response.Add('<i>Smart Module Loading Design</i></font></font><br/><br/>');
  SpiderTable1.SetColumnCount(2);
  SpiderTable1.HeaderColor:= '#AAAAAA';
  SpiderTable1.SetHeader(['Colour', 'Code']);
  SpiderTable1.AddRow('#FFFFFF', ['White', '#FFFFFF']);
  SpiderTable1.AddRow('#999999', ['Gray', '#999999']);
  SpiderTable1.AddRow('#000000', ['<font color=white>Black</font>', '<font color=white>#000000</font>']);

  SpiderTable1.AddRow('#66FF66', ['Green', '#66FF66']);
  SpiderTable1.AddRow('#DDFFDD', ['Bright Green', '#DDFFDD']);
  SpiderTable1.AddRow('#009900', ['Dark Green', '#009900']);

  SpiderTable1.AddRow('#FF2222', ['Red', '#FF2222']);
  SpiderTable1.AddRow('#FFAAAA', ['Bright Red', '#FFAAAA']);
  SpiderTable1.AddRow('#990000', ['Dark Red', '#990000']);

  SpiderTable1.AddRow('#2222FF', ['Blue', '#2222FF']);
  SpiderTable1.AddRow('#AAAAFF', ['Bright Blue', '#AAAAFF']);
  SpiderTable1.AddRow('#000099', ['Dark Blue', '#000099']);

  SpiderTable1.AddRow('#FFFF00', ['Yellow', '#FFFF00']);
  SpiderTable1.AddRow('#AA7722', ['Brown', '#AA7722']);
  SpiderTable1.AddRow('#FF00FF', ['Magenta', '#FF00FF']);


  Response.Add(SpiderTable1.Contents);

  Response.Add('<hr><a href="./">Main</a>');

end;

procedure TdmMod2.SpiderAction2Request(Sender: TObject;
  Request: TSpiderRequest; var Response: TSpiderResponse);
begin
  Response.Add('<h2>Mod2 Action2</h2>');
  Response.Add('This is another action in Module2 using Smart Module Loading Design, you should register module class in ');
  Response.Add('initialization section of secondary modules like this: <br><br>');
  Response.Add('<font color=blue face="Courier New">initialization <br> &emsp;&emsp;RegisterClass(TdmMod2);</font>');
  Response.Add('<hr><a href="./">Main</a>');
end;

initialization
  RegisterClass(TdmMod2);

end.

