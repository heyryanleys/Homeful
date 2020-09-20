<?php
require 'shelter.php';
$shelter = new shelter;
$shelter->bookStay($_POST["fname"], $_POST["lname"], $_POST["capacity"], $_POST["shelter_name"], $_POST["shelter_address"]);

?>
