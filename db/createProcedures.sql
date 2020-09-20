-- Necessary Queries:

-- Default web screen
DROP PROCEDURE IF EXISTS default_web;
DELIMITER // 
CREATE PROCEDURE default_web()
BEGIN
    SELECT shelter_name, a.address, c.city, s.state, total_capacity,
           (total_capacity - SUM(group_size)) as available_rooms, a.latitude, a.longitude
	FROM shelter sh
	JOIN stay st on sh.shelter_id = st.shelter_id
	JOIN address a USING (address_id)
	JOIN city c ON (a.city_id = c.city_id)
    JOIN state s ON (c.state_id = s.state_id)
	GROUP BY sh.shelter_id;

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
    SET city_id_var = (SELECT city_id FROM city WHERE city = city_var);

    SELECT shelter_name, address, (sh.total_capacity - SUM(group_size)) as available_rooms
	FROM shelter sh
	JOIN stay st on sh.shelter_id = st.shelter_id
	JOIN address a USING (address_id)
	WHERE a.city_id = city_id_var
	GROUP BY sh.shelter_id
	HAVING available_rooms > 0;

END //
DELIMITER ;

-- Identify all shelters in an area with open spots
DROP PROCEDURE IF EXISTS find_open_spots_in_area;
DELIMITER //
CREATE PROCEDURE find_open_spots_in_area(
	city_var VARCHAR(25)
)
BEGIN
	DECLARE city_id_var INT;
    SET city_id_var = (SELECT city_id FROM city WHERE city = city_var);

    SELECT shelter_name, address, (sh.total_capacity - SUM(group_size)) as open_rooms
	FROM shelter sh
	JOIN stay st on sh.shelter_id = st.shelter_id
	JOIN address a USING (address_id)
	WHERE a.city_id = city_id_var
	GROUP BY sh.shelter_id
	HAVING open_rooms > 0;
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
	DECLARE shelter_id_var INT;
    SET shelter_id_var = (SELECT shelter_id
		FROM shelter
        WHERE shelter_name = shelter_name_var);

	SELECT shelter_name, (sh.total_capacity - SUM(group_size)) as available_rooms
	FROM shelter sh
	JOIN stay st on sh.shelter_id = st.shelter_id
	WHERE sh.shelter_id = shelter_id_var;
END //
DELIMITER ;

-- CURRENTLY FIXED ALL ABOVE THIS, STILL WORKING ON BELOW


-- Find shelters in city that cater to input demographic
DROP PROCEDURE IF EXISTS search_city_and_demographic;
DELIMITER //
CREATE PROCEDURE search_city_and_demographic(
	city_var VARCHAR(25),
    demographic_var VARCHAR(50)
)
BEGIN
	DECLARE demographic_id_var INT;

    SET demographic_id_var = (SELECT demographic_id
						FROM Demographic
                        WHERE demographic = demographic_var);

-- TO DO: Determine what this procedure returns.
	SELECT sh.shelter_name, a.address
	FROM shelter sh
		inner JOIN shelter_has_demographic sd on (sh.shelter_id = sd.shelter_id)
		JOIN Demographic demo on (sd.demographic_id = demo.demographic_id)
        JOIN address a USING (address_id)
	WHERE  demo.demographic_id = demographic_id_var;
END //
DELIMITER ;

SELECT *
FROM shelter;

SELECT *
FROM shelter_has_demographic;

call search_city_and_demographic('Boston', 'Asian');

-- See how many shelters in a given city have open spots
-- and cater to a target demographic
DROP PROCEDURE IF EXISTS find_shelters_by_city;
DELIMITER //
CREATE PROCEDURE find_shelters_by_city(
	city VARCHAR(25)
)
BEGIN
    SELECT *
    FROM shelter sh
    WHERE sh.city = city;
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
    DECLARE current_capacity_var INT;
    DECLARE shelter_id_var INT;
    DECLARE new_current_capacity_var INT;


    SET shelter_id_var = (SELECT shelter_id
							FROM shelter
							WHERE shelter_name = shelter_name_var);

    SET current_capacity_var = (SELECT current_capacity
								FROM shelter
								WHERE shelter_id = shelter_id_var);


    SET new_current_capacity_var = current_capacity_var - num_of_guests_var;
    if new_current_capacity_var < 0 then
		return false;
	else
		update shelter
			SET current_capacity = new_current_capacity_var
			WHERE shelter_id = shelter_id_var;
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
SET shelter_id_var = (SELECT shelter_id
						FROM shelter
						WHERE shelter_name = shelter_name_var);

SET success = update_capacity(num_guests_var, shelter_name_var);
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
	DECLARE shelter_id_var INT;
    SET shelter_id_var = (SELECT shelter_id
		FROM shelter
        WHERE shelter_name = shelter_name_var);

	SELECT shelter_name,
		phone_number
	FROM shelter
	WHERE shelter_id = shelter_id_var;
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
    DECLARE address_id_var INT;
	DECLARE shelter_id_var INT;
	SET address_id_var = (SELECT address_id FROM address WHERE address = address_var);
    SET shelter_id_var = (SELECT shelter_id FROM shelter WHERE address_id = address_id_var);


	SELECT shelter_name
	FROM shelter
	WHERE shelter_id = shelter_id_var;
END //
DELIMITER ;
call find_shelter_by_address('PO Box 120108');


-- Add event that reSETs current capacity of all shelters
-- every 24 hours
DROP EVENT IF EXISTS reSET_current_capacity;
DELIMITER //
create event reSET_current_capacity
on schedule every 24 hour
do begin
	call reSET_current_capacity();
END //
DELIMITER ;

-- Creat reSET_crrent_capacity function
DROP FUNCTION IF EXISTS reSET_current_capacity;
DELIMITER //
CREATE FUNCTION reSET_current_capacity()
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
        FROM shelter;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET row_not_found = TRUE;

	OPEN shelter_cursor;

    FETCH shelter_cursor INTO total_capacity_var, current_capacity_var;
    WHILE row_not_found = FALSE DO

		IF total_capacity_var != current_capacity_var THEN
			update shelter
			SET current_capacity = total_capacity_var;
		END IF;

        SET row_count = row_count + 1;
		FETCH shelter_cursor INTO total_capacity_var, current_capacity_var;
	END WHILE;

    CLOSE shelter_cursor;
    RETURN FALSE;

END //
DELIMITER ;

DROP PROCEDURE IF EXISTS update_lat_long;
DELIMITER //
CREATE PROCEDURE update_lat_long(
    lat DOUBLE,
    lng DOUBLE,
    addy VARCHAR(100)
)
BEGIN
    UPDATE address
    SET latitude = lat,
    longitude = lng
    WHERE address.address = addy;

END //
DELIMITER ;


CREATE PROCEDURE filter(
    IN Boston tinyint(1),
    IN Quincy tinyint(1),
    IN Cambridge tinyint(1),
    IN Mattapan tinyint(1),
    IN Roxbury tinyint(1),
    IN Somerville tinyint(1),
    IN Jamaica_Plain tinyint(1),
    IN Brighton tinyint(1),
    IN East_Boston tinyint(1),
    IN Dorchester tinyint(1),
    IN Adult tinyint(1),
    IN Family tinyint(1),
    IN Women tinyint(1),
    IN Asian tinyint(1),
    IN LGBT tinyint(1),
    IN Men tinyint(1),
    IN Day tinyint(1),
    IN Children tinyint(1),
    IN Open tinyint(1)
)
BEGIN
    DECLARE BOS VARCHAR(30);
    DECLARE QUI VARCHAR(30);
    DECLARE CAM VARCHAR(30);
    DECLARE MAT VARCHAR(30);
    DECLARE ROX VARCHAR(30);
    DECLARE SOM VARCHAR(30);
    DECLARE JAM VARCHAR(30);
    DECLARE BRI VARCHAR(30);
    DECLARE EAS VARCHAR(30);
    DECLARE DOR VARCHAR(30);
    DECLARE ADU VARCHAR(30);
    DECLARE FAM VARCHAR(30);
    DECLARE WOM VARCHAR(30);
    DECLARE ASI VARCHAR(30);
    DECLARE LGB VARCHAR(30);
    DECLARE MEE VARCHAR(30);
    DECLARE DAA VARCHAR(30);
    DECLARE CHI VARCHAR(30);
    DECLARE OPE int;

    IF Boston THEN SET BOS := 'Boston'; END IF;
    IF Quincy THEN SET QUI := 'Quincy'; END IF;
    IF Cambridge THEN SET CAM := 'Cambridge'; END IF;
    IF Mattapan THEN SET MAT := 'Mattapan'; END IF;
    IF Roxbury THEN SET ROX := 'Roxbury'; END IF;
    IF Somerville THEN SET SOM := 'Somerville'; END IF;
    IF Jamaica_Plain THEN SET JAM := 'Jamaica Plain'; END IF;
    IF Brighton THEN SET BRI := 'Brighton'; END IF;
    IF East_Boston THEN SET EAS := 'East Boston'; END IF;
    IF Dorchester THEN SET DOR := 'Dorchester'; END IF;
    IF Adult THEN SET ADU := 'Adult'; END IF;
    IF Family THEN SET FAM := 'Family'; END IF;
    IF Women THEN SET WOM := 'Women'; END IF;
    IF Asian THEN SET ASI := 'Asian'; END IF;
    IF LGBT THEN SET LGB := 'LGBTQ+'; END IF;
    IF Men THEN SET MEE := 'Men'; END IF;
    IF Day THEN SET DAA := 'Day'; END IF;
    IF Children THEN SET CHI := 'Children'; END IF;
    IF Open THEN SET OPE := 0; END IF;
    IF NOT Open THEN SET OPE := -1; END IF;

select sh.shelter_name, a.address, c.city, s.state, sh.total_capacity,
           (sh.total_capacity - size) as available_rooms, a.latitude, a.longitude
from shelter sh
JOIN address a USING (address_id)
JOIN city c ON (a.city_id = c.city_id)
JOIN state s ON (c.state_id = s.state_id)
JOIN (
	SELECT DISTINCT shelter_id, demographic_id
    FROM shelter_has_demographic) shd ON (shd.shelter_id = sh.shelter_id)
JOIN demographic d ON (shd.demographic_id = d.demographic_id)
join (
	SELECT shelter_id, SUM(group_size) as size
    FROM stay
    GROUP BY shelter_id
) st on (st.shelter_id = sh.shelter_id)

    WHERE (city = BOS OR
          city = QUI OR
          city = CAM OR
          city = MAT OR
          city = ROX OR
          city = SOM OR
          city = JAM OR
          city = BRI OR
          city = EAS OR
          city = DOR) AND
          (demographic = ADU OR
          demographic = FAM OR
          demographic = WOM OR
          demographic = ASI OR
          demographic = LGB OR
          demographic = MEE OR
          demographic = DAA OR
          demographic = CHI)
	GROUP BY sh.shelter_id
    HAVING available_rooms != OPE;

END;

-- call filter_city4(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE);

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