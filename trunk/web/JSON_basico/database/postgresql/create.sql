CREATE TABLE cliente
(
  oid serial NOT NULL,
  nome character varying(100) NOT NULL,
  apelido character varying(20),
  idade integer,
  telefone character varying(10),
  CONSTRAINT pk_oidcliente PRIMARY KEY (oid)
);