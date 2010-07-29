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

unit ChequeConsts;

{$I cheques.inc}

interface

const
  // Config consts
  C_database = 'database';
  C_hostname = 'hostname';
  C_password = 'password';
  C_port = 'port';
  C_protocol = 'protocol';
  C_user = 'user';

  // Msg error
  CInvalidQueryIntance = 'Instancia inválida de uma query para um model.';
  CRequestFillField = 'Por favor, preencha o campo que será focado.';
  CRequestSearchValue = 'Por favor, informe um valor para localizar.';
  CRequestMinimalSearch = 'Defina pelo menos 3 caracteres para localizar.';
  CViewFormRegError = 'ViewForm não registrada em "%s".';
  CFormateDateError = 'Formato de data inválido.';
  C0RecordsUpdatedError = 'O registro parece estar sendo manipulado por outra transação.';
  CFKError = 'Você esta tentando excluir um registro que esta sendo usando por outra tabela.';

  // Msg
  CQuestionCap = 'Confirmação';
  CDeleteConfirm = 'Excluir registro?';

  // SQL
  CFKSQLPgSQLite = ' where %s = (select %s from %s %s order by %s limit 1) ';
  CFKSQLFirebird = ' where %s = (select first 1 %s from %s %s) ';
  CLikeBoolean = ' where lower(%s) = ''%s'' ';
  CLikeBooleanPg = ' where %s = ''%s'' ';
  CLikeString = ' where lower(%s) like ''%%%s%%'' ';
  CLikeNumber = ' where %s = %s ';
  CLikeDate = ' where %s = ''%s'' ';

  // Regional settings
  CShortDateFormat = 'dd/MM/yyyy';
  CCurrencyString = 'R$';
  CCurrencyFormat = 0;
  CNegCurrFormat = 14;
  CThousandSeparator = '.';
  CDecimalSeparator = ',';
  CCurrencyDecimals = 2;
  CDateSeparator = '/';
  CTimeSeparator = ':';
  CTimeAMString = 'AM';
  CTimePMString = 'PM';
  CShortTimeFormat = 'hh:mm:ss';

  CDocPath =
{$ifdef unix}
    '/opt/Cheques/Doc/';
{$else}
    {$I %programfiles%} + '\Cheques\Doc\';
{$endif}
  CHelpFileName = CDocPath + 'help.html';
  CPgDateFrmt = 'dd/mm/yyyy';
  CSQLiteDateFrmt = 'yyyy-mm-dd';
  CFirebirdDateFrmt = 'dd.mm.yyyy';
  CDefaultSessionProperties = 'Left;Top;Height;Width;';
  CDefaultDBSessionProperties = 'ListDBGrid.Columns;SearchEdit.Text;';
  CDBConfigFileName = 'cheques-conf';
  CPgProtocol = 'postgresql';
  CSQLiteProtocol = 'sqlite';
  CFirebirdProtocol = 'firebird';
  CSQLite3Protocol = 'sqlite-3';
  CGenericSelectSQL = 'select * from';
  CDefaultOrderByField = 'order by oid';
  CDefaultSearchEditText = 'Registro para Localizar...';
  CHTMLTempFileName = 'shtmlr.html';
  CNao = 'Não';
  CSim = 'Sim';

implementation

end.

