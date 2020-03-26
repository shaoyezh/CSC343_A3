drop schema if exists wetworldschema cascade;
create schema wetworldschema;
set search_path to wetworldschema;

/* user define type for certifacte */
create domain Certificate as varchar(4)
	check (value in ('NAUI','CMAS','PADI'));

/* user define type for time*/ 
create domain TimePeriod as text
	check (value in ('morning', 'afternoon', 'night'));

/*  user define type for dive type */ 
create domain DiveType as text
	check (value in ('open water', 'cave dive', 'deeper than 30 meters'));

/*  table that records all divers*/ 
create table Diver(
	name text primary key not null, 
	certificate Certificate not null,
	born date not null,
	email text not null
);

/*  table that record all lead.*/ 
create table Leader(
	name text primary key references Diver(name),
	creditCard text not null
);

/* information about each dive site*/ 
create table DiveSite(
	name text primary key,
	openWater boolean not null, 
	caveDive boolean not null,
	deeperDive boolean not null,
	dayMaxima integer not null,
	nightMaxima integer not null,
	caveMaxima integer not null, 
	deeperMaxima integer not null,
	diveFee integer not null,
	check (diveFee >= 0),
	constraint diffMaxima
		check ((dayMaxima > nightMaxima) and 
		(dayMaxima > caveMaxima) and (dayMaxima > deeperMaxima))
);

/*  table that records all monitors*/ 
create table Monitor(
	name text primary key
);

create table MonitorPrice(
	name text references Monitor,
	site text references DiveSite(name),
	timing TimePeriod not null,
	diveType DiveType not null,
	price Real not null,
	primary key (name,site, timing, diveType)
);

/* table that tells the capacity of each monitor.*/ 
create table MonitorCapacity(
	name text references Monitor,
	openWater int not null,
	cave int not null, 
	deepWater int not null,
	primary key (name),
	check (openWater >= 0 and cave >= 0 and deepWater >= 0)
);

create table SiteMonitor(
	site text references DiveSite(name),
	monitor text references Monitor,
	primary key(site, monitor)
);

-- /* The additional services provided by sites.*/ 
-- create table DiveSiteServices(
-- 	name text primary key references DiveSite(name), 
-- 	mask boolean,
-- 	regulator boolean,
-- 	fins boolean,
-- 	diveComputer boolean
-- );

/*  Price for each additional services provided by sites,
charge 0 if that service is not provided*/ 
create table DiveSiteServicesFee(
	name text references DiveSite(name), 
	mask Real not null,
	regulator Real not null,
	fins Real not null,
	diveComputer Real not null, 
	primary key (name)
);

/*  THe free serviese provided */ 
create table DiveSiteFreeServices(
	name text references DiveSite(name),
	video boolean not null,
	snacks boolean not null,
	showers boolean not null,
	towel boolean not null,
	primary key (name)
);

/*  all booking information*/ 
create table Booking(
	ID integer primary key,
	leader text references Leader(name),
	day date not null,
	timePeriod TimePeriod not null,
	site text references DiveSite(name),
	diveType DiveType,
	monitor text references Monitor(name)
);

/* table about how divers of each diving events are grouped. */ 
create table DiveEvent(
	diver text references Diver(name),
	bookingID integer references Booking(ID),
	primary key (diver, bookingID)
);

/*  Rate of site*/ 
create table SiteRate(
	diver text references Diver(name),
	site text not null,
	siteRate int not null,
	primary key(diver, site), 
	check (siteRate >= 0 and siteRate <= 5)
);

/*  Rate fo monitor*/ 
create table MonitorRate(
	bookingID int primary key references Booking(ID),
	monitorRate int not null,
	check (monitorRate >= 0 and monitorRate <= 5)
);


