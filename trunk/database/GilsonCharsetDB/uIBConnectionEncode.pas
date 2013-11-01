unit uIBConnectionEncode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, db, ibase60dyn;

type
   { TIBConnectionEncode }

  TIBConnectionEncode = class(TIBConnection)
  private
    FClientUTF8 : Boolean;
  protected
    function LoadField(cursor : TSQLCursor; FieldDef : TfieldDef; buffer : pointer; out CreateBlob : boolean) : boolean; override;
    //procedure Execute(cursor : TSQLCursor; atransaction : tSQLtransaction; AParams : TParams); override;
  public
    property ClientUTF8 : Boolean read FClientUTF8 write FClientUTF8;
  end;

 { TIBConnectionDefA }

  TIBConnectionDefA = Class(TIBConnectionDef)
  //public
    Class Function TypeName : String; override;
    Class Function ConnectionClass : TSQLConnectionClass; override;
  end;

implementation

{ TIBConnectionEncode }

function TIBConnectionEncode.LoadField(cursor : TSQLCursor; FieldDef : TfieldDef; buffer : pointer; out
  CreateBlob : boolean) : boolean;
begin
  Result := inherited LoadField(cursor, FieldDef, buffer, CreateBlob);
  if ClientUTF8 then
    if FieldDef.DataType in [ftString, ftMemo] then
      StrPLCopy(PChar(buffer), UTF8Encode(PChar(buffer)), FieldDef.Size);
end;

//procedure TIBConnectionEncode.Execute(cursor : TSQLCursor; atransaction : tSQLtransaction; AParams : TParams);
//begin
//  inherited Execute(cursor, atransaction, AParams);
//  if ClientUTF8 then
//    if FieldDef.DataType in [ftString, ftMemo] then
//      StrPLCopy(PChar(buffer), UTF8Encode(PChar(buffer)), FieldDef.Size);
//end;

{ TIBConnectionDefA }

class function TIBConnectionDefA.TypeName : String;
begin
  Result := 'FirebirdEncode';
end;

class function TIBConnectionDefA.ConnectionClass : TSQLConnectionClass;
begin
  Result := TIBConnectionEncode;
end;

initialization
  RegisterConnection(TIBConnectionDefA);

finalization
  UnRegisterConnection(TIBConnectionDefA);

end.

