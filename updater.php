<?php
function updateData($parentNode){
    global $mysqli;
    global $userID;
    global $commandID;

    $groupNode = $parentNode->addChild("update");
    $groupNode->addAttribute('user_command_id', $commandID);

    $query = "SELECT NOW() as time_now, 
    g.last_updated as last_updated,
    TIME_TO_SEC(TIMEDIFF(NOW(), g.last_updated)) as seconds_elapsed,
    f.faction_id,
    g.game_id
    FROM game g
    JOIN faction f ON f.game_id=g.game_id
    JOIN command c ON c.faction_id=f.faction_id
    WHERE c.command_id=" . $commandID;
    $res = $mysqli->query($query);

    $row = $res->fetch_assoc();
    $groupNode->addAttribute('time_now', $row['time_now']);
    $groupNode->addAttribute('last_updated', $row['last_updated']);
    $groupNode->addAttribute('seconds_elapsed', $row['seconds_elapsed']);
    $groupNode->addAttribute('user_faction_id', $row['faction_id']);
    $groupNode->addAttribute('game_id', $row['game_id']);

    if($row['seconds_elapsed'] > 0){
        $query = "UPDATE game SET last_updated = '" . $row['time_now'] . "' WHERE game_id=10";
        $mysqli->query($query);
        $groupNode->addAttribute('changed_last_updated', 1);
    }
    
}
?>