<?php
// To run this, navigate to your project folder in terminal and run the command php -S 127.0.0.1:8080
// and then go to localhost:8080 in your browser
  require 'shelter.php';
  $shelter = new shelter;
  $table_data = $shelter->runDefault();
  $table_data_json = json_encode($table_data, true);
  $shelter_name = $_GET['shelter_name'];
  ?>

    <head>
        <meta charset="utf-8" />
        <title>ProjectName</title>
        <link href="https://fonts.googleapis.com/css?family=Lato&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="styles.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="script.js"></script>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAJlEKPrN7IYA2vRjHpn1dUQYhOUIfswJI&callback=initMap"
    async defer></script>


    </head>
    <body>
        <div class="container">
            <div class="hero">
              <div class="main content-wrapper">
                <div class="headline">
                  <h1> Book a stay: </h1>
                </div>
                <div class="items-wrapper">


        </div>

          <!-- <iframe name="votar" style="display:none;"></iframe> -->
          <form method="POST" id="stay">
            <input type="text" name="capacity" id="fname" value="First Name"></input>
            <input type="text" name="capacity" id="lname" value="Last Name"></input>
            <input type="text" name="shelter" id="shelter" value="<?php echo $forename; ?>"></input>
            <input type="text" name="capacity" id="capacity" value="Amount of people"></input>
            <input type="submit" name='stay_button' value ="submit">
          </form>
          </div>
                <div class="hero-overlay">
                <div class="nav-wrapper">
                    <div class="left-column">
                        <div class="nav-link-wrap">
                            <a href="index.php">Home</a>
                        </div>

                        <div class="nav-link-wrap active-nav-link">
                            <a href="stay.php">Book a spot</a>
                        </div>
                      </div>

                    <div class="right-column">
                        <div class="brand">
                            <div>Project Name</div>
                        </div>
                    </div>
                </div>
                </div>
              </div>
            </div>
        </div>
    </body>
