(*
  Unit CEPLivre 1.0, Consultar CEP online gratuitamente.
  Copyright (C) 2010-2012 Silvio Clecio - admin@silvioprog.com.br

  http://blog.silvioprog.com.br

  See the file LGPL.2.1_modified.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

(*
  Powerfull contributors
  . Daniel Simões de Almeida
  . Kingbizugo
*)

unit CEPLivreReg;

{$mode objfpc}{$H+}

interface

uses
  LResources, Classes, CEPLivre;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CEPLivre', [TCEPLivre]);
end;

initialization
  {$I CEPLivreReg.lrs}

end.

