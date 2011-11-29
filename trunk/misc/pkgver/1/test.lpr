program test;

{$mode objfpc}{$H+}

uses
  Classes,
  SysUtils,
  DOM,
  XMLRead;

var
  VXML: TXMLDocument;
  VDOMElement: TDOMElement;
begin
  try
    ReadXMLFile(VXML, ExtractFilePath(ParamStr(0)) + 'codetools.lpk');
    VDOMElement := TDOMElement(VXML.GetElementsByTagName('Version').Item[1]);
    writeln(VDOMElement['Major'], '.', VDOMElement['Release']);
  finally
    VXML.Free;
  end;
end.

