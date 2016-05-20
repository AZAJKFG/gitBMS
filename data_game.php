<?php 
Header('Content-type: text/xml');
require_once ('my_sql_connect.php');
require_once ('my_sqli_connect.php');
require_once ('login.php');
require_once ('updater.php');

$string = <<<XML
<?xml version='1.0' ?>
<game>
</game>
XML;

$xmlRules = new SimpleXMLElement($string);

updateData($xmlRules);
outputTable($xmlRules, "command");
outputTable($xmlRules, "game");
outputTable($xmlRules, "asset");
outputTable($xmlRules, "faction");
outputTable($xmlRules, "faction_relationship");
outputTable($xmlRules, "op");
outputTable($xmlRules, "z_a");
outputTable($xmlRules, "zone");
outputTable($xmlRules, "zone_property");

echo $xmlRules->asXML();

function outputTable($parentNode, $tablename){
         global $userID;
         global $commandID;

         $groupNode = $parentNode->addChild($tablename . "s");
         //$parentNode->addAttribute('userID', $userID);
         //$groupNode->addAttribute('test', 'start');

         //execute the SQL query and return records

         switch ($tablename) {
         case "asset":
              $query = "SELECT a.*
              FROM asset a
              JOIN faction f ON a.faction_id=f.faction_id
              JOIN command c ON f.faction_id=c.faction_id
              WHERE c.command_id=" . $commandID . "
              ";
              break;
         case "command":
              $query = "SELECT c.*,
              CASE WHEN u.user_id=" . $userID . " THEN 1 ELSE NULL END as is_user
              FROM command c
              LEFT JOIN user u ON c.user_id=u.user_id
              ";
              break;
         case "faction":
              $query = "SELECT f.*,
              fi.src as icon,
              u.username as username,
              ft.name as faction_type,
              CASE WHEN u.user_id=" . $userID . " THEN 1 ELSE NULL END as is_user
              FROM faction f
              JOIN faction_icon fi ON f.faction_icon_id=fi.faction_icon_id
              LEFT JOIN user u ON f.user_id=u.user_id
              LEFT JOIN faction_type ft ON f.faction_type_id=ft.faction_type_id
              ";
              break;

         default:
           $query = "SELECT * FROM ".$tablename;
           break;
         }

         $result = mysql_query($query);
         if (!$result) {
            die('Invalid query: ' . mysql_error());
         }
         //echo "Ran query ".$query."<br>";
             
         if(mysql_num_rows($result)>0){
            //echo(mysql_num_rows($result)." rows<br>");
            while($result_array = mysql_fetch_assoc($result)){
               $currNode = $groupNode->addChild($tablename);

               //loop through each key,value pair in row
               foreach($result_array as $key => $value)
               {
                 if($value != null){
                      //$key holds the table column name
                      $currNode->addAttribute($key, $value);
                  }
               }
            }
         } else {
             //$groupNode->addAttribute('test', 'end');
         }
}
?>