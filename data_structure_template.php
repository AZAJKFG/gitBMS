<?php 
require_once ('my_sql_connect.php');
echo "Starting<br>";

#INSERTSQLHERE#



function runQuery($strSql){
	if (mysql_query($strSql)) {echo "Ran query" . $strSql . "<br>";}
	else {echo "Error running query: " . mysql_error() . "<br>";}
}
?>