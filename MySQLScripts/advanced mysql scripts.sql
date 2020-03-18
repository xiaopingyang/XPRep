SELECT first_name, last_name into @fname, @lname FROM sakila.actor limit 1;
SELECT @fname;
SELECT @lname;
select * from sakila.actor limit 1;

SELECT first_name, last_name INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/actor.txt'
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM  sakila.actor;

create table actorCopy select * from actor;
use xpdb;
create table city select * from sakila.city ;

use sakila;
drop table if exists payment_audit;
CREATE TABLE `payment_audit` (
  `audit_id` int NOT NULL auto_increment primary key,
  `payment_id` int(10) NOT NULL,
  `amount` decimal(5,2) NOT NULL,
  `changed_to` decimal(5,2) NOT NULL,
  `changed_on` datetime NOT NULL,
  `action` varchar(50) not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

delimiter //
create trigger trg_payment_audit_after_payment_update
 after update on payment
for each row 
begin
insert into payment_audit 
set action = 'Update',
	payment_id = old.payment_id,
    amount = old.amount,
    changed_to = new.amount,
    changed_on = now();
end //
delimiter ; 
-- drop trigger trg_payment_audit_after_payment_update;
select * from payment where payment_id=1;
-- 	1	1	1	76	2.99	2005-05-25 11:30:37	2006-02-15 22:12:30
update payment set amount =2.99 where payment_id in (1,2,3)

select * from payment_audit

SET GLOBAL event_scheduler = ON;
create event clear_payment_audit
on schedule every 3 minute
Do 
Truncate table payment_audit;
select * from payment_audit;
Drop event clear_payment_audit;

show events from sakila;
show processlist;




