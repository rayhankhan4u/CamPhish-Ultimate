<?php
// Advanced IP Logger with Geolocation
header('Content-Type: text/plain');

$ip = $_SERVER['REMOTE_ADDR'];
$data = [
    'timestamp' => date('Y-m-d H:i:s'),
    'ip' => $ip,
    'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'N/A',
    'geolocation' => json_decode(file_get_contents("http://ip-api.com/json/$ip"))
];

file_put_contents('logs/ips.log', json_encode($data).PHP_EOL, FILE_APPEND);
echo "OK";
?>
