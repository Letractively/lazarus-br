program test;

{$mode objfpc}{$H+}

uses
  Classes,
  SysUtils,
  DOM,
  XMLRead;

var
  VXML: TXMLDocument;
  VDOMNode: TDOMNode;
  VDOMElement: TDOMElement;

begin
  try
    ReadXMLFile(VXML, ExtractFilePath(ParamStr(0)) + 'codetools.lpk');
    VDOMElement := nil;
    // Take first node at 2 levels deep.
    VDOMNode := VXML.DocumentElement.FirstChild.FirstChild;
    while Assigned(VDOMNode) and not Assigned(VDOMElement) do
    begin
      // is it the node we want ?
      if (VDOMNode is TDOMElement) and (VDOMNode.NodeName = 'Version') then
        VDOMElement := VDOMNode as TDOMElement;
      // Go to next node at the same level.
      VDOMNode := VDOMNode.NextSibling;
    end;
    if Assigned(VDOMElement) then
      // Attributes available as default property of TDOMElement.
      Writeln(VDOMElement['Major'], '.', VDOMElement['Release']);
  finally
    VXML.Free;
  end;
end.

