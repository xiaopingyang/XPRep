-- -----------------------------------------------------------------
-- Copyright 2013 Code Strategies                                --
-- This code may be freely used and distributed in any project.  --
-- However, please do not remove this credit if you publish this --
-- code in paper or electronic form, such as on a web site.      --
-- -----------------------------------------------------------------
-- usage (mysql command line):
-- source C:/Users/Xiaoyang/Documents/MySQLScripts/testsource_table.sql;
USE testSource;
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (id INT, first_name VARCHAR(20), last_name VARCHAR(30));
INSERT INTO employees (id, first_name, last_name) VALUES (1, 'John', 'Doe');
INSERT INTO employees (id, first_name, last_name) VALUES (2, 'Bob', 'Smith');
INSERT INTO employees (id, first_name, last_name) VALUES (3, 'Jane', 'Doe');
SELECT * FROM employees;
