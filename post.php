<?php
// Data Submission Handler
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = file_get_contents('php://input');
    file_put_contents('logs/submissions.log', $data.PHP_EOL, FILE_APPEND);
    echo "Data received";
}
?>
