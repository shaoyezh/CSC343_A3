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
drop view if EXISTS SiteMonitorCapacity CASCADE;
drop view if EXISTS SiteProvideOpen;
drop view if EXISTS SiteProvideCave;
drop view if EXISTS SiteProvideDeep;

-- find site and divetype that has monitor to supervise
create view SiteMonitorCapacity as 
select site, divetype from sitemonitor, monitorcapacity
where name = monitor and capacity != 0;

-- find site that has a monitor that supervise open water
create view SiteMonitorOpenWater as
select distinct site from SiteMonitorCapacity 
where divetype = 'open dive';

-- find site that has a monitor that supervise cave dive
create view SiteMonitorCave as 
select distinct site from SiteMonitorCapacity 
where divetype = 'cave dive';

-- find site that has a monitor that supervise deep water
create view SiteMonitorDeep as 
select distinct site from SiteMonitorCapacity 
where divetype = 'deep water';

-- find site provide open water
create view SiteProvideOpen as 
select name from sitedivetype where divetype = 'open water';

-- find site provide cave dive
create view SiteProvideCave as 
select name from sitedivetype where divetype = 'cave dive';

-- find site provide deep water
create view SiteProvideDeep as 
select name from sitedivetype where divetype = 'deep water';

-- count number of site that provide openwater 
-- and has monitor supervise it.
create view OpenWater as 
select count(*) as openwater
from SiteProvideOpen provide join SiteMonitorOpenWater monitor 
on name = site;

-- count number of site that provide cavedive 
-- and has monitor supervise it.
create view CaveDive as 
select count(*) as cavedive
from SiteProvideCave provide join SiteMonitorCave monitor 
on name = site;

-- count number of site that provide deepwater 
-- and has monitor supervise it.
create view DeepWater as 
select count(*) as DeepWater
from SiteProvideDeep provide join SiteMonitorDeep monitor 
on name = site;

Insert into q1
select * from OpenWater, CaveDive, DeepWater;




