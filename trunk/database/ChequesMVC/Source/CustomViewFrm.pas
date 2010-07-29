(*
  Cheques 2.1, Controle pessoal de cheques.
  Copyright (C) 2010-2012 Everaldo - arcanjoebc@gmail.com

  See the file LGPL.2.1_modified.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

(*
  Powerfull contributors:
  Silvio Clecio - http://blog.silvioprog.com.br
  Joao Morais   - http://blog.joaomorais.com.br
  Luiz Americo  - http://lazarusroad.blogspot.com
*)

unit CustomViewFrm;

{$I cheques.inc}

interface

uses
  BaseFrm, ExtCtrls, Buttons, StdCtrls, DBGrids, Menus;

type

  { TCustomViewForm }

  TCustomViewForm = class(TBaseForm)
    SearchTypeComboBox: TComboBox;
    TopPanel: TPanel;
    SearchTypePanel: TPanel;
    PrintMenuItem: TMenuItem;
    N1: TMenuItem;
    PrintBitBtn: TBitBtn;
    CloseBitBtn: TBitBtn;
    DeleteBitBtn: TBitBtn;
    EditBitBtn: TBitBtn;
    InsertBitBtn: TBitBtn;
    ListDBGrid: TDBGrid;
    DataPopupMenu: TPopupMenu;
    CloseMenuItem: TMenuItem;
    InsertMenuItem: TMenuItem;
    EditMenuItem: TMenuItem;
    DeleteMenuItem: TMenuItem;
    N3: TMenuItem;
    N2: TMenuItem;
    SearchBitBtn: TBitBtn;
    SearchEdit: TEdit;
    SearchMenuItem: TMenuItem;
    MiscPopupMenu: TPopupMenu;
    ListDBGridPanel: TPanel;
    DataPanel: TPanel;
    SearchPanel: TPanel;
  end;

implementation

{$R *.lfm}

end.

