<?php 
Header('Content-type: text/xml');
require_once ('my_sql_connect.php');

$string = <<<XML
<?xml version='1.0'?> 
<rules>
</rules>
XML;

$xmlRules = new SimpleXMLElement($string);
outputTable($xmlRules, "asset_class");
outputTable($xmlRules, "asset_type");
outputTable($xmlRules, "faction_type");
outputTable($xmlRules, "map");
outputTable($xmlRules, "op_class");
outputTable($xmlRules, "op_req");
outputTable($xmlRules, "op_type");
outputTable($xmlRules, "opt_at_type");
outputTable($xmlRules, "opt_opt");
outputTable($xmlRules, "opt_opt_type");
outputTable($xmlRules, "opt_zpt");
outputTable($xmlRules, "zone_property_type");
outputTable($xmlRules, "zone_type");

echo $xmlRules->asXML();

function outputTable($parentNode, $tablename){
$groupNode = $parentNode->addChild($tablename . "s");
//$groupNode->addAttribute('test', 'start');

//execute the SQL query and return records
$query = "SELECT * FROM ".$tablename;
$result = mysql_query($query);
if (!$result) {
die('Invalid query: ' . mysql_error());
}
//echo "Ran query ".$query."<br>";
	
	if(mysql_num_rows($result)>0)
	{
	   //echo(mysql_num_rows($result)." rows<br>");
	   while($result_array = mysql_fetch_assoc($result))
	   {
		  $currNode = $groupNode->addChild($tablename);

		  //loop through each key,value pair in row
		  foreach($result_array as $key => $value)
		  {
			 //$key holds the table column name
			 $currNode->addAttribute($key, $value);
		  }
	   }
	} else {
		//$groupNode->addAttribute('test', 'end');
	}
}
?>