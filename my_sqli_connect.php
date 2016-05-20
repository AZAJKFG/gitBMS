<?php
$username = "aidanbz2";
$password = "itiwgfamt";
$hostname = "sql5c25d.carrierzone.com"; 
$databasename = "bms_aidanbz2";

//connection to the database
$mysqli = new mysqli($hostname, $username, $password, $databasename);
if ($mysqli->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}
//echo "Connected to MySQL ".$hostname."<br>";

?>