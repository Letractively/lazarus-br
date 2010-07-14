{ This file was automatically created by Lazarus. do not edit!
  This source is only used to compile and install the package.
 }

unit dbmaskeditpkg; 

interface

uses
  DBMaskEdit, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('DBMaskEdit', @DBMaskEdit.Register); 
end; 

initialization
  RegisterPackage('dbmaskeditpkg', @Register); 
end.
