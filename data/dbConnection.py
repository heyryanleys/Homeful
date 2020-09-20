import mysql.connector

# Database connection to fetch shelter/capacity information
try:
    connection = mysql.connector.connect(host='homefulmysql.c16ipd50siax.us-east-2.rds.amazonaws.com', database='homeful',user='homeful', password='newmasterpassword')
    cursor = connection.cursor()

    # Get total number of shelters!
    cursor.execute("SELECT COUNT(*) FROM shelter;")
    result = cursor.fetchone()
    for row in result:
        totalShelters = int(row)

    print("total: ", totalShelters)

    # Get total capacity for each shelter
    cursor.execute("SELECT total_capacity FROM shelter;")
    shelterCapacity = []
    result = cursor.fetchall()
    for row in result:
        shelterCapacity.append(int(row[0]))

    print("length: ", len(shelterCapacity))

    print shelterCapacity[0]
    print shelterCapacity[45]

    # Get total capacity of all shelters
    cursor.execute("SELECT SUM(total_capacity) FROM shelter;")
    result = cursor.fetchone()
    for row in result:
        totalCapacity = int(row)

    print totalCapacity

except Error as e:
    print("Error")

finally:
    if (connection.is_connected()):
        cursor.close()
        connection.close()
        print("connection closed")

# 