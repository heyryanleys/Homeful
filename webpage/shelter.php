<?php

class shelter {
  private $shelter_name;
  private $address;
  private $city;
  private $state;
  private $total_capacity;
  private $current_capacity;
  private $phone_number;
  private $conn;
  private $tableName = 'shelter';

  function setShelterName($shelter_name){$this->shelter_name = $shelter_name;}
  function setStreetAddress($address){$this->address = $address;}
  function setCity($city){$this->city = $city;}
  function setState($state){$this->state = $state;}
  function setTotalCapacity($total_capacity){$this->total_capacity = $total_capacity;}
  function setCurrent($current_capacity){$this->current_capacity = $current_capacity;}
  function setPhoneNumber($phone_number){$this->phone_number = $phone_number;}

  function getShelterName(){return $this->shelter_name;}
  function getStreetAddress(){return $this->street_address;}
  function getCity(){return $this->city;}
  function getState(){return $this->state;}
  function getTotalCapacity(){return $this->total_capacity;}
  function getCurrent(){return $this->current_capacity;}
  function getPhoneNumber(){return $this->phone_number;}

  public function __construct(){
    require_once('db/DbConnect.php');
    $conn = new DbConnect;
    $this->conn = $conn->connect();
  }

  public function filterCity($boston, $quincy ,$cambridge ,$mattapan, $roxbury,
  $somerville, $jamaica_plain, $brighton, $east_boston, $dorchester, $adult ,$family, $women,
  $asian, $lgbtq, $men, $day, $children, $open){
    $sql = "call filter($boston, $quincy ,$cambridge ,$mattapan, $roxbury,
    $somerville, $jamaica_plain, $brighton, $east_boston, $dorchester, $adult ,$family, $women,
    $asian, $lgbtq, $men, $day, $children, $open)";
    $stmt = $this->conn->prepare($sql);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
  }

  public function runDefault(){
    $sql = "call default_Web()";
    $stmt = $this->conn->prepare($sql);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
  }

  public function addLocation($latitude, $longitude, $addy){
    $stmt = $this->conn->prepare('CALL update_lat_long(' . $latitude . ',' . $longitude . ',"' . $addy . '")');
    $stmt->execute();
  }

  public function bookStay($fname, $lname, $capacity, $shelter_name, $shelter_address){
    $stmt = $this->conn->prepare('CALL book_a_stay("' . $fname . '","' . $lname . '",' . $capacity . ',"' . $shelter_name . '","' . $shelter_address . '")');
    // echo 'CALL book_a_stay("' . $fname . '","' . $lname . '",' . $capacity . ',"' . $shelter_name . '","' . $shelter_address . '")';
    $stmt->execute();
  }


}

 ?>
