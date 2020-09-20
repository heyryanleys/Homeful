import random
import urllib2
from bs4 import BeautifulSoup
import csv
import string

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

i = 1
j = 1

shelterList = []

while i < 52:
    shelterList.append(i)
    i += 1

random.shuffle(shelterList)

def randomString(strLen = 10):
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for i in range(strLen))

with open('admin.csv', 'wb') as csvfile:
    fw = csv.writer(csvfile, delimiter = ',', quotechar='|', quoting=csv.QUOTE_MINIMAL)

    fw.writerow(['id', 'admin_fname', 'admin_lname', 'admin_uname',
                'admin_email', 'admin_password', 'admin_phone_number', 'sheler_id'])

    while j < 51:
        firstName = random.choice(fNames)
        lastName = random.choice(lNames)
        uName = firstName[:1] + lastName
        email = firstName[:1] + lastName + '@google.com'
        password = randomString()
        digits = str(random.randint(1000000, 9999999))
        phone = '555-' + digits[:3] + '-' + digits[3:]
        shelter_id = shelterList[j]

        fw.writerow([j, firstName,lastName, uName, email, password, phone, shelter_id])
        j += 1

