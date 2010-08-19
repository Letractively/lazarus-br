(*
  Original file: >fpc>{FPCVERSION}>source>packages>fcl-db>src>sdf>sdfdata.pp
*)

{$HINTS OFF}
{$WARNINGS OFF}

unit mysdfdata;

{$mode objfpc}{$h+}

interface

uses
  DB, Classes, SysUtils;

type
  PRecInfo = ^TRecInfo;

  TRecInfo = packed record
    RecordNumber: PtrInt;
    BookmarkFlag: TBookmarkFlag;
  end;

  TCustomFixedFormatDataSet = class(TDataSet)
  private
    FSchema: TStringList;
    FFileName: TFileName;
    FFilterBuffer: PChar;
    FFileMustExist: Boolean;
    FReadOnly: Boolean;
    FLoadfromStream: Boolean;
    FTrimSpace: Boolean;
    procedure SetSchema(const Value: TStringList);
    procedure SetFileName(Value: TFileName);
    procedure SetFileMustExist(Value: Boolean);
    procedure SetTrimSpace(Value: Boolean);
    procedure SetReadOnly(Value: Boolean);
    procedure RemoveWhiteLines(List: TStrings; IsFileRecord: Boolean);
    procedure LoadFieldScheme(List: TStrings; MaxSize: Integer);
    function GetActiveRecBuf(var RecBuf: PChar): Boolean;
    procedure SetFieldPos(var Buffer: PChar; FieldNo: Integer);
  protected
    FData: TStringList;
    FCurRec: Integer;
    FRecBufSize: Integer;
    FRecordSize: Integer;
    FLastBookmark: PtrInt;
    FRecInfoOfs: Integer;
    FBookmarkOfs: Integer;
    FSaveChanges: Boolean;
    FDefaultRecordLength: cardinal;
    function AllocRecordBuffer: PChar; override;
    procedure FreeRecordBuffer(var Buffer: PChar); override;
    procedure InternalAddRecord(Buffer: Pointer; DoAppend: Boolean); override;
    procedure InternalClose; override;
    procedure InternalDelete; override;
    procedure InternalFirst; override;
    procedure InternalGotoBookmark(ABookmark: Pointer); override;
    procedure InternalHandleException; override;
    procedure InternalInitFieldDefs; override;
    procedure InternalInitRecord(Buffer: PChar); override;
    procedure InternalLast; override;
    procedure InternalOpen; override;
    procedure InternalPost; override;
    procedure InternalEdit; override;
    procedure InternalSetToRecord(Buffer: PChar); override;
    function IsCursorOpen: Boolean; override;
    procedure GetBookmarkData(Buffer: PChar; Data: Pointer); override;
    function GetBookmarkFlag(Buffer: PChar): TBookmarkFlag; override;
    function GetRecord(Buffer: PChar; GetMode: TGetMode;
      DoCheck: Boolean): TGetResult; override;
    function GetRecordSize: Word; override;
    procedure SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag); override;
    procedure SetBookmarkData(Buffer: PChar; Data: Pointer); override;
    procedure ClearCalcFields(Buffer: PChar); override;
    function GetRecordCount: Integer; override;
    function GetRecNo: Integer; override;
    procedure SetRecNo(Value: Integer); override;
    function GetCanModify: Boolean; override;
    function TxtGetRecord(Buffer: PChar; GetMode: TGetMode): TGetResult;
    function RecordFilter(RecBuf: Pointer; ARecNo: Integer): Boolean;
    function BufToStore(Buffer: PChar): string; virtual;
    function StoreToBuf(Source: string): string; virtual;
  public
    procedure SetFieldData(Field: TField; Buffer: Pointer); override;
    property DefaultRecordLength: cardinal read FDefaultRecordLength
      write FDefaultRecordLength default 250;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetFieldData(Field: TField; Buffer: Pointer): Boolean; override;
    procedure RemoveBlankRecords; dynamic;
    procedure RemoveExtraColumns; dynamic;
    procedure SaveFileAs(strFileName: string); dynamic;
    property CanModify;
    procedure LoadFromStream(Stream: TStream);
    procedure SavetoStream(Stream: TStream);
    property FileMustExist: Boolean read FFileMustExist write SetFileMustExist;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly;
    property FileName: TFileName read FFileName write SetFileName;
    property Schema: TStringList read FSchema write SetSchema;
    property TrimSpace: Boolean read FTrimSpace write SetTrimSpace default True;
  end;

  TFixedFormatDataSet = class(TCustomFixedFormatDataSet)
  published
    property FileMustExist;
    property ReadOnly;
    property FileName;
    property Schema;
    property TrimSpace default True;
    property FieldDefs;
    property Active;
    property AutoCalcFields;
    property Filtered;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnFilterRecord;
    property OnNewRecord;
    property OnPostError;
  end;

  TCustomSdfDataSet = class(TcustomFixedFormatDataSet)
  private
    FDelimiter: Char;
    FFirstLineAsSchema: Boolean;
    procedure SetFirstLineAsSchema(Value: Boolean);
    procedure SetDelimiter(Value: Char);
  protected
    procedure InternalInitFieldDefs; override;
    function GetRecord(Buffer: PChar; GetMode: TGetMode;
      DoCheck: Boolean): TGetResult; override;
    function BufToStore(Buffer: PChar): string; override;
    function StoreToBuf(Source: string): string; override;
  public
    constructor Create(AOwner: TComponent); override;
    property Delimiter: Char read FDelimiter write SetDelimiter;
    property FirstLineAsSchema: Boolean read FFirstLineAsSchema
      write SetFirstLineAsSchema;
  end;

  TSdfDataSet = class(TCustomSdfDataSet)
  published
    property FileMustExist;
    property ReadOnly;
    property FileName;
    property Schema;
    property TrimSpace default True;
    property FieldDefs;
    property Active;
    property AutoCalcFields;
    property Filtered;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnFilterRecord;
    property OnNewRecord;
    property OnPostError;
    property Delimiter;
    property FirstLineAsSchema;
  end;

implementation

constructor TCustomFixedFormatDataSet.Create(AOwner: TComponent);
begin
  FDefaultRecordLength := 60;
  FFileMustExist := True;
  FLoadfromStream := False;
  FRecordSize := 0;
  FTrimSpace := True;
  FSchema := TStringList.Create;
  FData := TStringList.Create;
  inherited Create(AOwner);
end;

destructor TCustomFixedFormatDataSet.Destroy;
begin
  inherited Destroy;
  FData.Free;
  FSchema.Free;
end;

procedure TCustomFixedFormatDataSet.SetSchema(const Value: TStringList);
begin
  CheckInactive;
  FSchema.Assign(Value);
end;

procedure TCustomFixedFormatDataSet.SetFileMustExist(Value: Boolean);
begin
  CheckInactive;
  FFileMustExist := Value;
end;

procedure TCustomFixedFormatDataSet.SetTrimSpace(Value: Boolean);
begin
  CheckInactive;
  FTrimSpace := Value;
end;

procedure TCustomFixedFormatDataSet.SetReadOnly(Value: Boolean);
begin
  CheckInactive;
  FReadOnly := Value;
end;

procedure TCustomFixedFormatDataSet.SetFileName(Value: TFileName);
begin
  CheckInactive;
  FFileName := Value;
end;

procedure TCustomFixedFormatDataSet.InternalInitFieldDefs;
var
  i, len, Maxlen: Integer;
  LstFields: TStrings;
begin
  if not Assigned(FData) then
    exit;
  FRecordSize := 0;
  Maxlen := 0;
  FieldDefs.Clear;
  for i := FData.Count - 1 downto 0 do
  begin
    len := Length(FData[i]);
    if len > Maxlen then
      Maxlen := len;
    FData.Objects[i] := TObject(Pointer(i + 1));
  end;
  if (Maxlen = 0) then
    Maxlen := FDefaultRecordLength;
  LstFields := TStringList.Create;
  try
    LoadFieldScheme(LstFields, Maxlen);
    for i := 0 to LstFields.Count - 1 do
    begin
      len := StrToIntDef(LstFields.Values[LstFields.Names[i]], Maxlen);
      FieldDefs.Add(Trim(LstFields.Names[i]), ftString, len, False);
      Inc(FRecordSize, len);
    end;
  finally
    LstFields.Free;
  end;
end;

procedure TCustomFixedFormatDataSet.InternalOpen;
var
  Stream: TStream;
begin
  FCurRec := -1;
  FSaveChanges := False;
  if not Assigned(FData) then
    FData := TStringList.Create;
  if (not FileMustExist) and (not FileExists(FileName)) then
  begin
    Stream := TFileStream.Create(FileName, fmCreate);
    Stream.Free;
  end;
  if not FLoadfromStream then
    FData.LoadFromFile(FileName);
  FRecordSize := FDefaultRecordLength;
  InternalInitFieldDefs;
  if DefaultFields then
    CreateFields;
  BindFields(True);
  if FRecordSize = 0 then
    FRecordSize := FDefaultRecordLength;
  BookmarkSize := SizeOf(PtrInt);
  FRecInfoOfs := FRecordSize + CalcFieldsSize;
  FBookmarkOfs := FRecInfoOfs + SizeOf(TRecInfo);
  FRecBufSize := FBookmarkOfs + BookmarkSize;
  FLastBookmark := FData.Count;
end;

procedure TCustomFixedFormatDataSet.InternalClose;
begin
  if (not FReadOnly) and (FSaveChanges) then
    FData.SaveToFile(FileName);
  FLoadfromStream := False;
  FData.Clear;
  BindFields(False);
  if DefaultFields then
    DestroyFields;
  FCurRec := -1;
  FLastBookmark := 0;
  FRecordSize := 0;
end;

function TCustomFixedFormatDataSet.IsCursorOpen: Boolean;
begin
  Result := Assigned(FData) and (FRecordSize > 0);
end;

procedure TCustomFixedFormatDataSet.InternalHandleException;
begin
{$ifndef fpc}
  Application.HandleException(Self);
{$else}
  inherited;
{$endif}
end;

procedure TCustomFixedFormatDataSet.LoadFromStream(Stream: TStream);
begin
  if assigned(stream) then
  begin
    Active := False;
    Stream.Position := 0;
    FLoadfromStream := True;
    if not Assigned(FData) then
      raise Exception.Create('Data buffer unassigned');
    FData.LoadFromStream(Stream);
    Active := True;
  end
  else
    raise Exception.Create('Invalid Stream Assigned (Load From Stream');
end;

procedure TCustomFixedFormatDataSet.SavetoStream(Stream: TStream);
begin
  if assigned(stream) then
    FData.SaveToStream(Stream)
  else
    raise Exception.Create('Invalid Stream Assigned (Save To Stream');
end;

function TCustomFixedFormatDataSet.AllocRecordBuffer: PChar;
begin
  if FRecBufSize > 0 then
    Result := AllocMem(FRecBufSize)
  else
    Result := nil;
end;

procedure TCustomFixedFormatDataSet.FreeRecordBuffer(var Buffer: PChar);
begin
  if Buffer <> nil then
    FreeMem(Buffer);
end;

procedure TCustomFixedFormatDataSet.InternalInitRecord(Buffer: PChar);
begin
  FillChar(Buffer[0], FRecordSize, 0);
end;

procedure TCustomFixedFormatDataSet.ClearCalcFields(Buffer: PChar);
begin
  FillChar(Buffer[RecordSize], CalcFieldsSize, 0);
end;

function TCustomFixedFormatDataSet.GetRecord(Buffer: PChar; GetMode: TGetMode;
  DoCheck: Boolean): TGetResult;
begin
  if (FData.Count < 1) then
    Result := grEOF
  else
    Result := TxtGetRecord(Buffer, GetMode);
  if Result = grOK then
  begin
    if (CalcFieldsSize > 0) then
      GetCalcFields(Buffer);
    with PRecInfo(Buffer + FRecInfoOfs)^ do
    begin
      BookmarkFlag := bfCurrent;
      RecordNumber := PtrInt(FData.Objects[FCurRec]);
    end;
  end
  else
  if (Result = grError) and DoCheck then
    DatabaseError('No Records');
end;

function TCustomFixedFormatDataSet.GetRecordCount: LongInt;
begin
  Result := FData.Count;
end;

function TCustomFixedFormatDataSet.GetRecNo: LongInt;
var
  BufPtr: PChar;
begin
  Result := -1;
  if GetActiveRecBuf(BufPtr) then
    Result := PRecInfo(BufPtr + FRecInfoOfs)^.RecordNumber;
end;

procedure TCustomFixedFormatDataSet.SetRecNo(Value: Integer);
begin
  CheckBrowseMode;
  if (Value >= 0) and (Value < FData.Count) and (Value <> RecNo) then
  begin
    DoBeforeScroll;
    FCurRec := Value - 1;
    Resync([]);
    DoAfterScroll;
  end;
end;

function TCustomFixedFormatDataSet.GetRecordSize: Word;
begin
  Result := FRecordSize;
end;

function TCustomFixedFormatDataSet.GetActiveRecBuf(var RecBuf: PChar): Boolean;
begin
  case State of
    dsBrowse: if IsEmpty then
        RecBuf := nil
      else
        RecBuf := ActiveBuffer;
    dsEdit, dsInsert: RecBuf := ActiveBuffer;
    dsCalcFields: RecBuf := CalcBuffer;
    dsFilter: RecBuf := FFilterBuffer;
    else
      RecBuf := nil;
  end;
  Result := RecBuf <> nil;
end;

function TCustomFixedFormatDataSet.TxtGetRecord(Buffer: PChar; GetMode: TGetMode): TGetResult;
var
  Accepted: Boolean;
begin
  Result := grOK;
  repeat
    Accepted := True;
    case GetMode of
      gmNext:
        if FCurRec >= RecordCount - 1 then
          Result := grEOF
        else
          Inc(FCurRec);
      gmPrior:
        if FCurRec <= 0 then
          Result := grBOF
        else
          Dec(FCurRec);
      gmCurrent:
        if (FCurRec < 0) or (FCurRec >= RecordCount) then
          Result := grError;
    end;
    if (Result = grOk) then
    begin
      Move(PChar(StoreToBuf(FData[FCurRec]))^, Buffer[0], FRecordSize);
      if Filtered then
      begin
        Accepted := RecordFilter(Buffer, FCurRec + 1);
        if not Accepted and (GetMode = gmCurrent) then
          Inc(FCurRec);
      end;
    end;
  until Accepted;
end;

function TCustomFixedFormatDataSet.RecordFilter(RecBuf: Pointer; ARecNo: Integer): Boolean;
var
  Accept: Boolean;
  SaveState: TDataSetState;
begin
  SaveState := SetTempState(dsFilter);
  FFilterBuffer := RecBuf;
  PRecInfo(FFilterBuffer + FRecInfoOfs)^.RecordNumber := ARecNo;
  Accept := True;
  if Accept and Assigned(OnFilterRecord) then
    OnFilterRecord(Self, Accept);
  RestoreState(SaveState);
  Result := Accept;
end;

function TCustomFixedFormatDataSet.GetCanModify: Boolean;
begin
  Result := not FReadOnly;
end;

procedure TCustomFixedFormatDataSet.LoadFieldScheme(List: TStrings; MaxSize: Integer);
var
  tmpFieldName: string;
  tmpSchema: TStrings;
  i: Integer;
begin
  tmpSchema := TStringList.Create;
  try
    if (Schema.Count > 0) then
    begin
      tmpSchema.Assign(Schema);
      RemoveWhiteLines(tmpSchema, False);
    end
    else
      tmpSchema.Add('Line');
    for i := 0 to tmpSchema.Count - 1 do
    begin
      tmpFieldName := tmpSchema.Names[i];
      if (tmpFieldName = '') then
        tmpFieldName := Format('%s=%d', [tmpSchema[i], MaxSize])
      else
        tmpFieldName := tmpSchema[i];
      List.Add(tmpFieldName);
    end;
  finally
    tmpSchema.Free;
  end;
end;

function TCustomFixedFormatDataSet.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
var
  TempPos, RecBuf: PChar;
begin
  Result := GetActiveRecBuf(RecBuf);
  if Result then
  begin
    if Field.FieldNo > 0 then
    begin
      TempPos := RecBuf;
      SetFieldPos(RecBuf, Field.FieldNo);
      Result := (RecBuf < StrEnd(TempPos));
    end
    else
    if (State in [dsBrowse, dsEdit, dsInsert, dsCalcFields]) then
    begin
      Inc(RecBuf, FRecordSize + Field.Offset);
      Result := boolean(byte(RecBuf[0]));
    end;
  end;
  if Result and (Buffer <> nil) then
  begin
    StrLCopy(Buffer, RecBuf, Field.Size);
    if FTrimSpace then
    begin
      TempPos := StrEnd(Buffer);
      repeat
        Dec(TempPos);
        if (TempPos[0] = ' ') then
          TempPos[0] := #0
        else
          break;
      until (TempPos = Buffer);
    end;
  end;
end;

procedure TCustomFixedFormatDataSet.SetFieldData(Field: TField; Buffer: Pointer);
var
  RecBuf, BufEnd: PChar;
  p: Integer;
begin
  if not (State in [dsEdit, dsInsert]) then
    DatabaseError('Dataset not in edit or insert mode', Self);
  GetActiveRecBuf(RecBuf);
  if Field.FieldNo > 0 then
  begin
    if State = dsCalcFields then
      DatabaseError('Dataset not in edit or insert mode', Self);
    if Field.ReadOnly and not (State in [dsSetKey, dsFilter]) then
      DatabaseErrorFmt('Field ''%s'' cannot be modified', [Field.DisplayName]);
    Field.Validate(Buffer);
    if Field.FieldKind <> fkInternalCalc then
    begin
      SetFieldPos(RecBuf, Field.FieldNo);
      BufEnd := StrEnd(ActiveBuffer);
      if BufEnd > RecBuf then
        BufEnd := RecBuf;
      FillChar(BufEnd[0], Field.Size + PtrInt(RecBuf) - PtrInt(BufEnd), Ord(' '));
      p := StrLen(Buffer);
      if p > Field.Size then
        p := Field.Size;
      Move(Buffer^, RecBuf[0], p);
    end;
  end
  else
  begin
    Inc(RecBuf, FRecordSize + Field.Offset);
    Move(Buffer^, RecBuf[0], Field.Size);
  end;
  if not (State in [dsCalcFields, dsFilter, dsNewValue]) then
    DataEvent(deFieldChange, Ptrint(Field));
end;

procedure TCustomFixedFormatDataSet.SetFieldPos(var Buffer: PChar; FieldNo: Integer);
var
  i: Integer;
begin
  i := 1;
  while (i < FieldNo) and (i < FieldDefs.Count) do
  begin
    Inc(Buffer, FieldDefs.Items[i - 1].Size);
    Inc(i);
  end;
end;

procedure TCustomFixedFormatDataSet.InternalFirst;
begin
  FCurRec := -1;
end;

procedure TCustomFixedFormatDataSet.InternalLast;
begin
  FCurRec := FData.Count;
end;

procedure TCustomFixedFormatDataSet.InternalPost;
begin
  FSaveChanges := True;
  inherited UpdateRecord;
  if (State = dsEdit) then
  begin
    FData[FCurRec] := BufToStore(ActiveBuffer);
  end
  else
    InternalAddRecord(ActiveBuffer, False);
end;

procedure TCustomFixedFormatDataSet.InternalEdit;
begin

end;

procedure TCustomFixedFormatDataSet.InternalDelete;
begin
  FSaveChanges := True;
  FData.Delete(FCurRec);
  if FCurRec >= FData.Count then
    Dec(FCurRec);
end;

procedure TCustomFixedFormatDataSet.InternalAddRecord(Buffer: Pointer; DoAppend: Boolean);
begin
  FSaveChanges := True;
  Inc(FLastBookmark);
  if DoAppend then
    InternalLast;
  if (FCurRec >= 0) then
    FData.InsertObject(FCurRec, BufToStore(Buffer), TObject(Pointer(FLastBookmark)))
  else
    FData.AddObject(BufToStore(Buffer), TObject(Pointer(FLastBookmark)));
end;

procedure TCustomFixedFormatDataSet.InternalGotoBookmark(ABookmark: Pointer);
var
  Index: Integer;
begin
  Index := FData.IndexOfObject(TObject(PPtrInt(ABookmark)^));
  if Index <> -1 then
    FCurRec := Index
  else
    DatabaseError('Bookmark not found');
end;

procedure TCustomFixedFormatDataSet.InternalSetToRecord(Buffer: PChar);
begin
  if (State <> dsInsert) then
    InternalGotoBookmark(@PRecInfo(Buffer + FRecInfoOfs)^.RecordNumber);
end;

function TCustomFixedFormatDataSet.GetBookmarkFlag(Buffer: PChar): TBookmarkFlag;
begin
  Result := PRecInfo(Buffer + FRecInfoOfs)^.BookmarkFlag;
end;

procedure TCustomFixedFormatDataSet.SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag);
begin
  PRecInfo(Buffer + FRecInfoOfs)^.BookmarkFlag := Value;
end;

procedure TCustomFixedFormatDataSet.GetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  Move(Buffer[FRecInfoOfs], Data^, BookmarkSize);
end;

procedure TCustomFixedFormatDataSet.SetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  Move(Data^, Buffer[FRecInfoOfs], BookmarkSize);
end;

procedure TCustomFixedFormatDataSet.RemoveWhiteLines(List: TStrings; IsFileRecord: Boolean);
var
  i: Integer;
begin
  for i := List.Count - 1 downto 0 do
  begin
    if (Trim(List[i]) = '') then
      if IsFileRecord then
      begin
        FCurRec := i;
        InternalDelete;
      end
      else
        List.Delete(i);
  end;
end;

procedure TCustomFixedFormatDataSet.RemoveBlankRecords;
begin
  RemoveWhiteLines(FData, True);
end;

procedure TCustomFixedFormatDataSet.RemoveExtraColumns;
var
  i: Integer;
begin
  for i := FData.Count - 1 downto 0 do
    FData[i] := BufToStore(PChar(StoreToBuf(FData[i])));
  FData.SaveToFile(FileName);
end;

procedure TCustomFixedFormatDataSet.SaveFileAs(strFileName: string);
begin
  FData.SaveToFile(strFileName);
  FFileName := strFileName;
  FSaveChanges := False;
end;

function TCustomFixedFormatDataSet.StoreToBuf(Source: string): string;
begin
  Result := Source;
end;

function TCustomFixedFormatDataSet.BufToStore(Buffer: PChar): string;
begin
  Result := Copy(Buffer, 1, FRecordSize);
end;

constructor TCustomSdfDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDelimiter := ',';
  FFirstLineAsSchema := False;
end;

procedure TCustomSdfDataSet.InternalInitFieldDefs;
var
  pStart, pEnd, len: Integer;
begin
  if not IsCursorOpen then
    exit;
  if (FData.Count = 0) or (Trim(FData[0]) = '') then
    FirstLineAsSchema := False
  else if (Schema.Count = 0) or (FirstLineAsSchema) then
  begin
    Schema.Clear;
    len := Length(FData[0]);
    pEnd := 1;
    repeat
      while (pEnd <= len) and (FData[0][pEnd] in [#1..' ']) do
        Inc(pEnd);

      if (pEnd > len) then
        break;

      pStart := pEnd;

      if (FData[0][pStart] = '"') then
      begin
        repeat
          Inc(pEnd);
        until (pEnd > len) or (FData[0][pEnd] = '"');

        if (FData[0][pEnd] = '"') then
          Inc(pStart);
      end
      else
        while (pEnd <= len) and (FData[0][pEnd] <> Delimiter) do
          Inc(pEnd);

      if (FirstLineAsSchema) then
        Schema.Add(Copy(FData[0], pStart, pEnd - pStart))
      else
        Schema.Add(Format('Field%d', [Schema.Count + 1]));

      if (FData[0][pEnd] = '"') then
        while (pEnd <= len) and (FData[0][pEnd] <> Delimiter) do
          Inc(pEnd);

      if (FData[0][pEnd] = Delimiter) then
        Inc(pEnd);

    until (pEnd > len);
  end;
  inherited;
end;

function TCustomSdfDataSet.GetRecord(Buffer: PChar; GetMode: TGetMode;
  DoCheck: Boolean): TGetResult;
begin
  if FirstLineAsSchema then
  begin
    if (FData.Count < 2) then
      Result := grEOF
    else
    begin
      Result := inherited GetRecord(Buffer, GetMode, DoCheck);
      if (Result = grOk) and (FCurRec = 0) then
        Result := inherited GetRecord(Buffer, GetMode, DoCheck);
    end;
  end
  else
    Result := inherited GetRecord(Buffer, GetMode, DoCheck);
end;

function TCustomSdfDataSet.StoreToBuf(Source: string): string;
const
  CR: Char = #13;
  LF: Char = #10;
var
  i, p: Integer;
  pRet, pStr, pStrEnd: PChar;
  Ret: string;
begin
  SetLength(Ret, FRecordSize);

  FillChar(PChar(Ret)^, FRecordSize, Ord(' '));
  PStrEnd := PChar(Source);
  pRet := PChar(Ret);

  for i := 0 to FieldDefs.Count - 1 do
  begin

    while boolean(byte(pStrEnd[0])) and (pStrEnd[0] in [#1..' ']) do
      Inc(pStrEnd);

    if not boolean(byte(pStrEnd[0])) then
      break;

    pStr := pStrEnd;

    if (pStr[0] = '"') then
    begin
      repeat
        Inc(pStrEnd);
      until not boolean(byte(pStrEnd[0])) or
        ((pStrEnd[0] = '"') and ((pStrEnd + 1)[0] in [Delimiter, CR, LF, #0]));

      if (pStrEnd[0] = '"') then
        Inc(pStr);
    end
    else
      while boolean(byte(pStrEnd[0])) and (pStrEnd[0] <> Delimiter) do
        Inc(pStrEnd);

    p := pStrEnd - pStr;
    if (p > FieldDefs[i].Size) then
      p := FieldDefs[i].Size;

    Move(pStr[0], pRet[0], p);

    Inc(pRet, FieldDefs[i].Size);

    if (pStrEnd[0] = '"') then
      while boolean(byte(pStrEnd[0])) and (pStrEnd[0] <> Delimiter) do
        Inc(pStrEnd);

    if (pStrEnd[0] = Delimiter) then
      Inc(pStrEnd);
  end;
  Result := Ret;
end;

function TCustomSdfDataSet.BufToStore(Buffer: PChar): string;
var
  Str: string;
  p, i: Integer;
begin
  Result := '';
  p := 1;
  for i := 0 to FieldDefs.Count - 1 do
  begin
    Str := Trim(Copy(Buffer, p, FieldDefs[i].Size));
    Inc(p, FieldDefs[i].Size);
    if (StrScan(PChar(Str), FDelimiter) <> nil) then
      Str := '"' + Str + '"';
    Result := Result + Str + FDelimiter;
  end;
  p := Length(Result);
  while (p > 0) and (Result[p] = FDelimiter) do
  begin
    System.Delete(Result, p, 1);
    Dec(p);
  end;
end;

procedure TCustomSdfDataSet.SetDelimiter(Value: Char);
begin
  CheckInactive;
  FDelimiter := Value;
end;

procedure TCustomSdfDataSet.SetFirstLineAsSchema(Value: Boolean);
begin
  CheckInactive;
  FFirstLineAsSchema := Value;
end;

end.

