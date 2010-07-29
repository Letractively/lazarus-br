(*
  Cheques 2.1, Controle pessoal de cheques.
  Copyright (C) 2010-2012 Everaldo - arcanjoebc@gmail.com

  See the file LGPL.2.1_modified.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

(*
  Powerfull contributors:
  Silvio Clecio - http://blog.silvioprog.com.br
  Joao Morais   - http://blog.joaomorais.com.br
  Luiz Americo  - http://lazarusroad.blogspot.com
*)

program cheques;

{$I cheques.inc}

uses
{$ifdef heaptrc}
  heaptrc, {$ifdef unix}SysUtils,{$endif}
{$endif}
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Forms, Interfaces, MainFrm, MainDM;

{$R *.res}

begin
{$ifdef heaptrc}
{$ifdef unix}
  DeleteFile(ExtractFilePath(ParamStr(0)) + 'heaptrclog.trc');
  SetHeapTraceOutput(ExtractFilePath(ParamStr(0)) + 'heaptrclog.trc');
{$endif}
{$endif}
  Application.Title := 'Cheques 2.1';
  Application.Initialize;
  Application.CreateForm(TMainDataModule, MainDataModule);
  Application.CreateForm(TMainForm, MainForm);
{$ifndef SaveFormSettings}
  MainForm.MainXMLPropStorage.Active := False;
{$endif}
  Application.Run;
end.

