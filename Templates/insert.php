<?php
include("db_connect.php");

$#PARAMATER#=$conn->escape_string($_GET["#PARAMATER#"]);


$sql_insert = "#SQL_INSERT#";

$sql_update = "#SQL_UPDATE#";


if ($#PK# == 0){
    f_update($sql_insert, $conn);
}else{
    f_update($sql_update, $conn);
}

?> 
