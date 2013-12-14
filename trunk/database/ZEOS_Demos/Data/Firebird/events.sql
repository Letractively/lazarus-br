SET TERM ^ ;
CREATE PROCEDURE EVENTDEMO (
    "EVENT" Varchar(40) )
AS
BEGIN SUSPEND; END^
SET TERM ; ^

SET TERM ^ ;
ALTER PROCEDURE EVENTDEMO (
    "EVENT" Varchar(40) )
AS
begin
  post_event :event;
end^
SET TERM ; ^