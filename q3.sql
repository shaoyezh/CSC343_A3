/*
 Find the average fee charged per dive (including extra charges)
 for dive sites that are more than half full on average, 
 and for those that are half full or less on average. 
 Consider both weekdays and weekends for which there is 
 booking information. Capacity includes all divers, 
 including monitors, at a site at a morning, afternoon, 
 or night dive opportunity.
 */

SET SEARCH_PATH TO wetworldschema;
DROP TABLE IF EXISTS Q3 CASCADE;

CREATE TABLE Q3(
	AvgFeeMoreThanHalf real, 
	AvgFeeLessThanHalf real
);

DROP view if EXISTS ExtraFee_help CASCADE;
Drop view if EXISTS Diverfee_help CASCADE;
Drop view if EXISTS NumDiver CASCADE;
drop view if EXISTS monitorFee CASCADE;
drop view if EXISTS SiteTotalCapacity CASCADE;

create view ExtraFee_help as 
select bookingid, site, services
from Booking join BookExtraService on id = bookingid;

create view ExtraFee as 
select bookingid, sum(price) as ExtraFee
from ExtraFee_help join DiveSiteServicesFee on 
ExtraFee_help.site = DiveSiteServicesFee.site 
and DiveSiteServicesFee.service = ExtraFee_help.services
group by bookingid;

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

create view Diverfee as 
select ID, divefee * (num + 1) as divefee
from Diverfee_help join NumAllowed on ID = bookingid;

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

/* find the capacity of site of each book.
*/
create view SiteTotalCapacity as 
select id, day, site, (2 * daymaxima + nightmaxima) as total_capacity
from booking join divesite on site = name;

/* find how many people booked of a site on each day
*/
create view SiteBooked as
select site, day, sum(num) as booked
from NumDiver join booking on bookingid = id
group by site, day
order by site;

-- add a column contain the capacity of each site.
create view SiteFullness as 
select site, day, booked, 
(2 * daymaxima + nightmaxima) as total_capacity
from SiteBooked join divesite on site = name;

-- find the fullness of each site on 
create view SiteFullnessAveragePercentage as 
select site, avg((booked/total_capacity)) as fullness
from SiteFullness
group by site;

-- site fullness more than half
create view TotalFeeOfMoreThanHalf as 
select total 
from SiteFullnessAveragePercentage join Totalfee on
Totalfee.site = SiteFullnessAveragePercentage.Site
where fullness > 0.5;

-- find the average fee charged per dive for dive site 
-- that are more than half fullness
create view AvgFeeMoreThanHalf as 
select avg(total) as MoreThanHalf from TotalFeeOfMoreThanHalf;


-- site fullnenss less than or equal to half
create view TotalFeeOfLessEqaulThanHalf as 
select total 
from SiteFullnessAveragePercentage join Totalfee on
Totalfee.site = SiteFullnessAveragePercentage.Site
where fullness <= 0.5;

-- find the average fee charged per dive for dive site 
-- that are less than or equal to half fullness
create view AvgFeeOfLessEqaulThanHalf as 
select avg(total) as LessThanHalf from TotalFeeOfLessEqaulThanHalf;

insert into Q3 
select * from AvgFeeMoreThanHalf, AvgFeeOfLessEqaulThanHalf;

