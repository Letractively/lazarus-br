(*
  LazListMediaDisc.pas, List media discs
  Copyright (C) 2010-2012 Silvio Clécio - admin@silvioprog.com.br

  http://blog.silvioprog.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  LResources, Forms, StdCtrls, LazListMediaDisc;

type

  { TMainForm }

  TMainForm = class(TForm)
    AvailableDiscsLabel: TLabel;
    AvailableDiscsListBox: TListBox;
    procedure AvailableDiscsListBoxDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    procedure OnListAvailableDiscs(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  LazListMediaDiscInstance.OnListAvailableDiscs := @OnListAvailableDiscs;
end;

procedure TMainForm.AvailableDiscsListBoxDblClick(Sender: TObject);
begin
  TLazListMediaDisc.OpenDisc(AvailableDiscsListBox.GetSelectedText);
end;

procedure TMainForm.OnListAvailableDiscs(Sender: TObject);
begin
  AvailableDiscsListBox.Items.BeginUpdate;
  AvailableDiscsListBox.Items.Text := LazListMediaDiscInstance.AvailableDiscs;
  AvailableDiscsListBox.Items.EndUpdate;
end;

initialization
  {$I MainFrm.lrs}

end.
