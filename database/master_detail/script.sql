create table person (
  id serial not null,
  name character varying(50) not null,
  constraint pk_person
  primary key (id)
);

create table phone (
  id serial not null,
  personid integer not null,
  number character varying(10),
  constraint pk_phone
    primary key (id ),
  constraint fk_phone
    foreign key (personid)
    references person (id)
    on update cascade
    on delete cascade
);