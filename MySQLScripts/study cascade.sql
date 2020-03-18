/* cascase in mySQL
CASCADE option allows you to Delete or Update the Records in child table 
(i.e Foreign key table) automatically when Parent Table(i.e Primary key table) 
records are Updated or Deleted.

How to Update/Delete Records in child table when Parent table records are updated/deleted ?
Syntax: Foreign key(column_name) References table_name(column_name) ON UPDATE CASCADE ON DELETE CASCADE

*/
use test;
Create table Table1
 (ID_VAL int AUTO_INCREMENT PRIMARY KEY,
 NAME_VAL varchar(255),
 DESCRIPTION text,
 Picture varchar(255)
 ); 
 Insert into Table1(NAME_VAL,DESCRIPTION,Picture)
 values('abcd','bla bla bla','pic.jpg'),
 ('xyz','bla bla bla','pic1.jpg');

select * from Table1; 

Create table Table2
 (ID_val int AUTO_INCREMENT PRIMARY KEY,
 NAME_val varchar(255),
 Table1_ID int,
 FOREIGN KEY(Table1_ID) REFERENCES Table1(ID_VAL) ON UPDATE CASCADE ON DELETE CASCADE); 
Insert INTO table2
 (NAME_val,Table1_ID)
 Values('name1',1),
 ('name2',1),
 ('name3',2),
 ('name4',2);

Select * from Table2;

-- Update some record in Parent table(Table1)
SET SQL_SAFE_UPDATES = 0;
Update table1 set ID_VAL=5 where NAME_VAL='abcd'; 

Select * from Table1;

Select * from Table2; 

show global variables like '%query_cache%';


