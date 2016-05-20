<?php
Header('Content-type: text/xml');
ini_set("display_errors", 1); 
require_once ('my_sqli_connect.php');

$string = <<<XML
<?xml version='1.0'?> 
<turn test="1">
<history />
</turn>
XML;

$getxml = trim(file_get_contents("php://input")); // get raw post data + trim out the spaces
$xmlReceived = new SimpleXMLElement($getxml);

$result = "Do nothing";
foreach ($xmlReceived->xpath('//action') as $action) {
$result = "Found Action";
switch ($action["type"]) {
case "rel_set":
$result = "Calling Function";
relationshipSet($action);
//$result = "Function called";
//testThis($action);
break;
}
}
$xml = new SimpleXMLElement($string);
$xml->addAttribute("result", $result);
echo $xml->asXML();

function testThis($action){

$result = "here";
}

function relationshipSet($action){
         global $result, $mysqli;

         $query = "SELECT relation FROM faction_relationship " . " WHERE faction_id ="  . $action["faction_id"] . " AND other_faction_id=" . $action["other_faction_id"];
         $res = $mysqli->query($query);
         $row = $res->fetch_assoc();
         if($res->num_rows == 0){
         $query = "INSERT INTO faction_relationship (faction_id, other_faction_id, relation) VALUES("  . $action["faction_id"] . ", " . $action["other_faction_id"] . " , " . $action["rel"] . ")";
         } else {
         $query = "UPDATE faction_relationship SET relation = " . $action["rel"] . " WHERE faction_id ="  . $action["faction_id"] . " AND other_faction_id=" . $action["other_faction_id"];
         }

         $result = "QUERY:" . $query;
         $res = $mysqli->query($query);
         //$result = "Set relationship from " . $action["faction_id"] . " to " . $action["other_faction_id"] . " to " . $action["rel"];
}
?>