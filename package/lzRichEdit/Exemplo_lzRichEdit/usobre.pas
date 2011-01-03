unit USobre;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  lzRichEdit;

type

  { TfrmSobre }

  TfrmSobre = class(TForm)
    Button1: TButton;
    lzRichEdit1: TlzRichEdit;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmSobre: TfrmSobre;

implementation

{$R *.lfm}

{ TfrmSobre }

procedure TfrmSobre.Button1Click(Sender: TObject);
begin
  Close;
end;

end.

