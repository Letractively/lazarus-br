program grabby;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, Unit1, unit2;

{$R *.res}

begin
  Application.Title:='Grabby';
  Application.Initialize;
  application.createform(tfrmmain, frmmain);
  application.createform(tfrmoptions, frmoptions);
  Application.Run;
end.

