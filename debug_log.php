<?php
// Error Debugger
ini_set('display_errors', 1);
error_reporting(E_ALL);

file_put_contents('logs/debug.log', 
    date('Y-m-d H:i:s')." - ".print_r($_REQUEST, true), 
    FILE_APPEND
);
?>
