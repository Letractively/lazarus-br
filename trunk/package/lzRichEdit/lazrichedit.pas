{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit LazRichEdit; 

interface

uses
    WSlzRichEdit, lzRichEdit, lzRichEditFactory, lzRichEditTypes, 
  {$IFDEF Windows}Win_WSlzRichEdit, lzRichOle, RichOle, {$ENDIF}{$IFDEF LCLGtk2}GTK2_WSlzRichEdit, {$ENDIF}LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('lzRichEdit', @lzRichEdit.Register); 
end; 

initialization
  RegisterPackage('LazRichEdit', @Register); 
end.
