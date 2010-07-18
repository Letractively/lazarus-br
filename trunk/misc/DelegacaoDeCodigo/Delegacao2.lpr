///////////////////////////////////////////
// ------------------------------------- //
// Qualquer colaboracao sera bem-vinda!  //
// Nome: Silvio Clecio                   //
// Banco: Bradesco                       //
// Agencia: 3045-7                       //
// Conta-corrente: 55597-5               //
// ------------------------------------- //
// Any collaboration will be welcome!    //
// Name: Silvio Clecio                   //
// Bank: Bradesco                        //
// Agency: 3045-7                        //
// Account: 55597-5                      //
// ------------------------------------- //
///////////////////////////////////////////
//              __________               //
//            .'----------`.             //
//            | .--------. |             //
//            | |  FREE  | |             //
//            | |SOFTWARE| |             //
//            | `--------' |             //
//            `----.--.----'             //
//           ______|__|______            //
//          /  %%%%%%%%%%%%  \           //
//         /  %%%%%%%%%%%%%%  \          //
//         ^^^^^^^^^^^^^^^^^^^^          //
///////////////////////////////////////////
//    .--------{SC Softwares}----------. //
//   /    silvioprog@yahoo.com.br     /  //
//  /     -----------------------    /   //
// / http://silvioprog.blogspot.com /    //
// `-------------------------------´     //
{*****************************************}
{     -:- Conheca o PressObjects -:-      }
{      http://br.pressobjects.org/        }
{*****************************************}
program Delegacao2;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms, Delegacao2MainFrm, CalcUtils, CalcClass;

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

