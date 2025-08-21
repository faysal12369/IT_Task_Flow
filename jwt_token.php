<?php
require 'vendor/autoload.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

$secret_key = "F@ysal25";
$payload = [
    "iss" => "localhost",
    "aud" => "localhost",
    "iat" => time(),       
    "exp" => time() + 3600,
    "user_id" => 123
];

$jwt = JWT::encode($payload, $secret_key, 'HS256');

echo "Generated JWT: " . $jwt;
?>
