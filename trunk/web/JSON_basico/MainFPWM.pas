unit MainFPWM;

{$mode objfpc}{$H+}

interface

uses
  ZConnection, ZDataset, HTTPDefs, fpHTTP, fpWeb, FpJSON;

type

  { TMainFPWebModule }

  TMainFPWebModule = class(TFPWebModule)
    MainZConnection: TZConnection;
    TestZQuery: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
  end;

var
  MainFPWebModule: TMainFPWebModule;

implementation

{$R *.lfm}

{ TMainFPWebModule }

procedure TMainFPWebModule.DataModuleRequest(Sender: TObject;
  ARequest: TRequest; AResponse: TResponse; var Handled: Boolean);
var
  VPerson: TJSONObject;
  VJSON: TJSONObject;
  VJSONArray: TJSONArray;
begin
  Handled := True;
  TestZQuery.SQL.Text := 'select * from cliente';
  TestZQuery.Open;
  TestZQuery.First;
  VJSONArray := TJSONArray.Create;
  VJSON := TJSONObject.Create;
  try
    while not TestZQuery.EOF do
    begin
      VPerson := TJSONObject.Create;
      VPerson.Add('Nome',
        TJSONString.Create(TestZQuery.FieldByName('nome').AsString));
      VPerson.Add('Apelido',
        TJSONString.Create(TestZQuery.FieldByName('apelido').AsString));
      VPerson.Add('Idade',
        TJSONIntegerNumber.Create(TestZQuery.FieldByName('idade').AsInteger));
      VPerson.Add('Telefone',
        TJSONString.Create(TestZQuery.FieldByName('telefone').AsString));
      TestZQuery.Next;
      VJSONArray.Add(VPerson);
    end;
    VJSON.Add('rows', VJSONArray);
    AResponse.Content :=
      '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">' + LineEnding +
      '<html>' + LineEnding +
      '<head>' + LineEnding +
      '<title>JSON test</title>' + LineEnding + LineEnding +
      '<script src="/scripts/jquery-1.5.1.min.js" type=' + LineEnding +
      '"text/javascript">' + LineEnding +
      '</script>' + LineEnding +
      '<script src="/scripts/json.htmTable.js" type="text/javascript">' + LineEnding +
      '</script>' + LineEnding +
      '<link href="/styles/default.css" rel="stylesheet" type="text/css">' + LineEnding +
      '<script type="text/javascript">' + LineEnding +
      '    $(document).ready(function() {' + LineEnding +
      '    var json1 = ' + VJSON.AsJSON + LineEnding +
      '    $(''#DynamicGridLoading'').hide();' + LineEnding +
      '    $(''#DynamicGrid'').append(CreateDetailView(json1.rows, "lightPro", true)).fadeIn();' + LineEnding +
      '    });' + LineEnding +
      '</script>' + LineEnding +
      '</head>' + LineEnding +
      '<body>' + LineEnding +
      '<form id="Form1" name="Form1" action="POST">' + LineEnding +
      '<div id="DynamicGrid">' + LineEnding +
      '<div id="DynamicGridLoading"><img src="/images/loading.gif" alt=' + LineEnding+
      '"Loading data"><span>Loading...</span></div>' + LineEnding +
      '</div>' + LineEnding +
      '</form>' + LineEnding +
      '</body>' + LineEnding +
      '</html>';
  finally
    VJSON.Free;
  end;
end;

procedure TMainFPWebModule.DataModuleCreate(Sender: TObject);
begin
  MainZConnection.Connect;
end;

initialization
  RegisterHTTPModule('TMainFPWebModule', TMainFPWebModule);

end.

