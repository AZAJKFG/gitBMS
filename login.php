<?php
require_once ('my_sqli_connect.php');

//set guid from querystring if there
$guid = $_GET['guid'];
if($guid != ''){
    setcookie("guid", $guid, time()+86400 * 7);
}
//look for guid in cookie if not in querystring
if(!$guid){
    $guid = $_COOKIE["guid"];
    if (isset($_COOKIE["guid"])) {
        $guid = $_COOKIE["guid"];
    }
}
//if has one
if($guid){
    $query = "SELECT * FROM user WHERE guid='" . $guid . "'";
    $res = $mysqli->query($query);
    $row = $res->fetch_assoc();
    if($res->num_rows == 0){
        if($_GET['guid'] != ""){
            echo "The link you have followed is unrecognised. Please contact the administrator for a new one.";
            exit();
        }
    } else {
        $userName = $row['username'];
        $userID = $row['user_id'];
        $guid = $row['guid'];
    }
} else {
    echo "You are not logged in.";
    exit();
}

//remember command ID as cookie
$commandID = $_GET['command_id'];
if($commandID != ''){
    setcookie("command_id", $commandID, time()+86400 * 7);
}
if(!$commandID){
    $commandID = $_COOKIE["command_id"];
    if (isset($_COOKIE["command_id"])) {
        $commandID = $_COOKIE["command_id"];
    }
}
 //need to check command id belongs to user
?>