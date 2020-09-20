<?php
require 'shelter.php';
$shelter = new shelter;
$shelter->addLocation($_POST["lat"], $_POST["lng"], $_POST["row"]);

?>
