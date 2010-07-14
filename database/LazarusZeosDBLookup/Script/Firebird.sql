create generator g_main;

create table produto (
 id integer not null,
 nome varchar(30) not null,
 valor numeric(17,2) not null,
 constraint pk_idproduto
  primary key (id),
 constraint unq_nomeproduto
  unique (nome));

create table pedido (
 id integer not null,
 nomeproduto varchar(30) not null,
 valor numeric(17,2) not null,
 constraint pk_idpedido
  primary key (id),
 constraint fk_nomeproduto_pedido
  foreign key (nomeproduto)
  references produto (nome)
  on update cascade
  on delete no action);