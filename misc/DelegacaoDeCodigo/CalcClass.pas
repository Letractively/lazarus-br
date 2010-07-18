unit CalcClass;

{$mode objfpc}{$H+}

interface

type
  TCalcFunc1 = function(const AValue: Currency): Currency of object;
  TCalcFunc2 = procedure (const AValue1, AValue2: Extended);

implementation

end.
