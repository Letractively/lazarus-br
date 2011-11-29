unit Unit2; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs;
function Mensagem: Boolean;
implementation

function Mensagem: Boolean; alias : 'Mensagemmaluca';
begin
  ShowMessage('Olá código maluco');
  Result:= True;
end;

end.

