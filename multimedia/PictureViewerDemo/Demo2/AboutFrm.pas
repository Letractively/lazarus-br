unit AboutFrm;

{$mode objfpc}{$H+}

interface

uses
  LResources, Forms, ExtCtrls, Buttons;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    OKButton: TBitBtn;
    LogoImage: TImage;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  public
    class procedure Execute;
  end;

implementation

{ TAboutForm }

procedure TAboutForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

class procedure TAboutForm.Execute;
begin
  Create(nil).ShowModal;
end;

initialization
  {$I AboutFrm.lrs}

end.

