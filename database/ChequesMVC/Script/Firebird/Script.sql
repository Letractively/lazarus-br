CREATE GENERATOR SEQ_CHEQUES;

CREATE DOMAIN "BOOLEAN"
 AS Varchar(1)
 DEFAULT 'F'
 NOT NULL
 check (value in ('F','T'))
 COLLATE NONE;

CREATE TABLE BANCO
(
  OID Integer NOT NULL,
  CODIGO Varchar(10),
  NOME Varchar(20) NOT NULL,
  AGENCIA Varchar(10),
  CONSTRAINT PK_OIDBANCO PRIMARY KEY (OID)
);

CREATE TABLE CHEQUE
(
  OID Integer NOT NULL,
  OIDBANCO Integer NOT NULL,
  OIDCONTA Integer NOT NULL,
  OIDDESTINO Integer NOT NULL,
  NUMERO Varchar(10),
  VENCIMENTO Date NOT NULL,
  OIDMES Integer NOT NULL,
  VALOR Numeric(17,2) NOT NULL,
  PAGO "BOOLEAN" DEFAULT 'f',
  CONSTRAINT PK_OIDCHEQUE PRIMARY KEY (OID)
);

CREATE TABLE CONTA
(
  OID Integer NOT NULL,
  NOME Varchar(10) NOT NULL,
  CONSTRAINT PK_OIDCONTA PRIMARY KEY (OID)
);

CREATE TABLE DESTINO
(
  OID Integer NOT NULL,
  NOME Varchar(50) NOT NULL,
  ENDERECO Varchar(30),
  CPF Varchar(11),
  TELEFONE Varchar(10),
  CELULAR Varchar(10),
  EMAIL Varchar(50),
  CONSTRAINT PK_OIDDESTINO PRIMARY KEY (OID)
);

CREATE TABLE MES
(
  OID Integer NOT NULL,
  NOME Varchar(9) NOT NULL,
  CONSTRAINT PK_OIDMES PRIMARY KEY (OID)
);

SET TERM ^ ;
CREATE TRIGGER TRI_OIDBANCO FOR BANCO ACTIVE
BEFORE INSERT POSITION 0
AS 
BEGIN 
  IF (NEW.OID IS NULL) THEN
    NEW.OID = GEN_ID(SEQ_CHEQUES, 1);
END^
SET TERM ; ^

SET TERM ^ ;
CREATE TRIGGER TRI_OIDCHEQUE FOR CHEQUE ACTIVE
BEFORE INSERT POSITION 0
AS 
BEGIN 
  IF (NEW.OID IS NULL) THEN
    NEW.OID = GEN_ID(SEQ_CHEQUES, 1);
END^
SET TERM ; ^

SET TERM ^ ;
CREATE TRIGGER TRI_OIDCONTA FOR CONTA ACTIVE
BEFORE INSERT POSITION 0
AS 
BEGIN 
  IF (NEW.OID IS NULL) THEN
    NEW.OID = GEN_ID(SEQ_CHEQUES, 1);
END^
SET TERM ; ^

SET TERM ^ ;
CREATE TRIGGER TRI_OIDDESTINO FOR DESTINO ACTIVE
BEFORE INSERT POSITION 0
AS 
BEGIN 
  IF (NEW.OID IS NULL) THEN
    NEW.OID = GEN_ID(SEQ_CHEQUES, 1);
END^
SET TERM ; ^

SET TERM ^ ;
CREATE TRIGGER TRI_OIDMES FOR MES ACTIVE
BEFORE INSERT POSITION 0
AS 
BEGIN 
  IF (NEW.OID IS NULL) THEN
    NEW.OID = GEN_ID(SEQ_CHEQUES, 1);
END^
SET TERM ; ^

ALTER TABLE CHEQUE ADD CONSTRAINT FK_OIDBANCO_CHEQUE
  FOREIGN KEY (OIDBANCO) REFERENCES BANCO (OID) ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE CHEQUE ADD CONSTRAINT FK_OIDCONTA_CHEQUE
  FOREIGN KEY (OIDCONTA) REFERENCES CONTA (OID) ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE CHEQUE ADD CONSTRAINT FK_OIDDESTINO_CHEQUE
  FOREIGN KEY (OIDDESTINO) REFERENCES DESTINO (OID) ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE CHEQUE ADD CONSTRAINT FK_OIDMES
  FOREIGN KEY (OIDMES) REFERENCES MES (OID) ON UPDATE NO ACTION ON DELETE NO ACTION;
