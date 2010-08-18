{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit CEPLivrePkg; 

interface

uses
  CEPLivreReg, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('CEPLivreReg', @CEPLivreReg.Register); 
end; 

initialization
  RegisterPackage('CEPLivrePkg', @Register); 
end.
