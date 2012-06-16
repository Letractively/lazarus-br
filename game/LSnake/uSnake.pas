unit uSnake;

{$mode objfpc}{$H+}

interface

uses
  windows, Classes, SysUtils, LCLType;

  type
    {$scopedenums on}
    TDirections = (UP, DOWN, LEFT, RIGHT);

    TBonus = record
      Pos : TPoint;
      Life : Integer;
    end;

    TPeca = record
      Pos : TPoint;
      Valid : Boolean;
    end;

    { TSnake }

    TSnake = class
    private
      FRuning : TThread;
      direcao : TDirections;
      corpo : array of TPoint;
      FErro : Integer;
      FOnPontos, FOnFim, FOnMoved : TNotifyEvent;
      FMoved : Boolean;
      Peca : TPeca;
      FPontos : Integer;
      fSpeed : Integer;
      Bonus : TBonus;
      //ExecSynchronize : procedure (Proc : TThreadMethod) of object;
  	  function checkPlacePeca : Boolean;
      procedure doMoveP(var p : TPoint);
      function getMoveP(const p : TPoint) : TPoint;
      procedure ExecMove;
      procedure AddPontos(const Value : Integer);
      procedure Run(Sender : TThread);
      procedure DoTerminado;
    public
    	WPanel, HPanel : Integer;
      Paused : Boolean;
      property Erro : Integer read FErro;
      property Pontos : Integer read FPontos;
      function GetPosPeca  : TPoint; inline;
      function GetPosBonus : TPoint; inline;
      procedure SetSeed(const Value : Integer);
      procedure New(ASpeed : Integer; AOnPontos, AOnFim, AOnMoved : TNotifyEvent);
      function GetRuning : Boolean;
      procedure Stop;
      function GetSize : Integer; inline;
      function GetPosAt(const i : Integer) : TPoint; inline;
      procedure SetDirecao(const Value : TDirections);
  end;

implementation

uses
  uGThread;

{ TSnake }

procedure TSnake.DoTerminado;
begin
  if Assigned(FOnFim) then
    FOnFim(Self);
end;

const
  SIZE = 5;

function TSnake.checkPlacePeca : Boolean;
var
  p : TPoint;
begin
  for p in corpo do
	  if PointsEqual(p, Peca.Pos) then
      Exit(True);

  Result := False;
end;

procedure TSnake.doMoveP(var p : TPoint);
begin
	  case direcao of
      TDirections.UP:
        begin
      		Dec(p.y);
      		if p.y < 0 then p.y := HPanel - 1;
        end;
      TDirections.DOWN:
        begin
      		Inc(p.y);
      		if p.y >= HPanel then p.y := 0;
        end;
      TDirections.LEFT:
        begin
      		Dec(p.x);
      		if p.x < 0 then p.x := WPanel - 1;
        end;
      TDirections.RIGHT:
        begin
      		Inc(p.x);
      		if p.x >= WPanel then p.x := 0;
        end;
    end;
end;

function TSnake.getMoveP(const p : TPoint) : TPoint;
begin
	Result := p;
	doMoveP(Result);
end;

procedure TSnake.ExecMove;
var
  p : TPoint;
  i : Integer;
begin
  i := High(corpo);
  if i < 0 then Exit;
	p := getMoveP(corpo[i]);

	if Bonus.Life > 0 then
  begin
    if PointsEqual(p, Bonus.Pos) then
    begin
		  AddPontos(30);
		  Bonus.Life := 0;
    end else if Bonus.Life <= fSpeed then
      Bonus.Life := 0
    else
      Dec(Bonus.Life, fSpeed);
  end else if Bonus.Life <= -5 then
  begin
    Bonus.Pos := Classes.Point(Random(WPanel-1), Random(HPanel - 1));
    Bonus.Life := 5000;
  end;

	if Peca.Valid and PointsEqual(p, Peca.Pos) then
  begin
    i := Length(corpo);
    SetLength(corpo, i + 1);
		corpo[i] := p;
		Peca.Valid := False;
		AddPontos(10);
    if Bonus.Life <= 0 then
		  Dec(Bonus.Life);
	end else
  begin
		for i := 0 to High(corpo) - 1 do
			corpo[i] := corpo[i+1];

    corpo[High(corpo)] := p;

	  for i := 0 to High(corpo) - 1 do
      if PointsEqual(p, corpo[i]) then
      begin
			  FErro := 1;
        Break;
      end;
  end;

  if not Peca.Valid then
  begin
    i := 10;
    repeat
      Peca.Pos := Classes.Point(Random(WPanel - 1), Random(HPanel - 1));
      Dec(i);
    until (i = 0) or not checkPlacePeca();
    Peca.Valid := i > 0;
  end;

	FMoved := True;

  if Assigned(FOnMoved) then
    FOnMoved(Self);
end;

procedure TSnake.AddPontos(const Value : Integer);
begin
  Inc(FPontos, Value);
  if Assigned(FOnPontos) then
    FOnPontos(Self)
end;

procedure TSnake.SetSeed(const Value : Integer);
begin
  if Value > 0 then
    FSpeed := 400 div Value;
end;

  {$DEFINE AUTO}

procedure TSnake.Run(Sender : TThread);
begin
  FRuning := Sender;
  try
    while FErro = 0 do
    begin
      Sleep(fSpeed);

      if not Paused then
	      TThread.Synchronize(Sender, @ExecMove);
    end;
  finally
    FRuning := nil;
  end;
  TThread.Synchronize(Sender, @DoTerminado);
end;

function TSnake.GetPosPeca : TPoint;
begin
  if Peca.Valid then
    Result := Peca.Pos
  else Result := Point(-1, -1);
end;

function TSnake.GetPosBonus : TPoint;
begin
  if Bonus.Life > 0 then
    Result := Bonus.Pos
  else Result := Point(-1, -1);
end;

procedure TSnake.New(ASpeed : Integer; AOnPontos, AOnFim,
  AOnMoved : TNotifyEvent);
var
  i : Integer;
begin
  if GetRuning then Exit;

  Randomize;

  FErro := 0;
	direcao := TDirections.RIGHT;
	SetLength(corpo, SIZE);
	FMoved := False;
	Peca.Valid := False;
	AddPontos(-FPontos);
	Paused := false;
  Bonus.Life := 0;
	for i := 0 to High(corpo) do
		corpo[i] := Classes.Point(i, i);

  FOnPontos := AOnPontos;
  FOnFim := AOnFim;
  FOnMoved := AOnMoved;

  if ASpeed < 1 then
    SetSeed(5)
  else SetSeed(ASpeed);

  {$IFDEF AUTO}
  with TGThread.Create(True, @Run) do
  begin
    FreeOnTerminate := True;
    Start;
  end;
  {$ENDIF}
end;

function TSnake.GetRuning : Boolean;
begin
  Result := FRuning <> nil;
end;

procedure TSnake.Stop;
begin
  if GetRuning then
    FErro := -1;
end;

function TSnake.GetSize : Integer;
begin
  Result := Length(corpo);
end;

function TSnake.GetPosAt(const i : Integer) : TPoint;
begin
  Result := corpo[i];
end;

procedure TSnake.SetDirecao(const Value : TDirections);
//var
//  s : String;
begin
  if Paused then Exit;
  if direcao <> Value then
  begin
    if not FMoved then
      ExecMove;

    FMoved := False;

    case direcao of
      TDirections.UP   : if Value = TDirections.DOWN then Exit;
      TDirections.DOWN : if Value = TDirections.UP then Exit;
      TDirections.LEFT : if Value = TDirections.RIGHT then Exit;
      TDirections.RIGHT: if Value = TDirections.LEFT then Exit;
    end;

    //WriteStr({%H-}s, Value);
    //DebugLn(s);
    direcao := Value;
  end;
  {$IFNDEF AUTO}
  move();
  {$ENDIF}
end;

end.

