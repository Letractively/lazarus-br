{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lazacpackage; 

interface

uses
    AuxVorbisFile, LazAC, LazAC_AO, LazAC_Ogg, LazAC_Proc, LazAC_Wav, 
  WAVTypes, Ogglib, Vorbislib, ao, os_types, LazAC_type, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('LazAC', @LazAC.Register); 
end; 

initialization
  RegisterPackage('LazACPackage', @Register); 
end.
