create table person (
	id serial not null,
	name varchar(50) not null,
	constraint pk_person
		primary key (id)
);