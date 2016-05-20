<?php
Header('Content-type: text/xml');
ini_set("display_errors", 1); 
require_once ('my_sqli_connect.php');

$string = <<<XML
<?xml version='1.0'?> 
<results>
</results>
XML;

$xmlRules = new SimpleXMLElement($string);
updateData($xmlRules);

echo $xmlRules->asXML();

function updateData($parentNode){
	global $mysqli;
	$groupNode = $parentNode->addChild("update");

	$query = "SELECT NOW() as time_now";
	$res = $mysqli->query($query);
	$row = $res->fetch_assoc();

	$groupNode->addAttribute('test', 1);
	$groupNode->addAttribute('now', $row['time_now']);

	$result = "QUERY:" . $query;
	$res = $mysqli->query($query);
}
?>