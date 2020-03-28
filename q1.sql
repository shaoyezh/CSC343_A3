/*
For each dive category from open water, cave, 
or beyond 30 meters, list the number of dive sites 
that provide that dive type and have at least one 
monitor with booking privileges with them who will 
supervise groups for that type of dive.
*/

SET SEARCH_PATH TO wetworldschema;
DROP TABLE IF EXISTS q1 CASCADE;

CREATE TABLE q1 (
    openwater int,
    cavedive int,
    deepwater int
);

drop view if EXISTS SiteMonitorCapacity CASCADE;

create view SiteMonitorCapacity as 
select * from sitemonitor, monitorcapacity
where name = monitor;

create view openwater as 
select count(distinct site) as openwater 
from SiteMonitorCapacity
where openwater != 0;

create view cavedive as 
select count(distinct site) as cave 
from SiteMonitorCapacity
where cave != 0;

create view deepwater as 
select count(distinct site) as deepwater
from SiteMonitorCapacity
where deepwater != 0;

Insert into q1
select * from openwater, cavedive, deepwater;




