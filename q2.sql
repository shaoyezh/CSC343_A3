/* Find monitors whose average rating is higher than 
that of all dives sites that the monitor uses. 
Report each of these monitor's average booking fee and email.
*/

SET SEARCH_PATH TO wetworldschema;
DROP TABLE IF EXISTS q2 CASCADE;

CREATE TABLE q2 (
    monitor text,
    email text, 
    price real
);

drop view if EXISTS MonitorAverage CASCADE;
drop view if EXISTS SiteMaxRate CASCADE;

create view MonitorAverage as 
select monitor, avg(monitorrate) as avg
from monitorrate join booking on bookingid = id
group by monitor;

create view SiteMaxRate as
select site, max(siterate) as maxrate
from siterate 
group by site;

create view SiteUsedByMonitorMaxRate as
select monitor, max(maxrate) as maxsite
from SiteMaxRate natural join SiteMonitor
group by monitor;

create view GoodMonitor as
select monitor
from MonitorAverage natural join SiteUsedByMonitorMaxRate
where avg > maxsite;

create view MonitorAvePrice as
select monitor, avg(price) as ave
from GoodMonitor join monitorprice on monitor = name
group by monitor;

Insert into q2
select monitor, email, ave
from MonitorAvePrice join Diver on monitor = name;





