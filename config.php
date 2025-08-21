<?php


$co = mysqli_connect("localhost", "root", "root", "inv");

if (!$co) {
    
    error_log("Database connection failed: " . mysqli_connect_error());  
    die("Unable to connect to the database. Please try again later.");  
}

?>
