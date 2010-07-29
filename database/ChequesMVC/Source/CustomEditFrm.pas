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

unit CustomEditFrm;

{$I cheques.inc}

interface

uses
  ExtCtrls, Buttons, BaseFrm, StdCtrls;

type

  { TCustomEditForm }

  TCustomEditForm = class(TBaseForm)
    OKBitBtn: TBitBtn;
    CancelBitBtn: TBitBtn;
    ClientPanel: TPanel;
    ButtomPanel: TPanel;
    RequiredFieldInfoLabel: TLabel;
  end;

implementation

{$R *.lfm}

end.

