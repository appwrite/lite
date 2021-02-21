<?php

require_once '/usr/src/code/vendor/autoload.php';

$url = getenv('JAWSDB_MARIA_URL');
$dbparts = parse_url($url);

$hostname = $dbparts['host'];
$username = $dbparts['user'];
$password = $dbparts['pass'];
$database = ltrim($dbparts['path'], '/');

try {
    $conn = new PDO("mysql:host=$hostname;dbname=$database", $username, $password);
    // set the PDO error mode to exception
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "Connected successfully";
    $commands = file_get_contents("/appwrite.sql");
    $qr = $conn->exec($commands);
} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
}
