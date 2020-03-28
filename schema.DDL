drop schema if exists wetworldschema cascade;
create schema wetworldschema;
set search_path to wetworldschema;

/* user define type for certifacte */
create domain Certificate as varchar(4)
	check (value in ('NAUI','CMAS','PADI'));

/* user define type for time*/ 
create domain TimePeriod as text
	check (value in ('morning', 'afternoon', 'night'));

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

-- information about what kind of dive type each site provide.
create table SiteDiveType(
	name text references DiveSite(name),
	diveType text not null,
	primary key(name, diveType),
	check (diveType in ('open water', 'cave dive', 'deep water'))
);

/*  table that records all monitors*/ 
create table Monitor(
	name text primary key references Diver(name)
);

-- records the monitor price at different time of day 
-- and different site
create table MonitorPrice(
	name text references Monitor,
	site text references DiveSite(name),
	timing TimePeriod not null,
	diveType text not null,
	price Real not null,
	primary key (name,site, timing, diveType),
	check (diveType in ('open water', 'cave dive', 'deep water'))
);

/* table that tells the capacity of each monitor.*/ 
create table MonitorCapacity(
	name text references Monitor,
	diveType text not null,
	capacity int,
	primary key (name, diveType),
	check (capacity >= 0),
	check (diveType in ('open water', 'cave dive', 'deep water'))
);

-- table that records the site that monitor has privilege with. 
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
	site text references DiveSite(name),
	service text,
	price int,
	check (service in ('mask', 'regulator', 'fins','divecomputer')),
	primary key(site, service)
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
	diveType text not null,
	monitor text references Monitor(name),
	unique (ID, leaderm day, timePeriod),
	check (diveType in ('open water', 'cave dive', 'deep water'))
);

-- holds the booking informatino of additional services
create table BookExtraService(
	bookingID integer references booking(ID),
	services text,
	primary key(bookingID, services)
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


