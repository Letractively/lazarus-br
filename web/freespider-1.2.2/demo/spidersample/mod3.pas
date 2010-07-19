unit mod3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SpiderAction, SpiderUtils;

type

  { TdmMod3 }

  TdmMod3 = class(TDataModule)
    SpiderAction1: TSpiderAction;
    SpiderAction2: TSpiderAction;
    procedure SpiderAction1Request(Sender: TObject; Request: TSpiderRequest;
      var Response: TSpiderResponse);
    procedure SpiderAction2Request(Sender: TObject; Request: TSpiderRequest;
      var Response: TSpiderResponse);
  end; 

var
  dmMod3: TdmMod3;

implementation

{$R *.lfm}

{ TdmMod3 }

procedure TdmMod3.SpiderAction1Request(Sender: TObject;
  Request: TSpiderRequest; var Response: TSpiderResponse);
begin
  Response.Add('<h2>Mod3 Action 1</h2>');
  Response.Add('Don''t forget to add this module unit name in main module uses clause like:<br/><br/>');
  Response.Add('<font color=blue face="Courier New">uses<br/>');
  Response.Add('&emsp;&emsp; Mod2, Mod3;</font>');
  Response.Add('<hr><a href="./">Main</a>');


end;

procedure TdmMod3.SpiderAction2Request(Sender: TObject;
  Request: TSpiderRequest; var Response: TSpiderResponse);
begin
  Response.Add('Your set cookies are: <font color=blue>');
  Response.Add(Request.Cookies.Text + '</font>');
  Response.Add('<hr><a href="./">Main</a>');

  Randomize;
  Response.SetCookie('RandomSession', IntToStr(Random(1000)), '/');
end;

initialization
  RegisterClass(TdmMod3);

end.

