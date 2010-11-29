CREATE GENERATOR SEQ_OIDTEST;

CREATE TABLE TEST
(
  OID integer NOT NULL,
  IMAGE blob sub_type 1,
  CONSTRAINT PK_OIDTEST PRIMARY KEY (OID)
);

SET TERM ^ ;
CREATE TRIGGER TRI_OIDTEST FOR TEST ACTIVE
BEFORE INSERT POSITION 0
AS
BEGIN
  IF (NEW.OID IS NULL) THEN
    NEW.OID = GEN_ID(SEQ_OIDTEST,1);
END^
SET TERM ; ^