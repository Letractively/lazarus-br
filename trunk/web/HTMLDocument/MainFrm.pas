unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls, SysUtils;

type

  { TMainForm }

  TMainForm = class(TForm)
    GetButton: TButton;
    ResultMemo: TMemo;
    procedure GetButtonClick(Sender: TObject);
  end; 

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  DOM_HTML, DOM, SAX_HTML;

{ TMainForm }

procedure TMainForm.GetButtonClick(Sender: TObject);
var
  I: Integer;
  VTables: TDOMNodeList;
  VHTMLDocument: THTMLDocument;
begin
  VHTMLDocument := THTMLDocument.Create;
  try
    ReadHTMLFile(VHTMLDocument, ExtractFilePath(ParamStr(0)) + 'index.html');
    VTables := VHTMLDocument.GetElementsByTagName('table');
    ResultMemo.Clear;
    if VTables.Length > 0 then
      for I := 0 to Pred(VTables.Item[0].ChildNodes.Count) do
        ResultMemo.Lines.Add(VTables.Item[0].ChildNodes[I].TextContent);
  finally
    VHTMLDocument.Free;
  end;
end;

end.

