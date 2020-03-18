use xpdb;
SET GLOBAL event_scheduler = ON;
CREATE TABLE messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    message VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL
);
select CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + 10

drop event if exists test_event_01;
CREATE EVENT test_event_01
ON SCHEDULE AT CURRENT_TIMESTAMP
DO
 Truncate table messages;

select * from messages for share;

drop event if exists test_event_02;
CREATE EVENT test_event_02
ON SCHEDULE EVERY 10 second 
STARTS CURRENT_TIMESTAMP 
ENDS CURRENT_TIMESTAMP + INTERVAL 10 minute
DO
	INSERT INTO messages(message,created_at)
	VALUES('Every 10 seconds within 10 minutes',NOW());
	commit;


CREATE EVENT test_event_04
ON SCHEDULE EVERY 20 second
STARTS CURRENT_TIMESTAMP
ENDS CURRENT_TIMESTAMP + INTERVAL 1 HOUR
DO
   INSERT INTO messages(message,created_at)
   VALUES('Event 4: insert an row every 20 seonds with One hour',NOW());
   commit;

show events ;
show variables like '%event_scheduler%'; 
show processlist

drop event if exists event5;
create event event5 on schedule every 10 second 
starts current_timestamp
ends  current_timestamp + interval 1 day
DO 
	delete from messages where created_at<current_timestamp  limit 1;
    commit;


select * from messages for share;

SET SESSION TRANSACTION ISOLATION LEVEL READ unCOMMITTED ;
SELECT * FROM xpdb.messages;
commit;


