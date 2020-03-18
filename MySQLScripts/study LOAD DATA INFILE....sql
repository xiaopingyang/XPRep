/*
How To Upload Data to MySQL tables using mysqlimport

use test;
create table employee (
empno int, ename varchar(15), job varchar(10));

Create a test datafile employee.csv (C:\DataFiles) with fields delimited by tab as shown below.
#	cat 		employee.txt
100	John Doe	DBA
200	John Smith	Sysadmin
300	Raj Patel	Developer
*/
-- Upload tab delimited datafile to the table by using Table Data Import Wizard

-- Using mySQLImport (command line)
-- mysqlimport -u root -ptmppassword --local test employee.txt

show  variables like '%local_infile%';
show  variables like '%secure_file_priv%';
set GLOBAL local_infile = 1;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/employee.csv'
INTO TABLE test.employee
 FIELDS TERMINATED BY '\t'
 LINES TERMINATED BY '\n'
 (empno, ename, job);
select * from employee;

SELECT empno,ename,job INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/employee_outfile.csv'
  FIELDS TERMINATED BY ',' -- OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM test.employee;

select * from employee;
