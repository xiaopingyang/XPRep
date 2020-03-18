/* Factors that can affect security.
	strong passwords
    adequate user role security
    application security

*/

GRANT SELECT ON sakila.customer TO testUser@'%';
GRANT SELECT ON test.* TO 'testUser'@'%';
GRANT INSERT ON test.* TO 'testUser'@'%';
select host from mysql.user where user = 'testUser'; -- % only
show grants for 'testUser'@'localHost'; -- doesn't work
show grants for 'testUser'@'%';
show grants for 'sakilaUser'@'%'; -- who has SELECT on all of objects.

revoke select on sakila.* from 'sakilaUser'@'%';
use sakila;
create view customer_payments as 
select sakila.customer.customer_id,
		sakila.customer.first_name,
        sakila.customer.last_name,
        SUM(sakila.payment.amount) as Sum_amount
from sakila.customer
inner join sakila.rental on sakila.rental.customer_id = sakila.customer.customer_id
inner join sakila.payment on sakila.payment.customer_id=sakila.customer.customer_id and 
			sakila.payment.rental_id = sakila.rental.rental_id
group by sakila.customer.customer_id, sakila.customer.first_name, sakila.customer.last_name;

-- give the user access to the view
GRANT SELECT on sakila.customer_payments to 'sakilaUser'@'%';














