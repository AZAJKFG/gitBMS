<?php 
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