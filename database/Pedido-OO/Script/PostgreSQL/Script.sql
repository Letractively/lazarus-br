CREATE TABLE produto
(
  oid integer NOT NULL,
  descricao character varying(30) NOT NULL,
  unidade character varying(3),
  preco numeric(17,2) NOT NULL,
  CONSTRAINT pk_oidproduto PRIMARY KEY (oid)
);

CREATE INDEX descricaoproduto
   ON produto (unidade);

CREATE TABLE pedido
(
  oid integer NOT NULL,
  numeropedido integer NOT NULL,
  data date,
  totalgeral numeric(17,2),
  CONSTRAINT pk_oidpedido PRIMARY KEY (oid)
);

CREATE TABLE pedidoitem
(
  oid integer NOT NULL,
  oidpedido integer NOT NULL,
  oidproduto integer NOT NULL,
  preco numeric(17,2) NOT NULL,
  quantidade integer NOT NULL,
  totalproduto numeric(17,2),
  CONSTRAINT pk_oidpedidoitem PRIMARY KEY (oid),
  CONSTRAINT fk_oidpedido_pedidoitem FOREIGN KEY (oidpedido)
      REFERENCES pedido (oid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_oidproduto_pedidoitem FOREIGN KEY (oidproduto)
      REFERENCES produto (oid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE SEQUENCE seq_mainsequence
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

CREATE SEQUENCE seq_numeropedido
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
