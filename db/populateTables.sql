
-- 5200 Semester Project
-- Homeless shelter Database
LOAD DATA LOCAL INFILE '/Users/grantlevy/Documents/NortheasternALIGN/CS5200/Project/grant/cs5200-group/data/state.csv'
        INTO TABLE state
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
        LINES TERMINATED BY '\r\n'
        IGNORE 1 LINES
        (state_id, state);

LOAD DATA LOCAL INFILE '/Users/grantlevy/Documents/NortheasternALIGN/CS5200/Project/grant/cs5200-group/data/city.csv'
        INTO TABLE city
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
        LINES TERMINATED BY '\r\n'
        IGNORE 1 LINES
        (city_id, city, state_id);


LOAD DATA LOCAL INFILE '/Users/grantlevy/Documents/NortheasternALIGN/CS5200/Project/grant/cs5200-group/data/zipCode.csv'
        INTO TABLE zipCode
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
        LINES TERMINATED BY '\r\n'
        IGNORE 1 LINES
        (zipCode_id, zipCode);

LOAD DATA LOCAL INFILE '/Users/grantlevy/Documents/NortheasternALIGN/CS5200/Project/grant/cs5200-group/data/address.csv'
        INTO TABLE address
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
        LINES TERMINATED BY '\r\n'
        IGNORE 1 LINES
        (address_id, address, city_id, zipCode_id);

LOAD DATA LOCAL INFILE '/Users/grantlevy/Documents/NortheasternALIGN/CS5200/Project/grant/cs5200-group/data/shelter.csv'
        INTO TABLE shelter
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
        LINES TERMINATED BY '\r\n'
        IGNORE 1 LINES
        (shelter_id, shelter_name, address_id, total_capacity, phone_number);

LOAD DATA LOCAL INFILE '/Users/grantlevy/Documents/NortheasternALIGN/CS5200/Project/grant/cs5200-group/data/demographic.csv'
        INTO TABLE demographic
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
        LINES TERMINATED BY '\r\n'
        IGNORE 1 LINES
        (demographic_id, demographic);

LOAD DATA LOCAL INFILE '/Users/grantlevy/Documents/NortheasternALIGN/CS5200/Project/grant/cs5200-group/data/shelter_has_demographic.csv'
        INTO TABLE shelter_has_demographic
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
        LINES TERMINATED BY '\r\n'
        IGNORE 1 LINES
        (shelter_id, demographic_id);

LOAD DATA LOCAL INFILE '/Users/grantlevy/Documents/NortheasternALIGN/CS5200/Project/grant/cs5200-group/data/admin.csv'
        INTO TABLE admin
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
        LINES TERMINATED BY '\r\n'
        IGNORE 1 LINES
        (admin_id, admin_fname, admin_lname, admin_uname, admin_email, admin_password, admin_phone_number);

LOAD DATA LOCAL INFILE '/Users/grantlevy/Documents/NortheasternALIGN/CS5200/Project/grant/cs5200-group/data/shelter_has_admin.csv'
        INTO TABLE shelter_has_admin
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
        LINES TERMINATED BY '\r\n'
        IGNORE 1 LINES
        (shelter_id, admin_id);

LOAD DATA LOCAL INFILE '/Users/grantlevy/Documents/NortheasternALIGN/CS5200/Project/grant/cs5200-group/data/stay.csv'
        INTO TABLE stay
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
        LINES TERMINATED BY '\r\n'
        IGNORE 1 LINES
        (stay_id, shelter_id, fname, lname, group_size);