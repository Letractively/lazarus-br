{
lzRichEdit

Copyright (C) 2010 Elson Junio elsonjunio@yahoo.com.br
                   Additions by Antônio Galvão

This is the file COPYING.modifiedLGPL, it applies to several units in the
Lazarus sources distributed by members of the Lazarus Development Team.
All files contains headers showing the appropriate license. See there if this
modification can be applied.

These files are distributed under the Library GNU General Public License
(see the file COPYING.LGPL) with the following modification:

As a special exception, the copyright holders of this library give you
permission to link this library with independent modules to produce an
executable, regardless of the license terms of these independent modules,
and to copy and distribute the resulting executable under terms of your choice,
provided that you also meet, for each linked independent module, the terms
and conditions of the license of that module. An independent module is a
module which is not derived from or based on this library. If you modify this
library, you may extend this exception to your version of the library, but
you are not obligated to do so. If you do not wish to do so, delete this
exception statement from your version.


If you didn't receive a copy of the file COPYING.LGPL, contact:
      Free Software Foundation, Inc.,
      675 Mass Ave
      Cambridge, MA  02139
      USA
}
unit USobre;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  RichBox, LResources;

type

  { TfrmSobre }

  TfrmSobre = class(TForm)
    Button1: TButton;
    lzRichEdit1: TlzRichEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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

procedure TfrmSobre.FormCreate(Sender: TObject);
var
  S:TMemoryStream;
  RTF:String='';
  P:PString;
begin
  S:= TMemoryStream.Create;
  S.Write(LazarusResources.Find('a').Value[1], Length(LazarusResources.Find('a').Value));
  lzRichEdit1.LoadFromStream(S);
  S.Free;
end;

initialization
{$I a.res}
end.

