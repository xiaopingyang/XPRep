
-- view raw calculation speed
select benchmark(100000000, 1+2+3+4+5+6+7+8+9);
select benchmark(100000000, 'select * from actor wherr first_name like ''x%''');


show profiles;
-- view execution statistics
show profile for query 2;






