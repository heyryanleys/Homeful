import random
import urllib2
from bs4 import BeautifulSoup
import csv
import string
import mysql.connector
from mysql.connector import Error

# Database connection to fetch shelter/capacity information
try:
    connection = mysql.connector.connect(host='homefulmysql.c16ipd50siax.us-east-2.rds.amazonaws.com', database='homeful',user='homeful', password='newmasterpassword')
    cursor = connection.cursor()

    # Get total number of shelters!
    cursor.execute("SELECT COUNT(*) FROM shelter")
    result = cursor.fetchone()
    for row in result:
        totalShelters = int(row)

    cursor.execute("SELECT total_capacity FROM shelter")

    # Get total capacity for each shelter
    shelterCapacity = []
    result = cursor.fetchall()
    for row in result:
        shelterCapacity.append(int(row[0]))

    # Get total capacity of all shelters
    cursor.execute("SELECT SUM(total_capacity) FROM shelter;")
    result = cursor.fetchone()
    for row in result:
        totalCapacity = int(row)

except Error as e:
    print("Error")

finally:
    if (connection.is_connected()):
        cursor.close()
        connection.close()

# Links used to webscrape popular names
fLink = 'http://www.babynamewizard.com/the-top-1000-baby-names-of-2016-united-states-of-america'
lLink = 'https://www.infoplease.com/us/miscellaneous/most-common-last-names'

# Open links
fPage = urllib2.urlopen(fLink)
lPage = urllib2.urlopen(lLink)

# Convert to html
fSoup = BeautifulSoup(fPage, 'html.parser')
lSoup = BeautifulSoup(lPage, 'html.parser')

# Find tags based on html response
fName_Box = fSoup.find_all('td')
lName_Box = lSoup.find_all('td', align="left" )

# Initialize empty lists
fNames = []
lNames = []

# Store tags into lists
for fn in fName_Box:
    if (fn.text.strip()).isdigit() or ("(" in str(fn.text.strip())):
        continue
    else:
        fNames.append(fn.text.strip())

for ln in lName_Box:
    lNames.append(ln.text.strip())

# Random selection of first/last name
firstName = random.choice(fNames)
lastName = random.choice(lNames)

totalPeople = 0
i = 1

with open('stay.csv', 'wb') as csvfile:
    fw = csv.writer(csvfile, delimiter = ',', quotechar='|', quoting=csv.QUOTE_MINIMAL)

    fw.writerow(['stay_id', 'shelter_id', 'fname', 'lname', 'group_size'])

    # Stay numbers is a random value between 1000 and 1295 people
    shelterLimit = random.randint(1000, totalCapacity - 5)

    while totalPeople <= shelterLimit:
        firstName = random.choice(fNames)
        lastName = random.choice(lNames)
        shelter = random.randint(1, totalShelters)
        groupSize = random.randint(1,5)

        while (shelterCapacity[shelter - 1] - groupSize) < 0:
            shelter = random.randint(1,totalShelters)

        fw.writerow([i, shelter, firstName, lastName, groupSize])

        shelterCapacity[shelter - 1] -= groupSize

        i += 1
        totalPeople += groupSize

# Database connection to write new stay data from csv
try:
    connection = mysql.connector.connect(host='homefulmysql.c16ipd50siax.us-east-2.rds.amazonaws.com', database='homeful',user='homeful', password='newmasterpassword', allow_local_infile=True)
    cursor = connection.cursor()

    # Truncate current table (if any)
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