unit CalcUtils;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Dialogs;

procedure Calculate1(const AValue1, AValue2: Extended);
procedure Calculate2(const AValue1, AValue2: Extended);

implementation

procedure Calculate1(const AValue1, AValue2: Extended);
begin
  ShowMessage(FloatToStr(AValue1 + AValue2));
end;

procedure Calculate2(const AValue1, AValue2: Extended);
begin
  ShowMessage(FloatToStr(AValue1 * AValue2));
end;

end.

