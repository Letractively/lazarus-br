unit RichOleBox;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, SysUtils, RichOle, RichBox, ActiveX, Richedit,
  ComCtrls, ComObj;

type
    { TRichEditOleCallback }

    TRichEditOleCallback = class(TInterfacedObject, IRichEditOleCallback)
  private
    FOwner: TCustomRichBox;
  protected
    function GetNewStorage(out stg: IStorage): HRESULT; stdcall;
    function GetInPlaceContext(out Frame: IOleInPlaceFrame;
         out Doc: IOleInPlaceUIWindow; var FrameInfo: TOleInPlaceFrameInfo): HRESULT; stdcall;
    function ShowContainerUI(fShow: BOOL): HRESULT; stdcall;
    function QueryInsertObject(const clsid: TCLSID; stg: IStorage; cp: longint): HRESULT; stdcall;
    function DeleteObject(oleobj: IOLEObject): HRESULT; stdcall;
    function QueryAcceptData(dataobj: IDataObject; var cfFormat: TClipFormat;
         reco: DWORD; fReally: BOOL; hMetaPict: HGLOBAL): HRESULT; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HRESULT; stdcall;
    function GetClipboardData(const chrg: TCharRange; reco: DWORD;
         out dataobj: IDataObject): HRESULT; stdcall;
    function GetDragDropEffect(fDrag: BOOL; grfKeyState: DWORD;
         var dwEffect: DWORD): HRESULT; stdcall;
    function GetContextMenu(seltype: Word; oleobj: IOleObject;
         const chrg: TCharRange; var menu: HMENU): HRESULT; stdcall;
  public
    constructor Create(AOwner: TCustomRichBox);
  end;


implementation

{ TRichEditOleCallback }

function TRichEditOleCallback.GetNewStorage(out stg: IStorage): HRESULT;
  stdcall;
var
  LockBytes: ILockBytes;
begin
  try
    OleCheck(CreateILockBytesOnHGlobal(0, True, LockBytes));
    OleCheck(StgCreateDocfileOnILockBytes(LockBytes, STGM_READWRITE or
      STGM_SHARE_EXCLUSIVE or STGM_CREATE, 0, stg));
    LockBytes._Release;
    LockBytes := nil;
    Result := S_OK;
  except
    Result := E_OUTOFMEMORY;
  end;
end;

function TRichEditOleCallback.GetInPlaceContext(out Frame: IOleInPlaceFrame;
  out Doc: IOleInPlaceUIWindow; var FrameInfo: TOleInPlaceFrameInfo): HRESULT;
  stdcall;
begin
  Result := E_NOTIMPL;
end;

function TRichEditOleCallback.ShowContainerUI(fShow: BOOL): HRESULT; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TRichEditOleCallback.QueryInsertObject(const clsid: TCLSID;
  stg: IStorage; cp: longint): HRESULT; stdcall;
begin
  Result := S_OK;
end;

function TRichEditOleCallback.DeleteObject(oleobj: IOLEObject): HRESULT;
  stdcall;
begin
  oleobj.Close(OLECLOSE_NOSAVE);
  Result:= S_OK;
end;

function TRichEditOleCallback.QueryAcceptData(dataobj: IDataObject;
  var cfFormat: TClipFormat; reco: DWORD; fReally: BOOL; hMetaPict: HGLOBAL
  ): HRESULT; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TRichEditOleCallback.ContextSensitiveHelp(fEnterMode: BOOL): HRESULT;
  stdcall;
begin
  Result := E_NOTIMPL;
end;

function TRichEditOleCallback.GetClipboardData(const chrg: TCharRange;
  reco: DWORD; out dataobj: IDataObject): HRESULT; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TRichEditOleCallback.GetDragDropEffect(fDrag: BOOL;
  grfKeyState: DWORD; var dwEffect: DWORD): HRESULT; stdcall;
var Effect: DWORD;
begin
  Result:= S_OK;
end;

function TRichEditOleCallback.GetContextMenu(seltype: Word; oleobj: IOleObject;
  const chrg: TCharRange; var menu: HMENU): HRESULT; stdcall;
begin
  menu:=0;
  Result:= S_OK;
end;

constructor TRichEditOleCallback.Create(AOwner: TCustomRichBox);
begin
  inherited Create;
  FOwner:= AOwner;
end;

end.

