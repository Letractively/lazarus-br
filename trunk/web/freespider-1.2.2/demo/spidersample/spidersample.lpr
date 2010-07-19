program spidersample;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, Interfaces, main, MemDSLaz, SQLDBLaz, mod2, mod3;

begin
  DataModule1:= TDataModule1.Create(nil) ;
end.

