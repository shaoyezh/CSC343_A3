drop schema if exists wetworldschema cascade;
create schema wetworldschema;
set search_path to wetworldschema;

/* user define type for certifacte */
create domain Certificate as var(4)
	check (value in ('NAUI','CMAS','PADI'));

/* user define type for time*/ 
create domain TimePeriod as text
	check (value in ('morning', 'afternoon', 'night'));

/*  user define type for dive type */ 
create domain DiveType as text
	check (value in ('open water', 'cave diving', 'deeper than 30 meters'));

/*  user define type for Monitor Capacity of each site*/ 
create domain Capacity as int
	default 0
	check (value >= 0);

/*  user define type for Rating system*/ 
create domain Rating as int
	check (value >= 0 and value <= 5);

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
	ID integer primary key references Diver(ID), # foreign key constrain
	creditCard text not null
);

/*  table that records all monitors*/ 
create table Monitor(
	name text
	timing TimePeriod not null,
	diveType DiveType not null,
	price Real not null,
	primary key(name, timing, diveType)
);

/* table that tells the capacity of each monitor.*/ 
create table MonitorCapacity(
	ID integer references Monitor(ID),
	diveType DiveType not null,
	capacity Capacity,
	primary key(ID, diveType)
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
	constrain diffMaxima
		check dayMaxima > nightMaxima and 
		dayMaxima > cave and dayMaxima > deeperMaxima
);

/* The additional services provided by sites.*/ 
create table DiveSiteServices(
	name text references DiveSite(name), 
	mask boolean,
	regulator boolean,
	fins boolean,
	diveComputer boolean
	primary key(name)
);

/*  Price for each additional services provided by sites */ 
create table DiveSiteServicesFee(
	name text references DiveSite(name), 
	mask Real,
	regulator Real,
	fins Real,
	diveComputer Real
	primary key(name)
);

/*  THe free serviese provided */ 
create table DiveSiteFreeServices(
	name text references DiveSite(name),
	video boolean,
	snacks boolean,
	showers boolean,
	towel boolean,
	primary key(name)
);

/*  all booking information*/ 
create table Booking(
	leader integer references Leader(ID),
	day date,
	timePeriod TimePeriod,
	site text references DiveSite(name),
	monitor text references Monitor(name),
	primary key(leader, day, timePeriod)
);

/* table about how divers of each diving events are grouped. */ 
create table DiveEvent(
	diverID references Diver(ID),
	day date references Booking(day),
	timePeriod TimePeriod references Booking(timePeriod),
	leadID references Leader(ID),
	primary key(diverID, day, timePeriod)
);

/*  Rate of site*/ 
create table SiteRate(
	diverID integer references Diver(ID),
	site text ,
	siteRate Rating, 
	primary key(diverID, site)
)

/*  Rate fo monitor*/ 
create table MonitorRate(
	leadID integer references Leader(ID),
	monitor text references Monitor,
	monitorRate Rating not null,
	primary key(leadID, monitor)
)


