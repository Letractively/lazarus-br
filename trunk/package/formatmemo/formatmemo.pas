{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit formatmemo; 

interface

uses
  FMemo, FMemo_GKT2, FMemo_Type, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('FMemo', @FMemo.Register); 
end; 

initialization
  RegisterPackage('FormatMemo', @Register); 
end.
