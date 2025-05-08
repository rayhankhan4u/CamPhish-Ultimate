<?php
// GPS Location Tracker
header('Content-Type: application/json');

$data = json_decode(file_get_contents('php://input'), true);
$log = [
    'timestamp' => date('Y-m-d H:i:s'),
    'latitude' => $data['lat'] ?? null,
    'longitude' => $data['lon'] ?? null,
    'accuracy' => $data['acc'] ?? null
];

file_put_contents('logs/locations.log', json_encode($log).PHP_EOL, FILE_APPEND);
echo json_encode(['status' => 'success']);
?>
