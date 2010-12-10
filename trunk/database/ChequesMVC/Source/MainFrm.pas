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

unit MainFrm;

{$I cheques.inc}

interface

uses
  Forms, Controls, ComCtrls, Menus, Classes, XMLPropStorage;

type

  { TMainForm }

  TMainForm = class(TForm)
    AboutMenuItem: TMenuItem;
    AboutToolButton: TToolButton;
    BancoMenuItem: TMenuItem;
    BancoToolButton: TToolButton;
    ChequeMenuItem: TMenuItem;
    ChequeToolButton: TToolButton;
    ContaMenuItem: TMenuItem;
    ContaToolButton: TToolButton;
    DestinoMenuItem: TMenuItem;
    DestinoToolButton: TToolButton;
    ExitMenuItem: TMenuItem;
    ExitToolButton: TToolButton;
    FileMenuItem: TMenuItem;
    HelpMenu: TMenuItem;
    HelpMenuItem: TMenuItem;
    HelpToolButton: TToolButton;
    MainImageList: TImageList;
    MainMenu: TMainMenu;
    MainToolBar: TToolBar;
    MainXMLPropStorage: TXMLPropStorage;
    MesMenuItem: TMenuItem;
    MesToolButton: TToolButton;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    StatusBar: TStatusBar;
    TB1: TToolButton;
    TB2: TToolButton;
    TB3: TToolButton;
    TB4: TToolButton;
    TB5: TToolButton;
    TB6: TToolButton;
    TB7: TToolButton;
    TB8: TToolButton;
    procedure AboutMenuItemClick(Sender: TObject);
    procedure BancoMenuItemClick(Sender: TObject);
    procedure ChequeMenuItemClick(Sender: TObject);
    procedure ContaMenuItemClick(Sender: TObject);
    procedure DestinoMenuItemClick(Sender: TObject);
    procedure ExitMenuItemClick(Sender: TObject);
    procedure HelpMenuItemClick(Sender: TObject);
    procedure MesMenuItemClick(Sender: TObject);
  public
    constructor Create(TheOwner: TComponent); override;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  BaseFrm, ChequeConsts, MesMVC, ContaMVC, BancoMVC, DestinoMVC, ChequeMVC,
  AboutFrm;

{ TMainForm }

procedure TMainForm.ExitMenuItemClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.HelpMenuItemClick(Sender: TObject);
begin
  TBaseForm.OpenHelp;
end;

procedure TMainForm.ContaMenuItemClick(Sender: TObject);
begin
  TContaView.Execute;
end;

procedure TMainForm.DestinoMenuItemClick(Sender: TObject);
begin
  TDestinoView.Execute;
end;

procedure TMainForm.BancoMenuItemClick(Sender: TObject);
begin
  TBancoView.Execute;
end;

procedure TMainForm.AboutMenuItemClick(Sender: TObject);
begin
  TAboutForm.Execute;
end;

procedure TMainForm.ChequeMenuItemClick(Sender: TObject);
begin
  TChequeView.Execute;
end;

procedure TMainForm.MesMenuItemClick(Sender: TObject);
begin
  TMesView.Execute;
end;

constructor TMainForm.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  MainXMLPropStorage.FileName := SXMLConfig;
end;

end.

