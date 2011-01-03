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

unit RichOle;

{$mode objfpc}{$H+}

interface

uses
  Windows, ActiveX;

const
  REO_GETOBJ_NO_INTERFACES     = 0;
  REO_GETOBJ_POLEOBJ           = 1;
  REO_GETOBJ_PSTG              = 2;
  REO_GETOBJ_POLESITE          = 4;
  REO_GETOBJ_ALL_INTERFACES    = 7;
  REO_CP_SELECTION             = ULONG(-1);
  REO_IOB_SELECTION            = ULONG(-1);
  REO_IOB_USE_CP               = ULONG(-2);
  REO_NULL                     = 0;
  REO_READWRITEMASK            = $3F;
  REO_DONTNEEDPALETTE          = 32;
  REO_BLANK                    = 16;
  REO_DYNAMICSIZE              = 8;
  REO_INVERTEDSELECT           = 4;
  REO_BELOWBASELINE            = 2;
  REO_RESIZABLE                = 1;
  REO_LINK                     = $80000000;
  REO_STATIC                   = $40000000;
  REO_SELECTED                 = $08000000;
  REO_OPEN                     = $4000000;
  REO_INPLACEACTIVE            = $2000000;
  REO_HILITED                  = $1000000;
  REO_LINKAVAILABLE            = $800000;
  REO_GETMETAFILE              = $400000;
  RECO_PASTE                   = 0;
  RECO_DROP                    = 1;
  RECO_COPY                    = 2;
  RECO_CUT                     = 3;
  RECO_DRAG                    = 4;


  IID_IRichEditOle: TGUID = (D1:$00020D00;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  IID_IRichEditOleCallback: TGUID = (D1:$00020D03;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));

type
  _reobject = record
      cbStruct : DWORD;
      cp : LONG;
      clsid : TCLSID;
      poleobj : IOleObject;
      pstg : IStorage;
      polesite : IOleClientSite;
      sizel : TSize;
      dvaspect : DWORD;
      dwFlags : DWORD;
      dwUser : DWORD;
    end;
    REOBJECT = _reobject;
    TReObject = _reobject;


  IRichEditOle = interface(IUnknown)
    ['{00020D00-0000-0000-C000-000000000046}']
    function GetClientSite(out clientSite: IOleClientSite): HRESULT; stdcall;
    function GetObjectCount: LongInt; stdcall;
    function GetLinkCount: LongInt; stdcall;
    function GetObject(iob: LongInt; out ReObject: TReObject; dwFlags: DWORD): HRESULT; stdcall;
    function InsertObject(var ReObject: TReObject): HRESULT; stdcall;
    function ConvertObject(iob: LongInt; const clsidNew: TCLSID; lpStrUserTypeNew: LPCSTR): HRESULT; stdcall;
    function ActivateAs(const clsid, clsidAs: TCLSID): HRESULT; stdcall;
    function SetHostNames(lpstrContainerApp: LPCSTR; lpstrContainerObj: LPCSTR): HRESULT; stdcall;
    function SetLinkAvailable(iob: LongInt; fAvailable: BOOL): HRESULT; stdcall;
    function SetDvaspect(iob: LongInt; dvaspect: DWORD): HRESULT; stdcall;
    function HandsOffStorage(iob: LongInt): HRESULT; stdcall;
    function SaveCompleted(iob: LongInt; const stg: IStorage): HRESULT; stdcall;
    function InPlaceDeactivate: HRESULT; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HRESULT; stdcall;
    function GetClipboardData(const chrg: TCharRange; reco: DWORD; out dataobj: IDataObject): HRESULT; stdcall;
    function ImportDataObject(const dataobj: IDataObject; cf: TClipFormat; hMetaPict: HGLOBAL): HRESULT; stdcall;
  end;

    IRichEditOleCallback = interface(IUnknown)
    ['{00020D03-0000-0000-C000-000000000046}']
    function GetNewStorage(out stg: IStorage): HRESULT; stdcall;
    function GetInPlaceContext(out Frame: IOleInPlaceFrame; out Doc: IOleInPlaceUIWindow; lpFrameInfo: POleInPlaceFrameInfo): HRESULT; stdcall;
    function ShowContainerUI(fShow: BOOL): HRESULT; stdcall;
    function QueryInsertObject(const clsid: TCLSID; const stg: IStorage; cp: LongInt): HRESULT; stdcall;
    function DeleteObject(const oleobj: IOleObject): HRESULT; stdcall;
    function QueryAcceptData(const dataobj: IDataObject; var cfFormat: TClipFormat; reco: DWORD; fReally: BOOL; hMetaPict: HGLOBAL): HRESULT; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HRESULT; stdcall;
    function GetClipboardData(const chrg: TCharRange; reco: DWORD; out dataobj: IDataObject): HRESULT; stdcall;
    function GetDragDropEffect(fDrag: BOOL; grfKeyState: DWORD; var dwEffect: DWORD): HRESULT; stdcall;
    function GetContextMenu(seltype: Word; oleobj: IOleObject; const chrg: TCharRange; var menu: HMENU): HRESULT; stdcall;
  end;
  //--

  function RichEdit_SetOleCallback(Wnd: HWND; const Intf: IRichEditOleCallback): Boolean;
  function RichEdit_GetOleInterface(Wnd: HWND; out Intf: IRichEditOle): Boolean;

implementation

function RichEdit_SetOleCallback(Wnd: HWND; const Intf: IRichEditOleCallback
  ): Boolean;
begin
  Result := SendMessage(Wnd, EM_SETOLECALLBACK, 0, LongInt(Intf)) <> 0;
end;

function RichEdit_GetOleInterface(Wnd: HWND; out Intf: IRichEditOle): Boolean;
begin
  Result := SendMessage(Wnd, EM_GETOLEINTERFACE, 0, LongInt(@Intf)) <> 0;
end;

end.

