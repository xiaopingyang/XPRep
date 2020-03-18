/* study MySQL LOOP statements
Three loop statements in MySQL:
WHILE expression DO ,,,
REPEAT ... UNTIL expression
LOOP 
 
*/
 DELIMITER $$
    CREATE  PROCEDURE   whileLoop()
    BEGIN
         DECLARE x INT;
		 DECLARE    str      VARCHAR(100);
         SET x = 1;
         SET str = '' ;
         WHILE    x <= 10    DO
            SET   str  =  CONCAT(str,x,',');
            SET   x    =  x + 1;
		 END WHILE;
         SELECT  str;
	END$$
DELIMITER ;
call whileloop;
 
delimiter $$
	create procedure repeatLoop()
	begin
		declare x int;
		declare str varchar(100);
		set x = 1;
		set str = '' ;
		repeat   
			set   str  =  concat(str,x,',');
			set   x    =  x + 1;
		until  x >=10
		end repeat;
		select  str;
	end$$
DELIMITER ;
call repeatloop;

drop procedure if exists looploop; 
DELIMITER $$
    CREATE  PROCEDURE   looploop()
    BEGIN
		DECLARE i INT DEFAULT 0;
        DECLARE str varchar(50) DEFAULT '';
		test_loop: 	LOOP
			SET str = concat(str, i,',');
			SET i = i + 1;
			IF i >=10 THEN 
				LEAVE test_loop; 
			END IF;
	END LOOP test_loop;
    select str;
END$$
DELIMITER ;
call looploop;


CREATE TABLE foo (a INT, PRIMARY KEY (a)) ENGINE =InnoDB;
show warnings;
CREATE DATABASE _

