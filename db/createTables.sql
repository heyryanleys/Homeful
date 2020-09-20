-- 5200 Semester Project
-- Homeless shelter Database
DROP DATABASE IF EXISTS homeful;
CREATE DATABASE IF NOT EXISTS homeful;
use homeful;

DROP TABLE IF EXISTS state;

CREATE TABLE IF NOT EXISTS state (
	state_id INT PRIMARY KEY AUTO_INCREMENT,
    state VARCHAR(2)
);

DROP TABLE IF EXISTS city;
CREATE TABLE IF NOT EXISTS city (
	city_id INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(100),
	state_id INT,
    CONSTRAINT city_fk_state FOREIGN KEY (state_id) REFERENCES state (state_id)
);

DROP TABLE IF EXISTS zipCode;
CREATE TABLE IF NOT EXISTS zipCode (
 zipCode_id INT PRIMARY KEY AUTO_INCREMENT,
 zipCode VARCHAR(10)
);

DROP TABLE IF EXISTS address;
CREATE TABLE IF NOT EXISTS address (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(100),
    city_id INT,
    zipCode_id INT,
    latitude double,
    longitude double,
	CONSTRAINT address_fk_city FOREIGN KEY (city_id) REFERENCES city (city_id),
	CONSTRAINT address_fk_zipCode FOREIGN KEY (zipCode_id) REFERENCES zipCode (zipCode_id)
);

DROP TABLE IF EXISTS shelter;
CREATE TABLE IF NOT EXISTS shelter (
	shelter_id INT PRIMARY KEY AUTO_INCREMENT,
    shelter_name VARCHAR(100),
    address_id INT,
    total_capacity INT,
    current_capacity INT,
    phone_number VARCHAR(100),
    CONSTRAINT shelter_fk_address FOREIGN KEY (address_id) REFERENCES address (address_id)
);

DROP TABLE IF EXISTS stay;
CREATE TABLE IF NOT EXISTS stay (
	stay_id INT PRIMARY KEY AUTO_INCREMENT,
    shelter_id INT,
    CONSTRAINT stay_fk_shelter FOREIGN KEY (shelter_id) REFERENCES shelter (shelter_id),
    fname VARCHAR(45),
    lname VARCHAR(45),
    group_size INT NOT NULL CHECK (guest_count between 0 and 10)
);

DROP TABLE IF EXISTS demographic;
CREATE TABLE IF NOT EXISTS demographic (
	demographic_id INT PRIMARY KEY AUTO_INCREMENT,
	demographic VARCHAR(45)
);

DROP TABLE IF EXISTS shelter_has_demographic;
CREATE TABLE IF NOT EXISTS shelter_has_demographic (
	shelter_id INT,
    CONSTRAINT shelter_has_demographic_fk_shelter FOREIGN KEY (shelter_id) REFERENCES shelter (shelter_id),
    demographic_id INT,
    CONSTRAINT shelter_has_demographic_fk_demographic FOREIGN KEY (demographic_id) REFERENCES demographic (demographic_id)
);

DROP TABLE IF EXISTS admin;
CREATE TABLE IF NOT EXISTS admin (
	admin_id INT PRIMARY KEY AUTO_INCREMENT,
    admin_fname VARCHAR(45),
    admin_lname VARCHAR(45),
    admin_uname VARCHAR(45) NOT NULL,
    admin_email VARCHAR(45),
    admin_password VARCHAR(45),
    admin_phone_number VARCHAR(45)
);

DROP TABLE IF EXISTS shelter_has_admin; 
CREATE TABLE IF NOT EXISTS shelter_has_admin(
	shelter_id INT,
    admin_id INT,
    CONSTRAINT shelter_has_admin_fk_shelter FOREIGN KEY (shelter_id) REFERENCES shelter (shelter_id),
    CONSTRAINT shelter_has_admin_fk_state FOREIGN KEY (admin_id) REFERENCES admin (admin_id)

);

