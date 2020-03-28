-- 4. For each dive site report the highest, 
-- lowest, and average fee charged per dive.

SET SEARCH_PATH TO wetworldschema;
DROP TABLE IF EXISTS Q4 CASCADE;

create TABLE q4(
	site text,
	highest real,
	lowest real,
	average real
);

DROP view if EXISTS ExtraFee_help CASCADE;
Drop view if EXISTS Diverfee_help CASCADE;
Drop view if EXISTS NumDiver CASCADE;
drop view if EXISTS monitorFee CASCADE;
-- find the fee charged for additional services
create view ExtraFee_help as 
select bookingid, site, services
from Booking join BookExtraService on id = bookingid;

create view ExtraFee as 
select bookingid, sum(price) as ExtraFee
from ExtraFee_help join DiveSiteServicesFee on 
ExtraFee_help.site = DiveSiteServicesFee.site 
and DiveSiteServicesFee.service = ExtraFee_help.services
group by bookingid;

-- find the fee charged per diver
create view Diverfee_help as 
select ID, divefee
from booking join divesite on name = site;

/*
number of diver in each booking
*/
create view NumDiver as
select bookingid, count(diver) as num 
from diveevent
group by bookingid 
order by bookingid;

/*
consider the capacity of monitor
*/
create view NumAllowed as 
select bookingid, least(num, capacity) as num 
from NumDiver, monitorcapacity, booking 
where NumDiver.bookingid = booking.id and 
monitorcapacity.name = booking.monitor and
monitorcapacity.divetype = booking.divetype;

-- find the total fee charged on diveing, 
-- including the fee paid for monitor
create view Diverfee as 
select ID, divefee * (num + 1) as divefee
from Diverfee_help join NumAllowed on ID = bookingid;

-- find the fee for monitor
create view monitorFee as
select id, price
from booking join monitorprice on monitor = name and 
timeperiod = timing and monitorprice.divetype = booking.divetype
and monitorprice.site = booking.site;

-- Totalfee for each booking intermediate step
create view TotalFee_help as 
select id, (greatest(price,0)+ greatest(divefee,0)
	+ greatest(ExtraFee,0)) as total 
from (monitorFee natural right join Diverfee) 
left join ExtraFee on id = bookingid
order by id;

-- Totalfee for each booking.(include site name)
create view TotalFee as 
select booking.id, booking.site, total
from TotalFee_help natural join booking;

-- find the average, highest, lowest fee charged per dive for 
-- each dive site
create view result as 
select site, max(total), min(total), avg(total)
from Totalfee
group by site;

insert into q4 
select * from result;

