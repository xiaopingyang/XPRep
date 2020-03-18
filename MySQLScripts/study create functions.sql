use sakila;
drop function if exists getActorName ;
SET GLOBAL log_bin_trust_function_creators = 1;
show global variables like 'log_bin_trust%';

delimiter //
create function getActorName (a_id int) returns varchar(91)
begin
	declare actor_name varchar(91);
	select concat(first_name, ' ', last_name) into actor_name from actor 
    where actor_id = a_id;
	return (actor_name);
end //
delimiter ;

select getActorName(13) as Cust_3;

select  concat(first_name, ' ', last_name) from actor limited 
