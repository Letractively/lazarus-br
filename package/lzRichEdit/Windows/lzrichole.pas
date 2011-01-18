{
lzRichEdit

Copyright (C) 2010 Elson Junio elsonjunio@yahoo.com.br

This library is free software; you can redistribute it and/or modify it
under the terms of the GNU Library General Public License as published by
the Free Software Foundation; either version 2 of the License, or (at your
option) any later version with the following modification:

As a special exception, the copyright holders of this library give you
permission to link this library with independent modules to produce an
executable, regardless of the license terms of these independent modules,and
to copy and distribute the resulting executable under terms of your choice,
provided that you also meet, for each linked independent module, the terms
and conditions of the license of that module. An independent module is a
module which is not derived from or based on this library. If you modify
this library, you may extend this exception to your version of the library,
but you are not obligated to do so. If you do not wish to do so, delete this
exception statement from your version.

This library is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
for more details.

You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

unit lzRichOle;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, Controls, ActiveX, Ole2, RichOle, ComObj, Forms;


type
  TGetTextLengthEx=packed record
    flags : dword;
    codepage : dword;
end;

const
  OLECLOSE_SAVEIFDIRTY = 0;
  OLECLOSE_NOSAVE = 1;
  OLECLOSE_PROMPTSAVE = 2;

type

  { TIRichEditOleCallback }

  TIRichEditOleCallback = class(TObject, IUnknown, IRichEditOleCallback)
    function QueryInterface({$IFDEF FPC_HAS_CONSTREF}constref{$ELSE}const{$ENDIF} iid: TGUID; out Obj): HResult; stdcall;
    function _AddRef: longint; stdcall;
    function _Release: longint; stdcall;
    function GetNewStorage(out stg: IStorage): HRESULT; stdcall;
    function GetInPlaceContext(out Frame: IOleInPlaceFrame;
      out Doc: IOleInPlaceUIWindow; lpFrameInfo: POleInPlaceFrameInfo): HRESULT; stdcall;
    function ShowContainerUI(fShow: BOOL): HRESULT; stdcall;
    function QueryInsertObject(const clsid: TCLSID; const stg: IStorage;
      cp: longint): HRESULT; stdcall;
    function DeleteObject(const oleobj: IOleObject): HRESULT; stdcall;
    function QueryAcceptData(const dataobj: IDataObject; var cfFormat: TClipFormat;
      reco: DWORD; fReally: BOOL; hMetaPict: HGLOBAL): HRESULT; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HRESULT; stdcall;
    function GetClipboardData(const chrg: TCharRange; reco: DWORD;
      out dataobj: IDataObject): HRESULT; stdcall;
    function GetDragDropEffect(fDrag: BOOL; grfKeyState: DWORD;
      var dwEffect: DWORD): HRESULT; stdcall;
    function GetContextMenu(seltype: word; oleobj: IOleObject;
      const chrg: TCharRange; var menu: HMENU): HRESULT; stdcall;
  private
    FOwner: TWinControl;
    FRefCount: longint;
  public
    constructor Create(AOwner: TWinControl);
    destructor Destroy; override;
  end;

  { TRichOle }

  TRichOle = class
    RichEditOleCallback: TIRichEditOleCallback;
    RichEditOle: IRichEditOle;
  public
    constructor Create(AOwner: TWinControl);
    destructor Destroy; override;
  end;



implementation

uses
  lzRichEdit;

{ TRichOle }

constructor TRichOle.Create(AOwner: TWinControl);
begin
  inherited Create;
  RichEditOleCallback := TIRichEditOleCallback.Create(AOwner);
end;

destructor TRichOle.Destroy;
begin
  RichEditOleCallback.Free;
  inherited Destroy;
end;

{ TIRichEditOleCallback }

function TIRichEditOleCallback.QueryInterface({$IFDEF FPC_HAS_CONSTREF}constref{$ELSE}const{$ENDIF} iid: TGUID;
  out Obj): HResult; stdcall;
var
  P: IUnknown;
begin

  P := nil;
  if IsEqualIID(iid, IID_IUnknown) then
    P := self;

  Pointer(obj) := P;
  if (P = nil) then
    Result := E_NOINTERFACE
  else
  begin
    P._AddRef;
    Result := S_OK;
  end;
end;

function TIRichEditOleCallback._AddRef: longint; stdcall;
begin
  Inc(FRefCount);
  Result := FRefCount;
end;

function TIRichEditOleCallback._Release: longint; stdcall;
begin
  Dec(FRefCount);
  Result := FRefCount;
end;

function TIRichEditOleCallback.GetNewStorage(out stg: IStorage): HRESULT;
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

function TIRichEditOleCallback.GetInPlaceContext(out Frame: IOleInPlaceFrame;
  out Doc: IOleInPlaceUIWindow; lpFrameInfo: POleInPlaceFrameInfo): HRESULT;
  stdcall;
begin
  Result := E_NOTIMPL;
end;

function TIRichEditOleCallback.ShowContainerUI(fShow: BOOL): HRESULT; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TIRichEditOleCallback.QueryInsertObject(const clsid: TCLSID;
  const stg: IStorage; cp: longint): HRESULT; stdcall;
begin
  Result := S_OK;
end;

function TIRichEditOleCallback.DeleteObject(const oleobj: IOleObject): HRESULT;
  stdcall;
begin
  {if Assigned(oleobj) then
    oleobj.Close(OLECLOSE_NOSAVE);
   Result := NOERROR; }
  Result := S_OK;
end;

function TIRichEditOleCallback.QueryAcceptData(const dataobj: IDataObject;
  var cfFormat: TClipFormat; reco: DWORD; fReally: BOOL;
  hMetaPict: HGLOBAL): HRESULT; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TIRichEditOleCallback.ContextSensitiveHelp(fEnterMode: BOOL): HRESULT;
  stdcall;
begin
  Result := E_NOTIMPL;
end;

function TIRichEditOleCallback.GetClipboardData(const chrg: TCharRange;
  reco: DWORD; out dataobj: IDataObject): HRESULT; stdcall;
begin
  Result := E_NOTIMPL;
end;

function TIRichEditOleCallback.GetDragDropEffect(fDrag: BOOL;
  grfKeyState: DWORD; var dwEffect: DWORD): HRESULT; stdcall;
begin
  Result := S_OK;
end;

function TIRichEditOleCallback.GetContextMenu(seltype: word;
  oleobj: IOleObject; const chrg: TCharRange; var menu: HMENU): HRESULT;
  stdcall;
begin
  Result := E_NOTIMPL;
end;

constructor TIRichEditOleCallback.Create(AOwner: TWinControl);
begin
  FOwner := AOwner;
  FRefCount := 0;
end;

destructor TIRichEditOleCallback.Destroy;
begin
  inherited Destroy;
end;

end.

