-- 5200 Semester Project
-- Homeless Shelter Database

--------------------------------------------------
-- NOTE: Redundant script, has been split to createTables and createProcedures scripts
--------------------------------------------------

drop database if exists homeful;
create database if not exists homeful;
use homeful;

drop table if exists State;
create table if not exists State (
	state_id INT PRIMARY KEY AUTO_INCREMENT,
    state VARCHAR(2)
);

insert into State values (1, 'MA');

select * from State;

drop table if exists City;
create table if not exists City (
	city_id INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(100),
	state_id INT,
    constraint City_fk_State foreign key (state_id) references State (state_id)
);

insert into City values (1, 'Boston', 1);

select * from City;

drop table if exists Zipcode;
create table if not exists Zipcode (
	zipcode_id INT PRIMARY KEY AUTO_INCREMENT,
	zipcode VARCHAR(10)
);

insert into Zipcode values (1, '02112');

select * from Zipcode;

drop table if exists Address;
create table if not exists Address (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(100),
    city_id INT,
    state_id INT,
    zipcode_id INT,
	constraint Address_fk_City foreign key (city_id) references City (city_id),
    constraint Address_fk_State foreign key (state_id) references State (state_id),
	constraint Address_fk_Zipcode foreign key (Zipcode_id) references Zipcode (Zipcode_id)
);

insert into Address values (1, 'PO Box 120108', 1, 1, 1);
select * from Address;

drop table if exists Shelter;
create table if not exists Shelter (
	shelter_id INT PRIMARY KEY AUTO_INCREMENT,
    shelter_name VARCHAR(100),
    address_id INT,
--     street_address VARCHAR(100),
--     city VARCHAR(100),
--     state VARCHAR(2),
--     postal_code VARCHAR(100),
--     country VARCHAR(100),
    total_capacity INT,
    current_capacity INT,
-- 	description TEXT,
    phone_number VARCHAR(100),
--    alt_phone_numer VARCHAR(100)
    constraint Shelter_fk_Address foreign key (address_id) references Address (address_id)
);






insert into Shelter values (1, 'Casa Myrna Vazquez', 1, 15, 2, '617-338-2350');
-- insert into Shelter values (2, 'Renewal House', '10 Putnam Street', 'Roxbury', 'MA', '02119', 'USA', 20, 20, "Provides temporary and emergency shelter for battered women and their children, counseling, support groups, welfare, court, housing and child advocacy. MBTA accessible", '617-277-4194', '24-hour Emergency Hotline: 617-566-6881');
-- insert into Shelter values (3, 'The Center for Violence Prevention and Recovery', '330 Brookline Avenue', 'Boston', 'MA', '02113', 'USA', 35, 320, "Hospital based program offering services to all. Programs include: Safe Transition: Domestic Violence Intervention Program, Rape Crisis Intervention Program, Community Violence Intervention, Advocacy and Support Project", '617-667-8141', 'Beth Israel Deaconess Medical Center Emergency Department: 617-754-2400');




select *
from Shelter;

drop table if exists Stay;
create table if not exists Stay(
	stay_id INT PRIMARY KEY AUTO_INCREMENT,
    shelter_id INT,
    constraint Stay_fk_Shelter foreign key (shelter_id) references Shelter (shelter_id),
    date DATETIME,
    guest_fname VARCHAR(45),
    guest_lname VARCHAR(45)
);

insert into Stay values (1, 1, now(), 'Ryan', 'Leys');

drop table if exists Demographic;
create table if not exists Demographic (
	demographic_id INT PRIMARY KEY AUTO_INCREMENT,
	demographic VARCHAR(45)
);

insert into Demographic values (1, 'Asian');
insert into Demographic values (2, 'Families');
insert into Demographic values (3, 'Veterans');
insert into Demographic values (4, 'Women');
insert into Demographic values (5, 'Children');


drop table if exists Shelters_Demographics;
create table if not exists Shelters_Demographics (
	shelter_id INT,
    constraint Shelters_Demographics_fk_Shelter foreign key (shelter_id) references Shelter (shelter_id),
    demographic_id INT,
    constraint Shelters_Demographics_fk_Demographic foreign key (demographic_id) references Demographic (demographic_id)
);

insert into Shelters_Demographics values (1, 1);
insert into Shelters_Demographics values (1, 2);

drop table if exists Admin;
create table if not exists Admin (
	admin_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_fname VARCHAR(45),
    admin_lname VARCHAR(45),
    admin_uname VARCHAR(45) NOT NULL,
    admin_email VARCHAR(45),
    admin_password VARCHAR(45),
    admin_phone_number VARCHAR(45),
    shelter_id INT,
    constraint Admin_fk_Shelter foreign key (shelter_id) references Shelter (shelter_id)
);

insert into Admin values (1, 'Kevin', 'Gendron', 'kgendron', 'gendron.k@husky.neu.edu', 'password1', '617-999-9999', 1);

drop table if exists Shelter_Has_Admin; 
create table if not exists Shelter_Has_Admin(
	shelter_id INT,
    admin_id INT,
    constraint Shelter_Has_Admin_fk_Shelter foreign key (shelter_id) references Shelter (shelter_id),
    constraint Shelter_Has_Admin_fk_State foreign key (admin_id) references Admin (admin_id)

);


drop table if exists Reservation;
create table if not exists Reservation (
	reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    shelter_id INT,
    constraint Reservation_fk_Shelter foreign key (shelter_id) references Shelter (shelter_id),
    admin_id INT,
    constraint Reservation_fk_Admin foreign key (admin_id) references Admin (admin_id)
);


-- Necessary Queries:

-- Default web screen
DROP PROCEDURE IF EXISTS default_web;
DELIMITER // 
CREATE PROCEDURE default_web()
BEGIN
    select shelter_name, street_address, city, state, total_capacity, current_capacity, phone_number
    from Shelter;
    
END //
DELIMITER ;

-- Identify all shelters in a specific area
DROP PROCEDURE IF EXISTS find_shelters_by_city;
DELIMITER // 
CREATE PROCEDURE find_shelters_by_city(
	city_var VARCHAR(25)
)
BEGIN
    DECLARE city_id_var INT;
    SET city_id_var = (select city_id from City where city = city_var);
    
    select *
    from Shelter sh
    join Address a using (address_id)
    where a.city_id = city_id; 
END //
DELIMITER ;

call find_shelters_by_city('Cambridge');

select *

from Shelter;

-- Identify all shelters in an area with open spots

DROP PROCEDURE IF EXISTS find_open_spots_in_area;
DELIMITER // 
CREATE PROCEDURE find_open_spots_in_area(
	city_var VARCHAR(25)
)
BEGIN
	DECLARE city_id_var INT;
    SET city_id_var = (select city_id from City where city = city_var);
    
    
	select shelter_name,
		a.address,
		current_capacity
	from Shelter sh
    join Address a using (address_id)
	where a.city_id = city_id_var AND sh.current_capacity > 0;
END //
DELIMITER ;
call find_open_spots_in_area('Boston');


-- Find how many open spots a shelter has
DROP PROCEDURE IF EXISTS find_open_spots_in_shelter;
DELIMITER // 
CREATE PROCEDURE find_open_spots_in_shelter(
	shelter_name_var VARCHAR(25)
)
BEGIN
	declare shelter_id_var INT;
    set shelter_id_var = (select shelter_id
		from Shelter
        where shelter_name = shelter_name_var);
        
	select shelter_name,
		current_capacity
	from Shelter
	where shelter_id = shelter_id_var;
END //
DELIMITER ;
call find_open_spots_in_shelter('Renewal House');

-- Book stay
DROP PROCEDURE IF EXISTS book_a_stay;
DELIMITER // 
CREATE PROCEDURE book_a_stay(
	fName_var VARCHAR(25),
    lName_var VARCHAR(25),
    groupSize_var INT,
    shelter_name_var VARCHAR(100),
    shelter_address_var VARCHAR(25)

)
BEGIN
    DECLARE available_spots_var INT;
	DECLARE shelter_id_var INT;
    DECLARE stay_id_var INT;
    DECLARE address_id_var INT;
    DECLARE city_id_var INT;
        
	SET address_id_var = (select address_id 
		from address 
		where address.address = shelter_address_var);

    SET shelter_id_var = (select sh.shelter_id 
		from shelter sh
		inner join address a on (sh.address_id = a.address_id)
        where sh.shelter_name = shelter_name_var
			and a.address_id = address_id_var);

	SET available_spots_var = (select total_capacity from shelter where shelter_id = shelter_id_var) - 
		(select sum(group_size) from stay where shelter_id = shelter_id_var);
        
	SET stay_id_var = (select count(*)
		from stay) + 1;
    
    IF groupSize_var <= available_spots_var THEN
		INSERT INTO stay 
		VALUES (
			stay_id_var,
			shelter_id_var,
			fName_var,
			lName_var,
			groupSize_var
		);
	ELSE
		SELECT CONCAT('ALERT! Not enough space at this location!') as Alert;
	END IF;
END //
DELIMITER ;

	-- fName_var VARCHAR(25),
    -- lName_var VARCHAR(25),
    -- shelter_name_var VARCHAR(50),
	-- shelter_city_var VARCHAR(25),
    -- shelter_address_var VARCHAR(25),
    -- groupSize_var INT 
call book_a_stay("Grant", "Levy", "Shattuck Shelter", "Jamaica Plain", "170 Morton Street", 10);

CALL book_a_stay("First%20Name","Last%20Name",2,"DOVE, Inc - Domestic Violence Ended","PO Box 690267");
-- Find shelters in city that cater to input demographic
DROP PROCEDURE IF EXISTS search_city_and_demographic;
DELIMITER // 
CREATE PROCEDURE search_city_and_demographic(
	city_var VARCHAR(25),
    demographic_var VARCHAR(50)
)
BEGIN
	declare demographic_id_var INT;
    
    set demographic_id_var = (select demographic_id
						from Demographic
                        where demographic = demographic_var);

-- TO DO: Determine what this procedure returns.
	select sh.shelter_name, a.address
	from Shelter sh
		inner join Shelters_Demographics sd on (sh.shelter_id = sd.shelter_id)
		join Demographic demo on (sd.demographic_id = demo.demographic_id)
        join Address a using (address_id)
	where  demo.demographic_id = demographic_id_var;
END //
DELIMITER ;

select *
from Shelter;

select *
from Shelters_Demographics;

call search_city_and_demographic('Boston', 'Asian');

-- See how many shelters in a given city have open spots 
-- and cater to a target demographic
DROP PROCEDURE IF EXISTS find_shelters_by_city;
DELIMITER // 
CREATE PROCEDURE find_shelters_by_city(
	city VARCHAR(25)
)
BEGIN
    select *
    from shelter sh
    where sh.city = city; 
END //
DELIMITER ;

-- Update capacity, helper function to add stay.
DROP FUNCTION IF EXISTS update_capacity;
DELIMITER // 
CREATE FUNCTION update_capacity(
	num_of_guests_var INT,
    shelter_name_var VARCHAR(45)
)
RETURNS TINYINT
DETERMINISTIC
BEGIN
    declare current_capacity_var INT;
    declare shelter_id_var INT;
    declare new_current_capacity_var INT;
    
    
    set shelter_id_var = (select shelter_id
							from Shelter
							where shelter_name = shelter_name_var);
    
    set current_capacity_var = (select current_capacity
								from Shelter
								where shelter_id = shelter_id_var);
	
    
    set new_current_capacity_var = current_capacity_var - num_of_guests_var;
    if new_current_capacity_var < 0 then
		return false;
	else
		update Shelter 
			set current_capacity = new_current_capacity_var
			where shelter_id = shelter_id_var;
		return true;
	end if;

END //
DELIMITER ;

-- Procedure to add a stay
DROP PROCEDURE IF EXISTS addStay;

DELIMITER //

CREATE PROCEDURE addStay(
	guest_fname_var varchar(45),
    guest_lname_var varchar(45),
	shelter_name_var VARCHAR(100),
    num_guests_var INT
)

BEGIN
DECLARE success TINYINT;
DECLARE shelter_id_var INT;
SET shelter_id_var = (select shelter_id 
						from Shelter 
						where shelter_name = shelter_name_var);

set success = update_capacity(num_guests_var, shelter_name_var);
if success = true then
	insert into Stay (date, shelter_id, guest_fname, guest_lname) values (now(), shelter_id_var, guest_fname_var,guest_lname_var);
else
	SELECT CONCAT('ALERT! Not enough space!') as Alert;
end if;
END //

DELIMITER ;

call addStay('Ryan','Leys', 'Casa Myrna Vazquez', 1);
call addStay('Kevin', 'Gendron', 'Casa Myrna Vazquez', 100);
call addStay('Grant', 'Levy', 'Casa Myrna Vazquez', 2);

-- Get available contact information for each shelter
DROP PROCEDURE IF EXISTS find_shelter_phone_num;
DELIMITER // 
CREATE PROCEDURE find_shelter_phone_num(
	shelter_name_var VARCHAR(25)
)
BEGIN
	declare shelter_id_var INT;
    set shelter_id_var = (select shelter_id
		from Shelter
        where shelter_name = shelter_name_var);
        
	select shelter_name,
		phone_number
	from Shelter
	where shelter_id = shelter_id_var;
END //
DELIMITER ;
call find_shelter_phone_num('Casa Myrna Vazquez');


-- Get shelter by address
DROP PROCEDURE IF EXISTS find_shelter_by_address;
DELIMITER // 
CREATE PROCEDURE find_shelter_by_address(
	address_var VARCHAR(25)
)
BEGIN
    declare address_id_var INT;
	declare shelter_id_var INT;
	set address_id_var = (select address_id from Address where address = address_var);
    set shelter_id_var = (select shelter_id from Shelter where address_id = address_id_var);

    
	select shelter_name
	from Shelter
	where shelter_id = shelter_id_var;
END //
DELIMITER ;
call find_shelter_by_address('PO Box 120108');


-- Add event that resets current capacity of all shelters
-- every 24 hours
DROP EVENT IF EXISTS reset_current_capacity;
DELIMITER // 
create event reset_current_capacity
on schedule every 24 hour
do begin
	call reset_current_capacity();
END //
DELIMITER ;

-- Creat reset_crrent_capacity function
DROP FUNCTION IF EXISTS reset_current_capacity;
DELIMITER // 
CREATE FUNCTION reset_current_capacity()
RETURNS TINYINT
DETERMINISTIC
BEGIN 
	DECLARE total_capacity_var TINYINT;
	DECLARE current_capacity_var INT;
	DECLARE row_not_found TINYINT DEFAULT FALSE;
    DECLARE update_count INT DEFAULT 0;
    DECLARE row_count INT DEFAULT 0;
    
    DECLARE shelter_cursor CURSOR FOR
		SELECT total_capacity, current_capacity
        FROM Shelter;
	
    DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET row_not_found = TRUE;
        
	OPEN shelter_cursor;
    
    FETCH shelter_cursor INTO total_capacity_var, current_capacity_var;
    WHILE row_not_found = FALSE DO
                                
		IF total_capacity_var != current_capacity_var THEN
			update Shelter 
			set current_capacity = total_capacity_var;
		END IF;
        
        SET row_count = row_count + 1;
		FETCH shelter_cursor INTO total_capacity_var, current_capacity_var;
	END WHILE;
    
    CLOSE shelter_cursor;
    RETURN FALSE;

END //
DELIMITER ;


select * from shelter;
select * from stay;
select * from address;
select * from city;
select * from Demographic;
select * from Shelters_Demographics;
select * from Admin;
select * from Reservation;

