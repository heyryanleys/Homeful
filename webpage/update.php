<?php
$sql = "CALL test('ryan','leys','drug',100.00)";
if(mysqli_query($mysqli, $sql)){
  $result = mysqli_query($mysqli, $sql);
  header("location:index.php?inserted=1");
?>
