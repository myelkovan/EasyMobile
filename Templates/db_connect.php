<?php
 

$conn = new mysqli(null,'u913328660_school','School123.!','u913328660_school',3306);
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}
 


function f_select($arg_sql,$conn)
{

	if ($result = $conn -> query($arg_sql)) {
		$resultArray = array();
	
		// Loop through each row in the result set
		while($row = $result->fetch_object())
		{
	 	   array_push($resultArray, $row);
		}
 
		echo json_encode($resultArray);
	}
	$conn -> close();
}



function f_delete($arg_sql,$conn)
{
    if ($conn->query($sql) === TRUE) {
        echo "OK";
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
    
    $conn -> close();
}


function f_update($arg_sql,$conn)
{
    if ($conn->query($sql) === TRUE) {
        echo "OK";
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
    
    $conn -> close();
}



function f_update1($arg_sql_update, arg_sql_insert, $conn)
{
	if ($conn->query($arg_sql_update) === TRUE) {

		$prototype=$conn->info;
		list($matched, $changed, $warnings) = sscanf($prototype, "Rows matched: %d Changed: %d Warnings: %d");

        if ($matched == 0) {
            if ($conn->query(arg_sql_insert) === TRUE) {
                echo "OK";
            }
            else {
                echo "Error: " . $sql . "<br>" . $conn->error;
            }
        }
        else{
            echo "OK";   // update edildi
        }
	}else{
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
	$conn -> close();
}

?>
