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
	check (value in ('open water', 'cave diving', 'deeper than 30 meters'));

/*  table that records all divers*/ 
create table Diver(
	ID integer primary key not null,
	certificate Certificate not null,

	age integer not null 
		check (age >= 16),
	email text not null
);

/*  table that record all lead.*/ 
create table Leader(
	ID integer primary key references Diver(ID),
	creditCard text not null
);

/*  table that records all monitors*/ 
create table Monitor(
	name text primary key
);

create table MonitorPrice(
	name text references Monitor,
	timing TimePeriod not null,
	diveType DiveType not null,
	price Real not null,
	primary key (name, timing, diveType)
);

/* table that tells the capacity of each monitor.*/ 
create table MonitorCapacity(
	name text references Monitor,
	diveType DiveType not null,
	capacity int,
	primary key (name, diveType),
	check (capacity >= 0)
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
	check (diveFee >= 0)
	constraint diffMaxima
		check ((dayMaxima > nightMaxima) and 
		(dayMaxima > caveMaxima) and (dayMaxima > deeperMaxima))
);

/* The additional services provided by sites.*/ 
create table DiveSiteServices(
	name text primary key references DiveSite(name), 
	mask boolean,
	regulator boolean,
	fins boolean,
	diveComputer boolean
);

/*  Price for each additional services provided by sites */ 
create table DiveSiteServicesFee(
	name text references DiveSite(name), 
	mask Real,
	regulator Real,
	fins Real,
	diveComputer Real, 
	primary key (name)
);

/*  THe free serviese provided */ 
create table DiveSiteFreeServices(
	name text references DiveSite(name),
	video boolean,
	snacks boolean,
	showers boolean,
	towel boolean,
	primary key (name)
);

/*  all booking information*/ 
create table Booking(
	ID integer primary key,
	leader integer references Leader(ID),
	day date,
	timePeriod TimePeriod,
	site text references DiveSite(name),
	monitor text references Monitor(name)
);

/* table about how divers of each diving events are grouped. */ 
create table DiveEvent(
	diverID integer references Diver(ID),
	leadID integer references Leader(ID),
	bookingID integer references Booking(ID),
	primary key (diverID, leadID, bookingID)
);

/*  Rate of site*/ 
create table SiteRate(
	diverID integer references Diver(ID),
	site text not null,
	siteRate int not null,
	primary key(diverID, site), 
	check (siteRate >= 0 and siteRate <= 5)
);

/*  Rate fo monitor*/ 
create table MonitorRate(
	leadID integer references Leader(ID),
	monitor text references Monitor,
	monitorRate int not null,
	primary key(leadID, monitor),
	check (monitorRate >= 0 and monitorRate <= 5)
);


