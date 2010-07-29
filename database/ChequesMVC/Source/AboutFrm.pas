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

unit AboutFrm;

{$I cheques.inc}

interface

uses
  Buttons, ComCtrls, ExtCtrls, StdCtrls, BaseFrm, Version;

type

  { TAboutForm }

  TAboutForm = class(TBaseForm)
    CaptionLabel: TLabel;
    DescriptionLabel: TLabel;
    Label1: TLabel;
    LGPLMemo: TMemo;
    silvioprogLabel: TLabel;
    joaomoraisLabel: TLabel;
    luizamericoLabel: TLabel;
    PowerfullContributorsLabel: TLabel;
    VersionLabel: TLabel;
    LogoImage: TImage;
    OKBitBtn: TBitBtn;
    ClientPageControl: TPageControl;
    BottomPanel: TPanel;
    AboutTabSheet: TTabSheet;
    LGPLTabSheet: TTabSheet;
    procedure LogoImagePaint(Sender: TObject);
    procedure silvioprogLabelClick(Sender: TObject);
    procedure joaomoraisLabelClick(Sender: TObject);
    procedure luizamericoLabelClick(Sender: TObject);
  public
    procedure OnExecute; override;
  end;

implementation

{$R *.lfm}

uses
  LCLIntf;

{ TAboutForm }

procedure TAboutForm.silvioprogLabelClick(Sender: TObject);
begin
  OpenURL('http://blog.silvioprog.com.br');
end;

procedure TAboutForm.LogoImagePaint(Sender: TObject);
begin
  LogoImage.Canvas.Frame(0, 0, LogoImage.Width - 1, LogoImage.Height - 1);
end;

procedure TAboutForm.joaomoraisLabelClick(Sender: TObject);
begin
  OpenURL('http://blog.joaomorais.com.br');
end;

procedure TAboutForm.luizamericoLabelClick(Sender: TObject);
begin
  OpenURL('http://lazarusroad.blogspot.com');
end;

procedure TAboutForm.OnExecute;
begin
  inherited;
  SessionProperties := '';
  VersionLabel.Caption := SVersion;
end;

end.

