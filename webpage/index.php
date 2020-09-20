<?php
// To run this, navigate to your project folder in terminal and run the command php -S 127.0.0.1:8080
// and then go to localhost:8080 in your browser
  require 'shelter.php';
  $shelter = new shelter;
  $table_data = $shelter->runDefault();
  $table_data_json = json_encode($table_data, true);

  ?>

    <head>
        <meta charset="utf-8" />
        <title>Hopeful</title>
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
              <video autoplay muted loop id="myVideo">
                <source src="images/bgvideo.mp4" type="video/mp4">
              </video>
              <div class="main content-wrapper">
                <div class="headline">
                  <div class="php">
                  <?php
                    echo '<div id ="data">' . $table_data_json . '</div>';
                   ?>
                 </div>
                  <!-- <h1 id="headline"> Browse shelters in Boston: </h1> -->
                  <h1 id="headline"><?php echo "<script> openSpot('headline', $table_data_json); </script>" ?></h1>
                </div>
                <div class="items-wrapper">
                  <div class="item-wrapper">
                    <div id="map"></div>
                  </div>
                <div class="item-wrapper table-wrapper">
                <div class="header-table">
                  <table class='labels'>
                    <tr><td class="col1"><strong>Shelter</strong></td>
                      <td class="col2"><strong>Address</strong></td>
                      <td class="col3"><strong>City</strong></td>
                      <td class="col4"><strong>State</strong></td>
                      <td class="col5"><strong>Capacity</strong></td>
                      <td class="col6"><strong>Available Space</strong></td></tr>
                  </table>
                <div class="main-table">
                  <table id="main_table">
                <?php echo "<script> updateTable('main_table', $table_data_json); </script>" ?>
              </table>
            </div>
          </div>
        </div>
      </div>
      <div class="filterbox">
      <form method="POST" id="filter">
      <div class="filters">
          <span class="filter-header">Filter city:</span>
          <input type="checkbox" name="boston" id="boston" value="True">Boston</input>
          <input type="checkbox" name="quincy" id="quincy" value="True">Quincy</input>
          <input type="checkbox" name="cambridge" id ="cambridge" value="True">Cambridge</input>
          <input type="checkbox" name="mattapan" id ="mattapan" value="True">Mattapan</input>
          <input type="checkbox" name="roxbury" id="roxbury" value="True">Roxbury</input>
          <input type="checkbox" name="somerville" id="somerville" value="True">Somerville</input>
          <input type="checkbox" name="jamaica_plain" id="jamaica_plain" value="True">Jamaica Plain</input>
          <input type="checkbox" name="brighton" id="brighton" value="True">Brighton</input>
          <input type="checkbox" name="east_boston" id="east_boston" value="True">East Boston</input>
          <input type="checkbox" name="dorchester" id="dorchester" value="True">Dorchester</input>
        </div>
        <div class="filters">
          <span class="filter-header">Filter type of shelter:</span>
          <input type="checkbox" name="adult" id="adult" value="True">Adult</input>
          <input type="checkbox" name="family" id="family" value="True">Family</input>
          <input type="checkbox" name="women" id ="women" value="True">Women</input>
          <input type="checkbox" name="asian" id ="asian" value="True">Asian</input>
          <input type="checkbox" name="lgbtq" id="lgbtq" value="True">LGBTQ+</input>
          <input type="checkbox" name="men" id="men" value="True">Men</input>
          <input type="checkbox" name="day" id="day" value="True">Day</input>
          <input type="checkbox" name="children" id="children" value="True">Children</input>
        </div>
        <div class="filters">
          <span class="filter-header">Filter availability:</span>
          <input type="checkbox" name="open" id="open" value="True">Only open shelters</input>
        </div>
        <div class="filters filter-submit">
          <input type="submit" name='filter_button' value ="Update Shelters">
        </div>
          </form>
      </div>
      <iframe name="votar" style="display:none;"></iframe>
          </div>

          <div id="book_room">
            <button class="xout" onClick="xout()">x</button>
            <p id="book_text">test</p>
            <form method="POST" id="stay">
            <table>
              <tr>
                <td>First name</td>
                <td>Last name</td>
                <td># of guests</td>

            </tr>
            <tr>
              <td><input type="text" name="fname" id="fname" label="First name" placeholder="First Name"></input></td>
              <td><input type="text" name="lname" id="lname" placeholder="Last Name"></input></td>
              <td><input type="number" min="1" name="capacity" id="capacity" value="1"></input></td>
              <td><input type="submit" name='stay_button' value ="submit"></td>
            </tr>
          </table>

            </form>
          </div>
                <div class="hero-overlay">
                <div class="nav-wrapper">
                    <div class="left-column">
                        <div class="nav-link-wrap active-nav-link">
                            <a href="index.php">Home</a>
                        </div>
                    </div>

                    <div class="right-column">
                        <div class="brand">
                            <div>Homeful</div>
                        </div>
                    </div>
                </div>
                </div>
              </div>
            </div>
        </div>
    </body>
