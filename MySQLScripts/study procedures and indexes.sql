/*
IN 
OUT
INOUT
eg:
call sales_by_id(@sales_id)
call get_country_info(France, @population)
call setapp_version(@version, @increment)

*/
use sakila;
select * from language;

delimiter //
create procedure ins_lang (in in_langName varchar(20), out out_language_id int)
begin
	insert into language (name,last_update) values(in_langName, now());
    set out_language_id = last_insert_id();
end //
delimiter ;

call ins_lang ('Hindi', @ov);
select @ov;

/* ------------------------------------------------------------recursion
Recursion is the process of a stored procedure referencing or calling 
itself repeately until execution of the code is complete

set max_recursion_depth option (0 - 255)

delimiter $$;
create procedure calcTotal (IN number INT, OUT total INT)
BEGIN 
	declare parent_ID int default null;
    declare tmptotal INT default 0;
    declare tmptotal2 INT defaut 0;
		select parentid from test where id = number into parent_ID;
        select quantity from test where id = number into tmptotal;
		
        if parent_ID is NULL THEN set total = tmptotal;
        else
			call calctotal(parent_ID, tmptotal2);
            set total=tmtotal2*tmptotal;
		end if;
END $$
*/        
/* ------------------------------------------------------------TRIGGERS
BEFORE triggers: primarily for constraints or validation checking

AFTER triggers: for transactions, reacting to a change or for auditing
*/
select * from sakila.staff; -- two records

create table staff_audit (
	id  int(10) not null auto_increment primary key ,
	staff_id int(10) NOT NULL, 
	last_name varchar(50) not null, 
	changed_to varchar(50) not null, 
	changed_on datetime DEFAULT NULL,
    action varchar(50) default null
);

delimiter //
create trigger tr_after_update_staff after update on staff for each row 
begin 
	insert into staff_audit 
    set action ='update',
    staff_id = OLD.staff_id,
    last_name = OLD.last_name,
    changed_to = NEW.last_name,
    changed_on = curdate();

end //
delimiter ;


update staff set last_name = 'Stevens'
where staff_id =2;
select * from staff_audit;

show indexes from staff;
create index idx_fn on staff (store_id asc, first_name asc, last_name asc);

show index from film;
explain select length, rental_duration from film where length = 100 and rental_duration =5; -- 2 rows
explain select length, rental_duration from film where length = 100 or rental_duration =5; -- 201 rows
create index idx_film_length on film (length);
create index idx_film_rental_duration on film (rental_duration);
create index idx_film_coverig_length_duration on film (length, rental_duration);

drop index idx_film_length on film;
drop index idx_film_rental_duration on film;
drop index idx_film_coverig_length_duration on film;

select * from film;
show index from film;
explain select title, length from film
where title ='agent truman';

explain select title, length from film
where title ='agent truman' or length =169;

create index idx_film_length on film(length);


/*------------------------------------------------------------Covered indexes
. All columns referenced in a select statement have indexes defined for these columns.
. When retrieving data MySQL need only read the index pages to locate teh data
. Data pages themselves are not read, speeding up the retrieval of data
. Pages within an indes are always sorted for fast access
*/
show indexes from actor; -- PRIMARY and idx_actor_last_name

explain select actor_id, last_name from actor; 

explain select first_name, last_name from actor;
alter table actor 
	drop index idx_actor_last_name, 
    add index idx_actor_full_name (last_name asc, first_name asc);
-- Let's rollback as it was
alter table actor 
	drop index idx_actor_full_name, 
    add index idx_actor_last_name (last_name asc);

/*------------------------------------------------------------Index Hints/query hints/optimizer hints
*/
explain select actor_id, last_name from actor -- use index (idx_actor_last_name)
where actor_id = 50 
order by last_name
 
explain select actor_id, last_name from actor use index (idx_actor_last_name)
where actor_id = 50 
order by last_name
--- other valid uses
	-- use/ignore/force index for join
	--							  order by	
    --                            group by


/*------------------------------------------------------------Index fragmentation and maintenance 
Causes:
large insertions/imports on clustered indexes. records need to be inserted into pages that are alrady full. Page splitting occurs.
large delete or export operations may leave many empty pages.

Can be maintained by rebuilding or reorganizing the indexes
Can be a demanding process for large tables

execute OPTIMIZE TABLE command
For storage engines that do not support OPTIMIZE TABLE perform a 'null table alter'.
ALTER TABLE table_name ENGINE = engine_name;

DROP and recreate the index

Selectivity is a measure of how much the index narrows the search for values. 
The selectivity of a specific value is the number of rows with that value, divided by the total number of rows. 
A lower selectivity value is better: it means fewer rows to scan and filter. 
Oddly, though, we say an index is “highly” selective if it has a low selectivity value.
*/

------------------------------------------------------------Analyize table Check 
show indexes from actor;
select last_name, count(last_name) as Cardinality from actor group by last_name; -- 123 rows

-- Perform a NULL Alter to rebuild table (all indexes rebuilt)
alter table actor engine = InnoDB;

drop index idx_actor_last_name on actor;
drop index idx_actor_last_name1 on actor;
create index idx_actor_last_name on actor(last_name);

analyze table actor; -- update index statistical information
insert into actor values(210,'XMAN','XMAN',default);
insert into actor values(211,'Xuehong','Kang',default);
explain select * from actor where last_name like 'kang';

select avg(salary)
from employees.salaries