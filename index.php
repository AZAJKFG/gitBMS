<?php 
$guid = $_GET['guid'];
if($guid != ''){
    setcookie("guid", $guid, time()+86400 * 7);
}

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<script language="javascript">
    function enterGame(commandID){
        document.location.href="game.php?command_id=" + commandID;
    }
</script>
<style>
    .box {
        color:white;
        background:#444444;
        font-family:Tahoma;
    }
    .gameLink {
        cursor:pointer;
        border:2px solid gray;
        padding:8px;
        width:300px;
    }
</style>
</head>
<body>
<div style="background:#222222;width:960px;height:640px;">

<div class="box" style="position:absolute;top:180px;left:100px;width:300px;">
<?php
require_once ('my_sqli_connect.php');
require_once ('login.php');
?>
Welcome
<?php
echo($userName);
?>
</div>

<div class="box" style="position:absolute;top:180px;left:500px;width:400px;">
<div class="sectionTitle">Games in Progress</div>
<?php
if($userID == 1) {
    ?>
    <div class="gameLink"><a href="data_structure.php" target="_blank" style="text-decoration:none;color:white;">Reset all system data</a></div>
    <?php
}
?>
<?php
$query = "SELECT f.*,
g.name as game_name,
c.command_id,
c.name as command_name
FROM faction f 
JOIN game g ON f.game_id=g.game_id 
JOIN command c ON f.faction_id=c.faction_id
WHERE c.user_id=" . $userID;

$res = $mysqli->query($query);
$row_cnt = $res->num_rows;

if($res->num_rows == 0){
    echo "None";
} else {
    while ($row = $res->fetch_assoc()) {
        echo "<div class=\"gameLink\" onclick=\"enterGame(" . $row['command_id'] .  ")\">" . $row['name'] . " in " . $row['game_name'] . "(" . $row['command_name'] .")</div>";
    }
}
?>
</div>

</body>
</html>

