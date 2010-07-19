{---------------------------------------------------------------------}
{ News Center                                                         }
{ Example of FreeSpider CGI web application in Free Pascal / Lazarus  }
{ Written by Motaz Abdel azeem     http://motaz.freevar.com           }
{ 4.Mar.2010                                                          }
{ Don't forget to change IBConnection settings to proper news.fdb     }
{ Parameters                                                          }
{---------------------------------------------------------------------}

Program news;


Uses
{$IFDEF UNIX}{$IFDEF UseCThreads}
  CThreads,
{$ENDIF}{$ENDIF}
  Interfaces, SQLDBLaz, main;

{$R *.res}

begin
  DataModule1:= TDataModule1.Create(nil)
end.
