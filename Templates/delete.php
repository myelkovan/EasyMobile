<?php

include("db_connect.php");

$#PARAMATER#=$conn->escape_string($_GET["#PARAMATER#"]);

$sql = "#SQL#";  
 
f_delete($sql, $conn)

?>
