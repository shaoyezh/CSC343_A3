Insert into DiveSite values
('Marine', true, true, true, 10, 8, 8, 8, 10),
('Widow Maker', true, true, true, 10, 8, 8, 8, 20),
('Crystal Bay', true, true, true, 10, 8, 8, 8, 15),
('Bolong', true, true, true, 10, 8, 8, 8, 15);

-- Insert into DiveSiteServices values
-- ('Marine', true, false, true, false),
-- ('Widow Maker', true, false, true, false),
-- ('Crystal Bay', false, false, true, true),
-- ('Bolong', true, false, false, true);
Insert into Diver values
('Micheal', 'PADI', '1967-03-15','michael@dm.org'),
('Dwight', 'PADI', '1970-04-04', 'dwight@dm.org'),
('Jim', 'PADI', '1980-10-10', 'jim@dm.org'),
('Pam','CMAS', '1990-10-20', 'pam@dm.org'),
('Andy','PADI', '1973-10-10', 'andy@dm.org'),
('Phyllis','PADI', '1973-10-10', 'Phyllis@dm.org'),
('Oscar','PADI', '1973-10-10', 'oscar@dm.org');

Insert into DiveSiteServicesFee values
('Marine',5,0,10,0),
('Widow Maker', 3, 0, 5,0),
('Crystal Bay', 0, 0,5, 20), 
('Bolong', 10, 0,0, 30);

Insert into SiteRate values
('Jim', 'Marine', 3),
('Dwight', 'Widow Maker', 0),
('Pam', 'Widow Maker', 1),
('Jim', 'Widow Maker', 2),
('Andy', 'Crystal Bay', 4),
('Pam', 'Crystal Bay', 5),
('Micheal', 'Crystal Bay', 2),
('Oscar', 'Crystal Bay', 3);

Insert into Monitor values
('Maria'),
('John'),
('Ben');
 
Insert into MonitorCapacity values
('Maria',10,5,5),
('John', 0,15,0),
('Ben', 15, 5, 5);

Insert into MonitorPrice values
('Maria', 'Marine', 'afternoon', 'cave dive', 25),
('Maria', 'Widow Maker', 'morning', 'cave dive', 20),
('Maria', 'Widow Maker', 'morning', 'open water', 10),
('Maria', 'Crystal Bay', 'afternoon', 'open water', 15),
('Maria', 'Bolong', 'morning', 'cave dive', 30),
('John', 'Marine', 'morning', 'cave dive', 15),
('Ben', 'Widow Maker', 'morning', 'cave dive'. 20);

Insert into MonitorRate values
(1, 2),
(2, 0),
(3, 5),
(5, 1),
(6, 0),
(7, 2)

Insert into Booking values
(1, 'Micheal', '2019-07-20', 'morning','Widow Maker','open water','Maria'),
(2, 'Micheal', '2019-07-21', 'morning','Widow Maker','cave dive','Maria'),
(3, 'Micheal', '2019-07-22', 'morning', 'Marine', 'cave dive','Ben'),
(4, 'Micheal', '2019-07-22', 'night', 'Marine', 'cave dive', 'Maria'),
(5, 'Andy', '2019-07-22', 'afternoon', 'Marine', 'open water', 'Maria'),
(6, 'Andy', '2019-07-23', 'morning', 'Widow Maker', 'cave dive', 'Ben'),
(7, 'Andy', '2019-07-24', 'morning', 'Widow Maker', 'cave dive', 'Ben');

Insert into DiveEvent values
('Micheal', 1),
('Dwight', 1),
('Jim', 1),
('Pam', 1),
('Andy', 1),
('Micheal', 2),
('Dwight', 2),
('Jim', 2),
('Micheal', 3),
('Jim', 3),
('Micheal', 4),
('Andy', 5),
('Dwight', 5),
('Jim', 5),
('Pam', 5),
('Micheal', 5),
('Phyllis', 5),
('Oscar', 5),
('Andy', 6),
('Andy', 7);












