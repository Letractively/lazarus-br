CREATE TABLE mes
(
  oid serial NOT NULL,
  nome character varying(9) NOT NULL,
  CONSTRAINT pk_oidmes PRIMARY KEY (oid)
);

CREATE TABLE banco
(
  oid serial NOT NULL,
  codigo character varying(10),
  nome character varying(20) NOT NULL,
  agencia character varying(10),
  CONSTRAINT pk_oidbanco PRIMARY KEY (oid)
);

CREATE TABLE conta
(
  oid serial NOT NULL,
  nome character varying(10) NOT NULL,
  CONSTRAINT pk_oidconta PRIMARY KEY (oid)
);

CREATE TABLE destino
(
  oid serial NOT NULL,
  nome character varying(50) NOT NULL,
  endereco character varying(30),
  cpf character varying(11),
  telefone character varying(10),
  celular character varying(10),
  email character varying(50),
  CONSTRAINT pk_oiddestino PRIMARY KEY (oid)
);

CREATE TABLE cheque
(
  oid serial NOT NULL,
  oidbanco integer NOT NULL,
  oidconta integer NOT NULL,
  oiddestino integer NOT NULL,
  numero character varying(10),
  vencimento date NOT NULL,
  oidmes integer NOT NULL,
  valor numeric(17,2) NOT NULL,
  pago boolean DEFAULT false,
  CONSTRAINT pk_oidcheque PRIMARY KEY (oid),
  CONSTRAINT fk_oidbanco_cheque FOREIGN KEY (oidbanco)
      REFERENCES banco (oid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_oidconta_cheque FOREIGN KEY (oidconta)
      REFERENCES conta (oid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_oiddestino_cheque FOREIGN KEY (oiddestino)
      REFERENCES destino (oid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_oidmes_cheque FOREIGN KEY (oidmes)
      REFERENCES mes (oid) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
