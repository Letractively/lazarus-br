create table [produto] (
 [id] integer constraint "pk_idproduto" not null primary key autoincrement,
 [nome] varchar(30) constraint "unq_nomeproduto" not null unique,
 [valor] numeric(18,2) not null);

create table [pedido] (
 [id] integer constraint "pk_idpedido" not null primary key autoincrement,
 [nomeproduto] VARCHAR(30) constraint "fk_nomeproduto_pedido" not null
  references [produto] (nome)
  on update cascade,
 [valor] numeric(18,2) not null);