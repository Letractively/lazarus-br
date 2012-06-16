unit uGThread;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  { TGThread }
  TProcGThread = procedure (AThread : TThread) of object;

  TGThread = class(TThread)
  private
    FOnExecute : TProcGThread;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended : Boolean; AOnExecute : TProcGThread;
                                                                        const StackSize : SizeUInt = DefaultStackSize);
  end;

implementation

{ TGThread }

procedure TGThread.Execute;
begin
  if Assigned(FOnExecute) then
    FOnExecute(Self);
end;

constructor TGThread.Create(CreateSuspended : Boolean; AOnExecute : TProcGThread; const StackSize : SizeUInt);
begin
  FOnExecute := AOnExecute;
  inherited Create(CreateSuspended, StackSize);
end;

end.

