(*
  LazListMediaDisc.pas, List media discs
  Copyright (C) 2010-2012 Silvio Clécio - admin@silvioprog.com.br

  http://blog.silvioprog.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit LazListMediaDisc;

{$mode objfpc}{$H+}

interface

uses
{$IFDEF UNIX}
  Process,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Classes, ExtCtrls, LCLIntf;

type

  { TLazListMediaDisc }

  TLazListMediaDisc = class
  private
    FTimer: TTimer;
    FAvailableDiscs: string;
    FOnListAvailableDiscs: TNotifyEvent;
    procedure OnTimer(Sender: TObject);
    procedure SetOnListAvailableDiscs(const AValue: TNotifyEvent);
  public
    constructor Create;
    destructor Destroy; override;
    class procedure OpenDisc(const ADisc: string);
    property AvailableDiscs: string read FAvailableDiscs write FAvailableDiscs;
    property OnListAvailableDiscs: TNotifyEvent read FOnListAvailableDiscs write SetOnListAvailableDiscs;
  end;

function ListAvailableMediaDiscs: string;
function LazListMediaDiscInstance: TLazListMediaDisc;

implementation

var
  _LazListMediaDisc: TLazListMediaDisc;

function ListAvailableMediaDiscs: string;
var
{$IFDEF UNIX}
  VProcess: TProcess;
  VStrTemp: TStringList;
{$ENDIF}
{$IFDEF MSWINDOWS}
  I: Byte;
  VDrives: LongWord;
{$ENDIF}
begin
{$IFDEF UNIX}
  VProcess := TProcess.Create(nil);
  VStrTemp := TStringList.Create;
  try
    VProcess.CommandLine := 'ls /dev/disk/by-label';
    VProcess.Options := [poUsePipes, poWaitOnExit];
    VProcess.Execute;
    VStrTemp.LoadFromStream(VProcess.Output);
    Result := VStrTemp.Text;
  finally
    VProcess.Free;
    VStrTemp.Free;
  end;
{$ENDIF}
{$IFDEF MSWINDOWS}
  VDrives := GetLogicalDrives;
  if VDrives <> 0 then
    for I := 65 to 90 do
      if ((VDrives shl (31 - (I - 65))) shr 31) = 1 then
        Result := Result + Char(I) + ':' + sLineBreak;
{$ENDIF}
end;

function LazListMediaDiscInstance: TLazListMediaDisc;
begin
  if not Assigned(_LazListMediaDisc) then
    _LazListMediaDisc := TLazListMediaDisc.Create;
  Result := _LazListMediaDisc;
end;

{ TLazListMediaDisc }

procedure TLazListMediaDisc.OnTimer(Sender: TObject);
begin
  if FAvailableDiscs <> ListAvailableMediaDiscs then
  begin
    FAvailableDiscs := ListAvailableMediaDiscs;
    OnListAvailableDiscs(Self);
  end;
end;

procedure TLazListMediaDisc.SetOnListAvailableDiscs(const AValue: TNotifyEvent);
begin
  if FOnListAvailableDiscs <> AValue then
  begin
    FOnListAvailableDiscs := AValue;
    FTimer.OnTimer(Self);
  end;
end;

constructor TLazListMediaDisc.Create;
begin
  FTimer := TTimer.Create(nil);
  FTimer.OnTimer := @OnTimer;
  FTimer.Interval := 5000;
end;

destructor TLazListMediaDisc.Destroy;
begin
  FTimer.Free;
  inherited Destroy;
end;

class procedure TLazListMediaDisc.OpenDisc(const ADisc: string);
begin
  if ADisc <> '' then
    OpenURL({$IFDEF UNIX}'/media/' +{$ENDIF} ADisc);
end;

initialization

finalization
  if Assigned(_LazListMediaDisc) then
    _LazListMediaDisc.Free;

end.
