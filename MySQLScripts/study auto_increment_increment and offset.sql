use test;
SHOW VARIABLES LIKE 'auto_inc%';
set @@auto_increment_offset =1;
set @@auto_increment_increment =1;
drop table autoinc1;
CREATE TABLE autoinc1
(col INT NOT NULL AUTO_INCREMENT PRIMARY KEY);
INSERT INTO autoinc1 VALUES (NULL), (NULL);
select * from autoinc1;
-- 1,2
SET @@auto_increment_increment=10;
INSERT INTO autoinc1 VALUES (NULL), (NULL);
select * from autoinc1;
-- 1,2,11,21 (increment + offset as 1st value, than after that just increment)
SET @@auto_increment_increment=100;
INSERT INTO autoinc1 VALUES (NULL), (NULL);
select * from autoinc1;
-- 1,2,11,21,101,201
SET @@auto_increment_increment=1000;
INSERT INTO autoinc1 VALUES (NULL), (NULL), (NULL), (NULL);
select * from autoinc1;
-- 1,2,11,21,101,201,1001,2001,3001,4001

SET @@auto_increment_offset=10;
INSERT INTO autoinc1 VALUES (NULL), (NULL);
select * from autoinc1;
-- 1,2,11,21,101,201,1001,2001,3001,4001,5010,6010
set auto_increment_increment=1000; 
set auto_increment_offset = 10;
truncate table autoinc1;
SHOW VARIABLES LIKE 'auto_inc%';
-- auto_increment_increment=1000; auto_increment_offset = 10
INSERT INTO autoinc1 VALUES (NULL), (NULL), (NULL), (NULL);
select * from autoinc1;
-- 10,1010,2010,3010
set @@auto_increment_increment =100;
SHOW VARIABLES LIKE 'auto_inc%';
-- auto_increment_increment=100; auto_increment_offset = 10
INSERT INTO autoinc1 VALUES (NULL),(NULL);
select * from autoinc1;
-- 10,1010,2010,3010,4010,4110 (1st value is the predicated 4010, then 4010+increment)
SET @@auto_increment_offset=5;
SHOW VARIABLES LIKE 'auto_inc%';
-- auto_increment_increment=100; auto_increment_offset = 5
INSERT INTO autoinc1 VALUES (NULL),(NULL);
select * from autoinc1;
-- 10,1010,2010,3010,4010,4110,4305,4405

SET @@auto_increment_offset=1;
set @@auto_increment_increment =1;
SHOW VARIABLES LIKE 'auto_inc%';
-- auto_increment_increment=1; auto_increment_offset = 1
INSERT INTO autoinc1 VALUES (NULL),(NULL);
select * from autoinc1;
-- 10,1010,2010,3010,4010,4110,4305,4405,4505,4506
truncate table autoinc1;
INSERT INTO autoinc1 VALUES (NULL),(NULL);
select * from autoinc1;
-- 1,2
SET @@auto_increment_offset=100;
set @@auto_increment_increment =10;
SHOW VARIABLES LIKE 'auto_inc%';
-- auto_increment_increment=10; auto_increment_offset = 100
INSERT INTO autoinc1 VALUES (NULL),(NULL);
select * from autoinc1;
-- 1,2,110,120
