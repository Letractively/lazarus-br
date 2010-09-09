unit UContainer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, extctrls, Controls, LMessages, Types, WSForms;

type

{ TContainerScrollBar }

TContainerScrollBar=class(TControlScrollBar)
public
  procedure AutoCalcRange; override;
end;

{ TCustomContainer }

TCustomContainer = class(TPanel)
private
  FHorzScrollBar: TContainerScrollBar;
  FVertScrollBar: TContainerScrollBar;
  FAutoScroll: Boolean;
  FIsUpdating: Boolean;
  procedure SetHorzScrollBar(Value: TContainerScrollBar);
  procedure SetVertScrollBar(Value: TContainerScrollBar);
  function StoreScrollBars: Boolean;
protected
  class procedure WSRegisterClass; override;
  procedure AlignControls(AControl: TControl; var ARect: TRect); override;
  procedure CreateWnd; override;
  function GetClientScrollOffset: TPoint; override;
  function GetLogicalClientRect: TRect; override;// logical size of client area
  procedure DoOnResize; override;
  procedure WMHScroll(var Message : TLMHScroll); message LM_HScroll;
  procedure WMVScroll(var Message : TLMVScroll); message LM_VScroll;
  function ComputeScrollbars: Boolean; virtual;
  procedure ScrollbarHandler(ScrollKind: TScrollBarKind;
                             OldPosition: Integer); virtual;
  procedure SetAutoScroll(Value: Boolean); virtual;
  procedure Loaded; override;
  property AutoScroll: Boolean read FAutoScroll write SetAutoScroll default False;// auto show/hide scrollbars
  procedure SetAutoSize(Value: Boolean); override;
public
  constructor Create(TheOwner : TComponent); override;
  destructor Destroy; override;
  procedure UpdateScrollbars;
  function HasVisibleScrollbars: boolean; virtual;
  class function GetControlClassDefaultSize: TSize; override;
  procedure ScrollBy(DeltaX, DeltaY: Integer);
  //procedure SetInitialBounds(aLeft, aTop, aWidth, aHeight: integer); virtual;
published
  property HorzScrollBar: TContainerScrollBar
            read FHorzScrollBar write SetHorzScrollBar stored StoreScrollBars;
  property VertScrollBar: TContainerScrollBar
            read FVertScrollBar write SetVertScrollBar stored StoreScrollBars;
end;


implementation

{ TCustomContainer }

procedure TCustomContainer.SetHorzScrollBar(Value: TContainerScrollBar);
begin
  FHorzScrollbar.Assign(Value);
end;

procedure TCustomContainer.SetVertScrollBar(Value: TContainerScrollBar);
begin
    FVertScrollbar.Assign(Value);
end;

function TCustomContainer.StoreScrollBars: Boolean;
begin
    Result := not AutoScroll;
end;

class procedure TCustomContainer.WSRegisterClass;
begin
  inherited WSRegisterClass;
  RegisterScrollingWinControl;
end;

procedure TCustomContainer.AlignControls(AControl: TControl; var ARect: TRect);
begin
  if AutoScroll then
  begin
    if (HorzScrollBar = nil) or (VertScrollBar = nil) then Exit;
    inherited AlignControls(AControl, ARect);

    HorzScrollBar.AutoCalcRange;
    VertScrollBar.AutoCalcRange;
    UpdateScrollBars;
  end
  else
    inherited AlignControls(AControl, ARect);
end;

procedure TCustomContainer.CreateWnd;
begin
  DisableAutoSizing{$IFDEF DebugDisableAutoSizing}('TScrollingWinControl.CreateWnd'){$ENDIF};
  try
    inherited CreateWnd;
    UpdateScrollBars;
  finally
    EnableAutoSizing{$IFDEF DebugDisableAutoSizing}('TScrollingWinControl.CreateWnd'){$ENDIF};
  end;
end;

function TCustomContainer.GetClientScrollOffset: TPoint;
begin
  if (HorzScrollBar <> nil) and (VertScrollBar <> nil) then
  begin
    Result.X := HorzScrollBar.Position;
    Result.Y := VertScrollBar.Position;
  end else
  begin
    Result.X := 0;
    Result.Y := 0;
  end;
end;

function TCustomContainer.GetLogicalClientRect: TRect;
begin
  Result := ClientRect;
  {if (FHorzScrollBar.Range>Result.Right)
  or (FVertScrollBar.Range>Result.Bottom) then
    DebugLn(['TScrollingWinControl.GetLogicalClientRect Client=',ClientWidth,'x',ClientHeight,' Ranges=',FHorzScrollBar.Range,'x',FVertScrollBar.Range]);}
  if Assigned(FHorzScrollBar) and FHorzScrollBar.Visible
  and (FHorzScrollBar.Range > Result.Right) then
    Result.Right := FHorzScrollBar.Range;
  if Assigned(FVertScrollBar) and FVertScrollBar.Visible
  and (FVertScrollBar.Range > Result.Bottom) then
    Result.Bottom := FVertScrollBar.Range;
end;

procedure TCustomContainer.DoOnResize;
begin
  inherited DoOnResize;

  if AutoScroll then
  begin
    if (HorzScrollBar = nil) or (VertScrollBar = nil) then Exit;
    if HorzScrollBar.Visible or VertScrollBar.Visible then UpdateScrollBars;
  end;
end;

procedure TCustomContainer.WMHScroll(var Message: TLMHScroll);
begin
  //DebugLn(['TScrollingWinControl.WMHScroll ',dbgsName(Self)]);
  HorzScrollbar.ScrollHandler(Message);
end;

procedure TCustomContainer.WMVScroll(var Message: TLMVScroll);
begin
  VertScrollbar.ScrollHandler(Message);
end;

function TCustomContainer.ComputeScrollbars: Boolean;
// true if something changed
// update Page, AutoRange, Visible

  procedure UpdateRange(p_Bar: TContainerScrollBar);
  var
    SBSize: Longint;
    OtherScrollbar: TContainerScrollBar;
    OldAutoRange: LongInt;
  begin
    OldAutoRange := p_Bar.FAutoRange;
    p_Bar.FAutoRange := 0;
    OtherScrollbar := p_Bar.GetOtherScrollBar;
    if OtherScrollbar.FVisible then
      SBSize := OtherScrollbar.Size
    else
      SBSize := 0;
    if p_Bar.Kind = sbVertical then
      SBSize := ClientHeight - SBSize
    else
      SBSize := ClientWidth - SBSize;
    if (p_Bar.FRange > SBSize) and (SBSize > 0) then
      p_Bar.FAutoRange := (p_Bar.FRange - SBSize)
    else
      p_Bar.FAutoRange := 0;
    {$IFDEF VerboseScrollingWinControl}
    if p_Bar.DebugCondition then
      DebugLn(['UpdateRange p_Bar.fRange=',p_Bar.fRange,' SBSize=',SBSize,' ClientWidth=',ClientWidth,' FAutoRange=',p_Bar.FAutoRange]);
    {$ENDIF}
    if OldAutoRange <> p_Bar.FAutoRange then
      Result := True;
  end;

var
  NewPage: Integer;
begin
  Result := False;
  // page
  NewPage := Max(1,Min(ClientWidth - 1, High(HorzScrollbar.FPage)));
  if NewPage <> HorzScrollbar.FPage then
  begin
    HorzScrollbar.FPage := NewPage;
    Result := True;
  end;
  NewPage := Max(1,Min(ClientHeight - 1, High(VertScrollbar.FPage)));
  if NewPage <> VertScrollbar.FPage then
  begin
    VertScrollbar.FPage := NewPage;
    Result := True;
  end;
  // range
  UpdateRange(HorzScrollbar);
  UpdateRange(VertScrollbar);

end;

procedure TCustomContainer.ScrollbarHandler(ScrollKind: TScrollBarKind;
  OldPosition: Integer);
begin
  if ScrollKind = sbVertical then
    ScrollBy(0, FVertScrollBar.Position - OldPosition)
  else
    ScrollBy(FHorzScrollBar.Position - OldPosition, 0);
end;

procedure TCustomContainer.SetAutoScroll(Value: Boolean);
begin
  if FAutoScroll = Value then Exit;
  FAutoScroll := Value;
  if Value then
  begin
    HorzScrollBar.AutoCalcRange;
    VertScrollBar.AutoCalcRange;
  end;
  UpdateScrollBars;
end;

procedure TCustomContainer.Loaded;
begin
  inherited Loaded;
  UpdateScrollbars;
end;

procedure TCustomContainer.SetAutoSize(Value: Boolean);
begin
  if AutoSize=Value then exit;
  if Value then
    ControlStyle:=ControlStyle-[csAutoSizeKeepChildLeft,csAutoSizeKeepChildTop]
  else
    ControlStyle:=ControlStyle+[csAutoSizeKeepChildLeft,csAutoSizeKeepChildTop];
  inherited SetAutoSize(Value);
end;

constructor TCustomContainer.Create(TheOwner: TComponent);
begin
  Inherited Create(TheOwner);

  FAutoScroll := False;
  FVertScrollbar := TContainerScrollBar.Create(Self, sbVertical);
  FHorzScrollbar := TContainerScrollBar.Create(Self, sbHorizontal);

  ControlStyle := [csAcceptsControls, csClickEvents, csDoubleClicks,
                   csAutoSizeKeepChildLeft, csAutoSizeKeepChildTop];

  with GetControlClassDefaultSize do
    SetInitialBounds(0, 0, CX, CY);
end;

destructor TCustomContainer.Destroy;
begin
  FreeThenNil(FHorzScrollBar);
  FreeThenNil(FVertScrollBar);
  inherited Destroy;
end;

procedure TCustomContainer.UpdateScrollbars;
begin
  if ([csLoading, csDestroying] * ComponentState <> []) then Exit;
  if not HandleAllocated then Exit;
  if (HorzScrollBar = nil) or (VertScrollBar = nil) then Exit;

  if FIsUpdating then Exit;

  FIsUpdating := True;
  try
    if AutoScroll then
      ComputeScrollbars; // page, autorange, visible
    FVertScrollbar.UpdateScrollbar;
    FHorzScrollbar.UpdateScrollbar;
  finally
    FIsUpdating := False;
  end;
end;

function TCustomContainer.HasVisibleScrollbars: boolean;
begin
  Result := (VertScrollBar <> nil) and VertScrollBar.Visible and
            (HorzScrollBar <> nil) and HorzScrollBar.Visible;
end;

class function TCustomContainer.GetControlClassDefaultSize: TSize;
begin
  Result.CX := 150;
  Result.CY := 150;
end;

procedure TCustomContainer.ScrollBy(DeltaX, DeltaY: Integer);
begin
  if HandleAllocated then
  begin
    TWSScrollingWinControlClass(WidgetSetClass).ScrollBy(Self, DeltaX, DeltaY);
    Invalidate;
  end;
end;

{ TContainerScrollBar }

procedure TContainerScrollBar.AutoCalcRange;
begin
  inherited AutoCalcRange;
end;

end.

