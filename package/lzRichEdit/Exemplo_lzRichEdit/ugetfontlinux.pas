unit UGetFontLinux;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Process;

procedure GetFontList(var iLines: TStringList);
const
  READ_BYTES = 2048;

implementation

procedure GetFontList(var iLines: TStringList);
 var
   S:String;
   Stream: TMemoryStream;
   iProcess: TProcess;
   n: LongInt;
   BytesRead: LongInt;
   I:Integer;
 begin

   Stream := TMemoryStream.Create;
   BytesRead := 0;

   iProcess := TProcess.Create(nil);
   iProcess.CommandLine := 'fc-list';
   iProcess.Options := [poUsePipes];
   iProcess.Execute;
   //--
   while iProcess.Running do
   begin
     Stream.SetSize(BytesRead + READ_BYTES);
     n := iProcess.Output.Read((Stream.Memory + BytesRead)^, READ_BYTES);
     if n > 0 then
       Inc(BytesRead, n)
     else
       Sleep(100);
   end;
   repeat
     Stream.SetSize(BytesRead + READ_BYTES);
     n := iProcess.Output.Read((Stream.Memory + BytesRead)^, READ_BYTES);
     if n > 0 then Inc(BytesRead, n);
   until n <= 0;

   Stream.SetSize(BytesRead);
   iLines.LoadFromStream(Stream);

   iProcess.Free;
   Stream.Free;
 ILines.Add('Sans');
 //--
 for n:= 0 to iLines.Count -1 do
 begin
   I:=0;
   I:=  Pos(':', iLines[n]);
   if (I > 0) then iLines[n]:= copy(iLines[n], 1, I -1);
   I:=0;
   I:=  Pos(',', iLines[n]);
   if (I > 0) then iLines[n]:= copy(iLines[n], 1, I -1);
   I:=0;
   I:=  Pos('\', iLines[n]);
   if (I > 0) then
     begin
       S:= iLines[n];
       //S[I]:= ' ';
       Delete(S, I, 1);
       iLines[n]:= S;
     end;
 end;
 end;
end.

