<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<script language="javascript">
	function enterGame(factionID){
		document.location.href="game.php?faction_id=" + factionID;
	}
</script>
</head>
<body>
<?php 
require_once ('my_sqli_connect.php');

//echo "GUID:" . $_GET['guid'] . "<br>";

$query = "SELECT * FROM user WHERE guid='" . $_GET['guid'] . "'";

//echo "Query:" . $query . "<br>";

$res = $mysqli->query($query);
$row = $res->fetch_assoc();
if($res->num_rows == 0){
	echo "The GUID \"" . $_GET['guid'] . "\" is unrecognised. Please contact the administrator for a new one.";
} else {
	echo "Username: " . $row['username'];
	$userID = $row['user_id'];
	setcookie("user_id", $userID, time()+3600);
}
?>
<div class="sectionTitle">Games in Progress</div>
<table>
<?php
$query = "SELECT f.* FROM faction f JOIN game g ON f.game_id=g.game_id WHERE f.user_id=" . $userID;
$mysqli->real_query($query);
$res = $mysqli->use_result();
while ($row = $res->fetch_assoc()) {
    echo "<tr>";
	echo "<td>" . $row['name'] . "</td>";
	echo "<td onclick=\"enterGame(" . $row['faction_id'] .  ")\">" . $row['game_id'] . "</td>";
	echo "</tr>";
}
?>

<?php
if (isset($_COOKIE["user_id"]))
  echo "Welcome " . $_COOKIE["user_id"] . "!<br>";
else
  echo "Welcome guest!<br>";
?>
</table>
</body>
</html>

