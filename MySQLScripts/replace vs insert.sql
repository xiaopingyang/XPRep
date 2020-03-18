use xpdb;
explain
select * from cities where state like '%N%';

alter table cities add index ix_Cities_Name (Name);

insert into cities (Name, State) values ('Tacoma', 'WA'),('Spokane', 'WA'),('Vancouver', 'WA'),
('Olympia', 'WA'),('Portland', 'OR'),('Eugene', 'OR'),('Las Vegas', 'NV'),
('Reno', 'NV'),('Salt Lake City', 'UT'),('Charlotte', 'NC'),('Raleigh', 'NC'),
('Greensboro', 'NC'),('Durham', 'NC'),('Charlotte', 'NC'),('Columbus', 'GA'),
('Augusta', 'GA'),('Macon', 'GA'),('Savannah', 'GA'),('Athens', 'GA'),
('Sandy Springs', 'GA'),('Roswell', 'GA'),('Johns Creek', 'GA'),('Alpharetta', 'GA')

select * from cities where state ='WA';
replace into cities values (39, 'Buffalo','NY');
replace into cities values (40, 'New York City','NY');
replace into cities values (41, 'Rochester','NY');
replace into cities values (42, 'Yonkers','NY');

insert into states values ('NY', 'New York');
show variables like '%collation%';
show variables like '%connection%';
show status like '%connection%';

