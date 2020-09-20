<?php
require 'shelter.php';
$shelter = new shelter;
$table_data = $shelter->filterCity($_POST["boston"],
                    $_POST["quincy"],
                    $_POST["cambridge"],
                    $_POST["mattapan"],
                    $_POST["roxbury"],
                    $_POST["somerville"],
                    $_POST["jamaica_plain"],
                    $_POST["brighton"],
                    $_POST["east_boston"],
                    $_POST["dorchester"],
                    $_POST["adult"],
                    $_POST["family"],
                    $_POST["women"],
                    $_POST["asian"],
                    $_POST["lgbtq"],
                    $_POST["men"],
                    $_POST["day"],
                    $_POST["children"],
                    $_POST["open"]);
$table_data_json = json_encode($table_data, true);

echo $table_data_json
// "<script>console.log('hello');</script>"
// echo "<script>updateTable('main_table', $newdata); </script>"

?>
