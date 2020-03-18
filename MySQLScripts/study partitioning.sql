/*
https://www.vertabelo.com/blog/everything-you-need-to-know-about-mysql-partitions/
Key Benefits of Partitioning
Some of the advantages of using partitions are:

Storage: It is possible to store more data in one table than can be held on a single disk or file system partition.
Deletion: Dropping a useless partition is almost instantaneous, but a classical DELETE query run in a very large table could take minutes.
Partition Pruning: This is the ability to exclude non-matching partitions and their data from a search; it makes querying faster. Also, 
MySQL 5.7 supports explicit partition selection in queries, which greatly increases the search speed. (Obviously, this only works if you 
know in advance which partitions you want to use.) This also applies for DELETE, INSERT, REPLACE, and UPDATE statements as well as LOAD DATA 
and LOAD XML.
*/
CREATE TABLE userslogs (
    username VARCHAR(20) NOT NULL,
    logdata BLOB NOT NULL,
    created DATETIME NOT NULL,
    PRIMARY KEY(username, created)
)
PARTITION BY HASH( TO_DAYS(created) )
PARTITIONS 10;


-- RANGE Partitioning
CREATE TABLE userslogsRANGE (
    username VARCHAR(20) NOT NULL,
    logdata BLOB NOT NULL,
    created DATETIME NOT NULL,
    PRIMARY KEY(username, created)
)
PARTITION BY RANGE( YEAR(created) )(
    PARTITION from_2013_or_less VALUES LESS THAN (2014),
    PARTITION from_2014 VALUES LESS THAN (2015),
    PARTITION from_2015 VALUES LESS THAN (2016),
    PARTITION from_2016_and_up VALUES LESS THAN MAXVALUE);
    
CREATE TABLE rc1 (
    a INT,
    b INT
)
PARTITION BY RANGE COLUMNS(a, b) (
    PARTITION p0 VALUES LESS THAN (5, 12),
    PARTITION p3 VALUES LESS THAN (MAXVALUE, MAXVALUE)
);
INSERT INTO rc1 (a,b) VALUES (4,11);
INSERT INTO rc1 (a,b) VALUES (5,11);
INSERT INTO rc1 (a,b) VALUES (6,11);
INSERT INTO rc1 (a,b) VALUES (4,12);
INSERT INTO rc1 (a,b) VALUES (5,12);
INSERT INTO rc1 (a,b) VALUES (6,12);
INSERT INTO rc1 (a,b) VALUES (4,13);
INSERT INTO rc1 (a,b) VALUES (5,13);
INSERT INTO rc1 (a,b) VALUES (6,13);

SELECT *,'p0' FROM rc1 PARTITION (p0) UNION ALL SELECT *,'p3' FROM rc1 PARTITION (p3) ORDER BY a,b ASC;
/*
a	b 	Prt
4	11	p0
4	12	p0
4	13	p0
5	11	p0
5	12	p3
5	13	p3
6	11	p3
6	12	p3
6	13	p3
*/


-- LIST Partitioning
/* LIST partitioning is similar to RANGE, except that the partition is selected based on columns matching 
one of a set of discrete values. In this case, the VALUES IN statement will be used to define matching criteria.
Note that in LIST partitioning, there is no catch-all (like the MAXVALUE expression in RANGE). You must cover 
all possible elements in the criteria list to prevent an INSERT error.
*/
CREATE TABLE serverlogs (
    serverid INT NOT NULL, 
    logdata BLOB NOT NULL,
    created DATETIME NOT NULL
)
PARTITION BY LIST (serverid)(
    PARTITION server_east VALUES IN(1,43,65,12,56,73),
    PARTITION server_west VALUES IN(534,6422,196,956,22)
);

-- HASH Partitioning
CREATE TABLE serverlogs2 (
    serverid INT NOT NULL, 
    logdata BLOB NOT NULL,
    created DATETIME NOT NULL
)
PARTITION BY HASH (serverid)
PARTITIONS 10;

-- LINEAR HASH
CREATE TABLE serverlogs2Linear (
    serverid INT NOT NULL, 
    logdata BLOB NOT NULL,
    created DATETIME NOT NULL
)
PARTITION BY LINEAR HASH (serverid)
PARTITIONS 10;


-- KEY Partitioning
/* Here KEY() has been used without explicitly stating the partitioning column. 
MySQL will automatically use the primary key or a unique key as the partitioning 
column. If no unique keys are available, the statement will fail.
*/
CREATE TABLE serverlogs4 (
    serverid INT NOT NULL, 
    logdata BLOB NOT NULL,
    created DATETIME NOT NULL,
    UNIQUE KEY (serverid)
)
PARTITION BY KEY()
PARTITIONS 10;

/*********************************************************
A Typical Use Case: Time Series Data
Partitions are commonly used when dealing with a series 
of time data that contains a lot of records. These could 
be logs or records of phone calls, invoices, samples, etc. 
Most of the time, you’ll be reading fresh data, so there 
will be lots of old rows that need deleting once they get 
“stale”.

1.8 millions of Records in measures table.
**********************************************************/

CREATE TABLE `measures` (
  `measure_timestamp` datetime NOT NULL,
  `station_name` varchar(255) DEFAULT NULL,
  `wind_mtsperhour` int(11) NOT NULL,
  `windgust_mtsperhour` int(11) NOT NULL,
  `windangle` int(3) NOT NULL,
  `rain_mm` decimal(5,2),
  `temperature_dht11` int(5),
  `humidity_dht11` int(5),
  `barometric_pressure` decimal(10,2) NOT NULL,
  `barometric_temperature` decimal(10,0) NOT NULL,
  `lux` decimal(7,2),
  `is_plugged` tinyint(1),
  `battery_level` int(3),
  KEY `measure_timestamp` (`measure_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `partitioned_measures` (
  `measure_timestamp` datetime NOT NULL,
  `station_name` varchar(255) DEFAULT NULL,
  `wind_mtsperhour` int(11) NOT NULL,
  `windgust_mtsperhour` int(11) NOT NULL,
  `windangle` int(3) NOT NULL,
  `rain_mm` decimal(5,2),
  `temperature_dht11` int(5),
  `humidity_dht11` int(5),
  `barometric_pressure` decimal(10,2) NOT NULL,
  `barometric_temperature` decimal(10,0) NOT NULL,
  `lux` decimal(7,2),
  `is_plugged` tinyint(1),
  `battery_level` int(3),
  KEY `measure_timestamp` (`measure_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
 
ALTER TABLE partitioneddb.partitioned_measures
 PARTITION BY RANGE (YEAR(measure_timestamp)) (
    PARTITION to_delete_logs VALUES LESS THAN (2015),
    PARTITION prev_year_logs VALUES LESS THAN (2016),
    PARTITION current_logs VALUES LESS THAN (MAXVALUE)
 ) ;

SELECT SQL_NO_CACHE COUNT(*) FROM measures WHERE measure_timestamp >= '2016-01-01' AND DAYOFWEEK(measure_timestamp) = 1;  -- 1.35s
SELECT SQL_NO_CACHE COUNT(*) FROM partitioned_measures WHERE measure_timestamp >= '2016-01-01'AND DAYOFWEEK(measure_timestamp) = 1; -- 1.25s

ALTER TABLE measures DROP INDEX `measure_timestamp` ;
ALTER TABLE partitioned_measures DROP INDEX `measure_timestamp` ;

-- Run the above SELECTs
SELECT SQL_NO_CACHE COUNT(*) FROM measures WHERE measure_timestamp >= '2016-01-01' AND DAYOFWEEK(measure_timestamp) = 1;  -- 3.39s
SELECT SQL_NO_CACHE COUNT(*) FROM partitioned_measures WHERE measure_timestamp >= '2016-01-01'AND DAYOFWEEK(measure_timestamp) = 1; -- 1.704s
/* Conclusion: Running the SELECT on the nonpartitioned table takes about twice the time as the same query on the partitioned table.*/

-- Let's add the index back on the measure_timestamp column:
ALTER TABLE measures ADD INDEX `index1` (`measure_timestamp` ASC); -- 18.09 seconds
ALTER TABLE partitioned_measures ADD INDEX `index1` (`measure_timestamp` ASC); -- 15.9 seconds

-- Now let’s do a big delete on the nonpartitioned table:
DELETE FROM measures WHERE  measure_timestamp < '2015-01-01'; -- 18.02 seconds deleted 85314 rows.

ALTER TABLE partitioned_measures DROP PARTITION to_delete_logs ; -- 1.18 sec
DELETE FROM measures WHERE  measure_timestamp < '2016-01-01';  -- 57 seoncds

ALTER TABLE partitioned_measures DROP PARTITION prev_year_logs ; -- 1.76 seconds
/*
From personal experience, partitioning is the last part of any optimization process I’d perform. 
I’d do it only after exhausting other alternatives, like reworking slow queries. In general, 
partitioning makes the most sense when you’re dealing with millions of records. RANGE partition 
is the most useful. The best-fitting use case for RANGE is massively deleting old time-series data.

Several limitations – 
the way that unique and primary keys are generated; 
the fact that foreign keys are not allowed; 
the lack of support for full-text indexes, etc.
*/