{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit packagelazac; 

interface

uses
  WAVTypes, WavProc, plugin, ao, os_types, LazAC, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('LazAC', @LazAC.Register); 
end; 

initialization
  RegisterPackage('PackageLazAC', @Register); 
end.
