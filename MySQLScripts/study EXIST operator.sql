show variables like '%optimizer%';
use xpdb;
show keys in cities;
alter table cities drop key ix_Cities_Name

insert into states values('MI','Michigan')

alter table cities add constraint fk_cities_state foreign key (state) references states(state_short);
select e.firstname, e.lastname, e.departmentID from employees e 
select e.firstname, e.lastname, e.departmentID from employees1 e 

select e.firstname, e.lastname, e.departmentID from employees e 
where NOT exists (
select f.firstname, f.lastname, f.departmentID from employees1 f 
where f.firstname =e.firstname and f.lastname = e.lastname and f.departmentID = e.departmentID)

create table failtable (id int primary key, 
name varchar(50) )

alter table failtable modify name varchar(610); 

select current_date()

select * from %Connection%;
show status like "%connection%";
show procedure status
show variables like "%connection%";


