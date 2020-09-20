import mysql.connector
from mysql.connector import Error


# Database connection to fetch shelter/capacity information
try:
    connection = mysql.connector.connect(host='homefulmysql.c16ipd50siax.us-east-2.rds.amazonaws.com', database='homeful',user='homeful', password='newmasterpassword', allow_local_infile=True)
    cursor = connection.cursor()

    # Get total number of shelters!
    cursor.execute('TRUNCATE TABLE stay;')

    cursor.execute(
        """
        LOAD DATA LOCAL INFILE '/Users/grantlevy/Documents/NortheasternALIGN/CS5200/Project/grant/cs5200-group/data/stay.csv'
        INTO TABLE stay
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
        LINES TERMINATED BY '\r\n'
        IGNORE 1 LINES
        (stay_id, shelter_id, fname, lname, group_size);
        """)
    connection.commit()

except Error as e:
    print("Error")

finally:
    if (connection.is_connected()):
        cursor.close()
        connection.close()