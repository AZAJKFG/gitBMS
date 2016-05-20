<?php
$username = "aidanbz2";
$password = "itiwgfamt";
$hostname = "sql5c25d.carrierzone.com"; 
$databasename = "bms_aidanbz2";

//connection to the database
$dbhandle = mysql_connect($hostname, $username, $password) 
  or die(mysql_error());
//echo "Connected to MySQL ".$hostname."<br>";

//select a database to work with
$selected = mysql_select_db($databasename,$dbhandle) 
  or die("Could not select examples");
  
//echo $databasename." database selected<br>";
?>